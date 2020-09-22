Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E38F274661
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 18:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgIVQTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 12:19:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39120 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbgIVQTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 12:19:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08MGFCef055413;
        Tue, 22 Sep 2020 16:18:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=sEHjYHgpuV+AnxSztrrqp3lRmdzCrQ71bV6mXr0RVMU=;
 b=aVEU3mvLJ/ITw0VV2xKn7/NCGpGUFxAruRlqpDHa/L2rdiTooPqTZlL+AtHMIWVaVMk+
 NM5RqspUXUdS4+u92d3uZVICz1kFvKsatIOAyaZztQ2ZAbZqIbGGKbaPGE85Iq2jCKa8
 M1B2dg+7f7R/KWihI0S2unb4nUtUtwnJcilFnxAitc/vmFOtMuFeHPj0yIwZR5bAhXQt
 2h3PZMTeeeeTIsW0dPCoAcbuGw6+c6+U8AHux+AJZ7Cc67InCxaYY5pYJOfxdf6V16n4
 EJQb0WZthhCKVdRRN9u26KCT+OTiJctOPCd0ems4pYIBByUawhs8waeDdg4kkZ24WEPN eQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33q5rgc4ts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 16:18:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08MGFtHd143702;
        Tue, 22 Sep 2020 16:18:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33nuw4b02s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 16:18:21 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08MGIBWW018552;
        Tue, 22 Sep 2020 16:18:11 GMT
Received: from [10.74.86.236] (/10.74.86.236)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Sep 2020 09:18:11 -0700
Subject: Re: [PATCH v3 01/11] xen/manage: keep track of the on-going suspend
 mode
To:     Anchal Agarwal <anchalag@amazon.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, jgross@suse.com, linux-pm@vger.kernel.org,
        linux-mm@kvack.org, kamatam@amazon.com, sstabellini@kernel.org,
        konrad.wilk@oracle.com, roger.pau@citrix.com, axboe@kernel.dk,
        davem@davemloft.net, rjw@rjwysocki.net, len.brown@intel.com,
        pavel@ucw.cz, peterz@infradead.org, eduval@amazon.com,
        sblbir@amazon.com, xen-devel@lists.xenproject.org,
        vkuznets@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dwmw@amazon.co.uk,
        benh@kernel.crashing.org
References: <cover.1598042152.git.anchalag@amazon.com>
 <9b970e12491107afda0c1d4a6f154b52d90346ac.1598042152.git.anchalag@amazon.com>
 <4b2bbc8b-7817-271a-4ff0-5ee5df956049@oracle.com>
 <20200914214754.GA19975@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <e9b94104-d20a-b6b2-cbe0-f79b1ed09c98@oracle.com>
 <20200915180055.GB19975@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <5f1e4772-7bd9-e6c0-3fe6-eef98bb72bd8@oracle.com>
 <20200921215447.GA28503@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
From:   boris.ostrovsky@oracle.com
Organization: Oracle Corporation
Message-ID: <e3e447e5-2f7a-82a2-31c8-10c2ffcbfb2c@oracle.com>
Date:   Tue, 22 Sep 2020 12:18:05 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200921215447.GA28503@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 clxscore=1015 suspectscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220124
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/21/20 5:54 PM, Anchal Agarwal wrote:
> Thanks for the above suggestion. You are right I didn't find a way to declare
> a global state either. I just broke the above check in 2 so that once we have
> support for ARM we should be able to remove aarch64 condition easily. Let me
> know if I am missing nay corner cases with this one.
>
> static int xen_pm_notifier(struct notifier_block *notifier,
> 	unsigned long pm_event, void *unused)
> {
>     int ret = NOTIFY_OK;
>     if (!xen_hvm_domain() || xen_initial_domain())
> 	ret = NOTIFY_BAD;
>     if(IS_ENABLED(CONFIG_ARM64) && (pm_event == PM_SUSPEND_PREPARE || pm_event == HIBERNATION_PREPARE))
> 	ret = NOTIFY_BAD;
>
>     return ret;
> }



This will allow PM suspend to proceed on x86.


-boris

