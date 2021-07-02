Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1DB53BA3F0
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 20:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhGBScW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 14:32:22 -0400
Received: from mail-vi1eur05on2124.outbound.protection.outlook.com ([40.107.21.124]:46816
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230115AbhGBScU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Jul 2021 14:32:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hZjN/j4uNQfr+AmB2yIHKcOo9aS8emmRwIFRZnZvmPWwguDEb8lS8w09ss9N4k0Ib1d1+cEhUnGdFjmRmTKPJ/Egd1Viucw4KNBrpJXpXCbc5K0gv8YzQby1GeXFim6JkP+D8wBMOo6FZtv5tHtb2yXsNV9upZbiIkhIugFoV/dgFDPBFXtjH6cy48guV3MqNaoFbAwPbPySH0Vk2mSBqxfykKty7KxQa8rOo5yJnOI5hcIxx/oFQ0dB468lG5MHd8fdsK2fy71UK3S1UbNDWtsBx2AyjImj8iPuKeyd/+iVO/TyzuiOlwC4lHbgXJH/FxgzkyaYMW02tzUygaaMYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LxSjiu8IfMhD2mbGIqePBMiVmiMtjHrQJ4FJ1AwMn1k=;
 b=kqPzlpAOTdicMTzRqKeWhL7ROy0/vIG20rO0ylBzRTo9y609nFsqofoVYJHVhJExmo+gvONRUa3golP5vZ8nKGUbMBd1DJ7ospi7IqBbOTg5hwhFQ5KQjmnH9z9u7A+OOuRzMGsAL133Vb4hCO59bu380WlQX0zxccZfAUkZFUCS5iiGQ2Tn50xk+S1PT3+DILl8c01IOZ3HtKQqAdsPdYqA43r3R2pMkPOqubL/TCD+y1/8F38pjUZXfSXA7RootO70L/CsjXzBBr+DYtjNtAGzgQ0dYT/Lrm2kuoUqxeFxfFti8wHt9hixMsLMVEhM5xYtGZyg1zqiPwKYXtmVBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LxSjiu8IfMhD2mbGIqePBMiVmiMtjHrQJ4FJ1AwMn1k=;
 b=OEiY3kSr5bR1ZsbB310h+hAFxys3qCmzAsLCivMV1UnlBiRs5ye9Y8CMV3bnvfs5OGo9Kh6TjbEVspts3V9DdsLTiRvmCHZtPHjyLEGvcd4mHlED+/afZZW/pn+mRHoGjYTj9dYKBUfELu6ivf/o4yiYbe4ngxuhQMxQsXKIqGU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0394.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:62::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4287.23; Fri, 2 Jul 2021 18:29:45 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::40d:b065:3aa7:ac38]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::40d:b065:3aa7:ac38%5]) with mapi id 15.20.4264.032; Fri, 2 Jul 2021
 18:29:45 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@mellanox.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [RFC net-next 1/4] net: marvell: prestera: do not fail if FW reply is bigger
Date:   Fri,  2 Jul 2021 21:29:12 +0300
Message-Id: <20210702182915.1035-2-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210702182915.1035-1-vadym.kochan@plvision.eu>
References: <20210702182915.1035-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AS8PR04CA0108.eurprd04.prod.outlook.com
 (2603:10a6:20b:31e::23) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AS8PR04CA0108.eurprd04.prod.outlook.com (2603:10a6:20b:31e::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend Transport; Fri, 2 Jul 2021 18:29:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0604c0b2-2392-404b-3213-08d93d875d9d
X-MS-TrafficTypeDiagnostic: HE1P190MB0394:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB03940761BDFA5498A89DD3C9951F9@HE1P190MB0394.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n+neQMYGYgMAa2GB6XLErqqfckKvo/OrKq8/CRgshex5r9iPcwoYmQpDtGJltDEK0x2O7TQOpiRRl0aTnMJEjpnvwqi7NlPjRN8iKQR2TAcG7ULzIzXuV88sw1fosqs9dFBHABQbJxjr76z9fB5CqD2r1JCmJ0+bYs1/gjAbzERlM7f3qjJS7AcdOJIP5oXyUr1bPbvS+xbz86qcC3DOoL2qsbY5Kq6r73KFvw2UelUp1v0ru/1ZSlBHbqDz9j0knRRu3QOP5Xr/RZnLfob2q1AWJ3wDv9IdHRF3uVXoJRKgIqYl0gVeeJoi7YwC8ZhsZW98yAoqw9bxN10fTX3VbzzR9qtCCby/KPmV+YaQYegnUytx1dymPU694CaAnnqSUgHnubWIIic0/TJICrBwSa5XSqxZ7RayhKxTGI3X1sOtO/dQWGzyefzsGZiw4i61NBPneLEY/his9t9OeyFWcIy9BjmztDBP0RlqaFOjf1AiGOp1PCZ0V2kvx5vlHqtOP/ZsmvAwrLpE+OusL1uDFU5bCdeKf24TwcrDmO8kzsLhKRBemwdb36VUdKmz7HmsxfYfoJ7IpGf1SjyoC6WTnHvJ0OrtcB1Fn0u9YJ/LZcAne11zN4Jq4kr5FjIQfMueFPV+lFdwr6vnCjKg1sXxwQih3Mgi7Nd1JtgEIbXzDDb6urF8ooVQOZ9YXhXQddblOJMg3Ejb/vVNT05e3C8N3gF9/i7Ngb5KgGqTjG/jYwc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(396003)(366004)(346002)(376002)(136003)(6636002)(7416002)(2906002)(316002)(110136005)(54906003)(44832011)(2616005)(956004)(38350700002)(83380400001)(86362001)(6666004)(36756003)(38100700002)(66476007)(4326008)(1076003)(6506007)(8676002)(8936002)(5660300002)(52116002)(16526019)(66556008)(6486002)(26005)(478600001)(66946007)(6512007)(186003)(135533001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P71OMki/uARe8rkLvCjlY0/KbFWOA24y3uGqu2JtdziELIyqJoJieFdzqV9l?=
 =?us-ascii?Q?NrPj1LSCEm8JqHfyBHe0znppm2Yl4DebSY3adOTvslE1N7F9xa5hoIf/u8Gd?=
 =?us-ascii?Q?+mgbctrWwCMCWCHekKwE6mm9FF4IRB/ngfoyQ3SoSeAgZTxjhB02sccS6ede?=
 =?us-ascii?Q?orRRkGBM4LzAv/07FVb5kt7RFGTzzWGcfu90vFAsNlRjkRolMTA7r0Z2hQ0N?=
 =?us-ascii?Q?uQghbIWy9663nenYn6ZF4Mgy2Tb7n8vzfjlyFz1vDc0pI4+VaelBZ+jGppKm?=
 =?us-ascii?Q?SVc2TfIvgYIv7BP20vvohGZBjJELTi69M8JfyaAvh9/L1EqLBr8UUAIaa9fr?=
 =?us-ascii?Q?1APJw/9wTRZxV2R8qnaMjni0vy6I7j7XcZE0hgDAwK1AOqkyImuYPCzT2pQH?=
 =?us-ascii?Q?7gazTuyfX+7my1rCf1sBMCQfG88A5arjz67emeiCAFVZsU8sIMHY4TF5c8ZW?=
 =?us-ascii?Q?p3EkD2+WYKYD9g8J4746sVF/eFWRvFroTqj2E+32PUjFpzTNEVFUvpUEC9q9?=
 =?us-ascii?Q?P94bPSLwuum9Wx70BvQusMCBBSKLe2m/Ldx3493EyYI9Jsbht1aql6N3FR5/?=
 =?us-ascii?Q?F6hbAnjarHj4etunlAP0JSw9mUd2gNeegCoJCuO352Cc9kTiDREnSpG8G2tA?=
 =?us-ascii?Q?rRvu9ETWeqlg954oBvcslVwQ6f8Mv67CJRe1iwwni+A5yik3OapghaKfi9U0?=
 =?us-ascii?Q?RvkBaqdnF2B/D8HUDvbt98qiAMy9Mo4YgXXptbne2MvZV6J9u3qELtL6ttwM?=
 =?us-ascii?Q?37kn5l/AXtEQrmc48qx57NkEfgXtaenFPx6zzALgSRVm6SrSbpLarrhcNfa9?=
 =?us-ascii?Q?8QTsW1ri+oUX4hbIle19fYeP4AS5spGXfcph4CHzwuDjVD60/z4BaHeJ8ucR?=
 =?us-ascii?Q?z8n13IZcqlvFhqLHE50hc5+q7AQ0gQv57FZucTEzasg52YWI5zYj5lnDMhl/?=
 =?us-ascii?Q?GTYF+sXq579Ou5+tkAa5ciBOy0RXGvsb8ny+INYb+8EeafXICKCAn3KSOVOC?=
 =?us-ascii?Q?+35soJUE7Qyz8FsaMDE2W/37+ol2tRBwszPmBp5MdRpnLTxdsVHBnJZxiDnG?=
 =?us-ascii?Q?jFOGktqE2pjqhvMlPmTfPem6u/3H1unGyAWtFrnmnRRao6d9hke722T5jP99?=
 =?us-ascii?Q?6CiokINO6J6sXudbKb6dovrrwcH2/Zv2/W61jMjqR0fRORmwJ5FhD/W8qObq?=
 =?us-ascii?Q?eFjr8yPS75LKZoAbJMiKnxMMQQwiWyK/fJn4M9bi1OpxpYJza2VusQPdwO9p?=
 =?us-ascii?Q?SVIzdDdqwx5yVuTdbcmiGevBggU+bOPUfSFDGCcqsBm46DVt2lN5Alj4+VP5?=
 =?us-ascii?Q?9CrymYk53j4FbXuEwwlj73xf?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 0604c0b2-2392-404b-3213-08d93d875d9d
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2021 18:29:45.1877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p9N7QkkwsEcP/4imLYh2r1GXgd90fObsPQSiTlYjDWT/unVXKRay9L8ScXNolCEuYb70y9GWo0qtQkiOmWo1RDcyey+YNrDOW/tfkqLveNE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0394
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vkochan@marvell.com>

There might be a case when driver talks to the newer FW version
which has extended message packets with extra fields, in that case
lets just copy minimum what we need/can.

Signed-off-by: Vadym Kochan <vkochan@marvell.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_pci.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index a250d394da38..58642b540322 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -359,12 +359,7 @@ static int prestera_fw_cmd_send(struct prestera_fw *fw,
 	}
 
 	ret_size = prestera_fw_read(fw, PRESTERA_CMD_RCV_LEN_REG);
-	if (ret_size > out_size) {
-		dev_err(fw->dev.dev, "ret_size (%u) > out_len(%zu)\n",
-			ret_size, out_size);
-		err = -EMSGSIZE;
-		goto cmd_exit;
-	}
+	ret_size = min_t(u32, ret_size, out_size);
 
 	memcpy_fromio(out_msg, fw->cmd_mbox + in_size, ret_size);
 
-- 
2.17.1

