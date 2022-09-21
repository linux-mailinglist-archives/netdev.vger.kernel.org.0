Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9B9F5BFD87
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 14:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiIUMMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 08:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiIUMMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 08:12:50 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2092.outbound.protection.outlook.com [40.107.94.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A372956A7
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 05:12:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ep56yHQyiMrmDIwSeRsEELNNVR3oS/vdoIbkGf1bOWNJZ1l050SACwRnqgvDvJkhSdogzpbKtDocKznZ6DSBE6C2+ZeGOZ5ITpji6Y9rRwWRHwL6jIFicdmcJDGtAtdcIU2uyu7/AWkolEmr2fJhddAyQhjQogNfbbpzNYJ9dyOmguPh8lABR1T9YEA8rtzagL+5qfgPfauFIteywWwHbhx0/RqKcrowfl5x3kjhljd/S6yEZ1v6/zx1qHqQUu4IE+fMaUAJBuDdMAYPdKlYh24/d2fliiVZI9v1x6HObGlsBXkOlz0coj37cpOwuJ9CVCzbUA5K6jClwXxVN6NeXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r0KNJBBn7GF/x6Y0iyk2JAVxe0HTNUywKmp5nSZT8iI=;
 b=VykT+rokSQsShSa84mnUi8FWWF8l4mN7wW+fA0Dw8ET03mx3ps4zMmpSJmb/ERSLyV2pmc3aoeesQuzAjJ6xsTQB2uk4i7kJ1CaDURHnFjgDiqV07XkyRuvmSgc3LePSz1akbTnWzD//87NiECB+1RwUgvn7f6xQuFz4Z7sVsokECpoyM2KNViPRRC38HGopkiV5ZXulPlN3KGIomkhdfmkLz/eg8oFCpuRwlqTQ8OG6hf2BA0nlx161GTIMHJ6Goh7wbcTva+gU/iflA9GqKoGzr3aL/H51IRUmwFAlMSXlEybJYabsYhzpiRm5k0Irawe33X8rUorwjrwwMDyaMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r0KNJBBn7GF/x6Y0iyk2JAVxe0HTNUywKmp5nSZT8iI=;
 b=bxUw8F8AcjtfY9YO+o+13o0MMgdeTl2X2Bwb3YP9X7WTF6EDDDLUre8QSF1hET/MWhNi2b873f8UZ0/NcU+PpKMeg/z/NXlgXKgxooclqjYqLcTS5xbyFOUUQDCl09tWvJQ4e+U6F6emgnomK+eO8QK4fa1jpeauVgPN/BodDhg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5210.namprd13.prod.outlook.com (2603:10b6:208:341::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Wed, 21 Sep
 2022 12:12:47 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54%4]) with mapi id 15.20.5654.014; Wed, 21 Sep 2022
 12:12:47 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Fei Qin <fei.qin@corigine.com>
Subject: [PATCH net-next 0/3] nfp: support FEC mode reporting and auto-neg
Date:   Wed, 21 Sep 2022 14:12:32 +0200
Message-Id: <20220921121235.169761-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0049.eurprd04.prod.outlook.com
 (2603:10a6:208:1::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5210:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f07f9d7-b821-4a2e-29e5-08da9bca98a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: buMpT07bUHbIUzYTvjxgdEe76cnZaSszz0rEn+WlmToRqGBqArkOyi6PD43AzON/qU9wgLRqh35VSLNQWzsgPVYU3Wv5TYW7DRGAG+wdvBc8xMV9nnbsfocWBhs+LGLdKy605V4N6GyEp8rVmG5HCQLOeLuadHOLJhNxzzPv7pn7v1J6Pmm5g16qMCX2Vh2wtmO7llTUou0+mmcLEw1HA8Rd2MuRgD4YuuwARPIo/UApRxxQLnYvsbyr4oRREuj+blDVYu4yrbG9Z7eJDC91f3MBcSUn5kcMoXUcOtBhhW0Fq0iqCMDS7X67fxJfRr7OI10Tb2t0G1LWOmEjy1Ud/rj0aoOSZmRdl+eYJFKd3oEHgeSbjxSyTo58QbFlmeLhD8YNzZ4V3Yaj51/7t7Dnt68fgbaaWr3GZqaE80RA39KgFRsDDoO+4GXSqZXWG+LeCZOrSxnyHJs/sT/a90VkZDY/Tdy2L6/ReOXIYcuh+IhfoCFgabJ+7KomfSSHPcOK2fXqDAYHFSqcEzoRiei45/nfLmT3erMxjF7RHa13SipaC2h3cRVNs3LETC+ecCNlML1BqiTGSQOkOWqG004HFbaa7VaOHNV80qMYy/OnEyTrx4a9ynsLwGTOz4ZCAWj/jZdd4TSdOuZw6z/upu96Q6yg80Z8kDGChL4yMudWuaSXdxFq189jnZOGBulasDJuaGFpl432e8enAoB5+o6a2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39840400004)(366004)(136003)(346002)(451199015)(107886003)(86362001)(41300700001)(6666004)(5660300002)(44832011)(4744005)(8676002)(478600001)(110136005)(4326008)(316002)(66946007)(6486002)(66556008)(66476007)(8936002)(38100700002)(2616005)(1076003)(52116002)(6506007)(6512007)(186003)(83380400001)(2906002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p6K7RB0DzJnCK67TBR1ReVFXmyMBotonhmT2JlJq71j6u4JNb5UuSqktY+pA?=
 =?us-ascii?Q?eQ3ZTYQy9eY3JlwfDRWZXIwd3YgHuEeNaPKXphHaPp5DfOzsUo/xFtI7uSb1?=
 =?us-ascii?Q?jAJFEHsGCWuNqndpQDQUTFN/sXaGp4nuU1LFv+RNIVabZns4nqL780qS7Elm?=
 =?us-ascii?Q?i+m118oA4YcWBchraJZk8HLpWr9VyWLIWKwoXjNTKjbKKkyMpoxfIuX9Vo0v?=
 =?us-ascii?Q?krcqmPIL0NdYmFRotAYWnlVLfsuYmvLUZ3MPPDpZKFyIw9gk1zdjZOkhTC0A?=
 =?us-ascii?Q?2p0kAuS/BdaKXrV+3I6Oor7h5yy/RtHFuJXKDQeyX4PwScQs2jsHhOaKSwoy?=
 =?us-ascii?Q?8ZI5vcJ4TYPTKdY+f5+5zUpE7k7+OYzh9oZJqJoQTVGZtJEV/QgXa8TGkR5P?=
 =?us-ascii?Q?F0HNFR50V6nkmtBa0JgWbiX/nApjKaoNkl1ghXXQT2EAJ0vka2zIqv0txMm5?=
 =?us-ascii?Q?Tmbn70SxBp9BTaK4SywPO+oOskmU61nINi/n5cD+KA9RC+Sc41BS4Q74GEp1?=
 =?us-ascii?Q?dJlvcPG0XnkzaJ5iKN7YFIEjdf6TTp8cjpwu9XNUAlQ82S2Vk+RjRdN7Pl3W?=
 =?us-ascii?Q?bIGgs0ubCxpbFIkqmEymmtbEwEi0IzKLx4xWOHSXFM1JAncKKg4CoQjkx0jU?=
 =?us-ascii?Q?SHjdQ+K2Hopv3xkv/9IfnGk927iiR7WSzPXuw+9I5X1J7IgL05nQ8BWhp8ym?=
 =?us-ascii?Q?u96Fd9gj0aoHjet6Z35hUfQaKJV+2Odb9Y8w18uqhzz0EBxbeP9b48H4+EhQ?=
 =?us-ascii?Q?ej4WZNE3pet2xbBTp0S2EQa3UHIaXeS+uUalDq2rxmWbxyhxqKWoKhNc0/dO?=
 =?us-ascii?Q?L+9umO9o18e+yB9hkwYpKonTnSzvRkcX3WU8afeuKi8SB2+aPNkKJQyV+Scg?=
 =?us-ascii?Q?Lo8FdaeXcSzJ4O+Qeik5hJvgz+xxy2izrPF9DG3/H4n1L42NiUK4YOfIc0Ah?=
 =?us-ascii?Q?chCpGSDb5a8bEszAXrCp4Rilxtoqqeb0/lHYlic1Gk6M6hPkJocsyk5EGPUC?=
 =?us-ascii?Q?gdCt6bkCyK5PMo6V+b1GgF46s/9okR263iFleL6z8Bt0XBrsOQFOzjhUKO8y?=
 =?us-ascii?Q?lrjW6L4wL7/hcRnNx303jjzgt2HyJibMzZtCU0Lg/pGb93gf/EN/MvpkEu/X?=
 =?us-ascii?Q?LXC6sP1bvmrKMvB8V4+sjJtd+WtA3dagH8h5PWVbXuNN84YfIesoJooFpPeI?=
 =?us-ascii?Q?lrQBgy6uXr8HHbSmNXfYtAFOV0DNO1ohf3phARfntpHo1M8vZ6if9BonQVgQ?=
 =?us-ascii?Q?RKs2rRSNCNSoprSXgsSLh0IIhLWcGBpwT26Nv4YkyJXMboVVbJxyfxZ+R8X7?=
 =?us-ascii?Q?QLn8C7+DObuaGqPD7LDRy9ElplMjYYGQRd1QI0hmT8reUCXp4RvnmKMukKLA?=
 =?us-ascii?Q?uAKrwxd3aW2e4K+QAo9wIW4K4HnCkjnZlhtVqjBWTdJUqY/aoOHsPK3dbqwx?=
 =?us-ascii?Q?Wc3TFnOembkDcOS05RZmw6d7T4EXoGLtCDJIcDePVNIJkDBepGm88ju52P+M?=
 =?us-ascii?Q?Z/7Mss8ChrVW6IkZt5wxNCg3VBUcFIByneVa/mVD12Cm37dRs2Iiv7kG+zKG?=
 =?us-ascii?Q?ZkJCnzoGum7lkQDjOwv+RZRGPZSIbdGpUNsgZeTTE8jnvIMoOyigIi8bfTQx?=
 =?us-ascii?Q?EiBNMejeoL9s2yOXrOGrSbmZPOsBJvp4127M/YDyprcM6g0oAW1GE35hGJXM?=
 =?us-ascii?Q?SlgJwg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f07f9d7-b821-4a2e-29e5-08da9bca98a8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 12:12:47.6340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RSNbfeDxw6pT19NgMDsJxOAN4ci216hnFm+QRd5iMiEfXrdTlnVfQ5bt9wWCjT4kkAWJHH1SpFoHt3Qq+TDVMK0L62oQJayxIbV1br+wK0w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5210
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this series adds support for the following features to the nfp driver:

* Patch 1/3: Support active FEC mode
* Patch 2/3: Support link auto negotiation
* Patch 3/3: Support restart of link auto negotiation

Fei Qin (1):
  nfp: add support restart of link auto-negotiation

Yinjun Zhang (2):
  nfp: add support for reporting active FEC mode
  nfp: add support for link auto negotiation

 .../ethernet/netronome/nfp/nfp_net_ethtool.c  | 78 +++++++++++++++++--
 .../net/ethernet/netronome/nfp/nfp_net_main.c | 23 +++++-
 .../ethernet/netronome/nfp/nfpcore/nfp_nsp.h  |  4 +
 .../netronome/nfp/nfpcore/nfp_nsp_eth.c       | 13 +++-
 4 files changed, 107 insertions(+), 11 deletions(-)

-- 
2.30.2

