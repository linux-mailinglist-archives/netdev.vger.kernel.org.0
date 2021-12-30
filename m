Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD5D481E9D
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 18:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233463AbhL3R2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 12:28:20 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45492 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229915AbhL3R2T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Dec 2021 12:28:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=HyJMtjEqcW2WQWKuDGsSN5xbiq9slSXB428sgIdUASE=; b=nQsjuoaw3yAqvwjwGAj86+ekQj
        ZM5SwBPuO7Pgj728fAhXzc9U0vcdqxLVdGPXWuldT/uUj7Bb/JRMh312zCzksyySkCxEib84tLK0M
        gTqGtkdgaXCkU9Z5Q3xOJxtBoKuA7CuU4zCef22dP+YU/OKNZp497cZP0PLcon8wQZTs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n2zDp-000BC9-01; Thu, 30 Dec 2021 18:28:13 +0100
Date:   Thu, 30 Dec 2021 18:28:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/8] net/fungible: Add service module for
 Fungible drivers
Message-ID: <Yc3sLEjF6O1CaMZZ@lunn.ch>
References: <20211230163909.160269-1-dmichail@fungible.com>
 <20211230163909.160269-3-dmichail@fungible.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211230163909.160269-3-dmichail@fungible.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/* Wait for the CSTS.RDY bit to match @enabled. */
> +static int fun_wait_ready(struct fun_dev *fdev, bool enabled)
> +{
> +	unsigned int cap_to = NVME_CAP_TIMEOUT(fdev->cap_reg);
> +	unsigned long timeout = ((cap_to + 1) * HZ / 2) + jiffies;
> +	u32 bit = enabled ? NVME_CSTS_RDY : 0;

Reverse Christmas tree, since this is a network driver.

Please also consider using include/linux/iopoll.h. The signal handling
might make that not possible, but signal handling in driver code is in
itself very unusual.

> +
> +	do {
> +		u32 csts = readl(fdev->bar + NVME_REG_CSTS);
> +
> +		if (csts == ~0) {
> +			dev_err(fdev->dev, "CSTS register read %#x\n", csts);
> +			return -EIO;
> +		}
> +
> +		if ((csts & NVME_CSTS_RDY) == bit)
> +			return 0;
> +
> +		msleep(100);
> +		if (fatal_signal_pending(current))
> +			return -EINTR;
> +	} while (time_is_after_eq_jiffies(timeout));
> +
> +	dev_err(fdev->dev,
> +		"Timed out waiting for device to indicate RDY %u; aborting %s\n",
> +		enabled, enabled ? "initialization" : "reset");
> +	return -ETIMEDOUT;
> +}

  Andrew
