Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E85CF462811
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 00:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbhK2XT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 18:19:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232984AbhK2XTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 18:19:13 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547C7C061756
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 15:09:24 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id gx15-20020a17090b124f00b001a695f3734aso15579260pjb.0
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 15:09:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cjI1iEQvrjuZSzQZKIgkcHTIt7pFNhKvScbd/sC/DHY=;
        b=ENGS1vi2o2YfHxqbY5IgOrQypSaAni8EZF3I6S1lvMqdeCH/+Fjux5Cbnguf0cpXmg
         Y8wi7VgkiFU3/jWJ2GmqReOkCz+URZggphEGNCM8VvkwYrxuk+MrtKGCZZSXBKdF8rX1
         mqah2ciG3K2Dx6lfaGNivlKrPZuesvJ+sC290q1qgLWJl6JaJgWRNua7ObLK8aRlo29m
         L2wegrb6IE+d7wEBHHigCEKl6tFmMfbGSAvbxPo8SuNX58aZAL4oBrLaakcwUW4rARR0
         cWpHv3Rxq15PxGeUIDucAovIiXrcwoqsxbqQCj8HCpzlZIAlg45YbaVvyDMG4YFlSGWd
         KRVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cjI1iEQvrjuZSzQZKIgkcHTIt7pFNhKvScbd/sC/DHY=;
        b=HsIRbTN41Jj5x9JRuk0d3N8KxnKwHUiFbNM/orYzb0jxWHfWhMdgFQ8gEo3K213IXk
         GOOiLnlJ+COt2e7kdOaETfDaJkiyr01Nj8zW1pEPEj6BNvDgrWCoSEuOGaXfh3RWOnvg
         I/37MhEy8mz/i9NaCGBcbG/GtVhWeSLEWtYHKREbf/uCP+/euY9Ru/CGjXGVnyfcHrOz
         n6uu827yTEyf4r3LLKGd3STe6d0mx2YP80EyrgAEAtKbFqqCUEyQfBTceC0Z+LT7ZOv6
         JQLMvPaIA2tGd84hZuqWTW4iwMoqzCB9mAUW3yrwqUcOi68c1jx2fwlZtJg41DRsUcf2
         Wthw==
X-Gm-Message-State: AOAM530ExbkOJAmjwfVASFWutE5XxjApLVQWI0dY9mEBdu/+KhSc1++b
        Z4QGuKYTAmJ1H7Tut7PSWuP/YQ==
X-Google-Smtp-Source: ABdhPJzbyoFU1yg8Z2cnExgjCBIVKV6YN6hQS1gzWST7Vflpo6RAr5de7f5200UzFLg1zyPhgkYp/g==
X-Received: by 2002:a17:90a:1283:: with SMTP id g3mr1344516pja.174.1638227363347;
        Mon, 29 Nov 2021 15:09:23 -0800 (PST)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id j38sm12969983pgb.84.2021.11.29.15.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 15:09:22 -0800 (PST)
Date:   Mon, 29 Nov 2021 15:09:20 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH net] igb: fix deadlock caused by taking RTNL in RPM
 resume path
Message-ID: <20211129150920.4a400828@hermes.local>
In-Reply-To: <6bb28d2f-4884-7696-0582-c26c35534bae@gmail.com>
References: <6bb28d2f-4884-7696-0582-c26c35534bae@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Nov 2021 22:14:06 +0100
Heiner Kallweit <hkallweit1@gmail.com> wrote:

> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index dd208930f..8073cce73 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -9254,7 +9254,7 @@ static int __maybe_unused igb_suspend(struct device *dev)
>  	return __igb_shutdown(to_pci_dev(dev), NULL, 0);
>  }
>  
> -static int __maybe_unused igb_resume(struct device *dev)
> +static int __maybe_unused __igb_resume(struct device *dev, bool rpm)
>  {
>  	struct pci_dev *pdev = to_pci_dev(dev);
>  	struct net_device *netdev = pci_get_drvdata(pdev);
> @@ -9297,17 +9297,24 @@ static int __maybe_unused igb_resume(struct device *dev)
>  
>  	wr32(E1000_WUS, ~0);
>  
> -	rtnl_lock();
> +	if (!rpm)
> +		rtnl_lock();
>  	if (!err && netif_running(netdev))
>  		err = __igb_open(netdev, true);
>  
>  	if (!err)
>  		netif_device_attach(netdev);
> -	rtnl_unlock();
> +	if (!rpm)
> +		rtnl_unlock();
>  
>  	return err;
>  }
>  
> +static int __maybe_unused igb_resume(struct device *dev)
> +{
> +	return __igb_resume(dev, false);
> +}
> +
>  static int __maybe_unused igb_runtime_idle(struct device *dev)
>  {
>  	struct net_device *netdev = dev_get_drvdata(dev);
> @@ -9326,7 +9333,7 @@ static int __maybe_unused igb_runtime_suspend(struct device *dev)
>  
>  static int __maybe_unused igb_runtime_resume(struct device *dev)
>  {
> -	return igb_resume(dev);
> +	return __igb_resume(dev, true);
>  }

Rather than conditional locking which is one of the seven deadly sins of SMP,
why not just have __igb_resume() be the locked version where lock is held by caller?
