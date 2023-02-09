Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C38A690013
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 06:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjBIFzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 00:55:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjBIFzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 00:55:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2251A3D081
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 21:55:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4827B81FF4
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 05:54:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506E0C4339B;
        Thu,  9 Feb 2023 05:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675922093;
        bh=LD16MfD3e7zcYDITNZihB0XUI4C2ENygiZ7yedHR2YA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ibs5ZbQYi2WG4+jTIKZjarPA8ClXxcG5WBkMPNRGy0eWt7iHgoSs7yFUzrV0SN1QQ
         vHAkCZSFZSy5bJIDS1OSmlaijkSIn6eBR9xxMk1oT3opW5fAmQPfUrrZoK4z9TKMM1
         5+pGXA+HVvBWHvOgjVODdPvTdvLWRPKzYyYcluW20dUKysdyKxdIs9IQLwWpe5htcK
         df9O1Ajs5TxP7aC59bLYZX/3X9sOsT1K7Wa/x5ppKYPZKGbMv5wh/IrAWkRp96LQYt
         ONFIBkRRtttaycGWo0N9wOABj3pu6uuF3ZfTq70G8XptnuHxBcVpqj5DqU2bAbzQ6A
         7pjGixrZIQoJQ==
Date:   Wed, 8 Feb 2023 21:54:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Praveen Kaligineedi <pkaligineedi@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Jeroen de Borst <jeroendb@google.com>
Subject: Re: [PATCH net-next 2/4] gve: Add XDP DROP and TX support for
 GQI-QPL format
Message-ID: <20230208215452.67225287@kernel.org>
In-Reply-To: <20230207210058.2257219-3-pkaligineedi@google.com>
References: <20230207210058.2257219-1-pkaligineedi@google.com>
        <20230207210058.2257219-3-pkaligineedi@google.com>
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

On Tue,  7 Feb 2023 13:00:56 -0800 Praveen Kaligineedi wrote:
> +		// Adding/removing a program, need to recreate the queues.
> +		if (!netif_carrier_ok(priv->dev)) {
> +			rcu_assign_pointer(priv->xdp_prog, prog);
> +			goto out;
> +		}
> +		err = gve_close(priv->dev);
> +		if (err)
> +			return err;
> +
> +		rcu_assign_pointer(priv->xdp_prog, prog);
> +		gve_open(priv->dev);

And if open() fails e.g. due to transient memory pressure the machine
drops off the network and success gets returned to user space?
We have been asking driver developers for a while now to allocate
resources first, then try the reconfig.
