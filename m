Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B68395456C7
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 23:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233773AbiFIV57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 17:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231699AbiFIV5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 17:57:55 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-bgr052101064020.outbound.protection.outlook.com [52.101.64.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5627665D39;
        Thu,  9 Jun 2022 14:57:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YcPDCO0Y18Enms8qKNccpbab/IF/3XK/SXjs7U2EoKoBhPPkngkCDA6cBQWuDt7ek1qje9tr4zUeHQaOn9+6MGrww+ta4cgs+mc7pEpgkq5kQS3Rg7emeu3I7aUJYJSP1lgcmO7PWG1W+zQYAKm01L1v8c8KDwxJsBM7eg+Ajp79mdSQgS4TH8WUSdy9/ACFdqsyQ6sV4KOxRnp6HjYDCbBTkUDQuzIkCX3VI218ossfw4D+/zDQbdhgltu71OP0oFI+Hfw2+rIUMcqxGQ18NKllxgHxXExSaH9M0lB2qPQ80qPe9qsaLPcEAfWEnYED6epJQLmZqkVTc8RWHxzaPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p6QMxEqA2iGGLukTTl0VpGpIOMNiCbSxVnHUTRKm4n4=;
 b=c/Bo2U046M6G4LQkWUIfC4tsicteqx0RcJOkpzbRsht4r6wJ18n5dXrTzXOSqc0tX1z/3rHL+BmaZBt8H+ZFZsNT9KST8utiZw3UVhEA62qM6MaC48ThFHjK71HyVK1CfBpy6f7CNQE2GGdD/2T7l7yx/iW/lQhZAA1EgXOOkWyDWLkq8Yf6lyAK7DkQbPNsKzjNkpC8yL45aQmQmAdf832XeVZTS5FzlIjFEiM4HQQ9GtgGpeskjsJ0DzzJWF1wF1UBa/IEPaZUbuNYFcKlttdOPuGja5Y4QcaOt5qiy9i5QkPY+KScsWzzwR2p0FanWB+wAbn8vAjTTHOHP2pkaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p6QMxEqA2iGGLukTTl0VpGpIOMNiCbSxVnHUTRKm4n4=;
 b=KKZMCLO5NUP+JbSRi93Du6LAhhFEHeep6+z1cKNz4WDtGlGwK0TwQkXMHQTZVcqyZEA8RcJLPHDuZ1JdOzekTIob1f0aKhkijXMexqX1p3C1Nvvc/lmPGceN/QG8TNVuN7WcpDHqHpQdEcU7p/PRRzrVesy4ncdlfANlNub4mTg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BYAPR21MB1223.namprd21.prod.outlook.com (2603:10b6:a03:103::11)
 by SJ0PR21MB1871.namprd21.prod.outlook.com (2603:10b6:a03:299::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.6; Thu, 9 Jun
 2022 21:57:43 +0000
Received: from BYAPR21MB1223.namprd21.prod.outlook.com
 ([fe80::7ceb:34aa:b695:d8ac]) by BYAPR21MB1223.namprd21.prod.outlook.com
 ([fe80::7ceb:34aa:b695:d8ac%5]) with mapi id 15.20.5353.001; Thu, 9 Jun 2022
 21:57:43 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, decui@microsoft.com, kys@microsoft.com,
        sthemmin@microsoft.com, paulros@microsoft.com,
        shacharr@microsoft.com, olaf@aepfle.de, vkuznets@redhat.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: [PATCH net-next,0/2] net: mana: Add PF and XDP_REDIRECT support
Date:   Thu,  9 Jun 2022 14:57:06 -0700
Message-Id: <1654811828-25339-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MWHPR19CA0060.namprd19.prod.outlook.com
 (2603:10b6:300:94::22) To BYAPR21MB1223.namprd21.prod.outlook.com
 (2603:10b6:a03:103::11)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a19de5e5-a13b-45e6-c07f-08da4a63142a
X-MS-TrafficTypeDiagnostic: SJ0PR21MB1871:EE_
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <SJ0PR21MB187163DEF38EF3B7D96CA9CBACA79@SJ0PR21MB1871.namprd21.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lOofB1CtlUB34ZaLrE7IW5g3eSfJQBS7xYu5z9yqm+QpXXGl2qaTA4PEL1Ox+OriHNAbgXuV4S0YzSnDDf5olOc8e0Ohft7PmUPExgIc/E7DcfUduQDVN3MTV2ISrpTnYQy2RpCw9knacsHjPjRvPXa1Rs0ZeRF0kSZ7c2gKlKrG/Tg03OZvcQrEpInV/bjcGQg9j4fBEcMnO+KUXekvYNfmMrpTGzzVsNuAWN5WSneWJSJQoPjkiEM1+xwdGgzPhi07Ziq7IwFvqV9XHYCfY+U1JkToFm9VHGMaoYImRoeeh0lBnF8PDXYW939e5nS174QAi8UXwSE4Sc0VDG8BAcd29j2Fz+Y4tUDJnnh5gb/Cqfkb+bfX+LJkWlrZAbEKH5gqGtyh/5AzycBXA+p4MuH8tTKvWKu0I/IymWpIkyOEetrqYUIBICEFwpcNXWYAQtg7MFmok2CPghu0h2YZ4h/dBjSdRbRV39KFpTsUKdDpMad6OInvjR3NOQL0jYkS6SGVf+hletQdN3IUVsMwuBh/dh7vDp4rnWAW8XTIH1kztrdNeVMDCFsyOiweaHafNB9TiR0JHgKDXVmYBr686QkZf1KZpguzSGB+P3Es7EkxRtpWEA5Z+m4KVBK/ppAsVBqU56oRLBmLLMWkO3c4ZhOj1mCuXw3E/lsyd1ML0DD+TWl9jrZM3NguwNS5wcOeYVIMlWZB6yrbXlio9eA/wj3G3DmygM8nCqVvcICu8BAkR3rVub58gWduRgCVxmGk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1223.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(83380400001)(10290500003)(36756003)(4326008)(38350700002)(6666004)(2906002)(38100700002)(4744005)(5660300002)(66556008)(66946007)(66476007)(8676002)(186003)(316002)(2616005)(6486002)(7846003)(6506007)(52116002)(82960400001)(6512007)(8936002)(82950400001)(26005)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2Zu8Um+5s8fHuV1e5c8VTl5eQNHyBR+xwhdFZBKt+Nh8LDfYPiss8GWd25mN?=
 =?us-ascii?Q?2T6ToJQlCVYOIF5lJSh49reDNV+R2czRohui9EPuDLSqWCBBfUA4lll/asjq?=
 =?us-ascii?Q?YIxtcoz6zQprIS2tXfTkiMkK84wZLv3RzookHwO5IVanyL6EibirGdDQLhNE?=
 =?us-ascii?Q?HrFZDLdC0u5CaRX1eYL+JcNGwBu9wF9jLUh3FdO3rQRyFArs6oW5e7ds1XtU?=
 =?us-ascii?Q?uf7JISHxZGJex4W4w7e5XVJCUcOTQ6A2yy0oZ3hHBOyaaMKPdi7BdJvQFyDO?=
 =?us-ascii?Q?V0ON2NJifWxTm3SowS5o+as9nacsPAzgwlhq5Gqg1sgBsLfZxhqqj9ZyLP1D?=
 =?us-ascii?Q?n+Y0TKqboKgb0I/495zMSrJYrqkbghLnDlE8zjCDGXd5LC/6WBnVYnp7qRml?=
 =?us-ascii?Q?DZlyiCDTTAaMrsdU+wv8Ru/945+pItz6UGzZFho6bUNiX3LCJlhtrk+bNy48?=
 =?us-ascii?Q?ASkzEf75lwwm9E8MXFq+2DHX7Tbm/WEvQnNozxX5bU7/SAfpEVi/PAupFcQw?=
 =?us-ascii?Q?u2NFUZASzgZLU475NlH70I6pnsZ6n6n5iOfKReM78KDmRK9/Jt9zZr5HRFMS?=
 =?us-ascii?Q?sLL8eH//K7Vtlg8CREmxBUfIonLmZCaph01oa0xt5sgxqZwUnHoICybR2SpS?=
 =?us-ascii?Q?ZJapOJR+KjTWWQGKHyVLaQVtuEjAANrGnu/3dLtiSAPGNJNNwwn93qb/sjKh?=
 =?us-ascii?Q?hexa+Nj/HEalqLcNA8Ja2+rVTcUBf2ubzlYnQlu3zJSUlS1cSZUGwztu5vDZ?=
 =?us-ascii?Q?imHPd8BJibdCgCdlGW+qsXOtvxCBAwobkg/pXZlrgrBKb2ZBEYZ6irYExXbk?=
 =?us-ascii?Q?jDU+Y6TS/UEEv99ZKGgTu2mESlcgYYGfjl76jBmOP54xobBmSDxiwbDNr11P?=
 =?us-ascii?Q?EnCzAcQWryPPYUV1IIjxIrK0C1nDuzU+Gssax4ERrQuBITgNN4Z1pXevp0Ng?=
 =?us-ascii?Q?m9BwEr2dSQdxt8kz7q/968MRG/UbAw/TovPnjrhxmOd5YyJY6KD61f860ihJ?=
 =?us-ascii?Q?bo6mzXKrlE088p27rRaaMLvM+Gp8ZS1mjjTmOQhlNkZb6iEpHNWxvMsoQXYU?=
 =?us-ascii?Q?blDr0Eq7i7cpRoOv9OlnSZCLR9qx49hpTV4gF+6dtCVA83PmCFyY6RyYd/yD?=
 =?us-ascii?Q?T0AOOKRBl19ub8nYhq2NTZH2wxuGK8iE00+ukOouaKw0yfUxPaNNeb+357uZ?=
 =?us-ascii?Q?JFwG4IZmJu95HP73J4OoezLbXdxmSbKATezDMXIlWJpQEdj1iP0SY+4fCdoc?=
 =?us-ascii?Q?onV60O3FOE2NlC6iKT/ERvpRmcZMuJkptNMptn1nm+DENLjvzHwltyARwpCA?=
 =?us-ascii?Q?cltAlG/vysKP3vhTd2FVeCpUYK1zUYjEAzrqDMj+VA8fghIHhdg811/ElD/E?=
 =?us-ascii?Q?QgJTZtbJstsxQq/8tgP9ubEB6Vkz5h4RKAUXHD/wguC1xfP12l+R2M37AP9j?=
 =?us-ascii?Q?iBQN6eJIBY/n8bXw66OKs8VvChzOrzXWwIrJArXYW2oK+a4pE+EwHlLc9xk9?=
 =?us-ascii?Q?uM60Wus4SHxcLfVLD+90Uz/ZOS5yNYSLT8l4jXbdUt8amoeUWAP7okQ7KpsB?=
 =?us-ascii?Q?gj2kgBE3nXRpeuSdwy4UBbfrE0fawnI+EpUXtED6AmCYAhQfqxSGXvWNUw7Z?=
 =?us-ascii?Q?/E0p6ChlXu+16bzjzalt30sygMjOetVctWA+TRYe+r+34qjLv3ui88607aMK?=
 =?us-ascii?Q?8CiZN+St8J9yQiyup0t4pVSYPHGJbTP6A2IfPsnZ6fGgj6MdNUuXC3rdnaOs?=
 =?us-ascii?Q?W9abp9AECQ=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a19de5e5-a13b-45e6-c07f-08da4a63142a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1223.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2022 21:57:43.0972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7MklPaEdA8SY+CrBUiMzHTnRo5wCyH2knzq41m5dX+8gVW6qBcQFaFZvBXtO4cjEVsoBp/Y27DY9R4JN43f2aA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR21MB1871
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch set adds PF and XDP_REDIRECT support.

Dexuan Cui (1):
  net: mana: Add the Linux MANA PF driver

Haiyang Zhang (1):
  net: mana: Add support of XDP_REDIRECT action

 drivers/net/ethernet/microsoft/mana/gdma.h    |  10 ++
 .../net/ethernet/microsoft/mana/gdma_main.c   |  39 ++++-
 .../net/ethernet/microsoft/mana/hw_channel.c  |  18 ++-
 .../net/ethernet/microsoft/mana/hw_channel.h  |   5 +
 drivers/net/ethernet/microsoft/mana/mana.h    |  70 +++++++++
 .../net/ethernet/microsoft/mana/mana_bpf.c    |  64 ++++++++
 drivers/net/ethernet/microsoft/mana/mana_en.c | 148 +++++++++++++++++-
 .../ethernet/microsoft/mana/mana_ethtool.c    |  12 +-
 8 files changed, 360 insertions(+), 6 deletions(-)

-- 
2.25.1

