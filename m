Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3BB02615C5
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 18:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731910AbgIHQ4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 12:56:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55416 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732109AbgIHQ4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 12:56:08 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 088GfhFU145349;
        Tue, 8 Sep 2020 12:55:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Mx8Q0RuPZTnd71/9NfZq1lVXeIOooylyhqozqU4QG3k=;
 b=ZobXdbrhR1ODYkTO4XHI+litlVhzK4JhbkRxh76pViTzBGzmbbvymEYlKQGMWLn3ISVG
 3v50JT5AIhYocqg8NmaEF4BCcV1LnbTS2e/JLTE3FJwMa1vpxVVUTA8Tkxhghdww7R05
 iuUWzGqL/xtBUwYWOoqQNNjPXvizbYc5PVF5Gut2kvOm+7PX0cDKJT1gyjCWsDQSq4eE
 VToygI04sx1RWTs7ltnN4a7NEBfBg8tJHevQAdb80UtHhT7TzvYIKwMik3G68zLPe8TB
 PQ1WeDdpwA1IFPHpi+Dr8v60UkyKyMV6Jfow0J1VisnJcpTvkplfihMepRNNj/ijDSrz UA== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33edq08ewf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 12:55:53 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 088Gpq65019622;
        Tue, 8 Sep 2020 16:55:48 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma01dal.us.ibm.com with ESMTP id 33d46mhtr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 16:55:48 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 088Gtlp455771562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Sep 2020 16:55:47 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91D8F124058;
        Tue,  8 Sep 2020 16:55:47 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D535D124052;
        Tue,  8 Sep 2020 16:55:46 +0000 (GMT)
Received: from Davids-MBP.randomparity.org (unknown [9.163.69.225])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  8 Sep 2020 16:55:46 +0000 (GMT)
Subject: Re: [PATCH net] tg3: Fix soft lockup when tg3_reset_task() fails.
To:     Michael Chan <michael.chan@broadcom.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, baptiste@arista.com
References: <1599157734-16354-1-git-send-email-michael.chan@broadcom.com>
From:   David Christensen <drc@linux.vnet.ibm.com>
Message-ID: <726c3fa7-9090-d8d1-d9f0-97e9f4445033@linux.vnet.ibm.com>
Date:   Tue, 8 Sep 2020 09:55:46 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1599157734-16354-1-git-send-email-michael.chan@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_08:2020-09-08,2020-09-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1011 bulkscore=0 impostorscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009080153
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/3/20 11:28 AM, Michael Chan wrote:
> If tg3_reset_task() fails, the device state is left in an inconsistent
> state with IFF_RUNNING still set but NAPI state not enabled.  A
> subsequent operation, such as ifdown or AER error can cause it to
> soft lock up when it tries to disable NAPI state.
> 
> Fix it by bringing down the device to !IFF_RUNNING state when
> tg3_reset_task() fails.  tg3_reset_task() running from workqueue
> will now call tg3_close() when the reset fails.  We need to
> modify tg3_reset_task_cancel() slightly to avoid tg3_close()
> calling cancel_work_sync() to cancel tg3_reset_task().  Otherwise
> cancel_work_sync() will wait forever for tg3_reset_task() to
> finish.
> 
> Reported-by: David Christensen <drc@linux.vnet.ibm.com>
> Reported-by: Baptiste Covolato <baptiste@arista.com>
> Fixes: db2199737990 ("tg3: Schedule at most one tg3_reset_task run")
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>

Thanks for the patch, I'll have some test time scheduled and let you know.

Dave
