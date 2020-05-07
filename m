Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B2A1C87EC
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 13:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgEGLUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 07:20:05 -0400
Received: from mail-db8eur05on2074.outbound.protection.outlook.com ([40.107.20.74]:6034
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725893AbgEGLUE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 07:20:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h1zTZ12Qz1bQJS4TAbV85kizjhUbqGvmWBOHDbFHSJrkcItPKCELX089DRYigVhbDn0KDnYjM5ry0CneLi8jxeKMNYegI76jrbo8g/SOR4HPKU7FiBSg75BXgue3gYG9j13/EanhoqS5pNRmak/z/p1tyPEBNpshfgNVcUU23zgrKkYuE3oQnnz/eK3iYgKr51cq8GQeLM2ZZQS9e6k2h3iu4dPmV70YDad10kLSdL2RB/jmYXGWqQ0mXoGNP+4sXAesP91CVCwmNnppNTHtl9fZFtkb842sgI5SnYlJb7Q1EotTwtoQs/r93dPoj/1ipLRTWb25q645LHbkvp3p9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pxESHQTuITx6QIsVbB5cR7thnQX+JdHLMPEG//ICSXo=;
 b=g/Z/JkhdVx58EBdMfoF8G2+XG0MNhKiyplZ8+4bvp35eUOTa/Oslh+/gBOhaMAkl717YXAt7duv7E6xLTIHHEyL+llKs8oaQMq94UWglK583B4jE7l5S6ElWFM4SE9hQl55uGPCAKH4aepEMkFb0rFqqIG+IY91CQdD7aJ02DvjA7abMRdtnkmjOtDtCtMKx7IDAPaU5iFZkv/6QeidBstRLebhfUhTduKQVCFqRFWlYZ34MLJOBY9YMUgC/5ZdgO+h3f1BZ9KqNer/5WSI9rYJUtgSa2M0PgxiJ9LHpJro7P4FPBGx1RdBnlHtAjSFI2l/85rQ9fxMZcM1z2Ubqlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pxESHQTuITx6QIsVbB5cR7thnQX+JdHLMPEG//ICSXo=;
 b=Y28Fkkb90NuGKfFZg1/Wich0+wk8xch3pHX+JNy7Te3kA2+GhtIs15UBCIeOZZApudwk5Isxi80uAhQfnOzwWlQE9Aet9wwZY4maOJ3uXIxUoyRXpqh5sVjhFgLXSW63ZVtnElTv3fxifDMV+c2iMddp0v4tpTom7gkc9RqdToI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6416.eurprd04.prod.outlook.com (2603:10a6:803:12a::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27; Thu, 7 May
 2020 11:20:00 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173%7]) with mapi id 15.20.2958.034; Thu, 7 May 2020
 11:19:59 +0000
From:   Po Liu <Po.Liu@nxp.com>
To:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, dan.carpenter@oracle.com
Cc:     davem@davemloft.net, claudiu.manoil@nxp.com,
        Po Liu <Po.Liu@nxp.com>
Subject: [net-next] net:enetc: bug fix for qos sfi operate space after freed
Date:   Thu,  7 May 2020 18:57:38 +0800
Message-Id: <20200507105738.29961-1-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0049.apcprd02.prod.outlook.com
 (2603:1096:4:54::13) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by SG2PR02CA0049.apcprd02.prod.outlook.com (2603:1096:4:54::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Thu, 7 May 2020 11:19:56 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8e42c3b0-b276-46b1-1807-08d7f27893e6
X-MS-TrafficTypeDiagnostic: VE1PR04MB6416:|VE1PR04MB6416:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6416B57F9B5BC54B2243B53692A50@VE1PR04MB6416.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:923;
X-Forefront-PRVS: 03965EFC76
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bLexLgFKzMtkyU/1vRcpkUN6v0Itzj2G/vp+QTROnnANNPlcBssfJl9ffWq/a1KPYl9x77m85LKx1lLSFz73MlXfk4usjLf64DbWHq4lVypl36vm9eG9WJUlAvER7euOblv8PWOU7j7eOEjGXWO1GZqL3Ps3tCPCUSpQxtJTyxG3/NdYpI7SJnLzlYIEkdct/PVDDCW/2aSZpYyFoNZKYtPH3Nz1vgkCyUcpkchtNUTZBO0RudAiF92fSXwRf4wZl9t7FAjfLHzOT6aR33PZhikKUKf7AglbB/bJWtj6584zs/+//Fk1PM/m/BpE9r5wzrcYO4j0VpZPXQgGUA7cHEecZ1qTBN3UePlnrqC+km5Q56rABD1ZycBboQIFjcLWYk41TuNhj4VsFj9cmZpmrn5i75lW0FEUt778Y9dkAlpt6kKGa6e3CO6lY9U6VnVoVrWdYsS4tMSWn/tsOpzhheN2z8U+zVdge0wOxpt62/4TnOJOVG8eSc2ZKqvP4cwIdRQG0GDnG9oPaegPPEDBnVtjtBU3Y4aGQ3Hot7ZINxIsKpQA4Jyiimt+ey4LBi66
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(346002)(136003)(376002)(396003)(33430700001)(316002)(5660300002)(69590400007)(33440700001)(6512007)(186003)(8676002)(6506007)(2906002)(86362001)(16526019)(6666004)(26005)(83300400001)(83320400001)(83280400001)(83310400001)(83290400001)(4326008)(52116002)(956004)(66946007)(66476007)(8936002)(1076003)(66556008)(36756003)(4744005)(6486002)(478600001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: BnlkqZhVxQ/iWbdLKM+Y+phrcQC2OKF8vMBMgEyJBTIGnlwieNm/Qtden1CfhYUH02Eo/TuB7fAruOqevOp8ppGjpBDm/cy3b+Z+uR8n2QuSdGZuTQTZbM7/x6R+OHmIUsW91NWIYiv76kIpcFftAp2s+4r2iYZyXxEMNAdSorHl9s9SjFLT8kCwpj0RjAEfOFaAeQIm8JcOu7r7ySnwYW22OB2hkCq7P2zULzc+szSKcjG3hPHteXM/j0hUlCr2Lf09qpc3P8Rl2sC4s7pREWqhpm6+GszhnG2sH3eFXEiHY/I1nSt7WXuBcllYXdGr/V/BqwAqBPshIEaQSzXEB0pg0z6g2E/aXB8xbXv2BcTOUh9bUDAOK67oFejoWM3KJtLdZ8+ARRVoKHuCwHAWwSSKAS4uQKMGohh49loF+kx4g/C35kIPYoT+KO+5KFugUO+mcqpe6DV5nlxLxL1vn46JEOdm+k28LDc1dIzqxk1w7rNy0clJemt3C6OoVZ5SlVU3EAqNj/5QKCQOOATnuo94+9VqaUt4YQTMxf9BIJIGJCRgCF+NcVzakG6aZ8b8umWzxKIHiObFIVS67CYuU7+pgwXq/OiTAGwwfe8t49NTQ8L13T0aOyEyob7OgpoE3p+zQx++/sSoUgdYtNl6dTY2WnM+9ecCCvXPFZlS0Mxxu9w89NqgjJxCD9yOlpTDDrKWGqLrLumttc74RH5kvsC7z4uScCaw0EKFQQcKZAeznz6IhsNZLp2k03VgywGvrNEJ3td7/Ei7FOTWvWv6zFG16SQHRwU68dHvQYVj5eE=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e42c3b0-b276-46b1-1807-08d7f27893e6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2020 11:19:59.7716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y4sBHYysN4mIv9uZNxbBwNbGtdxHKIAi5YxyrrDcoAhHV1DjWSbDHCKTrj9n2NBV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6416
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'Dan Carpenter' reported:
This code frees "sfi" and then dereferences it on the next line:
>                 kfree(sfi);
>                 clear_bit(sfi->index, epsfp.psfp_sfi_bitmap);

This "sfi->index" should be "index".

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Po Liu <Po.Liu@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_qos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 48e589e9d0f7..77f110e24505 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -903,7 +903,7 @@ static void stream_filter_unref(struct enetc_ndev_priv *priv, u32 index)
 		enetc_streamfilter_hw_set(priv, sfi, false);
 		hlist_del(&sfi->node);
 		kfree(sfi);
-		clear_bit(sfi->index, epsfp.psfp_sfi_bitmap);
+		clear_bit(index, epsfp.psfp_sfi_bitmap);
 	}
 }
 
-- 
2.17.1

