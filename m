Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A994029CD66
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 02:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725803AbgJ1BiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 21:38:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1832989AbgJ0XQI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 19:16:08 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0459F2225E;
        Tue, 27 Oct 2020 23:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603840567;
        bh=TANf6+4GJsfm6mjgHlPVgQ42wr/NLMgNvu68ahaUykw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KlLcPNuycRoU6rriSbrXX1NymvLllH8A/Y82/KukyHDY5uT6ysE/ipAE/ixvD157J
         CJMgWzNVm/2ZcwPwaEkIkt8hw3MnmcEZnR8ZREdtuTzQBd3jKJxtobYR8tGAdTz8lt
         d5AiIcFp3Tj/3TkjATZHKuuKde9ICvd7/NMnRmTU=
Date:   Tue, 27 Oct 2020 16:16:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moritz Fischer <mdf@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        lucyyan@google.com, moritzf@google.com,
        James.Bottomley@hansenpartnership.com
Subject: Re: [PATCH/RFC net-next v3] net: dec: tulip: de2104x: Add shutdown
 handler to stop NIC
Message-ID: <20201027161606.477a445e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201023202834.660091-1-mdf@kernel.org>
References: <20201023202834.660091-1-mdf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Oct 2020 13:28:34 -0700 Moritz Fischer wrote:
> diff --git a/drivers/net/ethernet/dec/tulip/de2104x.c b/drivers/net/ethernet/dec/tulip/de2104x.c
> index d9f6c19940ef..ea7442cc8e75 100644
> --- a/drivers/net/ethernet/dec/tulip/de2104x.c
> +++ b/drivers/net/ethernet/dec/tulip/de2104x.c
> @@ -2175,11 +2175,19 @@ static int __maybe_unused de_resume(struct device *dev_d)
>  
>  static SIMPLE_DEV_PM_OPS(de_pm_ops, de_suspend, de_resume);
>  
> +static void de_shutdown(struct pci_dev *pdev)
> +{
> +	struct net_device *dev = pci_get_drvdata(pdev);
> +
> +	de_close(dev);

Apparently I get all the best ideas when I'm about to apply something..

I don't think you can just call de_close() like that, because 
(a) it may expect rtnl_lock() to be held, and (b) it may not be open.

Perhaps call unregister_netdev(dev) - that'll close the device.
Or rtnl_lock(); dev_close(dev); rtnl_unlock();

> +}
> +
>  static struct pci_driver de_driver = {
>  	.name		= DRV_NAME,
>  	.id_table	= de_pci_tbl,
>  	.probe		= de_init_one,
>  	.remove		= de_remove_one,
> +	.shutdown	= de_shutdown,
>  	.driver.pm	= &de_pm_ops,
>  };
>  

