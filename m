Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9DE61F8C8
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 17:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbiKGQRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 11:17:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232461AbiKGQRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 11:17:02 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E606466;
        Mon,  7 Nov 2022 08:17:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667837821; x=1699373821;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5CmWRdas0pQcgH+5XcFqoniBpxZT92/HEksRj+lSXd0=;
  b=ZI9OxNy+rxIqvPW9vM+8gOCQ2hZYlXLqoAHnjpyb0NSF/PST7bR2N9lG
   i8jSsfFHSs2EueyL698EqlfEerNe9RZcx66Yppi6g4Ghww9jbbj5Uty+k
   KgZJoSnkq4UQfZ82Mb6HtRBxplCXRfSnkutFucboDGCXgWvjjzCHgG86O
   RBjMgJ2E4WBRHZjsBPPRJn/VjgK6u9hRTc+XGys/FepSi9lmacGHWI+Cf
   0EkKVmfXt6QuIj+i6AYmw2PuJHDP3XjLOPAKr1seNL+ZvNtPiZe03q/7+
   I+L3XXdmvwrX+yG7fFzl2avtD383Z1nr51bUg1XgPrbh7Gww6wDPfxVj1
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="308074901"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="308074901"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 08:17:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="704933794"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="704933794"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga004.fm.intel.com with ESMTP; 07 Nov 2022 08:16:58 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2A7GGvID021262;
        Mon, 7 Nov 2022 16:16:57 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Alexander Lobakin <alexander.lobakin@intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        linux@armlinux.org.uk
Subject: Re: [PATCH net-next v2 3/4] net: lan966x: Add basic XDP support
Date:   Mon,  7 Nov 2022 17:13:57 +0100
Message-Id: <20221107161357.556549-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221106211154.3225784-4-horatiu.vultur@microchip.com>
References: <20221106211154.3225784-1-horatiu.vultur@microchip.com> <20221106211154.3225784-4-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alexander.lobakin@intel.com>

From: Horatiu Vultur <horatiu.vultur@microchip.com>
Date: Sun, 6 Nov 2022 22:11:53 +0100

> Introduce basic XDP support to lan966x driver. Currently the driver
> supports only the actions XDP_PASS, XDP_DROP and XDP_ABORTED.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  .../net/ethernet/microchip/lan966x/Makefile   |  3 +-
>  .../ethernet/microchip/lan966x/lan966x_fdma.c | 11 ++-
>  .../ethernet/microchip/lan966x/lan966x_main.c |  5 ++
>  .../ethernet/microchip/lan966x/lan966x_main.h | 13 +++
>  .../ethernet/microchip/lan966x/lan966x_xdp.c  | 81 +++++++++++++++++++
>  5 files changed, 111 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c

[...]

> +bool lan966x_xdp_port_present(struct lan966x_port *port)
> +{
> +	return !!port->xdp_prog;
> +}

Why uninline such a simple check? I realize you want to keep all XDP
stuff inside in the separate file, but doesn't this one looks too
much?

> +
> +int lan966x_xdp_port_init(struct lan966x_port *port)
> +{
> +	struct lan966x *lan966x = port->lan966x;
> +
> +	return xdp_rxq_info_reg(&port->xdp_rxq, port->dev, 0,
> +				lan966x->napi.napi_id);
> +}
> +
> +void lan966x_xdp_port_deinit(struct lan966x_port *port)
> +{
> +	if (xdp_rxq_info_is_reg(&port->xdp_rxq))
> +		xdp_rxq_info_unreg(&port->xdp_rxq);
> +}
> -- 
> 2.38.0

Thanks,
Olek
