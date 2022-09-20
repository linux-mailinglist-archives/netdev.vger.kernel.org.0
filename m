Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2E445BE9DD
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 17:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbiITPPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 11:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231271AbiITPPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 11:15:37 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2125.outbound.protection.outlook.com [40.107.100.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8945AC7A
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 08:15:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LpN+guizmmHrjEVooYD4EAscV6pe5i1oeOXUwgPEBFmlkQmXluXQpVb0JmsaTu8drqZkceiFHZXUPmykfZK7g6/5ieWlh/3fcD3EqEaiXy36IE9rzl/GVlQbGiPGGSL+F95kRw6cBEMInLaV6TIDQdvhlWHb3LZ3Q+XExGLNLXPce+nZZUTKdRS2wGfURCrSGgb3mOeNZb3pJ9yzN3id3A7mq2C2p8UibJi7Pkd8bdeFurqeZ/bXaIbUMHhkZXO0fJ7VvVFXeDq625YsTvl18CI1syakyS6F9v48qfZl67k43Sa8Jjmy3FgKa3rbsdDAj86ek4YU5Gvlcd3Trn7hgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OPgrCWy1q7HucHuJ2Z6IoxoYadQVFdFA4pZVBWPxGv4=;
 b=HDY0i1nHP0R1HxzN3SR0wYCJVWm+LiRHj34AsY5KfSsAFW5lctQ5Ydfba9cc/qJbmZjGHTXb9rKAyr4W8lWFIk94oK844m94hClhCmXx9SKBu3K8ga3pCXOPeF9OxjAWsWG++ysWaYScK6Tg88ou5GPtwW60TKazHMRacrg+fenB3hLSYVyP4Pt873rkVrQ+WlTAjmLEOtrzI7rm/Kn3NxSQ/aqiHOu4DStxts96LYVI+VfEIHQFE515IVEPyH/Z5uKNYdKv/WWb8LdqTWY5RcI4qvUPJ6o/q60kSY+DWb9vtGGk6yhowgF5N/C0+z6djpgQAhSIXP22q08gbOkfHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OPgrCWy1q7HucHuJ2Z6IoxoYadQVFdFA4pZVBWPxGv4=;
 b=HDX7SttU5kIgow6vApTS3T2lhXm1PQkQlKdggacuWzE1Xbp0SIeXVb863zWbLUvQmIvHH47lQVDYq+2AiNZfiRZYCINc9VcF3c9P1qJPs90UL3MHxLlBNnA8/JulV983cZ3KCVZP9GEZQNRXnIk/3pjQ7HSRw1tKPR312Od0quA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5301.namprd13.prod.outlook.com (2603:10b6:a03:3d9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Tue, 20 Sep
 2022 15:15:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54%4]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 15:15:27 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Diana Wang <na.wang@corigine.com>,
        Peng Zhang <peng.zhang@corigine.com>
Subject: [PATCH/RFC net-next 3/3] nfp: devlink: add the devlink parameter "max_vf_queue" support
Date:   Tue, 20 Sep 2022 16:14:19 +0100
Message-Id: <20220920151419.76050-4-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220920151419.76050-1-simon.horman@corigine.com>
References: <20220920151419.76050-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0064.eurprd07.prod.outlook.com
 (2603:10a6:207:4::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5301:EE_
X-MS-Office365-Filtering-Correlation-Id: 608d7989-0db8-4ecf-5bfd-08da9b1af245
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5+AD0OiSFKvS0GszI76z3Z1QSV9hg/IodrnlZ81XbXYkf+WLnuwgMTtM0Q1WJSngLRp7xGhazqzbH6L/1Y6DI+qQLqRNFQ3bT4jpBV0Bt7b6gHAJPnUA95DbJxrx1yAi87SUXOlDgIMVJBeQCthR/fEsbVfmJ7YM1ye1Jcz3xFISOi4m9oZYD8zU4WTfpAE4PBU040j3y5QruYjP0VS8PsQiwqjjebTQJtVCenGNKNxd9sgwKRfsIieG/oAb2bWhLPXxDhfbTZ15kcqQoPlePDZiYPS5FiLuDstmytpFfKWGzoWjTN6kbTcf7tKsnTRZLVnNs0PC25uwsnHHnBvAUvoDvfLbd7Q2ZSW8wOpsB1ZZ5SJnw6L99RKqK2xs6+C9WkRXl7lSaW5e5Lf7a3RKIradmmx3kal8zh9Du4k+alMZr93SexM+rGrbXrjCs+2gVHaUyj7xtBkHTN2TnZzG6CXhGmEe+V/LzhKw3SVaWO2ue8LF8BKOXECCq2v5eaewPM3eqHTONW10ZPkG0SWor0CCEn76iHTk+zLFI/9fQdHxlkiFXE+PlFS6NGPj5YgvHxS2MStZC7zDiiHt0oEsLjrpdC9/y1f9OLIKkbqNw/8V0kOxJkpwIS3S393rASNUzoOvciY7UPl8kAxBzg3XduoalAmHLsWOx4Fk8nxaNkLc7fVtpS0cz6humH9Ugx8L92B8KrWEuE9YmnKgm0Uo/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(39840400004)(346002)(136003)(376002)(451199015)(6486002)(478600001)(186003)(1076003)(2616005)(6506007)(6512007)(6666004)(107886003)(52116002)(2906002)(44832011)(8936002)(36756003)(5660300002)(110136005)(54906003)(316002)(4326008)(8676002)(41300700001)(86362001)(66476007)(66556008)(66946007)(83380400001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qo6YwiCQcCfRy+RFSzvVQKoqjS1GJKBHpZapwMZKRhtFsfqeXW7rSWfBkI8B?=
 =?us-ascii?Q?kyArbn2M6blEw0GjNug/r2yYtA8NEwdVfIiOYX9hvRZsmNbkBNVWurIPMjQS?=
 =?us-ascii?Q?aOf1LUNZ1qA1CIrW+tukovXn06X44V0v5RAXHogX821Rg/etb5Q9pSpwAjEs?=
 =?us-ascii?Q?H8YuRZZxmxE30u89umGI+smdk6CXc9E2WvYWaycKj6vC4cu+0UjgWgP8eK6x?=
 =?us-ascii?Q?VrT3lrYoCy+HrO7hkOgjDMwzVyL+/zmvgvJ+YnAf85TgbHlvE75fDzUG2Ihu?=
 =?us-ascii?Q?XMje9WfFxvp3kFjRnV49UkQHGaoDfBY9hQyCHPMkOyInZnUoIaTfW6Duqktp?=
 =?us-ascii?Q?mnbZEx8vwtjsemzj1JHwiOzoutqJhwBOw5UNxyxF1Dm0I6KtDjU5JS3SgXf3?=
 =?us-ascii?Q?sZ+VUAehfWyEofaYMXD2A1w3T5a+sh8oFjzWh/pdBcR7mL2NUr0PWM4mDVlV?=
 =?us-ascii?Q?mjaL3z7/9cRLZjNJGMPoxEUkCEpHVeVok9R+VHpU47y4XEMysv3cL4EtcGT2?=
 =?us-ascii?Q?RPULA5hXmE2jQXyDnOgZEVoaUXkur3NDq1ASCCkKF1cRaRhl2OueIWMY/gEY?=
 =?us-ascii?Q?XkSN9MrjY9rLVvKDETZjYrfVPduuXxUI2/phGuRpc7JAc6gVPRB3MoBOUeYR?=
 =?us-ascii?Q?oJpNlgglEFi4CiJpZsgSRbxWA2jl47k6UqVYRpB47MuCiuHERKUSswFtgNIe?=
 =?us-ascii?Q?+XHQjn3XKqLg7pv5Pxf39GdfO/P1NHX6hkymubKmEqV0MX+26Lq+jXzhL7YT?=
 =?us-ascii?Q?SJ9QyzHfS91KJee6/4R5rWKCY55H2P1gTHnJBqPiceYLH+aE0zkA+KixUFXO?=
 =?us-ascii?Q?libeWY14/EGxH5+fzs5zpJAZOivTHBeZ0O/Sjipc4zEC+IthPV6ZhhXTgZ5l?=
 =?us-ascii?Q?qG4U1+Xr4cuikEOgsvMZ+s499jQfak4ZNztTTIXSUWjUGdysRDsBjSv5zec+?=
 =?us-ascii?Q?XyDnoDrOzjf1NIEiYRDq0RJeebwdk2pvPGaP6lrVBxRv/e4iCW29h0LVsZWn?=
 =?us-ascii?Q?pwmLV3Bz2fVjT242bQIp8tV0ht8hGcs6z7n0dP7J5eZeEFH6JmG0JahmS8nz?=
 =?us-ascii?Q?ef2sWp7GZ7I7Vz5necNxixprqN3pO3jZccHwvCo7n8k2aOeOBh38RPoPzhTF?=
 =?us-ascii?Q?OH1CucZ7oxJH2N6e7Qz/tRZrixlqrJi5BPsXcS6xCXTgWPASN5gfyMjpWMvR?=
 =?us-ascii?Q?lQQlSxu/HbYBAkt6ZbepHPfg808oV9vnfuTAKc3eCFWg8/KteD0xETMo2yId?=
 =?us-ascii?Q?gq/Ycl3G0LD0oGS0Sk7m2SnEhMo3L/MdWjVr4B7zntiAJxCzf0N3lRfXeOwv?=
 =?us-ascii?Q?fNeLpQ0sF28tHfSOJb3qge8dn6oEMRkJ+9sfO+BUU9LcJ7Ece1u8Q1fJp0It?=
 =?us-ascii?Q?hoOGJV3p1KnptZpZ5/Zfo53emwCYmqHCCGsA76TJ3QbfxQ46yhGYNw2s4Wf6?=
 =?us-ascii?Q?87OpoeXqEq7j09tRGzeWxywrDuzIWrTrYVBA5BblCU6k4AZN3Fh5Gn6U8Wh7?=
 =?us-ascii?Q?idh81qzzYbQpu7BOGbdjYhGhKrrqABtBmoOZzQqECuHrYv6AQoieXEosVkRg?=
 =?us-ascii?Q?M1k+CONwpADDG/VoTrmVKJBNCMGqJ3Zgk8ZHPSFVGeb406fX3cpGPDU5LvH2?=
 =?us-ascii?Q?og166oLFf28VYJ2dUHHPAY+8DDhEYXmZ/vxS8oLoTHhyPdvvcRmghk33ONlz?=
 =?us-ascii?Q?tQLsIg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 608d7989-0db8-4ecf-5bfd-08da9b1af245
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 15:15:26.3526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C73tXS9JWp7guvUERf6w3XukiHFUv/jUUzxeGqf5TgzZ1iCtvVVfQo0iBSAHY3YA5t2eO2nqtDekOelgo6LZMm3trdWDGdiohrM9HrVTNKc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5301
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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

