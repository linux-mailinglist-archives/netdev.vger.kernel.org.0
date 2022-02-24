Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 155204C3338
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 18:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbiBXRJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 12:09:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiBXRJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 12:09:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676A017582E;
        Thu, 24 Feb 2022 09:08:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0473461A94;
        Thu, 24 Feb 2022 17:08:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0580FC340EC;
        Thu, 24 Feb 2022 17:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645722517;
        bh=aFqQ6+V1wY3k12+W5FPWC2KQtgr102npBDs1j4mV2s4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G3s8XvBs/7DoZAOA9Zn2NeMlBeV+da45TFWRffLQEaKPBpF2QgW8WiN9zjFw72EWO
         c/r1+19w6VNj1r2JQIqL+d6ljs9VAIPTe8OgT9IbE0NjA7kum8pCHSE018p/ayjfaJ
         HsFV7FJwsN5rs+StK/a5uQ5iWzBQTF+OofyOhtZcEB630/cELnJYvPdA51Y+03YaOY
         abc03s1dfBDZd0BE/SpZU6aYmRDXl4x3cS5UH+bqd2pooXFMkzxtdIymZKa3am3XZB
         nE/J8uNMNMRNnFhbX4JpkecDL3uzj9Jn/ZBqz9iWnyVcvxxuBzC4U15tdNzxguofTF
         DJXKJKzBbxkog==
Date:   Thu, 24 Feb 2022 09:08:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "lena.wang" <lena.wang@mediatek.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     <davem@davemloft.net>, <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wsd_upstream@mediatek.com>, <hao.lin@mediatek.com>
Subject: Re: [PATCH] net:fix up skbs delta_truesize in UDP GRO frag_list
Message-ID: <20220224090835.147010b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <647050777c64ce48788602d61280e8923477b331.camel@mediatek.com>
References: <647050777c64ce48788602d61280e8923477b331.camel@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Feb 2022 18:08:47 +0800 lena.wang wrote:
> The truesize for a UDP GRO packet is added by main skb and skbs in main
> skb's frag_list:
> skb_gro_receive_list
>         p->truesize += skb->truesize;
> 
> When uncloning skb, it will call pskb_expand_head and trusesize for
> frag_list skbs may increase. This can occur when allocators uses
> __netdev_alloc_skb and not jump into __alloc_skb. This flow does not
> use ksize(len) to calculate truesize while pskb_expand_head uses.
> skb_segment_list
> err = skb_unclone(nskb, GFP_ATOMIC);
> pskb_expand_head
>         if (!skb->sk || skb->destructor == sock_edemux)
>                 skb->truesize += size - osize;
> 
> If we uses increased truesize adding as delta_truesize, it will be
> larger than before and even larger than previous total truesize value
> if skbs in frag_list are abundant. The main skb truesize will become
> smaller and even a minus value or a huge value for an unsigned int
> parameter. Then the following memory check will drop this abnormal skb.
> 
> To avoid this error we should use the original truesize to segment the
> main skb.
> 
> Signed-off-by: lena wang <lena.wang@mediatek.com>

CC: Eric


