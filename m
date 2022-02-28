Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 879194C6195
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 04:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbiB1DNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 22:13:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232766AbiB1DNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 22:13:50 -0500
Received: from APC01-HK2-obe.outbound.protection.outlook.com (mail-eopbgr1300113.outbound.protection.outlook.com [40.107.130.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA2742A2F;
        Sun, 27 Feb 2022 19:13:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m4MswJj314youmlAHTVGF5VqBZfr6h0iI52etfIEXngL7UI1tCH8n0mYipgyK5uHENsrBDr3oUkmHumsvbe2yWUwf7f6u8FUg5MOHSlQabHPxrcrPoBUDV2lVm4ChXqv5TtyaKNwkxLilFsYt+rL5G28IYFxIe12bV/+ZWAAz1PFV2jkSpEnWInV62a7ccbK7/IK3cVNlSGwUit3BY3jdpOFONbdBHO8JQnOJ+Q8S4boWKMxMFHlCdHB3kNLhE8tBqyKpNi2IYZRglIWHdJ+5OwM0Hn0eEUQfpM50h9DOvNftc0aQsN8p56pAgY8aNEsk3yr5MbP21UIvCDsvOgrtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rMB2oUJB1pQKAvgcKhgxZaXL8U1bm9/NLONwUUSOMOg=;
 b=lF/IRB4YITKmU48qATOgXKT6N2zFVs+5LQCbe4f3AabrHhuyr+X6C5qpCoeRg1U/b2MWfmhDOvg9ULO0MnhHimZPt+aDXv6zWBqkuJvB2tj6iJVLYsUUGLwPzjI9sQIVIbQUGJiGUgIrxfhT0wrdUzDWe99yRCeC2Z8TK2fdrawYL7MYFnMXOnHjrOlbGZqNCmaQheJOBW3lWDU9Jz9qZh5NuN5pJcJwjANWQBOgntYugaCmCNV4Pivgxauyb6rFuBuI3AXPNDE6wIxZ2a+cc4d202bBYMLmfRv1cy4nbA9hG+ffFctXXOy6F1MOW7VtalMIzD0x5gJGd8kYZO4iEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rMB2oUJB1pQKAvgcKhgxZaXL8U1bm9/NLONwUUSOMOg=;
 b=cqBTVnLn6ZnhQTOBhHKCTtsNmnHgZlbiycyqSqLFOnp0pJZbI/C2JxunWtNQriLD/Dr0genM01fv42ZoefHQyHX/3weOX7IquokRKm6GLEUiSFjBfbWXzH2Ah8SJ76AQd+6BwJPrcGSCCJDfDzYMuR0RFAtcqGPO4B92g2O6uKw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by PS2PR06MB2454.apcprd06.prod.outlook.com (2603:1096:300:45::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23; Mon, 28 Feb
 2022 03:13:09 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::49ef:baa:8c3b:cb3d]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::49ef:baa:8c3b:cb3d%5]) with mapi id 15.20.5017.026; Mon, 28 Feb 2022
 03:13:09 +0000
From:   Qing Wang <wangqing@vivo.com>
To:     Shahed Shaikh <shshaikh@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH] net: qlcnic: use time_is_before_jiffies() instead of open coding it
Date:   Sun, 27 Feb 2022 19:13:00 -0800
Message-Id: <1646017980-61037-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0209.apcprd04.prod.outlook.com
 (2603:1096:4:187::12) To SL2PR06MB3082.apcprd06.prod.outlook.com
 (2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2acc3ea9-9598-4e4b-e512-08d9fa683f4a
X-MS-TrafficTypeDiagnostic: PS2PR06MB2454:EE_
X-Microsoft-Antispam-PRVS: <PS2PR06MB24542A8A0B5B1E9B5F0AF97BBD019@PS2PR06MB2454.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sW/NZVfFAGpY/V200+qaqKuJWURa5XKXalXrOEZWEPBDpLyMTaMiplyDovUONGROO8PjGK1LBz2+XUYgaU33arcvSe+ZmiBeL+DGpsCBpC3/3NuHejG3Ud4FYK+1027u9666+++XjqE9xrNZVYROMpKQw3nk/Ca580Ms3Fc6ZS5OO/N3HRSo16oR3cTZ7VOzHh3WDYGyBoYLA6tP0GjHfpYbe+eIpgolqZ/mlwwFc3o68dGQZ3dPG3sfD+vEvNjhdxmLA6RUMGmzjROi8Bfm6sBPCrWGaQg8zRWxx0HHUAAd2l00Eau9wtTSHnFHyChVE9aE/BOf3hg2qcsKW0/MZmQBjPoCENvZNeWbJiphzJMpOLnuGpJm0tKk4iERXi80XxJwaulCjw7BWorJ9i+NSUVN8f+istHkYIb5k85f49H4gIWAUZVbW4WnTSoJYNebz+Bds9dA4AyNWQbnfj90pxUx6VURVSLRPxYkVkqXL09DwcD7dgQHrf/0hK8UB+CSxboST5RibxOHURpO3Y0t+H70jp+L5Jv4KJgJ3K/GrsL/uYMKMjZDQN4hcRIm+74/2naTk6lrVjwWNLmhOO/htXsWdyGARFAQaNAOa1Ryb/OtMFm0UQ3AMTe8hDgdTEuBxSSGuLJhjNs9YYhdZ8DmIcDopWf5DpEr2w/vv7JJUVHnsnfBFaNELOGIMv0Kvb3S455Nek9Zbdc0RBGeXw2i3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(66556008)(66476007)(66946007)(316002)(4326008)(2906002)(86362001)(38100700002)(38350700002)(8936002)(52116002)(6506007)(6512007)(8676002)(186003)(26005)(107886003)(2616005)(83380400001)(6666004)(110136005)(6486002)(508600001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gA7qVaZelIr+Ew2oiSeQx/xQ132uplBiTG6iFloLzSSW2KTvI2/i0RGdxt0t?=
 =?us-ascii?Q?riVNEB2S+WqLkR8PtWTsqFCSlw0DcNK+cGvuqJ+3foJj3ooaR7sCnM4Vkuuy?=
 =?us-ascii?Q?nrQFjjMscsy2uQrjE79vE0XXZxUnRm0VMsUiPz9OoTMBu7UCSPodirz8S6/V?=
 =?us-ascii?Q?9PwEILgFCz3nEWKaq5PlNHbvx8HCev9SDq/gbikHLXvFVHpOvYCBYogKTF/m?=
 =?us-ascii?Q?OLwt2DsYwt8QdoNp3Mpg2lJ9yvOPS+8+zABCUT97ZAShwbkmNfr1m6yDeojy?=
 =?us-ascii?Q?Tq3k2v4/ROX1gv1xb5NzMyGxiHZ6SsiqwX8qGQE/7CF1e92+dLPY5BII9u6F?=
 =?us-ascii?Q?rbqyKoAom+O7Omxf3j41aFL7fta+MC70dLZP/J+cJoxjMDdaiHthof8nNpSF?=
 =?us-ascii?Q?RQ8RRc783IqKOyR0bFsLz3IkloyREGUP5KTuLpj+Pi6/vwaI1gAlMi+ifuoA?=
 =?us-ascii?Q?RR/UwH5+fmKvedsOAIwKtU20TBFz7wQ0XpH0HI9D1pwseDOxLEwVkUCqscxc?=
 =?us-ascii?Q?rAvzBZ02YvzyB/pvMnwl7flxz3XvAQsAtI+KeYUs4iHOhB9wW2RjisYFozV3?=
 =?us-ascii?Q?wm+2fW7z6fvVpC27TPeOATOUSa6qnrVxuGc8oIfNWQ/iC6S3b5FhPBmYZleW?=
 =?us-ascii?Q?zpa17TgrM1WK3zugUI+E559xECljiC/MGOyKc9YxFDexzeAhoJOU/OEdL3bm?=
 =?us-ascii?Q?KWunR3F6GAXBqfjezS7UVjYF0cqGFG5fdKwW2yBRwBT+BbGCarKA+vmRA1nh?=
 =?us-ascii?Q?kwCz0g3GeCtqZM41isnTMLSOF4LawnXBU5Oz69eS4uoU9hOZs52Nxv9hUaJ7?=
 =?us-ascii?Q?dQcuFccOMtjtqO8hv4jPL68GYpjZZgHOg/AMcri72btjH6Sq+i6aR9k9vTXL?=
 =?us-ascii?Q?BtDRkRxzIT5nHGvgVpoiZNK1xt5z/B7ZQ+3UTYFRWCmiknsin2tex4Cj8RmU?=
 =?us-ascii?Q?cZcQ51btiGz278bUNeMk+zpeQRH1qwS8a5sf7HHO3WwruwsS0uiC32N/u6rG?=
 =?us-ascii?Q?J7JEWO1AxNnXnXy7KdP80/x+hW2kc8zrutssr0iVYA3CFVcHfQzIrXQhy9bQ?=
 =?us-ascii?Q?kwKHG8OAbdKqRVHQGGWEL4HCcfxK9/TNrnZuVHiVpOtyUTKA+B+eR8JhMBYh?=
 =?us-ascii?Q?g5FQeU3zVqhNfV3o4AgavYLFKhpt9qf4mWg/33+WqxsGjUhm0kabUt4f0SIw?=
 =?us-ascii?Q?7DNyWxAzmvmv+EiZbdVTyTzPkKffmPOgA0J2Ta2r2SCaaaJmdC2DeCCyae/+?=
 =?us-ascii?Q?/LDTZ37O1tPhFNHD4kEKLEvb1xaTLPLRqc103uVB58sILvvPJbS3X6LG0WKF?=
 =?us-ascii?Q?zL0pFSOdVPfh0lVLQB8erbn7gK9bDL5DQ4AAIrAn8EDOQW5fhzdj5K+ZvDX1?=
 =?us-ascii?Q?DEMvAzPEkn7FiLNIy9fO4sxFLoXeHOaH2WfSQKVSvXDarRK8ySFwbzq3gkzs?=
 =?us-ascii?Q?VOYkZlSy+jxpUNkD7HLIL09HzZZWhbFzCn8AIibupNTDOm0cnMLVAUy9LQBl?=
 =?us-ascii?Q?JVgu+EHYy4kUSJneML2RvKTGlhySp/3cAXU1SrdT0ql5cXE2MGVHFE8C7k43?=
 =?us-ascii?Q?+Ik6Sc4iT8jnngWSwXxPK3XToqmHqwGJAqW78RXvni1n9RHEjECILuSC0B26?=
 =?us-ascii?Q?C4Mi376mYB1J/X7HGhqFirk=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2acc3ea9-9598-4e4b-e512-08d9fa683f4a
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 03:13:09.7238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fjLAprKpRSJ2gFH3m98BknMlcE/nyVv6FYgAkM8kVjryg3qJiZt26dGeKQb1ze6QsBVf/mYmW2vqnuK8bf3KLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS2PR06MB2454
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Qing <wangqing@vivo.com>

Use the helper function time_is_{before,after}_jiffies() to improve
code readability.

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
index 29cdcb2..bcf3746
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
@@ -10,6 +10,7 @@
 #include <linux/ipv6.h>
 #include <net/checksum.h>
 #include <linux/printk.h>
+#include <linux/jiffies.h>
 
 #include "qlcnic.h"
 
@@ -332,7 +333,7 @@ static void qlcnic_send_filter(struct qlcnic_adapter *adapter,
 	hlist_for_each_entry_safe(tmp_fil, n, head, fnode) {
 		if (ether_addr_equal(tmp_fil->faddr, (u8 *)&src_addr) &&
 		    tmp_fil->vlan_id == vlan_id) {
-			if (jiffies > (QLCNIC_READD_AGE * HZ + tmp_fil->ftime))
+			if (time_is_before_jiffies(QLCNIC_READD_AGE * HZ + tmp_fil->ftime))
 				qlcnic_change_filter(adapter, &src_addr,
 						     vlan_id, tx_ring);
 			tmp_fil->ftime = jiffies;
-- 
2.7.4

