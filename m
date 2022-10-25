Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7FB60C2FE
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 07:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiJYFER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 01:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbiJYFEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 01:04:13 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2132.outbound.protection.outlook.com [40.107.92.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF03BA256;
        Mon, 24 Oct 2022 22:04:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c1l/UHTOMBc5X2Lbt4Sw/n9cb3QRcXSRxWPqQ5Ty4X2XSRZLFPzYePQ6d5qWRZfi1MrEApGDmzG+U/BgBAlzbAMJzsyyozY+vV8+FKtijvGJM5I7MTHjWCZ8n0jRqupkTd2S4C+Ej3UCLxeftXl9Q9B3vWV0eMoyfYMjxsfVGryLucUSAeTVkj+XHWksnCrNPdoLWm2+kk9MmVYHgtPskNZ5apEWD7yPm2lbgyG3wlb1GZP7eq7RinTrgl2hKdYbR/QA4ag2oj7fVFFh8qwAI07uLYGQmaL/wi2UhFCaEeAw+7douClIiZ9ecCeadd0cU3sFfcr5p+dIF8aNa8D9Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W554CbodlPh0WHKkp9NYut+Dz3hG5Wy53IA+JsFxgwE=;
 b=e+T2LXx0wgXJn0oRMwx3zvqg493iz4S2V45xRO855sEQHCSjlE1IuKUHP9F3hH2id2JrhH2YZJb3MMQtzlKY2ex+yKZTWaQ7Q7F8oDbJsX1ZkWcFRi/dbbQFxZXg7FMHKEDQ/AjkIyKe4cvCkjwRtcCueYPq8qsHSpXxXBvCzPZZ4hukzfStFbvw4US8o67S29eYxPfRxsaxi9TZXUxaIiIW6ghjoV2/Uzcda+W7XgXxx76aWoKmjPQVG+TrpkNBaUCnxye120wPUIdgsaknH3bUNaS7V0qSA1S3XaohZrCeN5aiz86t+QDSeJnZp3HqqxdrGTEZ4n5dIWTtjTFZOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W554CbodlPh0WHKkp9NYut+Dz3hG5Wy53IA+JsFxgwE=;
 b=MQrlKQubIN/yuyfZ1965kg+ht4XzHeoNIlUXAtnAlb3VKHb1/UO5B35hnhDNKAKe2yuGn6iTqBJ/MIbdp7kZxNDrJe9KD6rzxbqd0rHJpkRLCYlfl9chgxZtCsMR0TvJratN30YCXt2CF7MenX4pifG6I5Pm4WEuR0erR6HGDQ8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DS7PR10MB4989.namprd10.prod.outlook.com
 (2603:10b6:5:3a9::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.26; Tue, 25 Oct
 2022 05:04:11 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::8eaf:edf0:dbd3:d492]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::8eaf:edf0:dbd3:d492%5]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 05:04:11 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?UTF-8?q?n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v1 net-next 2/7] dt-bindings: mfd: ocelot: remove unnecessary driver wording
Date:   Mon, 24 Oct 2022 22:03:50 -0700
Message-Id: <20221025050355.3979380-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221025050355.3979380-1-colin.foster@in-advantage.com>
References: <20221025050355.3979380-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0189.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|DS7PR10MB4989:EE_
X-MS-Office365-Filtering-Correlation-Id: fd394396-6c70-4b55-ced4-08dab6465aa7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ghoCqzVC8nhvCXh97X1RLonl1BXP3HnouorVKqrzjZcbq7T26DIoW/0uiGyo0ApQjQEmjk1fFSc04/Rnn3SDTgo/mKlW2/cPk+b3TrgBpLDs1TAg4Dw6aS5EniOGKBCn3P07yGYocr98nldN3HlAoVT+d7KNywUN1/dTOW06ksgaRKOdLudipuMfclNRfZr2lZ7MT9mQRYkX5j5Ms7Vk9mpkfXtYXRElg/04uWLqZCPTaxiAOT2DjAGvrlg+sk0imVByvEjrM0Z+7zrRqrTpNNoqYbodZaf2ohu6FQS8P9AKRIoAjSBMt7k/+4PFcIaaYcvun1CP3NoviKyI4s/tXBUSPBvE3OOWNpAHcFwf9cXNZE3iBd0z9A3zyFkAzavPeX1P/YD2Xe8N9ZoB4sbjdK0Hie/sS/snAxvO5ERLOAJ1QZCoT7lgyLgnIysxKCI9Q56TJkv5aAd66qVz5aVj3Djpuihzlh/POu41VaGvLyvBpzaukUn+LrdKp1LVF05u3wGh0L/ARGu82nGsSwSl6FET8LjNkp8xWe6Dd1WydsfdT9CRCHF3dFahUAjsYUEd8KHbF8l07MoM0sZMFteKUYEz0Gjt6aUhsPpwqb+E0iV/jUF62z+e/efjSJaVdC8MxtytEgva0DCnVLWciIO3chjeWNQjG2tf1NOh1FSAcKreBWkr9rKoW1C4hc61zgz0jkGCxNMwLlo8/h2EJXZPV+vEpott7Tl7KGfzlKlIYFTqr6ICFbZFkYlv7VVxe8IKRs6Lzmwb/4WVmEqp/U07zQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39840400004)(136003)(346002)(376002)(451199015)(316002)(52116002)(66476007)(6512007)(26005)(54906003)(44832011)(36756003)(7416002)(66556008)(4326008)(41300700001)(8676002)(66946007)(86362001)(8936002)(5660300002)(2906002)(6666004)(478600001)(6486002)(83380400001)(6506007)(1076003)(38100700002)(186003)(38350700002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3TcpcF98Ye0HWn5wuWRWyZiJtEzQDk+zoMiZ1VGCXtYDB/V/3SoKoWtu+MNP?=
 =?us-ascii?Q?2a/T9aTgFmUQfnS+K5Jzdr3JK+vhqsv2P5JclvEKOhZDFprsvcOss8M5UjXn?=
 =?us-ascii?Q?jjwsMmD5Rlbq/b3RlHpfVSzwQjMlh8VDEgaGf9MdA9U1QUjZWKcu3PYXHFHi?=
 =?us-ascii?Q?0EUI7RooOGE2OdRHItms1/XsSOZPww5GEVWdZ8jszD/8foHsh3gsUqx3ZswU?=
 =?us-ascii?Q?MXLzGtZKEb2VVq4Wb0Mnet4wEBFkXwTc+pMWJyPQMPcCcWB/CJznjsAClN08?=
 =?us-ascii?Q?r0Fow7JgXRuKZbfcJhNvcf39kDSrrzk/En1o/Rd1ZLXrH/bjPcELNyZxFRCs?=
 =?us-ascii?Q?6DM9mKQcIt0Ekz7zsAQ1UkmQqso983dz1B3LvQ+3xfF04DQ7WhNEbN5gFe98?=
 =?us-ascii?Q?MiqFrdVnCTaLNxvZ6UbZ5iuzszl87ELnMREOZnBnz3ztRAMfQ99zrrVZ4gS/?=
 =?us-ascii?Q?xtxy1YQxlcXVs1tK21Lq++oXMaa2fmyMSe+pKos2EfRTr9Y3y+ag15oBAE3U?=
 =?us-ascii?Q?avj7kdRZDxthjJyg6PdA0xJfQOO+MLx+dEkcnBCX1uDwPLf/xnqTwm9FgoDP?=
 =?us-ascii?Q?TX7xabZiqms6sgcOfvp8GZZFdI+xqOYHQ890aGKZv0XnkonrZLf8bz8jbG/U?=
 =?us-ascii?Q?CA0ZWuIro8trXGpU+87HRb9GNdAKIz9l+SfxRCrvbkHlTUdr5pzc4TD5tHPH?=
 =?us-ascii?Q?QGXCkO0GQmKkKMgJf1jhgTZW5BSohRR0IdHL84E/vOPFnb2p3DB5XTjf/Yf2?=
 =?us-ascii?Q?SdbpQUrLSg1EIn5ZPSy6tom8azZvu4t5w4FC0u8NSRmbto/KcEpDWZ0qQ1HL?=
 =?us-ascii?Q?/Okc9/IVAi1X39PKHLQqhWdk2JdsBbwhV+HWXuUC8WngkztgsXMUmCXweL1N?=
 =?us-ascii?Q?fxFP22fZDJ+X61OV819oyVeAX6QKmD3b2TdEeW5Bje0GkRWZwp99OZ3cUb/q?=
 =?us-ascii?Q?WhWyi2sTXt87FyuK6VZIaA0a/+X+YA99U1+eEKIQzYcZKhK4220Dkvlhxtxt?=
 =?us-ascii?Q?AMf84HQIeD2yVniP4qBtpBLMENcqlrQriCLxlmQ3XFCpFpgdrGloWKZ962+4?=
 =?us-ascii?Q?KmaIFd0EdoU+hPYrUUGl4VcyXYpFBtElx/hv1eorcMZ3w6PHMXgTfEgJpwRY?=
 =?us-ascii?Q?+JgnjNLwH7SLVpjtJVJ9JFrZX8auZI/T4fNCf0Q1UyWs1fj9y4afx2ZEmoqM?=
 =?us-ascii?Q?60nkE+n328DOJm7aMwkHs22V0NwDS+0ZzhO3wt01F25w87YhfIuVgaqYXVn/?=
 =?us-ascii?Q?blyH16m1EhDBzOQgTQ5B7G7Ubib4F5pOSNxSaBizDHu/jWxW6PMcKWisd9yN?=
 =?us-ascii?Q?pQqF1rWuu2dOepdJHY8270ARSvmd23TSX6tVUCyfZ4od/wko+c9seWJcMhZt?=
 =?us-ascii?Q?NfZ+LyFDyORbVMQaqufMfP3wsDlRQpqxFPVWWnlZZVXt7ruRvChFOt4x88Nn?=
 =?us-ascii?Q?abrTyAYhKC75bDsDJbCvwUhMIvqGAzkCeLm1GD1jHTS7HB/BzaPoiMjuIX7K?=
 =?us-ascii?Q?rJn0d6hMC4KinIXHo+payXgt1AztvTXzF4PRIP5PRDBt99ANmO+KiFiw0cgS?=
 =?us-ascii?Q?Pf+ldSBFZcqhCwan4Jrun7mO+lDjypiEHkas533tVLph7t8iyb9Zv81d2gBw?=
 =?us-ascii?Q?NQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd394396-6c70-4b55-ced4-08dab6465aa7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 05:04:11.4071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nufLTtRW/DIt+tQgpam13hGRjXY4I4hspWkoYxoSVoEP7ENMaTFlKMyUPTIGGi37+GUali7CydhqeXPWlo40EnrwcnDJf7QpHbVsDEgb6Qs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4989
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initially there was unnecessary verbage around "this driver" in the
documentation. It was unnecessary. Remove self references about it being a
"driver" documentation and replace it with a more detailed description
about external interfaces that are supported.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Suggested-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml b/Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
index c6da91211a18..1d1fee1a16c1 100644
--- a/Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
+++ b/Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
@@ -12,7 +12,8 @@ maintainers:
 description: |
   The Ocelot ethernet switch family contains chips that have an internal CPU
   (VSC7513, VSC7514) and chips that don't (VSC7511, VSC7512). All switches have
-  the option to be controlled externally, which is the purpose of this driver.
+  the option to be controlled externally via external interfaces like SPI or
+  PCIe.
 
   The switch family is a multi-port networking switch that supports many
   interfaces. Additionally, the device can perform pin control, MDIO buses, and
-- 
2.25.1

