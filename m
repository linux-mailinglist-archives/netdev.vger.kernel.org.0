Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44D323E02B
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 20:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbgHFSJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 14:09:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45338 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726490AbgHFSIi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Aug 2020 14:08:38 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k3kJ5-008WeN-OS; Thu, 06 Aug 2020 20:07:59 +0200
Date:   Thu, 6 Aug 2020 20:07:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Adrian Pop <popadrian1996@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, vadimp@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com, roopa@nvidia.com, paschmidt@nvidia.com
Subject: Re: [PATCH ethtool v2] Add QSFP-DD support
Message-ID: <20200806180759.GD2005851@lunn.ch>
References: <20200806145936.29169-1-popadrian1996@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200806145936.29169-1-popadrian1996@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Adrian

> +static void
> +qsfp_dd_parse_diagnostics(const __u8 *id, struct qsfp_dd_diags *const sd)
> +{
> +	__u16 rx_power_offset;
> +	__u16 tx_power_offset;
> +	__u16 tx_bias_offset;
> +	__u16 temp_offset;
> +	__u16 volt_offset;
> +	int i;
> +
> +	for (i = 0; i < QSFP_DD_MAX_CHANNELS; ++i) {
> +		/*
> +		 * Add Tx/Rx output/input optical power relevant information.
> +		 * To access the info for the ith lane, we have to skip i * 2
> +		 * bytes starting from the offset of the first lane for that
> +		 * specific channel property.
> +		 */
> +		tx_bias_offset = QSFP_DD_TX_BIAS_START_OFFSET + (i << 1);
> +		rx_power_offset = QSFP_DD_RX_PWR_START_OFFSET + (i << 1);
> +		tx_power_offset = QSFP_DD_TX_PWR_START_OFFSET + (i << 1);

> +/*-----------------------------------------------------------------------
> + * Upper Memory Page 0x10: contains dynamic control bytes.
> + * RealOffset = 3 * 0x80 + LocalOffset
> + */
> +#define PAG10H_OFFSET				(0x03 * 0x80)
> +
> +/*-----------------------------------------------------------------------
> + * Upper Memory Page 0x11: contains lane dynamic status bytes.
> + * RealOffset = 4 * 0x80 + LocalOffset
> + */
> +#define PAG11H_OFFSET				(0x04 * 0x80)
> +#define QSFP_DD_TX_PWR_START_OFFSET		(PAG11H_OFFSET + 0x9A)
> +#define QSFP_DD_TX_BIAS_START_OFFSET		(PAG11H_OFFSET + 0xAA)
> +#define QSFP_DD_RX_PWR_START_OFFSET		(PAG11H_OFFSET + 0xBA)
> +
> +/* HA = High Alarm; LA = Low Alarm
> + * HW = High Warning; LW = Low Warning
> + */
> +#define QSFP_DD_TX_HA_OFFSET			(PAG11H_OFFSET + 0x8B)
> +#define QSFP_DD_TX_LA_OFFSET			(PAG11H_OFFSET + 0x8C)
> +#define QSFP_DD_TX_HW_OFFSET			(PAG11H_OFFSET + 0x8D)
> +#define QSFP_DD_TX_LW_OFFSET			(PAG11H_OFFSET + 0x8E)
> +
> +#define QSFP_DD_RX_HA_OFFSET			(PAG11H_OFFSET + 0x95)
> +#define QSFP_DD_RX_LA_OFFSET			(PAG11H_OFFSET + 0x96)
> +#define QSFP_DD_RX_HW_OFFSET			(PAG11H_OFFSET + 0x97)
> +#define QSFP_DD_RX_LW_OFFSET			(PAG11H_OFFSET + 0x98)

You still have code which implies page 0x10 and 0x11 follow directly
after page 2. This is something i would like to avoid until we have a
driver which really does export these pages. Please could you remove
all this code.

Thanks
	Andrew
