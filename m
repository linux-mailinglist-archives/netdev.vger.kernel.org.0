Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70E885E9BF9
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 10:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234025AbiIZI1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 04:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233925AbiIZI1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 04:27:19 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2071c.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::71c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4C9357C2
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 01:27:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QW9l7eemzSnculKW6nnOlIO9oBUwM5AoCbEffuaOr7hy7WKq37Hhm8CVhoo3nhFsx7tC/KhGN+vB0Jh44IAg9T7Tn7QnYfRuoE2djEBuueO0VDW0Xukkj39pj10o7zqe6fQ7hDFi+KVZCHFsM50P4MhuWy8igUhta/6W0/N9RDT1Pn25voP9WU4Tj3h9PpZfWBHkFIiJhGkPSyVH+PygHKYxqgR+gW50FEv2MyfZkfqdqBn6kfQOB7LX4BehKk3kZO/VkWHA77wgwQTCMjO2V8Xxd8sVVaGo/EHmFvrth+N+u2Lsep6FmlR6pWNpcVp8HELnRM0WaqtZVnBLUNdQJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gN62CbnoWsRACh0wu7eH9eVo6Qa4A8El4JLr4Rf6mZY=;
 b=lBbd1JEaPyALfuHhIfR8X40gLrAex4nEUjgl8WQ2+X8+fZw8ZSeSFbouKwW5/+gtXXKWjRXPAbHV09rhWdXlSp7LdbKEbQKJMHJz8vEis9SErlZW6aPHoQFA8aCf1mEQ6EPJFvo90c7a4uNGlRdVgdlYiFahKTST9IpEaRlmim3/Nt5mWbqYW7poV5G+8GTpFlIjm20TMFG1z2cDOQJTFK6ylz67Qnv3NRfNlmt0+uQEXcNMoFsoIhAbQ4+ISbDPMbfgKeE6YZvU1rQrRN+lTpvRlS+I2tAJoF4jfJ9pMpUoAFwDoGPOgV3i0NMHItHsXYyS+PXg7k65LCUpK2/sLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gN62CbnoWsRACh0wu7eH9eVo6Qa4A8El4JLr4Rf6mZY=;
 b=tmObgM7NicduVHwp+U6C60KpbbwQwIm6ANEYhmiuUlKGah/oPV2vS7hhDJmqi6tl9Iboh4YtlxzmUq8hFEAaRPQlabj178JrFbhUytLWiowXea4UL5MUS74zuQBE3yy+5mFbEScyJYJaGUypoa1+NqXPyiP8ufWPUqYg2JnCwlk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5282.namprd13.prod.outlook.com (2603:10b6:510:f2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.14; Mon, 26 Sep
 2022 08:27:14 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54%5]) with mapi id 15.20.5676.011; Mon, 26 Sep 2022
 08:27:14 +0000
Date:   Mon, 26 Sep 2022 10:27:09 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Juhee Kang <claudiajkang@gmail.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, skhan@linuxfoundation.org
Subject: Re: [PATCH net-next 1/3] net: use netdev_unregistering instead of
 open code
Message-ID: <YzFiXabip3LRy5e2@corigine.com>
References: <20220923160937.1912-1-claudiajkang@gmail.com>
 <YzFYYXcZaoPXcLz/@corigine.com>
 <CAK+SQuRj=caHiyrtVySVoxRrhNttfg_cSbNFjG2PL7Fc0_ObGg@mail.gmail.com>
 <YzFgnIUFy49QX2b6@corigine.com>
 <CAK+SQuTHciJWhCi-YAQKPG4cwh7zB9_WR=-zK3xTUq9eTtE4+g@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK+SQuTHciJWhCi-YAQKPG4cwh7zB9_WR=-zK3xTUq9eTtE4+g@mail.gmail.com>
X-ClientProxiedBy: AM4PR0101CA0080.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::48) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5282:EE_
X-MS-Office365-Filtering-Correlation-Id: 09908637-f7bf-43fe-9b5a-08da9f98ea86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kWwXKuwv+0BDUyieR8zp6oNTmmpqogDOo8/DAqlDHLndH8gvAhWJF8T1BcLeOOhDGW17jN+y/YOQOe3JGtKxdjOWTnCvLyauXCUPnxHHuPiWOx8LITnu66vcYfRhCdOpFTPAQWSnbWDnnUh+mFCITYhpOuoKTb87nPxuZ2qPVDOMLzhH1bs6ijo3y2xmWrzV/iaui7WueBSRIdrH9FshbkAkh6ouEzvcbqJg93L+tPaIF4c8vRv4zAUhcq3KPl8lU6gw2X0NolIBM4IW8iH0Kk1IguI3tvzcpbuI6drac7PevlcTeeZKG98UIzepiCzBvqq3iL8QXGuz7iETdiXYaPu5KTWLk7ZyJ18XlsleaRtM+69PgdsKIzzmTNhYimVidkLosWyxDyojEzehxGQTMNh54RcSD99mLsXOG+8io9Lm05noGw2Ef0MELJsbyRBgYdORVdUC7RBC/vsaq/7pFTACUsPvxBAIfGNjcs4boG/kOJDf0Ou76dehnIE9xbz5mJOTD2aVNZfPFc+JogpIdBtfaZqj/w7Kg5HqUFK/Atu0fLVRBjwF+mnncqAiOj7YzGdVRl12YEd2hYkYjw7xXgWjmbifZjgOJSpmOTI8iZLNwj+BPt40Q2fXy/A4xRUZ5a17GjajdV62sCR6PB01qMkuq/dPhYMqmESpVE7vFkQtwffPPhKql4b0wrDc/fIGxdheOYPs+qHqnnsZWXeFaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39830400003)(396003)(136003)(346002)(366004)(451199015)(6512007)(44832011)(36756003)(52116002)(53546011)(5660300002)(2616005)(8936002)(2906002)(66476007)(66556008)(66946007)(8676002)(4326008)(6506007)(6666004)(41300700001)(38100700002)(86362001)(186003)(6916009)(316002)(83380400001)(478600001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eC3N/vtwHOht2Nyd6IxddR/d0G1ZzGySD7gPt+bF1pyvGpy9yYNgSNNhIqpq?=
 =?us-ascii?Q?GnFaRtDnzdXYW0mVavTwpLhKxjakqa4bBoRzR8M9nquxBUAjYB1y7To+GxPa?=
 =?us-ascii?Q?HaRZOwsh6u0CMNZCmQzjLLgQwpULfdHCd3ShE1PZJAPWZto4vExgwiNxAcGV?=
 =?us-ascii?Q?RrzAOWhIm/4sHsTOAA76YIOejLqgLt/4fdDAp1JDaLjNUkeWpH0BtOZJglNM?=
 =?us-ascii?Q?rBC+jz5RKst5euuWyQKcV8TCaw5PIehSEfhb90ZoA3tr3uv4f7JVCNBXTiuH?=
 =?us-ascii?Q?/gEUrKbjLXMTfzh5/t2KWDI0SEzRR59AKGkYSmEvawoucnA2D5DdaD/Owj/Y?=
 =?us-ascii?Q?9Lhgaf+0iXDWlHeWe/kbsAeFtY14wGGMesdV2hzelxPYl3apvkS0FBBFkxTv?=
 =?us-ascii?Q?qDjbINB56bA7yElV3kYmAWENtLoEaCJQ3DtFulclQX3TTg3vsU+JgF3MsABT?=
 =?us-ascii?Q?gxr7NenKvQlnzIyQYrPYlsmkpYjF8JjOuUr9V4pvgNwMYYKw9zrmbHHkGGz7?=
 =?us-ascii?Q?jogugOGzL/A6gCXoEEzd5+csYD8baytBGljubEiF8Kt8/xJv4a4cLWYnIeDg?=
 =?us-ascii?Q?HMg0o5/4HgIo/VGw/571KTG1DBxiZgolnCJ96Y4awbFwaA7HRt7/M9ss9R8e?=
 =?us-ascii?Q?YXpAU6GamNpqMxa3ubTR27XeE/ZRhHyMW1rDnlMYW4ulunc8Z3kAuoFhBmYt?=
 =?us-ascii?Q?rhquTcO4VZhbFvO8vUkGWy5ffhhc5zGB1PbvNiTkWe+46U2VveYI9XQo+xqj?=
 =?us-ascii?Q?NfT242em2VyKjP/wmvhnLgB7UcgBl0f/9YbEa17AjWqcMnaecK8hs7P/u2uX?=
 =?us-ascii?Q?anPNL/xBuV8zGP8jluDOnmkLXclmjlxgmOHIrH/SiK9xWTjL2pPhiM0MT/Ot?=
 =?us-ascii?Q?7sbZl5fKDuLG0YSpBbG5MlmrdOJuk6KPycIeOwbHgN6itDN1a6LRFEExyOVD?=
 =?us-ascii?Q?bwBTm/cxiJfsgdwx+K38WQVIqXQfLQvLe5vczXl3jbz2prlk759poxLZGgtI?=
 =?us-ascii?Q?MCW7yfrTcFS1Fcwuqk7mALO4OOYbvtCZay97H+4hef5pLe8QPV7ChBewQIdH?=
 =?us-ascii?Q?Paj0BptDyd5oCBwMJRW8A62XKFAB4/KuUyLq5FhVmdcUTySxyjelfUaUBZ4d?=
 =?us-ascii?Q?7Nbeg1gsP8spltTPAalvv2pzXWQQozAhbtAPh/osmshzcYpOOLA3ikTTSYtJ?=
 =?us-ascii?Q?2kNoHQFTOdBFQ1HS33jCCrhK5QpHW6pnO6HOYfPWbRs3Os9VF+Jt5pLC/48p?=
 =?us-ascii?Q?j4NgyvnRwGajIfBaeQwXztmtTIoB6tnDbMRYznsjlXTQUoKGMVuozNq1i4Rx?=
 =?us-ascii?Q?iDEW9+Y3KumImKqWF8RSgrX7a3ArATHXIfvIbauG/ISvgkHeKAwCJFXNQ8eW?=
 =?us-ascii?Q?urqEleeas0E3B1QWAza3gNPk/GTANSl5F4boerjiRIbaSB56vY5mROyywZMI?=
 =?us-ascii?Q?K3LabKt9HOy48IH/T0krdoWgy8rDJBU5Z8JcgXMKwlcE0ZEr8kHrc8pP7Xnf?=
 =?us-ascii?Q?838sgp5HUaBWiuLLeje5OZjYReIYYezLCsMHEkv+bzYsO7iU2zNV+fr38KO8?=
 =?us-ascii?Q?2T8zBTctF7MDWDAqD13Knn6Kc3xaQMkFKAkb8of/dHnxl4tDMCmCwidDMTfz?=
 =?us-ascii?Q?cW7fabz9RPM0GmBFQmk5IxbG8KtsTFzlzIm4Q9gkgfQs9OjrhkTIPXEUdtv3?=
 =?us-ascii?Q?XcguPw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09908637-f7bf-43fe-9b5a-08da9f98ea86
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 08:27:14.6132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gEt/9Ht7RKi8TmLC1qeg1OPGbnGct7jFxb3RLzSFJK0vLEGZyU8FMza9tK4zGJ+J/eeuozA6a+uA+f68oq1/ISBCfmB/so8O7T2yJXOm7LE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5282
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 05:25:01PM +0900, Juhee Kang wrote:
> On Mon, Sep 26, 2022 at 5:19 PM Simon Horman <simon.horman@corigine.com> wrote:
> >
> > On Mon, Sep 26, 2022 at 05:05:08PM +0900, Juhee Kang wrote:
> > > Hi Simon,
> >
> > ...
> >
> > > > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > > > index d66c73c1c734..f3f9394f0b5a 100644
> > > > > --- a/net/core/dev.c
> > > > > +++ b/net/core/dev.c
> > > > > @@ -2886,8 +2886,7 @@ int netif_set_real_num_tx_queues(struct net_device *dev, unsigned int txq)
> > > > >         if (txq < 1 || txq > dev->num_tx_queues)
> > > > >                 return -EINVAL;
> > > > >
> > > > > -       if (dev->reg_state == NETREG_REGISTERED ||
> > > > > -           dev->reg_state == NETREG_UNREGISTERING) {
> > > > > +       if (dev->reg_state == NETREG_REGISTERED || netdev_unregistering(dev)) {
> > > > >                 ASSERT_RTNL();
> > > > >
> > > > >                 rc = netdev_queue_update_kobjects(dev, dev->real_num_tx_queues,
> > > >
> > > > Is there any value in adding a netdev_registered() helper?
> > > >
> > >
> > > The open code which is reg_state == NETREG_REGISTERED used 37 times on
> > > some codes related to the network. I think that the
> > > netdev_registered() helper is valuable.
> >
> > Thanks, FWIIW, that seems likely to me too.
> 
> Thanks!
> Apart from this patch, is it okay to send a patch that adds the
> netdev_registered helper function later?

In my opinion that would be good: let's fix one thing at a time.
