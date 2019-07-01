Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD59C5C458
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 22:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfGAUdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 16:33:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50796 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbfGAUdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 16:33:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61KVLEj175533;
        Mon, 1 Jul 2019 20:33:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=jEzPNLZ02t3QphNpzsBM68qrnjuWWKL/cytX9RD0wA4=;
 b=wVw1RdJoKCyXkaEDuIBugEWfazkM29AP5gTAS3HDTPMpFQH7bBBy1e1fRzOz9HFYzetR
 0exfrcrFL2Q/0Lae3SNQ+zkzoNqIN2j1/Raoqx9NpiUr15M1CE0xw3kmyfy1tOkVqfSZ
 JziNgOJdoDX49Ec8m+J/LZgM1Nuh2qn4D4JdNV4DLXLNG7EcHB89p8YdUHt1tnJza5Q3
 aJ5FwHI/+OJkeau+LDUxCwtofkCbqUvgre0CFj6R2GyDDqwgRBRF3/FMQjZohJe9wEoh
 CTijgRymK92zgX26bNkUbuwD85Bpd6udj8KS4phieozRe4d9t7NU0L0W1k595YmUy+Og cQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2te61pqswm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 20:33:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61KXD4n129025;
        Mon, 1 Jul 2019 20:33:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2tebktvvnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 20:33:13 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x61KX9KI009720;
        Mon, 1 Jul 2019 20:33:09 GMT
Received: from [10.209.242.148] (/10.209.242.148)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jul 2019 13:33:09 -0700
Subject: Re: [PATCH net-next 2/7] net/rds: Get rid of "wait_clean_list_grace"
 and add locking
To:     Gerd Rausch <gerd.rausch@oracle.com>, netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
References: <5c49f180-0dbf-88b9-965d-6cb88061f31b@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <02ee3384-fccf-e7c9-8e09-49d8dc70faf3@oracle.com>
Date:   Mon, 1 Jul 2019 13:33:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <5c49f180-0dbf-88b9-965d-6cb88061f31b@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907010238
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907010237
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/19 9:39 AM, Gerd Rausch wrote:
> Waiting for activity on the "clean_list" to quiesce is no substitute
> for proper locking.
> 
> We can have multiple threads competing for "llist_del_first"
> via "rds_ib_reuse_mr", and a single thread competing
> for "llist_del_all" and "llist_del_first" via "rds_ib_flush_mr_pool".
> 
> Since "llist_del_first" depends on "list->first->next" not to change
> in the midst of the operation, simply waiting for all current calls
> to "rds_ib_reuse_mr" to quiesce across all CPUs is woefully inadequate:
> 
> By the time "wait_clean_list_grace" is done iterating over all CPUs to see
> that there is no concurrent caller to "rds_ib_reuse_mr", a new caller may
> have just shown up on the first CPU.
> 
> Furthermore, <linux/llist.h> explicitly calls out the need for locking:
>   * Cases where locking is needed:
>   * If we have multiple consumers with llist_del_first used in one consumer,
>   * and llist_del_first or llist_del_all used in other consumers,
>   * then a lock is needed.
> 
> Also, while at it, drop the unused "pool" parameter
> from "list_to_llist_nodes".
> 
> Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
> ---
Looks good.
