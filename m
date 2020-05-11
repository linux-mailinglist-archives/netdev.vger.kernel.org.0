Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E174D1CDC49
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 15:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730281AbgEKN56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 09:57:58 -0400
Received: from mail-eopbgr130051.outbound.protection.outlook.com ([40.107.13.51]:56398
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730153AbgEKN55 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 09:57:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z9vyYvQE0Y1H+sODxGeXzkdkSIJEsdkfk05h+xKNNYjq5gAtpjOp1A5zkNe/emPl9vsV4JyeEcsE4rd/suuzQJgcGYGx0bINe6PKN+ePEKyQ09WHOJECljdMA+0e76JewRqOh2sW+j01Kf9xcIdizV6IXd9Ms17xHOFkVkWJJuRuG64XM4I7+JRShYVvaS1PDqk4q6LdRj4/V7zkz1/owy/ixp9XIR9RU0AG2V6fL7n7vZkgY22JiZVbgfAXMnGeSRN1KURLZd9C3ae5HvnV2EjeY2r0u05ES7CqbtZrX+7TBqwbyJHx073D5hNiO2z3j9wGuDlOPexWWOjV3focEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uVcuYLdJZr9S6GcEW5P+kCsikj+h0gCMfB1dH2Ul9OU=;
 b=VQZhaMjbepVUyUuSUnandEf83X/BPiUsZ3zMZGVKZFcGLG8CaBb08obUU+vdIcIMAQSmt9bRmTwYJqJ6SqbNH8b48Vog9XWdWgPgWtqMnoAZ5Xkqcf7gIQ2gNJ8mpyDQENUwdqqG/HrJZNfwRfIyEDDjCIWj/wzGrEEgb8StYbUa2EYi0VL//9wIBZtnpo4VdZB98ohQx+Vn9KVQZuirG0BHqjXoChtpILzGnwJChpxhxq6GUUaiE64L73DsC0icgyqjTokBn34GN6enJRU37cLvES2W2e0MW/0Dk0izY5n7UGsOD/YLL7myhHi/xqhVsrvcG/izV1PVtQtzct7rNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uVcuYLdJZr9S6GcEW5P+kCsikj+h0gCMfB1dH2Ul9OU=;
 b=daWz36oukSS2WVPTYaKp4O+Ib2EpfVyOY4gIZ50nkilhhVm9olJmVopTDrmespAuIfJz+FHrd0h0ErI4wHLhAzPLFO/QPRgPoEZl5eVw6a7HIRnfwa7c62AmVEBfGr4rmfl2BqIg4udmJRx/9HV6skTcFpYM9035Ex254EW1T1A=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from DB7PR05MB4156.eurprd05.prod.outlook.com (2603:10a6:5:18::21) by
 DB7PR05MB4873.eurprd05.prod.outlook.com (2603:10a6:10:1e::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2979.33; Mon, 11 May 2020 13:57:53 +0000
Received: from DB7PR05MB4156.eurprd05.prod.outlook.com
 ([fe80::39ab:622c:b05b:c86]) by DB7PR05MB4156.eurprd05.prod.outlook.com
 ([fe80::39ab:622c:b05b:c86%3]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 13:57:53 +0000
Subject: Re: [PATCH net] netfilter: flowtable: Add pending bit for offload
 work
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Paul Blakey <paulb@mellanox.com>
Cc:     Oz Shlomo <ozsh@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>,
        netfilter-devel@vger.kernel.org
References: <1588764279-12166-1-git-send-email-paulb@mellanox.com>
 <20200510221434.GA11226@salvia>
 <9dff92fe-15cd-348d-ff1c-7a102ea9263c@mellanox.com>
 <20200511115939.GA19979@salvia>
From:   Roi Dayan <roid@mellanox.com>
Message-ID: <28366c05-8293-6c9e-bfea-47f86bfc422e@mellanox.com>
Date:   Mon, 11 May 2020 16:57:50 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200511115939.GA19979@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR03CA0006.eurprd03.prod.outlook.com
 (2603:10a6:208:14::19) To DB7PR05MB4156.eurprd05.prod.outlook.com
 (2603:10a6:5:18::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.170] (176.231.113.172) by AM0PR03CA0006.eurprd03.prod.outlook.com (2603:10a6:208:14::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Mon, 11 May 2020 13:57:52 +0000
X-Originating-IP: [176.231.113.172]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2034b9c2-ce76-436e-4c47-08d7f5b34cf4
X-MS-TrafficTypeDiagnostic: DB7PR05MB4873:|DB7PR05MB4873:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR05MB487313A13839F8406266F1BDB5A10@DB7PR05MB4873.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nNJew+S4RmJDULGVjmnmbxHCXuEobFh6pyGWvlIuTiUl7bMM7AgD3MNhGYNBioi8tYBV8L7Aq+nQxFzmPXW/0i6outv52gIOZvsw+BVV0DDaqtpz/55qgC913frrYDw2V/rls0WXrN8lP4raIFbL/g+sV2bJfIhBPaGeWw1SKgko5Ckbi1LXXxEiBr+iCE6K0rA2+FUXxkpjNkm19mLsA51GbexHb6SKpFGrXb2FlI3M/QOJ8gepRw1pKxaL1MW9waUQlUqpi9QOxs3qKI60tcL81+eJ56JnshgGX21uh+uhmx5vY0ur5OHjkB/g1z+9C6PJHNO8G5gFGuyqigOq2Z4CKXPXzB/cyouejWjKrnHKraW83zVbRf8dlJC/RuvpS+LzY22W52dg+QvtIM2jpBZ2SsMeZIYFX5YfPbuSQOmBTpKzTVtDD8mNTOLqNQL2dYez/rlL1q3yiX2Fcdh4lBUQHT5LCCtIW0QD1VpD8hrVR5U9VXz5LUZQHP0lfpxE4L2mlV3+QA6gZ6a9JpseBUlVWe+LcjvwZziHXTccaOEINp9mqk8FIJEpWG9X3G3d
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR05MB4156.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(396003)(136003)(346002)(366004)(33430700001)(86362001)(478600001)(33440700001)(52116002)(6486002)(4326008)(5660300002)(31696002)(6636002)(31686004)(2616005)(8676002)(956004)(110136005)(2906002)(36756003)(16526019)(26005)(16576012)(66476007)(186003)(54906003)(66946007)(8936002)(316002)(53546011)(66556008)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: X6Rm+Vp+NokL4VSEP4pEPAJ6EqBmPcmKnZCApezaIm0Qs2ZCxucueAyUFWqmQskqUPeYcws6BYDL4MKv1gfr1gSvCerXdHhQMV5bVya/woPXHlnFj3oYMyKb8BGwKCjQXFeJUfi/uuLbyziUvZaspAluIMgLEEr+P/jt7pQc6agxAhCIYssfq3RBiyDd7pzkW9zsJAE5klKifBV6MtrmCrT8Mit9G9B1RANNAfIDb4y9CNulOHxyeWUMrPlM2lMbKl2m3fGFO9GHq3C6XX4vju4DKQltwANuUqMhavFU8XR3ejCHXWZHitBhbetB4Ge0KTZg6YX36XXwb+7dykXuHzpQFhqSdk582Szq5LLRlhMvAth416zwl29D7oR7HdFh6cYfNXa9f6Q9Ygh0labfbaaF/xI/2Z//WHdMn5rtm3Q9pJZ1rZLKq+x9pGO3k9VwD/kz4bw87pWzTQ7eeJE88rodAvSpuHvYpzbjvbe9rwAe69Y5Du7eHoPQ31+y8Pd/
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2034b9c2-ce76-436e-4c47-08d7f5b34cf4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 13:57:53.7493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nNUzRu0m9/TjrtbdoKiYaKmR3RLKO5csOHRc4iIxzenGIqzOR0D9jYKmZIPHpa50nR9WaCoGGyXwVLtXgr8aEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB4873
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020-05-11 2:59 PM, Pablo Neira Ayuso wrote:
> On Mon, May 11, 2020 at 11:32:36AM +0300, Paul Blakey wrote:
>> On 5/11/2020 1:14 AM, Pablo Neira Ayuso wrote:
> [...]
>>>> @@ -831,9 +832,14 @@ static void flow_offload_queue_work(struct flow_offload_work *offload)
>>>>  {
>>>>  	struct flow_offload_work *offload;
>>>>  
>>>> +	if (test_and_set_bit(NF_FLOW_HW_PENDING, &flow->flags))
>>>> +		return NULL;
>>> In case of stats, it's fine to lose work.
>>>
>>> But how does this work for the deletion case? Does this falls back to
>>> the timeout deletion?
>>
>> We get to nf_flow_table_offload_del (delete) in these cases:
>>
>>> -------if (nf_flow_has_expired(flow) || nf_ct_is_dying(flow->ct) ||
>>> -------    test_bit(NF_FLOW_TEARDOWN, &flow->flags) {
>>> ------->-------   ....
>>> ------->-------    nf_flow_offload_del(flow_table, flow);
>>
>> Which are all persistent once set but the nf_flow_has_expired(flow). So we will
>> try the delete
>> again and again till pending flag is unset or the flow is 'saved' by the already
>> queued stats updating the timeout.
>> A pending stats update can't save the flow once it's marked for teardown or
>> (flow->ct is dying), only delay it.
> 
> Thanks for explaining.
> 
>> We didn't mention flush, like in table free. I guess we need to flush the
>> hardware workqueue
>> of any pending stats work, then queue the deletion, and flush again:
>> Adding nf_flow_table_offload_flush(flow_table), after
>> cancel_delayed_work_sync(&flow_table->gc_work);
> 
> The "flush" makes sure that stats work runs before the deletion, to
> ensure no races happen for in-transit work objects, right?
> 
> We might use alloc_ordered_workqueue() and let the workqueue handle
> this problem?
> 

ordered workqueue executed one work at a time.
