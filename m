Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66E28639DC2
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 23:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbiK0WtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 17:49:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiK0WsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 17:48:20 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2138.outbound.protection.outlook.com [40.107.94.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E72CA1004E;
        Sun, 27 Nov 2022 14:48:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dtdn6VNCg38lvmche4n2Efnhl8L7XLPrLuVR4tYTWqjtGkrsFKcXPTy4leI4LDOezVdt47z8zggphChUy9Sq9aBfUk9efpLfDS6Dfmf/CxhQYGR/N9bXaqlSXU3GPz9y5iTXft3Dv6ywmoYS56jx8VzkcJ+KPFAWeTv+CSOtgtPG7Ng6tUgGhaJnrW8i2L0OI/3pbSWHBEWrOLMKj0ugUrn2vvtvHkTmA/u30nUxI6i1LyQbNJikcyA0GFeB5EuJk+kkHKdWnl0gDbkc0B+nf5F5GT7CEpTuX/YRu4PJ4Pn8rv3dwhThRfgOkwuv8auCzZQaJOUVgxAunutCHMHV9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YWcHhtShU6stqv2sS76U1y+DSgOirDvztP2zqFgmzYg=;
 b=DQ1jKYoMdnuVJL+iF+NDGSnUEVEWbpHs11SfU6GWs6drItMmlzkQPJPrJxC/87K52vyCO9Iubj+Ss8ht5hf37b1RCKHBET/F4Iv62OiLvAJ80iEvgNnArxvhjuUAqnLoUyQ1GcgzXVvfJgA9Pcbmeh/SS70sBLWgbt4hGfwaqh9Nx15vF/+9waRx+QzhnHWI1CEo2NuL3vxfmnY7Bt28tKRSGHtQ/pP0cYYwm/8ArfJzH5P5plfpBd4G3Wktqeoq/ky4V/fJYIaGM+g4OMqk9gwJklhlwSVfTGwCa6TSNEbvWMmkGiqDd+cLCwZE20s3oyJAjHQVBwYZ4ihyrMeneA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YWcHhtShU6stqv2sS76U1y+DSgOirDvztP2zqFgmzYg=;
 b=krcPMak+Rz4Vh21sl2m/1ake1w6lg0RPnm9XAFXI4Irnb8N6j/IyrOFfh6wifX2yersP4AlpLVnOTrddyCQr1z5NurQt2wGSj8WtamAKJIWWg49ArG9MwmBfZABWNJ7aYh2WQdajjQfUMpjplasWZ1v4/dXjsPezfnCSZLYJsMc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN0PR10MB4998.namprd10.prod.outlook.com
 (2603:10b6:408:120::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.22; Sun, 27 Nov
 2022 22:48:00 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5857.022; Sun, 27 Nov 2022
 22:48:00 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?UTF-8?q?n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH v3 net-next 07/10] dt-bindings: net: dsa: mediatek,mt7530: remove unnecessary dsa-port reference
Date:   Sun, 27 Nov 2022 14:47:31 -0800
Message-Id: <20221127224734.885526-8-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221127224734.885526-1-colin.foster@in-advantage.com>
References: <20221127224734.885526-1-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0027.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|BN0PR10MB4998:EE_
X-MS-Office365-Filtering-Correlation-Id: e302b049-f350-4dda-fbfb-08dad0c96f6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9hcSxbHrwxJss13KFw8GeIqnP/AOpMj9zm3UnmGcJntSeHc7KYPZ8y1eMWVpZEgbTU0icP+r/P5XbSDvs/2URpRWW1mfZoJlGOE87Gr3RzIjZd7bpQ+ll3dUQ65j/07zGbnAQ9DvoxOlh81RfcmUWVpc6XYNGgezEAk1HPzS40LRGAzJ8ivHGVcb0QoqM0PNV0bY4B7y2YrupYXccL61VD4qJ8vc0CCCJ2NRik2PQRwNaJuWFlC3GQ+QfKS57JkRDmTi2ZMtptB9R4x25uxesnyiHK/bN7BPl/2nRJ37xAIGlN2w7v7BznIjYrQ3xuBaWSpsqF0t9ATbt2jgRf6vrXVgsADWggjW+QTDzZG4CQ+h5DyvGHZMP25HZYCDSei7KK9gnyg+C8H3uQLuqHVgzLgtNeszfYW9CV3QpG0McnWX1wjIbw8jWSmYaICLeoz6aq59mVU/ZcrmGO3Zzg+tcynia/IB4f54JD2nAJvxTO+/kl+A8pLcJBN+T2UM/6Uc6zMFN6UUdS7oY0sN+BgxEByNZQ6eKdl+hRpd08k8Q6OHm2X8Wtb60GXEDOFH6/UkGVF+3auxFDnytK9Z6rWRl7A+aAePlYGIVU7OZgCHj+0ZO9vH+MIljZqfv4u5qYZ4a4Ao1jIOlHJ84JlVtQU6j1TN7gj9hR3BTkoE2uQQq1aZIxC7pbOA9DHeCZ3aEsVP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(376002)(346002)(39840400004)(366004)(451199015)(6506007)(2906002)(36756003)(86362001)(7416002)(7406005)(6486002)(478600001)(52116002)(316002)(4744005)(66946007)(66556008)(66476007)(6666004)(41300700001)(4326008)(5660300002)(8936002)(54906003)(8676002)(44832011)(38100700002)(38350700002)(2616005)(26005)(186003)(1076003)(83380400001)(6512007)(66574015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NTcwNjVCUGhiN3Rhd2JvcDdkRmFuUjZRUkIvOEUrcy9kU1llQXdsakNBMnlw?=
 =?utf-8?B?M2JaNTdOOEFYSGZiS3gxYzZGN08rOFppTUtXTjIraU96bWZHVjQ0dGp3V0Fy?=
 =?utf-8?B?cTRvRW0yaU9jSVRoRjFPQnN4RHhmRDRPZlNOYnIvc1NUbDNYL2Y2eHVoOFY4?=
 =?utf-8?B?VTArK3U2bWJERHYvZHMxMGJJR01DWnpBTStiUGNLU3ZNZEd6Zm9XYTRNa2N2?=
 =?utf-8?B?cUdJUG1CcU0yRFhlVVR2aEQzNXB6L1Zqa29GOG0wRXBPanNaSTNKWkNDbG11?=
 =?utf-8?B?bkJFeWpmREM2dmNtbEdvWXo5T3d2TVN5czBlWjA5N2lSYUpFbFBJOUlsdDht?=
 =?utf-8?B?TlpsS21GbHY1aHhLcTR5c2UvTVZEZkkxL1N4MDRIR0I1Qk1SSDh6UEVMQUow?=
 =?utf-8?B?b2hDbkZmeXVsY0hxeVd3ZEI2NXllQ3dTN0NEWlBENmg4RWVIZjNoWERQQ2Vq?=
 =?utf-8?B?Rktnb0tTVUtydlRLNWl2TzFQd1hjYVBPVEJ4UkVtQlh4b01UMGRPeDUxWTJD?=
 =?utf-8?B?WmdCSmMvNXRjeHpURVlUT1RjcS9XaE9HY3pIMlhzWjdpYjVwWEszcGxDWnpR?=
 =?utf-8?B?YWpkUkk1QTNDS1VJeU1FVnV6VDVoSExxa09mT0NGT0tnb1pxZ2dJQTJTc3dT?=
 =?utf-8?B?WWtjMnIwZEVBVVZUaXRhY1p2TjNoK2JVNFdHMmRNTkw2MHo5d2dvcnNTYUx1?=
 =?utf-8?B?MHhqTWNibzQ0L1VjZWJWQUNMMS9BTHlWN01JVDRXa1F5S3N0YkRnYllSamVH?=
 =?utf-8?B?cFZvRmt2eTAzUHdTcko0TmRiWThkVFNFQTFKcjZuMm1ISHBScS8wbFRqQnJt?=
 =?utf-8?B?YVh3eHlCNmUvV0pmRFgxMlV5U0ZJR254bkNkZ3lCcktQYTB4b3Q5QldxOHMy?=
 =?utf-8?B?YnFqbForemJXM2cwbVRIZVFzVkFGNnJldEM1eWExWldxMWdTalMxMDVKdzdN?=
 =?utf-8?B?Y0RNcjd3Uks3T0RwQjlCK2RSMElDbjZlaFRkejY5Nk5rL0RFK0VHZHdVbW01?=
 =?utf-8?B?eEFDamVYSHhhMmNNU1JsOHlzbUt5aHE1aGpRZSt3a3hoZW1ybjNPYklZY0ZJ?=
 =?utf-8?B?RWVzaWZpM3pCbEZ0bnRyQUh1ZnpreVdBRnRvVndyRHIvUWJZTEg0V0VFM3Ft?=
 =?utf-8?B?ZGNGUFUxSTZ2SnVFdExQalJxYk5TRFNpUnh4ZUhBU3hEY256VklzSnhiaG1M?=
 =?utf-8?B?dFo3Y24yYkFMT0FkZXdmMmFPZG83bGVLT0ZvdU40QmFQRnZtTjBkQVhvSkdC?=
 =?utf-8?B?T0RNWFUwUGZldmtUNVd1RVNrbFhKNFAxVGZpRUxWSFJvL0l3M1RMaHZyd0xk?=
 =?utf-8?B?YVpsa3hlM2lOcFhJTUxTK05zSVZsNk1SSktVWXpYUjhnZ2JMRHhzTGVhUHRs?=
 =?utf-8?B?YW41UnEvcURnLzhER1VDZHEvRnVEMFMxZzNHWm53TzUzVmkrSTFIVUh4ZkQ4?=
 =?utf-8?B?dXJxN1dXZ3p2WWJNOWw5Mi91UXF3WENHVW1PMm9VblB4SzhjSDBnL01Ba2p0?=
 =?utf-8?B?L2s4ODVVc05hVmM4cDFPQXZLSHpyTUJtdDhub2tTc0xyUlp2ZDAzclRBT0R2?=
 =?utf-8?B?WnY1TVZYb05ITTNRZ0NzLzhuR2xWUzVFWGJ2R3lXdDRIR25LbHlZdDBrY1dC?=
 =?utf-8?B?TVZzOVVGd1NYUVRkRnNQUkZ6bWFUWmtvNFlCVmNZUWhMM0I3dTZUemlKamtG?=
 =?utf-8?B?bDVNNVJOd09NblZJRC9rczN3RytQSVJPU3JjSkd6OUd5WGtNS1pxeVpOK2pr?=
 =?utf-8?B?ejhLcnI5V1RKZG5nRDJjYkNWLzlVOUhPVnJlbHN0QlNxanVKbUU5eExqWGdo?=
 =?utf-8?B?ek82dGZyWHVVdW45TWwwdmM0Vm1FUzJEWC9wRE1EZFNoclJWZjgveHcxUi96?=
 =?utf-8?B?bUphazNnNWd6bllqVmYzaEJSVVJRNTZ1TER3SnpXTlRaSUtkQWl5eTR5d25G?=
 =?utf-8?B?cDZGZnRCV0pXdXZMUnZRcDZLWm9ORjQzUWYrN3U2MlEwYktLNm1ZcWxwM3dN?=
 =?utf-8?B?VFdRWjZGZDMySVZlTjU1bWlhbHd3RjN2ZC9UTjFiS1dmS0l6M3VycG1PUkp1?=
 =?utf-8?B?amtWY0Jpa3hpalVKZkUvZ2lnbGxQNlFsZk9lRm5KMDlTY0t1NlJ6OEZ3ankx?=
 =?utf-8?B?c3k0WURjU2dxZlhsckNKbzgrSGNncUFaeTYwRjJNQ1ViYjlvL1lYV2ZlTVpO?=
 =?utf-8?B?YkE9PQ==?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e302b049-f350-4dda-fbfb-08dad0c96f6f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2022 22:48:00.5772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jxHzHrylYeaJD+SXaa9xOJyWrZJ4ZhlfPthMoKgg7/7xLZ2mg0sG1o1pYpi6DSh3Auq4IWaqXirsddGjsZTDk3mTEdZgmErAdD7dQGWkyfk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4998
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dsa.yaml contains a reference to dsa-port.yaml, so a duplicate reference to
the binding isn't necessary. Remove this unnecessary reference.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---

v2 -> v3
  * Keep "unevaluatedProperties: false" under the switch ports node.

v1 -> v2
  * Add Reviewed-by

---
 Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index 415e6c40787e..44608a9b244e 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -157,7 +157,6 @@ patternProperties:
     patternProperties:
       "^(ethernet-)?port@[0-9]+$":
         allOf:
-          - $ref: dsa-port.yaml#
           - if:
               required: [ ethernet ]
             then:
-- 
2.25.1

