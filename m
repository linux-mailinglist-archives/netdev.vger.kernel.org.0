Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACA31BEEA
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 23:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbfEMVBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 17:01:37 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:40218 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfEMVBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 17:01:37 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id x4DL1QOD114594;
        Mon, 13 May 2019 16:01:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1557781286;
        bh=/2YunYeZgtX9isacNDSmuvnU5VTml5eXOQXlaf/FIoM=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=mKPNG7TMzeYbL2OFHlInm3QHvc5p7ViVccl3rbSR+4iKmbjLv+gzI/C+gW7XuwZyP
         6mYwfnqjO+/io1dEsOcRV/VTpztiFy9pVZzZ3ouFeGdWO+W21t0McBkf1Nnevh0Sml
         RcAn3avguKA3lHhmhl3bBLYeQuSZkDhpBJFTrEGg=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x4DL1Qn5123360
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 13 May 2019 16:01:26 -0500
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Mon, 13
 May 2019 16:01:25 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Mon, 13 May 2019 16:01:25 -0500
Received: from [158.218.117.39] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id x4DL1PXN052692;
        Mon, 13 May 2019 16:01:25 -0500
Subject: Re: [PATCH net-next v1 0/4] net/sched: taprio change schedules
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        <netdev@vger.kernel.org>
CC:     <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <olteanv@gmail.com>, <timo.koskiahde@tttech.com>
References: <20190429224833.18208-1-vinicius.gomes@intel.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <aff2f1e8-99fa-8828-0127-73a1e6a98d35@ti.com>
Date:   Mon, 13 May 2019 17:05:12 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20190429224833.18208-1-vinicius.gomes@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,

On 04/29/2019 06:48 PM, Vinicius Costa Gomes wrote:
> Hi,
> 
> Changes from RFC:
>   - Removed the patches for taprio offloading, because of the lack of
>     in-tree user >   - Updated the links to point to the PATCH version of this series;
> 
> Original cover letter:
> 
> Overview
> --------
> 
> This RFC has two objectives, it adds support for changing the running
> schedules during "runtime", explained in more detail later, and
> proposes an interface between taprio and the drivers for hardware
> offloading.
> 
> These two different features are presented together so it's clear what
> the "final state" would look like. But after the RFC stage, they can
> be proposed (and reviewed) separately.
> 
> Changing the schedules without disrupting traffic is important for
> handling dynamic use cases, for example, when streams are
> added/removed and when the network configuration changes.
> 
> Hardware offloading support allows schedules to be more precise and
> have lower resource usage.
> 
> 
> Changing schedules
> ------------------
> 
> The same as the other interfaces we proposed, we try to use the same
> concepts as the IEEE 802.1Q-2018 specification. So, for changing
> schedules, there are an "oper" (operational) and an "admin" schedule.
> The "admin" schedule is mutable and not in use, the "oper" schedule is
> immutable and is in use.
> 
> That is, when the user first adds an schedule it is in the "admin"
> state, and it becomes "oper" when its base-time (basically when it
> starts) is reached.
> 
> What this means is that now it's possible to create taprio with a schedule:
> 
> $ tc qdisc add dev IFACE parent root handle 100 taprio \
>        num_tc 3 \
>        map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
>        queues 1@0 1@1 2@2 \
>        base-time 10000000 \
>        sched-entry S 03 300000 \
>        sched-entry S 02 300000 \
>        sched-entry S 06 400000 \
>        clockid CLOCK_TAI
>        
> And then, later, after the previous schedule is "promoted" to "oper",
> add a new ("admin") schedule to be used some time later:
> 
> $ tc qdisc change dev IFACE parent root handle 100 taprio \
>        base-time 1553121866000000000 \
>        sched-entry S 02 500000 \
>        sched-entry S 0f 400000 \
>        clockid CLOCK_TAI
> 
> When enabling the ability to change schedules, it makes sense to add
> two more defined knobs to schedules: "cycle-time" allows to truncate a
> cycle to some value, so it repeats after a well-defined value;
> "cycle-time-extension" controls how much an entry can be extended if
> it's the last one before the change of schedules, the reason is to
> avoid a very small cycle when transitioning from a schedule to
> another.
> 
> With these, taprio in the software mode should provide a fairly
> complete implementation of what's defined in the Enhancements for
> Scheduled Traffic parts of the specification.
> 
> 
> Hardware offload
> ----------------
> 
> Some workloads require better guarantees from their schedules than
> what's provided by the software implementation. This series proposes
> an interface for configuring schedules into compatible network
> controllers.
> 
> This part is proposed together with the support for changing
> schedules, because it raises questions like, should the "qdisc" side
> be responsible of providing visibility into the schedules or should it
> be the driver?
> 
> In this proposal, the driver is called passing the new schedule as
> soon as it is validated, and the "core" qdisc takes care of displaying
> (".dump()") the correct schedules at all times. It means that some
> logic would need to be duplicated in the driver, if the hardware
> doesn't have support for multiple schedules. But as taprio doesn't
> have enough information about the underlying controller to know how
> much in advance a schedule needs to be informed to the hardware, it
> feels like a fair compromise.
> 
> The hardware offloading part of this proposal also tries to define an
> interface for frame-preemption and how it interacts with the
> scheduling of traffic, see Section 8.6.8.4 of IEEE 802.1Q-2018 for
> more information.
> 
> One important difference between the qdisc interface and the
> qdisc-driver interface, is that the "gate mask" on the qdisc side
> references traffic classes, that is bit 0 of the gate mask means
> Traffic Class 0, and in the driver interface, it specifies the queues,
> that is bit 0 means queue 0. That is to say that taprio converts the
> references to traffic classes to references to queues before sending
> the offloading request to the driver.
> 
> 
> Request for help
> ----------------
> 
> I would like that interested driver maintainers could take a look at
> the proposed interface and see if it's going to be too awkward for any
> particular device. Also, pointers to available documentation would be
> appreciated. The idea here is to start a discussion so we can have an
> interface that would work for multiple vendors.
> 
> 
> Links
> -----
> 
> kernel patches:
> https://github.com/vcgomes/net-next/tree/taprio-add-support-for-change-v3
> 
> iproute2 patches:
> https://github.com/vcgomes/iproute2/tree/taprio-add-support-for-change-v3
> 
> 
> 
> Vinicius Costa Gomes (4):
>    taprio: Fix potencial use of invalid memory during dequeue()
>    taprio: Add support adding an admin schedule
>    taprio: Add support for setting the cycle-time manually
>    taprio: Add support for cycle-time-extension
> 
>   include/uapi/linux/pkt_sched.h |  13 +
>   net/sched/sch_taprio.c         | 605 ++++++++++++++++++++++-----------
>   2 files changed, 412 insertions(+), 206 deletions(-)
> 
Ok. I saw this one after I replied to your RFC. So I will pull v3 of
your branch instead of v2 for my investigation.

Thanks and regards,

Murali
