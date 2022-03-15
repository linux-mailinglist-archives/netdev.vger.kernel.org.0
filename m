Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 051EF4DA428
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 21:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351774AbiCOUnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 16:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245528AbiCOUnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 16:43:20 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7A1580EA
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 13:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=p0m/cSxixam7k6vhYyLEtrtXdbS2R+xHuHHKqG6eOiU=; b=OzZeLFOuGI9kzTw+mcU2ikbHzi
        V2XSD3cMPQB/TBvdPqPP1HyCTvE5oFhbEUBtf4x25wfyI0LqIFm1Z06sPcxYBF1PBqRirMUceOzfu
        IzVR7MJK8mg7yqHXzm0myNp4rrCzBCympQLcktBfgozeyPNhW/L/u0mJ276hwL3Z/76Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nUDzZ-00B2Pg-FW; Tue, 15 Mar 2022 21:42:05 +0100
Date:   Tue, 15 Mar 2022 21:42:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        UNGLinuxDriver@microchip.com, Ian.Saturley@microchip.com
Subject: Re: [PATCH net-next 2/5] net: lan743x: Add support for EEPROM
Message-ID: <YjD6Hdjz78aZL/Wz@lunn.ch>
References: <20220315061701.3006-1-Raju.Lakkaraju@microchip.com>
 <20220315061701.3006-3-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315061701.3006-3-Raju.Lakkaraju@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int lan743x_hs_syslock_acquire(struct lan743x_adapter *adapter,
> +				      u16 timeout)
> +{
> +	u16 timeout_cnt = 0;
> +	u32 val;
> +
> +	do {
> +		spin_lock(&adapter->eth_syslock_spinlock);
> +		if (adapter->eth_syslock_acquire_cnt == 0) {
> +			lan743x_csr_write(adapter, ETH_SYSTEM_SYS_LOCK_REG,
> +					  SYS_LOCK_REG_ENET_SS_LOCK_);
> +			val = lan743x_csr_read(adapter, ETH_SYSTEM_SYS_LOCK_REG);
> +			if (val & SYS_LOCK_REG_ENET_SS_LOCK_) {
> +				adapter->eth_syslock_acquire_cnt++;
> +				WARN_ON(adapter->eth_syslock_acquire_cnt == 0);
> +				spin_unlock(&adapter->eth_syslock_spinlock);
> +				break;
> +			}
> +		} else {
> +			adapter->eth_syslock_acquire_cnt++;
> +			WARN_ON(adapter->eth_syslock_acquire_cnt == 0);
> +			spin_unlock(&adapter->eth_syslock_spinlock);
> +			break;
> +		}
> +
> +		spin_unlock(&adapter->eth_syslock_spinlock);
> +
> +		if (timeout_cnt++ < timeout)
> +			usleep_range(10000, 11000);
> +		else
> +			return -EINVAL;

ETIMEDOUT should be used for a timeout.

> +static int lan743x_hs_eeprom_cmd_cmplt_chk(struct lan743x_adapter *adapter)
> +{
> +	unsigned long start_time = jiffies;
> +	u32 val;
> +
> +	do {
> +		val = lan743x_csr_read(adapter, HS_E2P_CMD);
> +		if (!(val & HS_E2P_CMD_EPC_BUSY_) ||
> +		    (val & HS_E2P_CMD_EPC_TIMEOUT_))
> +			break;
> +
> +		usleep_range(50, 60);
> +	} while (!time_after(jiffies, start_time + HZ));
> +
> +	if (val & (HS_E2P_CMD_EPC_TIMEOUT_ | HS_E2P_CMD_EPC_BUSY_)) {
> +		netif_warn(adapter, drv, adapter->netdev,
> +			   "HS EEPROM operation timeout/busy\n");
> +		return -ETIMEDOUT;
> +	}

It looks like iopoll.h should be used here.

> +static int lan743x_hs_eeprom_write(struct lan743x_adapter *adapter,
> +				   u32 offset, u32 length, u8 *data)
> +{
> +	int retval;
> +	u32 val;
> +	int i;
> +
> +	if (offset + length > MAX_EEPROM_SIZE)
> +		return -EINVAL;

The core should of already checked this. Look at net/ethtool/ioctl.c

    Andrew
