Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263253A6E6A
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 20:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233295AbhFNSws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 14:52:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232802AbhFNSwr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 14:52:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45DDE61241;
        Mon, 14 Jun 2021 18:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623696644;
        bh=uzeKfLPfAWmRjvc6DNl0fYk/iZvktKEtkT3rI+2VhoQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QK5Yx64V9e4wGfc/uCCAAwZBDoCQL80Yi9ue++0YN5EpZPIdH18/spjlBPTqrWAO5
         3v4ZKF9q2H6+NT/fU1pNoA1vCfebf3kkQYEHuMunpqZ4fBmLh2ZUKiHaPnzQ3DZ9PO
         3B4bQg4iQBiw+g7c2IiYinxZKROooqWH6orRa5Y6SDYJIUmQrYnFWOcGiPTOIGVSwJ
         K7WBQfy5qk/KCFM+jyL3Fmhhbm4eO+zNLPIhYVXZlwxS2BpJBQ/RULm1oRJ+5dqRcK
         15oidvDzgv2WxKHHnuNCCYyxz/g70WK4tkts9bVcVgH/j33ehyOnA+fhanV/D4QM//
         hHi4jy4hVh24w==
Date:   Mon, 14 Jun 2021 11:50:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        netdev@vger.kernel.org, sassmann@redhat.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: Re: [PATCH net-next 5/8] ice: register 1588 PTP clock device object
 for E810 devices
Message-ID: <20210614115043.4e2b48da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210614181218.GA7788@localhost>
References: <20210611162000.2438023-1-anthony.l.nguyen@intel.com>
        <20210611162000.2438023-6-anthony.l.nguyen@intel.com>
        <20210611141800.5ebe1d4e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ca27bafc-fdc2-c5f1-fc37-1cdf48d393b2@intel.com>
        <20210614181218.GA7788@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Jun 2021 11:12:20 -0700 Richard Cochran wrote:
> On Mon, Jun 14, 2021 at 09:43:17AM -0700, Jacob Keller wrote:
> > > Since dialed_freq is updated regardless of return value of .adjfine 
> > > the driver has no clear way to reject bad scaled_ppm>  
> > 
> > I'm not sure. +Richard?  
> 
> The driver advertises "max_adj".  The PHC layer checks user space inputs:
> 
> ptp_clock.c line 140:
> 	} else if (tx->modes & ADJ_FREQUENCY) {
> 		s32 ppb = scaled_ppm_to_ppb(tx->freq);
> 		if (ppb > ops->max_adj || ppb < -ops->max_adj)
> 			return -ERANGE;
> 
> So, if the max_adj is correct for the driver/HW, then all is well.

tx->freq is a long, and the conversion to ppb can overflow the s32 type.
E.g. 281474976645 will become -2 AFAICT. I hacked up phc_ctl to not do
range checking and kernel happily accepted that value. Shall we do this?

--->8----

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index 03a246e60fd9..ed32fc98d9d8 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -63,7 +63,7 @@ static void enqueue_external_timestamp(struct timestamp_event_queue *queue,
        spin_unlock_irqrestore(&queue->lock, flags);
 }
 
-s32 scaled_ppm_to_ppb(long ppm)
+s64 scaled_ppm_to_ppb(long ppm)
 {
        /*
         * The 'freq' field in the 'struct timex' is in parts per
@@ -80,7 +80,7 @@ s32 scaled_ppm_to_ppb(long ppm)
        s64 ppb = 1 + ppm;
        ppb *= 125;
        ppb >>= 13;
-       return (s32) ppb;
+       return ppb;
 }
 EXPORT_SYMBOL(scaled_ppm_to_ppb);
 
@@ -138,7 +138,7 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
                delta = ktime_to_ns(kt);
                err = ops->adjtime(ops, delta);
        } else if (tx->modes & ADJ_FREQUENCY) {
-               s32 ppb = scaled_ppm_to_ppb(tx->freq);
+               s64 ppb = scaled_ppm_to_ppb(tx->freq);
                if (ppb > ops->max_adj || ppb < -ops->max_adj)
                        return -ERANGE;
                if (ops->adjfine)
