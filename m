Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED8568EAB1
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 10:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbjBHJMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 04:12:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbjBHJMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 04:12:25 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on20709.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8b::709])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BD346702
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 01:11:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WWeHkZXG4Ni9ioUvteVKOlzDAapI+n53RB/AiBSPDl7cT6gVN49BSDA/PaapTM0YXan+7pE9VryqJITPURBekne2lPw1OxPtnkmgDffPLGh8FtjWbL3hIV+AahMbMMEef5is2SEP5XeNLSelsCl+D0MQizzWEzZrEM9UfIA+5Qbl3qU0ce9/5txo0THnGpjXuunNdqCPIBsp99KVtKw/4jHzNFuAvClRiF+avbmOQb05WzbjdU5XWK4/ZXUoQabpH8oSga9zZYNEGrwqjXTkoBFi/zAyHa1veq4YNlTAC25tRXnYSmx2c2LgU7o2wIzrL1FO2mFNzq/SxZDP8sxlYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DGUmlVejMkYNvdm5Cxn9ACZuwcqwL/ZmszVZxojO7Cg=;
 b=L94NkbA42vw6m/cZcgBIOxFNP6Kv2DYOOX1je8bTfGZ30XXR2CWqNc5d68S2rhPmB0BWCHMQ9tLactU6YvmK9F2Dd2gZV+xIF5aM14fZxBarHySEJWA7duyUIokXSYTKY6rMqd9E8uGV40/DarO+lYLjqNDelUNTIhByDGmKx2/TlOkdvhs2P7YI0iz/y4x+01DkiyuD4rbX/hpn5VsTGnByDFETwAQbRchiAiGG61DGah3kB8ZOx95FQA53qTdIh9G+Qxod1uixTCFS1mjTcpz1D7OBdtk3/fvWjkiM0DjU743k3DIdKj4UuszkjCUsDZeFzlI/mGeJb7wrJL6/wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DGUmlVejMkYNvdm5Cxn9ACZuwcqwL/ZmszVZxojO7Cg=;
 b=v75vMmPUEWqzrJJgd6Qm8OXytlDJFJaepxgoTU6uqACChar/UKt/ZRUFX/byZ9kqLWuG/1eeaJlvBewglB84I9nwVXk5R19M7pnch4EcNoPlic/kE4/Ed1kQDWgazFG7L53DkUxwsHMf2W6y+lxi7sNv1skLOPxBvg5HLKKAIe0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3710.namprd13.prod.outlook.com (2603:10b6:208:1ed::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Wed, 8 Feb
 2023 09:10:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 09:10:28 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Leon Romanovsky <leon@kernel.org>,
        Chentian Liu <chengtian.liu@corigine.com>,
        Huanhuan Wang <huanhuan.wang@corigine.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH v2 net-next v2] nfp: support IPsec offloading for NFP3800
Date:   Wed,  8 Feb 2023 10:10:00 +0100
Message-Id: <20230208091000.4139974-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM4PR0202CA0018.eurprd02.prod.outlook.com
 (2603:10a6:200:89::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3710:EE_
X-MS-Office365-Filtering-Correlation-Id: 8809341c-8104-48ce-7ea8-08db09b4524a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mbthecswQPSkOG/7XRRYhT6SwAvCBV7Ywm/du/s0mEX6a2fCcuTQp7z9Jcny/52SaLppWwILFaxCxIIUcXvNHqS0yruUX1NEBVKKuEZjtmGZ4D7kYYXCJOEJRm7e/fmnetsm+OtmA1yeKvaXmkVkwB4dv5VOkpZ4gYQ/TmcLqOOwwi5QD8M1VzOP4u7njXXRjLEGE9TEGe19sCF5+k25EfBGLk5gyy04nKoNdRk9o9dAS+j2TKDcb7YxCmJWWgT+ppe8kDmMbZ8AbcLAu+Axgq2KbJaebVQJ0onbyX1Ku7hVmbIas09VODjFk+NKqVS4AI/7X6YNNPhkC+oTF2YUbpI0kzHetsejsxK0G18+3iZipCkbD/iYpWHjx5vHYNG9fpuHpHmVf1FJrJ3NkML3IK6tZe9j0/359pbcWIvhn5ncM13GDRvGRUXUjDWEYbRdpjSwszAtlC7wWsyZwP1TRAXXRMi9TRe6ZwHNUGtaJAFyVJUOQft4B1Eg1GnIDijvUyWXT//5T/+wqaBAbfyKhYkMqmZNK3y98nMW0NKk7gObMCwLWKleUqFUbzHvoUEDCT6lxUvB3RZThfTV8pRwaMCRI3oF/2N1HM9wDcuYCVO84acoZlEx2jGJPjc6+kK2pO8tNqR+NVtKx2MOtzhBMCbAaW9ozIPGbcOeL2UFEByfma0AGCJuEzqUCrQSWYolpjJhvV8WEMsxP9F0wFZ+zgkkgavlcctLMrTKXPqizuOJ9+taLT1SwYCMtq4Gea8o
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(366004)(346002)(39840400004)(136003)(451199018)(5660300002)(44832011)(36756003)(2906002)(66574015)(83380400001)(1076003)(2616005)(38100700002)(8676002)(66946007)(4326008)(110136005)(54906003)(66476007)(316002)(8936002)(41300700001)(66556008)(6666004)(107886003)(186003)(6506007)(6512007)(478600001)(86362001)(52116002)(6486002)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZjZuWC91U3d3S0RNcU02ZkFFVXBNSzRTeXJua09VSFcrRUg5NHVwdGlYcTMw?=
 =?utf-8?B?WjJjYVpnZHNSUTFlTjdLd1hkQ0NrNnhPRnV0eE9YUTFUN2VWSXhpUVhHUDlz?=
 =?utf-8?B?OFBoWlo3SnRMUzIzeWNlbXliT1dJeHNFMjBGK0puYlhlbWozaElLNi8rVU8v?=
 =?utf-8?B?T2tqM0R3YVVwOEVQNi9yS1JDVi9NQUZDb05yaEtCSUtMRGRNTjlwNFBqTW1X?=
 =?utf-8?B?TloxWjB0dFM4ekpwdUxMZzJvaERmWmxJUDFYK3JvUGd6bzRMNTNweUIzWnV2?=
 =?utf-8?B?V0ZpVjlkM0o4VnZPUXBmK2ZWVUJGbnJZV2VxRU4vMXFUS0M3VDNtSzZXMnU4?=
 =?utf-8?B?cUpaRmo1UG13VjdiQ2RZaE1kWS9lZlBLb2ZrZ1ZidDA1Nnkwa05WVDg3Ympx?=
 =?utf-8?B?T1gwYS9uWVRzNjBGeDRKUElTOS94RUNMaUJDR0ZGSWFnbXh5RTcxd013RXdQ?=
 =?utf-8?B?TXVIZ1l2dUpBcVl3c2JlcUtaT3FnaHg3NFBseFdDSGJtaUdtWXZxRVhoQ2Vh?=
 =?utf-8?B?RFFXaldpWU9JNGtSMVNydGxiWllMUG0ybWV6RGNWNVlsMnpUWSt3MTVKQ3Rv?=
 =?utf-8?B?NXp3TVRyQW81TElMdlNocVZMOVg0a3RGMGdmNjR0SXpPc0pKb3dtWkVlRlNq?=
 =?utf-8?B?aGpWYWptdTljNVZ5NWU0NFpkdUZDek0wdi9DR0FUSktCYnJHekdUUEVrekVO?=
 =?utf-8?B?UlhOUUdvWUxTT2tyNkgrMUw1OE1aRVpIRi96MFNENlFkY3g2NHdPNUQ5TlFY?=
 =?utf-8?B?Q2MwSnhTM2syamVteWJHb2Nic0ZXWWd6OFBXT1ZVNHJsenFwY3M2ZlhMNEhx?=
 =?utf-8?B?NEU3YUwyeWd1N2JHOGZDaHEvRlRRNzFtaU5NVW1kczNiTWk0Ni9sa1lOeXVx?=
 =?utf-8?B?Q3lPY3lZT05kRTlYeUQwU2pnQURaY2hEME1nYnFWMzFPaG4za1RobGxaZ1BJ?=
 =?utf-8?B?bTl0LzZ2bDVTK3NMY0VxZkVkUnVvMlJ0YkgvOWFJT3BnSzhseWtSSEI3a1Nv?=
 =?utf-8?B?aVpUbm10eXdxamRDcjlJSGl3T2NhQW9pckZSbXVkZFFoMDhBd1BNejh3RVpD?=
 =?utf-8?B?WTZoVnVIRFQ2dTdVOU41cldHWXBhVTYyQ21iR2ZQc2tNTW9DdXp2Wm55dDhB?=
 =?utf-8?B?d0NDYmZhSmo0eHpWMEFhNzRBYVFxcU9TNm4yOXdiWUY4Yll6ZDBJNlVHL2dE?=
 =?utf-8?B?OGt2ekNyNXdWWDlVSm93b01nRzVUUHdQMVBjYktBVE1SWUY2ZXczeXpQdTJn?=
 =?utf-8?B?bjlTK09DNVVtQ3hyMUpPSXgvbzMvQWxtY08wRnpuZU8xWm5lbTlrbDlqUWJJ?=
 =?utf-8?B?OCtTOXZBVzNiU1hmY0xmeE1nNkZZREJtNkhHOGovTTVXaDEvMEY3bTNNWkZj?=
 =?utf-8?B?YnpRVXZjOXJiZ1EwaTRXK0JhcUpSMDNLamtNNUUxL0dhcGtlZFkyZVpEVG9l?=
 =?utf-8?B?eWdCUDREMi9hS2JHbkNnSUN1Qm5ZbUZYZnBFOTVwT2ozRVpFNUQ1REJsUkF1?=
 =?utf-8?B?N2o3ellwU2wyODU3MjFKcUdYT092d3JNcWxaZS9jNE01Ry9LYWlCVCtzb2p6?=
 =?utf-8?B?RkZTWVlmSmZCNTBMZVV0Ulh2MHVWSjExVU05U3BROEVjb2pRNnJxbGRZcGlu?=
 =?utf-8?B?aXVReFhpdy9WK2hDUWo3dy9qcnlMbFpFckdSWERldkl2TnVZcndmYkMrZGx2?=
 =?utf-8?B?Q0FZcG5Ca2s0MzBPRldic0VJT004Tk9HaE5sUVNkUVRkRW5RL3RXMnhJNmxD?=
 =?utf-8?B?Q2FDQmVmb1c0YzZDWFVSaFdFdlpVSERCRTR4U2Z6Mno3VFYzUk1IcmRiRVNX?=
 =?utf-8?B?Q21lZklDNm56ZmdPSWVQU0FHZXBCVUVMbTR4UzBUMlBMOEF1VnRNSFNFWndL?=
 =?utf-8?B?RmlXd3o0aGNJZ3h2MTJINGw4alNHelROcmJxT2FRQitjRmNKTTA4OTNEMFFI?=
 =?utf-8?B?ZWRNN2c3aFZRQmFvWXJITzcvT2ZqVjVlekdiWnhZb3NJR3poZFFaNzVvNksx?=
 =?utf-8?B?alNJakZveUgyL0QwQkxVSEd6eEVTYU4reDF6R2gvMGdpNHgreE9ab3JhaEdm?=
 =?utf-8?B?VzVlZzNYcE1Vc3R2OXp6cUxyZWNFS2V2SlFxU2dHM2pTdEhOWUhUREVWYTRZ?=
 =?utf-8?B?U0FiMGs4clBxRllrNExRTWw2eVdvbER6dkJSeVphajNKQmRzUFphWVY4L0hr?=
 =?utf-8?B?OWpvenNuL0RRNFFPQXFWSlRkVWNiWERLOW41RThUY0s2YVhhWHVuUUdUMXc2?=
 =?utf-8?B?cVFOZUtVQ05tMnU4M2tlemdUeXBnPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8809341c-8104-48ce-7ea8-08db09b4524a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 09:10:28.4621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fmHBwPUKNdWIEkiS+sbbPyNNOIJfBEoBqpCbG1m5mOwrX8dVK4ffw28RodbrP0g8PbTSuc8b1cmEdJlrn2sx/dFHIn6Irw94TkipcfasYeU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3710
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huanhuan Wang <huanhuan.wang@corigine.com>

Add IPsec offloading support for NFP3800. Include data
plane and control plane.

Data plane: add IPsec packet process flow in NFP3800
datapath (NFDk).

Control plane: add an algorithm support distinction flow
in xfrm hook function xdo_dev_state_add(), as NFP3800 has
a different set of IPsec algorithm support.

This matches existing support for the NFP6000/NFP4000 and
their NFD3 datapath.

In addition, fixup the md_bytes calculation for NFD3 datapath
to make sure the two datapahts are keept in sync.

Signed-off-by: Huanhuan Wang <huanhuan.wang@corigine.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
Changes in v2:
* use NL_SET_ERR_MSG_MOD instead of nn_err in nfp_net_xfrm_add_state()
* Avoid using boolean values as integers
---
 drivers/net/ethernet/netronome/nfp/Makefile   |  2 +-
 .../net/ethernet/netronome/nfp/crypto/ipsec.c |  9 ++++
 drivers/net/ethernet/netronome/nfp/nfd3/dp.c  | 11 ++---
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c  | 49 +++++++++++++++++--
 .../net/ethernet/netronome/nfp/nfdk/ipsec.c   | 17 +++++++
 .../net/ethernet/netronome/nfp/nfdk/nfdk.h    |  8 +++
 6 files changed, 83 insertions(+), 13 deletions(-)
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfdk/ipsec.c

diff --git a/drivers/net/ethernet/netronome/nfp/Makefile b/drivers/net/ethernet/netronome/nfp/Makefile
index c90d35f5ebca..808599b8066e 100644
--- a/drivers/net/ethernet/netronome/nfp/Makefile
+++ b/drivers/net/ethernet/netronome/nfp/Makefile
@@ -80,7 +80,7 @@ nfp-objs += \
 	    abm/main.o
 endif
 
-nfp-$(CONFIG_NFP_NET_IPSEC) += crypto/ipsec.o nfd3/ipsec.o
+nfp-$(CONFIG_NFP_NET_IPSEC) += crypto/ipsec.o nfd3/ipsec.o nfdk/ipsec.o
 
 nfp-$(CONFIG_NFP_DEBUG) += nfp_net_debugfs.o
 
diff --git a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
index b44263177981..b8bc89fc2540 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
+++ b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
@@ -10,6 +10,7 @@
 #include <linux/ktime.h>
 #include <net/xfrm.h>
 
+#include "../nfpcore/nfp_dev.h"
 #include "../nfp_net_ctrl.h"
 #include "../nfp_net.h"
 #include "crypto.h"
@@ -330,6 +331,10 @@ static int nfp_net_xfrm_add_state(struct xfrm_state *x,
 		trunc_len = -1;
 		break;
 	case SADB_AALG_MD5HMAC:
+		if (nn->pdev->device == PCI_DEVICE_ID_NFP3800) {
+			NL_SET_ERR_MSG_MOD(extack, "Unsupported authentication algorithm");
+			return -EINVAL;
+		}
 		set_md5hmac(cfg, &trunc_len);
 		break;
 	case SADB_AALG_SHA1HMAC:
@@ -373,6 +378,10 @@ static int nfp_net_xfrm_add_state(struct xfrm_state *x,
 		cfg->ctrl_word.cipher = NFP_IPSEC_CIPHER_NULL;
 		break;
 	case SADB_EALG_3DESCBC:
+		if (nn->pdev->device == PCI_DEVICE_ID_NFP3800) {
+			NL_SET_ERR_MSG_MOD(extack, "Unsupported encryption algorithm for offload");
+			return -EINVAL;
+		}
 		cfg->ctrl_word.cimode = NFP_IPSEC_CIMODE_CBC;
 		cfg->ctrl_word.cipher = NFP_IPSEC_CIPHER_3DES;
 		break;
diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
index 861082c5dbff..59fb0583cc08 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
@@ -192,10 +192,10 @@ static int nfp_nfd3_prep_tx_meta(struct nfp_net_dp *dp, struct sk_buff *skb,
 		return 0;
 
 	md_bytes = sizeof(meta_id) +
-		   !!md_dst * NFP_NET_META_PORTID_SIZE +
-		   !!tls_handle * NFP_NET_META_CONN_HANDLE_SIZE +
-		   vlan_insert * NFP_NET_META_VLAN_SIZE +
-		   *ipsec * NFP_NET_META_IPSEC_FIELD_SIZE; /* IPsec has 12 bytes of metadata */
+		   (!!md_dst ? NFP_NET_META_PORTID_SIZE : 0) +
+		   (!!tls_handle ? NFP_NET_META_CONN_HANDLE_SIZE : 0) +
+		   (vlan_insert ? NFP_NET_META_VLAN_SIZE : 0) +
+		   (*ipsec ? NFP_NET_META_IPSEC_FIELD_SIZE : 0);
 
 	if (unlikely(skb_cow_head(skb, md_bytes)))
 		return -ENOMEM;
@@ -226,9 +226,6 @@ static int nfp_nfd3_prep_tx_meta(struct nfp_net_dp *dp, struct sk_buff *skb,
 		meta_id |= NFP_NET_META_VLAN;
 	}
 	if (*ipsec) {
-		/* IPsec has three consecutive 4-bit IPsec metadata types,
-		 * so in total IPsec has three 4 bytes of metadata.
-		 */
 		data -= NFP_NET_META_IPSEC_SIZE;
 		put_unaligned_be32(offload_info.seq_hi, data);
 		data -= NFP_NET_META_IPSEC_SIZE;
diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
index ccacb6ab6c39..d60c0e991a91 100644
--- a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
@@ -6,6 +6,7 @@
 #include <linux/overflow.h>
 #include <linux/sizes.h>
 #include <linux/bitfield.h>
+#include <net/xfrm.h>
 
 #include "../nfp_app.h"
 #include "../nfp_net.h"
@@ -172,25 +173,32 @@ nfp_nfdk_tx_maybe_close_block(struct nfp_net_tx_ring *tx_ring,
 
 static int
 nfp_nfdk_prep_tx_meta(struct nfp_net_dp *dp, struct nfp_app *app,
-		      struct sk_buff *skb)
+		      struct sk_buff *skb, bool *ipsec)
 {
 	struct metadata_dst *md_dst = skb_metadata_dst(skb);
+	struct nfp_ipsec_offload offload_info;
 	unsigned char *data;
 	bool vlan_insert;
 	u32 meta_id = 0;
 	int md_bytes;
 
+#ifdef CONFIG_NFP_NET_IPSEC
+	if (xfrm_offload(skb))
+		*ipsec = nfp_net_ipsec_tx_prep(dp, skb, &offload_info);
+#endif
+
 	if (unlikely(md_dst && md_dst->type != METADATA_HW_PORT_MUX))
 		md_dst = NULL;
 
 	vlan_insert = skb_vlan_tag_present(skb) && (dp->ctrl & NFP_NET_CFG_CTRL_TXVLAN_V2);
 
-	if (!(md_dst || vlan_insert))
+	if (!(md_dst || vlan_insert || *ipsec))
 		return 0;
 
 	md_bytes = sizeof(meta_id) +
-		   !!md_dst * NFP_NET_META_PORTID_SIZE +
-		   vlan_insert * NFP_NET_META_VLAN_SIZE;
+		   (!!md_dst ? NFP_NET_META_PORTID_SIZE : 0) +
+		   (vlan_insert ? NFP_NET_META_VLAN_SIZE : 0) +
+		   (*ipsec ? NFP_NET_META_IPSEC_FIELD_SIZE : 0);
 
 	if (unlikely(skb_cow_head(skb, md_bytes)))
 		return -ENOMEM;
@@ -212,6 +220,17 @@ nfp_nfdk_prep_tx_meta(struct nfp_net_dp *dp, struct nfp_app *app,
 		meta_id |= NFP_NET_META_VLAN;
 	}
 
+	if (*ipsec) {
+		data -= NFP_NET_META_IPSEC_SIZE;
+		put_unaligned_be32(offload_info.seq_hi, data);
+		data -= NFP_NET_META_IPSEC_SIZE;
+		put_unaligned_be32(offload_info.seq_low, data);
+		data -= NFP_NET_META_IPSEC_SIZE;
+		put_unaligned_be32(offload_info.handle - 1, data);
+		meta_id <<= NFP_NET_META_IPSEC_FIELD_SIZE;
+		meta_id |= NFP_NET_META_IPSEC << 8 | NFP_NET_META_IPSEC << 4 | NFP_NET_META_IPSEC;
+	}
+
 	meta_id = FIELD_PREP(NFDK_META_LEN, md_bytes) |
 		  FIELD_PREP(NFDK_META_FIELDS, meta_id);
 
@@ -243,6 +262,7 @@ netdev_tx_t nfp_nfdk_tx(struct sk_buff *skb, struct net_device *netdev)
 	struct nfp_net_dp *dp;
 	int nr_frags, wr_idx;
 	dma_addr_t dma_addr;
+	bool ipsec = false;
 	u64 metadata;
 
 	dp = &nn->dp;
@@ -263,7 +283,7 @@ netdev_tx_t nfp_nfdk_tx(struct sk_buff *skb, struct net_device *netdev)
 		return NETDEV_TX_BUSY;
 	}
 
-	metadata = nfp_nfdk_prep_tx_meta(dp, nn->app, skb);
+	metadata = nfp_nfdk_prep_tx_meta(dp, nn->app, skb, &ipsec);
 	if (unlikely((int)metadata < 0))
 		goto err_flush;
 
@@ -361,6 +381,9 @@ netdev_tx_t nfp_nfdk_tx(struct sk_buff *skb, struct net_device *netdev)
 
 	(txd - 1)->dma_len_type = cpu_to_le16(dlen_type | NFDK_DESC_TX_EOP);
 
+	if (ipsec)
+		metadata = nfp_nfdk_ipsec_tx(metadata, skb);
+
 	if (!skb_is_gso(skb)) {
 		real_len = skb->len;
 		/* Metadata desc */
@@ -760,6 +783,15 @@ nfp_nfdk_parse_meta(struct net_device *netdev, struct nfp_meta_parsed *meta,
 				return false;
 			data += sizeof(struct nfp_net_tls_resync_req);
 			break;
+#ifdef CONFIG_NFP_NET_IPSEC
+		case NFP_NET_META_IPSEC:
+			/* Note: IPsec packet could have zero saidx, so need add 1
+			 * to indicate packet is IPsec packet within driver.
+			 */
+			meta->ipsec_saidx = get_unaligned_be32(data) + 1;
+			data += 4;
+			break;
+#endif
 		default:
 			return true;
 		}
@@ -1186,6 +1218,13 @@ static int nfp_nfdk_rx(struct nfp_net_rx_ring *rx_ring, int budget)
 			continue;
 		}
 
+#ifdef CONFIG_NFP_NET_IPSEC
+		if (meta.ipsec_saidx != 0 && unlikely(nfp_net_ipsec_rx(&meta, skb))) {
+			nfp_nfdk_rx_drop(dp, r_vec, rx_ring, NULL, skb);
+			continue;
+		}
+#endif
+
 		if (meta_len_xdp)
 			skb_metadata_set(skb, meta_len_xdp);
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/ipsec.c b/drivers/net/ethernet/netronome/nfp/nfdk/ipsec.c
new file mode 100644
index 000000000000..58d8f59eb885
--- /dev/null
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/ipsec.c
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+/* Copyright (C) 2023 Corigine, Inc */
+
+#include <net/xfrm.h>
+
+#include "../nfp_net.h"
+#include "nfdk.h"
+
+u64 nfp_nfdk_ipsec_tx(u64 flags, struct sk_buff *skb)
+{
+	struct xfrm_state *x = xfrm_input_state(skb);
+
+	if (x->xso.dev && (x->xso.dev->features & NETIF_F_HW_ESP_TX_CSUM))
+		flags |= NFDK_DESC_TX_L3_CSUM | NFDK_DESC_TX_L4_CSUM;
+
+	return flags;
+}
diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h b/drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h
index 0ea51d9f2325..fe55980348e9 100644
--- a/drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h
@@ -125,4 +125,12 @@ nfp_nfdk_ctrl_tx_one(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
 void nfp_nfdk_ctrl_poll(struct tasklet_struct *t);
 void nfp_nfdk_rx_ring_fill_freelist(struct nfp_net_dp *dp,
 				    struct nfp_net_rx_ring *rx_ring);
+#ifndef CONFIG_NFP_NET_IPSEC
+static inline u64 nfp_nfdk_ipsec_tx(u64 flags, struct sk_buff *skb)
+{
+	return flags;
+}
+#else
+u64 nfp_nfdk_ipsec_tx(u64 flags, struct sk_buff *skb);
+#endif
 #endif
-- 
2.30.2

