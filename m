Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41343F6FD8
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 09:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfKKIns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 03:43:48 -0500
Received: from mga06.intel.com ([134.134.136.31]:35315 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726804AbfKKInr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 03:43:47 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Nov 2019 00:43:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,292,1569308400"; 
   d="scan'208";a="405132573"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga006.fm.intel.com with ESMTP; 11 Nov 2019 00:43:43 -0800
Received: from andy by smile with local (Exim 4.93-RC1)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1iU5IV-0006mB-6r; Mon, 11 Nov 2019 10:43:43 +0200
Date:   Mon, 11 Nov 2019 10:43:43 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Stephan Gerhold <stephan@gerhold.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        =?iso-8859-1?Q?Cl=E9ment?= Perrochaud 
        <clement.perrochaud@effinnov.com>,
        Charles Gorand <charles.gorand@effinnov.com>,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sedat Dilek <sedat.dilek@credativ.de>
Subject: Re: [PATCH] NFC: nxp-nci: Fix NULL pointer dereference after I2C
 communication error
Message-ID: <20191111084343.GM32742@smile.fi.intel.com>
References: <20191110161915.11059-1-stephan@gerhold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191110161915.11059-1-stephan@gerhold.net>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 10, 2019 at 05:19:15PM +0100, Stephan Gerhold wrote:
> I2C communication errors (-EREMOTEIO) during the IRQ handler of nxp-nci
> result in a NULL pointer dereference at the moment:
> 
>     BUG: kernel NULL pointer dereference, address: 0000000000000000
>     Oops: 0002 [#1] PREEMPT SMP NOPTI
>     CPU: 1 PID: 355 Comm: irq/137-nxp-nci Not tainted 5.4.0-rc6 #1
>     RIP: 0010:skb_queue_tail+0x25/0x50
>     Call Trace:
>      nci_recv_frame+0x36/0x90 [nci]
>      nxp_nci_i2c_irq_thread_fn+0xd1/0x285 [nxp_nci_i2c]
>      ? preempt_count_add+0x68/0xa0
>      ? irq_forced_thread_fn+0x80/0x80
>      irq_thread_fn+0x20/0x60
>      irq_thread+0xee/0x180
>      ? wake_threads_waitq+0x30/0x30
>      kthread+0xfb/0x130
>      ? irq_thread_check_affinity+0xd0/0xd0
>      ? kthread_park+0x90/0x90
>      ret_from_fork+0x1f/0x40
> 
> Afterward the kernel must be rebooted to work properly again.
> 
> This happens because it attempts to call nci_recv_frame() with skb == NULL.
> However, unlike nxp_nci_fw_recv_frame(), nci_recv_frame() does not have any
> NULL checks for skb, causing the NULL pointer dereference.
> 
> Change the code to call only nxp_nci_fw_recv_frame() in case of an error.
> Make sure to log it so it is obvious that a communication error occurred.
> The error above then becomes:
> 
>     nxp-nci_i2c i2c-NXP1001:00: NFC: Read failed with error -121
>     nci: __nci_request: wait_for_completion_interruptible_timeout failed 0
>     nxp-nci_i2c i2c-NXP1001:00: NFC: Read failed with error -121
> 

FWIW,
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> Fixes: 6be88670fc59 ("NFC: nxp-nci_i2c: Add I2C support to NXP NCI driver")
> Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
> ---
> Note: Not sure why NFC is broken on this laptop (a Lenovo ThinkPad L490).
> It runs into the I2C communication errors immediately when enabling NFC.
> This patch fixes the NULL pointer dereference at least.
> ---
>  drivers/nfc/nxp-nci/i2c.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
> index 307bd2afbe05..4d1909aecd6c 100644
> --- a/drivers/nfc/nxp-nci/i2c.c
> +++ b/drivers/nfc/nxp-nci/i2c.c
> @@ -220,8 +220,10 @@ static irqreturn_t nxp_nci_i2c_irq_thread_fn(int irq, void *phy_id)
>  
>  	if (r == -EREMOTEIO) {
>  		phy->hard_fault = r;
> -		skb = NULL;
> -	} else if (r < 0) {
> +		if (info->mode == NXP_NCI_MODE_FW)
> +			nxp_nci_fw_recv_frame(phy->ndev, NULL);
> +	}
> +	if (r < 0) {
>  		nfc_err(&client->dev, "Read failed with error %d\n", r);
>  		goto exit_irq_handled;
>  	}
> -- 
> 2.23.0
> 

-- 
With Best Regards,
Andy Shevchenko


