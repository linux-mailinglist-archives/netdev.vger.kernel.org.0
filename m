Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9FCC4CD24D
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 11:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233080AbiCDKXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 05:23:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233148AbiCDKXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 05:23:40 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2115.outbound.protection.outlook.com [40.107.243.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F7752B36
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 02:22:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XTW7UoizVqJ+NjlehBAQ0QO5zyiTJHZklNW4Bh4HMC/RQWsMVWou6oWIm4X+eDBc7sJAA+NoDj8oceEk7rxXSqa858+a14osMtq6vnp0l3ML/sCbs+K3HebQ8dNx3gQCUWlx85cv2TNFO+3fGNWlhPcvZomd0QcIjcFPqbWe4ivMkgFzFETmXxocg6l8fPivbF9hpZwKcLVX2bSV70hoKOuF/h+ygbrc5qHzc4f17hH0S4ZU6OShoblDr5ApZ7Dt8lyyf/JqK1lqCtlmN1mh/MBP4alNzUwhE70qkM/g3i4mguOFbKlWGGISYMeDknYbu5MagPlh2YxUP2AB2CJpXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LheVwKJAJHbw8rOI7CD2UWqC1OpvinT+TJjCYJC6knM=;
 b=BvHslYA83J9GWKqaYZ0jzQJaEFSqPMGL/RBb+Cb5cM7ny6/Eb/SO987N5U9IJfHFOEemHj5v7NTf+NEL3Rscu+M/eZbY4ePhwmajpCtsaE/UACqYpXAlIw37NBSVZSSxk/hwyiza/GRqcWvntdolMU0fOKXwjjVxdJKg2tZGIGsWvBFSIoXCpo0wKzIsypxq7SvLQXvPMZkOF0434PdYX6VhmQWPGVSPldfi1E27Ol2jPMqb01mhRVxcPHknkkQkWAbX0I2yGGv8HH7ZD++eLfjD2OYXQdTBTaBidy7INAD2MgClSd8NGN+DDcNTQbNEH+w0BXFowzBRMRyCLl9sqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LheVwKJAJHbw8rOI7CD2UWqC1OpvinT+TJjCYJC6knM=;
 b=Xigy+drBDp8IuvgmxlglYNAV9H6kK/ZorBUAgMWWeVXWvxuYdZT1V3YV2tjTa8nNVlUlg/uT+lqty6M0GfMVoZRP2PAcDsZ/Vwq9JuRcK38Uje+wWdUTjVj4+6OIRsNs2vp51CkWcWvoj4qfP7jNQBPnihThX7S8kcMjclUEWCA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN7PR13MB2404.namprd13.prod.outlook.com (2603:10b6:406:b7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.11; Fri, 4 Mar
 2022 10:22:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e%2]) with mapi id 15.20.5038.017; Fri, 4 Mar 2022
 10:22:46 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 4/5] nfp: xsk: add configuration check for XSK socket chunk size
Date:   Fri,  4 Mar 2022 11:22:13 +0100
Message-Id: <20220304102214.25903-5-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220304102214.25903-1-simon.horman@corigine.com>
References: <20220304102214.25903-1-simon.horman@corigine.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM8P190CA0012.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f694f45-e2ee-4d90-1d3f-08d9fdc8ecc2
X-MS-TrafficTypeDiagnostic: BN7PR13MB2404:EE_
X-Microsoft-Antispam-PRVS: <BN7PR13MB240487EB0A5CF6B00BD248EBE8059@BN7PR13MB2404.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 80++RJOUVH++URZqJXMPPTIH5SlvyQ66qj1XDDzvyUbMmmu6pCCz3lzmbfOl1FdrQxzgn3ejU/GvKn+GPxICyYW8Duc5UDe/6it7fRHUrs/GVXulikit8ZFjuM4+rlnRjUtuQ+mST6xb3wuJR5+vBwfnjbB3L9KvJoRgV8oIZqm4rwwtZUXv0SyR2lsICnefvzv+RC1Jny984h/iAfiP5aVxsbPHMDW0D2BDnNgSuuEUn63DuESJ3EI8yA6KrO/5wO69KB1EVPEKk0qrVoNzXT0+/JaJHBALUPwrS3t50EKUW+KumzzvmcIyyWwkCThMfZ2+IEzkYBB0bZYhyMAxhzyWy19ZYYA7iex79UubGWG6fNkjHANTIroLeBQTlIkGjUoHLcS/LVjoCTIK+C+KCjXhA8oyvuzouYEZKP9NQwYsSVbGTsYRKgxvowOWmbMFwBDBuSThftS8rhYCF9Ux46qO68KSdIAHqZ8punebT3L6JF9bUysA8evFjEYGE4De9M3lsFGZRCWDg5rkj3i1jM2/spaFklDiytU6UjihWe6RkjEoCNIYUG1hV1MXBTeuW0CU2CJqpxwYAlpgtE07/ZuSP0gsOwANuml60FDcJTYRK8KMoJLadR9oWiaK8pGx0I/ozpmeE7DS6gjzEBcnMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(396003)(346002)(136003)(376002)(39840400004)(110136005)(316002)(86362001)(4326008)(8676002)(38100700002)(52116002)(66476007)(66556008)(66946007)(6666004)(6512007)(6636002)(6506007)(6486002)(508600001)(8936002)(44832011)(107886003)(5660300002)(186003)(2616005)(2906002)(1076003)(36756003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aHFKZEQ2Y25BbFdLWXdSemRCRE1IWWtVclBWRTJOTmJRMkhaQld5L04xOEhu?=
 =?utf-8?B?TzliZGxqNDBJby82MzgyZzk5WVVnMWprMlp3bWlqd1hqOUF4RVR4cWhGYURB?=
 =?utf-8?B?V0doWHRWcTBBU3phWUVLWFRXSFNNd2wrdVBlOGY4VzljZTlKQW8xanlwU1E4?=
 =?utf-8?B?RXV1Mm8wVEkrVWM0MC8vbzVkV3VJQXkwaks1c2xkcWRFODMvZE1vR2lkWml2?=
 =?utf-8?B?NVFocFpaMGE2R3hEd2RmbXArbi9MTkJUUDZqdklMSXEvSWhHZ1o5Z0JydGZq?=
 =?utf-8?B?MWJqMTYyWEtIaWVIZmpiM3E0VW5qZExzbVNKSUFQV1lhVGswRUk4bEtVNGRL?=
 =?utf-8?B?YjdHSGQvK1c1MDdQaFZ6dVVWdmhTaEJtbHZQQ2tCSUE3cExuVklLVklXbG9j?=
 =?utf-8?B?eFo4OHFRQWo2NFhTQnpFVGdMbSt3Yi9nZUpSU0ZEd0I3UGpCRHRiMGo1TjVL?=
 =?utf-8?B?RlFJcVRNblc5TVBkeGlpM1pObUo3cGhIOXpyRGc3OGRjYlBpdWh1dXg2VkI3?=
 =?utf-8?B?QTJ3LzRydVVERmswODNkblU3dWFWdklLK01FMU14K01PbFpJWk1SazR5Ung1?=
 =?utf-8?B?QXNtZFJHRzh1a015VlRMT25YSlFEUlNxMUcvS0NpUUVCUmF5WU1FZityM3B4?=
 =?utf-8?B?ZzBzNnNFeEFpR2l3SnFMRXZabzZoYnFXYkljRktVUER1dXhuS2FUZnJvdU5W?=
 =?utf-8?B?bHpKelA5Vkd0VXhhSk1SNXd1RFZSYmJSQWZaNzdvNWpGM1E2bXdCd0svUk55?=
 =?utf-8?B?dzRtcG9XM0hkdXJXRW1PL0lSRFdtWEZIVENkSmNheEszRFVRSWowdHRiOFU3?=
 =?utf-8?B?MlBjV21kNEVOdnVBeGZoMkw4YzdoL3hzVWsxZGRxbnRGR1FTYlNNTmdDUCtu?=
 =?utf-8?B?ZXBtQUwwanFJOUR1M3NqZm9kU3JRRUw2Z0F0dU5pcmt5M3RHTHVXd3QvTVNZ?=
 =?utf-8?B?MC9tRHRwdFFGQUVVSmhOeDh4UFd1My9FVW9rRXJWZlJyTHRSbS9IRzAwOG9n?=
 =?utf-8?B?MDJXNXQwVzZoOTRJWkY3cE9EODRKVktZUnp2a3ZHM0IzckVUWFhoOTFHRDcw?=
 =?utf-8?B?eVV4eVIvZTVEVHE2Mk90VGVIeHJGRjhwU2V0NjEyWWxlOTFKN1JBd0UrMnZa?=
 =?utf-8?B?VzdGeGNjRTdGL0Y5ZDdjcDNEZjVtSGlxOE4zTXFoYVkrYTBsRktPQ1g1T28z?=
 =?utf-8?B?S1lRanRtaGQ2K2NTTnM3eUJBUmVpeGRsS1ZzbXFXUGFtMHlZRkFMRDE3S1ZC?=
 =?utf-8?B?VHZJekYrTHhzVkZWZFFyeW9wS0N4S1VsV2NWbjk2MmIzOVhobU53YTBsZm53?=
 =?utf-8?B?akV6SHZOZlptM0pRL1dUclhrbXR6S0ZsUFZBQk1nclZNMklvOUM4TXQ3dTcw?=
 =?utf-8?B?UFdQN1R6QnlERGdscHRBazFSd09rVGVzbU1YWVNnMVlzY3dqa0JYdHZzeTVW?=
 =?utf-8?B?UjBQdHBOTFJacmtsMkRhUkxEVUkxYys5K0trM3pMUXRRNURPQk04dkJCWDhG?=
 =?utf-8?B?QkFDMVdIWkE2cVhEcldwYm5JN0sxZklBUEhEeGovS3B2bEtIZDFSUytWRnll?=
 =?utf-8?B?bm5jVnBISFlXSlpQL21aMWVDb0FtTUFmbzhZVzBLckhXNm40U01xcGVtTk1K?=
 =?utf-8?B?c3dCc1lCRUNaK0ttanduMTludTBGYmVLcVRmQlc0b1pmeDlqR3hDMVBjYVcy?=
 =?utf-8?B?ektqci9tUnlIZUVuczYwS3RIWnFGT3I5YUpueFZjdi9ZS1cvaHdiKzBBSTNk?=
 =?utf-8?B?b3ZDeU1ENXU4Q2FSQmcvK2VGRUIrckcwOVArM0x1Z3lxNU5oc1FWQkhPOVZ1?=
 =?utf-8?B?QnkvZHE1ZFhIOFhFUkVvM3VvMEkzOGJZUjFSTDhoQUZ3Tm1LVmNYdU5MN1hq?=
 =?utf-8?B?M3pIN2d0dmVTbXplVVdFOXBGZXMwb0o3SWFjeGM1WjhXVVNUanB1aGFEZHo4?=
 =?utf-8?B?d09KTmdmZ1p2WGVpdXNtcHNvK0hRZXZCdGhNY1lpL0d4ODZpZU5FNW5nb1Za?=
 =?utf-8?B?ank0TGNrRGFPczY3UGwvSmxGNTZ0aTJsSmhSSHVLNTJUZm5VZDVJRzhRY0JM?=
 =?utf-8?B?TDRqMnlDWlQ1endFelpXejJZOFN4ek8vYjB4djgzcXE1OS9tY3NKdmFhaE4r?=
 =?utf-8?B?UzJuZDZIekk0bzVVaVE1SEU0eFg5cHZMTzFBQ1BtQ2srY2pOdEY1ekdoa2Q4?=
 =?utf-8?B?M1lFT2I0Y2RPWHRxUjJQM3hZTDMwbCtRaGxLZzJSRWRhZTc5V0VrTmUvQzQw?=
 =?utf-8?B?RVB1ZXJ2ZHBiNytWSk8wMEJzTkpVVVkrS1ZsMEpwYURuVjFDUFRUWEhNQk1j?=
 =?utf-8?B?dzIrR2VHMFJNSE9mTndnQXRDU0NGTDlSYXh4bFc1WmlaL3pvVjFpSFdNNWEz?=
 =?utf-8?Q?MGu4fvCLay7RDQLI=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f694f45-e2ee-4d90-1d3f-08d9fdc8ecc2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 10:22:45.8629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CRDvouFA5FL3CqQVDVr+JfKLj1sBi2EL1HXKerWxb0cvCBcN9VXC761ommo9Jj8qm3Z/o+dpnH9AMiwyow6n9pWy7rbiJHpAUp10QJoQ41Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR13MB2404
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Niklas Söderlund <niklas.soderlund@corigine.com>

In preparation for adding AF_XDP support add a configuration check to
make sure the buffer size can not be set to a larger value then the XSK
socket chunk size.

Signed-off-by: Niklas Söderlund <niklas.soderlund@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/nfp_net_common.c   | 42 +++++++++++++++++--
 1 file changed, 38 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index abfc4f3963c5..c10e977d2472 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -38,6 +38,7 @@
 
 #include <net/tls.h>
 #include <net/vxlan.h>
+#include <net/xdp_sock_drv.h>
 
 #include "nfpcore/nfp_nsp.h"
 #include "ccm.h"
@@ -1338,24 +1339,43 @@ static void nfp_net_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 /* Receive processing
  */
 static unsigned int
-nfp_net_calc_fl_bufsz(struct nfp_net_dp *dp)
+nfp_net_calc_fl_bufsz_data(struct nfp_net_dp *dp)
 {
-	unsigned int fl_bufsz;
+	unsigned int fl_bufsz = 0;
 
-	fl_bufsz = NFP_NET_RX_BUF_HEADROOM;
-	fl_bufsz += dp->rx_dma_off;
 	if (dp->rx_offset == NFP_NET_CFG_RX_OFFSET_DYNAMIC)
 		fl_bufsz += NFP_NET_MAX_PREPEND;
 	else
 		fl_bufsz += dp->rx_offset;
 	fl_bufsz += ETH_HLEN + VLAN_HLEN * 2 + dp->mtu;
 
+	return fl_bufsz;
+}
+
+static unsigned int nfp_net_calc_fl_bufsz(struct nfp_net_dp *dp)
+{
+	unsigned int fl_bufsz;
+
+	fl_bufsz = NFP_NET_RX_BUF_HEADROOM;
+	fl_bufsz += dp->rx_dma_off;
+	fl_bufsz += nfp_net_calc_fl_bufsz_data(dp);
+
 	fl_bufsz = SKB_DATA_ALIGN(fl_bufsz);
 	fl_bufsz += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 
 	return fl_bufsz;
 }
 
+static unsigned int nfp_net_calc_fl_bufsz_xsk(struct nfp_net_dp *dp)
+{
+	unsigned int fl_bufsz;
+
+	fl_bufsz = XDP_PACKET_HEADROOM;
+	fl_bufsz += nfp_net_calc_fl_bufsz_data(dp);
+
+	return fl_bufsz;
+}
+
 static void
 nfp_net_free_frag(void *frag, bool xdp)
 {
@@ -3331,6 +3351,8 @@ static int
 nfp_net_check_config(struct nfp_net *nn, struct nfp_net_dp *dp,
 		     struct netlink_ext_ack *extack)
 {
+	unsigned int r, xsk_min_fl_bufsz;
+
 	/* XDP-enabled tests */
 	if (!dp->xdp_prog)
 		return 0;
@@ -3343,6 +3365,18 @@ nfp_net_check_config(struct nfp_net *nn, struct nfp_net_dp *dp,
 		return -EINVAL;
 	}
 
+	xsk_min_fl_bufsz = nfp_net_calc_fl_bufsz_xsk(dp);
+	for (r = 0; r < nn->max_r_vecs; r++) {
+		if (!dp->xsk_pools[r])
+			continue;
+
+		if (xsk_pool_get_rx_frame_size(dp->xsk_pools[r]) < xsk_min_fl_bufsz) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "XSK buffer pool chunk size too small\n");
+			return -EINVAL;
+		}
+	}
+
 	return 0;
 }
 
-- 
2.20.1

