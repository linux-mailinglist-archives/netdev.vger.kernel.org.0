Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 436094A6ADC
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 05:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244515AbiBBEUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 23:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244518AbiBBEUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 23:20:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1250FC06174E;
        Tue,  1 Feb 2022 20:14:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FB56616B1;
        Wed,  2 Feb 2022 04:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906F6C004E1;
        Wed,  2 Feb 2022 04:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643775260;
        bh=Hf9Af+jIJfWV93bRscI2lryAE659jsusiZwyg3y49tg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PoasB37U8EYdh6TboLARgoAMle6yuc6Hkuj3+k7f2ec0y9l6Fl5QDCf/wQY5o/821
         Pk6+3xpAk3MQxy7nqhyHaU988+uFVBWbNDCO+qqfE+cOiE58otE/B14kVd3z1Ojlbq
         iKJ1rRUop04Yt3wV5R8kgavsU4fo2GPcZrJe8pHl7kk19pU8bS6EeQtC2EaZNgNJAx
         E0OppVOKHUKxAMXP43FsPO+3Lxil960r/iy5yIaMCkA/beKmUpAatCfPClzlZdFsNR
         nLx2yuulL6GgqpVeuHSSYGFWJwHqAfScQobZiyMcxRTlGOHK8tMTXIpzCCQ973w5LM
         eWEn/xUC3tPKw==
Date:   Tue, 1 Feb 2022 20:14:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc:     netdev@vger.kernel.org, Sunil Goutham <sgoutham@marvell.com>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH v2] drivers: net: Replace acpi_bus_get_device()
Message-ID: <20220201201418.67ae9005@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <11918902.O9o76ZdvQC@kreacher>
References: <11918902.O9o76ZdvQC@kreacher>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 01 Feb 2022 20:58:36 +0100 Rafael J. Wysocki wrote:
> -	struct bgx *bgx = context;
> +	struct acpi_device *adev = acpi_fetch_acpi_dev(handle);
>  	struct device *dev = &bgx->pdev->dev;
> -	struct acpi_device *adev;
> +	struct bgx *bgx = context;

Compiler says you can't move bgx before dev.

Venturing deeper into the bikesheeding territory but I'd leave the
variable declarations be and move init of adev before the check.
Matter of preference but calling something that needs to be error 
checked in variable init breaks the usual
	
	ret = func(some, arguments);
	if (ret)
		goto explosions;

flow.

> -	if (acpi_bus_get_device(handle, &adev))
> +	if (!adev)
>  		goto out;
