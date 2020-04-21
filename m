Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13011B2E92
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 19:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729038AbgDURsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 13:48:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:53558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbgDURsV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 13:48:21 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76868206E9;
        Tue, 21 Apr 2020 17:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587491300;
        bh=RuC5p/lgcVntVYCMSxS92ZelTknt7a5dW2tyKs9fdeo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OW8AtGCdrvdnTkqiLBYK5JYAqJAeNaZnlqYzo4Oaq8Fz1hYIpH+cFn7kG8y367j+A
         ePgwtGB5bELVrv0fNsvCYsDaNIpVgoH7fQUGsykRBG/JujPpoQCvyxT8j1BwA4yclf
         DMRvVYnoK9cLhlS13o8WW1bCYdbMO/EKLFU7sanU=
Date:   Tue, 21 Apr 2020 10:48:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Vitaly Lifshits <vitaly.lifshits@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        kbuild test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andre Guedes <andre.guedes@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [net-next 03/13] igc: add support to interrupt, eeprom,
 registers and link self-tests
Message-ID: <20200421104818.1e9cfa14@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200420234313.2184282-4-jeffrey.t.kirsher@intel.com>
References: <20200420234313.2184282-1-jeffrey.t.kirsher@intel.com>
        <20200420234313.2184282-4-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Apr 2020 16:43:03 -0700 Jeff Kirsher wrote:
> +bool igc_intr_test(struct igc_adapter *adapter, u64 *data)
> +{
> +	struct igc_hw *hw = &adapter->hw;
> +	struct net_device *netdev = adapter->netdev;
> +	u32 mask, ics_mask = IGC_ICS_MASK_OTHER, i = 0, shared_int = true;
> +	u32 irq = adapter->pdev->irq;
> +
> +	*data = 0;
> +
> +	/* Hook up test interrupt handler just for this test */
> +	if (adapter->msix_entries) {
> +		if (request_irq(adapter->msix_entries[0].vector,
> +				&igc_test_intr_msix, 0,
> +				netdev->name, adapter)) {
> +			*data = 1;
> +			return false;
> +		}
> +		ics_mask = IGC_ICS_MASK_MSIX;
> +	} else if (adapter->flags & IGC_FLAG_HAS_MSI) {
> +		shared_int = false;
> +		if (request_irq(irq,
> +				igc_test_intr, 0, netdev->name, adapter)) {
> +			*data = 1;
> +			return false;
> +		}
> +	} else if (!request_irq(irq, igc_test_intr, IRQF_PROBE_SHARED,
> +				netdev->name, adapter)) {
> +		shared_int = false;
> +	} else if (request_irq(irq, &igc_test_intr, IRQF_SHARED,
> +		 netdev->name, adapter)) {
> +		*data = 1;
> +		return false;
> +	}

What's the meaning of shared_int here? Looks like MSI-Ss are shared but
not MSIs? Could you perhaps add a comment or rename so it's clear it's
not IRQF_SHARED we're talking about?

> +static void igc_diag_test(struct net_device *netdev,
> +			  struct ethtool_test *eth_test, u64 *data)
> +{
> +	struct igc_adapter *adapter = netdev_priv(netdev);
> +	bool if_running = netif_running(netdev);
> +
> +	if (eth_test->flags == ETH_TEST_FL_OFFLINE) {
> +		netdev_info(adapter->netdev, "offline testing starting");
> +		set_bit(__IGC_TESTING, &adapter->state);

> +	} else {
> +		netdev_info(adapter->netdev, "online testing starting");

I'm no expert on self-tests but this looks like a strange condition for
a bitfield. If only on bit is set we do offline, if no bit is set, or
offline and something else we do online?

Perhaps:

if (flags & OFFLINE) {
 ...
} else {
 ...
}

Or

if (flags == OFFLINE) {
 ...
} else if (flags == 0) {
 ...
}

Rather than the mix of the two?

> +		/* register, eeprom, intr and loopback tests not run online */
> +		data[TEST_REG] = 0;
> +		data[TEST_EEP] = 0;
> +		data[TEST_IRQ] = 0;
> +		data[TEST_LOOP] = 0;
> +
> +		if (!igc_link_test(adapter, &data[TEST_LINK]))
> +			eth_test->flags |= ETH_TEST_FL_FAILED;
> +	}
> +
> +	msleep_interruptible(4 * 1000);

Why?

> +}
> +
