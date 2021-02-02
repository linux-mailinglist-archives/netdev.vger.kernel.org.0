Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B273030BD5B
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 12:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbhBBLrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 06:47:21 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:16195 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbhBBLrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 06:47:18 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60193b9e0000>; Tue, 02 Feb 2021 03:46:38 -0800
Received: from [172.27.13.225] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 2 Feb
 2021 11:46:33 +0000
Subject: Re: [PATCH iproute2-next] tc/htb: Hierarchical QoS hardware offload
To:     David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yossi Kuperman <yossiku@nvidia.com>,
        "Dan Carpenter" <dan.carpenter@oracle.com>,
        <netdev@vger.kernel.org>,
        "Maxim Mikityanskiy" <maximmi@mellanox.com>
References: <20201215074213.32652-1-maximmi@mellanox.com>
 <8c818766-ec3f-4c0b-f737-ec558613b946@gmail.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
Message-ID: <01ce90dc-9880-ccad-cce4-e13dc22f8118@nvidia.com>
Date:   Tue, 2 Feb 2021 13:46:29 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <8c818766-ec3f-4c0b-f737-ec558613b946@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612266398; bh=Cm2jx4tcYVYpM3opO+2yczc13itYdmPiX05wpbe8+/w=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=e+MisvYbksczjXVQQBsOwvlj3O3atnovxUII52L0JCl8GnrD3xAcL1EF3oVEuN3ue
         /pDcdABys6ChlWpPZJ7glEu1Y4QyRbgkmDg91HopOOs3teiI0FAM/4vYHlLezb8MqH
         VeNN8JDfwwWOJCkXmdqt5P5D30gEPs75G5kbnrRunRieF7R2makDK2ShYJZmb+Cbk8
         LpizYS2BNX4ZF+cFdUOiGZxweFyz0XBzJP+T2p3qCOcbRkKNWoJHq2HiSPeQndZCej
         7YmvnpqEfW+VA/TSPPciogOrYr+YOnyBvv962p8o6sdB3Y+GdTY/ZSuaT/k0ZLjHCU
         iQn+6QovMAVYw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-29 18:05, David Ahern wrote:
> On 12/15/20 12:42 AM, Maxim Mikityanskiy wrote:
>> This commit adds support for configuring HTB in offload mode. HTB
>> offload eliminates the single qdisc lock in the datapath and offloads
>> the algorithm to the NIC. The new 'offload' parameter is added to
>> enable this mode:
>>
>>      # tc qdisc replace dev eth0 root handle 1: htb offload
>>
>> Classes are created as usual, but filters should be moved to clsact for
>> lock-free classification (filters attached to HTB itself are not
>> supported in the offload mode):
>>
>>      # tc filter add dev eth0 egress protocol ip flower dst_port 80
>>      action skbedit priority 1:10
> 
> please add the dump in both stdout and json here.

Do you mean to add example output to the commit message?

>>
>> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
>> ---
>>   include/uapi/linux/pkt_sched.h | 1 +
>>   tc/q_htb.c                     | 9 ++++++++-
> 
> missing an update to man/man8/tc-htb.8

OK, I'll add.

>>   2 files changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
>> index 9e7c2c60..79a699f1 100644
>> --- a/include/uapi/linux/pkt_sched.h
>> +++ b/include/uapi/linux/pkt_sched.h
>> @@ -434,6 +434,7 @@ enum {
>>   	TCA_HTB_RATE64,
>>   	TCA_HTB_CEIL64,
>>   	TCA_HTB_PAD,
>> +	TCA_HTB_OFFLOAD,
>>   	__TCA_HTB_MAX,
>>   };
>>   
>> diff --git a/tc/q_htb.c b/tc/q_htb.c
>> index c609e974..fd11dad6 100644
>> --- a/tc/q_htb.c
>> +++ b/tc/q_htb.c
>> @@ -30,11 +30,12 @@
>>   static void explain(void)
>>   {
>>   	fprintf(stderr, "Usage: ... qdisc add ... htb [default N] [r2q N]\n"
>> -		"                      [direct_qlen P]\n"
>> +		"                      [direct_qlen P] [offload]\n"
>>   		" default  minor id of class to which unclassified packets are sent {0}\n"
>>   		" r2q      DRR quantums are computed as rate in Bps/r2q {10}\n"
>>   		" debug    string of 16 numbers each 0-3 {0}\n\n"
>>   		" direct_qlen  Limit of the direct queue {in packets}\n"
>> +		" offload  hardware offload\n"
> 
> why 'offload hardware offload'? does not make sense to me and

"offload" is a new parameter, and "hardware offload" is the description, 
just like the other parameters above.

> you don't
> reference hardware below.

Where should I reference it?

> 
> 
> 
>>   		"... class add ... htb rate R1 [burst B1] [mpu B] [overhead O]\n"
>>   		"                      [prio P] [slot S] [pslot PS]\n"
>>   		"                      [ceil R2] [cburst B2] [mtu MTU] [quantum Q]\n"
>> @@ -68,6 +69,7 @@ static int htb_parse_opt(struct qdisc_util *qu, int argc,
>>   	};
>>   	struct rtattr *tail;
>>   	unsigned int i; char *p;
>> +	bool offload = false;
>>   
>>   	while (argc > 0) {
>>   		if (matches(*argv, "r2q") == 0) {
>> @@ -91,6 +93,8 @@ static int htb_parse_opt(struct qdisc_util *qu, int argc,
>>   			if (get_u32(&direct_qlen, *argv, 10)) {
>>   				explain1("direct_qlen"); return -1;
>>   			}
>> +		} else if (matches(*argv, "offload") == 0) {
>> +			offload = true;
>>   		} else {
>>   			fprintf(stderr, "What is \"%s\"?\n", *argv);
>>   			explain();
>> @@ -103,6 +107,8 @@ static int htb_parse_opt(struct qdisc_util *qu, int argc,
>>   	if (direct_qlen != ~0U)
>>   		addattr_l(n, 2024, TCA_HTB_DIRECT_QLEN,
>>   			  &direct_qlen, sizeof(direct_qlen));
>> +	if (offload)
>> +		addattr(n, 2024, TCA_HTB_OFFLOAD);
>>   	addattr_nest_end(n, tail);
>>   	return 0;
>>   }
>> @@ -344,6 +350,7 @@ static int htb_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
>>   		print_uint(PRINT_ANY, "direct_qlen", " direct_qlen %u",
>>   			   direct_qlen);
>>   	}
>> +	print_uint(PRINT_ANY, "offload", " offload %d", !!tb[TCA_HTB_OFFLOAD]);
>>   	return 0;
>>   }
>>   
>>
> 

