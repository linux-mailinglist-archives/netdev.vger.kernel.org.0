Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D35D82BB1DB
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 18:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729013AbgKTR6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 12:58:16 -0500
Received: from mga11.intel.com ([192.55.52.93]:45078 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728602AbgKTR6P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 12:58:15 -0500
IronPort-SDR: l9J0SIR+HoTcTURb201gksJlbWO+KH0tsF7q8PnbHL40TKdSaMd0Ka29btXA1Xj7i4+VpWw0Nu
 FDP03OJ/QwRg==
X-IronPort-AV: E=McAfee;i="6000,8403,9811"; a="168004979"
X-IronPort-AV: E=Sophos;i="5.78,357,1599548400"; 
   d="scan'208";a="168004979"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2020 09:58:15 -0800
IronPort-SDR: v/sTxd7qwryAj5uZni3OxkmBfo/XnOnKrjNiIsj/kIe4l7H2kfE8y+EXWppmTqEVaD5zeT1FPm
 HwQPf1pIVoQw==
X-IronPort-AV: E=Sophos;i="5.78,357,1599548400"; 
   d="scan'208";a="331399391"
Received: from deeppate-mobl1.amr.corp.intel.com (HELO ellie) ([10.212.22.160])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2020 09:58:14 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Miroslav Lichvar <mlichvar@redhat.com>,
        intel-wired-lan@lists.osuosl.org, andre.guedes@intel.com,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        bhelgaas@google.com
Subject: Re: [Intel-wired-lan] [PATCH next-queue v2 3/3] igc: Add support
 for PTP getcrosststamp()
In-Reply-To: <20201120141621.GC7027@hoboy.vegasvil.org>
References: <20201114025704.GA15240@hoboy.vegasvil.org>
 <874klo7pwp.fsf@intel.com> <20201117014926.GA26272@hoboy.vegasvil.org>
 <87d00b5uj7.fsf@intel.com> <20201118125451.GC23320@hoboy.vegasvil.org>
 <87wnyi2o1e.fsf@intel.com> <20201120141621.GC7027@hoboy.vegasvil.org>
Date:   Fri, 20 Nov 2020 09:58:14 -0800
Message-ID: <877dqf29mx.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

Richard Cochran <richardcochran@gmail.com> writes:

> On Wed, Nov 18, 2020 at 04:22:37PM -0800, Vinicius Costa Gomes wrote:
>
>> Talking with the hardware folks, they recommended using the periodic
>> method, the one shot method was implemented as a debug/evaluation aid.
>
> I'm guessing ...
>
> The HW generates pairs of time stamps, right?

Not exactly.

On the PTM protocol there are four timestamps involved:
 - T1, when the NIC sends the Request message;
 - T2, when the PCIe root receives the Request message;
 - T3, when the PCIe root sends the Response message;
 - T4, when the NIC receives the Response message;

The NIC registers expose these values (I am using ' to indicate
timestamps captured on the previous cycle):
 - T1 (on this cycle);
 - T2 and T2' (on this and on the previous cycle);
 - (T4 - T1) and (T4' - T1') (on this and on the previous cycle);
 - (T3' - T2') (on the previous cycle).

Yeah, applications would be most interested in a pair (host, device)
timestamps, but as Miroslav said, a third value expressing the
propagation delay from those values could be also useful.

>
> And these land in the device driver by means of an interrupt, right?

Again, not exactly. I have to either poll for a "valid bit" on a status
register or wait for a "fake" (all zeroes source and destination
addresses) ethernet frame to arrive on a specific queue.

Just for information the "fake" packet has different information:
 - T1 (on this cycle);
 - T2 (on this cycle);
 - (T4' - T1') (on the previous cycle);
 - (T3 - T2) (on this cycle);

>
> If that is so, then maybe the best way to expose the pair to user
> space is to have a readable character device, like we have for the
> PTP_EXTTS_REQUEST2.  The ioctl to enable reporting could also set the
> message rate.

Sounds reasonable.

>
> Although it will be a bit clunky, it looks like we have reserved room
> enough for a second, eight-byte time stamp.

The question is if we want to also expose some of the other values.


Cheers,
-- 
Vinicius
