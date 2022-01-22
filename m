Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4D88496CD7
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 16:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbiAVPys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 10:54:48 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48908 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229581AbiAVPyr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Jan 2022 10:54:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/NBSKtd7whqJIJtzGKx0M/b3+V996RekHxiVT2ao8ho=; b=q1QO/k+CTojrmj3jIsQIEe2fmf
        h2rz+VvsDNKlw1vBCLc17mtPbtgwK/RUt6j1mSrqGQ99locXdk4H8vJXR+rXAy06WerGIPXt9t/8l
        uajMQ2K2hqX3q+3umn47AGjzKcVTElHrWygZwcYDlWrRhi7sDG7oQOp5jVdlqj71187M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nBIiz-002IzR-P6; Sat, 22 Jan 2022 16:54:45 +0100
Date:   Sat, 22 Jan 2022 16:54:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergei Trofimovich <slyich@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Re: atl1c drivers run 'napi/eth%d-385' named threads with
 unsubstituted %d
Message-ID: <YewoxYh2jNBnanUM@lunn.ch>
References: <YessW5YR285JeLf5@nz>
 <YetFsbw6885xUwSg@lunn.ch>
 <20220121170313.1d6ccf4d@hermes.local>
 <YetjpvBgQFApTRu0@lunn.ch>
 <20220122121228.3b73db2a@nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220122121228.3b73db2a@nz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Thank you Andrew! I used this second version of your patch
> against 5.16.1 and it seems to work:
> 
>     $ sudo ping -f 172.16.0.1
> 
>     613 root 20 0 0 0 0 S 11.0 0.0 0:07.46 napi/eth0-385
>     614 root 20 0 0 0 0 R  5.3 0.0 0:03.96 napi/eth0-386
> 
> Posting used diff as is just in case:
> 
> Tested-by: Sergei Trofimovich <slyich@gmail.com>

Great, thanks for testing.

> 
> --- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> @@ -2706,6 +2706,15 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  		goto err_alloc_etherdev;
>  	}
> 
> +	if (rtnl_lock_killable()) {
> +		err = -EINTR;
> +		goto err_init_netdev;
> +	}
> +	err = dev_alloc_name(netdev, netdev->name);
> +	rtnl_unlock();
> +	if (err < 0)
> +		goto err_init_netdev;

Since there are multiple users of dev_alloc_name() and it appears some
get locking wrong, it makes sense to add a helper in the code which
does the locking. So i will work on a patchset to add such a helper
and convert other drivers.

    Andrew
