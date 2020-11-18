Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A6C2B73B8
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 02:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgKRBVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 20:21:51 -0500
Received: from mga03.intel.com ([134.134.136.65]:40896 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727359AbgKRBVv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 20:21:51 -0500
IronPort-SDR: sFbfgEnJFJrYLy5VkkuTF9B/+JPlb8jsM4gh606QZn119y9aUKpf7GuVF5TCF/JD3CpmlmV75+
 RGDNhVKKYR9A==
X-IronPort-AV: E=McAfee;i="6000,8403,9808"; a="171143594"
X-IronPort-AV: E=Sophos;i="5.77,486,1596524400"; 
   d="scan'208";a="171143594"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2020 17:21:50 -0800
IronPort-SDR: FPn8pfqeTRrllz4kT4hF5E0RLenEnVSifImz/pmSo4YJt2hHf9eKLbdu8kWBnMfv3mG/I1Rvo2
 jTzrVO4Lvidw==
X-IronPort-AV: E=Sophos;i="5.77,486,1596524400"; 
   d="scan'208";a="310403267"
Received: from pnoll-mobl.amr.corp.intel.com (HELO ellie) ([10.255.230.106])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2020 17:21:49 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Miroslav Lichvar <mlichvar@redhat.com>,
        intel-wired-lan@lists.osuosl.org, andre.guedes@intel.com,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        bhelgaas@google.com
Subject: Re: [Intel-wired-lan] [PATCH next-queue v2 3/3] igc: Add support
 for PTP getcrosststamp()
In-Reply-To: <20201117014926.GA26272@hoboy.vegasvil.org>
References: <20201114025704.GA15240@hoboy.vegasvil.org>
 <874klo7pwp.fsf@intel.com> <20201117014926.GA26272@hoboy.vegasvil.org>
Date:   Tue, 17 Nov 2020 17:21:48 -0800
Message-ID: <87d00b5uj7.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Richard Cochran <richardcochran@gmail.com> writes:

> On Mon, Nov 16, 2020 at 05:06:30PM -0800, Vinicius Costa Gomes wrote:
>> The PTM dialogs are a pair of messages: a Request from the endpoint (in
>> my case, the NIC) to the PCIe root (or switch), and a Response from the
>> other side (this message includes the Master Root Time, and the
>> calculated propagation delay).
>> 
>> The interface exposed by the NIC I have allows basically to start/stop
>> these PTM dialogs (I was calling them PTM cycles) and to configure the
>> interval between each cycle (~1ms - ~512ms).
>
> Ah, now I am starting to understand...
>
> Just to be clear, this is yet another time measurement over PCIe,
> different than the cross time stamp that we already have, right?
>

Not so different. This series implement the getcrosststamp() function in
the igc driver, the difference from e1000e (another NIC driver that
supports getcrosststamp()) is that e1000e uses the fact that it has more
or less direct access to the CPU clock. In my case the access is less
direct as it happens via standardized PCIe PTM.

> Also, what is the point of providing time measurements every 1
> millisecond?

I sincerely have no idea. I had no power on how the hardware was
designed, and how PTM was implemented in HW.

>
>> Another thing of note, is that trying to start the PTM dialogs "on
>> demand" syncronously with the ioctl() doesn't seem too reliable, it
>> seems to want to be kept running for a longer time.
>
> So, I think the simplest thing would be to have a one-shot
> measurement, if possible.  Then you could use the existing API and let
> the user space trigger the time stamps.

Agreed that would be easiest/simplest. But what I have in hand seems to
not like it, i.e. I have an earlier series implementing this "one shot" way
and it's not reliable over long periods of time or against having the
system time adjusted.

So I think I am stuck with proposing a new API, if I am reading this
right.

Something like PTP_EXTTS_REQUEST is what was suggested, so
PTP_CROSSTS_REQUEST?

struct ptp_crossts_request {
	unsigned int index;
        struct ptp_clock_time period; /* Desired period, zero means disable */
	unsigned int flags;
	unsigned int rsv[2]; 
};

And a new event type, something like:

struct ptp_extts_event {
	struct ptp_clock_time hostts;
	struct ptp_clock_time devicets;
	unsigned int index;      
	unsigned int flags;      
};


Cheers,
-- 
Vinicius
