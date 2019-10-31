Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 440C2EB37C
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 16:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbfJaPJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 11:09:50 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49132 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbfJaPJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 11:09:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9VF4KvB013590;
        Thu, 31 Oct 2019 15:09:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=g5FDpzysK/Tdx/b7QD8MBg2VCo9YaQaUV9WG6V5S8AI=;
 b=MpyuFAMnzUaYVhcRpFe7vw9AaYuDjDIvwr7gin4v6BM3aw3Z056PzWpSICE4TW8xjfSk
 5oRW3sS5x40ZqCTTFmB5iQWaCiE+PnYyDoUk8Oq0XFxg1RPH1MxT35cMSUaKgOvjUaUR
 uYhcllghOb/ajNsDpNaIpHCtq07iWd+9mi549EG9ojx0G36Fvu5IzYA6kMmqpf0QBMCr
 fb1hF8RwKyGTyYKJFy+4Mo5anZ2smscfE0Akr9mV9ukcwdOVak+phEIJry1HmUzzStnT
 m5eo0RW160tXurEFc30OL79JSCgbjyusOGQK5/pxeAtSBkHrlieab1wm/iBQ3pD8pWIc ng== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2vxwhfm0g1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Oct 2019 15:09:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9VEx2r4109170;
        Thu, 31 Oct 2019 15:09:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2vykw1gj09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 31 Oct 2019 15:09:41 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x9VF92YY145957;
        Thu, 31 Oct 2019 15:09:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2vykw1ghyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Oct 2019 15:09:41 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9VF9eqa000316;
        Thu, 31 Oct 2019 15:09:41 GMT
Received: from [10.172.157.165] (/10.172.157.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Oct 2019 08:09:40 -0700
Subject: Re: [PATCH net-next] rds: Cancel pending connections on connection
 request
To:     santosh.shilimkar@oracle.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc:     davem@davemloft.net, haakon.bugge@oracle.com
References: <1572528956-8504-1-git-send-email-dag.moxnes@oracle.com>
From:   Dag Moxnes <dag.moxnes@oracle.com>
Message-ID: <51893d36-492b-b345-b8c4-93110c4de7f8@oracle.com>
Date:   Thu, 31 Oct 2019 16:09:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1572528956-8504-1-git-send-email-dag.moxnes@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9426 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910310154
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This one should be for net instead of net-next.
Also it is not correct.
I will send a new patch for net.

-Dag

On 10/31/19 2:35 PM, Dag Moxnes wrote:
> RDS connections can enter the RDS_CONN_CONNECTING state in two ways:
> 1. It can be started using the connection workqueue (this can happen
> both on queue_reconnect and upon send if the workqueue is not up)
> 2. It can enter the RDS_CONN_CONNECTING state due to an incoming
> connection request
>
> In case RDS connections enter RDS_CONN_CONNECTION state due to an incoming
> connection request, the connection workqueue might already be scheduled. In
> this case the connection workqueue needs to be cancelled.
>
> Signed-off-by: Dag Moxnes <dag.moxnes@oracle.com>
> ---
>   net/rds/ib_cm.c | 6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
> index 6b345c858d..1fdd76f70d 100644
> --- a/net/rds/ib_cm.c
> +++ b/net/rds/ib_cm.c
> @@ -880,6 +880,12 @@ int rds_ib_cm_handle_connect(struct rdma_cm_id *cm_id,
>   			rds_ib_stats_inc(s_ib_connect_raced);
>   		}
>   		goto out;
> +	} else {
> +		/* Cancel any pending reconnect */
> +		struct rds_conn_path *cp = &conn->c_path[0];
> +
> +		cancel_delayed_work_sync(&cp->cp_conn_w);
> +		rds_clear_reconnect_pending_work_bit(cp);
>   	}
>   
>   	ic = conn->c_transport_data;

