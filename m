Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82324233F66
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 08:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731507AbgGaGq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 02:46:59 -0400
Received: from mail-eopbgr80047.outbound.protection.outlook.com ([40.107.8.47]:50639
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731351AbgGaGq4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 02:46:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MbptyMmlxASD8yne0MAoeZA83ZXMvECbXdgsW+SphlEy5L5pc0vtvq6K2M8x57ZfBiyUz6C1WAL9ccR3BS1Wr8q1xqA3ajQXLvj1z04p7N5/S97peIWevhRXoWCpaeZQ1lAax2Q9vEJdNMHxYmuqjdHu1AEJOXGYb6qChmKP9RGyd1hO1TBWqFmL3a9jDYhkaAdVTBIAsdk8l05n+Lfn7MBWo4+wYUMK9jaK6T2htLg2T4SjsUHdmLLuEfFgCIUAlaVikletsN89QAuPuIepB72S2Qt1ldJk85xv/4tOaTZKh6vCqn4c+Xl0yVs+tOURrPUSc6upFPdRrbait+qQNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u5cBx1oXIzt1s7VrjVH/78iqviUUrr4v8mgMpeaFfJE=;
 b=NuOXOKO5tKxjXoHl19095K2qZZc/2hVmtfyDRIKNdQA/E8pLeIRLCWNgyN5aVMVBl1ovs2RMddMyeKvFhS9OHpd7PGd2Y4k5WjZhIYp8o1wSCPEzRdkfeKd5IeFDUavHFEPY4fb3yjJiuCOWi00KVxTjAL0ln8qXEa0GKQySHhqskS4DS5SHsdzKkUJJDdl7EWAWB5JiCq6AsfVaFQjywS0RZTN9hV1L9MH6MwG7iSGBSV5LK257Wlxssp6NqRohqLA38Mv0kHkAuKBR7tSnAIoD8u4EXAeKoyqrBIiFJKfAQAzzU8M472ZfFkRj1N7B5edWVreq/r5EuvMF9yBy+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u5cBx1oXIzt1s7VrjVH/78iqviUUrr4v8mgMpeaFfJE=;
 b=l605n0tA6K/2/vuzkX4Yquq2SgpHVC7NXIzMPVwR+7II8k1KBQ7PsqmzjkPe4/uNmdzeZ321NGEq7Ue6yWzpQ9iG3FUe/pxAWqlh5Qz1hw1ui8chHRYN+ETa/ZrroDPbRv+O7/iCDvf4xzxhmR/xj1rZWp7+t36A4bQiNtLsMng=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR04MB5447.eurprd04.prod.outlook.com (2603:10a6:20b:94::20)
 by AM6PR0402MB3527.eurprd04.prod.outlook.com (2603:10a6:209:6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Fri, 31 Jul
 2020 06:46:48 +0000
Received: from AM6PR04MB5447.eurprd04.prod.outlook.com
 ([fe80::e115:af36:613c:5a99]) by AM6PR04MB5447.eurprd04.prod.outlook.com
 ([fe80::e115:af36:613c:5a99%5]) with mapi id 15.20.3239.019; Fri, 31 Jul 2020
 06:46:48 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     madalin.bucur@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net 2/5] fsl/fman: fix dereference null return value
Date:   Fri, 31 Jul 2020 09:46:06 +0300
Message-Id: <1596177969-27645-3-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1596177969-27645-1-git-send-email-florinel.iordache@nxp.com>
References: <1596177969-27645-1-git-send-email-florinel.iordache@nxp.com>
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0112.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::17) To AM6PR04MB5447.eurprd04.prod.outlook.com
 (2603:10a6:20b:94::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM0PR06CA0112.eurprd06.prod.outlook.com (2603:10a6:208:ab::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3239.16 via Frontend Transport; Fri, 31 Jul 2020 06:46:48 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f9b96ca6-c5d9-4a94-2fb5-08d8351d7f9d
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3527:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0402MB3527BD2834FB676B81A6C84FFB4E0@AM6PR0402MB3527.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:475;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 11H2+THL/0IL7OebsR9SXshpAdH1YofEu8y78EuxY1Tt8gz58ZW6EGMUQ4xFvgDAeXj1LUF2ddjUPfHYprXr+stcHArBCfWOxJmNRy2MGyFkthnDqpgD535ueWoyggA55+qBi7Sa7U9godE92qOFMmbfdu/3cNYd2baIKZaL4MhhYEHRar+AMbOE6BfJoD61uucinH5O6Q13nd1aPNrrnucxmF5rXb4dyRQEwkgvpWMCxSiHqwFb+HWZ8tyq7xBQ8SqvqEkm0fCX0UuH5sC4KipqQ8gNja9EGq4iJO2bDCb0VwyptbXkas722C3I+5INR/UaMifDKKqIsAhaHPxeOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB5447.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(376002)(39860400002)(346002)(366004)(316002)(83380400001)(36756003)(44832011)(66946007)(5660300002)(2906002)(66476007)(6506007)(66556008)(8676002)(6486002)(26005)(6666004)(2616005)(956004)(8936002)(4326008)(3450700001)(16526019)(6512007)(86362001)(478600001)(186003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: As77zo9NwbjO4WSGcrTEZ/3Br3Jf7C+JHN8bFnW8Owx8y7f4LFoOoGtkpZy7eeXc+ydD5YZDA5Iv9PwgAiTb9YMfXl44gpT+Cu/mLO8WM67b0D0R07tsKsT0vgBoX8iguAjho3LngozN9XXgnL6H4VqYVA2jxk7Xwm25XVNsHJ1ey/pikk3TPAq6p/FGUPXRBEi5z4JMCICzOTBW57FDS4HWcLMDOHuzjX/uYPucCS+3JmYP+YyVOouj/32IfyPORZQJCOJDaCqM0xxqIGwfEUdJoVNiw+pBJkgpzvsKLFOoBU5efrwwYsDCiq1qJr0qhLSg15Ne78SSwHZbzTtS/FkmfOEijlc3bI402o6NLTneL0JJR+QFsC2S1GB7DHdegQ9WJnKDVUXjb630+/VI7pWZ6capOKJhtzDYNoc7NTtyLlm/kvjb2TOvz1hp36fP7bD8KqxgrLmCXWTXasjwVi+iq1aVFe5k2Yy57zYg81s=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9b96ca6-c5d9-4a94-2fb5-08d8351d7f9d
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB5447.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2020 06:46:48.6155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5I3wb2SPXSn9d26bQLWuVWsYcMzU44Z0O4nufCaUKu+xfXJeyrIKRWn6RovhJ8oaPH2iLDyDNi5K6X2DedWsaNbYhalJ3VwzxPh8eNkZrWc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3527
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check before using returned value to avoid dereferencing null pointer.

Fixes: 18a6c85f ("fsl/fman: Add FMan Port Support")

Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
---
 drivers/net/ethernet/freescale/fman/fman_port.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_port.c b/drivers/net/ethernet/freescale/fman/fman_port.c
index 87b26f0..c27df15 100644
--- a/drivers/net/ethernet/freescale/fman/fman_port.c
+++ b/drivers/net/ethernet/freescale/fman/fman_port.c
@@ -1767,6 +1767,7 @@ static int fman_port_probe(struct platform_device *of_dev)
 	struct fman_port *port;
 	struct fman *fman;
 	struct device_node *fm_node, *port_node;
+	struct platform_device *fm_pdev;
 	struct resource res;
 	struct resource *dev_res;
 	u32 val;
@@ -1791,8 +1792,14 @@ static int fman_port_probe(struct platform_device *of_dev)
 		goto return_err;
 	}
 
-	fman = dev_get_drvdata(&of_find_device_by_node(fm_node)->dev);
+	fm_pdev = of_find_device_by_node(fm_node);
 	of_node_put(fm_node);
+	if (!fm_pdev) {
+		err = -EINVAL;
+		goto return_err;
+	}
+
+	fman = dev_get_drvdata(&fm_pdev->dev);
 	if (!fman) {
 		err = -EINVAL;
 		goto return_err;
-- 
1.9.1

