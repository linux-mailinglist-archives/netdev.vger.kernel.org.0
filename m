Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E059168ECB8
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 11:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbjBHKXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 05:23:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjBHKXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 05:23:38 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2129.outbound.protection.outlook.com [40.107.220.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE38045209
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 02:23:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EtFybypOmJbiEklatTkDAXg3jdyV8YiP45RRh6TOwHk0InmXVuUy7Mb+NLq09++U2t93C4ghSGyHLccPi8sg3V2DYbn5s85AnFt3f8WxCLreVPHdxDEFJDOkeixFcaEl+4n2pZxEm1E8IPr2DCMalbzkSplkbi3vM68HkFP2sLgg7GYmCSawaAHYhYvrnIMGMtNOP1eZY7M9TwuDDF1ceOFjqYEClhFSxuFwhfDOJUuhokaL7IsGCGM70YBdcAo/ytFsAILxMuhZ9FBaPH4wRspMVP39GAJWXd3ps2ek+wVjBxfNeaBZSQ7Teby6pQ9xHzdFLhUxchGW/tvLHk7YhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K0S5jaOcjdRztSRmouwHsReQN+Z0HaM1NA2owgefuko=;
 b=DZG44WzqOspATTj5kjgQC3kwRZUpXBC6su0xMeVW9SkbKJIDEPm/083baeUbQTyiHJCk6yMNBg2KJbJ+soNPJF7dbpoSvSyq1Qbd1P6rQ5OnFdEUWRrAAD7PB6pHfsBSQJl0ruaPzs6nb+XRXNpuF4Hu25mDDnqTXoyKZVbAuQkwxMuV4ph69Zb1mmckdXgHn/A5n/DCsFDj4uFv8KxFP5PwPJzKvoG1TPEB3crVuVVv64plN7ZbOBJ1S6F8M8mzM5LF4DWyzuGCqk5R/K2bInQQp4F71eX7DpriKj55aLRaRrWoC/qlvWSxWuTkmGZlp8zbrXVROh0pOA/IzFc6Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K0S5jaOcjdRztSRmouwHsReQN+Z0HaM1NA2owgefuko=;
 b=tFL5K2BM6eZe3UBUND1QZecN/2Tq+LPgZ3qKCr/H1fux1whu07OemTn+da2vFc2FHweSvZJeGYozILy4JpUp+10IOu/ychrYGHzWX8jA8ocpXkW5ntTF9N/k3/ls/XlfY3yuwri348gaiNW/NYZC+5/IP4OKsf7SDpW2q5PYlQg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5761.namprd13.prod.outlook.com (2603:10b6:510:118::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Wed, 8 Feb
 2023 10:23:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 10:23:33 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Leon Romanovsky <leon@kernel.org>,
        Chentian Liu <chengtian.liu@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net 2/2] nfp: fix schedule in atomic context when offloading sa
Date:   Wed,  8 Feb 2023 11:22:58 +0100
Message-Id: <20230208102258.29639-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230208102258.29639-1-simon.horman@corigine.com>
References: <20230208102258.29639-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P251CA0008.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5761:EE_
X-MS-Office365-Filtering-Correlation-Id: a76e3b72-0b97-49e3-dad6-08db09be878c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6GKrTtRhrdU82uKyY6TzDWNublC/CYRsGXng9gsCyUOHmjGDdV8yBSvVV9MmE1135OBe/62YTBarILaXqXJSDSyRlN9vE4ND5cvauPgUsQqhYltYamZ4KiuriEMNWDG8p9TEZ+k2l/xCJtrVYlKJbe7RpD3sOPKZcJfl/oEwlu0pUytuyWcVnNfDXGUN9R9KMKdhDekracXF+Us+8T/d6tqZqNiTX25UkGd7cUtCsBXF+DTh3dTltg5tbR3LRRQTDcoxDmB7LS6WxmON3vthgK9Zj2fF8YBjkhrCZwmiPhUUSv93JHSnecQTtHE3LvaRMPaaFWYnfoOa4LN6ewVH1FnPqtwzstTF3Y4MQ4S7OsnLCPzlxPus2i3YxU60bjiEWgfeYHoOKjMinDhwr3W/XtfjZN0A2oVz+DHTCT0a08sxkH+GfpqFOT1HfMmn8JPXSK+Sv5C5VqpEhOi5GXDviB1nFLu8GYLDDoyUBcjivjL/EVLLsU6q3dZIgV1GOV8gs7zdJG0NyRAbPNr9tm51T0j/Eg7ZkXhiTCPkSIRcWPUXmBVwbXRxQa4JPIvBMYBpDM6kzK9e/Lz+2B0AS4UhM+3mTYZxz6klQh168DCOlNh4VqkIE4fTteSa+uFjLx+UPwZJOEIMlFigoYX9iyBp5eJTo0TUYJbxvPF/u2fSTGnvssAcNezsnnevfmIl9qt5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(396003)(346002)(39840400004)(376002)(451199018)(86362001)(66476007)(66556008)(66946007)(186003)(2906002)(2616005)(52116002)(107886003)(54906003)(316002)(36756003)(6666004)(6486002)(110136005)(6512007)(41300700001)(44832011)(4326008)(478600001)(8676002)(38100700002)(8936002)(83380400001)(5660300002)(1076003)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3mTxbMa37q/9FegYKJSe4EKOPL9YfFtP/D7CQWbTfc4QXB28A+UFtpoEv+Im?=
 =?us-ascii?Q?GLEfSAZFQV6H42vyDeRDsHbaIuLGm1nz4dL3kTK3JRQwN87rDy2DOKJMJ+69?=
 =?us-ascii?Q?J6zRssua4SrbyYQNUq1hGxDXGbubS9y2AHcyqbIiHS/Xn9VM0lsbyxEO+RBD?=
 =?us-ascii?Q?UPs5SHg0UcqMGZblw2JmNIP3k88SC8U2oKkAPMHsO4/j4+lz41L+JUa7nN4L?=
 =?us-ascii?Q?SYhvqDQbqPbZt/9hoWDLEc0cdxWoquAc98nEct6bsML/95qsE+ns0ZuxoaxK?=
 =?us-ascii?Q?DpOmcBhTnew2ceDR7K0sIc7CSzTlLtsyFU/ZZaPuz2GKzmDrBvO7fBfsH5mc?=
 =?us-ascii?Q?2IZHsn6Ld+aIS+HVV+dq1Fi6fOzJDluRqlsdhTIxI2Ok7+2TrfSy+Lpivqqb?=
 =?us-ascii?Q?mWzzeTECWKpqkZf2uSdA1UyuRx0nzw9QV1MmdErjfkn2/CakoIFfCTTuWjAn?=
 =?us-ascii?Q?kQJ6T/3Iy+nOt36rSbiWbu3Y4kixZZx4Ebwbr8vqpMO3cyW7jVACcZp/kIqi?=
 =?us-ascii?Q?hBwKWEaJPtTl6SOYaBimZexuE9Ugi4NJN3GmSDRSCvLuJzS2rfG6yuh86LlW?=
 =?us-ascii?Q?3qowwP5+h9mDI1q+XQBQIqpL3h5eXcjLr85F4uSxhGm02iUXckJSPR3orw6h?=
 =?us-ascii?Q?UOc4sHLTmDbQtuzGv12x1ZNK+lrmVISeziNSsOMcxKIZQeWqbXs7ZSL8rP9x?=
 =?us-ascii?Q?EyPYDLnrCbTSI7shPnOWtqo8jGm03KLEawp2dB6GaZBkb89TAA383iUQP9wx?=
 =?us-ascii?Q?Wb6nq2A91MOHny5BQZEqm2k/tgu6SdOB4ouKc/zkzq/y6B4MFnvadXvTCVPH?=
 =?us-ascii?Q?+SgI6NDolE+W6+G7kPnHlUfZsZ2WLrAD7GXnFEi1SNGtlMsDxnzHsQ0OwKXR?=
 =?us-ascii?Q?YqsvxWW1MFAKWk6OPbfLTw2R5A2SQGPZipYRED1zs+lmMvloGc/FPgaf5GWZ?=
 =?us-ascii?Q?dUEgHUVzED0NtaZo6V1rOHwD+ZvoMECzApa3He8T0vcrT49+fUsMsdJ1dMAz?=
 =?us-ascii?Q?IN4cEJ+dFeAUjQobsZ0dWUINnVziGoQzCqBlr/kUQcWldewTmLRH4KWVGE/J?=
 =?us-ascii?Q?Bm3IOrd7z2bK8mIRIRI/tTdAWF97fkKLo70qzzqPnjG9RMHvEgyQ43nrRtk5?=
 =?us-ascii?Q?KPp7MDG96+LHpYY+o9v5rO2n0jCJ2UrYdA2OEnzrm6NR5UlYPvZtm402lFbt?=
 =?us-ascii?Q?gK4jkAu4s7KlS2vQ5Hk+T620UvDkSAGuL+3dXffWx69UXSkT+yd6lcoW255/?=
 =?us-ascii?Q?8yCZSunZb4HP0iD3217vV0lY0lpcLTX9Fy1bd51vEExoPRks1q1edJ7MNMHz?=
 =?us-ascii?Q?4nz3ezWRkQwjgrP8+BdAyOLNGdQno3W76o5kj0JCRDyShQlRnGYZ83gBGIBl?=
 =?us-ascii?Q?vqlrbkAomfMVI3EE+0wqJI6XksJKshr6B7Up/inhpOhSuzNmFMeJJ+WDvJfw?=
 =?us-ascii?Q?fHWt9AL1mrDC7HqqH5vBDM4QgJSpShv+I6kWxwwYmdHnDB6rOAL2oQ6fvtSe?=
 =?us-ascii?Q?wLZND5tZZDPip/h3jNsp192RspOQ/MiPrewmxn0bBEVe2e+cd6ijlAHr2NS5?=
 =?us-ascii?Q?ohfElBsqsYa33pUcmsdfSrFUVZl5B3XgpGFmBpEVa3mpnQeXCqGF6v1tciAQ?=
 =?us-ascii?Q?GojH/OA3uUwCjCLtqXcMO2JVin+J8/ZXoc+WeGsh/fXAnamLyUCB3L8Btl46?=
 =?us-ascii?Q?dWPZQQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a76e3b72-0b97-49e3-dad6-08db09be878c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 10:23:32.8750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zb57913nKN+W+A09+9F28QTthXs4Wv3VIdEymqS7Uza550UNT+jGsz/QTG2B68Zk6hpYFb0atXnwJ9rGLGk8HgUFyyxZc2IXAU+yjODU+HY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5761
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

IPsec offloading callbacks may be called in atomic context, sleep is
not allowed in the implementation. Now use workqueue mechanism to
avoid this issue.

Extend existing workqueue mechanism for multicast configuration only
to universal use, so that all configuring through mailbox asynchronously
can utilize it.

Fixes: 859a497fe80c ("nfp: implement xfrm callbacks and expose ipsec offload feature to upper layer")
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../net/ethernet/netronome/nfp/crypto/ipsec.c |  24 ++--
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |  25 +++-
 .../ethernet/netronome/nfp/nfp_net_common.c   | 108 +++++++++---------
 3 files changed, 87 insertions(+), 70 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
index 6d9d1c89ae6a..063cd371033a 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
+++ b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
@@ -129,25 +129,21 @@ struct nfp_ipsec_cfg_mssg {
 	};
 };
 
-static int nfp_ipsec_cfg_cmd_issue(struct nfp_net *nn, int type, int saidx,
-				   struct nfp_ipsec_cfg_mssg *msg)
+static int nfp_net_ipsec_cfg(struct nfp_net *nn, struct nfp_mbox_amsg_entry *entry)
 {
 	unsigned int offset = nn->tlv_caps.mbox_off + NFP_NET_CFG_MBOX_SIMPLE_VAL;
+	struct nfp_ipsec_cfg_mssg *msg = (struct nfp_ipsec_cfg_mssg *)entry->msg;
 	int i, msg_size, ret;
 
 	ret = nfp_net_mbox_lock(nn, sizeof(*msg));
 	if (ret)
 		return ret;
 
-	msg->cmd = type;
-	msg->sa_idx = saidx;
-	msg->rsp = 0;
 	msg_size = ARRAY_SIZE(msg->raw);
-
 	for (i = 0; i < msg_size; i++)
 		nn_writel(nn, offset + 4 * i, msg->raw[i]);
 
-	ret = nfp_net_mbox_reconfig(nn, NFP_NET_CFG_MBOX_CMD_IPSEC);
+	ret = nfp_net_mbox_reconfig(nn, entry->cmd);
 	if (ret < 0) {
 		nn_ctrl_bar_unlock(nn);
 		return ret;
@@ -486,7 +482,10 @@ static int nfp_net_xfrm_add_state(struct xfrm_state *x)
 	}
 
 	/* Allocate saidx and commit the SA */
-	err = nfp_ipsec_cfg_cmd_issue(nn, NFP_IPSEC_CFG_MSSG_ADD_SA, saidx, &msg);
+	msg.cmd = NFP_IPSEC_CFG_MSSG_ADD_SA;
+	msg.sa_idx = saidx;
+	err = nfp_net_sched_mbox_amsg_work(nn, NFP_NET_CFG_MBOX_CMD_IPSEC, &msg,
+					   sizeof(msg), nfp_net_ipsec_cfg);
 	if (err) {
 		xa_erase(&nn->xa_ipsec, saidx);
 		nn_err(nn, "Failed to issue IPsec command err ret=%d\n", err);
@@ -500,14 +499,17 @@ static int nfp_net_xfrm_add_state(struct xfrm_state *x)
 
 static void nfp_net_xfrm_del_state(struct xfrm_state *x)
 {
+	struct nfp_ipsec_cfg_mssg msg = {
+		.cmd = NFP_IPSEC_CFG_MSSG_INV_SA,
+		.sa_idx = x->xso.offload_handle - 1,
+	};
 	struct net_device *netdev = x->xso.dev;
-	struct nfp_ipsec_cfg_mssg msg;
 	struct nfp_net *nn;
 	int err;
 
 	nn = netdev_priv(netdev);
-	err = nfp_ipsec_cfg_cmd_issue(nn, NFP_IPSEC_CFG_MSSG_INV_SA,
-				      x->xso.offload_handle - 1, &msg);
+	err = nfp_net_sched_mbox_amsg_work(nn, NFP_NET_CFG_MBOX_CMD_IPSEC, &msg,
+					   sizeof(msg), nfp_net_ipsec_cfg);
 	if (err)
 		nn_warn(nn, "Failed to invalidate SA in hardware\n");
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index 432d79d691c2..939cfce15830 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -617,9 +617,10 @@ struct nfp_net_dp {
  * @vnic_no_name:	For non-port PF vNIC make ndo_get_phys_port_name return
  *			-EOPNOTSUPP to keep backwards compatibility (set by app)
  * @port:		Pointer to nfp_port structure if vNIC is a port
- * @mc_lock:		Protect mc_addrs list
- * @mc_addrs:		List of mc addrs to add/del to HW
- * @mc_work:		Work to update mc addrs
+ * @mbox_amsg:		Asynchronously processed message via mailbox
+ * @mbox_amsg.lock:	Protect message list
+ * @mbox_amsg.list:	List of message to process
+ * @mbox_amsg.work:	Work to process message asynchronously
  * @app_priv:		APP private data for this vNIC
  */
 struct nfp_net {
@@ -721,13 +722,25 @@ struct nfp_net {
 
 	struct nfp_port *port;
 
-	spinlock_t mc_lock;
-	struct list_head mc_addrs;
-	struct work_struct mc_work;
+	struct {
+		spinlock_t lock;
+		struct list_head list;
+		struct work_struct work;
+	} mbox_amsg;
 
 	void *app_priv;
 };
 
+struct nfp_mbox_amsg_entry {
+	struct list_head list;
+	int (*cfg)(struct nfp_net *nn, struct nfp_mbox_amsg_entry *entry);
+	u32 cmd;
+	char msg[];
+};
+
+int nfp_net_sched_mbox_amsg_work(struct nfp_net *nn, u32 cmd, const void *data, size_t len,
+				 int (*cb)(struct nfp_net *, struct nfp_mbox_amsg_entry *));
+
 /* Functions to read/write from/to a BAR
  * Performs any endian conversion necessary.
  */
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 18fc9971f1c8..70d7484c82af 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1334,14 +1334,54 @@ int nfp_ctrl_open(struct nfp_net *nn)
 	return err;
 }
 
-struct nfp_mc_addr_entry {
-	u8 addr[ETH_ALEN];
-	u32 cmd;
-	struct list_head list;
-};
+int nfp_net_sched_mbox_amsg_work(struct nfp_net *nn, u32 cmd, const void *data, size_t len,
+				 int (*cb)(struct nfp_net *, struct nfp_mbox_amsg_entry *))
+{
+	struct nfp_mbox_amsg_entry *entry;
+
+	entry = kmalloc(sizeof(*entry) + len, GFP_ATOMIC);
+	if (!entry)
+		return -ENOMEM;
+
+	memcpy(entry->msg, data, len);
+	entry->cmd = cmd;
+	entry->cfg = cb;
+
+	spin_lock_bh(&nn->mbox_amsg.lock);
+	list_add_tail(&entry->list, &nn->mbox_amsg.list);
+	spin_unlock_bh(&nn->mbox_amsg.lock);
+
+	schedule_work(&nn->mbox_amsg.work);
+
+	return 0;
+}
+
+static void nfp_net_mbox_amsg_work(struct work_struct *work)
+{
+	struct nfp_net *nn = container_of(work, struct nfp_net, mbox_amsg.work);
+	struct nfp_mbox_amsg_entry *entry, *tmp;
+	struct list_head tmp_list;
+
+	INIT_LIST_HEAD(&tmp_list);
+
+	spin_lock_bh(&nn->mbox_amsg.lock);
+	list_splice_init(&nn->mbox_amsg.list, &tmp_list);
+	spin_unlock_bh(&nn->mbox_amsg.lock);
+
+	list_for_each_entry_safe(entry, tmp, &tmp_list, list) {
+		int err = entry->cfg(nn, entry);
+
+		if (err)
+			nn_err(nn, "Config cmd %d to HW failed %d.\n", entry->cmd, err);
+
+		list_del(&entry->list);
+		kfree(entry);
+	}
+}
 
-static int nfp_net_mc_cfg(struct nfp_net *nn, const unsigned char *addr, const u32 cmd)
+static int nfp_net_mc_cfg(struct nfp_net *nn, struct nfp_mbox_amsg_entry *entry)
 {
+	unsigned char *addr = entry->msg;
 	int ret;
 
 	ret = nfp_net_mbox_lock(nn, NFP_NET_CFG_MULTICAST_SZ);
@@ -1353,26 +1393,7 @@ static int nfp_net_mc_cfg(struct nfp_net *nn, const unsigned char *addr, const u
 	nn_writew(nn, nn->tlv_caps.mbox_off + NFP_NET_CFG_MULTICAST_MAC_LO,
 		  get_unaligned_be16(addr + 4));
 
-	return nfp_net_mbox_reconfig_and_unlock(nn, cmd);
-}
-
-static int nfp_net_mc_prep(struct nfp_net *nn, const unsigned char *addr, const u32 cmd)
-{
-	struct nfp_mc_addr_entry *entry;
-
-	entry = kmalloc(sizeof(*entry), GFP_ATOMIC);
-	if (!entry)
-		return -ENOMEM;
-
-	ether_addr_copy(entry->addr, addr);
-	entry->cmd = cmd;
-	spin_lock_bh(&nn->mc_lock);
-	list_add_tail(&entry->list, &nn->mc_addrs);
-	spin_unlock_bh(&nn->mc_lock);
-
-	schedule_work(&nn->mc_work);
-
-	return 0;
+	return nfp_net_mbox_reconfig_and_unlock(nn, entry->cmd);
 }
 
 static int nfp_net_mc_sync(struct net_device *netdev, const unsigned char *addr)
@@ -1385,35 +1406,16 @@ static int nfp_net_mc_sync(struct net_device *netdev, const unsigned char *addr)
 		return -EINVAL;
 	}
 
-	return nfp_net_mc_prep(nn, addr, NFP_NET_CFG_MBOX_CMD_MULTICAST_ADD);
+	return nfp_net_sched_mbox_amsg_work(nn, NFP_NET_CFG_MBOX_CMD_MULTICAST_ADD, addr,
+					    NFP_NET_CFG_MULTICAST_SZ, nfp_net_mc_cfg);
 }
 
 static int nfp_net_mc_unsync(struct net_device *netdev, const unsigned char *addr)
 {
 	struct nfp_net *nn = netdev_priv(netdev);
 
-	return nfp_net_mc_prep(nn, addr, NFP_NET_CFG_MBOX_CMD_MULTICAST_DEL);
-}
-
-static void nfp_net_mc_addr_config(struct work_struct *work)
-{
-	struct nfp_net *nn = container_of(work, struct nfp_net, mc_work);
-	struct nfp_mc_addr_entry *entry, *tmp;
-	struct list_head tmp_list;
-
-	INIT_LIST_HEAD(&tmp_list);
-
-	spin_lock_bh(&nn->mc_lock);
-	list_splice_init(&nn->mc_addrs, &tmp_list);
-	spin_unlock_bh(&nn->mc_lock);
-
-	list_for_each_entry_safe(entry, tmp, &tmp_list, list) {
-		if (nfp_net_mc_cfg(nn, entry->addr, entry->cmd))
-			nn_err(nn, "Config mc address to HW failed.\n");
-
-		list_del(&entry->list);
-		kfree(entry);
-	}
+	return nfp_net_sched_mbox_amsg_work(nn, NFP_NET_CFG_MBOX_CMD_MULTICAST_DEL, addr,
+					    NFP_NET_CFG_MULTICAST_SZ, nfp_net_mc_cfg);
 }
 
 static void nfp_net_set_rx_mode(struct net_device *netdev)
@@ -2681,9 +2683,9 @@ int nfp_net_init(struct nfp_net *nn)
 	if (!nn->dp.netdev)
 		return 0;
 
-	spin_lock_init(&nn->mc_lock);
-	INIT_LIST_HEAD(&nn->mc_addrs);
-	INIT_WORK(&nn->mc_work, nfp_net_mc_addr_config);
+	spin_lock_init(&nn->mbox_amsg.lock);
+	INIT_LIST_HEAD(&nn->mbox_amsg.list);
+	INIT_WORK(&nn->mbox_amsg.work, nfp_net_mbox_amsg_work);
 
 	return register_netdev(nn->dp.netdev);
 
@@ -2704,6 +2706,6 @@ void nfp_net_clean(struct nfp_net *nn)
 	unregister_netdev(nn->dp.netdev);
 	nfp_net_ipsec_clean(nn);
 	nfp_ccm_mbox_clean(nn);
-	flush_work(&nn->mc_work);
+	flush_work(&nn->mbox_amsg.work);
 	nfp_net_reconfig_wait_posted(nn);
 }
-- 
2.30.2

