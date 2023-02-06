Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A769068C1D9
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 16:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjBFPkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 10:40:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231698AbjBFPj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 10:39:56 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20720.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::720])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABEA2BEEB
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 07:39:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LODu54GJn/x6R4IRem+xbHyFic10FPy5A3OZC/98PnaqMTghR+Ekv8PhO17zXFpQZuuRmaZrutE8QVJeXt9yElk+0sND4p1gG1V+NanlGEg71Yv7TTucHIjE6cdQa3QJ9VljUOSkUeIgz/mMRBO+yaQsaxlaWf1n95xc35ktrQVmafoPnqGHSKf+T2qt2e5kvTPuaKn4hNGY71ZMzq2hLM/NALN76jU4sn4MjuftHupzXYmcgvSGa74i9XS0YB9HYozid/k+ZZgYFLRt0kjwpl25e75HQVON3JIwFwqOpbbbcKshEWk2h2ByuhthXuhgkSSdee1dXDj50JTTzu/rDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=krAZ/z9lLu4yftXseWdiMmTVvKil55EoYub4vkVmGhQ=;
 b=lxWBVA3t0nLiPqmj5udUlZZuNUiChq/YcEYRcJZ84tM4mGaGuc+ZUAyYaXelaXhodKBhGEcH9s2gZk9aYKvkR0uDseJ+VmAXEptqcmn3j2b10LPrzMUIc4oeLojEuL0HX6n9Mbv7KmNXjaA4c0Gyd4vt2ZUzO+9OR1BhssnybGR/Np/oRzLtAwUbdvQiOOrUciJJuol5y/5g1LWiLZdTwGT4ZirrScFpI+p6tKlF7GjMU515n2qRm1GgJvpxT1RZqSMaQkH+djs9PwPjY96DjI7ygITfk5zlTV1zqwbzZz25SyIH+FMj/WhSUGXA18JjxsEU+ELgFOd1quvD3+hzaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=krAZ/z9lLu4yftXseWdiMmTVvKil55EoYub4vkVmGhQ=;
 b=sO1BclWGLqIxZ3rCTAZM9Enwmv6KhE4EE9FlLdO8HbHEJLVie8KU7f3rqny8N8y5RdVBb5+Mz3QpHbYq75xSEcVFExRV2otd219Eh58BCk3QBVv50SGTtZwbUtCKQ3rVs17Z6xcD6M4qoZ5+pY8lC9lfqx6mDvGeOaIEO02JJqc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB4912.namprd13.prod.outlook.com (2603:10b6:806:184::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Mon, 6 Feb
 2023 15:37:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 15:37:22 +0000
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
        Andrew Lunn <andrew@lunn.ch>, Fei Qin <fei.qin@corigine.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH/RFC net-next 2/2] nfp: add support for assigning VFs to different physical ports
Date:   Mon,  6 Feb 2023 16:36:03 +0100
Message-Id: <20230206153603.2801791-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230206153603.2801791-1-simon.horman@corigine.com>
References: <20230206153603.2801791-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0202CA0013.eurprd02.prod.outlook.com
 (2603:10a6:200:89::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB4912:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b0f75e4-b81f-4e32-3ebe-08db08580a3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LQ/wUzuBifSrts57zIIfvZucHPseRoxICpUsnBTb19CDa7GKnkK+TVpFQSLyPwkfR91XDp6+z00AkSSKAUrL84G3kWKRszoFM9YDKLwOJ8QV1hyP2yxX2hqSDGaaLMaqyPfJb0D5KwcaqRLP4ZLlWWFQSYyDsASZ5i4Z3B56z4wZw6k1amyuKuLdEjXdJzfuVy89tIbsf6nRSmN+t4NwI1Vs4RnLPngTz3JIZq/YAm/BgX+WMW+LJgUAyaOfx2QJwx5LkHfZ9x+1cMPIPQWsygBjX+vkWRe9yw9vIBBe52ORSne306GW4FGBbAMXdb7YJlXCyghnfbNVwpxOXEPiPE44cBC/4NwOqqdBk5aQmzl/pZF6XheUbeYBWGMXn2LA5I9ycELXqHEqIr9oAkxiuFOu7ZSPwrOkIxIeA0u/woYMe2l8uhg7qqksgWfoxhs5Up6M8iwF4uDQHv1oZFszpj3XypQG9tfb+iyRHX1yl4X8Yk6bB7ilXf7SzDZqidFjKzCgu4gjNZ5K7tTJkgwuO/PVPCu7FMTkCMjAmVMqtAKnZH1LTsdjTqtIpYecZy9E8XfPidmXSZyXDUmBNcGW1nOZnazcTXf2y/l+tZH1szeCdy35Jcuq7D/nyRFvZIHuEs0rVN3ieYNLFDt6f+YaAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(396003)(39840400004)(346002)(376002)(451199018)(478600001)(2906002)(6486002)(66946007)(186003)(6512007)(66476007)(6666004)(107886003)(41300700001)(1076003)(6506007)(8676002)(66556008)(52116002)(4326008)(30864003)(7416002)(316002)(54906003)(5660300002)(38100700002)(110136005)(8936002)(44832011)(86362001)(36756003)(83380400001)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rBPkx1B833YMeS0k7kWCFFHshnG1Q6CcFUGcttVmuIch1D7QENTO/OunG5jf?=
 =?us-ascii?Q?kCkrwiBFcD/f8LQ2woBC5lga45rSSTA/q0pDVpFjks4Oet6sYit/1yNui+gg?=
 =?us-ascii?Q?UeneAvjvrBD009/ohBUCTdAlmZs5a2hkCK+i6NScvVW3NJNHbiI9EE2Q++vu?=
 =?us-ascii?Q?jfgHmTis5h6vz20Yc0eZW/w7c/aDkiXcmLoEYo+kChVAFGgTw7gkAWtlWF8X?=
 =?us-ascii?Q?VdrqdhbIsovPm59ccynL6YyxLIUHQkzl4tDIx+w9erni41z8ub/qxTU5z53M?=
 =?us-ascii?Q?xEMZJnNdpzmAxZgFPWteBVM/4cfROda5hd6qbPn9Uf8mlpCQC7QoIkv3SuyJ?=
 =?us-ascii?Q?mM5LCV7F9WjwG+mHs1CLH7ICx1PlORl5ELp/KlKW/qOuTtxJr8dVg864iN8x?=
 =?us-ascii?Q?BQr/dDEQOsaMEcAJMcp97x82k50JZJLJjAN1zuXYh12sJFQJINm4+2SUB1Q3?=
 =?us-ascii?Q?0DtsiaMmGmfo3Ko3ynqxOP/R7FCVFltoq2tF9LEUwvd8RE9UWG8IFzls6v2f?=
 =?us-ascii?Q?1/vP4jFV5fxn9ej2ib5v6JKKuu9Dk7hYFCPV1m30C5pVWDccrX0qkHzusnXm?=
 =?us-ascii?Q?Ea3Yfl2pDctLA0cUKPTzk7crmJSSCcUkUXxorwFYvIPQJ/0ypxlfGxdoOZbI?=
 =?us-ascii?Q?G+/dm7MtfI33Gl2na7ogymR40B9jz3Wk3XRzal4Y3JehOSoKSVQa8pp+b9FE?=
 =?us-ascii?Q?kFXrttXscUGyA2Z9/8okcm37oeBPMVw0SWIIfPx2vFjzp3UR0ia699YCynR0?=
 =?us-ascii?Q?9A7l+9GPF6RlQvCgT2z6i1LgeL6j/CsyAIND2m7w2JWoJV+QQZYV2+nkbMX3?=
 =?us-ascii?Q?86CvmLlLtfjfMECQSUt+QoEp3hXYYQiFzdRx8FG8XjESrrSSUvXKOkHSFKoL?=
 =?us-ascii?Q?RhHw+/sdlbLBFrMoPeO2d702MvoKhx4BIYeXZd1d5t5KfGxLOF8LafT7fKpt?=
 =?us-ascii?Q?RuT2VT18Lqe3na9whIfdSSNt/SyMTUYy877y79pfacOnK8EtCIWrs1g5fQC+?=
 =?us-ascii?Q?ANLceMJkhaBLD7m3u3fEyW3kNw7JgDw6gVJRphe3Tml82HvY1y5aRkzNOopd?=
 =?us-ascii?Q?msT8lOhgrlo5xSAvztBuserSW8KSvKGBs3hfo4Czq4tbCSgHH0rLJv3+eZaS?=
 =?us-ascii?Q?TVj+99+uPRF4mecThvs4aw+EsRa+hCM8rAlY8yGqLnY0BiXVGcwNQ6G7dTX7?=
 =?us-ascii?Q?8yZNBixTLCJbq7dZ1gVoEhg3hd7ynMQtR2mhFISqYJOLY/kQR3Lia6Jg5++d?=
 =?us-ascii?Q?TzQRhs2gGOswpam7ZMnPiHL2J614Kg5dL2gIK/9NUHMD7dqhYT2EqfExVM4N?=
 =?us-ascii?Q?jW45wmRyfLpCIDvLSVpoiFV29z+xJenRm9OtZEFo4f8NR0fs9HzZKWUSm5mk?=
 =?us-ascii?Q?vDt/E4JrYX8xZfz+8DWoutabkG2BDTFp6l+q+fKJnA9crOYDjc/g1g2iFFg2?=
 =?us-ascii?Q?R9+JzOGot1Eck4dQuaK0ARp135i0XF0CBjTTL4sTUq030M4dzHEsSvRvg+PI?=
 =?us-ascii?Q?+QO153K+6uqT/YFTI3NM53Xv+zKvlOBCc8wOGK0wF9idADUqBA5docJLdP2u?=
 =?us-ascii?Q?FVnr8p3z8TaOjFt1KTF45SwKmgZUbqZc6MaGgP+qCdkmZVSRCusyZiF/t2bt?=
 =?us-ascii?Q?nalwPeg8U/I/HS2aw8CkrBvQK3cQV3D/oCXlrchSI8R9Xq8xHE57ufZSzo4k?=
 =?us-ascii?Q?zwWXQQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b0f75e4-b81f-4e32-3ebe-08db08580a3d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 15:37:22.6875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7zngTnMWwkWA9z7Nqi/5nPcjRNRkyiTW/UMjY5MaobWZnDZHbt8uuqtNE5XtvAuj25zJEsriYGSBeUhHU4MNm/2v9dF9V8zNIT8HSdNqYDg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4912
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fei Qin <fei.qin@corigine.com>

Currently, all the VFs are bridged to port 0 for the device.
Assigning VFs to different ports is required to realize
traffic load balancing.

Add implement for "devlink port function set vf_count <VAL>"
command to support assigning vfs to different physical ports.

e.g.
$ devlink port show pci/0000:82:00.0/0
pci/0000:82:00.0/0: type eth netdev enp130s0np0 flavour physical
port 0 splittable true lanes 4
    function:
       vf_count 0

$ devlink port function set pci/0000:82:00.0/0 vf_count 3

$ devlink port show pci/0000:82:00.0/0
pci/0000:82:00.0/0: type eth netdev enp130s0np0 flavour physical
port 0 splittable true lanes 4
    function:
       vf_count 3

Signed-off-by: Fei Qin <fei.qin@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../net/ethernet/netronome/nfp/nfp_devlink.c  |  71 +++++++++
 drivers/net/ethernet/netronome/nfp/nfp_main.c |   5 +
 drivers/net/ethernet/netronome/nfp/nfp_main.h |   4 +
 .../ethernet/netronome/nfp/nfp_net_sriov.c    | 147 +++++++++++++++++-
 .../ethernet/netronome/nfp/nfp_net_sriov.h    |   6 +
 5 files changed, 225 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
index bf6bae557158..9a6b4d6c28ca 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
@@ -9,6 +9,7 @@
 #include "nfp_app.h"
 #include "nfp_main.h"
 #include "nfp_port.h"
+#include "nfp_net_sriov.h"
 
 static int
 nfp_devlink_fill_eth_port(struct nfp_port *port,
@@ -310,6 +311,74 @@ nfp_devlink_flash_update(struct devlink *devlink,
 	return nfp_flash_update_common(devlink_priv(devlink), params->fw, extack);
 }
 
+static int
+nfp_devlink_vf_count_get_port_id(struct devlink_port *dl_port)
+{
+	struct nfp_pf *pf = devlink_priv(dl_port->devlink);
+	struct nfp_eth_table_port *eth_port;
+	struct nfp_port *port;
+	int err;
+
+	err = nfp_net_sriov_check(pf->app, 0, NFP_NET_VF_CFG_MB_CAP_VF_ASSIGNMENT,
+				  "vf_assignment", false);
+	if (err)
+		return err;
+
+	port = container_of(dl_port, struct nfp_port, dl_port);
+	eth_port = __nfp_port_get_eth_port(port);
+	if (!eth_port)
+		return -EOPNOTSUPP;
+
+	return eth_port - pf->eth_tbl->ports;
+}
+
+static int
+nfp_devlink_vf_count_get(struct devlink_port *dl_port, u16 *vf_count,
+			 struct netlink_ext_ack *extack)
+{
+	int port_id = nfp_devlink_vf_count_get_port_id(dl_port);
+	struct nfp_pf *pf = devlink_priv(dl_port->devlink);
+
+	if (port_id < 0 || port_id >= NFP_VF_ASSIGNMENT_PORT_COUNT)
+		return -EOPNOTSUPP;
+
+	*vf_count = pf->num_assigned_vfs[port_id];
+
+	return 0;
+}
+
+static int
+nfp_devlink_vf_count_set(struct devlink_port *dl_port, u16 vf_count,
+			 struct netlink_ext_ack *extack)
+{
+	int port_id = nfp_devlink_vf_count_get_port_id(dl_port);
+	struct nfp_pf *pf = devlink_priv(dl_port->devlink);
+	int total_num_ports = pf->eth_tbl->count;
+	int total_num_vfs = 0;
+	unsigned int i;
+
+	if (port_id < 0 || port_id >= NFP_VF_ASSIGNMENT_PORT_COUNT)
+		return -EOPNOTSUPP;
+
+	for (i = 0; i < total_num_ports; i++) {
+		if (i != port_id)
+			total_num_vfs += pf->num_assigned_vfs[i];
+		else
+			total_num_vfs += vf_count;
+
+		if (total_num_vfs > pf->limit_vfs)
+			goto exit_out_of_range;
+	}
+
+	pf->num_assigned_vfs[port_id] = vf_count;
+
+	return 0;
+
+exit_out_of_range:
+	NL_SET_ERR_MSG_MOD(extack, "Parameter out of range");
+	return -EINVAL;
+}
+
 const struct devlink_ops nfp_devlink_ops = {
 	.port_split		= nfp_devlink_port_split,
 	.port_unsplit		= nfp_devlink_port_unsplit,
@@ -319,6 +388,8 @@ const struct devlink_ops nfp_devlink_ops = {
 	.eswitch_mode_set	= nfp_devlink_eswitch_mode_set,
 	.info_get		= nfp_devlink_info_get,
 	.flash_update		= nfp_devlink_flash_update,
+	.port_fn_vf_count_get	= nfp_devlink_vf_count_get,
+	.port_fn_vf_count_set	= nfp_devlink_vf_count_set,
 };
 
 int nfp_devlink_port_register(struct nfp_app *app, struct nfp_port *port)
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.c b/drivers/net/ethernet/netronome/nfp/nfp_main.c
index 71301dbd8fb5..29663d2562aa 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.c
@@ -29,6 +29,7 @@
 #include "nfp_app.h"
 #include "nfp_main.h"
 #include "nfp_net.h"
+#include "nfp_net_sriov.h"
 
 static const char nfp_driver_name[] = "nfp";
 
@@ -252,6 +253,10 @@ static int nfp_pcie_sriov_enable(struct pci_dev *pdev, int num_vfs)
 		return -EINVAL;
 	}
 
+	err = nfp_configure_assign_vf(pdev, num_vfs);
+	if (err)
+		return err;
+
 	err = pci_enable_sriov(pdev, num_vfs);
 	if (err) {
 		dev_warn(&pdev->dev, "Failed to enable PCI SR-IOV: %d\n", err);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.h b/drivers/net/ethernet/netronome/nfp/nfp_main.h
index 14a751bfe1fe..67692fcf1201 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.h
@@ -16,6 +16,8 @@
 #include <linux/workqueue.h>
 #include <net/devlink.h>
 
+#define NFP_VF_ASSIGNMENT_PORT_COUNT 8
+
 struct dentry;
 struct device;
 struct pci_dev;
@@ -63,6 +65,7 @@ struct nfp_dumpspec {
  * @irq_entries:	Array of MSI-X entries for all vNICs
  * @limit_vfs:		Number of VFs supported by firmware (~0 for PCI limit)
  * @num_vfs:		Number of SR-IOV VFs enabled
+ * @num_assigned_vfs:	Number of VFs assigned to different physical ports
  * @fw_loaded:		Is the firmware loaded?
  * @unload_fw_on_remove:Do we need to unload firmware on driver removal?
  * @ctrl_vnic:		Pointer to the control vNIC if available
@@ -111,6 +114,7 @@ struct nfp_pf {
 
 	unsigned int limit_vfs;
 	unsigned int num_vfs;
+	u8 num_assigned_vfs[NFP_VF_ASSIGNMENT_PORT_COUNT];
 
 	bool fw_loaded;
 	bool unload_fw_on_remove;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.c b/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.c
index 6eeeb0fda91f..873c6d707c0e 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.c
@@ -13,9 +13,13 @@
 #include "nfp_net_ctrl.h"
 #include "nfp_net.h"
 #include "nfp_net_sriov.h"
+#include "nfp_port.h"
+#include "nfpcore/nfp_nsp.h"
 
-static int
-nfp_net_sriov_check(struct nfp_app *app, int vf, u16 cap, const char *msg, bool warn)
+/* Capability of VF pre-configuration */
+#define NFP_NET_VF_PRE_CONFIG			NFP_NET_VF_CFG_MB_CAP_VF_ASSIGNMENT
+
+int nfp_net_sriov_check(struct nfp_app *app, int vf, u16 cap, const char *msg, bool warn)
 {
 	u16 cap_vf;
 
@@ -29,6 +33,9 @@ nfp_net_sriov_check(struct nfp_app *app, int vf, u16 cap, const char *msg, bool
 		return -EOPNOTSUPP;
 	}
 
+	if (cap & NFP_NET_VF_PRE_CONFIG)
+		return 0;
+
 	if (vf < 0 || vf >= app->pf->num_vfs) {
 		if (warn)
 			nfp_warn(app->pf->cpp, "invalid VF id %d\n", vf);
@@ -38,17 +45,125 @@ nfp_net_sriov_check(struct nfp_app *app, int vf, u16 cap, const char *msg, bool
 	return 0;
 }
 
+/* VFs can be shown and configured through each physical port even with VF
+ * assignment enabled. FW requires configurations to be sent through the port
+ * that the VF assigned to. Driver may need to get the port id and judge if the
+ * current netdev is the one that the VF assigned to.
+ */
+static int nfp_vf_assignment_get_port_id(struct nfp_app *app, int vf)
+{
+	struct nfp_pf *pf = app->pf;
+	unsigned int i, start_vf;
+
+	for (start_vf = 0, i = 0; i < ARRAY_SIZE(pf->num_assigned_vfs); i++) {
+		if (vf >= start_vf && vf < (start_vf + pf->num_assigned_vfs[i]))
+			return i;
+		start_vf += pf->num_assigned_vfs[i];
+	}
+
+	/* If VF assignment is disabled, all the VFs are assigned to port 0 */
+	return 0;
+}
+
+static bool nfp_vf_assignment_assigned_to_cur_port(struct net_device *netdev, int vf)
+{
+	struct nfp_app *app = nfp_app_from_netdev(netdev);
+	struct nfp_eth_table_port *eth_port;
+	struct nfp_pf *pf = app->pf;
+	int assigned_port_id, err;
+	struct nfp_port *port;
+
+	/* If firmware doesn't support vf_assignment, each VF should be shown under
+	 * each physical port or PF normally.
+	 */
+	err = nfp_net_sriov_check(pf->app, 0, NFP_NET_VF_CFG_MB_CAP_VF_ASSIGNMENT,
+				  "vf_assignment", false);
+	if (err < 0)
+		return true;
+
+	port = nfp_port_from_netdev(netdev);
+	eth_port = nfp_port_get_eth_port(port);
+	if (!eth_port)
+		return true;
+
+	assigned_port_id = nfp_vf_assignment_get_port_id(app, vf);
+	return eth_port == &pf->eth_tbl->ports[assigned_port_id];
+}
+
+int nfp_configure_assign_vf(struct pci_dev *pdev, int num_vfs)
+{
+	struct nfp_pf *pf = pci_get_drvdata(pdev);
+	int err, total_num_vfs = 0, idx = 0;
+	struct nfp_net *nn;
+	unsigned int i;
+
+	err = nfp_net_sriov_check(pf->app, 0, NFP_NET_VF_CFG_MB_CAP_VF_ASSIGNMENT,
+				  "vf_assignment", false);
+	if (err)
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(pf->num_assigned_vfs); i++)
+		total_num_vfs += pf->num_assigned_vfs[i];
+
+	/* When the total_num_vfs is nonzero, the VF assignment is enabled.
+	 * The total number of created VFs is required to be consistent with
+	 * the one set in VF assignment.
+	 */
+	if (total_num_vfs && num_vfs != total_num_vfs) {
+		dev_err(&pdev->dev,
+			"Trying to create %d VFs not satisfy the configuration of VF assignment\n",
+			num_vfs);
+		return -EINVAL;
+	}
+
+	/* When VF assignment is disabled, all the VFs are allocated to port 0 */
+	list_for_each_entry(nn, &pf->vnics, vnic_list) {
+		u8 num_assigned_vfs = ((idx == 0) && !total_num_vfs) ?
+				  pf->limit_vfs : pf->num_assigned_vfs[idx];
+		idx++;
+
+		writeb(num_assigned_vfs, pf->vfcfg_tbl2 + NFP_NET_VF_CFG_VF_ASSIGNMENT);
+		writew(NFP_NET_VF_CFG_MB_UPD_VF_ASSIGNMENT, pf->vfcfg_tbl2 + NFP_NET_VF_CFG_MB_UPD);
+
+		err = nfp_net_reconfig(nn, NFP_NET_CFG_UPDATE_VF);
+		if (err)
+			return err;
+
+		err = readw(pf->vfcfg_tbl2 + NFP_NET_VF_CFG_MB_RET);
+		if (err) {
+			dev_info(&pdev->dev,
+				 "FW refused VF assignment update with errno: %d\n", err);
+			return -err;
+		}
+	}
+
+	return 0;
+}
+
 static int
 nfp_net_sriov_update(struct nfp_app *app, int vf, u16 update, const char *msg)
 {
+	int ret, assigned_port_id, cnt = 0;
+	struct nfp_net *nn_iter;
 	struct nfp_net *nn;
-	int ret;
 
 	/* Write update info to mailbox in VF config symbol */
 	writeb(vf, app->pf->vfcfg_tbl2 + NFP_NET_VF_CFG_MB_VF_NUM);
 	writew(update, app->pf->vfcfg_tbl2 + NFP_NET_VF_CFG_MB_UPD);
 
 	nn = list_first_entry(&app->pf->vnics, struct nfp_net, vnic_list);
+
+	/* If VF assignment is enabled, reconfig of VF should be set through "nn"
+	 * of corresponding physical port
+	 */
+	assigned_port_id = nfp_vf_assignment_get_port_id(app, vf);
+	list_for_each_entry(nn_iter, &app->pf->vnics, vnic_list) {
+		if (cnt++ == assigned_port_id) {
+			nn = nn_iter;
+			break;
+		}
+	}
+
 	/* Signal VF reconfiguration */
 	ret = nfp_net_reconfig(nn, NFP_NET_CFG_UPDATE_VF);
 	if (ret)
@@ -257,11 +372,18 @@ int nfp_app_set_vf_link_state(struct net_device *netdev, int vf,
 				    "link state");
 }
 
+/* VFs can be shown under each physical port. When the VF is
+ * not assigned to the physical port, hardcode its mac to
+ * ff:ff:ff:ff:ff:ff to distinguish. The changes of VFs'
+ * configurations can be only seen under the corresponding
+ * physical ports.
+ */
 int nfp_app_get_vf_config(struct net_device *netdev, int vf,
 			  struct ifla_vf_info *ivi)
 {
 	struct nfp_app *app = nfp_app_from_netdev(netdev);
 	u32 vf_offset, mac_hi, rate;
+	bool is_assigned = true;
 	u32 vlan_tag;
 	u16 mac_lo;
 	u8 flags;
@@ -271,13 +393,19 @@ int nfp_app_get_vf_config(struct net_device *netdev, int vf,
 	if (err)
 		return err;
 
-	vf_offset = NFP_NET_VF_CFG_MB_SZ + vf * NFP_NET_VF_CFG_SZ;
+	is_assigned = nfp_vf_assignment_assigned_to_cur_port(netdev, vf);
 
-	mac_hi = readl(app->pf->vfcfg_tbl2 + vf_offset);
-	mac_lo = readw(app->pf->vfcfg_tbl2 + vf_offset + NFP_NET_VF_CFG_MAC_LO);
+	vf_offset = NFP_NET_VF_CFG_MB_SZ + vf * NFP_NET_VF_CFG_SZ;
 
-	flags = readb(app->pf->vfcfg_tbl2 + vf_offset + NFP_NET_VF_CFG_CTRL);
-	vlan_tag = readl(app->pf->vfcfg_tbl2 + vf_offset + NFP_NET_VF_CFG_VLAN);
+	if (is_assigned) {
+		mac_hi = readl(app->pf->vfcfg_tbl2 + vf_offset);
+		mac_lo = readw(app->pf->vfcfg_tbl2 + vf_offset + NFP_NET_VF_CFG_MAC_LO);
+		flags = readb(app->pf->vfcfg_tbl2 + vf_offset + NFP_NET_VF_CFG_CTRL);
+		vlan_tag = readl(app->pf->vfcfg_tbl2 + vf_offset + NFP_NET_VF_CFG_VLAN);
+	} else {
+		mac_hi = 0xffffffff;
+		mac_lo = 0xffff;
+	}
 
 	memset(ivi, 0, sizeof(*ivi));
 	ivi->vf = vf;
@@ -285,6 +413,9 @@ int nfp_app_get_vf_config(struct net_device *netdev, int vf,
 	put_unaligned_be32(mac_hi, &ivi->mac[0]);
 	put_unaligned_be16(mac_lo, &ivi->mac[4]);
 
+	if (!is_assigned)
+		return 0;
+
 	ivi->vlan = FIELD_GET(NFP_NET_VF_CFG_VLAN_VID, vlan_tag);
 	ivi->qos = FIELD_GET(NFP_NET_VF_CFG_VLAN_QOS, vlan_tag);
 	if (!nfp_net_sriov_check(app, vf, NFP_NET_VF_CFG_MB_CAP_VLAN_PROTO, "vlan_proto", false))
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.h b/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.h
index 2d445fa199dc..fdf429f60d34 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.h
@@ -21,6 +21,7 @@
 #define   NFP_NET_VF_CFG_MB_CAP_TRUST			  (0x1 << 4)
 #define   NFP_NET_VF_CFG_MB_CAP_VLAN_PROTO		  (0x1 << 5)
 #define   NFP_NET_VF_CFG_MB_CAP_RATE			  (0x1 << 6)
+#define   NFP_NET_VF_CFG_MB_CAP_VF_ASSIGNMENT		  (0x1 << 8)
 #define NFP_NET_VF_CFG_MB_RET				0x2
 #define NFP_NET_VF_CFG_MB_UPD				0x4
 #define   NFP_NET_VF_CFG_MB_UPD_MAC			  (0x1 << 0)
@@ -30,6 +31,8 @@
 #define   NFP_NET_VF_CFG_MB_UPD_TRUST			  (0x1 << 4)
 #define   NFP_NET_VF_CFG_MB_UPD_VLAN_PROTO		  (0x1 << 5)
 #define   NFP_NET_VF_CFG_MB_UPD_RATE			  (0x1 << 6)
+#define   NFP_NET_VF_CFG_MB_UPD_VF_ASSIGNMENT		  (0x1 << 8)
+#define NFP_NET_VF_CFG_VF_ASSIGNMENT			0x6
 #define NFP_NET_VF_CFG_MB_VF_NUM			0x7
 
 /* VF config entry
@@ -67,5 +70,8 @@ int nfp_app_set_vf_link_state(struct net_device *netdev, int vf,
 			      int link_state);
 int nfp_app_get_vf_config(struct net_device *netdev, int vf,
 			  struct ifla_vf_info *ivi);
+int nfp_configure_assign_vf(struct pci_dev *pdev, int num_vfs);
+int nfp_net_sriov_check(struct nfp_app *app, int vf, u16 cap, const char *msg,
+			bool warn);
 
 #endif /* _NFP_NET_SRIOV_H_ */
-- 
2.30.2

