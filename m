Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDE495183F1
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 14:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235099AbiECMMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 08:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234572AbiECML6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 08:11:58 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50073.outbound.protection.outlook.com [40.107.5.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6158237A36
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 05:08:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VVkC7AAi/szeF4UY6Zv2/0JUl16dwicWwjWeBZszozi9kj/RwzmDKTy+9x+mSJH3BDP9dGVVVbKTp5BHEEWX3UhlLRU9H0j3rgIBkJOkj2rZLIdiEdsp4iRhfaUgAKeyyU6ybuZidVM7EF1fWTbK+e0vJ5dO8CDKhnjJxdShETwn0LKuou7EigA2xUWT4tWhCy4yYFxknkz3qiq4NG0w7wkB5og30hZHTLbIMfIfPYkfpCcBVHVsOF4JCcankqk7Ya387fwP7WcNT/kLwFszM5W47ipJ0+PvW45cuY5BDMybhc1Pj+4wJX1m4GW0Kf0tUdkzTlTK8MbYSHRT5Zf41Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iyeUlvmRlwN/Mt0EHsuNHsvjBzBvHIZYbGuH8RuyErI=;
 b=AIUvynfnRx2C0fgQWesh92yLm40Peq2GKGd/WZCkIsKZncp61xXgq2RhZVFZpXvY5aVlRIfL+qQZ6wOdEzlvfUJbCbUzjob8n/3Ju63mz0/hi1aFwzBATDSzql82TIhawmhMb7/NTNqhJ32nKAKgTs7tknPkpg/wZq51EIPXCY9C0bbZ4G/0/seibEmHLzHG902AOKoxWl4Vl6oPMKPeGoSTYtv0V3wtGTyrC/KIWfCmUQ8jS4xlVeZQerOK35gA+U/KKxJaV+3cV7JSHU+otnCH8F8gsC4AKXU7/1CtLD170uTHb9tLvh6SX89+0exJeE0/EOCUCy+qU0JQRChrXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iyeUlvmRlwN/Mt0EHsuNHsvjBzBvHIZYbGuH8RuyErI=;
 b=s8BDQWOa7QAVBzEVeyrc1NOVwEnCa1nskzB/aEdTUNhpZCfUdVUaqGxsSK0Y5HaNAWi+N2heUfuxGHdbsQ3CYdGxqNx57PRGmuNx+lJ5ljGe3/2JzSpZR5aNilHdQ4+wTpaSClTN3Tqk+d4/0SQ0ZGls17FGsCl5cmSDkM3Fkgg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DB6PR0402MB2743.eurprd04.prod.outlook.com (2603:10a6:4:95::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14; Tue, 3 May
 2022 12:08:25 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 12:08:25 +0000
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
Subject: [PATCH net-next 3/3] selftests: net: dsa: symlink the tc_actions.sh test
Date:   Tue,  3 May 2022 15:08:04 +0300
Message-Id: <20220503120804.840463-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220503120804.840463-1-vladimir.oltean@nxp.com>
References: <20220503120804.840463-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0080.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::33) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29bb4cc9-3e76-4b3e-4cf8-08da2cfda03a
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2743:EE_
X-Microsoft-Antispam-PRVS: <DB6PR0402MB274304F915F98A8CF3DD7DD5E0C09@DB6PR0402MB2743.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gwX+2DhjDmZt2u9yv56m7fhbiMAflP38gAAgdy1ou0y/eTSj9XMOob6Pfoc+sfigO2ooHFHK/8gNq6+KQvpgkfbI6M2cXgPrqrZPvyaQ0NgfrzVZbHq6YiqCz2QZ3vWkVTIgN7Oj85+rE6l7tSk05H/CGeYDHpW6HxvjcyJnEpNE1F4IFndpbp7IO96grylrRiXgRNvGUJqM1sfogoxCumgUpVnpcfn7bgNpjrM25VWvi2FFqRtSZ7/hzhiqsShQ70x/8CHS6yuWCyuDuVC+ngV5gkSN/WnW6JdPQepHQL5lz/xGX4ayMLoBpykIoNaaTqllSkupKTrcmgEZZZP8JLv7ipFj3A1k5R5tSAz9Vq2+1Bs5vq6PX68nzeqHiXZ5iOufamyl+0WQ21b0m31iVm4Ei4jmtX1ycBidZlqLad9f6WCemz7+afUc5FMnRIJ4L1QzrAGP6Jvpb75IBdErbCYh5lEKz4nz8BZ2LMYfqynTWLR73PlQ3YcdhvMzhr79N7xxz7xgnijCsPXnyhtJY4y0baYIofmwlpCt8oQDBUwEdSjjukwcA+pQv0lYFte2j9HtAdw0jfxt46NwW3o4YxxNdAxHdcu/8Zjyw9oNvcsBRY52SvOFHcJt+nb8lhLMYmmDhgwmHupK6uYNi23VsznPFzqKV8hRx+1BMAHxm4Hdf/w3Zdf4JTfJfv5+mL7Te4IppCIbLsf6BCin44dwlg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(4326008)(36756003)(52116002)(6506007)(66476007)(8676002)(66946007)(66556008)(2906002)(83380400001)(186003)(1076003)(6512007)(26005)(2616005)(44832011)(86362001)(316002)(38350700002)(38100700002)(8936002)(54906003)(7416002)(6486002)(508600001)(6916009)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?36en1AHxi9PqqIj3+hMA0OhKd0pEeyOONrgxU8xHm8WDMj/DW72hEBIWMwY7?=
 =?us-ascii?Q?5o/kkktRKAS/iycwDPrKe9dUiTl5hZJy+L5W4UBBXadeZuCYd5rIYb+5bU32?=
 =?us-ascii?Q?evSQgbA3mRIhBR1vWi43KzXuHUOkvH0k/csyZXI0xtjBc6SjhJ6zmHNLZfn9?=
 =?us-ascii?Q?RQpvgVSSyV6Dsj3kOBO09VGsYZ385hkYZoOVQUGir23GQbnb5/GAHPqlvlAd?=
 =?us-ascii?Q?n1rPb+KpCtIV+IEn+LePzBs4SaqIhGW0Kboq5Exkke5i1rR76gkiWyRi/TYn?=
 =?us-ascii?Q?d8qvO7SNFpWBgYRtnrgeczIlXmwiksCR06W/GRL81MD3ec9aQqJ2qvVMj9dh?=
 =?us-ascii?Q?HOSGsHXPGvg9a/409MQv04sL2snepk4gfEgVwQaOrBl6+NHgmSZjZVYvJN+1?=
 =?us-ascii?Q?yWk7wpH9DXcEEJd6nRyBu0YVpmHeMH4JSPy07MFQkkV6Hzxwgzuw0DW1CaP8?=
 =?us-ascii?Q?4IFAGy099/ZfKXxzasHP1IntwJplD3NNTtWlGNoIEyxpdIIPRk7Y1on9XLhU?=
 =?us-ascii?Q?xsj7RM05AkqHows4O3HugbW09Avn2JJFW5xjDdJrZPifod35clIQdeWCkQmg?=
 =?us-ascii?Q?OX1hjQcyo1bqALqxprGDnBAgIbkSywXsasOt3DIaktvA6rifrpCcx3HG4zx7?=
 =?us-ascii?Q?0EQZD9wuUUYPrj4pFzN1P6dava8+ZJu2B0AwGPFoXDewi6OhcyP1d/syaUxf?=
 =?us-ascii?Q?hYfzLSZpVa6dgRpm3Xmgc3KaV65hv6l/skRfFo31LqySodjG0/VOi+JRU0PP?=
 =?us-ascii?Q?+E8uJ6JdMQDEF8qKEMs2YNn4Nybun8FtuwTv5GTFyZzpMsxXjK9YWZ5KCMY6?=
 =?us-ascii?Q?8F3u1hP3g49cx65Pq9KO0IoclgFPFoTFBvQduZiD9vNURJD0WxZmXuBB13RA?=
 =?us-ascii?Q?yE6vSfnqU+qZgt8bUJoOadLCGnxddiPzm3ZW3eSrwCMpVC+lYz+I4Xngtojb?=
 =?us-ascii?Q?SPaeAJlUN+KTvvUo+cuoU4bo6ePpnWbsoYtEyNKVNuX+RVbIKOOv8z67b8tQ?=
 =?us-ascii?Q?JxsHlNivq4GBDljjmG3NeukBNDIntR9bminmHFIbnoVXvLMWo4j0QK7Z2j3G?=
 =?us-ascii?Q?ZMN+ilbPqqLhUPvktRNLzFzgax+S9O7WH+XIbiCO1UtUMdKGhmp+8C0MFY7L?=
 =?us-ascii?Q?RnWUtiHUIhhvLYgmk0XnSAEzsKzK7fT58IbF4RwlQB1s+CWT+K/jg7SPhK6W?=
 =?us-ascii?Q?DyYGNfxIVmIt6nKgq95/01bqFcG9H2jULrVHfZFAkSF/Uu3FcAaCa8tccv0Z?=
 =?us-ascii?Q?gOVANtKQffT3zjONX5Jj4XYzS2ViFJoM3YDqJV0BY8/ny1uWEwmvCgpboDV0?=
 =?us-ascii?Q?f/ZyUW51tIcnvLqmLUAwvA7X1gsfU74ND8vRb61VHuJ2jt1LNXOMpPLfPy1p?=
 =?us-ascii?Q?EAgP5FsjMvt4vL7O+dsbr9kAgKTFgEYRJeumRYWPAbSSuzJa9Wxkw2UYehFC?=
 =?us-ascii?Q?xTNSaLDHTOP22P0akMXeSEFEGDR6Atei0JCJtwG7U7/yd2PL7hqpzy0Sv1ll?=
 =?us-ascii?Q?/ILmEA5kvxRG3abtbHkZCQQL3e1QVBEwHbhkRaGnTS/zw3vlTxzCRcQjj6eO?=
 =?us-ascii?Q?Sii64Pu4Ruri4fXUIpdy5PHh/QuHMDwnjcr8aKFzo6PTFqpHo1dIfyoPtWlO?=
 =?us-ascii?Q?VSlVVLP4NrFE+fv5X2tCskKFFNyr/ok7PxSnSlzZ6s/bhWDCPSeHfg2Tqa8L?=
 =?us-ascii?Q?szsKyB+5cQqQ+gzOhMGV9PLlP7EUPjzh69p+ucYHReQclmxFuYBHXF4vEWpr?=
 =?us-ascii?Q?qLvKWKqlXDOle2Pw5JvHokVwLj6G9cU=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29bb4cc9-3e76-4b3e-4cf8-08da2cfda03a
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 12:08:25.5057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dxQcUK+5Z/WzM5Abn6kAUikfNyxNriOIhRFzrDoghHFsRteK+C28B10u0oG0tCl9v0OAKlh3idlSSIP81ECHzA==
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

This has been validated on the Ocelot/Felix switch family (NXP LS1028A)
and should be relevant to any switch driver that offloads the tc-flower
and/or tc-matchall actions trap, drop, accept, mirred, for which DSA has
operations.

TEST: gact drop and ok (skip_hw)                                    [ OK ]
TEST: mirred egress flower redirect (skip_hw)                       [ OK ]
TEST: mirred egress flower mirror (skip_hw)                         [ OK ]
TEST: mirred egress matchall mirror (skip_hw)                       [ OK ]
TEST: mirred_egress_to_ingress (skip_hw)                            [ OK ]
TEST: gact drop and ok (skip_sw)                                    [ OK ]
TEST: mirred egress flower redirect (skip_sw)                       [ OK ]
TEST: mirred egress flower mirror (skip_sw)                         [ OK ]
TEST: mirred egress matchall mirror (skip_sw)                       [ OK ]
TEST: trap (skip_sw)                                                [ OK ]
TEST: mirred_egress_to_ingress (skip_sw)                            [ OK ]

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 tools/testing/selftests/drivers/net/dsa/tc_actions.sh | 1 +
 1 file changed, 1 insertion(+)
 create mode 120000 tools/testing/selftests/drivers/net/dsa/tc_actions.sh

diff --git a/tools/testing/selftests/drivers/net/dsa/tc_actions.sh b/tools/testing/selftests/drivers/net/dsa/tc_actions.sh
new file mode 120000
index 000000000000..306213d9430e
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/dsa/tc_actions.sh
@@ -0,0 +1 @@
+../../../net/forwarding/tc_actions.sh
\ No newline at end of file
-- 
2.25.1

