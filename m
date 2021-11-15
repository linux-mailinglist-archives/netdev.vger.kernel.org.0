Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFD52450779
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 15:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbhKOOvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 09:51:21 -0500
Received: from mga05.intel.com ([192.55.52.43]:52838 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230038AbhKOOvK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 09:51:10 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10168"; a="319662285"
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="319662285"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 06:48:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="494043353"
Received: from mylly.fi.intel.com (HELO [10.237.72.160]) ([10.237.72.160])
  by orsmga007.jf.intel.com with ESMTP; 15 Nov 2021 06:48:01 -0800
Subject: Re: [PATCH net 1/4] can: m_can: pci: fix incorrect reference clock
 rate
To:     Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Felipe Balbi (Intel)" <balbi@kernel.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1636967198.git.matthias.schiffer@ew.tq-group.com>
 <c9cf3995f45c363e432b3ae8eb1275e54f009fc8.1636967198.git.matthias.schiffer@ew.tq-group.com>
From:   Jarkko Nikula <jarkko.nikula@linux.intel.com>
Message-ID: <48d37d59-e7d1-e151-4201-1dcc151819fe@linux.intel.com>
Date:   Mon, 15 Nov 2021 16:48:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <c9cf3995f45c363e432b3ae8eb1275e54f009fc8.1636967198.git.matthias.schiffer@ew.tq-group.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

On 11/15/21 11:18 AM, Matthias Schiffer wrote:
> When testing the CAN controller on our Ekhart Lake hardware, we
> determined that all communication was running with twice the configured
> bitrate. Changing the reference clock rate from 100MHz to 200MHz fixed
> this. Intel's support has confirmed to us that 200MHz is indeed the
> correct clock rate.
> 
> Fixes: cab7ffc0324f ("can: m_can: add PCI glue driver for Intel Elkhart Lake")
> Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> ---
>   drivers/net/can/m_can/m_can_pci.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/can/m_can/m_can_pci.c b/drivers/net/can/m_can/m_can_pci.c
> index 89cc3d41e952..d3c030a13cbe 100644
> --- a/drivers/net/can/m_can/m_can_pci.c
> +++ b/drivers/net/can/m_can/m_can_pci.c
> @@ -18,7 +18,7 @@
>   
>   #define M_CAN_PCI_MMIO_BAR		0
>   
> -#define M_CAN_CLOCK_FREQ_EHL		100000000
> +#define M_CAN_CLOCK_FREQ_EHL		200000000
>   #define CTL_CSR_INT_CTL_OFFSET		0x508
>   
I'll double check this from HW people but at quick test on an HW I have 
the signals on an oscilloscope were having 1 us shortest cycle (~500 ns 
low, ~500 ns high) when testing like below:

ip link set can0 type can bitrate 1000000 dbitrate 2000000 fd on
ip link set can0 up
ip link set can1 type can bitrate 1000000 dbitrate 2000000 fd on
ip link set can1 up

candump can0 &

cansend can1 01a#11223344AABBCCDD

Caveat: I'm not an CAN signaling expert at all.

Jarkko
