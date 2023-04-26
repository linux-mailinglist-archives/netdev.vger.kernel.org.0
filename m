Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD82B6EF787
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 17:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241140AbjDZPIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 11:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241079AbjDZPIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 11:08:50 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04hn2225.outbound.protection.outlook.com [52.100.161.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E407744B5
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 08:08:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XBB4nE8LDHJ16AJYnGX45rGhm2LN5gKIEFlc5ZJGf8i9n0mz4Wy007buJaUyxDqqlEW6kAeIRI1SnwDwGeCB6j624QEKtoEw6GeGAi7gGKii84wXTFiXeXjxz/jm2DpfMTQnUYi+/uw7OY5EUipIW3xi8m1+QYvQKXP2tXDF8J/bOKb/3aOwEfaZqpXMsW3EmuDvZtEIYHrj27AX+n+Ge1JPXI+UPymakmhWLkaeZmsr/jyl2tENJFvbf0zqfR4pr1nm2JyENsrVqZBjraa0gmcDwEZ5gqUwD5gIOOOxbhCEwJt4dq9/k8Fkfx4DL0wVUI83zd24aWGBee9O8FYYng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fle0aPFYmrd18/pEG/QeZCi0xMf/R2XVeBqD3ypO2jc=;
 b=Or3DWgiCaCZmUde+/dYXmED3GTRBve/ceXEdXS4xIowkABrWbeD/XyCnmE8BLhKS/Fmods+AIG341Y/WIFRE37Ym+baaspvP22F54vLoThETNkby86ezJDJRshn0Vh0YCdgU+Cwp/gvD8AqjVQUJAq2cItGltL7rIuoUivU7Z2yN1QiCyfiNLznF9FLScnJCOpTlGZOQDOO7A+8tzImkjk+6mmW2PbcfpZdUFWv6O48t1TE7iZ9ri/aUVQ5bXLZoWOMFdnIUSlRITn1nlrHjy+TgZrut5JXJAgI+YOjimxxexG4qfqcBflg0Cg6Wa0pYrNj9di42DSkUAgIrCkqHIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fle0aPFYmrd18/pEG/QeZCi0xMf/R2XVeBqD3ypO2jc=;
 b=amnTiHxcTMYhO8RBZQNsM+ufOYTswe+EflD8xOtW5Zu0NNHEUnX/btmGbkZcZCUzyRU3GvgwVxIqsn5VeQkV602jTBlFDkl6+lF5TCH6/PuTo8p549O/FjwPJDPo+yEVlNUADEmttrKY9SbPPAWA5n8Odq3NW/iCNFRzgYlJW7tlrJfpafSExciRem0VkG+gM+ZPMgaDkqckKZWlmme51QZAcsE++r2Q8rRNoWO4vmLSQTpHpi78imYIMO+uwNI2qaLcup7ouuLtKygTPrZxC0cCkEOlhz8teaDbv4omaSZ32MuzpzMNUpiT4yEkqgp/WBH3SAlvaKM/rS2bidF1Rw==
Received: from DS7PR03CA0196.namprd03.prod.outlook.com (2603:10b6:5:3b6::21)
 by CH0PR12MB8552.namprd12.prod.outlook.com (2603:10b6:610:18e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.34; Wed, 26 Apr
 2023 15:08:46 +0000
Received: from DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b6:cafe::e6) by DS7PR03CA0196.outlook.office365.com
 (2603:10b6:5:3b6::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21 via Frontend
 Transport; Wed, 26 Apr 2023 15:08:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT016.mail.protection.outlook.com (10.13.173.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.21 via Frontend Transport; Wed, 26 Apr 2023 15:08:45 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 26 Apr 2023
 08:08:36 -0700
Received: from fedora.nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 26 Apr
 2023 08:08:32 -0700
References: <20230426121415.2149732-1-vladbu@nvidia.com>
 <20230426121415.2149732-3-vladbu@nvidia.com>
 <4a647080-cdf6-17e3-6e21-50250722e698@mojatatu.com>
User-agent: mu4e 1.8.11; emacs 28.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Pedro Tammela <pctammela@mojatatu.com>,
        Ivan Vecera <ivecera@redhat.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <marcelo.leitner@gmail.com>, <paulb@nvidia.com>,
        <simon.horman@corigine.com>
Subject: Re: [PATCH net 2/2] net/sched: flower: fix error handler on replace
Date:   Wed, 26 Apr 2023 17:46:38 +0300
In-Reply-To: <4a647080-cdf6-17e3-6e21-50250722e698@mojatatu.com>
Message-ID: <87bkjasmtw.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT016:EE_|CH0PR12MB8552:EE_
X-MS-Office365-Filtering-Correlation-Id: f8a63461-2bf0-4d1a-397a-08db4668219e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AR4BtjJQzJk9ncJyLh23i8+ux0sPH9tPeWJBEUM01iRnymTWpZQtDCKqHJ3JRR0P/2k4ZHvzz+Ov5FShOg2dkp5AWQ21oBTLzXDhEBGhx4ndMOxekCnyV7UPH1uLZw4R6IHpX7ZsrwhCasTMucssckRlo7mTuQBsLWIEj4LfxlN/JZRMqogzyuYDlxk2//wWlQYOq4iAEay4x/HLdyPq51++tNN+YX9omYx88BJ6MeCTnizO1eUzbc6ghE4x9Tlh/3CXCZNI/d/vtvMuJAVuiWkWRaUxrjicox3N+guPpwAkD7qkjv/+GBJ/39u24usLKRO/eRWdpQm+Gg3f0f8tOAZwst2IeESRAWIQbhAsCIMmKyCqFAnpNfr+1pw0UUsMlUYGBo8hUFU5cXIFYc9q9G3lgHtoR6hvfBew5xjK6kvhcFnaUV8J6b9srbtdNrujoWpAQozvTu95sdwmiH11o8srccM9DNTW8mauYExQIDCPAGpS8Y8h26XMY76v0EOXMf+6Jo1kaicPklNKne9BoOp9eDusdtAlWA2XhDChtYDyT2wW7OdZ1r2pkU3i50cpYrGlC2X1dRhUhkPgBtwmN4jvD/5/yZU6W9aXLAf5hNLBUJHWSgGvROY7Bzh4yc8VLOIRZnrrwGcriAJOQANXo75yol/H/ionSsNGh3uxd8iIogezgJQsB4+0vEizSy3YekKXW1BC56oIb6Y/PYT5uEuxEyxn7FbEn5bqgb226Fd4FrCuqG7G8Dem5RaVTITMQePDCvLeBoReNA/rtxPHRKtAgAakrnc8vQ7TfT2xq4MPIyd9LOPNt3ELh3Xb2X+Q
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(376002)(346002)(39860400002)(451199021)(5400799015)(36840700001)(46966006)(40470700004)(36756003)(70206006)(4326008)(54906003)(70586007)(316002)(110136005)(966005)(478600001)(82310400005)(8936002)(8676002)(7696005)(5660300002)(41300700001)(40480700001)(7416002)(2906002)(82740400003)(34020700004)(47076005)(336012)(7636003)(356005)(86362001)(2616005)(186003)(16526019)(53546011)(26005)(36860700001)(83380400001)(426003)(40460700003)(12100799030);DIR:OUT;SFP:1501;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 15:08:45.6055
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f8a63461-2bf0-4d1a-397a-08db4668219e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8552
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 26 Apr 2023 at 11:22, Pedro Tammela <pctammela@mojatatu.com> wrote:
> On 26/04/2023 09:14, Vlad Buslov wrote:
>> When replacing a filter (i.e. 'fold' pointer is not NULL) the insertion of
>> new filter to idr is postponed until later in code since handle is already
>> provided by the user. However, the error handling code in fl_change()
>> always assumes that the new filter had been inserted into idr. If error
>> handler is reached when replacing existing filter it may remove it from idr
>> therefore making it unreachable for delete or dump afterwards. Fix the
>> issue by verifying that 'fold' argument wasn't provided by caller before
>> calling idr_remove().
>> Fixes: 08a0063df3ae ("net/sched: flower: Move filter handle initialization
>> earlier")
>> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
>> ---
>>   net/sched/cls_flower.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
>> index 1844545bef37..a1c4ee2e0be2 100644
>> --- a/net/sched/cls_flower.c
>> +++ b/net/sched/cls_flower.c
>> @@ -2339,7 +2339,8 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
>>   errout_mask:
>>   	fl_mask_put(head, fnew->mask);
>>   errout_idr:
>> -	idr_remove(&head->handle_idr, fnew->handle);
>> +	if (!fold)
>> +		idr_remove(&head->handle_idr, fnew->handle);
>>   	__fl_put(fnew);
>>   errout_tb:
>>   	kfree(tb);
>
> Actually this seems to be fixing the same issue:
> https://lore.kernel.org/all/20230425140604.169881-1-ivecera@redhat.com/

Indeed it does, I've missed that patch. However, it seems there
is an issue with Ivan's approach. Consider what would happen when
fold!=NULL && in_ht==false and rhashtable_insert_fast() fails here:


        if (fold) {
                /* Fold filter was deleted concurrently. Retry lookup. */
                if (fold->deleted) {
                        err = -EAGAIN;
                        goto errout_hw;
                }

                fnew->handle = handle; // <-- fnew->handle is assigned

                if (!in_ht) {
                        struct rhashtable_params params =
                                fnew->mask->filter_ht_params;

                        err = rhashtable_insert_fast(&fnew->mask->ht,
                                                     &fnew->ht_node,
                                                     params);
                        if (err)
                                goto errout_hw; /* <-- err is set, go to
                                                     error handler here */
                        in_ht = true;
                }

                refcount_inc(&fnew->refcnt);
                rhashtable_remove_fast(&fold->mask->ht,
                                       &fold->ht_node,
                                       fold->mask->filter_ht_params);
                /* !!! we never get to insert fnew into idr here, if ht insertion fails */
                idr_replace(&head->handle_idr, fnew, fnew->handle);
                list_replace_rcu(&fold->list, &fnew->list);
                fold->deleted = true;

                spin_unlock(&tp->lock);

                fl_mask_put(head, fold->mask);
                if (!tc_skip_hw(fold->flags))
                        fl_hw_destroy_filter(tp, fold, rtnl_held, NULL);
                tcf_unbind_filter(tp, &fold->res);
                /* Caller holds reference to fold, so refcnt is always > 0
                 * after this.
                 */
                refcount_dec(&fold->refcnt);
                __fl_put(fold);
        }

...

 errout_ht:
         spin_lock(&tp->lock);
 errout_hw:
         fnew->deleted = true;
         spin_unlock(&tp->lock);
         if (!tc_skip_hw(fnew->flags))
                 fl_hw_destroy_filter(tp, fnew, rtnl_held, NULL);
         if (in_ht)
                 rhashtable_remove_fast(&fnew->mask->ht, &fnew->ht_node,
                                        fnew->mask->filter_ht_params);
 errout_mask:
         fl_mask_put(head, fnew->mask);
 errout_idr:
         /* !!! On next line we remove handle that we don't actually own */
         idr_remove(&head->handle_idr, fnew->handle);
         __fl_put(fnew);
 errout_tb:
         kfree(tb);
 errout_mask_alloc:
         tcf_queue_work(&mask->rwork, fl_uninit_mask_free_work);
 errout_fold:
         if (fold)
                 __fl_put(fold);
         return err;


Also, if I understood the idea behind Ivan's fix correctly, it relies on
the fact that calling idr_remove() with handle==0 is a noop. I prefer my
approach slightly better as it is more explicit IMO.

Thoughts?
