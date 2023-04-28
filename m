Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D81A16F1223
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 09:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345415AbjD1HML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 03:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjD1HMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 03:12:09 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2120.outbound.protection.outlook.com [40.107.223.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F9031FC6
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 00:12:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=luirubr0p3TUDecJr7OyRtHklO/k+oFByxEahxA+191ZWTVDc/6kjHKtDNOF0Y0Hb+W6k38l22g9+bq0EyyKihl9mnQ/GmGpxZGXVmb4vN4RF9uvUMTnSske1AR6682j/InIjMXlF5wNvWGwmbsIdQULZ8tRdkqDonsHzVm8AkNU+upTgkthBOZhXK1tgfaQD4N1EyaEHXmMi+dycBbUW3rqhjGX1XAeuaRTjKeaMQcsOZJ2aYKv8+4TdvbKPsmxePFRSzpcLOCbptIaUfL2uN8wRkEWwJtfnpYgPOeQMoOKuYtJ7FEoZVz8nY7YTz5VX6DBBDYeGaFXY4xXKLnPxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CnyJoPEuHOJVURkc6yFoSijUl7mptir1GbeuU3JZAsU=;
 b=A+EFlCaeXnbWTTgG9Mz/XKSXOof0CQruRp6HT6yBIDAG8o4YHw0vSRn+konc78F482dDrQ91d6vow2cY7V58hAKah8icTjBdNiHKeI4h12p9ZdCHwudQxLAA3um90aaQTgp9Ie9KsUiUFCgRXMb9BQ0C88gIzLnZ7Gl4i6xcilVIpvCILzavaKiWfh8DQSNMDMZpoYAEL9CE5XgIJR+gsJkG2Q4PpW3B2+mJEnajdtuAymzCEU0Y+zJsGeJ+cUm14jRutcCfk8KAuTgp5Zrz697sTY9Uz/hRKVXbV4CMkRCnAp6W1NIUsUr6X0LMedL8cdlgp+8aIbM3NhH9UtY+9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CnyJoPEuHOJVURkc6yFoSijUl7mptir1GbeuU3JZAsU=;
 b=AV/UdY+VDHBJ44+aX1azoslD4Ox2xXYiVXY4d50eRlG3g6V6dTazcti4o/9undRM2sHn3QStyQYTuQrX9ITWHXUFSZj3vqCwaaC6EtLbjTbbI1yCCrt339uUIq803miq9OvsMMDh7fE27ZwbZg5irMr8+azq9yg5nhXZOk9G/5s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5484.namprd13.prod.outlook.com (2603:10b6:303:183::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Fri, 28 Apr
 2023 07:12:04 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.022; Fri, 28 Apr 2023
 07:12:04 +0000
Date:   Fri, 28 Apr 2023 09:11:56 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     Vlad Buslov <vladbu@nvidia.com>,
        Pedro Tammela <pctammela@mojatatu.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        marcelo.leitner@gmail.com, paulb@nvidia.com
Subject: Re: [PATCH net 2/2] net/sched: flower: fix error handler on replace
Message-ID: <ZEtxvPaa/L3jHa2d@corigine.com>
References: <20230426121415.2149732-1-vladbu@nvidia.com>
 <20230426121415.2149732-3-vladbu@nvidia.com>
 <4a647080-cdf6-17e3-6e21-50250722e698@mojatatu.com>
 <87bkjasmtw.fsf@nvidia.com>
 <1bf81145-0996-e473-4053-09f410195984@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bf81145-0996-e473-4053-09f410195984@redhat.com>
X-ClientProxiedBy: AM3PR05CA0100.eurprd05.prod.outlook.com
 (2603:10a6:207:1::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW4PR13MB5484:EE_
X-MS-Office365-Filtering-Correlation-Id: 835832d4-dcae-4d3e-471b-08db47b7de3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9+iDTiHuGvw6QauwskhLCdIqLvD7a4g+C/NGXw6U9EYzuCNUgIbblbATap4hAzMCU0a2S6nj6Rq9M7sNlg3v1vvKKjZ4tt1IabfRAPyHEe197ZoqLAykQkiaxjVWUO2xsEvVkGnqT4fhW55EIJjd7eP4yzbu5Ol8tMl3gp0nscTc1bMw94XdU+Kgswdt9878Td6+CnX2QcY7oXeeBGr1sRoH7NnIs/rpyJE2aTSkfZtVyZad+4Ra1nY16dfyVF9pehMzu0LWR9dedjdUCg1ofTf60GF8jO2lQDk0gEg+Ay0QCFLZlTghcZqGO3rPzLkxrnval/V6CNrPfB2zJBo7IoOBvJtqai3Q9P3Qvz5mtiqsF472wMUNXF3fLKonY/AL+2tVsUUQjJ2X+CN0n3v90eZVE2XPJ4C60ajMW9xBvPP8IIj1r4KgsAXnqTfSPoqrks+Px9Ms+hWSS69vIYkuIRk7xs2iiTZPAFtOThNCA6LxlPuYCKmbGixKmEVIhF3/qzR/rYpJ3mcvyl6gTbcXVVLmIil8p92c0OUSu08qfeo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(136003)(366004)(376002)(39840400004)(451199021)(2616005)(83380400001)(186003)(6512007)(6506007)(5660300002)(53546011)(6916009)(86362001)(316002)(66946007)(44832011)(66556008)(4326008)(38100700002)(41300700001)(66476007)(2906002)(478600001)(54906003)(6666004)(8676002)(36756003)(8936002)(7416002)(6486002)(966005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/q0ANQgZPqG7+2XzHf+L8jyGe1J+gEQvej4NMf3giitgeypHFmrT+UVaaV0q?=
 =?us-ascii?Q?Mts0QyU0mvHM8Et8Opu41JAivwwqepabtVVkeUTTdxQqCenmaUarIoE9olwE?=
 =?us-ascii?Q?mOm78uEbTSp3GUKEYbYyJTJl9i6viaza9Um308HAseYlkgXklPKsr39LBrGC?=
 =?us-ascii?Q?M9xWxeYIstN3T6zrKwP7w6Xg9IXYlPczF/inSqXyTOL2Df8urmN2kPNRiepq?=
 =?us-ascii?Q?DAyAxXbl84myyog1Ltm3iMcUSaRap76LwCRwGErIe6CN1xqG8lqM7/uNqUCg?=
 =?us-ascii?Q?AdteEKQbApD150Y7YB85fhXpR8t9IyZiehk/3+q7V00nk8PLkGUPy0h9XDpm?=
 =?us-ascii?Q?lCXCUHkxJ7Fdx7EminwArorYtQK1SYT26Phct7SdShkJXO6IWOlG6AViB1/J?=
 =?us-ascii?Q?ORd9embt3Q4pgoCBV+MtMAgbvkdqw68Jt6YMpqunMKxnYaVW+saTjOXSwa61?=
 =?us-ascii?Q?0MhNsPCmro4b2So+hSKMaez6klZ3hqmTcKbTW1Ecu1ReVdof9Lh/2cvXUsmr?=
 =?us-ascii?Q?1E6kJMBnx5xfXSr+twAgGip163UosY9EygcdIfN/JM8364BnfmZnjxAwDIHG?=
 =?us-ascii?Q?1hbjpK9g4QrI0ANA1wRfY7ECIjWKMEiAXOQfFOtf846/tAdKjNM/E21BBnXl?=
 =?us-ascii?Q?F25t6Aq/teaT4v2yrEfzy8rhKZPbQxgPQAbbk90/n5wIbgP3jq3dsC03FXP3?=
 =?us-ascii?Q?Xqa+RqBglAXZV3/Q6CKGFRmMTWjtaBAYcBT/ywZgXAN/lFisFI7cGcU1xSEP?=
 =?us-ascii?Q?ZW2Us/aMaL0Bqp4rxD2DxBhRqU898QNUeqONE17qxLi5GzPBkrBYyACp2spe?=
 =?us-ascii?Q?Ih59IqJcrQZH7vKbqbhxm/42a/5E6Rmf3UB1FZkUfSIf5VO28ql52nBFYh+c?=
 =?us-ascii?Q?N1NA6CwB5nhr/Zbl0XDgwAFXWAsBhidtQXtxKnt6pUquY2PCfPjzbajpATjP?=
 =?us-ascii?Q?Z5onr655XDVZL6UYsYSH6ggBNEsO3YGa0vlVE0sraR79Oj1C/ytF8kqyaVfJ?=
 =?us-ascii?Q?LMw9RtKQSntx9XNxhlBU2pkCeXutyTh3Eh4D59Oxn60NuaNXaaj5BJKTXwBZ?=
 =?us-ascii?Q?/XEpcImVTIsH66IWsVoyXBX6MM74XTHSZVrsBQzApW9a04JlDLW9wAz1Cpoy?=
 =?us-ascii?Q?RIdM0qtHdaG6qphnHTTY08od0qar6Nh9azsxOF1AdQZ8XfD4//nmuvqAbOrt?=
 =?us-ascii?Q?mX8PSZYlszdSIp7dV+Ox0+TryKWLGLkLsBMy6WV88hZ0RuVHTs2TuJBAV7mz?=
 =?us-ascii?Q?a4r7DwtoPT8uT4iInhRHt4Q0KdSWxb/w1nVhjvuQebaC6G7bqchhd5epzRF3?=
 =?us-ascii?Q?gEyRjTL36kIln09ZcgZLadq+ufHH7hkgI7dQkUx+z20Mj5JYpCjDTw3eWwoY?=
 =?us-ascii?Q?8VDGMjWzp0GBIRBr7YId5r1a9LUt1JbGRW5AneFSk0L8PYyEbW5CuZV8H6s2?=
 =?us-ascii?Q?X0F0ChYcRLtxfpU+p3dZNZZivaV+b/sFOKbNyH7ifNqHQRJWGtR5bRvLu9QK?=
 =?us-ascii?Q?x5SDHdJl5QJIXIS2OEWCtHQjKaXVduEpO4HbNvipELEvgljDJGnIyOgVxJzL?=
 =?us-ascii?Q?BXwrpquWbkZ7yNPqi7Bzfl4ZncEG4vdjaXcusnMtd09VYFh2rVP2P/X2ezXw?=
 =?us-ascii?Q?HQ7G8Te3Pw3Qpd48AzcwrQ1tu74hkJFeU5e9hvjRZO79iVLrM2jvZUZze7zy?=
 =?us-ascii?Q?pu2f5A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 835832d4-dcae-4d3e-471b-08db47b7de3f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 07:12:03.9867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4LE7nxL4os7GCtvHR+uPgTKHUhVPlWLk5DRbGRYlu5X/ov1xg13cWeHStygXtCz3S3XyP16oEDn7HkpGSF2oHoTT58nAYgv+TSCPyUgKFJ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5484
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 05:39:09PM +0200, Ivan Vecera wrote:
> 
> 
> On 26. 04. 23 16:46, Vlad Buslov wrote:
> > On Wed 26 Apr 2023 at 11:22, Pedro Tammela <pctammela@mojatatu.com> wrote:
> > > On 26/04/2023 09:14, Vlad Buslov wrote:
> > > > When replacing a filter (i.e. 'fold' pointer is not NULL) the insertion of
> > > > new filter to idr is postponed until later in code since handle is already
> > > > provided by the user. However, the error handling code in fl_change()
> > > > always assumes that the new filter had been inserted into idr. If error
> > > > handler is reached when replacing existing filter it may remove it from idr
> > > > therefore making it unreachable for delete or dump afterwards. Fix the
> > > > issue by verifying that 'fold' argument wasn't provided by caller before
> > > > calling idr_remove().
> > > > Fixes: 08a0063df3ae ("net/sched: flower: Move filter handle initialization
> > > > earlier")
> > > > Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
> > > > ---
> > > >    net/sched/cls_flower.c | 3 ++-
> > > >    1 file changed, 2 insertions(+), 1 deletion(-)
> > > > diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> > > > index 1844545bef37..a1c4ee2e0be2 100644
> > > > --- a/net/sched/cls_flower.c
> > > > +++ b/net/sched/cls_flower.c
> > > > @@ -2339,7 +2339,8 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
> > > >    errout_mask:
> > > >    	fl_mask_put(head, fnew->mask);
> > > >    errout_idr:
> > > > -	idr_remove(&head->handle_idr, fnew->handle);
> > > > +	if (!fold)
> > > > +		idr_remove(&head->handle_idr, fnew->handle);
> > > >    	__fl_put(fnew);
> > > >    errout_tb:
> > > >    	kfree(tb);
> > > 
> > > Actually this seems to be fixing the same issue:
> > > https://lore.kernel.org/all/20230425140604.169881-1-ivecera@redhat.com/
> > 
> > Indeed it does, I've missed that patch. However, it seems there
> > is an issue with Ivan's approach. Consider what would happen when
> > fold!=NULL && in_ht==false and rhashtable_insert_fast() fails here:
> > 
> > 
> >          if (fold) {
> >                  /* Fold filter was deleted concurrently. Retry lookup. */
> >                  if (fold->deleted) {
> >                          err = -EAGAIN;
> >                          goto errout_hw;
> >                  }
> > 
> >                  fnew->handle = handle; // <-- fnew->handle is assigned
> > 
> >                  if (!in_ht) {
> >                          struct rhashtable_params params =
> >                                  fnew->mask->filter_ht_params;
> > 
> >                          err = rhashtable_insert_fast(&fnew->mask->ht,
> >                                                       &fnew->ht_node,
> >                                                       params);
> >                          if (err)
> >                                  goto errout_hw; /* <-- err is set, go to
> >                                                       error handler here */
> >                          in_ht = true;
> >                  }
> > 
> >                  refcount_inc(&fnew->refcnt);
> >                  rhashtable_remove_fast(&fold->mask->ht,
> >                                         &fold->ht_node,
> >                                         fold->mask->filter_ht_params);
> >                  /* !!! we never get to insert fnew into idr here, if ht insertion fails */
> >                  idr_replace(&head->handle_idr, fnew, fnew->handle);
> >                  list_replace_rcu(&fold->list, &fnew->list);
> >                  fold->deleted = true;
> > 
> >                  spin_unlock(&tp->lock);
> > 
> >                  fl_mask_put(head, fold->mask);
> >                  if (!tc_skip_hw(fold->flags))
> >                          fl_hw_destroy_filter(tp, fold, rtnl_held, NULL);
> >                  tcf_unbind_filter(tp, &fold->res);
> >                  /* Caller holds reference to fold, so refcnt is always > 0
> >                   * after this.
> >                   */
> >                  refcount_dec(&fold->refcnt);
> >                  __fl_put(fold);
> >          }
> > 
> > ...
> > 
> >   errout_ht:
> >           spin_lock(&tp->lock);
> >   errout_hw:
> >           fnew->deleted = true;
> >           spin_unlock(&tp->lock);
> >           if (!tc_skip_hw(fnew->flags))
> >                   fl_hw_destroy_filter(tp, fnew, rtnl_held, NULL);
> >           if (in_ht)
> >                   rhashtable_remove_fast(&fnew->mask->ht, &fnew->ht_node,
> >                                          fnew->mask->filter_ht_params);
> >   errout_mask:
> >           fl_mask_put(head, fnew->mask);
> >   errout_idr:
> >           /* !!! On next line we remove handle that we don't actually own */
> >           idr_remove(&head->handle_idr, fnew->handle);
> >           __fl_put(fnew);
> >   errout_tb:
> >           kfree(tb);
> >   errout_mask_alloc:
> >           tcf_queue_work(&mask->rwork, fl_uninit_mask_free_work);
> >   errout_fold:
> >           if (fold)
> >                   __fl_put(fold);
> >           return err;
> > 
> > 
> > Also, if I understood the idea behind Ivan's fix correctly, it relies on
> > the fact that calling idr_remove() with handle==0 is a noop. I prefer my
> > approach slightly better as it is more explicit IMO.
> > 
> > Thoughts?
> 
> Yes, your approach is better...
> 
> Acked-by: Ivan Vecera <ivecera@redhat.com>

In the meantime it seems that Ivan's patch has been accepted into net.

- [net] net/sched: flower: Fix wrong handle assignment during filter change
  https://git.kernel.org/netdev/net/c/32eff6bacec2

Is some adjustment to this patch required to take that into account?

> 
