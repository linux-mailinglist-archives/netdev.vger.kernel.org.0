Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C172682FE
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 05:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgINDEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 23:04:53 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:33141 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726042AbgINDEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 23:04:46 -0400
Received: by mail-pj1-f68.google.com with SMTP id md22so4500377pjb.0;
        Sun, 13 Sep 2020 20:04:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wslV7kc2OWlQiNYx6OI1TuXMh83MtChw+AW7PwzF+ro=;
        b=mPIq42oLQQwZPeph0I/GC+c8qJnt/f3DdFzWNMY3gxujgLp30o6tnG80LrBQgqk03Z
         gIkm8/dUyA2yrJnL0dbF830VMiLkpd1S6vpXAsNSewzG4A5JZ+Fmkk0pqhSp/t8OPVf+
         4uv+gI2KAcUN9MYWAE/XX/cS4I60DGnSxV67Hc/C00zvnveBL4I2MoKzzdAzfA1kpcDA
         SdbBRf/lfFexfLLsJzEJKR2kGbXoEPBMOyotfR7vye5nocxxwE77NdB5dBrMSP5DnDuq
         I6V82ygq/rS3/8L84EWOMxYTcG8crGK2M+RY4LNdv1O9ZFT1NKQOSwbEY5v3AxmRO3io
         NdNA==
X-Gm-Message-State: AOAM530Y5JWLpejPovVGAORgWJJMcwF5VLxTzs6qXUw7TGm4iBBj1BuO
        fH2YMkjOgscWfLlUuEHUmwc=
X-Google-Smtp-Source: ABdhPJwkWuf6DfzGlBx7srcAs/Wny3kc9OOhUctFy8t0zGlFn2N/FKnl3KPovaV6BnflvIvVgsFOAw==
X-Received: by 2002:a17:90a:8593:: with SMTP id m19mr12267271pjn.104.1600052685777;
        Sun, 13 Sep 2020 20:04:45 -0700 (PDT)
Received: from localhost ([2601:647:5b00:1162:1ac0:17a6:4cc6:d1ef])
        by smtp.gmail.com with ESMTPSA id q65sm6809774pga.88.2020.09.13.20.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2020 20:04:45 -0700 (PDT)
Date:   Sun, 13 Sep 2020 20:04:43 -0700
From:   Moritz Fischer <mdf@kernel.org>
To:     Moritz Fischer <mdf@kernel.org>
Cc:     davem@davemloft.net, snelson@pensando.io, mst@redhat.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        moritzf@google.com
Subject: Re: [PATCH net-next 2/3] net: dec: tulip: de2104x: Replace
 pci_enable_device with devres version
Message-ID: <20200914030443.GA12542@archbook>
References: <20200914001002.8623-1-mdf@kernel.org>
 <20200914001002.8623-3-mdf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914001002.8623-3-mdf@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 13, 2020 at 05:10:01PM -0700, Moritz Fischer wrote:
> Replace pci_enable_device() with its devres counterpart
> pcim_enable_device().
> 
> Signed-off-by: Moritz Fischer <mdf@kernel.org>
> ---
>  drivers/net/ethernet/dec/tulip/de2104x.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/dec/tulip/de2104x.c b/drivers/net/ethernet/dec/tulip/de2104x.c
> index 9bcfc82b71d1..e4189c45c2ba 100644
> --- a/drivers/net/ethernet/dec/tulip/de2104x.c
> +++ b/drivers/net/ethernet/dec/tulip/de2104x.c
> @@ -2009,14 +2009,14 @@ static int de_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	netif_carrier_off(dev);
>  
>  	/* wake up device, assign resources */
> -	rc = pci_enable_device(pdev);
> +	rc = pcim_enable_device(pdev);
>  	if (rc)
>  		return rc;
>  
>  	/* reserve PCI resources to ensure driver atomicity */
>  	rc = pci_request_regions(pdev, DRV_NAME);
>  	if (rc)
> -		goto err_out_disable;
> +		return rc;
>  
>  	/* check for invalid IRQ value */
>  	if (pdev->irq < 2) {
> @@ -2096,8 +2096,6 @@ static int de_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	iounmap(regs);
>  err_out_res:
>  	pci_release_regions(pdev);
> -err_out_disable:
> -	pci_disable_device(pdev);
>  	return rc;
>  }
>  
> @@ -2111,7 +2109,6 @@ static void de_remove_one(struct pci_dev *pdev)
>  	kfree(de->ee_data);
>  	iounmap(de->regs);
>  	pci_release_regions(pdev);
> -	pci_disable_device(pdev);
>  }
>  
>  #ifdef CONFIG_PM
> -- 
> 2.28.0
> 

Ugh, sorry for the noise, I missed the instances in the suspend/resume.
Let me resend a v2 of this ...

Thanks,
Moritz
