Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACA776BC36F
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 02:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjCPBmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 21:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjCPBmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 21:42:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52769ABB21
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 18:42:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83D9061EA1
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 01:41:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8444DC433D2;
        Thu, 16 Mar 2023 01:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678930906;
        bh=CKrnVcR/DlNKxWZYOJWg58b854tP4teX2PPXpqu1Zgg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DZ0n+Npen2ATV5+BoiHyGmET5X/OjutPQPiRrknJ3Q/wEVJTlosmEOFKUoakKRvz1
         f5gKy1+tV7DeemweINkM4xk1wBWGylfuN/cUuGtJEW9nwXUIxYbK/GEIDQYOXGSs/B
         SBEt6ZMBWl3wFf7Gi2v7sJnr1xQ+ntb2BJ6fjWMSzRBUSKDiAZfWbU0xgRNg0HZ2Q+
         QGkbMIWxyieeELEbaqgKI0E0nsySlIdgYHVr/6nY9bjIIItW1ItOFSHUM5i/9lckDc
         P0/W3qSqjRrmskWH/sgX5+F3p1m/g8ehZl+mSHoH6FhGseaKutzBHqtUFFo6MU6zF0
         mTWmPYGmBqsPw==
Date:   Wed, 15 Mar 2023 18:41:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, borisp@nvidia.com, john.fastabend@gmail.com,
        maximmi@nvidia.com, tariqt@nvidia.com, vfedorenko@novek.ru,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net-next v3 7/7] tls: rx: do not use the standard
 strparser
Message-ID: <20230315184145.7c25bd99@kernel.org>
In-Reply-To: <54cdcc22-821a-b0fc-2eb6-b88c47049188@gmail.com>
References: <20220722235033.2594446-1-kuba@kernel.org>
        <20220722235033.2594446-8-kuba@kernel.org>
        <3c9eaf1b-b9eb-ed06-076a-de9a36d0993f@gmail.com>
        <20230309095436.17b01898@kernel.org>
        <89086da6-b559-f6c0-d73a-6c73ff74dff5@gmail.com>
        <20230313112210.71905e2d@kernel.org>
        <54cdcc22-821a-b0fc-2eb6-b88c47049188@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Mar 2023 22:26:55 +0200 Tariq Toukan wrote:
> +       printk("skb: %p, len = %d, nfrags = %d\n", darg->skb, 
> darg->skb->len, skb_shinfo(darg->skb)->nr_frags);
> +       for (i = 0; i < skb_shinfo(darg->skb)->nr_frags; i++)
> +               printk("frag#%d: %p, len %d\n", i, 

Not enough info, I tried my best to get the CX6 DX I have to work, 
but mlx5_crypto_create_dek_key() returns -EINVAL fw 22.32.1206
IDK what the story is but it's quite frustrating to try to help
the offload vendors (NXP before you) and not be able to repro even 
when in theory one has the right HW :|

What do I need to do get a CX6 DX which reports

# ethtool -k eth0 | grep tls
tls-hw-tx-offload: on
tls-hw-rx-offload: on

to actually offload TLS 1.2?
