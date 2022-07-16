Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94FDF5770EB
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 20:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbiGPSyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 14:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232457AbiGPSyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 14:54:14 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130050.outbound.protection.outlook.com [40.107.13.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A11FA1D30F
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 11:54:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gm5+Pj34y5I7U/FQ7VgzmKtRNBtvGdtMfWCAA9+fgPCs03frPrr5Sfc3OOjfDBVsy5BqhWhxi+4J7ZDuycog11N9ThIUq5HWD003ipmeRe5ozop9apFqIfWqU7iyBY4ptamFzHAIZYO5B1VhuwBc1CBknaQzg7OwH/HsgMZNxPAhz5B495IilJDLabIfQOukzFNP7HEsGN5kfS6bGd0L91QhzAjFkz0yQxuIbC1l+I17fGiagvlOvtg6y07NwYqGGKFKSoBklbFeK6WxOfMOGse3sJIc3AbE0WntKbDQp0OdEaVAfiEoVctVS+hKdLP9ZzTg/p7cTWliu5P2veQrQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=POy0Y5Y84ENFBKfoiOy16wl+0Z6ZstfWkJUgnYOv2CA=;
 b=PhGkAv+QDILPsv0zwy1fHuKXEK6fEMtHXBnaqVB8DW1j36Pv4g/cGCObT/f7jvlIFV9SViFCfDxDPCa3HsWlv1g3j3TmnfTyMsC2WiureGmAPAiN8Bi2QAMbbbRwS/Yf79MoYzrIEtjwXSKKtVmmSyJxMx9XremfmvMLCFstDtW+w5dZyUS300eCqzumVGSXDxHQWXdjPzIKtgipAcJRn6iQmzgItYaieCcbKBr++JNgh7PnNWJplUUmqecBI0HPvWk4BZ55XxPb8z/v/7MeizLnCKfNmEiKi1uQPzwEKZYGFTCcCTVKnRVTPguY3QPUfQASfdOrYCgfuFE43qRtPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=POy0Y5Y84ENFBKfoiOy16wl+0Z6ZstfWkJUgnYOv2CA=;
 b=UoCi6lzLxMw5ISqVpV+LezyqIfjHIfJQ2TUhUrFUSkFKRuQxBTjhlC5YssVpfqDGc7S9fg6HY9NJyPG96CU1WEqfhwKQ3TkxhHvkngEViszOx+pjYHxpbqJQxTUfz24nKI9z7VxF1cmHJAWu+U4LcJAoQWkXCGE77Lh654kpsVs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by VI1PR04MB5311.eurprd04.prod.outlook.com (2603:10a6:803:60::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Sat, 16 Jul
 2022 18:54:08 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd%6]) with mapi id 15.20.5438.020; Sat, 16 Jul 2022
 18:54:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net 11/15] docs: net: dsa: delete port_mdb_dump
Date:   Sat, 16 Jul 2022 21:53:40 +0300
Message-Id: <20220716185344.1212091-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
References: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P194CA0101.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:8f::42) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6eb5bc6f-5ded-42fc-26ec-08da675c904c
X-MS-TrafficTypeDiagnostic: VI1PR04MB5311:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u6jGfqPm8hTUJHPaAM94eroK/dyg4f9dHJH3KFkRAe01QRtZ+fTzkvejJ/XcUR5xtwNNTPNDVDhzfbWP3nAOjvXHnLDvmUA6G/Sh5oOeqHzm8xIz5E7CWTPcNxqxgeCNEbNk6yOaXL0Wvjf6Ouca69cA7v4hgQQuheFynhQgOfMsfPsJu1MwnTH+LUee/FOaQ8b4wd4kNNMQFbARbf5pQHcfFmZoEkqwnixDIYWo8KoZZrsG6xZUoofwzcelyaz/K5DjqFnjan4QfI2ZGDCwD3MlUKLZFg/YtcZvw0qNR8cSawRtc08zm3sqij4y5QIlAgRi9VSuFVTUG/OPJqXQbmAPZXDkSKfJN57u9FXdOsyAsdq5ynmsKaD7ZYrRy96EPjHqe03l666MXmiqItKJT6rsJxBiYYS8adCM3SITQGFMvwwI/1t4CWEK+5S8hg0fyRYBz+iYK8oAtit+KxvLOMIxsaFeLGXrSH4Nu4w7aUOb5P9aOFP4fNurfOce48ron4GdKXXONEFc9S7+VhHUvbQp/RUASatBbGT1uE5IlmaFEv4YJdWbo+3ohmpu04okl0/1l595HyUz9L3vFPlrVldY07cLTcLEPvzfTK5vtO+gRUfs7P3K95EinMV+1qGdRxgT/giL1IIWSRv348SS/N7BUM6KK3ECazX6CDSo71JgDTAm+H+/8gL2RoeAnvRX5g/P8eCGZq7CyR5+chJYNuC3638hIcqFzE2bYzMOW3NJwvJb5nFXTDfsBESclfRx0tTmzwc0ruTz/JYnrG+r5nqB8ib59xGr6LXwK5mEFm2lP43omkuBIbPM5tst+Qx2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(26005)(6506007)(6666004)(41300700001)(6512007)(52116002)(6486002)(478600001)(4744005)(5660300002)(44832011)(8936002)(86362001)(2906002)(54906003)(316002)(6916009)(36756003)(66946007)(4326008)(8676002)(83380400001)(38350700002)(66476007)(1076003)(2616005)(66556008)(186003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aF9XXYpovV17bxMNQsMWcFCD4gVybVVSR1d+AtJHwgW4a2y8EXxwNtt4lHWj?=
 =?us-ascii?Q?eK2Q6q+h9FfEQReXB5MYyjMvKuP3u+OwVJEK9qw9QUOp7PC862HPncXKnZxS?=
 =?us-ascii?Q?3CokxGNHiDj0KaL0LEuXwtBJZcQgsOm6bQUh3daQYIrn19zW/DhUpfGHKtZP?=
 =?us-ascii?Q?NPTbevLdbxpHXp8XMB6TgVBNW4jIr5ygScuVuWrkenClE0iLgakKdRuyeRdT?=
 =?us-ascii?Q?GyFXZztp2mHON+72f9GxD02q81XIT759/0hJ9CM4d9dxvob59TGhUPj4TtHW?=
 =?us-ascii?Q?I2Jnm+Qs0GQvl61MBMt3jj893c9JSFnBwaj5UR1iv8e+EwW2WZCX5C12mCv9?=
 =?us-ascii?Q?cZOYZV80Spf7CRDuA8vWjkCaAPDpbL6D9EcHP2f6b0hypmRGG2OzqDAim/Z3?=
 =?us-ascii?Q?vcez5Azskt39OEAfJnoOY0Ow78/HTTfjWnPyZ78iOYeTgvtmkg17qO0sy2x3?=
 =?us-ascii?Q?VUGZELilA6O/kE9Qugd6u1xuv88ZWs61voBTM2Hv//5+1l6J/DF8Wwx/SQo7?=
 =?us-ascii?Q?jjMwIzVLG483mgzSg9OnYzcGpYm9SWSKKmk/8pZO7U+ZoGO82bRWHlB3InIl?=
 =?us-ascii?Q?Y60986IGVYjXsQwy5wnSCk7Y21vMti//2je2TR/inRkviLKGV0Qw7310u8Cw?=
 =?us-ascii?Q?k03pIbRqu+aZnTDsnhbKW3nEO+H5G0zSwh8bvEmrnr6vUqpGp6xjJRrqLz+S?=
 =?us-ascii?Q?1PU2ioClb4enjnCZNbAWio0WmsbBTNPUGMK/ijoH7gWXIU6apuyMN1OXnrvy?=
 =?us-ascii?Q?qPlQ+WzRkUY324k6mdduo+ohudIcIXd6HEJK6kfbStxNqpeC2sJ7xv8CSEID?=
 =?us-ascii?Q?rA41JeZ6s9+mfDO2bsum6+iT669QtfOOBJ8WFOTRKV9Co2BpIDezXChxat+q?=
 =?us-ascii?Q?Qj7qU7/pB9wtbJxERyCoZWo+3V7K3lTASS9uoclSNi9WRPaZRZjGkyZ+4iFc?=
 =?us-ascii?Q?h9hz8r9KOucLtUUJ5C+Y1cZZtnkpm0qI7+5MMmLvj8GhyF/o0AgYsdOtrhXU?=
 =?us-ascii?Q?FXNsYc9kn9nT/T6YSnlACN7XTdeo2LvHpi44oidfUmiVZbTNlkRVgmdnCduL?=
 =?us-ascii?Q?2JmWUsGsSJ+zuBZMxW2Z/zdBl37bT3EN1cfSFe2b9+CKYe0WtybSbc8WwdvT?=
 =?us-ascii?Q?nlCsIsSfOWNaFQ8vZGjQ7XnxiNRsikAbtWNJ1jbdJzn+z3jQ/17+/t8DHmrl?=
 =?us-ascii?Q?lSEW7lS8qHxKbfGPn0m8AbKzGR2T6AKKawcw6jFtFVGP+/5aL8WxP4xM/rPX?=
 =?us-ascii?Q?4zrtweTtiVl0+9vTh4WOss7GMnKOv+C8HCwNxG8ew1KjIWWmlfXg/A8rHzDq?=
 =?us-ascii?Q?HJSbumgB07Ro2tbo0srKpCJuembOLUnveubNo4acjhsVmogoG3s5/zTI/Ga1?=
 =?us-ascii?Q?eBs9JxTI+OWGroXON8BHhcTY7pZqKTIIugimkd0WKtYkJC+VWYNfYjmzhqHU?=
 =?us-ascii?Q?piSYapqzInOsIGo9z0xXLFHPkjSgbUBkdHSzTfShKwsJ0FhS2o8On+6o4xqr?=
 =?us-ascii?Q?funQ76vrmjdPq004hp74ncdnawQoZ6Vz1LXu+N50fU6mO/PyqEiyKjN4gctS?=
 =?us-ascii?Q?DDGzvYDajUuZlYs6F8RKM4/BV3WVtQRxY9N1cW+D0Kt6j3TnGGTjng1MycbY?=
 =?us-ascii?Q?lQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6eb5bc6f-5ded-42fc-26ec-08da675c904c
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2022 18:54:08.3783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1JIDJ6yB1hmBZHoRN1KBiqnoxKz2GYdGe4ZaYv0X+XIR3Y5rC4D1oNQ72DNerVD8lB1NZphhqeEelbTPq0NXGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5311
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This was deleted in 2017, stop documenting it.

Fixes: dc0cbff3ff9f ("net: dsa: Remove redundant MDB dump support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/dsa/dsa.rst | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index e61eef93be1b..118853d1d7ac 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -862,10 +862,6 @@ Bridge VLAN filtering
   the specified MAC address from the specified VLAN ID if it was mapped into
   this port forwarding database.
 
-- ``port_mdb_dump``: bridge layer function invoked with a switchdev callback
-  function that the driver has to call for each MAC address known to be behind
-  the given port. A switchdev object is used to carry the VID and MDB info.
-
 Link aggregation
 ----------------
 
-- 
2.34.1

