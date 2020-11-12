Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8A3C2B01FC
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 10:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbgKLJcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 04:32:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37121 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726061AbgKLJcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 04:32:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605173530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=W4rr1GqJf/+uu0VkLhG4q2/u5hTt2/5s5Ib9+I3BFQE=;
        b=RR+BQaQ+5tqBKD+Nd/KrYYoj/65jTvuy8gom/ZEjP+xz59eOqKR+5WSZGocCTCar+n5PoR
        z6HV+SXR/iJ8VWIq3DpAnQGtd7qtQRAy9jD4b5WtICDy+e5h7s5ruPUE5qVZC6DSXCw2uH
        1Ec4Nekbl+RmPIwODwOtLq+3wtnCwLM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-541-WnWs5QdYMI-kUdMBsptDIg-1; Thu, 12 Nov 2020 04:32:08 -0500
X-MC-Unique: WnWs5QdYMI-kUdMBsptDIg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 938375705D;
        Thu, 12 Nov 2020 09:32:06 +0000 (UTC)
Received: from localhost (holly.tpb.lab.eng.brq.redhat.com [10.43.134.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B6A91A92A;
        Thu, 12 Nov 2020 09:32:04 +0000 (UTC)
Date:   Thu, 12 Nov 2020 10:32:03 +0100
From:   Miroslav Lichvar <mlichvar@redhat.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, andre.guedes@intel.com,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        bhelgaas@google.com, Richard Cochran <richardcochran@gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH next-queue v2 3/3] igc: Add support for
 PTP getcrosststamp()
Message-ID: <20201112093203.GH1559650@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87imab8l53.fsf@intel.com>
 <87tutv8rdr.fsf@intel.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 02:23:28PM -0800, Vinicius Costa Gomes wrote:
> Miroslav Lichvar <mlichvar@redhat.com> writes:
> > On Tue, Nov 10, 2020 at 11:06:07AM -0800, Vinicius Costa Gomes wrote:
> >> The NIC I have supports PTM cycles from every ~1ms to ~512ms, and from
> >> my tests it wants to be kept running "in background" always, i.e. set
> >> the cycles to run, and only report the data when necessary. Trying to
> >> only enable the cycles "on demand" was unreliable.
> >
> > I see. It does makes sense if the clocks need to be are synchronized.
> > For the case of this ioctl, I think it would be better if it we could
> > just collect the measurements and leave the clocks free running.
> 
> Not sure if I understand. This is what this series does, it only adds
> support for starting the PTM cycles and reporting the measurements.

Ok, great. I meant that the apparent requirement to keep the
measurements running periodically in background made sense if the
clocks were synchronized by the hardware. Now I realize that wouldn't
work for phc2sys unless there was a separate clock and something
tracking the offset between the two clocks.

Considering how the existing applications work, ideally the
measurements would be performed on demand from the ioctl to minimize
the delay. If that's not possible, maybe it would be better to provide
the measurements on a descriptor at their own rate, which could be
polled by the applications, similarly to how the PTP_EXTTS_REQUEST
ioctl works?

> > I suspect a bigger issue, for both the PRECISE and EXTENDED variants,
> > is that it would return old data. I'm not sure if the existing
> > applications are ready to deal with that. With high clock update
> > rates, a delay of 50 milliseconds could cause an instability. You can
> > try phc2sys -R 50 and see if it stays stable.
> 
> After a couple of hours of testing, with the current 50ms delay,
> 'phc2sys -R 50' is stable, but I got the impression that it takes longer
> (~10s) to get to ~10ns offset.

That sounds like it could break in some specific conditions. Please
try slightly different -R values and when it's running, try inserting
a step with date -s '+0.1 sec' and see how reliable is the recovery.
You can also test it with a different servo: phc2sys -E linreg.

> There might be a problem, the PTM dialogs start from the device, the
> protocol is more or less this:
> 
>  1. NIC sends "Request" message, takes T1 timestamp;
>  2. Host receives "Request" message, takes T2 timestamp;
>  3. Host sends "Response" message, takes T3 timestamp;
>  4. NIC receives "Response" message, takes T4 timestamp;
> 
> So, T2 and T3 are "host" timestamps and T1 and T4 are NIC timestamps.

Is that the case even when there is a PTM-enabled switch between the
CPU and NIC? My understanding of the spec is that the switches are
supposed to have their own clocks and have separate PTM dialogs on
their upstream and downstream ports. In terms of PTP, are the switches
boundary or transparent clocks?

> That means that the timestamps I have "as is" are a bit different than
> the expectations of the EXTENDED ioctl().
> 
> Of course I could use T3 (as the "pre" timestamp), T4 as the device
> timestamp, and calculate the delay[1], apply it to T3 and get something
> T3' as the "post" timestamp (T3' = T3 + delay). But I feel that this
> "massaging" would defeat the purpose of using the EXTENDED variant.
> 
> Does it make sense? Am I worrying too much?
> 
> [1] 
> 	delay = ((T4 - T1) - (T3 - T2)) / 2

Yes, I think that would work, except the delay would need to be
doubled in the T3' calculation. The important thing is that the offset
and delay calculated from the timestamps don't change. It might be
better to shift the timestamps back to avoid the "post" timestamp
coming from future, which applications could drop as invalid. To not
shift the middlepoints in the conversion, this should work:

T1' = (T2 + T3) / 2 - delay
T2' = (T1 + T4) / 2
T3' = (T2 + T3) / 2 + delay

-- 
Miroslav Lichvar

