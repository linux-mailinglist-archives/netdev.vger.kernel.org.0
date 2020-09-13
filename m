Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50482680A2
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 19:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725951AbgIMRzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 13:55:23 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46886 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgIMRzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 13:55:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08DHrdFq039544;
        Sun, 13 Sep 2020 17:54:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=sy2EBQGLtkwSCJ4qWcAA6Xc4v0A1ZGPtRw4hAqODsqM=;
 b=DOOmI92TtRCDWI2kKSoFBCMQWNg5qr9uhstEKhsGYZCrwXR+EMa2i6whfNnuSST6Oaup
 yK+aRreuEYyO4g5GHYrTUYUVcMXAush0OlavyT39fAmolaKP+iB2BuHkU56SLSgmpNVU
 vu6vgKLxc1JSXQFWarXRHRkNlV6mYE0NIOz8zh0aH33zC0Xh176uwNVcbfuXTF3rGioR
 SB+Zn4juGEfd2lL8rbJh2yo5e3E60ITm1/AI0v2AK+b3T7OPNA/8S5CpQAcAZGDyhyuU
 lCMclR8l9oEYSthd75c2fPanjHoeRFdCuQZjA5NxGCZlJ+ko5Q4Ifk5KrcJmUegZwPhR RQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 33gnrqk909-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 13 Sep 2020 17:54:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08DHnp8Y166603;
        Sun, 13 Sep 2020 17:52:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33h7wjw3q1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 13 Sep 2020 17:52:26 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08DHqGIo007221;
        Sun, 13 Sep 2020 17:52:16 GMT
Received: from [10.74.86.192] (/10.74.86.192)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 13 Sep 2020 17:52:16 +0000
Subject: Re: [PATCH v3 10/11] xen: Update sched clock offset to avoid system
 instability in hibernation
To:     Anchal Agarwal <anchalag@amazon.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        jgross@suse.com, linux-pm@vger.kernel.org, linux-mm@kvack.org,
        kamatam@amazon.com, sstabellini@kernel.org, konrad.wilk@oracle.com,
        roger.pau@citrix.com, axboe@kernel.dk, davem@davemloft.net,
        rjw@rjwysocki.net, len.brown@intel.com, pavel@ucw.cz,
        peterz@infradead.org, eduval@amazon.com, sblbir@amazon.com,
        xen-devel@lists.xenproject.org, vkuznets@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dwmw@amazon.co.uk, benh@kernel.crashing.org
References: <cover.1598042152.git.anchalag@amazon.com>
 <238e837b8d4e17925801c4e85de17bdfca4ddd00.1598042152.git.anchalag@amazon.com>
From:   boris.ostrovsky@oracle.com
Organization: Oracle Corporation
Message-ID: <09bb5d50-ee13-133e-d5da-a342052e4271@oracle.com>
Date:   Sun, 13 Sep 2020 13:52:10 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <238e837b8d4e17925801c4e85de17bdfca4ddd00.1598042152.git.anchalag@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9743 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009130163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9743 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009130163
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/21/20 6:30 PM, Anchal Agarwal wrote:
> Save/restore xen_sched_clock_offset in syscore suspend/resume during PM
> hibernation. Commit '867cefb4cb1012: ("xen: Fix x86 sched_clock() interface
> for xen")' fixes xen guest time handling during migration. A similar issue
> is seen during PM hibernation when system runs CPU intensive workload.
> Post resume pvclock resets the value to 0 however, xen sched_clock_offset
> is never updated. System instability is seen during resume from hibernation
> when system is under heavy CPU load. Since xen_sched_clock_offset is not
> updated, system does not see the monotonic clock value and the scheduler
> would then think that heavy CPU hog tasks need more time in CPU, causing
> the system to freeze


I don't think you need to explain why non-monotonic clocks are bad.
(and, in fact, the same applies to commit message in patch 8)


>
> Signed-off-by: Anchal Agarwal <anchalag@amazon.com>
> ---
>  arch/x86/xen/suspend.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
> index b12db6966af6..a62e08a11681 100644
> --- a/arch/x86/xen/suspend.c
> +++ b/arch/x86/xen/suspend.c
> @@ -98,8 +98,9 @@ static int xen_syscore_suspend(void)
>  		return 0;
>  
>  	gnttab_suspend();
> -
>  	xen_manage_runstate_time(-1);
> +	xen_save_sched_clock_offset();
> +
>  	xrfp.domid = DOMID_SELF;
>  	xrfp.gpfn = __pa(HYPERVISOR_shared_info) >> PAGE_SHIFT;
>  
> @@ -120,6 +121,12 @@ static void xen_syscore_resume(void)
>  	xen_hvm_map_shared_info();
>  
>  	pvclock_resume();
> +
> +	/*
> +	 * Restore xen_sched_clock_offset during resume to maintain
> +	 * monotonic clock value
> +	 */


I'd drop this comment, we know what the call does.


-boris


> +	xen_restore_sched_clock_offset();
>  	xen_manage_runstate_time(0);
>  	gnttab_resume();
>  }
