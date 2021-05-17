Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57A1383CB3
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 20:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237295AbhEQSwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 14:52:03 -0400
Received: from foss.arm.com ([217.140.110.172]:60350 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234049AbhEQSwC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 14:52:02 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 28FB331B;
        Mon, 17 May 2021 11:50:45 -0700 (PDT)
Received: from [10.57.66.179] (unknown [10.57.66.179])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 60CBF3F73D;
        Mon, 17 May 2021 11:50:41 -0700 (PDT)
Subject: Re: [PATCH tip:irq/core v1] genirq: remove auto-set of the mask when
 setting the hint
To:     Thomas Gleixner <tglx@linutronix.de>,
        Nitesh Lal <nilal@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "frederic@kernel.org" <frederic@kernel.org>,
        "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, jbrandeb@kernel.org,
        Alex Belits <abelits@marvell.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "rppt@linux.vnet.ibm.com" <rppt@linux.vnet.ibm.com>,
        "jinyuqi@huawei.com" <jinyuqi@huawei.com>,
        "zhangshaokun@hisilicon.com" <zhangshaokun@hisilicon.com>,
        netdev@vger.kernel.org, chris.friesen@windriver.com,
        Marc Zyngier <maz@kernel.org>
References: <20210501021832.743094-1-jesse.brandeburg@intel.com>
 <16d8ca67-30c6-bb4b-8946-79de8629156e@arm.com>
 <20210504092340.00006c61@intel.com>
 <CAFki+LmR-o+Fng21ggy48FUX7RhjjpjO87dn3Ld+L4BK2pSRZg@mail.gmail.com>
 <bf1d4892-0639-0bbf-443e-ba284a8ed457@arm.com>
 <87sg2lz0zz.ffs@nanos.tec.linutronix.de>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <d1d5e797-49ee-4968-88c6-c07119343492@arm.com>
Date:   Mon, 17 May 2021 19:50:35 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87sg2lz0zz.ffs@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-05-17 19:08, Thomas Gleixner wrote:
> On Mon, May 17 2021 at 18:26, Robin Murphy wrote:
>> On 2021-05-17 17:57, Nitesh Lal wrote:
>> I'm not implying that there isn't a bug, or that this code ever made
>> sense in the first place, just that fixing it will unfortunately be a
>> bit more involved than a simple revert. This patch as-is *will* subtly
>> break at least the system PMU drivers currently using
> 
> s/using/abusing/
> 
>> irq_set_affinity_hint() - those I know require the IRQ affinity to
>> follow whichever CPU the PMU context is bound to, in order to meet perf
>> core's assumptions about mutual exclusion.
> 
> Which driver is that?

Right now, any driver which wants to control an IRQ's affinity and also 
build as a module, for one thing. I'm familiar with drivers/perf/ where 
a basic pattern has been widely copied; some of the callers in other 
subsystems appear to *expect* it to set the underlying affinity as well, 
but whether any of those added within the last 6 years represent a 
functional dependency rather than just a performance concern I don't know.

Robin.
