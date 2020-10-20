Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE991294583
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 01:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410700AbgJTXs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 19:48:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:38756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410696AbgJTXsz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 19:48:55 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 301F62222D;
        Tue, 20 Oct 2020 23:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603237735;
        bh=rAvFFwIh4tbwHu4TOdJbkQnWHNF8sHO1vAlPvGWPyZQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y2T8pJM5yH3REVwyMcKAj/PxuUhxojcQTea1H8zQlAeoS6EuQMcMaBMb10nQ1j2VQ
         KYuz/5obErpbe39MVOlYEebr4Sw5akbBNNOF4Aj4Wn0FrWOjaXAUa4UXNdbiTh9tWB
         tVEWc0WhW9eMylPA3FGYm01Liajfjh6G9o3Ny5Is=
Date:   Tue, 20 Oct 2020 16:48:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] ibmvnic: no need to update adapter->mac_addr before
 it completes
Message-ID: <20201020164852.722bdedd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201020232812.46498-1-ljp@linux.ibm.com>
References: <20201020232812.46498-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 18:28:12 -0500 Lijun Pan wrote:
> @@ -1828,7 +1827,6 @@ static int ibmvnic_set_mac(struct net_device *netdev, void *p)
>  	int rc;
>  
>  	rc = 0;
> -	ether_addr_copy(adapter->mac_addr, addr->sa_data);
>  	if (adapter->state != VNIC_PROBED)
>  		rc = __ibmvnic_set_mac(netdev, addr->sa_data);
>  

If we just do this, in case state == VNIC_PROBED ibmvnic_set_mac() will
do nothing - just return 0 without saving the user supplied MAC address.
