Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 271A02AFB84
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 23:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbgKKWkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 17:40:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:3574 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbgKKWiV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 17:38:21 -0500
IronPort-SDR: 1o/TxpjZbXBLfuwiC/moV2dsaPefQsFzxg1v7VyyDjQXDOlJmbI2/TPd5FJCAA57xvpLZQBoPI
 QAev7h5H6jqA==
X-IronPort-AV: E=McAfee;i="6000,8403,9802"; a="157243143"
X-IronPort-AV: E=Sophos;i="5.77,470,1596524400"; 
   d="scan'208";a="157243143"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2020 14:23:30 -0800
IronPort-SDR: hGsxbfaYRvdWk35pTBUKpOW8JOJVfq1oGMb5usGf4KNU/tYgcJe7uNyzqYS88ZIKvSDQ6XPS4D
 +gQjyFmkcKKg==
X-IronPort-AV: E=Sophos;i="5.77,470,1596524400"; 
   d="scan'208";a="541980922"
Received: from mcalqui1-mobl.amr.corp.intel.com (HELO ellie) ([10.212.84.222])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2020 14:23:30 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Miroslav Lichvar <mlichvar@redhat.com>
Cc:     intel-wired-lan@lists.osuosl.org, andre.guedes@intel.com,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        bhelgaas@google.com
Subject: Re: [Intel-wired-lan] [PATCH next-queue v2 3/3] igc: Add support
 for PTP getcrosststamp()
In-Reply-To: <20201111093346.GE1559650@localhost>
References: <20201110061019.519589-1-vinicius.gomes@intel.com>
 <20201110061019.519589-4-vinicius.gomes@intel.com>
 <20201110180719.GA1559650@localhost> <871rh19gm8.fsf@intel.com>
 <20201111093346.GE1559650@localhost>
Date:   Wed, 11 Nov 2020 14:23:28 -0800
Message-ID: <87tutv8rdr.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Miroslav Lichvar <mlichvar@redhat.com> writes:

> On Tue, Nov 10, 2020 at 11:06:07AM -0800, Vinicius Costa Gomes wrote:
>> Miroslav Lichvar <mlichvar@redhat.com> writes:
>> > I suspect the estimate would be valid only when the NIC is connected
>> > directly to the PTM root (PCI root complex). Is it possible to get the
>> > timestamps or delay from PTM-capable switches on the path between CPU
>> > and NIC? Also, how frequent can be the PTM dialogs? Could they be
>> > performed synchronously in the ioctl?
>> 
>> Reading the PTM specs, it could work over PCIe switches (if they also
>> support PTM).
>
> I saw some "implementation specific means" mentioned in the spec, so
> I'm not sure what and how exactly it works with the existing CPUs,
> NICs and PCIe switches. But even if the reported delay was valid only
> for directly connected NICs, I think that could still be useful as
> long as the user/application can figure out whether that is the case.

Right now, the logic I am using is that the PTM cycles (and measurement
reporting) are started only if PTM could be enabled in the endpoint PCI
device. If I understand the code right, PTM will only be enabled if it
could be enabled all along the path to the root port.

In other words, what this series does is: if the CONFIG_PCIE_PTM option
is enabled, and if PTM is supported along the path to the NIC, the PTM
cycles will be started during the device initialization, and the
measurements will be reported when the ioctl() is called.

>
>> The NIC I have supports PTM cycles from every ~1ms to ~512ms, and from
>> my tests it wants to be kept running "in background" always, i.e. set
>> the cycles to run, and only report the data when necessary. Trying to
>> only enable the cycles "on demand" was unreliable.
>
> I see. It does makes sense if the clocks need to be are synchronized.
> For the case of this ioctl, I think it would be better if it we could
> just collect the measurements and leave the clocks free running.

Not sure if I understand. This is what this series does, it only adds
support for starting the PTM cycles and reporting the measurements.

>
>> (so for the _EXTENDED case, I would need to accumulate multiple values
>> in the driver, and report them later, a bit annoying, but not
>> impossible)
>
> I think you could simply repeat the sample in the output up to the
> requested number.
>
> I suspect a bigger issue, for both the PRECISE and EXTENDED variants,
> is that it would return old data. I'm not sure if the existing
> applications are ready to deal with that. With high clock update
> rates, a delay of 50 milliseconds could cause an instability. You can
> try phc2sys -R 50 and see if it stays stable.

After a couple of hours of testing, with the current 50ms delay,
'phc2sys -R 50' is stable, but I got the impression that it takes longer
(~10s) to get to ~10ns offset.

Just for fun, I tried 'phc2sys -R 100' and it doesn't stabilize.

So it seems that applications (phc2sys) are able to tolerate some old
data.


Cheers,
-- 
Vinicius
