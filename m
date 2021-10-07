Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19265426006
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 00:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233220AbhJGWsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 18:48:37 -0400
Received: from mail-bn8nam12on2104.outbound.protection.outlook.com ([40.107.237.104]:13057
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229778AbhJGWsg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 18:48:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V83g6CWJ5kMNgjrZvDq/i6bq9oenniaKYGEafxFQPudeOeBbFjmnmdI59jh5vlBBcNijVT0mgY15CiSih9KJkVE95Hvz5g+1NsNO5puCwLCWoVSXa5yAPY/8YcX4k1+modj0unqEDYYeywWULREXA1lw9thhdrErQOL1za9ol8/p7XLOg1AeY4Jdlazzi3KuxYjDuRYr69pIuFSuYGBYDoRUR30AAtLb9HhDO9mCiQI1DVUFBqc8XRvNRZU3RUvUxAi1ZQyBU7CbmmUaaC/FKrF8L7J/Jk+38PYesoox2BHn/i+7rMPF8hxlr35RACNgG7jQUnr1mpSlMNrbIdiKeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qdhhv2v0QWkxbFdGGhFQgSGkJA/ZlZDhBRrXOK8z6f4=;
 b=eJeYSE2UGro5OJqt3ZclhHngQQBIHGr8V/l24JoQx+UE6GeI3OTzaIbJULRte3K6TzGQ3yJxR/4y1uaZRKsIY7Fdt8eo052+BABj0wO7SjozA58uciQw2sjaUUxZkmVn7JqaEFdbz0339ackAhBP+Zczt5OU79A38xphkKyOIJzvIy1wgwybe+Pon3PsqFWvFn3CL3GPldJ5vTM+NjzuE25PZ5LwKQQiJu5UCr4zjZjca1e6q46zXCmuRecHq6meIHaZJ3aESCjCORrkJhRicmCrMNQjLhaB4s5OUuesbSX1j7p3/yA2Kpx2HOD97KnbSmp/F+3D4ZJ0XiihvQvpEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qdhhv2v0QWkxbFdGGhFQgSGkJA/ZlZDhBRrXOK8z6f4=;
 b=BwB8/fLSlQa70rKOxK11ZKweGtV8PEAEQfhWIi+LAWmyIT3ZMdqedK8WenjJihjafbdFhd5voZUQQcTe6+KTpuQZH5B0imhLlp2U9uDzt59esJvCS/5P0+pUIplc//ML9pYLmfir/ZyuClLjEXoBi97Vv0mlbIl4FT+fFKOsZfw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1340.namprd21.prod.outlook.com (2603:10b6:5:175::19)
 by DM5PR2101MB0805.namprd21.prod.outlook.com (2603:10b6:4:76::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.2; Thu, 7 Oct
 2021 22:46:39 +0000
Received: from DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::10b6:1733:cf27:f6aa]) by DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::10b6:1733:cf27:f6aa%6]) with mapi id 15.20.4608.005; Thu, 7 Oct 2021
 22:46:39 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        paulros@microsoft.com, shacharr@microsoft.com, olaf@aepfle.de,
        vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net: mana: Fix error handling in mana_create_rxq()
Date:   Thu,  7 Oct 2021 15:45:33 -0700
Message-Id: <1633646733-32720-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MWHPR17CA0070.namprd17.prod.outlook.com
 (2603:10b6:300:93::32) To DM6PR21MB1340.namprd21.prod.outlook.com
 (2603:10b6:5:175::19)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MWHPR17CA0070.namprd17.prod.outlook.com (2603:10b6:300:93::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Thu, 7 Oct 2021 22:46:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f65879e-96ca-49a5-dada-08d989e45297
X-MS-TrafficTypeDiagnostic: DM5PR2101MB0805:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR2101MB080523127D4065BD07EBD966ACB19@DM5PR2101MB0805.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1060;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IdHhTnMyQDN+0XWRwSsEsAtQyaqMdZ9/ghu2SDdlFWzKli0eKIKc0BuayNu+OhsP0A4O5kegQuGlI9dJzu4RjmZYHi8tm0QYErNDj4s2ycMavidAgAM/FVOeU9chY/hWefckcMFTlV4mUOLMLXJHBMnxsSHZMlSigZlor4DEldPR4pNWn/4nzl18n3isLMikDnXHdVv1r30I1PZY5iF5l3D2ZB19qoMyF0meja+EHfMqj3HmM3yP24McTqjNbll7huPk+XUQxqlBeWFM3opwxr4t0ePuaJldCU3B5Xz/1Ti1VsItm3hsCmmWHVd8HboSrGaIdFTu92035ngdOEDsRozqIdleWOZ5yGKB+lzz9skcqWhowHsFUYfoEOpTUR+T4MsqcI5D1f2KPpluWA09Vle+f5cRTI3OsETAd1qFRAxbNAXpJxtevgFEMcwZtiM16h5yo2+E4GRPMEpe/D9Yb/I8kFPdPc7RgLt5VUyojiA6wxkEO/8g0MCLtzhpmaDj1x1FctGermHP0OpC561hgEB/Z/XA+mTGVd7JqJG8fOjH+Zto2tBQuvgKFNBbP01ks5bPrWnpDxM6S8WLIpJ5E9s4+yO3IldozNL+gCBOF2bxaIMh05o1ZteICvaLN7pcEHJSgEGGB37E6YeD4FlYSHZjKaPB/YgWBHLVFfnjvn5rGCNcS1mKFMkvOYWzU1NZNe3wGzQCf3YT28bEfFOzFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1340.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(66476007)(2906002)(66946007)(10290500003)(5660300002)(316002)(83380400001)(6512007)(6666004)(4744005)(508600001)(52116002)(38350700002)(38100700002)(82950400001)(82960400001)(2616005)(4326008)(956004)(8936002)(6486002)(6506007)(26005)(36756003)(8676002)(186003)(7846003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?14VO/xdXOq0dBmnDQ1hm1/Njmq2yU/z+OKNfsV10s3TPRwZ6SbOodN2Zjyni?=
 =?us-ascii?Q?QwL3hMgR8WQTuTVjSm9NidQpNbRUFy1xfGIsDXv/qFCmZh/jqX4aZ8hJ361J?=
 =?us-ascii?Q?FgCgXC53oNxkNODNdZF0zpCpQhh+UY/+rX6jhWjBZqA12PsutT+uNdZho6Ya?=
 =?us-ascii?Q?Y1VpKjLSWmsw2Ni0C5cI7GlpLsAxCKbboE5ZrmYEuVAH+TCfGAGmZfuAp8wl?=
 =?us-ascii?Q?FHQXiSD1o+k3AaWS/QMfZuVGQQo0WDV9dZXiVJ6VSv4OxM0rFN45HFvZRLWL?=
 =?us-ascii?Q?27z3RuoEp5EfnPhrpqGOIVF400/ROx7BeJMuyHLf2nukoDLRrSZsyHY5J2tf?=
 =?us-ascii?Q?nmkjXPAU6LjML9YDJ2r5+icZBK/FPb9wa2EhNbuSOTJu549Bhx/OAx96oT4i?=
 =?us-ascii?Q?3oS3J/6KcrsAELVvqh0fPLwRqp29uSh+t6Jv3IZTXUsiwYH8IOzN05tvsZwO?=
 =?us-ascii?Q?qtd7yHtT+bjA6WHxWNANBV1xD//ldzPYWLDYcroH+nCI9lKGT56AuWdr4iW2?=
 =?us-ascii?Q?AQYf12W53KhZXMobqstLQk0qv+mxRTOzgVZEfiHCXFd9kaFAAw9m6/8SnZ5P?=
 =?us-ascii?Q?GpJOIT+Sx5S+fXt2awjkhSymTvlZwwiFNsgLyK7CARCXofjKG0Bfigit27Ru?=
 =?us-ascii?Q?DIdbCz15IsmEFf48Y6wKfqTXH+EGBI5s0u2Hc9ZdUS/w5LKS2IFBuCgY7kPJ?=
 =?us-ascii?Q?EvNixFeLieDn1mr1sJ+WicGfwvvopVjFBU06LLWF1VqeqSgvc2uJkO3R1RwL?=
 =?us-ascii?Q?LorhJuRLCvoKZF4NIj4W1gSrszjlllCBKzqJ6kVyfz2sKm+hIWdDpiA7advK?=
 =?us-ascii?Q?TDQElbWEORO9odNEALFLaZ6guUdNlxETzhi4VbRJpeUiIWESPRYpIythKkgF?=
 =?us-ascii?Q?mKni/qgw/jfP1FkZ4oqODGNAcKbBRYEPyPxcLiw48FAkYq6/EVbVHixwdJyI?=
 =?us-ascii?Q?jmov30/mNC+BCytFWSMRlcw9lNloecLbVSj0Xna3jgOnEMSoaP9o69vawlpW?=
 =?us-ascii?Q?Zl1M89/5iHXkC0cUnCp4ZWE1R5dzCOCg6ZdWf/klACO+gFyY2J/KdkQcUcax?=
 =?us-ascii?Q?9YoxythnHatGFSohX8kKqNlvIsnkFzEUookdeo/is7PTLDYFv3/8NuXPplEq?=
 =?us-ascii?Q?OWYFdrWzl4yfHDUZP1omKHgMrpSi+HxgFYPmPQMremyKoFVNXP3Hx1+DcIo7?=
 =?us-ascii?Q?w9KHdOthTqvfAHvtMNd0hBqzV4T80nchsYJTVkA1gkm1ubtGOAgRA46nq+PG?=
 =?us-ascii?Q?zX0ydj700dGCMPFl3AxS5r/lG7D6uQv241HIUwufv7Kx8SEbMnT8umzTsU6k?=
 =?us-ascii?Q?uTF+tD+GzS5oN2lgfBFCCRv7?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f65879e-96ca-49a5-dada-08d989e45297
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1340.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2021 22:46:38.9380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JX0nUG1X6XrXe9wvy5gHDPdHSzJEYsWi0yXIk/gML23skdgOXA3XwdWUArWngXg0srhHVTnL78x7Z9daNdiLCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB0805
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix error handling in mana_create_rxq() when
cq->gdma_id >= gc->max_num_cqs.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 9a871192ca96..d65697c239c8 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1477,8 +1477,10 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 	if (err)
 		goto out;
 
-	if (cq->gdma_id >= gc->max_num_cqs)
+	if (WARN_ON(cq->gdma_id >= gc->max_num_cqs)) {
+		err = -EINVAL;
 		goto out;
+	}
 
 	gc->cq_table[cq->gdma_id] = cq->gdma_cq;
 
-- 
2.25.1

