Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9055183EE
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 14:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235095AbiECML4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 08:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234572AbiECMLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 08:11:55 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50073.outbound.protection.outlook.com [40.107.5.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DFF237A1A
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 05:08:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mzqa8hUQaiD4Buwtds/cpKlmb4BZQhuNeSGUw2KofzgGsf5rMYdC9wrCB17dff0J2EbgCGK1zSE2unvRXyl5aCwWuDil1PAi45QKFQby/yMbQFJFOQoBWc1pnh+3C2shRHAWcWS79/u3n9cUpIsw158xg+qSxAD8Fm+XtX40JbukrdKpFTaIkFQPD00JVdFTqTJ+AwTDGH0FHBy2hwebcAvB10Ypm33YrB4xSqB7oM5SvwE+/TPu1KtYJqUf6a7Nl/+VErZXYWa5aMf7puQEHFxKvhLrXuKwVTbMp9zmavphTUXQ5aDAE2I5mSQRQSBtKEvrDggMFIaLXLnf5G6r8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zdxovuTBTbO0dpP87isQh6YF3f2JblEar9UuGdtYpek=;
 b=Dwt69e2xyBQAn2wfkeFLcNl2OUACrVmA4It4THvjC3vV2AgxBncc/Hzph3AC7pBtyUFENVYCZHYOe/RaU6qrVWBgGTUcPy3YlDkGnLoFr3f1gh06hwSmhlMORmiQBaaHWxAij25e/HMZwhNfzbzlWIRo1qRLAASO0dp/+KnxY0ZYRDPx8IvalTrGQ7vWXj57JXbG6Du09mQbg9qfMw9Rr+1p0nEdZwuYfxon6HPsyvxeUOqr/+y9a+uNp/+eCbzo5+7/hnJFAWCJ5X1IMaFsXt/0aH130SYMq6Z9HvNoEAKyoCBgD1pNFxF3bLZqqUDrTQUgWo1Rkk2lhUzcDQd+MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zdxovuTBTbO0dpP87isQh6YF3f2JblEar9UuGdtYpek=;
 b=VjxtFrwER0+plvx7dDori2+8NXPkDmzZWf82jh/NtxTvkIpSU4mPAPvGzOeQWINYJQRG6cPuq3Tv3lrRTWBYfJx0S2Qov3iXuR8ks7CAkNzIWydZ++4NQTXFzLzmwuBoJfIhgQQplK2JxkdNGjfDOF+dq5aruyDWU5n0geHmgw4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DB6PR0402MB2743.eurprd04.prod.outlook.com (2603:10a6:4:95::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14; Tue, 3 May
 2022 12:08:21 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 12:08:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH net-next 0/3] Add DSA support for tc_actions selftest
Date:   Tue,  3 May 2022 15:08:01 +0300
Message-Id: <20220503120804.840463-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0080.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::33) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 790d69d1-06ba-48aa-a401-08da2cfd9d97
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2743:EE_
X-Microsoft-Antispam-PRVS: <DB6PR0402MB2743A9CB4E5FD0656FEB58F7E0C09@DB6PR0402MB2743.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tIoJrSRTT3CrCTa8aZYpgZWprf+Ni51n9GODVd0vQ7P1X3ZSQbK3Clb6yK8cSZrDDU71itHTgiQZu65Dvsqx9tRtXYKP+y3bMVhAGZpAuVG2lQjfuoPKeiT0QoTBvqR8DcbqTOF7FTqtjjzaYfwSXGp3KWqLh4EI+SE8g/xQW/TsOnjT+pAX3SPsS3E1JdJzZlXn9ZCB3hCrxqgL9mTrA30fpmYiHfvj26YzNNfY6OJqW5ivQ0RMmiUMCwJ59mwvYIcBVrR+UqRaIAIqjby4HlIwE+LKOyqIAF3TIomyU7aaUUlcwEqysAnzay5XgfdRcuYNEG34SmHxYsJ/+N/9dVyNAQ8LPq3Mwc+LWZ4FBodSVNp8vH2VhsrgRH1kR0jjMQ5HjiJHlhowPYB6vZYVn+0bFEomFpPG/MQu+Bsn7DvKOLoBP4BPQgCvR1nrKNCCQhaLkZyGW2PxM7HmAbceAlPbwETVj0xo/0pL/YrPhnbE1FCosgNFEYtyoi36gSs8hIb/F8DqbBtW9bEkCsrE3IshywzF6GiGFDYxGB8sQhWhNss+M2sFgRjuiyxTNn6SQtheCHj7xskqLyM68jPH+Zrx85S9Iz3Eece63Xs7pJfZZO73kWQC1GURHTOZLn9Ckfm+d79DtabLj2YBHXVKiywNBTb0bNeyJHqW5A8eHW6NOQdCM7SbYS25Ga6RRktfiCDNdeTG9p7PXY+mfupe5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(4326008)(36756003)(52116002)(6506007)(66476007)(8676002)(66946007)(66556008)(2906002)(83380400001)(186003)(1076003)(4744005)(6512007)(26005)(2616005)(44832011)(86362001)(316002)(38350700002)(38100700002)(8936002)(54906003)(7416002)(6486002)(508600001)(6916009)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZRoSJxY2i0Srn5nzODvhehCUgIpbTuzvXHfEX/KvobXT8NxWWa8G+rw8dXLR?=
 =?us-ascii?Q?JKZg27eQyJpZLz+ha5QALMSflFff81PmVxMXDFWZ9F5YvrAt4X5ZlASy/gfR?=
 =?us-ascii?Q?h6yQdnDrK578LDWxJO6osIlJ7v8CPPA+u3kQrqpMFc1XwCNrNhJPjLoRs3U9?=
 =?us-ascii?Q?/P5i41PkqJaqRyLYoYLEV7daLBzo0ANFHiIB3BRemXvKY4VzB1cU8Hh9byDa?=
 =?us-ascii?Q?Jko9kDD3A7dD8b6Dmg+faVQ0psdoLSP3hbywLsdI5R4FzPlBv+IGXWspZ1xg?=
 =?us-ascii?Q?qQMp7C58GVnoOBBeAWaIQ+ervAC5jB5jXFi1DYxS/K1H39seZU/5q0+t5znE?=
 =?us-ascii?Q?UrxAR6uv2GGKQ+GHq40Ye7OVJZxtK5ydGYJFbIt3vQ0nM9k606qw0wNXJIoR?=
 =?us-ascii?Q?o3yYzU3HVCMkkgvVGf7UOzCI7nxNDsCJErWb8Mj4qZxZ408cazYzdWVX6xQp?=
 =?us-ascii?Q?Ci9QfYW5VrSQxANG4AsCeuqTZTeYMEI3X7xBZtmEB0lC6Aia3AeCitW5jRqc?=
 =?us-ascii?Q?I6drAyplyTOrfMraRruFoh3C5wLe6H3ZoCxvpWJbYApeDa3NPW1zI6mb8gKf?=
 =?us-ascii?Q?KW2PmFWkFGD3JDl+gFOjfu3QgCj3amoVwk3HsqxUpyCSm5wJKtg+Fv1/2oLi?=
 =?us-ascii?Q?LQnWDgKSwo9Vc30fm+uZSM3IVgUKpEONF+AKxZ29BUSgJhE2842qnpLSTcCW?=
 =?us-ascii?Q?LyopZZgTeevkomnGbxTLhOhn5MVQnWn5FS8kbThlgzJMiVCy8PyaG5rFAeqA?=
 =?us-ascii?Q?Wf1KaOrbwAC8s9rKSpq0NHLTpQJYxs+Vx6+z/CwJEo+sk/PR7akvvaQYB4RF?=
 =?us-ascii?Q?RV3qc3MpJqo/DVB9LxKMgo5Uw0zgtePOhSbrUd00Z+VjD5y8v6I248nWNL/b?=
 =?us-ascii?Q?k+xpPcOmulDEZwcG90/UfrLwoCuPEXnxfgR+pQDIIsZKmmlMwlwY8RY0W6+k?=
 =?us-ascii?Q?9xqDyQD8nYmSSx/3uTsmPmlT6z+AblAMUOnh2zeuPaEKYqkuiS4u0PPBomie?=
 =?us-ascii?Q?9axa1GI8N/wOQ1MJhIr7Qv4dGCNWt6+wtF1KFowx3YjcgsnXINY/kvtbipHO?=
 =?us-ascii?Q?4Mu6xpe7RW70vmUCUgCB3mZZ3NxVzjlU3W0wQkFN2B2CDRVt5u85bD64dPjQ?=
 =?us-ascii?Q?8tiD2u2RK1zfgGDTiwb6G2p2n3q8ykGkxDHFtlHPZbXfrDsI/Q+JIV5sg11x?=
 =?us-ascii?Q?nQmqpoBfDtDNiGWq6JKS4/lTaqKu0wz0lFLeCNz9z9b54E4p2w2tuwAYRX/7?=
 =?us-ascii?Q?frzpfiWXG2bnxluQkxvbgbONNTooaKE7rdhOns078RFUB44cy7PHeTQmPhZD?=
 =?us-ascii?Q?j5dPyUkIqQ1JJiqLdEzL5blgoSfCKAm+hXJ4E8HA1A+3epR5Y7C8uOgs4Qe1?=
 =?us-ascii?Q?1fPMctA8z97Knh0WjAiv3WFpJYd7ifpVAf76C0MB0KBbHigR2yHwR7URT1KP?=
 =?us-ascii?Q?CVdva3on7/lDNr9IIbT4fJBTLhqhnta5EZYGhjjjLQ5QcDIVvrK2Ehv0S7M2?=
 =?us-ascii?Q?vi4aYUZ3M9cjTigfE5Y4TlZdXh1ap8tl1bIBBgkgLzkplbmk7a0bo3ebkMys?=
 =?us-ascii?Q?xCqfE0x3NgFSawysdxi0+iogkp9Gbx7KAmKBdCIg7F35GA9bv5sNLWazCrpj?=
 =?us-ascii?Q?pI7PZNKINBPm16ZG8IgbFhwXUNwyeMR466hKu9fSkdmJxyI/QlUcHkCqodsg?=
 =?us-ascii?Q?Z7l2ZLBEQ1LTohSJuix5Rz0xYrV1M3d+PwJzjAiqPt91ngSAKH+La/ADFt78?=
 =?us-ascii?Q?/85syic1LDcTm3xH8cRy5bBxK1HmjwU=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 790d69d1-06ba-48aa-a401-08da2cfd9d97
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 12:08:21.0686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lkdMZap2Ob7XKb6b6PKeZSQLgRY9bIE+mGC9hsl8UsAveF8X2orIErYTiVzFTOAZquZLMPZi3h96VdaioY7S9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2743
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change set makes the tc_actions.sh selftest run successfully on at
least NXP LS1028A, which includes the felix/ocelot DSA driver.

Vladimir Oltean (3):
  net: mscc: ocelot: offload tc action "ok" using an empty action vector
  selftests: forwarding: tc_actions: allow mirred egress test to run on
    non-offloaded h2
  selftests: net: dsa: symlink the tc_actions.sh test

 drivers/net/ethernet/mscc/ocelot_flower.c        | 16 ++++++++++++++++
 .../selftests/drivers/net/dsa/tc_actions.sh      |  1 +
 .../selftests/net/forwarding/tc_actions.sh       |  2 +-
 3 files changed, 18 insertions(+), 1 deletion(-)
 create mode 120000 tools/testing/selftests/drivers/net/dsa/tc_actions.sh

-- 
2.25.1

