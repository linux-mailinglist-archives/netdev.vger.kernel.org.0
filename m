Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC2C9604930
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 16:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233563AbiJSO11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 10:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233519AbiJSO06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 10:26:58 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on20714.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8b::714])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E0919DD9C
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 07:11:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z9M8rs7R89+D82D3HZd6ArgSDquSfbVurIN0wVnanf1jkF+3E79b8s1wC/a8BQg3zaHiAQv/JkO3ELT5eMTBCbSPEuCKg2Iog4ng6YRT7di9ic8lwEzSI0VJrsTA77YUgz993EBdiYAy7dUiH9I2TOK7T+q0EVgbW1aTa63fCyabzKWAeNSE9Dc5RP06ONnf6RDJoR+wUgl2bCFUkcxDet8HCNeRs7j0xeOBAOZDr+3Ta3NA2U8/9KNtwCRnYNPaW97ylaxAIVaYcAeBS6XdXu92qQJocUjOedOVp6ZQKJ+/cucGBhnVQchiPpa+5zTiTV9I5jevN9hf78dmMP7i0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OPgrCWy1q7HucHuJ2Z6IoxoYadQVFdFA4pZVBWPxGv4=;
 b=Ne67i/vVyOMTCduG1zjT0FtTyrRsSdxXjKwQVhXKF9aoYXR3rophj9izQ3fyHuw0CZkhovZvIm4qyV9mbKs3uQY45uCHPhTmzkbh3JIHwr+HpKXen1+8Umq6m7DMVddGadi5O839UH1qEczIiCwpBgxJdw9aFkGcqXMc9o189J8Hz2YHcpCoEpMK+dyTuZVPApDnlphILbXOylX0Et4LE7gZ/UOBgensOtmR1v6XA+lsYa+ty7A5cAIJcSAWC7lpaQA0nnIOcl8U7NyEHWuqMZgU6i3phi4uDZQI9iw+rGIGird7fmjo53aQ1MwT1mteebgH5PVwZYYopYFdxeD/9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OPgrCWy1q7HucHuJ2Z6IoxoYadQVFdFA4pZVBWPxGv4=;
 b=qj1EmiOdaP7oxEjIHMi+KTysYEPepm11OwSfIeX63GrW3mmidCzKvPIZ0FO5uDFK4HpgCLg4XGvTMx9zuKyZzMa68WN1oDQJ1KwN4M2FkI7KHQH1Ypnrk7Jc8OEDE+GaNejA0gGmejTONkdD15WXMO2aCqmDkw2gqrjYBgZxB08=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL0PR13MB4404.namprd13.prod.outlook.com (2603:10b6:208:1c9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.20; Wed, 19 Oct
 2022 14:10:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3a35:112e:34eb:6161]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3a35:112e:34eb:6161%6]) with mapi id 15.20.5746.016; Wed, 19 Oct 2022
 14:10:26 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Peng Zhang <peng.zhang@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: [PATCH net-next 3/3] nfp: devlink: add the devlink parameter "max_vf_queue" support
Date:   Wed, 19 Oct 2022 16:09:43 +0200
Message-Id: <20221019140943.18851-4-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221019140943.18851-1-simon.horman@corigine.com>
References: <20221019140943.18851-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P250CA0008.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5df::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL0PR13MB4404:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bddb674-f16b-405f-21b7-08dab1dbabb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kyELyFwIjQJ6fURWbZ3T2rI+DgrDKv5uYrqTZ7ErOxFL/gawop20F0hlhcq/5zjsdmWePhOzKQ4TCkWkYUK4AWO0+SpLf2Q0kELLIis9A6qro2ubPG0G11iQ9c+XmAFdbdMjCE2laDylxFbgjPnfIB/ULXrRP2UE1GeDbNPS7CJp1a6uCA+mp81sW980p98MCvjgshPctJ6yHi9F9R0V9oQc05u+j2ASTy5NdAju/RErQMQrR/CCJTRxN91dn9kE0fh8nrICGMORJtzVvTzQiUB20tf0IE02Nr2tiaE4rVg+r2l7kySdc1mBAMQDVit5uBajpD2A73pwdAp2qvj11IexyCPTVADm4CDQK1OuIFk+oLucahEFpjkUh8PRW45/eJh325hndkNSjA5YHOaN/WWq2RRzg1L6AogN9MjgLQjkZ55q4ndn1qhrr89qiJVWP5TYsNSssLbBDPLcfuOGHhxY2lkkE5Ckejsqa9Gc9di/nS8LHuhhrhFYVd5BWqcvtCgs3YzZCdlFZunVzivmEI/SEJ+icx79F0Iqd8oeGmRKVLLe+7iANHbyVYiKNlEZJuPtlfw59KmBGdolvSihE8Zs+AthRptpQdyqWp5OL6DgOP9yKI+CSNNHl9zs6KPLTWcVNqd0DosERN9Navzsow6AjF/xgC3QKAtLHjYw3ydJ49tBSNES4auMa7fMXWtxub5F/TfjvOWoN8NCxH/kW7caS45M8ae3WbYE6GFsEGyAi+O6wzIDRCXi/PVIZL/a
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39830400003)(366004)(346002)(376002)(396003)(451199015)(1076003)(4326008)(66556008)(41300700001)(66476007)(7416002)(5660300002)(6506007)(2906002)(8936002)(52116002)(2616005)(6512007)(6666004)(107886003)(186003)(44832011)(86362001)(36756003)(8676002)(66946007)(6486002)(478600001)(110136005)(38100700002)(83380400001)(54906003)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xm/EGz6/gcP5h4HUrrvB2swAxc/wsH5kRzIIpMa2PuKz7KZyTVAXtOrKp3y4?=
 =?us-ascii?Q?TWEiAZj/Kv/F8SBFDJXWc7uqBxmk6gpasNQ5qHqWAgPU78zgNwJp/Dl4o3Gs?=
 =?us-ascii?Q?GgyeoJhuxEzUXi8/M25wlQejEUHAgMtAj81903QEYbxmEqGIebxW25RB+d5g?=
 =?us-ascii?Q?XchU+ApDi9O8GFDS4NiPuFSx7T2JpnVU51YjvZgFoREBGBFYchzI2cacGbYw?=
 =?us-ascii?Q?jILes43wueUYCc9eviL4OlTNSkZkWde4eD34YhqBMxe6iwklUmA9ulYS/U4t?=
 =?us-ascii?Q?hXRHVjelUEIXvbaRKbora7cBp/0j87taE2unX8BvrzYlPRm7NlfavWRguCI3?=
 =?us-ascii?Q?E0qOMt29dWdjHRB10SsY4BQZ/+4q6er2jVYqgXmxz6kdS+fiQazqihXnIR6b?=
 =?us-ascii?Q?QeYANBphb70NSa0S5P56+8ZsTvMA5yW2QZObuv5ppqNDcrhfwTJHL3bWHQLy?=
 =?us-ascii?Q?lLNhOJXc/PB4J8yl3nGrd1U8ofzU5dxCpaabMVA+/5H7X+nsn82lCZwo72y3?=
 =?us-ascii?Q?z5P1u4vaz+g97ghn2zE4bPewg4q8/Oogt4GMSuMPxLWLkL2BJO2ctQK9Rn0q?=
 =?us-ascii?Q?af+mf7mIJDfuE5OIqMoaKnftH+EIM9FtXnoTrGV1K7QNgdQR45dkvTp6x6La?=
 =?us-ascii?Q?Uu1ppXdllywug3KIvj0P2NdB2BBCHxjALr4jNt6uxRqzciyGeDwa4rrSDw3l?=
 =?us-ascii?Q?gwwwNvq2YMb3BR2uvtC50IFeNbR+CcPhiP3GJqKirvt/iAjFJvM8vaqLxLLp?=
 =?us-ascii?Q?kxscTVgN8Ne1Q5lO3bH6VyHGgO61AR3O6ShRLq2pl4xtOXdpC3rxRdDLgzQb?=
 =?us-ascii?Q?NUkEYSGfKnXfnvDqytNDf0WdNvqLwnoUsm0+z4qVDbgtkMdB7u3NmYHY6k6p?=
 =?us-ascii?Q?qY4V3V3n10IzvwDM+dxqSkZVVlfTZ0MYE9O3lZR4KtzOmjgwscRKwwlQPHVp?=
 =?us-ascii?Q?5ziU3ovc70rxI+vuk2hrPdwizU58j6ryc33ANhR9+wWNTR8w0+FWmlivn4+T?=
 =?us-ascii?Q?4Pb0MChUvbugW4S0SyY27ma4/VCHt3ueJ0v58BCQUsogOfUDWZaCYTXJhZJ4?=
 =?us-ascii?Q?NeEjowKM670H/yS0oeNWIi6ilSecIhGlakTMGuVgS6XAmwPZ5CrHcoTzzSLd?=
 =?us-ascii?Q?9MayO/OyzJ8e7T6N1F1n4yXdOQyPK6u56b0ih8cKuQ40/hGijU9eTfLwOySQ?=
 =?us-ascii?Q?g/POQpI3fXh6CpXImFlmSsgxGQGyZVmXY4IjxmVpNGza4/GGdv+K654/7Mdk?=
 =?us-ascii?Q?FOJRaQHey/rDt0izzGfaTy/qLSzrPl6Xp2dVVsuSga+oTn9vXRLGyMPlYvw5?=
 =?us-ascii?Q?LeicJn+ti8ms8VecLnIt/mSi8kgCIj/CEbRqM9Pjh6t4dQwu6JFB9C9iN0xB?=
 =?us-ascii?Q?aRccpiJ/0hycpPZJSMKNE6mxjKnv4LcF5hmlHe2uWbjN+HzIGkhKnJu1kbfk?=
 =?us-ascii?Q?n8/mD/dA0idzzt4H8qGLy+v+ldsRcKVjYUHNOMueP+2NBJR2moUpBGLmrh3B?=
 =?us-ascii?Q?uGFsbozXgmK0GiqDwcjD5g4uCtj7qGoi910/VJCx5/YKVaybw2zPNKmtmT4+?=
 =?us-ascii?Q?gjZiXQ8RkbiOkTVXtJV3qMwxHRq8hcGKFFeJpXwFC0AES9fN1iP1+sRUzzLZ?=
 =?us-ascii?Q?/WuabyBURc/ZQEzBTbStqT8VHd8HT3ByN4T8ZQt1w5rYBXun4d7ei6cMeKLL?=
 =?us-ascii?Q?SQbYlg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bddb674-f16b-405f-21b7-08dab1dbabb2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 14:10:26.4283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BGoIdWLKqvZFQog9lUeGOGuwqMzRAdbIDKdooouwboN1WdRDfHd62kSYWsgbawL6yTx4c29r+qdrmEdYm9Pf54fzn+YNQsWUF6vxNusAOtw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR13MB4404
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Zhang <peng.zhang@corigine.com>

VF max-queue-number is the MAX num of queues which the VF has.

Currently, different users need that the number of VF max-queue-number
is different. Configuring the VF max-queue-number dynamically can
better match users. Hence, it is necessary to allow user to configure
the number of the VF max-queue-number.

The string format is V-W-X-Y-Z, the V represents generating
V VFs that have 16 queues, the W represents generating W VFs that
have 8 queues, and so on, the z represents  generating Z VF that
has 1 queues. As far, it supports the VF max-queue-number is 16.

For example, to configure
* 1x VF with 16 queue
* 1x VF with 8 queues
* 2x VF with 4 queues
* 2x VF with 2 queues
* 0x VF with 1 queue, execute:

$ devlink dev param set pci/0000:01:00.0 \
		   name max_vf_queue value "1-1-2-2-0" cmode runtime

The nfp also support the variable-length argument, Y-Z, X-Y-Z, W-X-Y-Z
and Z, it also is right format and represents that the VFs which aren't
configured are all zero.

For example, execute:
$ devlink dev param set pci/0000:01:00.0 \
                   name max_vf_queue value "1-1" cmode runtime

It represent configure the queue is as follows:
* 0x VF with 16 queue
* 0x VF with 8 queues
* 0x VF with 4 queues
* 1x VF with 2 queues
* 1x VF with 1 queue

When created VF number is bigger than that is configured by this parameter,
the extra VFs' max-queue-number is 1.

If the config doesn't be set, the nfp vf max-queue-number is 2^n which is
round_down the average of the total queue / VF nums. If setting the config
is "0-0-0-0-0", it also is as the default way to generate VF.

Signed-off-by: Peng Zhang <peng.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 Documentation/networking/devlink/nfp.rst      |   2 +
 .../ethernet/netronome/nfp/devlink_param.c    | 114 ++++++++++++++++++
 2 files changed, 116 insertions(+)

diff --git a/Documentation/networking/devlink/nfp.rst b/Documentation/networking/devlink/nfp.rst
index a1717db0dfcc..1936cee16dbe 100644
--- a/Documentation/networking/devlink/nfp.rst
+++ b/Documentation/networking/devlink/nfp.rst
@@ -18,6 +18,8 @@ Parameters
      - permanent
    * - ``reset_dev_on_drv_probe``
      - permanent
+   * - ``vf_max_queue``
+     - runtime
 
 Info versions
 =============
diff --git a/drivers/net/ethernet/netronome/nfp/devlink_param.c b/drivers/net/ethernet/netronome/nfp/devlink_param.c
index db297ee4d7ad..5856b45601f7 100644
--- a/drivers/net/ethernet/netronome/nfp/devlink_param.c
+++ b/drivers/net/ethernet/netronome/nfp/devlink_param.c
@@ -6,6 +6,7 @@
 #include "nfpcore/nfp.h"
 #include "nfpcore/nfp_nsp.h"
 #include "nfp_main.h"
+#include "nfp_net.h"
 
 /**
  * struct nfp_devlink_param_u8_arg - Devlink u8 parameter get/set arguments
@@ -191,7 +192,120 @@ nfp_devlink_param_u8_validate(struct devlink *devlink, u32 id,
 	return 0;
 }
 
+static int
+nfp_devlink_vq_config_get(struct devlink *devlink, u32 id,
+			  struct devlink_param_gset_ctx *ctx)
+{
+	struct nfp_pf *pf = devlink_priv(devlink);
+	char config[4 * NFP_NET_CFG_QUEUE_TYPE];
+	int i, len;
+
+	if (!pf)
+		return -ENODEV;
+
+	for (i = 0, len = 0; i < NFP_NET_CFG_QUEUE_TYPE; i++)
+		len += snprintf(config + len, sizeof(config), "%03d-", pf->config_vfs_queue[i]);
+	config[len - 1] = '\0';
+
+	strscpy(ctx->val.vstr, config, sizeof(ctx->val.vstr));
+
+	return 0;
+}
+
+static int
+nfp_devlink_vq_config_set(struct devlink *devlink, u32 id,
+			  struct devlink_param_gset_ctx *ctx)
+{
+	int config_vfs_queue[NFP_NET_CFG_QUEUE_TYPE];
+	char vq[__DEVLINK_PARAM_MAX_STRING_VALUE];
+	struct nfp_pf *pf = devlink_priv(devlink);
+	char *num_vf, *value;
+	u8 config = 0;
+	int i;
+
+	if (!pf)
+		return -ENODEV;
+
+	strscpy(vq, ctx->val.vstr, sizeof(vq));
+	value = vq;
+	memset(config_vfs_queue, 0, sizeof(config_vfs_queue));
+
+	num_vf = strsep(&value, "-");
+	while (num_vf) {
+		if (kstrtouint(num_vf, 10, &config_vfs_queue[config++]))
+			return -EINVAL;
+		num_vf = strsep(&value, "-");
+	}
+
+	pf->default_config_vfs_queue = true;
+	memset(pf->config_vfs_queue, 0, sizeof(pf->config_vfs_queue));
+
+	for (i = NFP_NET_CFG_QUEUE_TYPE - 1; i >= 0; i--) {
+		if (config >= 1) {
+			pf->config_vfs_queue[i] = config_vfs_queue[--config];
+			if (pf->config_vfs_queue[i] && pf->default_config_vfs_queue)
+				pf->default_config_vfs_queue = false;
+		}
+	}
+
+	return 0;
+}
+
+static int
+nfp_devlink_vq_config_validate(struct devlink *devlink, u32 id,
+			       union devlink_param_value val,
+			       struct netlink_ext_ack *extack)
+{
+	int config_vfs_queue[NFP_NET_CFG_QUEUE_TYPE];
+	char vq[__DEVLINK_PARAM_MAX_STRING_VALUE];
+	struct nfp_pf *pf = devlink_priv(devlink);
+	char *num_vf, *value;
+	u32 total_q_num = 0;
+	u32 config = 0;
+	int i;
+
+	if (!pf) {
+		NL_SET_ERR_MSG_MOD(extack, "Can't find the device.");
+		return -ENODEV;
+	}
+
+	strscpy(vq, val.vstr, sizeof(vq));
+	value = vq;
+	memset(config_vfs_queue, 0, sizeof(config_vfs_queue));
+
+	num_vf = strsep(&value, "-");
+	while (num_vf) {
+		if (kstrtouint(num_vf, 10, &config_vfs_queue[config++])) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "The input format is error, expected format: %d-%d-%d-%d-%d.");
+			return -EINVAL;
+		}
+
+		if (config > NFP_NET_CFG_QUEUE_TYPE) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "The config queue type is more than the max_cfg_queue_type.");
+			return -EINVAL;
+		}
+		num_vf = strsep(&value, "-");
+	}
+
+	for (i = NFP_NET_CFG_QUEUE_TYPE - 1; i >= 0 && config; i--)
+		total_q_num += config_vfs_queue[--config] * NFP_NET_CFG_MAX_Q(i);
+
+	if (total_q_num > pf->max_vf_queues) {
+		NL_SET_ERR_MSG_MOD(extack, "The set queue is more than the MAX queue.");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static const struct devlink_param nfp_devlink_params[] = {
+	DEVLINK_PARAM_GENERIC(MAX_VF_QUEUE,
+			      BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			      nfp_devlink_vq_config_get,
+			      nfp_devlink_vq_config_set,
+			      nfp_devlink_vq_config_validate),
 	DEVLINK_PARAM_GENERIC(FW_LOAD_POLICY,
 			      BIT(DEVLINK_PARAM_CMODE_PERMANENT),
 			      nfp_devlink_param_u8_get,
-- 
2.30.2

