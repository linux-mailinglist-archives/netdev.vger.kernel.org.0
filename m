Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4E45EFBA4
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 19:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236047AbiI2RJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 13:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235773AbiI2RJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 13:09:16 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 300AD1CEDE2
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 10:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kpHNsx/87V66a40BkVJcIxdUZ3ghIg1WBwx3IutKLB4=; b=2mrrmsfzYxSLYzsR1vCeA/u7kz
        tWc6bBwFxIUlMeSytOhQIX/YtsacABD3ctc4UHNWWhb5LgRIUNexNrQ3KVuv1ZlqsjETbS+VSBNpS
        SgXVboR5kZznBmljboeAFJxVcLS+SI2cVwpsio0vYe1gcv6d7a4ZEXbbqwtGYdm4+RvU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1odx28-000dab-EJ; Thu, 29 Sep 2022 19:09:12 +0200
Date:   Thu, 29 Sep 2022 19:09:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v3 3/3] net: txgbe: Set MAC address and register
 netdev
Message-ID: <YzXROBtztWopeeaA@lunn.ch>
References: <20220929093424.2104246-1-jiawenwu@trustnetic.com>
 <20220929093424.2104246-4-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929093424.2104246-4-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/**
> + * txgbe_open - Called when a network interface is made active
> + * @netdev: network interface device structure
> + *
> + * Returns 0 on success, negative value on failure
> + *
> + * The open entry point is called when a network interface is made
> + * active by the system (IFF_UP).
> + **/
> +static int txgbe_open(struct net_device *netdev)
> +{
> +	netif_carrier_off(netdev);

The carrier should already be off, so this should not be needed.

> +/**
> + * txgbe_set_mac - Change the Ethernet Address of the NIC
> + * @netdev: network interface device structure
> + * @p: pointer to an address structure
> + *
> + * Returns 0 on success, negative on failure
> + **/
> +static int txgbe_set_mac(struct net_device *netdev, void *p)
> +{
> +	struct txgbe_adapter *adapter = netdev_priv(netdev);
> +	struct wx_hw *wxhw = &adapter->hw.wxhw;
> +	struct sockaddr *addr = p;
> +
> +	if (!is_valid_ether_addr(addr->sa_data))
> +		return -EADDRNOTAVAIL;

Maybe use eth_prepare_mac_addr_change() ?

> + * txgbe_add_sanmac_netdev - Add the SAN MAC address to the corresponding
> + * netdev->dev_addr_list
> + * @dev: network interface device structure
> + *
> + * Returns non-zero on failure
> + **/
> +static int txgbe_add_sanmac_netdev(struct net_device *dev)
> +{
> +	struct txgbe_adapter *adapter = netdev_priv(dev);
> +	struct txgbe_hw *hw = &adapter->hw;
> +	int err = 0;
> +
> +	if (is_valid_ether_addr(hw->mac.san_addr)) {

You have a lot of these checks. Where can the bad MAC address come
from? Can you check this once at a higher level? Generally, if you
don't have a valid MAC address you call eth_hw_addr_random() to create
a valid random MAC address.

> +	eth_hw_addr_set(netdev, wxhw->mac.perm_addr);
> +
> +	if (!is_valid_ether_addr(netdev->dev_addr)) {
> +		dev_err(&pdev->dev, "invalid MAC address\n");
> +		err = -EIO;
> +		goto err_free_mac_table;
> +	}

so maybe you should call eth_hw_addr_random() here?

> +
> +	txgbe_mac_set_default_filter(adapter, wxhw->mac.perm_addr);
> +
> +	strcpy(netdev->name, "eth%d");

That is not needed. It should already default to that from the call to
alloc_etherdev() or its variants.

> +	err = register_netdev(netdev);
> +	if (err)
> +		goto err_free_mac_table;
> +
>  	pci_set_drvdata(pdev, adapter);
> +	adapter->netdev_registered = true;
> +
> +	/* carrier off reporting is important to ethtool even BEFORE open */
> +	netif_carrier_off(netdev);

It can already be open by the time you get here. As soon as you call
register_netdev(), the device can be used. e.g. NFS root could of
already opened the device and tried to talk to the NFS server before
register_netdev() even returns. The device needs to be 100% ready to
go before you call register_netdev().

>  static void txgbe_remove(struct pci_dev *pdev)
>  {
> +	struct txgbe_adapter *adapter = pci_get_drvdata(pdev);
> +	struct net_device *netdev;
> +
> +	netdev = adapter->netdev;
> +
> +	/* remove the added san mac */
> +	txgbe_del_sanmac_netdev(netdev);
> +
> +	if (adapter->netdev_registered) {
> +		unregister_netdev(netdev);
> +		adapter->netdev_registered = false;
> +	}

How can remove be called without it being registered? Probe should
either succed and register the netdev, or fail, and hence remove will
never be called.

      Andrew
