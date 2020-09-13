Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A067426807D
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 19:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725952AbgIMRNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 13:13:33 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35484 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgIMRNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 13:13:32 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08DH4iC8191502;
        Sun, 13 Sep 2020 17:07:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=xVtLGu7xP2YfYZ/5jujoneuZlmPA2+dwH8I7NLyPQ1c=;
 b=Juv1J9ih7aW9VwvSNOXrVn+lQ4/bY66fgMAgys7R6MsdDkbG+kKYFizO9UnPrQdS0FYR
 +ezg0OJOUY1uvU8MGRH551lzfWXsOWSUFz6a4UJGMiDkcNUU5Feup7d9OHIFYenEikuu
 C/UnQWnDb5PRRG4jPJrR+8XnwadKGotc5vHgqrdGPQ1ezckIfBrzqwv9imTfKgbGnvXn
 711q1eISZIqV86FM0NWO25rot6HkB/h8FGKSy4colpRNegADVYS0TN3neDlC5In0rLOH
 4wqPX+bPOBhDmiUf4csMsZx6svd9dvWTO8/52NkIc9i8ZFRXwgyhrKnchFHwyCeTi8JS 5A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33gp9ku66c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 13 Sep 2020 17:07:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08DH5fF1064033;
        Sun, 13 Sep 2020 17:07:47 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 33hm2vghh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 13 Sep 2020 17:07:46 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08DH7gN6025265;
        Sun, 13 Sep 2020 17:07:42 GMT
Received: from [10.74.86.192] (/10.74.86.192)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 13 Sep 2020 17:07:41 +0000
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
Message-ID: <986e074e-9c9f-ce09-ffb8-ed8f5d528d98@oracle.com>
Date:   Sun, 13 Sep 2020 13:07:36 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <9b970e12491107afda0c1d4a6f154b52d90346ac.1598042152.git.anchalag@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9743 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009130155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9743 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009130155
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
>
> Though, accquirng pm_mutex is still right thing to do, we may
> see deadlock if PM hibernation is interrupted by Xen suspend.
> PM hibernation depends on xenwatch thread to process xenbus state
> transactions, but the thread will sleep to wait pm_mutex which is
> already held by PM hibernation context in the scenario. Xen shutdown
> code may need some changes to avoid the issue.
>
> [Anchal Agarwal: Changelog]:
>  RFC v1->v2: Code refactoring
>  v1->v2:     Remove unused functions for PM SUSPEND/PM hibernation
>  v2->v3:     Added logic to use existing pm_notifier to detect for ARM
> 	     and abort hibernation for ARM guests. Also removed different
> 	     suspend_modes and simplified the code with using existing state
> 	     variables for tracking Xen suspend. The notifier won't get
> 	     registered for pvh dom0 either.
>
> Signed-off-by: Anchal Agarwal <anchalag@amazon.com>
> Signed-off-by: Munehisa Kamata <kamatam@amazon.com>


BTW, just to make sure --- Thomas' comments about commit message format
(SoB order, no changelog, etc) apply to all patches, not just #5.


-boris

