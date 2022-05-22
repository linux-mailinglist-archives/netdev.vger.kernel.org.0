Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F35D530229
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 11:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239763AbiEVJu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 05:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233143AbiEVJu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 05:50:58 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2084.outbound.protection.outlook.com [40.107.22.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52A2D40
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 02:50:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YaKBz9ZB2bj71hqaJxj6d/5+5KjDMXLeOezuizhgfszpE1m+Zu9alNqxm/hLKe/Ucqe+LMbbgZO+pktzk40XMoLJzdKeXQYKyaRMeFExxmLsaY49lJdFPVeEnaGHE6tV6sGZ3a0SyannsJUl4fmZ7sNcrQl3KRLIBu5GjXZU4QNffrIAYHRMbbkJyjl77plBaPorfMr3OzGB8XSa3JTfzVCwBvc/NoLNMIlG/6LBpVvCME3x+d8rDxxVjGCkJUuNy/P42kbfYkiaJ2B6UUQQ6oL7KrmdyOtpZrEvEpteF8gwjx61z5eEsqI7/9nigijs3OuM0chVzE4/kaejUA7xbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eMXnSkH/rmFdLCbMCinLOuJeb3Fs+u/yFqkKqnfwWME=;
 b=ArNrBIN2KhRE3yTRWBx8o62JlqzLjJ5m8OFfUJsHu8e+i+mS3x8/2PgymfjkrHAbljJ/P/ir7jbuO/TQDCiPrZP2uyobw3bX21rNPaxR8haRF5DpZhuATPHyXdilcMhf31mL3/V8g8fvhhwgQuvUYi3FU3jGUTNqWkB8d8bg0FKF6kV7WadpvrB1c+7JbYTNLaoswt1F1NaiJrs/kG6fzBxjITscSoQyPcnPCPqSdFCVl6bn6k5XeZRhENax8HT4cUcu7Ot4xQ/gM68gAHfun6fCpE0t+cBBNamQzXPX9kpNbjnSIETJO8fvEu42mupON6u7Xq3P26ZY+xmNtzjS/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eMXnSkH/rmFdLCbMCinLOuJeb3Fs+u/yFqkKqnfwWME=;
 b=AsEAtblXeknYMnyhDNK3EXe0pvnMIKwAo6o1pR+oXz+fpEFq8tTtp5Gc3MwvtMO3kmgwJKV0fTUHBAipDOZYllpbBSSbqDCvhpKV0GR0NZ+Jy6m2MdtTtr5OUhQxfxchWUn8jNaWQDHwCeLC3+QlLeuJlkPZE6xd7DkwDo0qzJc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB5306.eurprd04.prod.outlook.com (2603:10a6:10:1f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.22; Sun, 22 May
 2022 09:50:52 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5273.022; Sun, 22 May 2022
 09:50:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 0/3] Streamline Ocelot tc-chains selftest
Date:   Sun, 22 May 2022 12:50:37 +0300
Message-Id: <20220522095040.3002363-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR04CA0057.eurprd04.prod.outlook.com
 (2603:10a6:20b:46a::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1a12971-468a-45ae-a5ce-08da3bd88eb0
X-MS-TrafficTypeDiagnostic: DB7PR04MB5306:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB530661503FCFE9F5546D4347E0D59@DB7PR04MB5306.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: taaBl4Sxk3KBC4tk0MsQXt/hFw5eZCVG2/3rgwRKlelpegeqRQMBIR/YFUJ0NIj/WMoJlzE5vMSTUIWU2PKIu+qFP9aE/kzQilH0oF+2h1czF/CyNEqu7W8JPxcjCsCJ1qY3DhS35Q9siJxvT5SjkIzQZRc9WZmeiPIH4iKOcZG2F0BvBbG3/FKujRmc1KB51Lzzy4f++gtgcEIcWtGZ/UaoSnioIlrVXUuU2DCoOH45YsLvgHzcSeg32BxGtrrCmVSJ7SpZFzCXWKYc0uzg25pHQeN0pGGCu11/UneEHoCRlMcWS5qi9AqsQFjd+Iw9lc9/cPQhapdg73fuh41XnuqA5j5NOweLvJ2HWLc4xqUuV8Poew/tGbS6NvVTuHcSJwMG3W1XGOjGTvIoruPcJGM2nZh6USpOtU3Pi/ql3/KNIF1+1MM3Q7On53Tmi2frrjuuRZ1vi+LLJpQePSTHB57REtW5kWDWrUwU/Bs8YxFleEVwL3JMnXcqxct6ocIyXBP0QbU/VJFDLl43CHWHuXhHnTuPkgJ+8S1m7A1V7VmZr5mIlt3K2/2X6Pop7MC2+Y0mUQcf6fD/sZdEEAndV4NCQZg+Q2iFglks/FamOeK52dBJk1Lj2Y3TO7OcQm3SlfCFsO9YAbHzYgQwYEHK6E8DZUJxMSlLnm7IATbm6HTnCngc4ImvxfQ+podwgSxJ3N8+LuHyT+n3pYeMg0KWfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(4326008)(66946007)(38350700002)(66476007)(66556008)(83380400001)(36756003)(52116002)(316002)(6916009)(54906003)(6666004)(186003)(6512007)(2616005)(6506007)(26005)(1076003)(8676002)(86362001)(508600001)(2906002)(6486002)(4744005)(5660300002)(8936002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e0m0M0zMj2PpW7OjhQqGpvzgJpPFJvi/A69H/+BkHpbwyq44YoBKg1lBphJj?=
 =?us-ascii?Q?qZRns90KnWQw3L14Y+uOMXGyjIawrbLjd8su0CQ6jIwZEB3nG/GvjITSxWX2?=
 =?us-ascii?Q?Wj0hsOqa1+iVJliJT9q9/fJdaQqoYtcI27mu6mi8KvUQcVsJgj1e/L+MloGY?=
 =?us-ascii?Q?Fmwd8npXW/lPXi3dOtRaUQVo/2Ra8scIqtIHWqbejb1kYgsQruApGxgZf3uf?=
 =?us-ascii?Q?A3i3ktv0GCd4Q+2cYO0WPp413SQ96yc66OZ0zkXAOkpDxR0Z6k1VS7JfaKNn?=
 =?us-ascii?Q?yTdFek3XJhCUEn0H33yjKWrHORcoCYTcaLzuiq5mxCCArxM8q3yUXmQ6exXp?=
 =?us-ascii?Q?zHMXBJJI+ZjEKWWEcp70z1XcZKPyN5bN2FXkUG6bFDRB1GLVdUQC5ruv7Mrp?=
 =?us-ascii?Q?zYtj7W5xecxln3J2MR4KmqP4W/NHC3cF7O0+rx8OD2GEdhygVmVh4wGS+BTO?=
 =?us-ascii?Q?dTfn53PfQfAkMFWyrZmqiLrVUPBgRNbhfHXhKL8VZ3bJ18zmOywgHD+qBp1H?=
 =?us-ascii?Q?LWFjoYQwgNi2ekND7NpGPmjCQrLiyMtqk+A6LKJulKDiKER9nKGc5+WA3bwK?=
 =?us-ascii?Q?f5UVHZqJ0nxW2ryvqwJ4jUEIjHU/oafEoBLQ5oPRxp151Fbe63c5oKW1kHht?=
 =?us-ascii?Q?u0dijkDJaLA9tozNVID1B/l3IZCFA+bGADTgLrwRk8LZLJzhMaDPaDsGq8R7?=
 =?us-ascii?Q?MCMkimwYSrZ5mLlDab1oZChpwlPsSIoZpe9RvbN2fKoMu3Fp4HGdoPmoFzjf?=
 =?us-ascii?Q?EYhd1Wbns1hur9K6mrbvm1e9VI9tMOCg0Eiic+K1j0cqCYRgWrPE2uBURLXE?=
 =?us-ascii?Q?KwmDkSRVp0+8551t9y0/bqnxRX0dlSuUhPXehmszCY16/enMLvhXGN09GSlx?=
 =?us-ascii?Q?dUiUKPttyuyCdRhQzyKnNyQC7JfKNNgvo/IgF1A3B0VPX9O2C9Yg6SQe9HBf?=
 =?us-ascii?Q?nwGS/gQa3MIfFyRoe96ArOJ5s1uH49e8orgBE5psQY4gm+2ESc7PdblnqeDv?=
 =?us-ascii?Q?wxHF8RihlaLB6+e+GeuJBm3d08dsTPEqYjUTVQGtAGGO4Ybt5/MqTQ5KG6WQ?=
 =?us-ascii?Q?9lGQbz69Fcmq6Z8Sd3hvSUOHF1z6JT8DprMXTc5Ha3puZ66a1yglKVEnIWKU?=
 =?us-ascii?Q?oiV2i/abhQqW7bnv/Zdk9D0pVYqMkmLqq8czkwaZaOP0BXU2lU/H/agKyN2b?=
 =?us-ascii?Q?bA/mok1dtVacD/U2Egb9RbrFTNtrLPQgTAQFSwHGjupi2+b7bmRxu6GCJ6e2?=
 =?us-ascii?Q?Zh/IYymws2Igyd2+W7T22FrAniN37YoDFB3a1rS+BlXaxb7lgumL3tploRYi?=
 =?us-ascii?Q?Ua/Vw2+x8d0tinys29hELm8fFjRMnF6Qq6koP8/qAekJhB7jWtAaJSHdzG4+?=
 =?us-ascii?Q?I3ItdAdAfhfWrP/BF41SgKbFX2vb0GGuQCtd6/maiv3ykhLGX2XBH4yl8Ndr?=
 =?us-ascii?Q?wkZLu8rmNR3JoYcRZFLE3L0h7OfHr6WTUcLpS9oBG87MnagJ2TRNaapdBm7m?=
 =?us-ascii?Q?LARCHxZFy7/v/C45fSfS8nRmXnHfgo7Z9INOqof8eTT/vTP4ZLuUgsc0CDw5?=
 =?us-ascii?Q?IS6lfDzTlqRMsSKabxBLSC1zB51Ky5BMaP8iwqenzGykCiJN7hSOXp0QU3fi?=
 =?us-ascii?Q?OuzB4lZnYevbxUoQCyh1+vL3ptxzOxC4Mj396IMtKbheWHP25kdDBrdokwu3?=
 =?us-ascii?Q?dV/wsdQb97KKRA3YAn3HKArKiqGpjfIOw/ABuLNRWngpNaHatImGvoZIExan?=
 =?us-ascii?Q?uC8i18PfzgiNO0EWP36QlIQMWbYLcZY=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1a12971-468a-45ae-a5ce-08da3bd88eb0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2022 09:50:52.1293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5gpTpGJ4eDTLYfXFLl2G553O1sUhREIzcPrLlST/E+ntBqWBIfkxxJFO7KCZVEQBnABjv8E0EpN6d8TaHDuUeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5306
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series changes the output and the argument format of the Ocelot
switch selftest so that it is more similar to what can be found in
tools/testing/selftests/net/forwarding/.

Vladimir Oltean (3):
  selftests: ocelot: tc_flower_chains: streamline test output
  selftests: ocelot: tc_flower_chains: use conventional interface names
  selftests: ocelot: tc_flower_chains: reorder interfaces

 .../drivers/net/ocelot/tc_flower_chains.sh    | 202 +++++++++---------
 1 file changed, 97 insertions(+), 105 deletions(-)

-- 
2.25.1

