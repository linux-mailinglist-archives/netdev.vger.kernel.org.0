Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36118267FFC
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 17:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbgIMPpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 11:45:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33118 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbgIMPpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 11:45:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08DFUGHI094879;
        Sun, 13 Sep 2020 15:43:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=+KYz9WIbVQU7rPAI45m7Ps673pTmdbdTUX1I+G/jOhY=;
 b=X1P+8NpsKg3UbMT0WWzVM8HAl9xEWZbL+4ZfleEG0ASVxqSTscKJ9gvAmNXALxyCbP3P
 74lzqY/xtd3guruWFh9K9FYUrXU54TSfN3iizW8Xxy0fXyYZoPUaL7PNRX+KyX85Jmtg
 pEA3bUsQA+3hFwV9IeNHgCChqM7LbJnLYTrVqLtTDAm3mF+lHfl6m8WJaBEwY7BD4h1c
 lFDaiORtjwukYc1ZyCb92GaiAAkxVQ2FP7BayoITSR56GRu7lCia2IdFiDs2TsfZVDog
 +9xKL7zaKxgGsGhapbZGlxDF0WjX7YHSmUsWn67s5F8XsA5KuI0UR3Is7u4ELYC6JkoQ Ow== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33gpymb1db-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 13 Sep 2020 15:43:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08DFPuQU088545;
        Sun, 13 Sep 2020 15:43:56 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33h7wjsx4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 13 Sep 2020 15:43:56 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08DFhabS027483;
        Sun, 13 Sep 2020 15:43:36 GMT
Received: from [10.74.86.192] (/10.74.86.192)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 13 Sep 2020 15:43:36 +0000
Subject: Re: [PATCH v3 01/11] xen/manage: keep track of the on-going suspend
 mode
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
 <9b970e12491107afda0c1d4a6f154b52d90346ac.1598042152.git.anchalag@amazon.com>
From:   boris.ostrovsky@oracle.com
Organization: Oracle Corporation
Message-ID: <4b2bbc8b-7817-271a-4ff0-5ee5df956049@oracle.com>
Date:   Sun, 13 Sep 2020 11:43:30 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <9b970e12491107afda0c1d4a6f154b52d90346ac.1598042152.git.anchalag@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9743 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009130140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9743 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 clxscore=1015 mlxscore=0 impostorscore=0
 bulkscore=0 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009130140
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/21/20 6:25 PM, Anchal Agarwal wrote:
> From: Munehisa Kamata <kamatam@amazon.com>  
> 
> Guest hibernation is different from xen suspend/resume/live migration.
> Xen save/restore does not use pm_ops as is needed by guest hibernation.
> Hibernation in guest follows ACPI path and is guest inititated , the
> hibernation image is saved within guest as compared to later modes
> which are xen toolstack assisted and image creation/storage is in
> control of hypervisor/host machine.
> To differentiate between Xen suspend and PM hibernation, keep track
> of the on-going suspend mode by mainly using a new API to keep track of
> SHUTDOWN_SUSPEND state.
> Introduce a simple function that keeps track of on-going suspend mode
> so that PM hibernation code can behave differently according to the
> current suspend mode.
> Since Xen suspend doesn't have corresponding PM event, its main logic
> is modfied to acquire pm_mutex.


lock_system_sleep() is not taking this mutex.


> 
> Though, accquirng pm_mutex is still right thing to do, we may
> see deadlock if PM hibernation is interrupted by Xen suspend.
> PM hibernation depends on xenwatch thread to process xenbus state
> transactions, but the thread will sleep to wait pm_mutex which is
> already held by PM hibernation context in the scenario. Xen shutdown
> code may need some changes to avoid the issue.



Is it Xen's shutdown or suspend code that needs to address this? (Or I
may not understand what the problem is that you are describing)


> 
> +
> +static int xen_pm_notifier(struct notifier_block *notifier,
> +	unsigned long pm_event, void *unused)
> +{
> +	int ret;
> +
> +	switch (pm_event) {
> +	case PM_SUSPEND_PREPARE:
> +	case PM_HIBERNATION_PREPARE:
> +	/* Guest hibernation is not supported for aarch64 currently*/
> +	if (IS_ENABLED(CONFIG_ARM64)) {
> +		ret = NOTIFY_BAD;
> +		break;
> +	}

Indentation.

> +	case PM_RESTORE_PREPARE:
> +	case PM_POST_SUSPEND:
> +	case PM_POST_HIBERNATION:
> +	case PM_POST_RESTORE:
> +	default:
> +		ret = NOTIFY_OK;
> +	}
> +	return ret;
> +};


This whole routine now is

	if (IS_ENABLED(CONFIG_ARM64))
		return NOTIFY_BAD;

	return NOTIFY_OK;

isn't it?


> +
> +static struct notifier_block xen_pm_notifier_block = {
> +	.notifier_call = xen_pm_notifier
> +};
> +
> +static int xen_setup_pm_notifier(void)
> +{
> +	if (!xen_hvm_domain() || xen_initial_domain())
> +		return -ENODEV;


I don't think this works anymore.

In the past your notifier would set suspend_mode (or something) but now
it really doesn't do anything except reports an error in some (ARM) cases.

So I think you should move this check into the notifier.

(And BTW I still think PM_SUSPEND_PREPARE should return an error too.
The fact that we are using "suspend" in xen routine names is irrelevant)



-boris



> +	return register_pm_notifier(&xen_pm_notifier_block);
> +}
> +
