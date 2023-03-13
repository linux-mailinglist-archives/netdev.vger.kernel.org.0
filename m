Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0A5C6B8057
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 19:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbjCMSX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 14:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbjCMSXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 14:23:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A38EC7D09F
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 11:22:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99A0AB811D3
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 18:22:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDED8C433EF;
        Mon, 13 Mar 2023 18:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678731732;
        bh=0Z7THOy/HG0H6WdiTuHOS1S8TlwF+IiwSj0oW8QU3Dc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r+UB1RKIMgBSxemUyxc9tiNTGNp1JXhSlVEB24u19fOFF6+arG6CfwiKkqEAh81hO
         BOlOzPVOp+npTz+CfKseBKwESJdjoaJH19kZxSCBguErLljwJMKvQToLWQDv3nCO8K
         WmRuchGzEPVz/ap1cPNH1F6H+efOqF2DFgSEwBMkdFAc9rsBnB18AFlO6B1cRO+27X
         8DAbxXdD0qU3OZIvZtSrEwYtq2VrVfkon03/tCElXefgDSKlY6JqPCLghsO92AqsiR
         d6U5g+kqgtl2UfEATcmEnP5TWFtZJrL2evWae4YpXCYtctxgEiiKg20u4QGc9aRGHH
         bgtJb9yejRThw==
Date:   Mon, 13 Mar 2023 11:22:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, borisp@nvidia.com, john.fastabend@gmail.com,
        maximmi@nvidia.com, tariqt@nvidia.com, vfedorenko@novek.ru,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net-next v3 7/7] tls: rx: do not use the standard
 strparser
Message-ID: <20230313112210.71905e2d@kernel.org>
In-Reply-To: <89086da6-b559-f6c0-d73a-6c73ff74dff5@gmail.com>
References: <20220722235033.2594446-1-kuba@kernel.org>
        <20220722235033.2594446-8-kuba@kernel.org>
        <3c9eaf1b-b9eb-ed06-076a-de9a36d0993f@gmail.com>
        <20230309095436.17b01898@kernel.org>
        <89086da6-b559-f6c0-d73a-6c73ff74dff5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NORMAL_HTTP_TO_IP,
        NUMERIC_HTTP_ADDR,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,WEIRD_PORT
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 Mar 2023 19:59:57 +0200 Tariq Toukan wrote:
> On 09/03/2023 19:54, Jakub Kicinski wrote:
> > On Thu, 9 Mar 2023 17:15:26 +0200 Tariq Toukan wrote:  
> >> A few fixes were introduced for this patch, but it seems to still cause
> >> issues.
> >>
> >> I'm running simple client/server test with wrk and nginx and TLS RX
> >> device offload on.
> >> It fails with TlsDecryptError on the client side for the large file
> >> (256000b), while succeeding for the small one (10000b). See repro
> >> details below.
> >>
> >> I narrowed the issue down to this offending patch, by applying a few
> >> reverts (had to solve trivial conflicts):  
> > 
> > What's the sequence of records in terms of being offloaded vs fall back?
> > Could you whip up a simple ring buffer to see if previous records were
> > offloaded and what the skb geometries where?  
> 
> Interesting. All records go through the sw fallback.
> 
> Command:
> $ wrk_openssl_3_0_0 -b2.2.2.2 -t1 -c1 -d2 --timeout 5s 
> https://2.2.2.3:20443/256000b.img

Is wrk_openssl_3_0_0 a nginx command? Any CX6 DX card can do this?

> Debug code:
> @@ -1712,8 +1723,13 @@ static int tls_rx_one_record(struct sock *sk, 
> struct msghdr *msg,
>          int err;
> 
>          err = tls_decrypt_device(sk, msg, tls_ctx, darg);
> -       if (!err)
> +       if (!err) {
>                  err = tls_decrypt_sw(sk, tls_ctx, msg, darg);
> +               printk("sk: %p, tls_decrypt_sw, err = %d\n", sk, err);
> +       } else {
> +               printk("sk: %p, tls_decrypt_device, err = %d\n", sk, err);
> +       }
> +       skb_dump(KERN_ERR, darg->skb, false);
>          if (err < 0)
>                  return err;
> 
> dmesg output including skb geometries is attached.

Hm, could you add to the debug the addresses of the fragments 
(and decrypted status) of the data queued to TCP by the driver?
And then the frag addresses in skb_dump() ?

tls_decrypt_sw() will also get used in partially decrypted records, 
right?
