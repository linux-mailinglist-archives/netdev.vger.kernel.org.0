Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 784736A7F88
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 11:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjCBKD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 05:03:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbjCBKDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 05:03:13 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2103.outbound.protection.outlook.com [40.107.92.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DEFC3B3DF
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 02:02:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JUV8S2kvdGlbQZrOIbNondoE14gfoUEx0dYzGK6AOAUuoKWgPHGsr1vGaL6vwuSTmqWppBI30GBaeesquOVa+egVuhCelLTsCE5JoizUlnKmtu2Wuvo9tNRGK/X9pfI/q79lb9w+ckuThSVT6LuxXilFwPdiCk7p9uL7p4udZQOXcF9CWBrlyZIb+qN4vwoc2L2RcUJF35PUnnX79LZ3+fD2iIakJfdWH0nGRvGHJbpAtGkmHoaxQNtoLCIsrEEB6z7B72NUxRzAaWDPVKSWubiOeUtJA5c+6FSeVl23tJHiRNliKI5Er+6wtwQ9OnjqOYWVSRGEOxYRU7lQPkHCAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w3AGYHwqHDlP4ts4sQ+R0AXMvdpk1u25Eg38SMf1zkk=;
 b=LAytyjxieDB2HZzVpRnJVZXV8ruQupue+XKInNRfNFQRlzpNyUynkXgKcqQ8AJuuySp+nDjBF2obdgaIHPLu154cHGWwexUXun9mDIaPo+y5n3IViHTsutQTTqQr0xRVvUfr9iiio9obPtPaGMLTRoWuP4DuZ8IZJhtG6Ux3fzWTdhAOF+jjOln/BDl2A98xm5qfms4rcGkVMqInqwA+zrY/f8E7GiM087crbjEL+Md/B3X2aWidmvNgvOdgvaPRj+o6wE3w+wVApG9OjWfvhJHsRfnSQEaOCXN6x5q2OeV88ZABAqbAj5qYujKGTrT6Iva/h/73H+cNazR3znRaEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w3AGYHwqHDlP4ts4sQ+R0AXMvdpk1u25Eg38SMf1zkk=;
 b=IiQAVh6B3uMCj8VMriZLS40s48jntSJQhfyXmCAWRPpRWHsPzmO0lEYY+fez8PmAimi044nwL+8IDBdB3rG+PlRpQPD4WP1p6NZtjXPmTkZkltbki6q0RMDdmp+XA1+5HH7CB/0ce/dl47OGrDbnIoVMiy4SOY9ly9SqM9zG7ts=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5692.namprd13.prod.outlook.com (2603:10b6:a03:407::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.18; Thu, 2 Mar
 2023 09:59:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6156.018; Thu, 2 Mar 2023
 09:59:01 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Huanhuan Wang <huanhuan.wang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net 3/3] nfp: fix esp-tx-csum-offload doesn't take effect
Date:   Thu,  2 Mar 2023 10:58:30 +0100
Message-Id: <20230302095830.2512535-4-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230302095830.2512535-1-simon.horman@corigine.com>
References: <20230302095830.2512535-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR10CA0008.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5692:EE_
X-MS-Office365-Filtering-Correlation-Id: b0d8e91b-6c2b-4c5a-b1cd-08db1b04bfb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kXTOmNL/CjHmDQdzSXLXypkI2wu58VRsduI9r2kiEZp1if4M/L55N1W5zAm7bSfNavPva7DiYWN+AGnwHBUC7f/NMPfyBRIRwVjH3VEW4/A7Qf8w+Ma4VKwLPM1wBpaDxigQqy2DgVVGhN9JkK36Q844Sjz0VkdvARg6RbehrUTNL+OG4bmUoK1IT/NTi9SNEbZOE5WgyE2ik2LWmeVSliSiFaWVkU3ppc7JSXsGWKsbxY9yfyw5Bqy7/Y5VNECmlkWA9FFuwzY5wgxqSnO0+GAUKneA4Fbl/H8rYGN2XCDaWQmZc/94L1kRRZ7AXLOvbSyRNHxI+w5q0eMDrZYGdY4lyPictLqzRGWzyLQ30RKQo0TgMb2gyTnvqthkcrSjk/1YwcIzZxWpoOvu8qLAphN+6YTfw8Q7U6/Cn5giO8wZd8oSht8TSlbCXwfKCnwk29EBC5qKZFppgpmZke5odBeQu5V95lkwOlxK1xId2n4ENe/tKuOwKWQln4z8DraSzAbgHB/VCYvo93/2ANoP5ECtz3PjqQ6/O9P5kxa7u9Z4YBsQK4O7gIVK90zgUxtPmpqE8c308tn6fGE93OuCqIXMS5AwxpFQ4yclSlX2ixn7qhjB1xkoalJygLpZFeWCtcmTlcJYB+/vlbctRc2yUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(376002)(396003)(366004)(39840400004)(451199018)(5660300002)(2616005)(44832011)(6666004)(54906003)(107886003)(110136005)(52116002)(38100700002)(6486002)(478600001)(41300700001)(186003)(36756003)(6512007)(8936002)(6506007)(1076003)(316002)(4326008)(86362001)(66556008)(66476007)(8676002)(66946007)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t0tMNiOmORINtnGS9uAaCAa/ZILfaF595FcDCfXfagzieRXuHGgWmYgqRi+G?=
 =?us-ascii?Q?xHmoQarmJgypOBrY+petxss0vcrCHP+wyZaSLmt1+8XJuLZTA3gnGDfCqG33?=
 =?us-ascii?Q?wD4yGlM2kYrEthuyIjIoxOALKSZsOs3RhqQSyY4eXOJP7shvtfC11zfbvdhU?=
 =?us-ascii?Q?iZSWPHhw+cfuK97FXtVPgBIaU7dyHzp7OiRZ3nKWuSQsBaNgjCg0TjhwcZUG?=
 =?us-ascii?Q?Z1fz3gigkNNFJt5PMTWnmwo7eX+S/o3bn6cRKdT9ooSG7ap2ybb6wZ/VICIj?=
 =?us-ascii?Q?Yd5zBXP/nA62WKpEO6D9KWKpOLmPM/HM/dA5B9CVXZSXv3XaG5lUsVZXlsnJ?=
 =?us-ascii?Q?dE6z/9O2T/UqaEBpZnU6zwSrBTWYMVBh7ApfQP2n50+YodcOqMl6xw8CbOpL?=
 =?us-ascii?Q?hwqhKpPBwNociL+vg12ggZ/XS1yfSDDYp991p9Wj/PrDhhylB07lqANKnBYv?=
 =?us-ascii?Q?kG+MB8tW8pmaECK6kjggoPVihX5irLqNCCATtTb9mUqhdrEWD6gH58MiUaPx?=
 =?us-ascii?Q?A2zrRCLHuYtuwObZJ2nKPvpfw966nh3MJ/tcoROOi1ntEqfjbfrzgGPZozSG?=
 =?us-ascii?Q?JryrQpSwnQLeKGOaoqBO0sZvnyZyrDZUFBZuQV/3nHmOQP0XHOKfvXSTj/EY?=
 =?us-ascii?Q?pWW9IvZqpcvMtQ5BE9OmVoUJZxqXWs0ivXsfFBJeQ1MPLM6wE6ncyfBJqAng?=
 =?us-ascii?Q?NkVtAiDc5TjDPCfHGl+RsXnTkQHkXqY/8/ARZOgV0ffoueUu4PAnVe2PKifL?=
 =?us-ascii?Q?oUvod6eE4HsaFWmtQm9qcO/SVv4BO9iJwWCWWL+/8nLMJh1g+Ou6nh687HX5?=
 =?us-ascii?Q?zVs6qBq1L2p4EjFQvMwoucIXBP3Svpo+efXjZ5goBFmv2iiBUEnBNjnmnzBj?=
 =?us-ascii?Q?mBVEwb3qd41EPn9BCIBC3dE9EP5/AYpy1i9iRImaHBfD2DiJBFxaF3+PxZFJ?=
 =?us-ascii?Q?IlFDeAhXcXYss/qjqGLRJSXhkgaaSBPize6KZMcE6HtOY8I7FIzd4zY6FMsP?=
 =?us-ascii?Q?csJWgLjQ87FNnvyl5bGUs5s+iNRcLUtykMHT7m7cPLc78uTPMyiPsRHDnyyq?=
 =?us-ascii?Q?MQeNsEHwxdRcX6iBKV/5cMokTnU/emWqqsiQDyZ/+IisnB34607zVFbG8lHp?=
 =?us-ascii?Q?bdjO5yJxpqeqd1AbdpTQD3xhh7vnr5LD1FJKjrs3+JBi6A1o8YnIhaP0pR1y?=
 =?us-ascii?Q?0ZN5MIx2/fUF4uUoYmv6Ajuqv76NrTNdSzJyoV1v9Ag5EblhEjuK9cisKf2Q?=
 =?us-ascii?Q?b909HzU4TdmX+1YKkhmaVr35NVM1MDUBwxLo/KFcFbY+5Z4z/ZGSvwBRahOW?=
 =?us-ascii?Q?95DZrodSL7Ct9UjSevlglFrWZmFqprMG3oBLE+/2f41f7XepRDFEC51xwUif?=
 =?us-ascii?Q?HOWmgtkfvEjjqccQ/yChunZOmF0nn0sI6A91nu5/FgIzuY92BsZXZ6z/Ga8n?=
 =?us-ascii?Q?RKTuJmI3V1QEL2wUrOaeahn2yXTUeFg94IVbAUMuU1WYlTUHdEeAqXINxxtQ?=
 =?us-ascii?Q?AXWvI7ErCUVGF8rvM8atEQmp0QCZYhPwZcaf9B2rcK41nh1HNE9ATcep9eaK?=
 =?us-ascii?Q?j8oFfmhIGNXo3fmmLeatA0KoQkhJXV9TmkPJ3bjYAq8A/Mrzh/dF7xow5tMX?=
 =?us-ascii?Q?d7DWyu8Gs/14dXsgmNl0Q1pqw7D8ItIXVbriA/FBccuBc/F/jNloBeuNVVRI?=
 =?us-ascii?Q?1VSUGQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0d8e91b-6c2b-4c5a-b1cd-08db1b04bfb5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 09:59:01.6356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AC/+WurhuNdGOkoVvypcjRx4yjCH+LzasUcsrE/i0XhX75aFA1CThURB5x4Nr95ePd4kJf47ngkPTI1yvUPyAWUxW8zNkKzDm5Qwyb4slWc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5692
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huanhuan Wang <huanhuan.wang@corigine.com>

When esp-tx-csum-offload is set to on, the protocol stack shouldn't
calculate the IPsec offload packet's csum, but it does. Because the
callback `.ndo_features_check` incorrectly masked NETIF_F_CSUM_MASK bit.

Fixes: 57f273adbcd4 ("nfp: add framework to support ipsec offloading")
Signed-off-by: Huanhuan Wang <huanhuan.wang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 81b7ca0ad222..62f0bf91d1e1 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -38,6 +38,7 @@
 #include <net/tls.h>
 #include <net/vxlan.h>
 #include <net/xdp_sock_drv.h>
+#include <net/xfrm.h>
 
 #include "nfpcore/nfp_dev.h"
 #include "nfpcore/nfp_nsp.h"
@@ -1897,6 +1898,9 @@ nfp_net_features_check(struct sk_buff *skb, struct net_device *dev,
 			features &= ~NETIF_F_GSO_MASK;
 	}
 
+	if (xfrm_offload(skb))
+		return features;
+
 	/* VXLAN/GRE check */
 	switch (vlan_get_protocol(skb)) {
 	case htons(ETH_P_IP):
-- 
2.30.2

