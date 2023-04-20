Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 291FA6E880B
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 04:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbjDTClP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 22:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjDTClO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 22:41:14 -0400
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021014.outbound.protection.outlook.com [52.101.57.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4D2F2;
        Wed, 19 Apr 2023 19:41:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gK4duflaRTqQaWN8Q/JTtR9fQ/K4dgM31DYIiVP1BFPZMKQVKtcEPRSU+6P4we8fYvONv/B01LvsdEj/fLWEgzVbS2jCRfnJQQMhHaleerUNT4b9xQeN6xLy9hhREVn5XbP6J+WC89Cn2XE+JVteYWZPdcBwqrU3e7M+s7VEsIIbjQ2WCv/Yrtjyk3yec4Vf8qdRHFGJrbjOz+JHIkLgeJlrgoj5y9WXBTL8G3ZoJQ284sR0rp7IcDHXg3FaD0BHvYThAPI+DNuJtyuRd4Qvc+7XWI3kTmvIwUIJRV6U67jqycYkssrtnPexoGNenZAEhwHdt6DI7i4sUiNKr0vs+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WOM67pBbZqEU6233oIAMYg9ABoV9tHU8HDvLg4S3tWk=;
 b=i648LT68ELLroRtT00SSayFymIglVrfrsoHr0tuqIkmAtpCj1n3X7oULcohCsSnuuh9ebVco8BoFlixxZGTl8opEJQ3XObIYSeaVBaWyk1VeHRpbjghCcsS7D3OWabsdP+grrgI5ibQBjjKa3hQyRJsbzhLGsN883d75rma3LfzD6mDpI+Q2N2GMySX452LWpVQtyjdWt7XQPA3I22ncQWWBXXcRfND3vS9BVmCyrtomoacWfu+ce4j/A17LMIi9zLZxeOBMkvFuf9t7BQhP1DrK5bqMIBTcIxuPa5XNcPSRTARnKIUuQ819Z9swxkpp4BFVDpi4Yqnjzj7kDwsWqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOM67pBbZqEU6233oIAMYg9ABoV9tHU8HDvLg4S3tWk=;
 b=fUZ/Zvln2FSc8X9D1kbZ6Jn3314LAtDlOBXG2zPVev9TcHjqZ8INtGhGeW1wvkJQ/UI46qJ3O7VcOrrwq+0X34fK3rUZgs5FmakLQixYZ4XKpJuUaGlj43JK23dSqLn5w6gOTjP1zm+SnbQCoUDZb+OHWWZJSS0QAqYRoYz5zrA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23) by SJ1PR21MB3411.namprd21.prod.outlook.com
 (2603:10b6:a03:451::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.7; Thu, 20 Apr
 2023 02:41:09 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::932e:24fe:fc1b:5d30]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::932e:24fe:fc1b:5d30%5]) with mapi id 15.20.6340.009; Thu, 20 Apr 2023
 02:41:09 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     bhelgaas@google.com, davem@davemloft.net, decui@microsoft.com,
        edumazet@google.com, haiyangz@microsoft.com, jakeo@microsoft.com,
        kuba@kernel.org, kw@linux.com, kys@microsoft.com, leon@kernel.org,
        linux-pci@vger.kernel.org, lpieralisi@kernel.org,
        mikelley@microsoft.com, pabeni@redhat.com, robh@kernel.org,
        saeedm@nvidia.com, wei.liu@kernel.org, longli@microsoft.com,
        boqun.feng@gmail.com, ssengar@microsoft.com, helgaas@kernel.org
Cc:     linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        josete@microsoft.com
Subject: [PATCH v3 0/6] pci-hyper: Fix race condition bugs for fast device hotplug
Date:   Wed, 19 Apr 2023 19:40:31 -0700
Message-Id: <20230420024037.5921-1-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: MW4P221CA0023.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::28) To BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR2101MB1092:EE_|SJ1PR21MB3411:EE_
X-MS-Office365-Filtering-Correlation-Id: 8cf5489e-10a5-4630-c22c-08db4148b1e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t+EnossUVzShVk4zQQjEqIvVI2w9my18HmvktoHvu4GgX8kPkpb66riYBONFwLqB5MzFCzzzOLyYsn+hk8m9BsQPICgno88IOwwKu1GJDJvLrP9ZEyiSirevxa8LJPttmc/04zMH5K/DaVvNc0/yR6E5Olki0FLksPodRWQz1wYodPXymV01C9oonGMha49PeVZoY4niScTNC28gJCZL1LDi53485cFkveJR7FHjkkk/6/JsqK4HnGYHb71DUCMFbG7ZMsNB6HYsxevmD8nSOVzvIscvvhg8ZRB4ps9g304bI1KA+UGQIZbdeAwd1mpMysbHZn15wjuLP1IGkrGpEbvnzgglay7VwuGU5Euyn+KEuG9K7sZv139XuVAVso0o7lc6PrQOW1XvuiLt7dHedwc2XjJK/s87w/gMsWM5MLCI2SywYXNjpfkoCpj90B4VgoYckMkV4tVn3aeVXU5PHKJ24hLGfOlTwE5Xs0VV19BKkKIaUCcYRWoKsVtgTHaftS24hfwlLAGJu+KY0lfVr8qjnNWcyUzHtyF0BCzNYJRAlZu3T8DCYm2RHI7jwB/MRIhOUOdJIhuX1QDGUrHQdeLgTbLaJ7+brRDiu+56BwQgcp6yZtTh9MlaojhBk3WWqTXrHcondrfy/p1Etlt8R+enchtXLY3h7/G/OVF5K2za0pVRel0rB00kBKrkgPAq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(451199021)(2616005)(83380400001)(36756003)(186003)(6486002)(6512007)(1076003)(6506007)(966005)(6666004)(52116002)(66946007)(66556008)(10290500003)(66476007)(478600001)(4326008)(316002)(41300700001)(82950400001)(82960400001)(921005)(786003)(8676002)(8936002)(38100700002)(5660300002)(7416002)(107886003)(86362001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KO/8tbPh5kwQ1LehDBhwMXokI+Cp9bDevRkHmoeBaQeW6wGl/U6TC8kq88ET?=
 =?us-ascii?Q?0eqLMEMlHlZPhdaEK1lOcZT7NR/uBu3EmymqaEuINgMfpI332I3AGlh61dEs?=
 =?us-ascii?Q?Otkz77prMu5CvCz5t0KSJxvG86Zn/lAleWPveN/60YbbpkoRhZ9Sgnm6hf28?=
 =?us-ascii?Q?jsxWWsyyGvgmridlr0d1zF+BI0nTSkXlZx4rW+AQIG2uNe/aL8peF1m/bSXd?=
 =?us-ascii?Q?B1pTSmQZ1d2x5PCix9In9i52nYl8Ff4a0lURvmgIi8gPxsyKe1pvvgr0WZRr?=
 =?us-ascii?Q?0HfMaioiStvMaYOKTeRLA3c8HB2L1GOZv73C6Z4bjmaePgv9q79wO1ytlzd7?=
 =?us-ascii?Q?HNB7EQ1zWktUYw8U94BbJhB/Y2lsn3PMiV/v05tEi51yV1nqHRYwvKQYj36H?=
 =?us-ascii?Q?Ur0JF/391ZexaBvCqKBY8pgvlrNX2J13F3JrsKNA+wHRAT4dCjYHjBJ+RNtN?=
 =?us-ascii?Q?/rH0CT2xAFv05nMbgLCthgQetLCfEVZlI79NT6sP1JU0h+kZkK5fUGy0993R?=
 =?us-ascii?Q?ExZMN2BI4jJWi2lvwQV3kBwVXMi77gInK0fGwv/G9IX8ujBiG0NG2mURevq9?=
 =?us-ascii?Q?nkc0ud5bPppIZ/J8msh8qI8N+/nva5ZNLckojOLU9xm0MOGk6Ouopl65jZwq?=
 =?us-ascii?Q?WJOIKKuXJImMK4NG7xWUwZsMVo3v+ggP/h1E/1khEujuEVfWOyosPEK6+YKx?=
 =?us-ascii?Q?6+Bzk6qx6+8/Q5DTqD4saeuFMuMFKlujNjnCT1YAo/neY5ZGSGLka0upaLbt?=
 =?us-ascii?Q?iOGIJPeT9jAyCRW7lvkCiyVDSU3K/dQ2QVmus8I1rFuHXV1g7s35Tjk/491P?=
 =?us-ascii?Q?TqrHCHlsprkNVM62u2zcZ8BH/R3pJauxg/vxgbvATyQLvDJdWf/qeNbmowGH?=
 =?us-ascii?Q?EvLNlU72qY3ZKQW9pNvCbgPoTcxQZ89Ue0k9cyVNo36unv5F1yIV9S73IuB/?=
 =?us-ascii?Q?H0JNuIvP2gBa17HhF0/x6hFIM6Fb81ZKenq+m4p9zY9Ffm413XkUL4441QOj?=
 =?us-ascii?Q?lF10IdNY5NHJNkp6+o89ZJTbT6ktQUPQtSg1ldlBp3doa6zulYeEx2ZeisB2?=
 =?us-ascii?Q?w5Ue2Shd0+zs5L2owC0NKd0uBiByHXfYh+WU8mxd41VRwGG/qnuKrSM/69/x?=
 =?us-ascii?Q?AASIeZbR11LtH/EPQp5GU2iTHbKlxLn3MTDtR6a09mp8iYPlEpj1iEkHvwGo?=
 =?us-ascii?Q?hRbhSGxvuAX8706bAsP4LuHPQ6QF+QS+AyuV9WLwIEZ76S7WJ8UnNpdrUX+H?=
 =?us-ascii?Q?gSLmorbhXWDpVBPdukfj1W00a7pDyaB6gM9PLReGg5mMhEpJy828Od0pkSjO?=
 =?us-ascii?Q?PKnFXGQlBqE3zsWPfFTHnhoQxY2W5X+bkKF0kPm8Sn8RT6ukccwx2Z1lJTdd?=
 =?us-ascii?Q?a0F5e7D2dKxGcuWverlIBq9PvoQMP4lXpBSM+oKx80435f5UWraMNBBJ6VLc?=
 =?us-ascii?Q?SaNH14Z48Mb/17wbf8rv13axwOL/rMSThKdtucR/CjFKvBdOF1M0re3lPQpA?=
 =?us-ascii?Q?vZFtd3WTs9PV22mhfgAK6eICRIUzQwMffa92umFk774fmSEuOBQadsREhhqv?=
 =?us-ascii?Q?/39Z+Wnqw7sdH8M/hrhC0ojTekfleUcFOnGglPv9NS/QeBwOEj+c8jLRm/Iu?=
 =?us-ascii?Q?n0khWlXdIcSGp4SaB9q4d41xOR+ask22wXhaX/+u4YQd?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cf5489e-10a5-4630-c22c-08db4148b1e9
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 02:41:08.5575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rcK6EDcBhE0XYTba+e/yB8nJMWoQirzkQJGFjTHoGdanMCgO6IAmn1FB8DiL/p462h6b/YH21ZGnlH5grgGT6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR21MB3411
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before the guest finishes probing a device, the host may be already starting
to remove the device. Currently there are multiple race condition bugs in the
pci-hyperv driver, which can cause the guest to panic.  The patchset fixes
the crashes.

The patchset also does some cleanup work: patch 3 removes the useless
hv_pcichild_state, and patch 4 reverts an old patch which is not really
useful (without patch 4, it would be hard to make patch 5 clean).

Patch 6 removes the use of a global mutex lock, and enables async-probing
to allow concurrent device probing for faster boot.

v3 is based on v6.3-rc5. No code change since v2. I just added Michael's
and Long Li's Reviewed-by.

The patchset is also availsble in my github branch:
https://github.com/dcui/tdx/commits/decui/vpci/v6.3-rc5-v3

v2 can be found here:
https://lwn.net/ml/linux-kernel/20230404020545.32359-1-decui@microsoft.com/

Please review. Thanks!


Dexuan Cui (6):
  PCI: hv: Fix a race condition bug in hv_pci_query_relations()
  PCI: hv: Fix a race condition in hv_irq_unmask() that can cause panic
  PCI: hv: Remove the useless hv_pcichild_state from struct hv_pci_dev
  Revert "PCI: hv: Fix a timing issue which causes kdump to fail
    occasionally"
  PCI: hv: Add a per-bus mutex state_lock
  PCI: hv: Use async probing to reduce boot time

 drivers/pci/controller/pci-hyperv.c | 145 +++++++++++++++++-----------
 1 file changed, 86 insertions(+), 59 deletions(-)

-- 
2.25.1

