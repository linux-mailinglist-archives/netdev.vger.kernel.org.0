Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6CED2D6BE6
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 00:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394353AbgLJXXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 18:23:06 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33688 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394246AbgLJXWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 18:22:45 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BANJcxD076282;
        Thu, 10 Dec 2020 23:21:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=g9HQMgG8/lH1Xl7UdSJNvDAMRQCo3FWW7Bk60ydYMFM=;
 b=yiiSqUT1ul8LHgAfKjBlIB4yYYSpi+fGANCSKFFlOWkOUouS3Dv2O9HSPvMZHyva2HLa
 t2URiRpBCtd04nx9Lq/bUlqBSfAvdgny9AZ7r99NqQl+3SLxNcNacBmNDpvbnkmq+RJf
 tkHuWp0PFf1OqSZUrQZdo1op9pLE6PCegbVRzlACJRrfsJakcoaM7H+sCwUihUEMr2fQ
 dVrKn7O2B0uCiKt4l0ihiQonSCwdjdrSogLQz8qpbD6/3t1pwKq6cTqj0HVlsjBYL0mf
 j+yxZxQYgeFZOyVTmAVytFe3f0zAIJgGCpXDL4UlTLva10Xtrln9de8y9hZfow66cFAT Dg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35825mg2bs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 10 Dec 2020 23:21:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BANKtw7149340;
        Thu, 10 Dec 2020 23:21:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 358m42f5be-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Dec 2020 23:21:07 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BANKp8g025210;
        Thu, 10 Dec 2020 23:20:51 GMT
Received: from [10.39.227.125] (/10.39.227.125)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 10 Dec 2020 15:20:51 -0800
Subject: Re: [patch 27/30] xen/events: Only force affinity mask for percpu
 interrupts
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>, Juergen Gross <jgross@suse.com>,
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
From:   boris.ostrovsky@oracle.com
Organization: Oracle Corporation
Message-ID: <7f7af60f-567f-cdef-f8db-8062a44758ce@oracle.com>
Date:   Thu, 10 Dec 2020 18:20:46 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201210194045.250321315@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9831 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012100149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9831 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012100149
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/10/20 2:26 PM, Thomas Gleixner wrote:
> All event channel setups bind the interrupt on CPU0 or the target CPU for
> percpu interrupts and overwrite the affinity mask with the corresponding
> cpumask. That does not make sense.
>
> The XEN implementation of irqchip::irq_set_affinity() already picks a
> single target CPU out of the affinity mask and the actual target is stored
> in the effective CPU mask, so destroying the user chosen affinity mask
> which might contain more than one CPU is wrong.
>
> Change the implementation so that the channel is bound to CPU0 at the XEN
> level and leave the affinity mask alone. At startup of the interrupt
> affinity will be assigned out of the affinity mask and the XEN binding will
> be updated. 


If that's the case then I wonder whether we need this call at all and instead bind at startup time.


-boris


> Only keep the enforcement for real percpu interrupts.
