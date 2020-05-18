Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47CA01D8BA4
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 01:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgERXdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 19:33:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:33908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbgERXdK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 19:33:10 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F22D920756;
        Mon, 18 May 2020 23:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589844790;
        bh=yyTg7ppw/tVZoi/AlS5IXaoCDgkni6tdBM1yJuqpMVA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mVyMJDA+T9xUb6OZgAnm/mKOkwd543IZYS7WH8y+NY3cjA+IH+IMDqlG9oGuwuc7V
         nw+B65WzCSyTc1++hCMxk/I4Y8l0jzisv0xe+7uX5Skd6opL8m3ESRjTOb1K/+ypuc
         s3dfSMhNs2kcCl3oCzVOv//kSDYtPABw6ul9TaU4=
Date:   Mon, 18 May 2020 16:33:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rohit Maheshwari <rohitm@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
Subject: Re: [PATCH net] cxgb4/chcr: Enable ktls settings at run time
Message-ID: <20200518163303.1dc96e07@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200518085918.32262-1-rohitm@chelsio.com>
References: <20200518085918.32262-1-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 May 2020 14:29:18 +0530 Rohit Maheshwari wrote:
>  	for_each_port(adap, i) {
>  		netdev = adap->port[i];
> -		netdev->features |= NETIF_F_HW_TLS_TX;
>  		netdev->hw_features |= NETIF_F_HW_TLS_TX;
>  		netdev->tlsdev_ops = &chcr_ktls_ops;
> +
> +		rtnl_lock();
> +		netdev_update_features(netdev);
> +		rtnl_unlock();
>  	}
>  }
>  
> @@ -571,6 +584,10 @@ void chcr_disable_ktls(struct adapter *adap)
>  		netdev->features &= ~NETIF_F_HW_TLS_TX;
>  		netdev->hw_features &= ~NETIF_F_HW_TLS_TX;

Twiddling with device flags without holding rtnl_lock seems
questionable.

>  		netdev->tlsdev_ops = NULL;

Clearing the ops pointer at runtime with no synchronization - even more
so. What if TLS code is mid-way through adding a connection?

> +		rtnl_lock();
> +		netdev_update_features(netdev);
> +		rtnl_unlock();
>  	}
>  }
