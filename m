Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2535B6364BC
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 16:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238202AbiKWPw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 10:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239098AbiKWPwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 10:52:24 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83D4C72EA;
        Wed, 23 Nov 2022 07:52:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669218721; x=1700754721;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6ne8ydE7pKzkiu7r3g05XpgU2xo+eR0YxTixzH5yqn8=;
  b=hS8aUoNVybqnS+6/tmzJCP1kxknWFAB+fxaqAoraSdYRGZJ4aCoWbPr5
   EZgMb1L1Bfwzx4HF4F5D2wPtbcPdDsU16DxxgxQeNxc45l8NeDCgEfzxz
   mRxrMGzOG361ShTBiJHTpRPlDoLn0UjJyGbkJTn/7l9d6fs606U8tNSuE
   fkDv+FiywGhCgQycMgltDBm7MXxw9TUnQXmpmG6LGPAULwLT7varWEaKD
   Qw2eIGLKnvcwyyEpLl/9dIkUaOMKgctRxLFlvb9/1W3BG42/2XZVjAQqd
   4I3noQ7Tir+mKB0WowgSs/i7KIZrg65/XZacvxJ/qlmgegwyaGNwSSDKv
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="294483609"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="294483609"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 07:51:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="747840614"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="747840614"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga002.fm.intel.com with ESMTP; 23 Nov 2022 07:51:49 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2ANFpm4I000385;
        Wed, 23 Nov 2022 15:51:48 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: enetc: preserve TX ring priority across reconfiguration
Date:   Wed, 23 Nov 2022 16:51:16 +0100
Message-Id: <20221123155116.484163-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221122130936.1704151-1-vladimir.oltean@nxp.com>
References: <20221122130936.1704151-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Tue, 22 Nov 2022 15:09:36 +0200

> In the blamed commit, a rudimentary reallocation procedure for RX buffer
> descriptors was implemented, for the situation when their format changes
> between normal (no PTP) and extended (PTP).
> 
> enetc_hwtstamp_set() calls enetc_close() and enetc_open() in a sequence,
> and this sequence loses information which was previously configured in
> the TX BDR Mode Register, specifically via the enetc_set_bdr_prio() call.
> The TX ring priority is configured by tc-mqprio and tc-taprio, and
> affects important things for TSN such as the TX time of packets. The
> issue manifests itself most visibly by the fact that isochron --txtime
> reports premature packet transmissions when PTP is first enabled on an
> enetc interface.
> 
> Save the TX ring priority in a new field in struct enetc_bdr (occupies a
> 2 byte hole on arm64) in order to make this survive a ring reconfiguration.
> 
> Fixes: 434cebabd3a2 ("enetc: Add dynamic allocation of extended Rx BD rings")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/freescale/enetc/enetc.c  |  8 ++++---
>  drivers/net/ethernet/freescale/enetc/enetc.h  |  1 +
>  .../net/ethernet/freescale/enetc/enetc_qos.c  | 21 ++++++++++++-------
>  3 files changed, 19 insertions(+), 11 deletions(-)

[...]

>  	err = enetc_setup_taprio(ndev, taprio);
> -
> -	if (err)
> -		for (i = 0; i < priv->num_tx_rings; i++)
> -			enetc_set_bdr_prio(hw, priv->tx_ring[i]->index,
> -					   taprio->enable ? 0 : i);
> +	if (err) {
> +		for (i = 0; i < priv->num_tx_rings; i++) {
> +			tx_ring = priv->tx_ring[i];
> +			tx_ring->prio = taprio->enable ? 0 : i;

Side note: is that `taprio ? 0 : i` correct? It's an error path
IIUC, why not just unconditional 0?
I guess it is, so

Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>

> +			enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
> +		}
> +	}
>  
>  	return err;
>  }
> -- 
> 2.34.1

Thanks,
Olek
