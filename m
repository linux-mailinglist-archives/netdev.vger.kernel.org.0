Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C39DE687551
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 06:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjBBFpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 00:45:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjBBFpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 00:45:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353D5301B2
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 21:45:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBDEA615E9
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 05:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0485C433EF;
        Thu,  2 Feb 2023 05:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675316707;
        bh=WfQt6EAuZ/PMmEcng97lTlxoNAJAP9Ir/m292pcfJ8o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rIxWKS73EzABqrJTup+4oC8b5BYXM7pUcf/f7LvBI2GYqwrYaTSOdgeECOp5pNyPV
         fgRpj/tQXCpAkNJhqPPsburd4753eWH9tRQYocnNh2HPaLYTkQDovIJEUBApGGX4y5
         yJVmLyW5VZoOtW0tg3POL0eoM64LIjQkDlteGXVEzUj8JcKfLRYiI2odZngAV5QMX5
         96ZUn2LVViyQf7Rh80kEkFgnquEEv6IkOiUWa3qtZyFaXT48+gs1Nw8Eq/yIAknf6J
         cCge99US0QG3T6PN1m8qxFuCbQTqkoaH3ZqZSSzMsy/e5h79zZPPMh7rXFrUMA7Odp
         qPcXTyVAUkjPA==
Date:   Wed, 1 Feb 2023 21:45:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next v2 01/10] net: libwx: Add irq flow functions
Message-ID: <20230201214505.24b1fb4a@kernel.org>
In-Reply-To: <20230131100541.73757-2-mengyuanlou@net-swift.com>
References: <20230131100541.73757-1-mengyuanlou@net-swift.com>
        <20230131100541.73757-2-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 Jan 2023 18:05:32 +0800 Mengyuan Lou wrote:
> +	/* initialize work limits */
> +	q_vector->tx.work_limit = wx->tx_work_limit;
> +	q_vector->rx.work_limit = wx->rx_work_limit;

How is the work limit used? 

> +	wx->isb_mem = dma_alloc_coherent(&pdev->dev,
> +					 sizeof(u32) * 4,
> +					 &wx->isb_dma,
> +					 GFP_KERNEL);
> +	if (!wx->isb_mem) {
> +		wx_err(wx, "Alloc isb_mem failed\n");
> +		return -ENOMEM;
> +	}
> +	memset(wx->isb_mem, 0, sizeof(u32) * 4);

unnecessary, dma_alloc_coherent() clears the memory.
