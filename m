Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9F9A420C
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 06:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbfHaEVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 00:21:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44350 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfHaEVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 00:21:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7V4LX4B147968;
        Sat, 31 Aug 2019 04:21:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=r1tbZ6gDKY9auMKMvKdJ83EmU0NSBIfGEYX5Ce+i/C0=;
 b=CLUlot22Gkaur2YXLlQu3RxUhcwymZJNv1e+RPe45WipZZ7pYseRA+MxiQo5XidfbzP5
 edq9XfrggM2gNjR8BM1ZTL2aVwn8n7x9KtZXEHVJB7DnF1fk4ZfYFFM3L5uuEjp7rNaB
 XQxwtGbXBd84jDT+MaouEddNWLsfGmk+OiSmR1TeDp57MqghZVGn2oonIJHl9W9sY5WN
 /5pnDKlsba+JMJSa7VpkdqhbrrQbmiyc7WgWBtP7u3qn3w4RBRW+gLpkrQlJRLMr7fdH
 Auy8ArrGPyZdfzZPT19YBotqCDpW0fguZ44R0Ylhvoufhbs0Zcymqpg/W8PyBzzU2Bxg 5g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2uqhsng02f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 31 Aug 2019 04:21:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7V4IhpT117807;
        Sat, 31 Aug 2019 04:21:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2uqg80t0k9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 31 Aug 2019 04:21:15 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7V4LEwC023040;
        Sat, 31 Aug 2019 04:21:14 GMT
Received: from [10.182.71.192] (/10.182.71.192)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 30 Aug 2019 21:21:13 -0700
Subject: Re: [PATCH 1/1] forcedeth: use per cpu to collect xmit/recv
 statistics
To:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, nan.1986san@gmail.com
References: <1567154111-23315-1-git-send-email-yanjun.zhu@oracle.com>
 <1567154111-23315-2-git-send-email-yanjun.zhu@oracle.com>
 <24ad8394-cb24-fcb7-0dc2-3435429bb8cd@gmail.com>
From:   Zhu Yanjun <yanjun.zhu@oracle.com>
Organization: Oracle Corporation
Message-ID: <1a41e4fa-2fac-00f0-ca8a-7968a54b9b96@oracle.com>
Date:   Sat, 31 Aug 2019 12:24:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <24ad8394-cb24-fcb7-0dc2-3435429bb8cd@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908310047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908310047
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/8/30 17:32, Eric Dumazet wrote:
>
> On 8/30/19 10:35 AM, Zhu Yanjun wrote:
>> When testing with a background iperf pushing 1Gbit/sec traffic and running
>> both ifconfig and netstat to collect statistics, some deadlocks occurred.
>>
> This is quite a heavy patch trying to fix a bug...
This is to use per-cpu variable. Perhaps the changes are big.
>
> I suspect the root cause has nothing to do with stat
> collection since on 64bit arches there is no additional synchronization.
This bug is similar to the one that the commit 5f6b4e14cada ("net: dsa: 
User per-cpu 64-bit statistics") tries to fix.
So a similar patch is to fix this similar bug in forcedeth.
> (u64_stats_update_begin(), u64_stats_update_end() are nops)
Sure. Exactly.
>
>> +static inline void nv_get_stats(int cpu, struct fe_priv *np,
>> +				struct rtnl_link_stats64 *storage)
>> +{
>> +	struct nv_txrx_stats *src = per_cpu_ptr(np->txrx_stats, cpu);
>> +	unsigned int syncp_start;
>> +
>> +	do {
>> +		syncp_start = u64_stats_fetch_begin_irq(&np->swstats_rx_syncp);
>> +		storage->rx_packets       += src->stat_rx_packets;
>> +		storage->rx_bytes         += src->stat_rx_bytes;
>> +		storage->rx_dropped       += src->stat_rx_dropped;
>> +		storage->rx_missed_errors += src->stat_rx_missed_errors;
>> +	} while (u64_stats_fetch_retry_irq(&np->swstats_rx_syncp, syncp_start));
>> +
>> +	do {
>> +		syncp_start = u64_stats_fetch_begin_irq(&np->swstats_tx_syncp);
>> +		storage->tx_packets += src->stat_tx_packets;
>> +		storage->tx_bytes   += src->stat_tx_bytes;
>> +		storage->tx_dropped += src->stat_tx_dropped;
>> +	} while (u64_stats_fetch_retry_irq(&np->swstats_tx_syncp, syncp_start));
>> +}
>> +
>>
> This is buggy :
> If the loops are ever restarted, the storage->fields will have
> been modified multiple times.
Sure. Sorry. My bad.
A similar changes in the commit 5f6b4e14cada ("net: dsa: User per-cpu 
64-bit statistics").
I will use this similar changes.
I will send V2 soon.

Thanks a lot for your comments.

Zhu Yanjun

>
>
