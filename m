Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF0B5DAF7
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 03:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbfGCBfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 21:35:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56210 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbfGCBfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 21:35:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x62L4A7T045122;
        Tue, 2 Jul 2019 21:06:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=YRVdh/QvvmuFoDlYH5iB/0tut28mWlxoXt9DsbVVIrk=;
 b=RYyOz4v89UK+/Sz/9A+xdBwAtWkmjbHeG6M/udGj6bWCWe4miTS9lCVuBMnh1N7r02Hs
 XQkP7EuXqc4N5/8nfOUs6xo20caDZk7DoqQyCnVnpGGDbDfGdxqauDja80Ma0R1wp+bZ
 IkxTw52Hq+ELs4CEZm9Y+pDcryKqgNQLrrClUu2peeE/cdkCthnGaR3vNAvmf8u5IeeX
 VzLgh7KQS9GuURWJ4m1GLdO5YzwA1BoLzvaVs52fu+XMQg1rb0Z2CG0N/NsC1AvR73Y1
 /+r2bMHvqfniR/R12af0YQERIyTthrcUVmaKerRS5Ggd0ZbVWf0e97/wNlujyRFY8m9I vQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2te5tbnyjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jul 2019 21:06:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x62L353D016908;
        Tue, 2 Jul 2019 21:06:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2tebam0de4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jul 2019 21:06:02 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x62L60Mv013136;
        Tue, 2 Jul 2019 21:06:01 GMT
Received: from [10.211.54.238] (/10.211.54.238)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jul 2019 14:06:00 -0700
Subject: Re: [PATCH net-next 3/7] net/rds: Wait for the FRMR_IS_FREE (or
 FRMR_IS_STALE) transition after posting IB_WR_LOCAL_INV
To:     santosh.shilimkar@oracle.com, netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
References: <505e9af7-a0cd-bf75-4a72-5d883ee06bf1@oracle.com>
 <c79821e0-307c-5736-6eb5-e20983097345@oracle.com>
 <01c251f4-c8f8-fcb8-bccc-341d4a3db90a@oracle.com>
 <b5669540-3892-9d79-85ba-79e96ddd3a81@oracle.com>
 <14c34ac2-38ed-9d51-f27d-74120ff34c54@oracle.com>
 <79d25e7c-ad9e-f6d8-b0fe-4ce04c658e1e@oracle.com>
 <6ff00a46-07f6-7be2-8e75-c87448568aa4@oracle.com>
 <d7ab5505-92e5-888c-a230-77bce3540261@oracle.com>
From:   Gerd Rausch <gerd.rausch@oracle.com>
Message-ID: <697adfba-ac8b-db4d-5819-f4c22ec6c76a@oracle.com>
Date:   Tue, 2 Jul 2019 14:05:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <d7ab5505-92e5-888c-a230-77bce3540261@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9306 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907020233
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9306 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907020233
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/07/2019 09.49, santosh.shilimkar@oracle.com wrote:
> On 7/1/19 10:11 PM, Gerd Rausch wrote:
>> For the registration work-requests there is a benefit to wait a short
>> amount of time only (the trade-off described in patch #1 of this series).
>>
> Actually we should just switch this code to what Avinash has
> finally made in downstream code. That keeps the RDS_GET_MR
> semantics and makes sure MR is really valid before handing over
> the key to userland. There is no need for any timeout
> for registration case.
> 

What do you call "RDS_GET_MR" semantics?

The purpose of waiting for a IB_WR_REG_MR request to complete
(inside rds_ib_post_reg_frmr) is in fact to make sure
the memory region is valid.

Regardless of this being true after a specific time-out,
or an infinite timeout.

For the non-infinite time-out case, there is a check if the request
was handled by the firmware.

And if a time-out occurred and the firmware didn't handle the request,
function "rds_ib_post_reg_frmr" will return -EBUSY.

>> Actually, no:
>> Socket option RDS_GET_MR wasn't even in the code-path of the
>> tests I performed:
>>
>> It were there RDS_CMSG_RDMA_MAP / RDS_CMSG_RDMA_DEST control
>> messages that ended up calling '__rds_rdma_map".
>>
> What option did you use ? Default option with rds-stress is
> RDS_GET_MR and hence the question.
> 

Not true!:

Socket option RDS_GET_MR is only used by "rds-stress"
if it is invoked with "--rdma-use-get-mr <non-zero-value>".

Verify this with the following patch applied to rds-tools-2.0.7-1.18:
--- a/rds-stress.c
+++ b/rds-stress.c
@@ -705,6 +705,7 @@ static uint64_t get_rdma_key(int fd, uint64_t addr, uint32_t size)
        if (opt.rdma_use_once)
                mr_args.flags |= RDS_RDMA_USE_ONCE;
 
+       abort();
        if (setsockopt(fd, sol, RDS_GET_MR, &mr_args, sizeof(mr_args)))
                die_errno("setsockopt(RDS_GET_MR) failed (%u allocated)", mrs_allocated);


And why is socket option RDS_GET_MR a subject of this discussion?

The proposed patch suggests to wait for a firmware response in handling
_all_ cases that end up in "rds_ib_post_reg_frmr", issuing a "IB_WR_REG_MR" request.

It doesn't matter where they came from:
Whether they came from an RDS_GET_MR socket option, or a  RDS_CMSG_RDMA_MAP:
They all go through "__rds_rdma_map" and end up calling "rds_ib_get_mr".

How is socket option RDS_GET_MR special with regards to this proposed fix?

>> I don't understand, please elaborate:
>> a) Are you saying this issue should not be fixed?
>> b) Or are you suggesting to replace this fix with a different fix?
>>     If it's the later, please point out what you have in mind.
>> c) ???
>>
> All am saying is the code got changed for good reason and that changed
> code makes some of these race conditions possibly not applicable.

I don't understand this. Please elaborate.

> So instead of these timeout fixes, am suggesting to use that
> code as fix. At least test it with those changes and see whats
> the behavior.
> 

Are you suggesting to
a) Not fix this bug right now and wait until some later point in time
b) Use a different fix. If you've got a different fix, please share.

And besides these options, is there anything wrong with this fix
(other than the discussion of what the timeout value ought to be,
 which we can address)?

Thanks,

  Gerd

