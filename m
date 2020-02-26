Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88B7E16FB29
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 10:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbgBZJpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 04:45:03 -0500
Received: from mail-vi1eur05on2086.outbound.protection.outlook.com ([40.107.21.86]:18799
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727934AbgBZJpD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 04:45:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZIxeXepPDES96CNZc/QlMxWnlIJGCq3fyZzTGEiLLCg8odOMlAu0b2Nf3LdhLm9cjCT9xdbcctYRr/92N8h5cu/9bLwAJS8zfYV0egLyKOlhRSwgbnFPcMYUBjlbJp6EDxkj3woAiMXWwPkJ9tsqzaMzMyfEGppPPyNgvSFzgU6phs6LIEgcb8H9qthOPey8PvSj0ppcF+hZpIM2U87EklZKHehYRT5/cHl6BjllVpTWfIdu7+mnfGjkuNCV6b2jXRXV/GzUkje4Nitp2ZfPZW3Cd/JiSLab0OW5ImielB6CIq1m6hqgrfRhmywoP6xtWVPQzcuIlb2FF+k0C7kAVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZjgg5+bZz/YF+Qx02D6k7rzcODm5ecIf9NOXWff3sc=;
 b=PpGsWq6e1IPjIfs0Ug8iqDYEi+O4kazoWUsUCESB+X54pF25oYVjGWbPv00giKG+IHc4Ev5y8k6dbsAoozo89TlR0yEDyYajJp92F+gJzmJesvxmgEPDjbR4k1pybJXdRrn4brXsl5NPLTbfZiXMAN6mtS0moLA966647YFURJRcvpR7IrbMdyxBFcGS8EJ0ZbAxjNa5wHW2s7zvU6xBUWygLiHxgfdT0UvzQ5d1C8/dgAbscJbEuNs7OVhApdnOVa7hjqzncWotkiepf0yx2U6weiwtcIuOvFuffMs2dx6NmpHndYuzeZGEjMQj/x+r9UOcciD6h5beoOniDu9SmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZjgg5+bZz/YF+Qx02D6k7rzcODm5ecIf9NOXWff3sc=;
 b=e8xzgBWVHHo3AW9dhLqLqR1jrrdEK25Ryib4D5fmIUYoyXJ+VSLKM0nnJAJg51j4dTL48RwVjQv4LJTVvVNSEQ1G4zSdDFWUv1t273mB4D6kCeL/xRxXORBw6B07gwUyQkTMqilaDnrmlV8XP3aLcYo2cAPJRAx++Duyyv9kGr8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (20.177.36.78) by
 AM6PR05MB5554.eurprd05.prod.outlook.com (20.177.189.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Wed, 26 Feb 2020 09:44:57 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4%7]) with mapi id 15.20.2750.021; Wed, 26 Feb 2020
 09:44:57 +0000
Subject: Re: [PATCH net-next 4/6] net/sched: act_ct: Create nf flow table per
 zone
To:     Edward Cree <ecree@solarflare.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1582458307-17067-1-git-send-email-paulb@mellanox.com>
 <1582458307-17067-5-git-send-email-paulb@mellanox.com>
 <97c2e036-6334-9818-f8cd-4c2671273eed@solarflare.com>
From:   Paul Blakey <paulb@mellanox.com>
Message-ID: <a6f0dc1c-e271-329c-509f-045f1b400e1c@mellanox.com>
Date:   Wed, 26 Feb 2020 11:44:52 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <97c2e036-6334-9818-f8cd-4c2671273eed@solarflare.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: ZR0P278CA0018.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::28) To AM6PR05MB5096.eurprd05.prod.outlook.com
 (2603:10a6:20b:11::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.223.6.3] (193.47.165.251) by ZR0P278CA0018.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.22 via Frontend Transport; Wed, 26 Feb 2020 09:44:56 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 10ba81c9-e9c4-4985-0eb0-08d7baa08a48
X-MS-TrafficTypeDiagnostic: AM6PR05MB5554:|AM6PR05MB5554:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB55545300666A227FEFEC2E8FCFEA0@AM6PR05MB5554.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0325F6C77B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(199004)(189003)(5660300002)(81156014)(8676002)(81166006)(2906002)(36756003)(52116002)(26005)(8936002)(31686004)(66556008)(66476007)(16526019)(186003)(6636002)(66946007)(53546011)(956004)(2616005)(478600001)(110136005)(31696002)(86362001)(6486002)(316002)(16576012)(6666004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5554;H:AM6PR05MB5096.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w+Y95hCKNTGR+pMq005psRpwJDxfKLmtWNOHdgNEn6xrHJuLz8r2AYQe55F6PO56oQZXOcYCkHccEePytbaNw7TIOARt3mWfxTYUNo6Plqzy2m4htujtuE+ZSn8+QV1AOD0ngYRn94tYB47ArpRuwP7JMvVA2LABjMFwUvOu13x31gVfCC+GIwQGX3p5+8qWrqyGLP9zQVl8LZ9FKHoBEXxy0+1A5KDzWtaxawS/VWjHx/Tg/q1Kh5WzTKBC3aUxFAoqr8aFMoEF9yYVHG7HNq/Pfks/2cQAc9zu9pZC/3dU3rDazRx3zyhNl7tUNhfLk4vlgTRwNMwAA+byyr251rwYiz7IurxucrafZnI8PWl32fk8xxlXD4dQ8EKOsQrBawqnlRT5Wz1X+0Z1n+QI/BbzF33EirH/0t+e6Q6V/xvOKmS0eL/I0t20/YmsgDke
X-MS-Exchange-AntiSpam-MessageData: +m7luKycsDT0dUSnMc18wzr5mB7hetg2/TLtsLapcFTa4RDSvHL6t5tDxxxN3SfaIwbrGj3UwwAwKAfiUIXfMfvoNr7r4o2KI7CfmOZBQt74RbU4qlDyoqB/VC5bgkSasdEpNXpImmaXD3nZJ86fWg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10ba81c9-e9c4-4985-0eb0-08d7baa08a48
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2020 09:44:57.5355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: idRiHOPQgneF7Fv7tPGbxh+mA24F34U2XFtWMs/rpdTE/F9AltYpSF01MmLQCayLu1felphgwWAVJm16yTOmhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5554
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/24/2020 5:58 PM, Edward Cree wrote:
> On 23/02/2020 11:45, Paul Blakey wrote:
>> Use the NF flow tables infrastructure for CT offload.
>>
>> Create a nf flow table per zone.
>>
>> Next patches will add FT entries to this table, and do
>> the software offload.
>>
>> Signed-off-by: Paul Blakey <paulb@mellanox.com>
>> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
>> ---
>>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c |   1 +
>>  include/net/tc_act/tc_ct.h                      |   2 +
>>  net/sched/Kconfig                               |   2 +-
>>  net/sched/act_ct.c                              | 159 +++++++++++++++++++++++-
>>  4 files changed, 162 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> index 70b5fe2..eb16136 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> @@ -45,6 +45,7 @@
>>  #include <net/tc_act/tc_tunnel_key.h>
>>  #include <net/tc_act/tc_pedit.h>
>>  #include <net/tc_act/tc_csum.h>
>> +#include <net/tc_act/tc_ct.h>
>>  #include <net/arp.h>
>>  #include <net/ipv6_stubs.h>
>>  #include "en.h"
>> diff --git a/include/net/tc_act/tc_ct.h b/include/net/tc_act/tc_ct.h
>> index a8b1564..cf3492e 100644
>> --- a/include/net/tc_act/tc_ct.h
>> +++ b/include/net/tc_act/tc_ct.h
>> @@ -25,6 +25,8 @@ struct tcf_ct_params {
>>  	u16 ct_action;
>>  
>>  	struct rcu_head rcu;
>> +
>> +	struct tcf_ct_flow_table *ct_ft;
>>  };
>>  
>>  struct tcf_ct {
>> diff --git a/net/sched/Kconfig b/net/sched/Kconfig
>> index edde0e5..bfbefb7 100644
>> --- a/net/sched/Kconfig
>> +++ b/net/sched/Kconfig
>> @@ -972,7 +972,7 @@ config NET_ACT_TUNNEL_KEY
>>  
>>  config NET_ACT_CT
>>  	tristate "connection tracking tc action"
>> -	depends on NET_CLS_ACT && NF_CONNTRACK && NF_NAT
>> +	depends on NET_CLS_ACT && NF_CONNTRACK && NF_NAT && NF_FLOW_TABLE
> Is it not possible to keep sensible/old behaviour in the case
>  of NF_FLOW_TABLE=n?  (And what about NF_FLOW_TABLE=m, which is
>  what its Kconfig help seems to advise...)

No problem with it being a module.

It is possible to allow compilation without flow table, but it will create confusion for people trying

to offload conntrack, as it would silently not happen.

>
>>  	help
>>  	  Say Y here to allow sending the packets to conntrack module.
>>  
>> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
>> index f685c0d..4267d7d 100644
>> --- a/net/sched/act_ct.c
>> +++ b/net/sched/act_ct.c
>> @@ -15,6 +15,7 @@
>>  #include <linux/pkt_cls.h>
>>  #include <linux/ip.h>
>>  #include <linux/ipv6.h>
>> +#include <linux/rhashtable.h>
>>  #include <net/netlink.h>
>>  #include <net/pkt_sched.h>
>>  #include <net/pkt_cls.h>
>> @@ -24,6 +25,7 @@
>>  #include <uapi/linux/tc_act/tc_ct.h>
>>  #include <net/tc_act/tc_ct.h>
>>  
>> +#include <net/netfilter/nf_flow_table.h>
>>  #include <net/netfilter/nf_conntrack.h>
>>  #include <net/netfilter/nf_conntrack_core.h>
>>  #include <net/netfilter/nf_conntrack_zones.h>
>> @@ -31,6 +33,133 @@
>>  #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
>>  #include <uapi/linux/netfilter/nf_nat.h>
>>  
>> +static struct workqueue_struct *act_ct_wq;
>> +
>> +struct tcf_ct_flow_table {
>> +	struct rhash_head node; /* In zones tables */
>> +
>> +	struct rcu_work rwork;
>> +	struct nf_flowtable nf_ft;
>> +	u16 zone;
>> +	u32 ref;
> Any reason this isn't using a refcount_t?
> -ed
it is updated under lock, so there was no need for atomic as well
