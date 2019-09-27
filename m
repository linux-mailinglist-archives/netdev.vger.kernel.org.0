Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C82FC030A
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 12:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbfI0KMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 06:12:07 -0400
Received: from foss.arm.com ([217.140.110.172]:47960 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbfI0KMH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 06:12:07 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AF75F28;
        Fri, 27 Sep 2019 03:12:06 -0700 (PDT)
Received: from dawn-kernel.cambridge.arm.com (unknown [10.1.197.116])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 72FE73F534;
        Fri, 27 Sep 2019 03:12:04 -0700 (PDT)
Subject: Re: [RFC PATCH v4 2/5] ptp: Reorganize ptp_kvm modules to make it
 arch-independent.
To:     "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Will Deacon <Will.Deacon@arm.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        "Kaly Xin (Arm Technology China)" <Kaly.Xin@arm.com>,
        "Justin He (Arm Technology China)" <Justin.He@arm.com>,
        nd <nd@arm.com>
References: <20190926114212.5322-1-jianyong.wu@arm.com>
 <20190926114212.5322-3-jianyong.wu@arm.com>
 <2f338b57-b0b2-e439-6089-72e5f5e4f017@arm.com>
 <HE1PR0801MB167630F7B983A7F9DBB473DFF4810@HE1PR0801MB1676.eurprd08.prod.outlook.com>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <4337dcf0-bd60-4db8-6c9f-cd718b89d2a4@arm.com>
Date:   Fri, 27 Sep 2019 11:12:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <HE1PR0801MB167630F7B983A7F9DBB473DFF4810@HE1PR0801MB1676.eurprd08.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 27/09/2019 11:10, Jianyong Wu (Arm Technology China) wrote:
> Hi Suzuki,
> 
>> -----Original Message-----
>> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Sent: Thursday, September 26, 2019 9:06 PM
>> To: Jianyong Wu (Arm Technology China) <Jianyong.Wu@arm.com>;
>> netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
>> tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
>> maz@kernel.org; richardcochran@gmail.com; Mark Rutland
>> <Mark.Rutland@arm.com>; Will Deacon <Will.Deacon@arm.com>
>> Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
>> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org; Steve Capper
>> <Steve.Capper@arm.com>; Kaly Xin (Arm Technology China)
>> <Kaly.Xin@arm.com>; Justin He (Arm Technology China)
>> <Justin.He@arm.com>; nd <nd@arm.com>
>> Subject: Re: [RFC PATCH v4 2/5] ptp: Reorganize ptp_kvm modules to make it
>> arch-independent.
>>
>> Hi Jianyong,
>>
>> On 26/09/2019 12:42, Jianyong Wu wrote:
>>> Currently, ptp_kvm modules implementation is only for x86 which
>>> includs large part of arch-specific code.  This patch move all of
>>> those code into new arch related file in the same directory.
>>>
>>> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
>>> ---
>>>    drivers/ptp/Makefile                 |  1 +
>>>    drivers/ptp/{ptp_kvm.c => kvm_ptp.c} | 77 ++++++------------------
>>>    drivers/ptp/ptp_kvm_x86.c            | 87
>> ++++++++++++++++++++++++++++
>>>    include/asm-generic/ptp_kvm.h        | 12 ++++
>>>    4 files changed, 118 insertions(+), 59 deletions(-)
>>>    rename drivers/ptp/{ptp_kvm.c => kvm_ptp.c} (63%)
>>
>> minor nit: Could we not skip renaming the file ? Given you are following the
>> ptp_kvm_* for the arch specific files and the header files, wouldn't it be
>> good to keep ptp_kvm.c ?
>>
> If the module name ptp_kvm.ko is the same with its dependent object file ptp_kvm.o, warning will be given by compiler,
> So I change the ptp_kvm.c to kvm_ptp.c to avoid that conflict.

Hmm, ok. How about ptp_kvm_common.c instead of kvm_ptp.c ?

Suzuki
