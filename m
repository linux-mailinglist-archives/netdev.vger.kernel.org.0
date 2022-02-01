Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6804A61E2
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 18:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241404AbiBARGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 12:06:22 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63012 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231877AbiBARGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 12:06:21 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 211H0Ybq016152;
        Tue, 1 Feb 2022 17:06:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=onrqYIOKUr4RNTR6BCf3mCF2S16T7nddg5AP40Dp79A=;
 b=YLMWhhuQIxEJwuegzaz1nfJaXranP7f6aHyrOA8ZQ65v6TMLjlXuNOgkyi4xL8Gxesuy
 oZ9SrQ6UATj3vM99z3hhXU8cWNobev2MF6X2INhmaxlYR9On9afD9dYy6xHPxarFQELd
 Yyfqk49+YHvRdWlE4dZqFkiIqZ+Pd0GQigjqHk1vNtCn5PNnb+A9PujY3pbNVxoMaw8s
 cevaQ6psMWy9DbMEEqPJsuzu2AhoPbqxlEm3BuDYjQQ28qlZihDKL3aWNRAg1HNTh7Jp
 E4Rma38RiAggfaVy/XygAFCaixpBzY1Ze7GgWneE3Jd23Qc0xVGEuyiHCjwTA9aB1nFf NQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dy6q4kght-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Feb 2022 17:06:17 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 211G0jIi028915;
        Tue, 1 Feb 2022 17:06:17 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dy6q4kgha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Feb 2022 17:06:16 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 211Gl9KU025334;
        Tue, 1 Feb 2022 17:06:15 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3dvvujer20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Feb 2022 17:06:15 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 211H6Dpb47579530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Feb 2022 17:06:13 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECC8A42047;
        Tue,  1 Feb 2022 17:06:12 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E88942045;
        Tue,  1 Feb 2022 17:06:12 +0000 (GMT)
Received: from [9.145.64.14] (unknown [9.145.64.14])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  1 Feb 2022 17:06:12 +0000 (GMT)
Message-ID: <0936d5f3-aef2-0553-408b-07b3bb47e36b@linux.ibm.com>
Date:   Tue, 1 Feb 2022 18:06:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [BUG] net: smc: possible deadlock in smc_lgr_free() and
 smc_link_down_work()
Content-Language: en-US
To:     Jia-Ju Bai <baijiaju1990@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <11fe65b8-eda4-121e-ec32-378b918d0909@gmail.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <11fe65b8-eda4-121e-ec32-378b918d0909@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pea68IG5Bj1ccet02yEexdujcsm8MwYP
X-Proofpoint-ORIG-GUID: wR9E2Ty2RNbiLvkCityV-vItCyHpBkeq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-01_08,2022-02-01_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 clxscore=1015 suspectscore=0 mlxscore=0 adultscore=0 malwarescore=0
 impostorscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202010095
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/02/2022 08:51, Jia-Ju Bai wrote:
> Hello,
> 
> My static analysis tool reports a possible deadlock in the smc module in Linux 5.16:
> 
> smc_lgr_free()
>   mutex_lock(&lgr->llc_conf_mutex); --> Line 1289 (Lock A)
>   smcr_link_clear()
>     smc_wr_free_link()
>       wait_event(lnk->wr_tx_wait, ...); --> Line 648 (Wait X)
> 
> smc_link_down_work()
>   mutex_lock(&lgr->llc_conf_mutex); --> Line 1683 (Lock A)
>   smcr_link_down()
>     smcr_link_clear()
>       smc_wr_free_link()
>         smc_wr_wakeup_tx_wait()
>           wake_up_all(&lnk->wr_tx_wait); --> Line 78 (Wake X)
> 
> When smc_lgr_free() is executed, "Wait X" is performed by holding "Lock A". If smc_link_down_work() is executed at this time, "Wake X" cannot be performed to wake up "Wait X" in smc_lgr_free(), because "Lock A" has been already hold by smc_lgr_free(), causing a possible deadlock.
> 
> I am not quite sure whether this possible problem is real and how to fix it if it is real.
> Any feedback would be appreciated, thanks :)

A deeper analysis showed up that this reported possible deadlock is actually not a problem.

The wait on line 648 in smc_wr.c
	wait_event(lnk->wr_tx_wait, (!atomic_read(&lnk->wr_tx_refcnt)));
waits as long as the refcount wr_tx_refcnt is not zero.

Every time when a caller stops using a link wr_tx_refcnt is decreased, and when it reaches 
zero the wr_tx_wait is woken up in smc_wr_tx_link_put() in smc_wr.h, line 70:
		if (atomic_dec_and_test(&link->wr_tx_refcnt))
			wake_up_all(&link->wr_tx_wait);

Multiple callers of smc_wr_tx_link_put() do not run under the llc_conf_mutex lock, and those
who run under this mutex are saved against the wait_event() in smc_wr_free_link().


Thank you for reporting this finding! Which tool did you use for this analysis?

