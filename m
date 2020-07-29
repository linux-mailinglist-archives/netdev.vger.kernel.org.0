Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D436D2316D7
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 02:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730880AbgG2Agd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 20:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730507AbgG2Agc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 20:36:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB12C061794;
        Tue, 28 Jul 2020 17:36:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CAF50128D3F8B;
        Tue, 28 Jul 2020 17:19:44 -0700 (PDT)
Date:   Tue, 28 Jul 2020 17:36:29 -0700 (PDT)
Message-Id: <20200728.173629.741539582090080322.davem@davemloft.net>
To:     bkkarthik@pesu.pes.edu
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH v2] net: ipv6: fix use-after-free Read in
 __xfrm6_tunnel_spi_lookup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200726030855.q6dfjekazfzl5usw@pesu.pes.edu>
References: <20200726030855.q6dfjekazfzl5usw@pesu.pes.edu>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Jul 2020 17:19:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: B K Karthik <bkkarthik@pesu.pes.edu>
Date: Sun, 26 Jul 2020 08:38:55 +0530

> @@ -103,10 +103,10 @@ static int __xfrm6_tunnel_spi_check(struct net *net, u32 spi)
>  {
>  	struct xfrm6_tunnel_net *xfrm6_tn = xfrm6_tunnel_pernet(net);
>  	struct xfrm6_tunnel_spi *x6spi;
> -	int index = xfrm6_tunnel_spi_hash_byspi(spi);
> +	int index = xfrm6_tunnel_spi_hash_byaddr((const xfrm_address_t *)spi);

We can cast this a thousand times to make the compiler quiet, but the
fact is that this function does not expect an integer SPI as an
argument.

It expects a protocol address.

Please stop forcing this fix, I fear you don't understand how this code
works.  Come back to us when you do.

Thank you.
