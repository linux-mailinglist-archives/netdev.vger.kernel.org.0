Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D454B17DA26
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 09:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbgCIICQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 04:02:16 -0400
Received: from mail-eopbgr40083.outbound.protection.outlook.com ([40.107.4.83]:23207
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725796AbgCIICP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 04:02:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dXc1W1n3Wb9LPxDrg2liup0kzZuHtfUEkevrDU1MtbeGkHsW6kUIWAHnzWhDB+UNXOD96QE+13mSo5zi+oXNl75xHmSxAfpK/y6udD06Np7hEUbR0sklDMLY9BEH+I7M7i5xuGg6QelhPkwjNjCE2ZkB30aIf+ZAdyGo+FBLSY0pof9lEyumvpCrbJhRP+rlItHt4c5KZubz+tWN3oX68bICaSjMjCqdjrmK0FPYuAZJxk3d0n3oaNHbsFnxKuwYUGnCrtS65qeeYv363vgOU23EbvPizGGBkWoG4L7dal9bLwDbXUKt9kz6t76WSU9CVCUim99xgEgww6Vyk/El9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fGpiF0mtWjXvdw5WKId5/1POmpetejuLGrbwJmDFHCg=;
 b=TkSk21U+qMQjtJlXTLDnkgYs2baMXgeMNVOwL06qoJu6EX4xIkYxj+xsMQbiz7TQEsxpBtAx7B2YcHXJBDzTVQ4uG908S84H45gST+/hb3MvFbabupaotKZKOGLRzCBEG5gjmWVp7pVF9+UMBQLQqzqAyUkosI9YxCIC5Ljx4EYwPwSjfiRQCDeSmiJYqtGyELhKKCuJl99puC1G0eqBLufS3+ECt1aPHzf0ssOH5sj6IY/XuN+bnwnOtURH40ykWZkC2EySxbP/nMADCXOaUYxt663jTSna8TG13TKa8eTcJTEU8QHoF77L1E8etOc1/tJp4vwdi5DLGHi0uTU53Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fGpiF0mtWjXvdw5WKId5/1POmpetejuLGrbwJmDFHCg=;
 b=dXkWEihcP2DA2jO9Qjm0G1QRCSbrXCjUhwA54b8mZGd8Uw8fhdktpKFtzzQFlXBSAbGYO2r4SdiEQeKbgGdLbqimf5GxPWgMwFun2tdHsQTdjV+GdgzWSGiBk8YjKN593HyMJu87DdG9SVE/Rw9C/cXGje3xNrb3dfu2yPJoO4A=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (20.177.36.78) by
 AM6PR05MB5878.eurprd05.prod.outlook.com (20.179.1.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Mon, 9 Mar 2020 08:02:11 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4%7]) with mapi id 15.20.2772.019; Mon, 9 Mar 2020
 08:02:11 +0000
Subject: Re: [PATCH net-next v6 1/3] net/sched: act_ct: Create nf flow table
 per zone
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1583251072-10396-1-git-send-email-paulb@mellanox.com>
 <1583251072-10396-2-git-send-email-paulb@mellanox.com>
 <c0c033e8-63ed-a33c-2e1b-afbedcb476ea@gmail.com>
 <57a22ef3-63de-2b51-61cb-5ff00d2a5b81@gmail.com>
 <334b4af2-1ac0-d28b-f1a5-b9b604a9ba80@mellanox.com>
 <69fa856f-4aaf-4f54-7324-009cdbf26e38@mellanox.com>
 <5ab39d86-7ed3-b9b8-e6c2-2d96a3bd1f83@gmail.com>
From:   Paul Blakey <paulb@mellanox.com>
Message-ID: <6a6f8bb5-c896-767d-2c7b-84aca380aa35@mellanox.com>
Date:   Mon, 9 Mar 2020 10:02:07 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
In-Reply-To: <5ab39d86-7ed3-b9b8-e6c2-2d96a3bd1f83@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR0102CA0024.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:14::37) To AM6PR05MB5096.eurprd05.prod.outlook.com
 (2603:10a6:20b:11::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.223.6.3] (193.47.165.251) by AM0PR0102CA0024.eurprd01.prod.exchangelabs.com (2603:10a6:208:14::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17 via Frontend Transport; Mon, 9 Mar 2020 08:02:10 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 688eaf74-cee1-467f-be39-08d7c4002bd1
X-MS-TrafficTypeDiagnostic: AM6PR05MB5878:|AM6PR05MB5878:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB58787FC450D312CB74F96382CFFE0@AM6PR05MB5878.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0337AFFE9A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(136003)(366004)(376002)(396003)(189003)(199004)(52116002)(86362001)(478600001)(31696002)(5660300002)(316002)(16576012)(110136005)(6636002)(2906002)(53546011)(66556008)(6486002)(8676002)(26005)(186003)(8936002)(66476007)(36756003)(6666004)(66946007)(956004)(81156014)(16526019)(81166006)(31686004)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5878;H:AM6PR05MB5096.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B8E88b1iJ6MKo3dnaP69Ba+WXR/kYAlowSg8WG/nVLXu/0/n9Yod5VxLh8CFsNUizZgfTamqiLH2aas0/nASbpS37023qpuM9kxZc6sXrNkea6EbfBO1FPKRHY7tIRmQooeuX5oRw/h+pwOloQZYes+wCcPmmYW4pnu+0dZB9mYSjQ43hWwogrJJ53+2gI0CzV2KWPVxhQ9cN6kR6uAaZEn7yifOOaSq5sp3bjzQuHLLXUlcH+C6fJgjfnMlxxEvwpJLeahGRj+o0da/zm/OQPdYCjj4gx44ucm/VtMh1EVIjnYmXeFlQwBLvZSnSwiOpFQ4q2NGJxuWu4iBTNdHBi4jCgdKGvliYZd4IJX9yeWQkNQtfvKDczl1kcjDn2WituoIUVjNdX7HbeIBBhc67LV7sOG0s4KVBDpxt4pl3gJzHOu66dbyIy8V7fAqjlkE
X-MS-Exchange-AntiSpam-MessageData: 3z4c4ym266ZJRJ/zEgjl+009lfnAQtcxeWVVRVANrNXwkZLHFnuF7kj0ghqAOK5HYRrDdpwh+M9kMAb0y+unDkatR8KcEyqTez36WtVpjmPw1Ufu8fdfG3KEW6fP9dzDgK4WFInkNex/0fDMvF8xcQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 688eaf74-cee1-467f-be39-08d7c4002bd1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2020 08:02:11.4202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oZn5e5m3mXX45cC1xtOg3KmnzfG/bk3CoAcHlvi9kzDn9v5Hhj/mzB0QQRbjeFVDnQnnHCgBVg3h1bCZsKWuBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5878
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/8/2020 10:42 PM, Eric Dumazet wrote:
>
> On 3/8/20 12:15 AM, Paul Blakey wrote:
>> On 3/8/2020 10:11 AM, Paul Blakey wrote:
>>
>>> iirc I did the spin lock bh because we can be called from queue work rcu handler , so I wanted to disable soft irq.
>>>
>>> I got a possible deadlock splat for that.
>> Here I meant this call rcu:
>>
>> static void tcf_ct_cleanup(struct tc_action *a)
>> {
>>> -------struct tcf_ct_params *params;
>>> -------struct tcf_ct *c = to_ct(a);
>>> -------params = rcu_dereference_protected(c->params, 1);
>>> -------if (params)
>>> ------->-------call_rcu(&params->rcu, tcf_ct_params_free);
>> }
>>
> Yes, understood, but to solve this problem we had many other choices,
> and still keeping GFP_KERNEL allocations and a mutex for control path.
>
> Have you read my patch ?
>
> By not even trying to get a spinlock in tcf_ct_flow_table_put(),
> and instead use a refcount for ->ref, we avoid having this issue in the first place.
>
> static void tcf_ct_flow_table_put(struct tcf_ct_params *params)
> {
>         struct tcf_ct_flow_table *ct_ft = params->ct_ft;
>
>         if (refcount_dec_and_test(&params->ct_ft->ref)) {
>                 rhashtable_remove_fast(&zones_ht, &ct_ft->node, zones_params);
>                 INIT_RCU_WORK(&ct_ft->rwork, tcf_ct_flow_table_cleanup_work);
>                 queue_rcu_work(act_ct_wq, &ct_ft->rwork);
>         }
> }
Sorry missed that, thanks for the fix.
>> static void tcf_ct_params_free(struct rcu_head *head)
>> {
>>> -------struct tcf_ct_params *params = container_of(head,
>>> ------->------->------->------->------->-------    struct tcf_ct_params, rcu);
>>> -------tcf_ct_flow_table_put(params);
>> ...
>>
>>
>>>
>>> On 3/7/2020 10:53 PM, Eric Dumazet wrote:
>>>
>>>> On 3/7/20 12:12 PM, Eric Dumazet wrote:
>>>>> On 3/3/20 7:57 AM, Paul Blakey wrote:
>>>>>> Use the NF flow tables infrastructure for CT offload.
>>>>>>
>>>>>> Create a nf flow table per zone.
>>>>>>
>>>>>> Next patches will add FT entries to this table, and do
>>>>>> the software offload.
>>>>>>
>>>>>> Signed-off-by: Paul Blakey <paulb@mellanox.com>
>>>>>> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
>>>>>> ---
>>>>>>   v4->v5:
>>>>>>     Added reviewed by Jiri, thanks!
>>>>>>   v3->v4:
>>>>>>     Alloc GFP_ATOMIC
>>>>>>   v2->v3:
>>>>>>     Ditch re-locking to alloc, and use atomic allocation
>>>>>>   v1->v2:
>>>>>>     Use spin_lock_bh instead of spin_lock, and unlock for alloc (as it can sleep)
>>>>>>     Free ft on last tc act instance instead of last instance + last offloaded tuple,
>>>>>>     this removes cleanup cb and netfilter patches, and is simpler
>>>>>>     Removed accidental mlx5/core/en_tc.c change
>>>>>>     Removed reviewed by Jiri - patch changed
>>>>>>
>>>>>> +	err = nf_flow_table_init(&ct_ft->nf_ft);
>>>>> This call is going to allocate a rhashtable (GFP_KERNEL allocations that might sleep)
>>>>>
>>>>> Since you still hold zones_lock spinlock, a splat should occur.
>>>>>
>>>>> "BUG: sleeping function called from invalid context in  ..."
>>>>>
>>>>> DEBUG_ATOMIC_SLEEP=y is your friend.
>>>>>
>>>>> And it is always a good thing to make sure a patch does not trigger a lockdep splat
>>>>>
>>>>> CONFIG_PROVE_LOCKING=y
>>>> Also abusing a spinlock and GFP_ATOMIC allocations in control path is highly discouraged.
>>>>
>>>> I can not test the following fix, any objections before I submit this officially ?
>>>>
>>>> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
>>>> index 23eba61f0f819212a3522c3c63b938d0b8d997e2..3d9e678d7d5336f1746035745b091bea0dcb5fdd 100644
>>>> --- a/net/sched/act_ct.c
>>>> +++ b/net/sched/act_ct.c
>>>> @@ -35,15 +35,15 @@
>>>>  
>>>>  static struct workqueue_struct *act_ct_wq;
>>>>  static struct rhashtable zones_ht;
>>>> -static DEFINE_SPINLOCK(zones_lock);
>>>> +static DEFINE_MUTEX(zones_mutex);
>>>>  
>>>>  struct tcf_ct_flow_table {
>>>>         struct rhash_head node; /* In zones tables */
>>>>  
>>>>         struct rcu_work rwork;
>>>>         struct nf_flowtable nf_ft;
>>>> +       refcount_t ref;
>>>>         u16 zone;
>>>> -       u32 ref;
>>>>  
>>>>         bool dying;
>>>>  };
>>>> @@ -64,14 +64,15 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
>>>>         struct tcf_ct_flow_table *ct_ft;
>>>>         int err = -ENOMEM;
>>>>  
>>>> -       spin_lock_bh(&zones_lock);
>>>> +       mutex_lock(&zones_mutex);
>>>>         ct_ft = rhashtable_lookup_fast(&zones_ht, &params->zone, zones_params);
>>>> -       if (ct_ft)
>>>> -               goto take_ref;
>>>> +       if (ct_ft && refcount_inc_not_zero(&ct_ft->ref))
>>>> +               goto out_unlock;
>>>>  
>>>> -       ct_ft = kzalloc(sizeof(*ct_ft), GFP_ATOMIC);
>>>> +       ct_ft = kzalloc(sizeof(*ct_ft), GFP_KERNEL);
>>>>         if (!ct_ft)
>>>>                 goto err_alloc;
>>>> +       refcount_set(&ct_ft->ref, 1);
>>>>  
>>>>         ct_ft->zone = params->zone;
>>>>         err = rhashtable_insert_fast(&zones_ht, &ct_ft->node, zones_params);
>>>> @@ -84,10 +85,9 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
>>>>                 goto err_init;
>>>>  
>>>>         __module_get(THIS_MODULE);
>>>> -take_ref:
>>>> +out_unlock:
>>>>         params->ct_ft = ct_ft;
>>>> -       ct_ft->ref++;
>>>> -       spin_unlock_bh(&zones_lock);
>>>> +       mutex_unlock(&zones_mutex);
>>>>  
>>>>         return 0;
>>>>  
>>>> @@ -96,7 +96,7 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
>>>>  err_insert:
>>>>         kfree(ct_ft);
>>>>  err_alloc:
>>>> -       spin_unlock_bh(&zones_lock);
>>>> +       mutex_unlock(&zones_mutex);
>>>>         return err;
>>>>  }
>>>>  
>>>> @@ -116,13 +116,11 @@ static void tcf_ct_flow_table_put(struct tcf_ct_params *params)
>>>>  {
>>>>         struct tcf_ct_flow_table *ct_ft = params->ct_ft;
>>>>  
>>>> -       spin_lock_bh(&zones_lock);
>>>> -       if (--params->ct_ft->ref == 0) {
>>>> +       if (refcount_dec_and_test(&params->ct_ft->ref)) {
>>>>                 rhashtable_remove_fast(&zones_ht, &ct_ft->node, zones_params);
>>>>                 INIT_RCU_WORK(&ct_ft->rwork, tcf_ct_flow_table_cleanup_work);
>>>>                 queue_rcu_work(act_ct_wq, &ct_ft->rwork);
>>>>         }
>>>> -       spin_unlock_bh(&zones_lock);
>>>>  }
>>>>  
>>>>  static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
>>>>
