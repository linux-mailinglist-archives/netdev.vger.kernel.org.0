Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60842C7A32
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 18:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbgK2RR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 12:17:27 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55510 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbgK2RR0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Nov 2020 12:17:26 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kjQJO-009NNW-Vv; Sun, 29 Nov 2020 18:16:34 +0100
Date:   Sun, 29 Nov 2020 18:16:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microsemi List <microsemi@lists.bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] net: sparx5: Add Sparx5 switchdev driver
Message-ID: <20201129171634.GD2234159@lunn.ch>
References: <20201127133307.2969817-1-steen.hegelund@microchip.com>
 <20201127133307.2969817-3-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127133307.2969817-3-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c b/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
> new file mode 100644
> index 000000000000..a91dd9532f1c
> --- /dev/null
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
> @@ -0,0 +1,1027 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/* Microchip Sparx5 Switch driver
> + *
> + * Copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
> + */
> +
> +#include <linux/ethtool.h>
> +
> +#include "sparx5_main.h"
> +#include "sparx5_port.h"
> +
> +/* Add a potentially wrapping 32 bit value to a 64 bit counter */
> +static inline void sparx5_update_counter(u64 *cnt, u32 val)
> +{
> +	if (val < (*cnt & U32_MAX))
> +		*cnt += (u64)1 << 32; /* value has wrapped */
> +
> +	*cnt = (*cnt & ~(u64)U32_MAX) + val;
> +}

No inline functions in C files. Let the compiler decide.

And i now think i get what this is doing. But i'm surprised at the
hardware. Normally registers like this which are expected to wrap
around, reset to 0 on read.

	Andrew
