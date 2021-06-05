Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB59339C658
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 08:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhFEGot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 02:44:49 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:55687 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229688AbhFEGor (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Jun 2021 02:44:47 -0400
Received: from [192.168.0.3] (ip5f5aeece.dynamic.kabel-deutschland.de [95.90.238.206])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 6746C61E646D4;
        Sat,  5 Jun 2021 08:42:59 +0200 (CEST)
Subject: Re: [Intel-wired-lan] [PATCH next-queue v5 3/4] igc: Enable PCIe PTM
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        intel-wired-lan@lists.osuosl.org
Cc:     linux-pci@vger.kernel.org, richardcochran@gmail.com,
        hch@infradead.org, netdev@vger.kernel.org, bhelgaas@google.com,
        helgaas@kernel.org
References: <20210605002356.3996853-1-vinicius.gomes@intel.com>
 <20210605002356.3996853-4-vinicius.gomes@intel.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <70d32740-eb4b-f7bf-146e-8dc06199d6c9@molgen.mpg.de>
Date:   Sat, 5 Jun 2021 08:42:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210605002356.3996853-4-vinicius.gomes@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Vinicius,


Am 05.06.21 um 02:23 schrieb Vinicius Costa Gomes:
> Enables PCIe PTM (Precision Time Measurement) support in the igc
> driver. Notifies the PCI devices that PCIe PTM should be enabled.
> 
> PCIe PTM is similar protocol to PTP (Precision Time Protocol) running
> in the PCIe fabric, it allows devices to report time measurements from
> their internal clocks and the correlation with the PCIe root clock.
> 
> The i225 NIC exposes some registers that expose those time
> measurements, those registers will be used, in later patches, to
> implement the PTP_SYS_OFFSET_PRECISE ioctl().
> 
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---
>   drivers/net/ethernet/intel/igc/igc_main.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index a05e6d8ec660..f23d0303e53b 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -12,6 +12,8 @@
>   #include <net/pkt_sched.h>
>   #include <linux/bpf_trace.h>
>   #include <net/xdp_sock_drv.h>
> +#include <linux/pci.h>
> +
>   #include <net/ipv6.h>
>   
>   #include "igc.h"
> @@ -5864,6 +5866,10 @@ static int igc_probe(struct pci_dev *pdev,
>   
>   	pci_enable_pcie_error_reporting(pdev);
>   
> +	err = pci_enable_ptm(pdev, NULL);
> +	if (err < 0)
> +		dev_err(&pdev->dev, "PTM not supported\n");
> +

Sorry, if I am missing something, but do all devices supported by this 
driver support PTM or only the i225 NIC? In that case, it wouldn’t be an 
error for a device not supporting PTM, would it?

>   	pci_set_master(pdev);
>   
>   	err = -ENOMEM;
> 


Kind regards,

Paul
