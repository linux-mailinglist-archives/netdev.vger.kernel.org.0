Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9475A51E3A0
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 04:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244897AbiEGClZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 22:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241394AbiEGClX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 22:41:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F016B0A1
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 19:37:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 944F1B8394C
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 02:37:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD802C385A6;
        Sat,  7 May 2022 02:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651891056;
        bh=eLcAWgFRkYu6lsHqWqXlAcu6qFVqorfa56VexC2ZU2A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Rq2wnT/+bf+OzE8q64zeALoy8E5fsGaEg3VKl+39suM18b3uXU/sskQZrRfDRDhNY
         JKd6aUXD14lK2ZN/UVBsPWAsQ4QocxINyETPZJT2chqTVRPOZwZmBAQVm6JUWPzJr9
         grwnZ2eYw1ssix9VjeoYMtX1z2TFMkGmvZ8/u/q+ymYN66XbmscP0acHODpaXWilVW
         9TTw56t1xney0MIm51T6h3imcDJS6TBp8PLwRUtEUImNXZ9HqoHUeimgbJguznmpXt
         m6M0E7mHBZUafUI3le1Itb4RuA+e3IcI+dFGELuHMolkHH++3dHUHnqhcMNtJc3FaI
         P+xzeX33ptQUg==
Date:   Fri, 6 May 2022 19:37:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v4 net-next 12/12] mlx5: support BIG TCP packets
Message-ID: <20220506193734.408c2a0d@kernel.org>
In-Reply-To: <CANn89iKQtn0a-Etk-tBrwafbe6dkBz=d3=bkwd8j8_Ed+kiCPQ@mail.gmail.com>
References: <20220506153048.3695721-1-eric.dumazet@gmail.com>
        <20220506153048.3695721-13-eric.dumazet@gmail.com>
        <20220506153414.72f26ee3@kernel.org>
        <CANn89iJDP1aSwsCyVVq_qjVY8OZjg-vWULR=GN-WQV6FpLz+Mg@mail.gmail.com>
        <20220506185405.527a79d4@kernel.org>
        <CANn89iKQtn0a-Etk-tBrwafbe6dkBz=d3=bkwd8j8_Ed+kiCPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 May 2022 19:10:48 -0700 Eric Dumazet wrote:
> On Fri, May 6, 2022 at 6:54 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > Without our patches drivers/net/ethernet/mellanox/mlx5/core/ builds
> > cleanly. Gotta be the new W=1 filed overflow warnings, let's bother
> > Kees.  
> 
> Note that inline_hdr.start is a 2 byte array.
> 
> Obviously mlx5 driver copies more than 2 bytes of inlined headers.
> 
> mlx5e_insert_vlan(eseg->inline_hdr.start, skb, attr->ihs)
> is called already with attr->ihs > 2
> 
> So it should already complain ?

It's a static checker, I presume it ignores attr->ihs because 
it can't prove its value is indeed > 2. Unpleasant :/

> static inline void mlx5e_insert_vlan(void *start, struct sk_buff *skb, u16 ihs)
> {
>    struct vlan_ethhdr *vhdr = (struct vlan_ethhdr *)start;
>    int cpy1_sz = 2 * ETH_ALEN;
>    int cpy2_sz = ihs - cpy1_sz;
> 
>     memcpy(&vhdr->addrs, skb->data, cpy1_sz);
>     vhdr->h_vlan_proto = skb->vlan_proto;
>     vhdr->h_vlan_TCI = cpu_to_be16(skb_vlan_tag_get(skb));
>     memcpy(&vhdr->h_vlan_encapsulated_proto, skb->data + cpy1_sz,
> cpy2_sz);  // Here, more than 2 bytes are copied already
> }

