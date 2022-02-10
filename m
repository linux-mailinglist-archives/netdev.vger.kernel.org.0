Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 450124B0256
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 02:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbiBJBbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 20:31:02 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:37438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232563AbiBJBbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 20:31:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0712F22527;
        Wed,  9 Feb 2022 17:31:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AD8F616B2;
        Thu, 10 Feb 2022 01:06:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCEB8C340E7;
        Thu, 10 Feb 2022 01:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644455172;
        bh=OBeVERzluy4DArHFC4mn3YZzQAgsdo26IY1UOV+S3po=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=neW6q5TJZCtjBdRjuhBPe+fIQsoITAs+gqkje+/Oguku7udHSpMNRMzCKSdgscQn6
         7FmDKj+IO9dmg0svmZqafQNZ6HuHSeVuosT1ezyk+J5yEQbEWfb9JtxwbLHkUTBMBW
         XktUDiEeL0sGM5Z+elyaa3276MG8A10Qk7Gb0/Or0qEMecOdvGmIpIyLuqbgvC0Cam
         +PDuhw3lYYM8bFxNLSOWHdJOT/Tds/blKfKqAhEBhzcKvSyWiuwEvbHRoMElsQZ3z8
         dnc6ltsVSwxCXn54z+6MxGujQXS6V4VyuZrRYWRuT52gneoQF8PV+TtD+ciQPvODcG
         WsCeJxOtKjYaQ==
Date:   Wed, 9 Feb 2022 17:06:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "lina.wang" <lina.wang@mediatek.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <maze@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        "Kernel hackers" <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, "Martin KaFai Lau" <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Willem Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>, <zhuoliang@mediatek.com>,
        <chao.song@mediatek.com>
Subject: Re: [PATCH] net: fix wrong network header length
Message-ID: <20220209170610.10694339@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <5ca86c46109794a627e6e2a62b140963217984a0.camel@mediatek.com>
References: <20220208025511.1019-1-lina.wang@mediatek.com>
        <0300acca47b10384e6181516f32caddda043f3e4.camel@redhat.com>
        <CANP3RGe8ko=18F2cr0_hVMKw99nhTyOCf4Rd_=SMiwBtQ7AmrQ@mail.gmail.com>
        <a62abfeb0c06bf8be7f4fa271e2bcdef9d86c550.camel@redhat.com>
        <5ca86c46109794a627e6e2a62b140963217984a0.camel@mediatek.com>
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

On Wed, 9 Feb 2022 18:25:07 +0800 lina.wang wrote:
> We use NETIF_F_GRO_FRAGLIST not for forwarding scenary, just for
> software udp gro. Whatever NETIF_F_GRO_FRAGLIST or NETIF_F_GRO_FWD,
> skb_segment_list should not have bugs.
> 
> We modify skb_segment_list, not in epbf. One point is traversing the
> segments costly, another is what @Maciej said, *other* helper may have
> the same problem. In skb_segment_list, it calls
> skb_headers_offset_update to update different headroom, which implys
> header maybe different.

Process notes:
 - the patch didn't apply so even if the discussion concludes that 
   the patch was good you'll need to rebase on netdev/net and repost;
 - please don't top post.
