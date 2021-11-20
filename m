Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD4D457AFB
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 04:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236209AbhKTEB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 23:01:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:38962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230055AbhKTEB4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 23:01:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B95466069B;
        Sat, 20 Nov 2021 03:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637380733;
        bh=mXqChChKsjSCPnEkiDTHU/cG+Or7VNbeDM9auKDL9R8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bk0m+13ZxNA5mwpJx1vevh3NucZD8hzAA8UxE41a69GYzcZxMfmnA86yDSNuvjgeF
         SR1cQANiO5Bt7TPZT13ji+8ykVN48YR0Ml5MqyjSNb3TleCLeYKrhnIIFekjsNrz1G
         +cn/xcOUCVLcM9Unwi+evNHFI/Jj3M3Bi0bB8ydQF0dqabC36kkMSCl4cKPYCHCF2v
         PFO+33eibpW6iY8UhYRtcQ4bTe96Xs4NORTbf3cX1fXGyXLV6lpl2lU6PlOakL/Zwy
         Bgf7N0dIYTGOTCSoditSvdhd9aUQc2uJTY8t3fTZm6rCFnl0qYEt8HopwsypM7sAfq
         pnprrOwaN905Q==
Date:   Fri, 19 Nov 2021 19:58:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Yannick Vignon <yannick.vignon@nxp.com>,
        Michael Olbrich <m.olbrich@pengutronix.de>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Holger Assmann <h.assmann@pengutronix.de>,
        kernel@pengutronix.de, Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH net] net: stmmac: retain PTP clock time during
 SIOCSHWTSTAMP ioctls
Message-ID: <20211119195851.2181aab3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211119230542.3402726-1-vladimir.oltean@nxp.com>
References: <20211119230542.3402726-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 20 Nov 2021 01:05:42 +0200 Vladimir Oltean wrote:
> Currently, when user space emits SIOCSHWTSTAMP ioctl calls such as
> enabling/disabling timestamping or changing filter settings, the driver
> reads the current CLOCK_REALTIME value and programming this into the
> NIC's hardware clock. This might be necessary during system
> initialization, but at runtime, when the PTP clock has already been
> synchronized to a grandmaster, a reset of the timestamp settings might
> result in a clock jump. Furthermore, if the clock is also controlled by
> phc2sys in automatic mode (where the UTC offset is queried from ptp4l),
> that UTC-to-TAI offset (currently 37 seconds in 2021) would be
> temporarily reset to 0, and it would take a long time for phc2sys to
> readjust so that CLOCK_REALTIME and the PHC are apart by 37 seconds
> again.
> 
> To address the issue, we introduce a new function called
> stmmac_init_tstamp_counter(), which gets called during ndo_open().
> It contains the code snippet moved from stmmac_hwtstamp_set() that
> manages the time synchronization. Besides, the sub second increment
> configuration is also moved here since the related values are hardware
> dependent and runtime invariant.
> 
> Furthermore, the hardware clock must be kept running even when no time
> stamping mode is selected in order to retain the synchronized time base.
> That way, timestamping can be enabled again at any time only with the
> need to compensate the clock's natural drifting.
> 
> As a side effect, this patch fixes the issue that ptp_clock_info::enable
> can be called before SIOCSHWTSTAMP and the driver (which looks at
> priv->systime_flags) was not prepared to handle that ordering.

Makes build fail:

ERROR: modpost: "stmmac_init_tstamp_counter" [drivers/net/ethernet/stmicro/stmmac/stmmac-platform.ko] undefined!
