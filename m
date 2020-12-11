Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF4C2D77FB
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 15:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406289AbgLKOdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 09:33:16 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44700 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406261AbgLKOcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 09:32:33 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BBEK3q4153543;
        Fri, 11 Dec 2020 14:29:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=XwmNJXsce0biO7XLe+zGaIsjtrmRfK/vTz0mYn6nQBU=;
 b=bR7yH4+1kTFS/uaRb9qwsHTyFm2EoNVmWnQB/6uOrO708u+eqNtBobFpmn1ttrRdH1ys
 eWZmcv+9rBDGS0S9dxVH7WJEjVIq3kan/8A2J+2JEfl4cmi6SdTHDxhFZ9FOjgghK0i/
 gSlqjyBs3FtwP3+ZAOMx//Xrh2s4GGZVNmZZvw8Dg7A8ucgqyFuZ1jZz6HYR0R/QX3KB
 jq1go8jZfLC3JdZILS9AqGFwicAYPALMmwsEwRd+5bZO9goG03a6o19lTH5pgGTEdXEs
 I4ECgSmCCiTYqeMDSavCaEpGT9QkWsYwEp7lVPsTzWiLDfHkK38lg3Q5ATAnYCJ8Q3TZ zQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3581mratkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 11 Dec 2020 14:29:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BBEPIII069767;
        Fri, 11 Dec 2020 14:29:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 358kstfcjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Dec 2020 14:29:20 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BBETD7i006093;
        Fri, 11 Dec 2020 14:29:13 GMT
Received: from [10.39.222.144] (/10.39.222.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 11 Dec 2020 06:29:13 -0800
Subject: Re: [patch 27/30] xen/events: Only force affinity mask for percpu
 interrupts
To:     Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        xen-devel@lists.xenproject.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        linux-parisc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Wambui Karuga <wambui.karugax@gmail.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Jon Mason <jdmason@kudzu.us>,
        Dave Jiang <dave.jiang@intel.com>,
        Allen Hubbe <allenbh@gmail.com>, linux-ntb@googlegroups.com,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-pci@vger.kernel.org,
        Karthikeyan Mitran <m.karthikeyan@mobiveil.co.in>,
        Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
References: <20201210192536.118432146@linutronix.de>
 <20201210194045.250321315@linutronix.de>
 <7f7af60f-567f-cdef-f8db-8062a44758ce@oracle.com>
 <2164a0ce-0e0d-c7dc-ac97-87c8f384ad82@suse.com>
 <871rfwiknd.fsf@nanos.tec.linutronix.de>
From:   boris.ostrovsky@oracle.com
Organization: Oracle Corporation
Message-ID: <9806692f-24a3-4b6f-ae55-86bd66481271@oracle.com>
Date:   Fri, 11 Dec 2020 09:29:09 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <871rfwiknd.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9831 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012110094
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9831 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012110093
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/11/20 7:37 AM, Thomas Gleixner wrote:
> On Fri, Dec 11 2020 at 13:10, Jürgen Groß wrote:
>> On 11.12.20 00:20, boris.ostrovsky@oracle.com wrote:
>>> On 12/10/20 2:26 PM, Thomas Gleixner wrote:
>>>> All event channel setups bind the interrupt on CPU0 or the target CPU for
>>>> percpu interrupts and overwrite the affinity mask with the corresponding
>>>> cpumask. That does not make sense.
>>>>
>>>> The XEN implementation of irqchip::irq_set_affinity() already picks a
>>>> single target CPU out of the affinity mask and the actual target is stored
>>>> in the effective CPU mask, so destroying the user chosen affinity mask
>>>> which might contain more than one CPU is wrong.
>>>>
>>>> Change the implementation so that the channel is bound to CPU0 at the XEN
>>>> level and leave the affinity mask alone. At startup of the interrupt
>>>> affinity will be assigned out of the affinity mask and the XEN binding will
>>>> be updated.
>>>
>>> If that's the case then I wonder whether we need this call at all and instead bind at startup time.
>> After some discussion with Thomas on IRC and xen-devel archaeology the
>> result is: this will be needed especially for systems running on a
>> single vcpu (e.g. small guests), as the .irq_set_affinity() callback
>> won't be called in this case when starting the irq.


On UP are we not then going to end up with an empty affinity mask? Or are we guaranteed to have it set to 1 by interrupt generic code?


This is actually why I brought this up in the first place --- a potential mismatch between the affinity mask and Xen-specific data (e.g. info->cpu and then protocol-specific data in event channel code). Even if they are re-synchronized later, at startup time (for SMP).


I don't see anything that would cause a problem right now but I worry that this inconsistency may come up at some point.


-boris


> That's right, but not limited to ARM. The same problem exists on x86 UP.
> So yes, the call makes sense, but the changelog is not really useful.
> Let me add a comment to this.
>
> Thanks,
>
>         tglx
>
