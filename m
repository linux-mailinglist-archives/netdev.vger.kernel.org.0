Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7D4E16C08E
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 13:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729189AbgBYMQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 07:16:36 -0500
Received: from mail-eopbgr00047.outbound.protection.outlook.com ([40.107.0.47]:30937
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728965AbgBYMQg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 07:16:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZAknGprd6oNVEL0gH9CxLvdsXHxo2mtoQdZxTTain31MpH2bcx3L1hzpCRIIaUtrI/G6LrdDiICeTIOyVHJKsw5K4OcheHZMfdWG5j3nvqjf8QczqhAOdGbtPoHyW8ex+ntzbAXTUDgDYDHH+sQqXT4QSlpOmUraUiR1bEICfVK9HUVDZQQI1EjOBhUxP/CWVYjUMaLjUXK/584oPidL1LJ374Kye0xtw+k0yjpyLo97tVsXdvL62v5sk0KQydENI12PYlJM5zpHlObucqKgssTwOd4qHZDX7SwiHd9Ig9b5rC4toI3PpW4aE5dJDN+WhSpqlJ/61Pa65tVSw46Pjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BNJ8Ubbg+HwneBKvXjgk5j9zudIbZlgSnmkPwTlNdTI=;
 b=OTJu5JzpvCYgu8EWBTf+sgfjZoHcAR2AabxaZT56nTa3kPjnWUwrD6gNv186tPIz2WK50eyce8rxTRH8izkvReIjcS18hl+WtGAYnGnUaZrwcKhpjLlxFeGoAXIjr40MuqGE/Ka+6WqAOROVnJJPFDOZrxzV6y1Wl1Ajj1abEKsiMYapaG4x/yzmpgILnpcjbqh1KWUsHUkYVULKVsQ93TkxRIz2YuvBID+rloHr4wd6YIMv9JatOi4JjZGdQLbtNknAZdHNf2lSBuhzyfBvBHiKB1uleU1Z4VMegQOBimceLt5hDh8be2mXTPt5Zw2EII02UrFJUDTXQbFRC2N/Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BNJ8Ubbg+HwneBKvXjgk5j9zudIbZlgSnmkPwTlNdTI=;
 b=jNIzmk7fC4g/6UQcBdMcDzJdpYPfTm/q42aYKGQ83EoUooTAFKPQTeubk4LyF5tgs36++Drewucf2HreMcR/NJgOit/UdYmFzJNBqUN6sRjsldqRUh+v42NZ+ZjrjqbjUoLX/P+cTT4yRA29+eNP7OwYEBvJGoZRBP+RYFTrJbE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (20.177.36.78) by
 AM6PR05MB4966.eurprd05.prod.outlook.com (20.177.33.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.22; Tue, 25 Feb 2020 12:16:33 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4%7]) with mapi id 15.20.2750.021; Tue, 25 Feb 2020
 12:16:33 +0000
Subject: Re: [PATCH net-next 6/6] net/sched: act_ct: Software offload of
 established flows
To:     Edward Cree <ecree@solarflare.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1582458307-17067-1-git-send-email-paulb@mellanox.com>
 <1582458307-17067-7-git-send-email-paulb@mellanox.com>
 <00bede7c-1140-f2ec-05c5-f9db855ca90f@solarflare.com>
From:   Paul Blakey <paulb@mellanox.com>
Message-ID: <adabb21a-908a-c62d-6d72-ff97553a501d@mellanox.com>
Date:   Tue, 25 Feb 2020 14:16:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <00bede7c-1140-f2ec-05c5-f9db855ca90f@solarflare.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM3PR07CA0112.eurprd07.prod.outlook.com
 (2603:10a6:207:7::22) To AM6PR05MB5096.eurprd05.prod.outlook.com
 (2603:10a6:20b:11::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.223.6.3] (193.47.165.251) by AM3PR07CA0112.eurprd07.prod.outlook.com (2603:10a6:207:7::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.13 via Frontend Transport; Tue, 25 Feb 2020 12:16:31 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 990c60fd-08c5-44b4-6ed4-08d7b9ec8d2d
X-MS-TrafficTypeDiagnostic: AM6PR05MB4966:|AM6PR05MB4966:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB4966B2A77ED150CF6C6B17CECFED0@AM6PR05MB4966.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0324C2C0E2
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(199004)(189003)(5660300002)(16526019)(26005)(186003)(36756003)(6486002)(498600001)(66556008)(53546011)(66946007)(52116002)(66476007)(81166006)(110136005)(956004)(16576012)(2906002)(6666004)(31696002)(81156014)(2616005)(8676002)(6636002)(31686004)(8936002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4966;H:AM6PR05MB5096.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BeEx3U//AHl194LvR3zMV9zBNpH5w/oCsHPqPGJ1CVIaIZiCq570pzFFX43WWEVIHIWgqFELFWVts2LV7JVpY1nst0JDnEQ3ZXluSbEWizYfzIXQZJmO9m9/1iCEwhnLcIcWGJcMkUeICKKFaxqPXswf4doKa13fAg+bcsNNRduSqn5klQEx/Pi6ZUWgUoFnrfbXzF1EhiBxf+C/cY0nNpl7Mb+/lsT29vNOA6UOVQeRxK7suvqZiKoXkDxxSGRS6R1X+AFoAdG+gGXXKnMJMBu+WGf3TU2MuZmKDfTgSd61jDbtDOZZqbM79dM/AVCr85XEGENZuyZ/xcEI/o/16dFDZTfQHMuJVXFtCVHyNcYXygO3sVlMzdbID256V3KTJUgozmk+HxwlaBDtxCy7wfia7r5NkGbQfhDb9veNK42qzQbajP07TX9FZBc6oKMG
X-MS-Exchange-AntiSpam-MessageData: sim3LM8WGDp/qSBHy3JjvikVGPa5MxDQSRcul2Sa5WkvwGiI314ZdYs3UZAnK5aYIIvP8H+3WsjRnIXIE15TCYLoerSDQC96SQASv3Z6MJD5qdQBBUqYysMBAnLaXf+8/RIsDhiHZtSDqvPr/JZZag==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 990c60fd-08c5-44b4-6ed4-08d7b9ec8d2d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2020 12:16:32.9948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mVXrvVjQe1CUiF3r+iJDyk8ItiFPnv9we2fBVnCYSfRQFsEZxMSJOm7fvThof+hmx6SSoDnzBE3nuUEyUQlsGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4966
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/24/2020 6:04 PM, Edward Cree wrote:
> On 23/02/2020 11:45, Paul Blakey wrote:
>> Offload nf conntrack processing by looking up the 5-tuple in the
>> zone's flow table.
>>
>> The nf conntrack module will process the packets until a connection is
>> in established state. Once in established state, the ct state pointer
>> (nf_conn) will be restored on the skb from a successful ft lookup.
>>
>> Signed-off-by: Paul Blakey <paulb@mellanox.com>
>> Acked-by: Jiri Pirko <jiri@mellanox.com>
>> ---
>>  net/sched/act_ct.c | 163 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 160 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
>> index b2bc885..3592e24 100644
>> --- a/net/sched/act_ct.c
>> +++ b/net/sched/act_ct.c
> <snip>
>> @@ -645,6 +802,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>>  			goto out_push;
>>  	}
>>  
>> +do_nat:
>>  	ct = nf_ct_get(skb, &ctinfo);
>>  	if (!ct)
>>  		goto out_push;
>> @@ -662,9 +820,8 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>>  		 * even if the connection is already confirmed.
>>  		 */
>>  		nf_conntrack_confirm(skb);
>> -	}
>> -
>> -	tcf_ct_flow_table_process_conn(p->ct_ft, ct, ctinfo);
>> +	} else if (!skip_add)
>> +		tcf_ct_flow_table_process_conn(p->ct_ft, ct, ctinfo);
>>  
> Elseif body should be enclosed in braces, since if body was.
> -ed
thanks, will do
