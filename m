Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5872B244E
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 20:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbgKMTLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 14:11:03 -0500
Received: from mga18.intel.com ([134.134.136.126]:60325 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbgKMTLC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 14:11:02 -0500
IronPort-SDR: MyIHhkDeBBkEfjK9ipXNQY8HOwQ6LMyOK0Mc3ignxiY+SLLzUl4DircCy/1rjZAmejz6fhkcQc
 qjjMsKKv1F2Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9804"; a="158295891"
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="158295891"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 11:11:01 -0800
IronPort-SDR: 2ZUWuBsCzrCVLk1Fms9JjoxN5AUnawZsXeA3Qr8RIGcleHcszqlH9beDJgNO6SEDM0Vz5M2/c4
 WktQc6Zg9KFw==
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="532675890"
Received: from ajdrisco-mobl.amr.corp.intel.com (HELO ellie) ([10.255.231.72])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 11:11:00 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Miroslav Lichvar <mlichvar@redhat.com>,
        intel-wired-lan@lists.osuosl.org, andre.guedes@intel.com,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        bhelgaas@google.com
Subject: Re: [Intel-wired-lan] [PATCH next-queue v2 3/3] igc: Add support
 for PTP getcrosststamp()
In-Reply-To: <20201113032451.GB32138@hoboy.vegasvil.org>
References: <20201112093203.GH1559650@localhost> <87pn4i6svv.fsf@intel.com>
 <20201113032451.GB32138@hoboy.vegasvil.org>
Date:   Fri, 13 Nov 2020 11:10:58 -0800
Message-ID: <87ima96pj1.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

Richard Cochran <richardcochran@gmail.com> writes:

> On Thu, Nov 12, 2020 at 03:46:12PM -0800, Vinicius Costa Gomes wrote:
>> I wanted it so using PCIe PTM was transparent to applications, so adding
>> another API wouldn't be my preference.
>> 
>> That being said, having a trigger from the application to start/stop the
>> PTM cycles doesn't sound too bad an idea. So, not too opposed to this
>> idea.
>> 
>> Richard, any opinions here?
>
> Sorry, I only have the last two message from this thread, and so I'm
> missing the backstory.

No worries. The not so short version of the story is this:

I am proposing a series that adds support for PCIe PTM (for the igc
driver), exporting the values via the PTP_SYS_OFFSET_PRECISE ioctl().

The way PTM works in the NIC I have, kind of forces me to start the PTM
dialogs during initialization, and they are kept running in background,
what the _PRECISE ioctl() does is basically collecting the most recent
measurement.

Miroslav is suggesting that a new API, similar to PTP_EXTTS_REQUEST,
would be a good idea.

This new API idea has a few nice "pros":
 - I can use it to trigger starting the PTM cycles (instead of starting
 PTM during initialization), and the application would potentially have
 access to all the measurements;
 - Right now, keeping the PTM cycles always running would probably have
 an impact in power comsuption/number of wake-ups, with this new API,
 this price would only be paid when the user wants.

The main "con" would be that it wouldn't be transparent to applications
(phc2sys), as it would have to use another API if it wants to take
advantage of PTM.

And so question is, what is your opinion on this: export the PTM
measurements using some "to be defined" new API or keep using some of
the PTP_SYS_OFFSET_* ioctls?

I think that's it. Miroslav, feel free to correct me if I missed
something.


Cheers,
-- 
Vinicius
