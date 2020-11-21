Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 966392BC2AF
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 00:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgKUXoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 18:44:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:57854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbgKUXoV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 18:44:21 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D36F820575;
        Sat, 21 Nov 2020 23:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606002261;
        bh=iV3Rm2n/Wq3H/wtrJKrr5ljSSvNt9cuMCWMdutwG5z8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X4BEL+66YaFB+SSRaaqB7VCWniPDJOjTBKTOSC+wzModjTZRDEW7fLR9mmFjnCsEY
         jotvTy5Myb4A5eYq/WLxDFtWgK/7bQGC78GDn2wPKtMUQKxV5KqIeukMSIcah5kHrJ
         /mCp5RCU2JUqgb7ceoWNiBUJLlGKeF/8Gyn6Rj4s=
Date:   Sat, 21 Nov 2020 15:44:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org, sukadev@linux.ibm.com, drt@linux.ibm.com
Subject: Re: [PATCH net 12/15] ibmvnic: fix NULL pointer dereference in
 reset_sub_crq_queues
Message-ID: <20201121154420.4e9e8f0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201120224049.46933-13-ljp@linux.ibm.com>
References: <20201120224049.46933-1-ljp@linux.ibm.com>
        <20201120224049.46933-13-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 16:40:46 -0600 Lijun Pan wrote:
> adapter->tx_scrq and adapter->rx_scrq could be NULL if the previous reset
> did not complete after freeing sub crqs. Check for NULL before
> dereferencing them.

> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> index 47446e5f8ec5..a0dbd963a1ab 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -2930,6 +2930,13 @@ static int reset_sub_crq_queues(struct ibmvnic_adapter *adapter)
>  {
>  	int i, rc;
>  
> +	if (!adapter->tx_scrq || !adapter->rx_scrq) {
> +		netdev_err(adapter->netdev,
> +			   "tx_scrq (%p) or rx_scrq (%p) does not exist\n",
> +			   adapter->tx_scrq, adapter->rx_scrq);

This is expected to happen for the condition you describe in the commit
message. Either prevent it from happening or silently ignore.

What's the impact to the user when this happens? Why would they want to
know that some pointer is NULL? Presumably there is already a message
printed when reset does not complete or such?

> +		return -EINVAL;
> +	}
> +
>  	for (i = 0; i < adapter->req_tx_queues; i++) {
>  		netdev_dbg(adapter->netdev, "Re-setting tx_scrq[%d]\n", i);
>  		rc = reset_one_sub_crq_queue(adapter, adapter->tx_scrq[i]);

