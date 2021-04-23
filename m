Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE161368B03
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 04:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236068AbhDWC2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 22:28:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42604 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230367AbhDWC2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 22:28:35 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13N22lxU113351;
        Thu, 22 Apr 2021 22:26:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=cYeJn2we0b5nvyzcKIrHpPFcBxuUAeiaum1tA94OSKw=;
 b=cVzLJhJxHYD7EWVM59Ws3+tage82CyNcBxLTogz465u46alqjEI4czRsr7oN5sAxHRha
 wNPVMMVg7gPsQlWVzAKNeAuovTvbcEarHcO2Z5PGBfYTITaxO5HoRcUGq9ilyfADMlNw
 LU0HowvQtO7Q4DrptYJyn+gKsANALfdGPn+WoVRvwk9DwkYm5wtKTcP+GFrtAmI34sD7
 aY+qEy/sc/1LbsnvLAJdTvYcGcSBx2FHu/2y9KZ1PTG+wxt7EdtnH3hY0bhlUVaEWcUF
 ldg5PPJSbYUHT4v4cp21i4TsiIDXvVKwdGPKSZ2GgTeAI3JpBOVC99tw1F0esQMkpPw+ cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 383btyf16y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Apr 2021 22:26:30 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13N2CVwj143570;
        Thu, 22 Apr 2021 22:26:30 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 383btyf16p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Apr 2021 22:26:30 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13N26csk032205;
        Fri, 23 Apr 2021 02:26:29 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03wdc.us.ibm.com with ESMTP id 37yqa9nytq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Apr 2021 02:26:29 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13N2QSMx37355950
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Apr 2021 02:26:28 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26460BE0A6;
        Fri, 23 Apr 2021 02:26:28 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68BE3BE0A0;
        Fri, 23 Apr 2021 02:26:25 +0000 (GMT)
Received: from [9.160.109.21] (unknown [9.160.109.21])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 23 Apr 2021 02:26:25 +0000 (GMT)
Subject: Re: [PATCH V2 net] ibmvnic: Continue with reset if set link down
 failed
To:     =?UTF-8?Q?Michal_Such=c3=a1nek?= <msuchanek@suse.de>,
        Lijun Pan <lijunp213@gmail.com>
Cc:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        netdev@vger.kernel.org, Lijun Pan <ljp@linux.vnet.ibm.com>,
        Tom Falcon <tlfalcon@linux.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Dany Madden <drt@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linuxppc-dev@lists.ozlabs.org, David Miller <davem@davemloft.net>
References: <20210420213517.24171-1-drt@linux.ibm.com>
 <60C99F56-617D-455B-9ACF-8CE1EED64D92@linux.vnet.ibm.com>
 <20210421064527.GA2648262@us.ibm.com>
 <CAOhMmr4ckVFTZtSeHFHNgGPUA12xYO8WcUoakx7WdwQfSKBJhA@mail.gmail.com>
 <20210422172135.GY6564@kitsune.suse.cz>
From:   Rick Lindsley <ricklind@linux.vnet.ibm.com>
Message-ID: <9e46d7ad-55dd-7caf-0a39-344b80bdceb3@linux.vnet.ibm.com>
Date:   Thu, 22 Apr 2021 19:26:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210422172135.GY6564@kitsune.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jWsLpFXxeuukBeTNMw6M3Tj4tQ9V-Or9
X-Proofpoint-ORIG-GUID: i2GYQ9voH4e4uhVWf5V27_zHgg52w8rr
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-22_15:2021-04-22,2021-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxscore=0 clxscore=1011 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 suspectscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104230012
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/22/21 10:21 AM, Michal Suchánek wrote:

> Merging do_reset and do_hard_reset might be a good code cleanup which is
> out of the scope of this fix.

I agree, on both points. Accepting the patch, and improving the reset
path are not in conflict with each other.

My position is that improving the reset path is certainly on the table,
but not with this bug or this fix.  Within the context of this discovered
problem, the issue is well understood, the fix is small and addresses the
immediate problem, and it has not generated new bugs under subsequent
testing.  For those reasons, the submitted patch has my support.

Rick

