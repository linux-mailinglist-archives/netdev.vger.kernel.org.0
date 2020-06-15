Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9003D1F9AEE
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 16:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730768AbgFOOxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 10:53:30 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46538 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728304AbgFOOx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 10:53:27 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05FE3MBf118291;
        Mon, 15 Jun 2020 10:53:22 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31mut93jy2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Jun 2020 10:53:22 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05FEnYeU003902;
        Mon, 15 Jun 2020 14:53:19 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03dal.us.ibm.com with ESMTP id 31nbyu2fx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Jun 2020 14:53:19 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05FEqGmN23593380
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jun 2020 14:52:16 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57E59136060;
        Mon, 15 Jun 2020 14:52:18 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67CBB136051;
        Mon, 15 Jun 2020 14:52:17 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.65.236.85])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 15 Jun 2020 14:52:17 +0000 (GMT)
Subject: Re: [PATCH net] ibmvnic: Harden device login requests
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        danymadden@us.ibm.com
References: <1591986699-19484-1-git-send-email-tlfalcon@linux.ibm.com>
 <20200612.141040.977929535227856014.davem@davemloft.net>
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Message-ID: <890cfb19-b443-c0ca-100f-2814a5212844@linux.ibm.com>
Date:   Mon, 15 Jun 2020 09:52:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200612.141040.977929535227856014.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-15_02:2020-06-15,2020-06-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0
 cotscore=-2147483648 lowpriorityscore=0 malwarescore=0 bulkscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 phishscore=0 clxscore=1011
 suspectscore=0 priorityscore=1501 impostorscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006150111
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/12/20 4:10 PM, David Miller wrote:
> From: Thomas Falcon <tlfalcon@linux.ibm.com>
> Date: Fri, 12 Jun 2020 13:31:39 -0500
>
>> @@ -841,13 +841,14 @@ static int ibmvnic_login(struct net_device *netdev)
>>   {
>>   	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
>>   	unsigned long timeout = msecs_to_jiffies(30000);
>> +	int retries = 10;
>>   	int retry_count = 0;
>>   	bool retry;
>>   	int rc;
> Reverse christmas tree, please.

Oops, sending a v2 soon.

Thanks,

Tom

