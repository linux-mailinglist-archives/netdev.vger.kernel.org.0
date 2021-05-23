Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 498F638DADA
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 12:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbhEWKVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 06:21:49 -0400
Received: from mail-eopbgr60080.outbound.protection.outlook.com ([40.107.6.80]:54404
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231666AbhEWKVp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 May 2021 06:21:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TuglYU27UnEoRrSXBKzZq+Zn3TgSLYcC7J/APJNMllrw8S8Y2HQaZ5oNlKZwOVx4IdnoXsDmNCiS1YiqE85s+mfEEMbRORKiVuJS63OX19RZ5C+k1cEZW/WMt0Ap7wOnLRVG+YRmRypopVTa3S7XK0Y3UAUrirGkkT7eUU3CHrlh9l5ohoffhzJ5xtdeyLtY6XANkAGx3PZqlEd/KHNxg7xQv4qOTK8V/qD1LdrO9+ZlN9ky5fL3rZASE0lcd5Ie7AehuWQwLCP2PqWW90K/JVE54bt6tnhBrTiriq9o27tP26ySTjhygjBiPbinXqz+SQc5t4dAg+BsWaXiOePniA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=osSKSHNryS1NU8gzYVYYXS0qKxwLNz8tvKjtxAqeErk=;
 b=HD6+6H2iMD2l3bOIQEAtAK5uOE52HcURmIUP1fv/TdP8PmrLcJs2L1HoQ5xlRxY+PK7nqWJMBJvj1sMQ1OExBP/imEGshxD8b8lYa25DGi2JMrus6/njKMqyW5s4gEuObqXbfjZc7dyuNQf6Mdxk39EBuoQ7LMbFp7kcq6K3t6LbjbVf2Q3GjwFw26aA+7qKnBTcF1bZ6gEziRRMaNZLn1ahRpbLNYE3sVUKmOAkUUvnNbXVW/nS9px10kwEjAhdmRXdhhLVlfE8JJbfPiWOV5VmADdD8ONND7LuOAGjqJCGi4pTCv0F6Y58kg7QPp7F2z/+NF8R0Oo8guxmeKxMIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=osSKSHNryS1NU8gzYVYYXS0qKxwLNz8tvKjtxAqeErk=;
 b=CIubixYUn+eCsuQsM3z0DCEkF54TWLVtGmNICKUoE6kgrdpCV8JnXEI3CuN+njlM2l6N617AFndEXPkR93bvfAfSGTqbhWG8de5+gHG58CX+VzTIFUvqvKo7kVWMugwfan8G+v6ERv1XbEN4t/2cTYt39OEAStfcwcXcDXmrrx4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB5788.eurprd04.prod.outlook.com (2603:10a6:10:b1::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Sun, 23 May
 2021 10:20:17 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 10:20:17 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, frieder.schrempf@kontron.de
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: [RFC net-next 0/2] net: fec: fix TX bandwidth fluctuations
Date:   Sun, 23 May 2021 18:20:17 +0800
Message-Id: <20210523102019.29440-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0053.apcprd02.prod.outlook.com
 (2603:1096:4:54::17) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0053.apcprd02.prod.outlook.com (2603:1096:4:54::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Sun, 23 May 2021 10:20:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e496c662-5fae-417d-390a-08d91dd45c21
X-MS-TrafficTypeDiagnostic: DB8PR04MB5788:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB578813A7F366DDDB67BD536DE6279@DB8PR04MB5788.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Woa6y5KfyEV9cwU8TngVlOwsQXHXFVYLjoyfb+9+9yb3Isrtub6M014Jh4XKEjdJ4MS97AKw3+asUN7IHq+obdwSKywlbJdfU3PFo40VIt085+iuwLuQr0KU83R8jGlJLsJy4kIpIbnZa3o3MxIsUTYKDilNu9kAlwEVer25zgN7FazGJ7UWNVQykLuD56YUzkwKdFJwa12zrfBVAI+ksYlwzHjn0xbP5Of9W9geK/SO/8jfbByTKc3/luiTBTAOYlp1VYnKk32CpPVenlPbt0gnwrDe3g61h6qzd8nKgh/lt1gg4BW3CrOJEahSbh8U2IVuwLgBbJpuJceWNm6ROXrO9rzNI3rTVg0akv7SPl1GI6B91+kD3dk3o494LGLtmQLGq1YhO6pAfvimaUr4ycA6VGq1ufJBw1mOu5BcAGbxVObUk6dtg4LR2sgPP1Ok8lE43/GbokFqwugMMQAE8/bdiHleGHKucR9AzeE8QJaL4org1a+w3F6RPAYvU0uXYjYCXCv93gTCUwiJC5fDlZyhNxr6gVKW5GehRaut6YFeiAIhDz/ylvdy7pwj2VDzcs0rfWZlYvN9FBMB4JtDb4/wFC5fOuwfz+UYSfgmfOIWD9A72PtroIdqxsSbSdQhYUlo9sqczsbH7bw0+r7Tt0ylSUhmK2sBP9ZB69lPodCf6qmQ80x3By5GJLJoBSHm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(136003)(366004)(346002)(52116002)(8676002)(83380400001)(478600001)(316002)(86362001)(6486002)(66946007)(38100700002)(38350700002)(4326008)(66476007)(6512007)(16526019)(186003)(4744005)(2616005)(36756003)(2906002)(6506007)(66556008)(8936002)(26005)(1076003)(956004)(5660300002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?r/6UnhiE1vo6VnC+Zx/3xfd54ZKIoASbEcHYup7ORASlihMZBLhU+EXVrMSF?=
 =?us-ascii?Q?bHXQOwFD/4cS1Hhh5ObfNmGDYLMzqDz8gzZ0GtwMK3Hcy2NN2v2wgc0DZ0MV?=
 =?us-ascii?Q?ArYk/zO2fAXEI9Ab6/ObuEn//mOhUQq8iQ8LyV7ZJFuT/xJNv7EQ/ut4pT+2?=
 =?us-ascii?Q?i2ZlkwicFmAhlRZzVnadlGJrh/khGlRQfUP6udBYv5EHYKSBbrYgxZymTvcD?=
 =?us-ascii?Q?CR98dDrmqYUhhcDI0/tCfA2ACffIIo2UzM+tqH/7ms8cZ6pRlOIyOCGwN4ts?=
 =?us-ascii?Q?Uv8h/l3o2GEwg589I2VpU/dM6cJC2ETte74wguAuC0KJlxblGrYLj26Hs3JC?=
 =?us-ascii?Q?O5z1jehYm9eEn8xyxUrmXuEiRRc3wg59+0E2NBdsh1ZtvIIoYmN5ZmI/cdFT?=
 =?us-ascii?Q?dk+27pUU/by5CjPMmkYB8SrIyZE93dMIDfi979NXMm6l+BI7g30mhxsV2pRo?=
 =?us-ascii?Q?4CJnahLrAkqEOB9v66IjVORPSRzvLqs2mQ1TBnlIXAGfC79GucFhkF7C+Q3k?=
 =?us-ascii?Q?iUCKtb7AQLku7pPOpjm8LIcsofoidNxzqlhcDYW9oZBEinmcWsVyoNlz7742?=
 =?us-ascii?Q?XMSvj5mfAZPWj2QMbbH6xEMc5GWAH9/kxWxVyCXT/fdR2t1lKnyrGO6l4IXg?=
 =?us-ascii?Q?CRa7c70ZIe02QV1nhLkgmt3+vCeOFkE6ypljc5fQ8s9mr14ZD/Y8yDyOpq5A?=
 =?us-ascii?Q?6IsPA4qlfxOxf/D2R801xFDTh4TlvQ68iM4wMga39KzgY9dzUxwDn/m+MNwD?=
 =?us-ascii?Q?XKs4sipm7JKMf8NmAPjMQypeINLeRDgDBNmWawnB3osoOPdo+yKNLW/RlioW?=
 =?us-ascii?Q?8SQ791IuZ2bq3wErzAY7hXZlWkGyTl2xneT7VxWICjiVbW2qtfwQCXv/wSP1?=
 =?us-ascii?Q?6vd12I7SBcSFs5xViOtHl5BlY59MgFQkGBTeZV28r8x6QFPJMzCzjmum9asI?=
 =?us-ascii?Q?hPvfMgKNcuYYiz8EhF+6zKaAA7zru9nqyhuT+pjubR2iNbEo43Az6Np2xfAc?=
 =?us-ascii?Q?NTF1yZwqOhqREp4gObPbbwlU0f066U/fYEl5CQDyAJ35BuzDV3tt0Tu7/JA9?=
 =?us-ascii?Q?MVrALofJzggeSdtYpU7YcjQtN4h/DgBZIEgC/rivo6/0hxkaMJp5W8Re1JlM?=
 =?us-ascii?Q?G0mVLzYfEtEDOekxgr3/DCUA+lOJ2rcF5XWE7w5cKbAmOtGEm8FIbJstPh42?=
 =?us-ascii?Q?adBwxFkGPfEQZwcYl1/D79I7uZ/0o1Rr6vpzI3g7jE8pVGDvONVqTJlRUEEL?=
 =?us-ascii?Q?Kl3PVyJTTXmrHJDMy7LcbVvF25OzfxFV3pLjC86+r2TnMpMbHAIRf9xmrpna?=
 =?us-ascii?Q?BNKtRewfJbcjRpgbTGKmwUEv?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e496c662-5fae-417d-390a-08d91dd45c21
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 10:20:16.9223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oOx75b/2DMYaSkD6Vqj1zJ8u+CxPKFZihrSeLtmqlUgpw2P8YtGkZTsFROqWdVuFT4x1zuCIWWnqI6adLwHK/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5788
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set intends to fix TX bandwidth fluctuations, this is a RFC,
any feedback would be appreciated.

Fugang Duan (1):
  net: fec: add ndo_select_queue to fix TX bandwidth fluctuations

Joakim Zhang (1):
  net: fec: add FEC_QUIRK_HAS_MULTI_QUEUES represents i.MX6SX ENET IP

 drivers/net/ethernet/freescale/fec.h      |  5 +++
 drivers/net/ethernet/freescale/fec_main.c | 43 ++++++++++++++++++++---
 2 files changed, 43 insertions(+), 5 deletions(-)

-- 
2.17.1

