Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE391D8846
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 21:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbgERTeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 15:34:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:10727 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728135AbgERTeX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 15:34:23 -0400
IronPort-SDR: YpszQ4mZVU0tJnFdCSDrFKkmWDpp8qvtKLLxDXx2JyOr6h0JUj/5mS+hcu1MnffEzZ+DOiGept
 SChI4X+EGEUg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2020 12:34:22 -0700
IronPort-SDR: tt1eoPuz7fCciEvUeSjqTZ3yCm7SgLq7O4O9JqaKLgIiUGTttwhDzzlp41zU33X3Vz2o99F6cx
 GutFZuFp3cTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,407,1583222400"; 
   d="scan'208";a="465870772"
Received: from melassa-mobl1.amr.corp.intel.com (HELO ellie) ([10.212.228.130])
  by fmsmga006.fm.intel.com with ESMTP; 18 May 2020 12:34:22 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, jeffrey.t.kirsher@intel.com,
        vladimir.oltean@nxp.com, po.liu@nxp.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com
Subject: Re: [next-queue RFC 0/4] ethtool: Add support for frame preemption
In-Reply-To: <20200516093317.GJ21714@lion.mk-sys.cz>
References: <20200516012948.3173993-1-vinicius.gomes@intel.com> <20200516093317.GJ21714@lion.mk-sys.cz>
Date:   Mon, 18 May 2020 12:34:22 -0700
Message-ID: <87sgfxox4x.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Michal Kubecek <mkubecek@suse.cz> writes:

> On Fri, May 15, 2020 at 06:29:44PM -0700, Vinicius Costa Gomes wrote:
>> Hi,
>> 
>> This series adds support for configuring frame preemption, as defined
>> by IEEE 802.1Q-2018 (previously IEEE 802.1Qbu) and IEEE 802.3br.
>> 
>> Frame preemption allows a packet from a higher priority queue marked
>> as "express" to preempt a packet from lower priority queue marked as
>> "preemptible". The idea is that this can help reduce the latency for
>> higher priority traffic.
>> 
>> Previously, the proposed interface for configuring these features was
>> using the qdisc layer. But as this is very hardware dependent and all
>> that qdisc did was pass the information to the driver, it makes sense
>> to have this in ethtool.
>> 
>> One example, for retrieving and setting the configuration:
>> 
>> $ ethtool $ sudo ./ethtool --show-frame-preemption enp3s0
>> Frame preemption settings for enp3s0:
>> 	support: supported
>
> IMHO we don't need a special bool for this. IIUC this is not a state
> flag that would change value for a particular device; either the device
> supports the feature or it does not. If it does not, the ethtool_ops
> callbacks would return -EOPNOTSUPP (or would not even exist if the
> driver has no support) and ethtool would say so.

(I know that the comments below only apply if "ethtool-way" is what's
decided)

Cool. Will remove the supported bit.

>
>> 	active: active
>> 	supported queues: 0xf
>> 	supported queues: 0xe
>> 	minimum fragment size: 68
>> 
>> 
>> $ ethtool --set-frame-preemption enp3s0 fp on min-frag-size 68 preemptible-queues-mask 0xe
>> 
>> This is a RFC because I wanted to have feedback on some points:
>> 
>>   - The parameters added are enough for the hardware I have, is it
>>     enough in general?
>> 
>>   - even with the ethtool via netlink effort, I chose to keep the
>>     ioctl() way, in case someone wants to backport this to an older
>>     kernel, is there a problem with this?
>
> I would prefer not extending ioctl interface with new features, with
> obvious exceptions like adding new link modes or so. Not only because
> having new features only available through netlink will motivate authors
> of userspace tools to support netlink but mostly because the lack of
> flexibility and extensibility of ioctl interface inevitably leads to
> compromises you wouldn't have to do if you only implement netlink
> requests.

Agreed. Will send the next version with only the netlink interface, and
let's see who complains.

>
> One example I can see is the use of u32 for queue bitmaps. Perhaps you
> don't expect this feature to be supported on devices with more than 32
> queues (and I don't have enough expertise to tell if it's justified at
> the moment) but can you be sure it will be the case in 10 or 20 years?
> As long as these hardcoded u32 bitmaps are only part of internal kernel
> API (ethtool_ops), extending the support for bigger devices will mean
> some code churn (possibly large if many drivers implement the feature)
> but it's something that can be done. But if you have this limit in
> userspace API, you are in a much bigger trouble. The same can be said
> for adding new attributes - easy with netlink but with ioctl you never
> know if those reserved fields will suffice.

A bit of background for this decision (using u32), frame preemption has
dimishing returns in relation to link speeds, my gut feeling is that for
links faster than 2.5G it stops making sense, at least in Linux, the
measurement noise will hide any latency improvement brought by frame
preemption. And I don't see many 2.5G NICs supporting more than 32
queues.

But I agree that keeping the interface future proof is better. Will
change to expose the queues configuration as bitset.

>
>> 
>>   - Some space for bikeshedding the names and location (for example,
>>     does it make sense for these settings to be per-queue?), as I am
>>     not quite happy with them, one example, is the use of preemptible
>>     vs. preemptable;
>> 
>> 
>> About the patches, should be quite straightforward:
>> 
>> Patch 1, adds the ETHTOOL_GFP and ETHOOL_SFP commands and the
>> associated data structures;
>> 
>> Patch 2, adds the ETHTOOL_MSG_PREEMPT_GET and ETHTOOL_MSG_PREEMPT_SET
>> netlink messages and the associated attributes;
>
> I didn't look too deeply but one thing I noticed is that setting the
> parameters using ioctl() does not trigger netlink notification. If we
> decide to implement ioctl support (and I'm not a fan of that), the
> notifications should be sent even when ioctl is used.

Oh, yeah, that's right. Nice catch.


Cheers,
-- 
Vinicius
