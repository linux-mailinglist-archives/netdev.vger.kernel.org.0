Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAE7E6EB030
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 19:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbjDURHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 13:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbjDURHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 13:07:39 -0400
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-cusazlp170100000.outbound.protection.outlook.com [IPv6:2a01:111:f403:c111::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DFF659C;
        Fri, 21 Apr 2023 10:07:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PyMp6cX5SKgSKpHoUxvVmmqNyHVoTpz5rDSSqc3rIzQRZ357GupqOpDEe08wXKmKbZMSDn4l9ryoDlaa+dr+KCWVR6Fdz6Vokm550qNtMV9FVixuRr7oxp8C99xzunFqUBK+kMSoXOIFgUgayTTo5h9tCqAz2+Zz02nzEFMJSTqw7ZAHK4qlbVxU1NMj8KLu5ZgIS7JdJUxuH8yIQqILyRHXLXZkchmhtxIak8iBQ0GIqpTlgcCFm+hSobN4QHYwbhVnwQAX7f6o0XkM6RMXDt4o8prvrhW3WjsdCJIQnLjbUyswUuEeM8Sh1yEkU5FP5e5jnBf1fnEZ8qTEDzFUxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fUAAqt2zlA6V2pSbGw5SVCTIpm+EIG4oMYK47XrZo8U=;
 b=maLcHMQVF4hdbK8zpaidCULYDynk3fQUEmoXW7diU6HTqpRPTW0YRXMa3IyHF6tp4Q+9U3AISlcOxMAJqbagVpKnwEdO3zWIrYl94cSrk+w5CVO6KmjOfc1OpoCwItNQwSFWiCgDHlEG1LyvN46I3Eqx41ktQ1faAkiatSmkR3O1uV1DblVqd5C2EDF9XgVdMuYiZ4WNKzLLLdyWg7/oWKNejkQDGtEgx+d436o1giEjUKvOZQeoLbwl3jKckrPgGQLLGg4OUTvXpELdm0xI+tWqYBpKTgm106XUzvDiRa5mhrpqvkBvZJXJ43FFlo+3zNhqN7Z5bNeY8o4Ymt+CoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fUAAqt2zlA6V2pSbGw5SVCTIpm+EIG4oMYK47XrZo8U=;
 b=X25t0itKRkrO940ISX+p934KpuxLcaLkrx4jjSqqcx4GcghzdQc5ViZfqNO476N2a81ulhHgXIuVXGKvDg/+YGQRvNoSRfTTRoWWeHkGMjNRBvdOK8UwCrB3v7HjU4vcDJ7q+zDXTJD9nkhvFjsNm8g9XBhg8Hvkrq826C/2kLw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BY5PR21MB1443.namprd21.prod.outlook.com (2603:10b6:a03:21f::18)
 by CO1PR21MB1316.namprd21.prod.outlook.com (2603:10b6:303:153::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.11; Fri, 21 Apr
 2023 17:07:27 +0000
Received: from BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::3e5b:6d93:ceab:b4c6]) by BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::3e5b:6d93:ceab:b4c6%4]) with mapi id 15.20.6340.015; Fri, 21 Apr 2023
 17:07:27 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, decui@microsoft.com, kys@microsoft.com,
        paulros@microsoft.com, olaf@aepfle.de, vkuznets@redhat.com,
        davem@davemloft.net, wei.liu@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, leon@kernel.org,
        longli@microsoft.com, ssengar@linux.microsoft.com,
        linux-rdma@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, bpf@vger.kernel.org, ast@kernel.org,
        sharmaajay@microsoft.com, hawk@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next, 0/2] Update coding style and check alloc_frag
Date:   Fri, 21 Apr 2023 10:06:56 -0700
Message-Id: <1682096818-30056-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0102.namprd03.prod.outlook.com
 (2603:10b6:303:b7::17) To BY5PR21MB1443.namprd21.prod.outlook.com
 (2603:10b6:a03:21f::18)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR21MB1443:EE_|CO1PR21MB1316:EE_
X-MS-Office365-Filtering-Correlation-Id: ab36f4d2-e1aa-41dd-8e52-08db428ae230
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ABTrtml/CYL2cEisiyx6978TbO0Lr2Y8NiGOPpNnHAuqznQCVrx1OHAvKPIJE38EZM1EtnNPlki+XbYigIsQUXf+WR71odMNk62BdnyjM4CbsMmb5zhsPLwjo9xHcPgv8x16UVxgkv9sp/JocxXKN22dmQAlJU4Rjuy46Q7mgkfyuoz7aALDAObQ5em2rkOaw/JCutibLlSh6GRxnhsc33D2b2F8SwhTYPqSxMo0JKcdWQKy9BVxdQSzdMKLEsqKMJIHRw8E6Z4/0ABo7lQ603lV7euvQoa8lr/e15daJQlZm0gePl3mNsoncQroBjFOFJpO4iSo8bc96MIH5bs0xz/+oE1KK9arYC4HGKUoX4wzUJTf3QBEFSE3uhkTGINJwHg8dxmILD77Ud07vZWYlEnJPylI8UA/ZuYnMjmnuW06dpsMJMeEfw85NuSA4OHPiQzxan1VswO7J3//V2eSqEuK5/sd0Fg80spUjnqd6SJDaX23igfJ1WmEZohkfddO2bD8ofbxxQQAICcoSrEpLtxN8pl7rc38dc+rZrF8UEnaSL8qNEZtl1zqpeMEtYQcZGkXrx5S6r3hBWXlg2kmI0AU2CgL94JXYNXlDgvER9b7HmYbjgtMF2gEf5WHts7M45inCcHnhQiWKdiDUQrr7UDJ3q3pOVXyLgPRl5r2RJg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR21MB1443.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(136003)(346002)(366004)(39860400002)(451199021)(4326008)(66946007)(7846003)(66556008)(786003)(66476007)(316002)(36756003)(6506007)(26005)(82960400001)(38350700002)(38100700002)(82950400001)(6512007)(2616005)(186003)(83380400001)(5660300002)(41300700001)(8676002)(8936002)(478600001)(52116002)(10290500003)(6666004)(6486002)(15650500001)(7416002)(2906002)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PjrQ3YnsYNGo+u44RDN0A7DLRhOB1tghQcgBN2fXf/eaqKPr95QFWg+I6h7V?=
 =?us-ascii?Q?oZpghDbb58ceER8Tst8XPSLlhKHCAkjqvA45/EQldiqTiyqgW7/HzYec8Lbn?=
 =?us-ascii?Q?4Qkti1BJmHPmU3up2PtcVlNmPgFs1oszZ3VGJVRbRyLwHMqiLSrE1DDUc8VL?=
 =?us-ascii?Q?2AmyIkBGds3iEWN3P8HzYoOxcHZr2HATcTdSqIrJeN3Jd37CT8uaVrAu7rSW?=
 =?us-ascii?Q?NV6BJEcpUewhTkXonCb93EK72tZDwMD3Bm3KOmkh7kfYLPmLivNnE4X0GUeW?=
 =?us-ascii?Q?fskO6sHp3rlVZlLW1sK0n5XvLFp+m02DHkcbDos2gZMGaln92/wjp5b8iKUK?=
 =?us-ascii?Q?EsGRkTEgt0DFKV8YwhKuS41rBs0X3t3CflhHIL1C1kLxNhIm2bEMYpNEBsvp?=
 =?us-ascii?Q?uDrT7tak2390SkzQ7IwEv+bUs9XxtVSs6JzastGyktHFp1MxI28b7JuWJe8j?=
 =?us-ascii?Q?Y6EBszLoc0JUcb1HBUcVG5qs6m1VF8mVFvb0EzXZgr41tDDNqvukT43n+aCe?=
 =?us-ascii?Q?Ii3CpvG+dv+2Kf4XZn+MR3PaX7wIR0Mmf9LQ+ka2GK+lYsQfYr97P+i6bVGY?=
 =?us-ascii?Q?CvAnfUYo49SiqV7wqS368KUT8niy8DUdLICxCif2krspfleWcAYL3v13iQl7?=
 =?us-ascii?Q?XG2qX8v+OT/QHj0k6ehnHhNis+LW1WV1r5HJ44YVyuQFifJbl4i4VDDxMZVc?=
 =?us-ascii?Q?W/x3A1IC5rAeNwOq0qojkX4s7mKJbnEtN/FG2dNCrAhnLFQ4is5QwQ1Tvk7D?=
 =?us-ascii?Q?2VmVw9y0M5z38MaGcHmRwwS6M20Zs+4BTMWv7iqwWN9hUHojhz/BFTL71RyO?=
 =?us-ascii?Q?4xy7zszDwB/Sv9/56yKbtkZHUceuThvpmluCNp+Ouof5B1fV5nhwvMew+G0e?=
 =?us-ascii?Q?YQxfY9OSTCKSMutlsa0EVwwBQBZbjKlTID6x8dFmCCSvvj0GhZIsXvdKS2rd?=
 =?us-ascii?Q?w2OmjobjBrGHi/aK+rKjxr3rgqWBJba5pPEF/wZ0pTIdreHMefy1McE9s5dg?=
 =?us-ascii?Q?or/Os9yXgr4MNwBPwfSQ1qoku6Z0llvgstGK6t+xuxQqywOYINqrGU2DOHEy?=
 =?us-ascii?Q?lt1NRNkIYngSEXX3orR63lwvzHfE4k/2bbjGrg1K/fNcgTzteXQypRB9DNcy?=
 =?us-ascii?Q?IZ4incOca7wo04iiZtlG1Q3tE8U/NakQjqJGqycKpD5KNtSSge76QbKKCs45?=
 =?us-ascii?Q?dxZdB3gtTJAiVhgba22GHHPJkrf7ikHeCtTrafWA6TLRbGmuo/257/Sv19z5?=
 =?us-ascii?Q?BWfGda+RLL7uetYwrV05chGZqi7XsWX9BKt+dIckCBBjhFWisdIHXLalA3bq?=
 =?us-ascii?Q?uM9pq2Ih8WnXFZmTTsqqZCPzlgfOlas8Yuj88DRjTEeht8k/6cDGpAlt9fBk?=
 =?us-ascii?Q?YXQIxBDtJahY4aLGHlVvj5njb3JXewMajp5jyLRucGvgIN9GSf1tN5RvXdxn?=
 =?us-ascii?Q?mnpvkk7AXVWt30jS/9R5jinq2jA13Z2FLVjkGIVH68IZoXo7A5YPcwN6qGk7?=
 =?us-ascii?Q?hfppeEQkgEUKUlhfz/YQsBPu9NTK9gJbf2VAjRbcnSPfxoSk88xygnLLC0w8?=
 =?us-ascii?Q?h4MMVyy9Ps/b04FFwNLQEkCaR2yPC1Ub1twmGB2Z?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab36f4d2-e1aa-41dd-8e52-08db428ae230
X-MS-Exchange-CrossTenant-AuthSource: BY5PR21MB1443.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 17:07:27.5727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iyP678z3CtS8E6G5UlE5vx5S2b/1yKPn5wbpw15VtroqPtQOdN9m7RbgpI2eHUYVBy3sQ0BO4QDTtbfY0Ucxew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR21MB1316
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follow up patches for the jumbo frame support.

As suggested by Jakub Kicinski, update coding style, and check napi_alloc_frag
for possible fallback to single pages.

Haiyang Zhang (2):
  net: mana: Rename mana_refill_rxoob and remove some empty lines
  net: mana: Check if netdev/napi_alloc_frag returns single page

 drivers/net/ethernet/microsoft/mana/mana_en.c | 24 ++++++++++++++-----
 1 file changed, 18 insertions(+), 6 deletions(-)

-- 
2.25.1

