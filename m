Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 106E51A1A24
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 04:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgDHCwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 22:52:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45576 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726428AbgDHCwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 22:52:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0382n5jm185735;
        Wed, 8 Apr 2020 02:52:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=CYyLdE1lEs1p3pDXngh3mDcweEE8nuGYbpPn1QMMnhA=;
 b=xZBlcWXgPmFD01QwcZpmElr4tHtdSbsJ7bva5JsY0bpfmYrzA7+iqip35mMm5eP7862d
 O2tscbOrfLr9rjhAICg/XWJma7ECKneIfWu0Fs4sPDs42p6/n47+4ElHc7BkewCLVNFd
 A+o4QeJX4ix7KLT7p4Po3SqCTuEen6ea8ml566D+h29ppqeGTbEX1WKJmv6REpzT5i5+
 9gWQRBtPkQhdsNNMqfSub6yX2w+9RtDgQp80sEul2gpUk9O9JdCPLQa4EE1ltv2f+Tad
 +Z6mGZz03AXybwE7J+4jiFid4vHrcck2RrHQfPE4z4rj5BPSYVXSomnfqKNHbv05MUos hA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 3091mngqfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 02:52:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0382kg90012759;
        Wed, 8 Apr 2020 02:52:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3091kgcw3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 08 Apr 2020 02:52:16 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0382mUOa016708;
        Wed, 8 Apr 2020 02:52:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 3091kgcw2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 02:52:15 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0382qFX4023374;
        Wed, 8 Apr 2020 02:52:15 GMT
Received: from [10.159.153.50] (/10.159.153.50)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Apr 2020 19:52:14 -0700
Subject: Re: [PATCH net 2/2] net/rds: Fix MR reference counting problem
To:     zerons <sironhide0null@gmail.com>,
        Ka-Cheong Poon <ka-cheong.poon@oracle.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, rds-devel@oss.oracle.com
References: <4b96ea99c3f0ccd5cc0683a5c944a1c4da41cc38.1586275373.git.ka-cheong.poon@oracle.com>
 <a99e79aa8515e4b52ced83447122fbd260104f0f.1586275373.git.ka-cheong.poon@oracle.com>
 <96f17f7d-365c-32ec-2efe-a6a5d9d306b7@oracle.com>
 <e1853439-fe73-14d1-a57c-1a67341a7f8a@gmail.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <8db99ccf-d762-8ec6-5439-732ad5b30f8e@oracle.com>
Date:   Tue, 7 Apr 2020 19:52:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <e1853439-fe73-14d1-a57c-1a67341a7f8a@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 mlxlogscore=999 mlxscore=0 priorityscore=1501 bulkscore=0 adultscore=0
 impostorscore=0 phishscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004080016
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/7/20 7:25 PM, zerons wrote:
> On 4/8/20 03:30, santosh.shilimkar@oracle.com wrote:
>> On 4/7/20 9:08 AM, Ka-Cheong Poon wrote:
>>> In rds_free_mr(), it calls rds_destroy_mr(mr) directly.  But this
>>> defeats the purpose of reference counting and makes MR free handling
>>> impossible.  It means that holding a reference does not guarantee that
>>> it is safe to access some fields.  For example, In
>>> rds_cmsg_rdma_dest(), it increases the ref count, unlocks and then
>>> calls mr->r_trans->sync_mr().  But if rds_free_mr() (and
>>> rds_destroy_mr()) is called in between (there is no lock preventing
>>> this to happen), r_trans_private is set to NULL, causing a panic.
>>> Similar issue is in rds_rdma_unuse().
>>>
>>> Reported-by: zerons <sironhide0null@gmail.com>
>>> Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
>>> ---
>> Thanks for getting this out on the list.
>>
>> Hi zerons,
>> Can you please review it and see it addresses your concern ?
>>
> 
> Yes, the MR gets freed only when the ref count decreases to zero does
> address my concern. I think it make the logic cleaner as well. Fantastic!
> 
Thanks for confirmation.

FWIW,
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
