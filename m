Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F072246D3
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 01:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbgGQXMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 19:12:09 -0400
Received: from mga06.intel.com ([134.134.136.31]:16431 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726204AbgGQXMJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 19:12:09 -0400
IronPort-SDR: 9lRTACR2e57CYWiL2YvNST/uX7QYQa2DrnRebV0iRznLPYNbKXnznifgklxcRxHZknaxRr7rxd
 i/9Slf1ZpMIQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9685"; a="211237203"
X-IronPort-AV: E=Sophos;i="5.75,364,1589266800"; 
   d="scan'208";a="211237203"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2020 16:12:08 -0700
IronPort-SDR: r3Pv3y1pRRzb7HrJkL66EuGBr77zpSXrIYXL4aC35HMHvuPk8EnNn9b4muA30qMOhEpbESHRBl
 Vu3QUXTCprxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,364,1589266800"; 
   d="scan'208";a="461014472"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.94.160]) ([10.212.94.160])
  by orsmga005.jf.intel.com with ESMTP; 17 Jul 2020 16:12:07 -0700
Subject: Re: [PATCH net-next 3/3] docs: networking: timestamping: add a set of
 frequently asked questions
To:     Vladimir Oltean <olteanv@gmail.com>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, sorganov@gmail.com,
        linux-doc@vger.kernel.org
References: <20200717161027.1408240-1-olteanv@gmail.com>
 <20200717161027.1408240-4-olteanv@gmail.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <e6b6f240-c2b2-b57c-7334-4762f034aae3@intel.com>
Date:   Fri, 17 Jul 2020 16:12:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200717161027.1408240-4-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/17/2020 9:10 AM, Vladimir Oltean wrote:
> These are some questions I had while trying to explain the behavior of
> some drivers with respect to software timestamping. Answered with the
> help of Richard Cochran.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>  Documentation/networking/timestamping.rst | 26 +++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/Documentation/networking/timestamping.rst b/Documentation/networking/timestamping.rst
> index 4004c5d2771d..e01ec01179fe 100644
> --- a/Documentation/networking/timestamping.rst
> +++ b/Documentation/networking/timestamping.rst
> @@ -791,3 +791,29 @@ The correct solution to this problem is to implement the PHY timestamping
>  requirements in the MAC driver found broken, and submit as a bug fix patch to
>  netdev@vger.kernel.org. See :ref:`Documentation/process/stable-kernel-rules.rst
>  <stable_kernel_rules>` for more details.
> +
> +3.4 Frequently asked questions
> +------------------------------
> +
> +Q: When should drivers set SKBTX_IN_PROGRESS?
> +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> +
> +When the interface they represent offers both ``SOF_TIMESTAMPING_TX_HARDWARE``
> +and ``SOF_TIMESTAMPING_TX_SOFTWARE``.
> +Originally, the network stack could deliver either a hardware or a software
> +time stamp, but not both. This flag prevents software timestamp delivery.
> +This restriction was eventually lifted via the ``SOF_TIMESTAMPING_OPT_TX_SWHW``
> +option, but still the original behavior is preserved as the default.
> +

So, this implies that we set this only if both are supported? I thought
the intention was to set this flag whenever we start a HW timestamp.

> +Q: Should drivers that don't offer SOF_TIMESTAMPING_TX_SOFTWARE call skb_tx_timestamp()?
> +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> +
> +The ``skb_clone_tx_timestamp()`` function from its body helps with propagation
> +of TX timestamps from PTP PHYs, and the required placement of this call is the
> +same as for software TX timestamping.
> +Additionally, since PTP is broken on ports with timestamping PHYs and unmet
> +requirements, the consequence is that any driver which may be ever coupled to
> +a timestamping-capable PHY in ``netdev->phydev`` should call at least
> +``skb_clone_tx_timestamp()``. However, calling the higher-level
> +``skb_tx_timestamp()`` instead achieves the same purpose, but also offers
> +additional compliance to ``SOF_TIMESTAMPING_TX_SOFTWARE``.
> 

This makes sense.

Thanks,
Jake
