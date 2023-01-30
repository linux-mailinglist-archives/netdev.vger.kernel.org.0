Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA21B681A83
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 20:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237463AbjA3TbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 14:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236074AbjA3TbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 14:31:09 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2040.outbound.protection.outlook.com [40.107.104.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646AB27980
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 11:31:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iBbGbc1wfk7uJgxC9zomlvqCMWKLcTDEEHz6u6O5F/zsdolEH8uyOmIvLJ5k8ybEuwIYOg3lLNY1XjlbJ3RGtQxdL+E0xN4rFti0HttaoghZHqrEtFEKGq6zzeEPbClOYkG7m0xYgPOKXnfT8qOVAC/ASBzMNDkqDU891Udtc+LQRFepYTt/+G5cTIlUa52vSldsuekDCuJEZK+17VBnlG+SZoCn0JjjmxabtMv7ityDvExXWtIwgRqJESTr1d++rBy2JUVVjxJjKFDrwc7in27PPuZ98in6RwNLEyrW4fVtDAQfxrzn81btjUY7xHSd286ZZMjtLYAdVwcxBsLpNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4La/EAD/hKMd+CyXpErUY0PauJke5dGbDQBcAt0SwbU=;
 b=KvJgKKJdaUTCeoj0kUhVJNl7JmqpyWaMQbhXf6BPSLy3laAFzvInwB+/u3SS9O+Nbwztr3Jw4tnTvmk/svNKH3FhJJWDaEfxDRH1Sw4X+Ol952qxJajEvI+PrFF73TPNRSwUKntsJwLv087inrRy8VlVfSW8DBSVU3Gr/C5wd/YFDSE9xyZRIGQ8PPHwbx4grIVLyM/3vxrlFG3sB5YRgDKIVSxU1fMAC+sIMA/YCooZXgIJPtzfncQnBZC5rc3dSlpoScM452mLNnuEuFPrBwnswflx5Wo4mc7OwnasfYjKexqLhdoT+yHxvnStOmiz06dO5TkCFxl+R7yHXOItGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4La/EAD/hKMd+CyXpErUY0PauJke5dGbDQBcAt0SwbU=;
 b=ULP1GcRPA3Opn+nRtOyaCpH9f12OBoprYsI1OOWSlPP6ReqnufwrKNVn022sftcfYk6cpVwU+BRSkO6TJ+ihQXWdg2nJwv/0ESaV/CZHBLuKJbys6EXZ/tHzOUDA518Fln+1hx6IA2KRESgF1VxQDI4/lFkDS56HO8fbwBHtRI4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DU2PR04MB8616.eurprd04.prod.outlook.com (2603:10a6:10:2db::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 19:31:01 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730%4]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 19:31:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: [PATCH net] net: fman: memac: free mdio device if lynx_pcs_create() fails
Date:   Mon, 30 Jan 2023 21:30:51 +0200
Message-Id: <20230130193051.563315-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0185.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::18) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|DU2PR04MB8616:EE_
X-MS-Office365-Filtering-Correlation-Id: ab4b51cb-a6a9-45de-c2d6-08db02f88505
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uRKBBN/wscgo7d16A4MV/yjMfGaAvaGWFMDZPsYl4/EN+9d65djf84C4A4zsbI+oXmZcOu+iw/d2C2ueo6kgFFGKo4Fdgq020ua0Pv1+ZfwF8sKUzik0USnrmDZIT4orP9u+zwe56shOYcfchlvnc6cZyraxhzo2PfmbxNltp/auABhkiLrrmJCLopXsh9AMQ59+4mOim1TMHiOKi2H/oPEwTKDUsZj3iQ28aNM8E/0X6bQ+I/PxiEHlUpyuIiWh38f45DXCXqgWJEhEQJGFEcQfhvUM0Q+Nmr6njV8Y5g2O4Tvr2XOqCrlY9oKBq05BpoJdaJnGFS7XUQ0F5ejjV8h7gcqE/N/CmL5JNVGAT+suE/Iv/xqR5U9/XdSsAzv+JirhFP4/GZwOKuvi/AnmowSeNWUbNCNwLraLXVgQXjpQOVVO0JyNmU17FwNAdqOhoNF3DCsWxRW0OWpn7rp/L7YlU07/kZb+ZlKVxL88EqQzNNk1cc05blYUNqGfdkfv7Cp7+5ZdYSh9PQnYtyRJH4xbGox56ZyVPXiE7SW8ccQlqsj8Oz7KDfcyNZ1u08JFuYUWfEBoejORK6ZLJMFrgr+DZQ3xzelitRQAuNAsRBsaEfaXXYmnTGLX0KvsAwW6tkh1uDcLydyfu0Knw6Wn0fnU24oHJPOsLhwDRBgsZSnCnnsIDUiBQ4vM7eu5Kz54LjPeIqiwseAwJDKVWGRtCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(346002)(39860400002)(396003)(366004)(451199018)(6486002)(1076003)(6506007)(8936002)(478600001)(2616005)(44832011)(36756003)(86362001)(4744005)(2906002)(6512007)(6666004)(52116002)(26005)(186003)(83380400001)(5660300002)(54906003)(316002)(66476007)(4326008)(66556008)(66946007)(6916009)(8676002)(38350700002)(38100700002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uZIcAieszXTZFy3WtYoz5R05XEJla/tPk5o3p4yPmFtxAN4+3uFv68GlT/0A?=
 =?us-ascii?Q?Ohwi/95OKc5m9z6Mr7rTYuDescxNlbGwMzg4vj1sZRH90swkI39BTtIk3kuM?=
 =?us-ascii?Q?Ir7n2dWkbGLIIfN7qzqwrHorkLmzUlbt+dHtEQVPN4WRmaeRrDKw16dyHtDb?=
 =?us-ascii?Q?cP3+rdqWqdrcdfDiK4FmZyOcl/HCxoSsGGdPqE/In3b4GKLiZUCA6enqG6RH?=
 =?us-ascii?Q?Zb+dk+F8rSzlrx2MgDP5hiZFMRHMeY599A8QWF0lM50+A27SoLgLTA016SiX?=
 =?us-ascii?Q?1l4FIAzefs/nTxc74LSFjGkcMz2w81zccHAP/GxFs/NUQdMp0+WmO4lRaj0M?=
 =?us-ascii?Q?TlPb7hl4iDKGj0TXOJ5R0rtLqx5y0gsy6IgTkWDkkergQUPt5kr8GDbX4EVp?=
 =?us-ascii?Q?MRJj2cAT51B9h/VrnOe+AB56hj32GJIT5Ge7rEdvrI0yROl7CTV8qgNyoyM5?=
 =?us-ascii?Q?on6yfgJ9QSQJfatolDKeV0KiSJFwq/tIz5s30mvGp32tNPdSWsWNJjJUfAGI?=
 =?us-ascii?Q?efkzoMDm2mKRTcES0BDDNXlSDWjC+nz1bepgUp4HXHCCqq+o9zDrYEpwgguG?=
 =?us-ascii?Q?O49QgthPxT0rRA723wbxkPn17OENzCTcczRkXE39GxEM2iBkWwlvQ4f0qQ3J?=
 =?us-ascii?Q?EPj5zmfKHZdYpM+xe01z0YZQsFi1tw6Hb5ZzlflPsibL/xJsFk93JbVL8qa+?=
 =?us-ascii?Q?ZgFtoXMSeqKeB497BdldQG8kQJBWEHf8JU85UjVxHhL90VIJpouTXcW+QQFB?=
 =?us-ascii?Q?45haSc5g03ECCrjrFNrSWnlLvUhVUUIgQMPOzjkzo5sj+g59lUFBPpOGgbEt?=
 =?us-ascii?Q?SFhMiP+BfbTs4xkOys10xlJyIN48ZQg3WHNGSDvYS7s3ZbKKgdqim9yWLV/c?=
 =?us-ascii?Q?DtGqRQhw176HzLiGYKbOley/pRbyCWHuGgQVp/lUYTgv8b1IIVf/Tv/aLFd6?=
 =?us-ascii?Q?rPAqIP5jdW8r4ssSYzbWJMP7GWKZzTVulASHfqo2Z+V2GhXS7r4+aRvEHs78?=
 =?us-ascii?Q?fi1tJ11/+EjdJiVvSR2W2p31m2peS9MlGy+RA/aQ0/x6bTt7+b1BmQdu2/vz?=
 =?us-ascii?Q?uhv4lRRfsHxRsSpvi6UJkwPLw8Kb2bFPXXyIipTd+jeAwyPOhvQA9NreAJRp?=
 =?us-ascii?Q?yK4exSB93dWQzAG9r/jC8u+5UO5UaMawacvwxNfsQGT1oLFPEetWqlv5XNhG?=
 =?us-ascii?Q?E2HTFBh0gTjs/9nxs2Z0ki9YCEx9rPO9Oo9RVqygbxLSm1Zv9Wdl0mBfrV1w?=
 =?us-ascii?Q?AvdPpWVzUuKGlPmfhf6/Dx/VqpstuJURyAXAFszMRGPSK5Ms9x6i6lDVhYx4?=
 =?us-ascii?Q?BsHU3OuRznNTBiBUQxKgeeJuG0yxhsieWAM0iP3FRCmXp1WHbbBQ64Ck8Z59?=
 =?us-ascii?Q?oIMmcEskFNFYzzmMJYrGJj43fA7VIWbKzfLdA3pNBMK8gfyusPuFmTU2lLfM?=
 =?us-ascii?Q?oRHWykVGZvil9yBHqAWq+LWOUDhDAB1/3GkuJL6/jbMinl66e3YmxZ/AjtRr?=
 =?us-ascii?Q?SWmWqcNh7zcMMHSKo4JGom82aWObqTyypiVA/+iIrCTGDCnxgOanPwJ5yT4G?=
 =?us-ascii?Q?AoH21bYSwoyWbVUzuGellU3K9SjAVbGLhVc1jaDj4lIS9wvsXCNCmRTx5SBu?=
 =?us-ascii?Q?4g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab4b51cb-a6a9-45de-c2d6-08db02f88505
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 19:31:01.2761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H6YjYJKLW/MzjxTCD9BEPyp41j/t7x25XXG1pJAjwsM412GFxvrDcfU+EnO/9JfSTJXstLb/lWgGtMFVkCnl6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8616
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When memory allocation fails in lynx_pcs_create() and it returns NULL,
there remains a dangling reference to the mdiodev returned by
of_mdio_find_device() which is leaked as soon as memac_pcs_create()
returns empty-handed.

Fixes: a7c2a32e7f22 ("net: fman: memac: Use lynx pcs driver")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/fman/fman_memac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 9349f841bd06..587ad81a2dc3 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -1055,6 +1055,9 @@ static struct phylink_pcs *memac_pcs_create(struct device_node *mac_node,
 		return ERR_PTR(-EPROBE_DEFER);
 
 	pcs = lynx_pcs_create(mdiodev);
+	if (!pcs)
+		mdio_device_free(mdiodev);
+
 	return pcs;
 }
 
-- 
2.34.1

