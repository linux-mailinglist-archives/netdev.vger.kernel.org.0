Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B188B19FF05
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 22:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgDFU0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 16:26:17 -0400
Received: from mail-eopbgr10062.outbound.protection.outlook.com ([40.107.1.62]:49411
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725957AbgDFU0Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 16:26:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AeNH/jFHaILf6JpJxYKJ+5yiQBCqqatq6bXK5oJoeTnkt+HFPdUbAHTjIsdWmEPvmysGXo2Kg8SlqH2yN0wnPhUamXbHQKHrlr6IVaJVsiR+4bsMJ53lRIXjCUzeM4n7/Y+Nshr6cdRADnnVzk7+e/q8r73KZBJF25cAOqeC+Ml2W3FFom6+VYkBCy45fzQLs9abm/ezarKZch1PQJSSVD7/WWZoCiGjnWIwDZztADHgG+zhIJB48TX0yOfyV81fG2DvKf/rXnkAxxlpZfoXWUdAw3UEtVV+VSOnUVgxDZ3mOL7jYjwwHojMyKKIalDHKDnbGRdm/WmFTcgSRnnilw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+z2OJkzJA6u5AM6g8G/MpN7qmmcIGTIXRiHyEf8jlco=;
 b=L64MjdQUd7uNRuf0ID4IbrjroIfF5qHCD1CpUb/cq/Jsv+Pj+0rswQUhxLG7Zx5xYg2LLRBoluNTPTg/sCruilPg4EcM1sGE9ZUjfDhcxEnr98js28E4UXRIbfkjRaurmR8luyOWwUmYg2X8EzVUilLtHDZ28wK9Nk5Tt0R5N4I7HlnKdeSe2P/A/h0NiLckHvf0XKf5x4xvINNa05Vy1OZRA678irhI+6EOmBG3euvdBrveT5TBP3wOWc1E59FLOcZqpGrvXHs2HH7SMDREdU7a7LzlzK7ZjT2OAIUEJiyjO8C0t3OXx8ELwktRHQUWx/2JmDkFxRlbk2d+hr1+1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+z2OJkzJA6u5AM6g8G/MpN7qmmcIGTIXRiHyEf8jlco=;
 b=UiGjSyTiLZyXab7Fq2a3oF8SqIwxre8++VX2wpC7gLUlY5JFR7SsefRjGLxVnMeDWAq0+aWmLH5cAY+81q5LpPWW6KObhz6YMj/F6uZaUUsdwEaRoC9wvTRJY7tTpIUNJXMzO1/GuehpFJCylUUESgM6WjZj0g/02P/bsVALHqY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=yossiku@mellanox.com; 
Received: from DB6PR05MB4775.eurprd05.prod.outlook.com (2603:10a6:6:4c::32) by
 DB6PR05MB3414.eurprd05.prod.outlook.com (2603:10a6:6:1a::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2878.21; Mon, 6 Apr 2020 20:26:12 +0000
Received: from DB6PR05MB4775.eurprd05.prod.outlook.com
 ([fe80::942e:5673:6d48:d362]) by DB6PR05MB4775.eurprd05.prod.outlook.com
 ([fe80::942e:5673:6d48:d362%3]) with mapi id 15.20.2878.021; Mon, 6 Apr 2020
 20:26:12 +0000
Subject: Re: [RFC] Packet pacing (offload) for flow-aggregates and forwarding
 use-cases
From:   Yossi Kuperman <yossiku@mellanox.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     Rony Efraim <ronye@mellanox.com>
References: <d3d764d5-8eb6-59f9-cd3b-815de0258dbc@mellanox.com>
 <4d16c8e8-31d2-e3a4-2ff9-de0c9dc12d2e@gmail.com>
 <46bb3497-a3cf-84ce-d0b5-855ecedbac15@mellanox.com>
Message-ID: <a8510982-96a0-f8d5-b401-f4cce3d30c3c@mellanox.com>
Date:   Mon, 6 Apr 2020 23:26:03 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <46bb3497-a3cf-84ce-d0b5-855ecedbac15@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM3PR07CA0056.eurprd07.prod.outlook.com
 (2603:10a6:207:4::14) To DB6PR05MB4775.eurprd05.prod.outlook.com
 (2603:10a6:6:4c::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Yossis-MacBook-Pro.local (213.57.108.109) by AM3PR07CA0056.eurprd07.prod.outlook.com (2603:10a6:207:4::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.11 via Frontend Transport; Mon, 6 Apr 2020 20:26:09 +0000
X-Originating-IP: [213.57.108.109]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: df0974c8-a936-4973-32e7-08d7da68bf97
X-MS-TrafficTypeDiagnostic: DB6PR05MB3414:|DB6PR05MB3414:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR05MB34147B1ECE9282D443C6EBB9C4C20@DB6PR05MB3414.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0365C0E14B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR05MB4775.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(136003)(396003)(39860400002)(376002)(366004)(6666004)(26005)(2616005)(6486002)(186003)(16526019)(107886003)(956004)(31686004)(36756003)(6512007)(31696002)(52116002)(4326008)(478600001)(86362001)(8676002)(110136005)(66556008)(66476007)(53546011)(6636002)(316002)(66946007)(6506007)(5660300002)(2906002)(81156014)(8936002)(81166006);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4VCWCRKK3oPyuY+f07n3yl5gMM2YQqqTL5l51Oc2Ij7Z7DvrUHSqz4l1vqdUk4B8uNdfnlbq9elrLx5RBwW16S1IeaZO/0aQWKNMv15ruFf+Y8AbfarlGUp6e6OdF49MVETrPAP6/E0KiVGKnv0aMPcMzy0T/ThXb6Jt5lrmH+24ZMlHP0zig3OIzSJKBxj1DB9Iycaf40CQQb6k5k2TFP4MXpb0V66QPMYhH02H/Ga01fAEOupUBCpQrfeKUsODlnFKCQYXO2s03z9rTJhQxYqlp2tsX3kDW2673AVwKF5SV45VDPByq0yPWtWCNQUsxfLVpKMPycziY8MPLumLNu5s+eE5+R7mTLL7ndyYxjGDMOTaIluLLJrs0OdNLKkU112R7xkJRZb+sEX6qHvJBh1AYAVttFgeC3EB4PMvcSKiY+vE79ajgqzhcB/u+Ern
X-MS-Exchange-AntiSpam-MessageData: OAlyifW97JkbKmazHILxHKOurHppJRwEfcRtXh9a7rVRkPfwcHsmTOVoEqbUvW2iqf22cg09n+m/8peUPdrnfx5njaoYRyH5Ouo74EQG5gsZwhSCv2/8wwrBJIMpxDGTc1HUBI3QIBByiiypnDza/Q==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df0974c8-a936-4973-32e7-08d7da68bf97
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2020 20:26:12.3954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XOfXpq3kS41VC6fFAB1Pv0MUwjW5OJIw8qoiCJ/8VGzoCZBKXIxJnFRHSFVMoJeprWZi8MJjdp84Mnf4GczX8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR05MB3414
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 26/03/2020 16:42, Yossi Kuperman wrote:
> On 24/03/2020 21:26, Eric Dumazet wrote:
>> On 3/24/20 12:05 PM, Yossi Kuperman wrote:
>>> Hello,
>>>
>>>  
>>>
>>> We would like to support a forwarding use-case in which flows are classified and paced
>>>
>>> according to the selected class. For example, a packet arrives at the ingress hook of interface
>>>
>>> eth0,  performing a sequence of filters and being redirected to interface eth1. Pacing takes
>>>
>>> place at the egress qdisc of eth1.
>>>
>>>  
>>>
>>> FQ queuing discipline is classless and cannot provide such functionality. Each flow is
>>>
>>> paced independently, and different pacing is only configurable via a socket-option—less
>>>
>>> suitable for forwarding  use-case.
>>>
>>>  
>>>
>>> It is worth noting that although this functionality might be implemented by stacking multiple
>>>
>>> queuing disciplines, it will be very difficult to offload to hardware.
>>>
>>>  
>>>
>>> We propose introducing yet another classful qdisc, where the user can specify in advance the
>>>
>>> desired classes (i.e. pacing) and provide filters to classify flows accordingly. Similar to other
>>>
>>> qdiscs, if skb->priority is already set, we can skip the classification; useful for forwarding
>>>
>>> use-case, as the user can set the priority field in ingress. Works nicely with OVS/TC.
>>>
>>>  
>>>
>>> Any thoughts please?
>>>
>> Why not using HTB for this typical use case ?
>
> As far as I understand HTB is meant for rate-limiting, is the implementation fine-grained enough to support pacing
>
> as well?
>
Hi Eric, I'm not sure if HTB also performs pacing (similarly to FQ), can you please comment on that?

