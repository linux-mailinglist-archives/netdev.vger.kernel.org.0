Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE9654DB834
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 19:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350989AbiCPSwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 14:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347143AbiCPSwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 14:52:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5496BDE0;
        Wed, 16 Mar 2022 11:51:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEA28B81B08;
        Wed, 16 Mar 2022 18:51:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4B2C340E9;
        Wed, 16 Mar 2022 18:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647456666;
        bh=t/dEU7GfFjVk7rRpLv75Jtugk4JYnyGtAFqLVnnU2fY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LX7rqIFifYEgXT/9yXum24TDsJzncU9A8UypErNe1Y2DuX4LPPDE5ly0lYvYBwvup
         W5Nq0xNeQIqf6uawfe4YTS2dfU+mYez7ha8iQgzvKMfofv0sKoMKjoOx+3vG+fqFNE
         MRD9VQ7TCdTUF7H44KjxWoTZ31GUrtMvFF2cBaDh0yniioO1Q9K0scshAGfbklTQfh
         3ONNq+KUZ7ojzpzv/nsonS963ziSb+xDJjGnp9T30MU18XFv79ovMV+4kfZLvpO4Nx
         1Ihfhw9n2TM8oQF8A1V0gEB3vKHmmRbWlhR6bbqEagJqUZUfStOyZTKMkJJfdtZ26p
         8RDyvd2cVgocQ==
Date:   Wed, 16 Mar 2022 11:51:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, xeb@mail.ru,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>, Martin Lau <kafai@fb.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Hao Peng <flyingpeng@tencent.com>,
        Mengen Sun <mengensun@tencent.com>, dongli.zhang@oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Biao Jiang <benbjiang@tencent.com>
Subject: Re: [PATCH net-next 3/3] net: ipgre: add skb drop reasons to
 gre_rcv()
Message-ID: <20220316115104.25ad2605@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CADxym3Yj58gXe9kHRxNvxxMfNMYjvzbrdcq7sNAo6SQHXb98nQ@mail.gmail.com>
References: <20220314133312.336653-1-imagedong@tencent.com>
        <20220314133312.336653-4-imagedong@tencent.com>
        <20220315201706.464d5ecd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CADxym3Yj58gXe9kHRxNvxxMfNMYjvzbrdcq7sNAo6SQHXb98nQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Mar 2022 14:21:24 +0800 Menglong Dong wrote:
> > ipgre_rcv() OTOH may be better off taking the reason as an output
> > argument. Assuming PACKET_REJECT means NOMEM is a little fragile.  
> 
> Yeah, it seems not friendly. I think it's ok to ignore such 'NOMEM' reasons?
> Therefore, we only need to consider the PACKET_NEXT return value, and
> keep ipgre_rcv() still.

SGTM.
