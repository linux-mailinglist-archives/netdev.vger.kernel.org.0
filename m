Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0023310BFE
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 14:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbhBENlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 08:41:01 -0500
Received: from mail-db8eur05on2040.outbound.protection.outlook.com ([40.107.20.40]:59115
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231169AbhBENiQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 08:38:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oEYBXb5KScdJhhMOlcSkk34+EIqNBTsSIpqohxqGa0MzzEcnJO8gNRENwwZL+tsnq2Droh+fk4732DlGfSmgZ9YfztPPd9I+tuIfLOFDgthu4UgBWfqghyTsSqMnu2jaWVTUiUKLGSymXQwMahrncn30MGytxbZzrcFEYhyuMdG06YmhNkyLQVMLbtzJjL3rGzcboINDzUFfmIJeZB9ccNnhINk8JSU9iCrrEFAEk4OpexqkoUig1ZD1HXJ+f1eZBNEA/iadNeRaxYJ9Aan9wjD20XUsfoNi4tG5+QKijnN1nTup3NM35GuPn+mHXH+FSOxfGZ6Jmh0qyXkIM9kAIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2mwvZpy3Dc/0E57L+L8Hi+Mv2RqAQehfzt2PP4ugE7k=;
 b=bNWQH4C/UTXvrvvMLmqcZ09FY3hBANfIIQLEDRNfyUED8FYpMnnBjN84JHUCKFBtXxEZQZ2ZlUqAkswC7IXzZjgvLWxFUdoEWwwHbTEvOeznekke06zu9KsDQU5ibSwIbTSqscKnyAUt8tGf/ciqp15jAHp2UueXgbmTOKzqtsQSuWpnANHc1cHAQSUHw8YMsXuP09b+rqImyXgO9T2ekQ+vHHGkDu+zWqOZpYHoJxA7AEgKb399nSCCVfg1pr5xgIiTzRSkDMJJ23lg1K4LbspKviWc6bJm7RQhgG9JsAXgFEskUJhh4arKFQ/wjlOMlW8QefIp5ZprSTI+zeCVoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2mwvZpy3Dc/0E57L+L8Hi+Mv2RqAQehfzt2PP4ugE7k=;
 b=K2lJz75f1g1BmqmOYh06cChxTZbRAATAUwSXBJxaTQn1p41Mvtf3gia/Q9Dm39Y9t4x+pfLbAeGNnddQ7SMVb31pMlx0Yv72L2mkOUvCYjMOvkxLvTPn01nOc4XgLfo1OnuOM0eefNgBmH7nb5qShN8QApks+oGKPYnM23sdu6c=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4910.eurprd04.prod.outlook.com (2603:10a6:803:5c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.24; Fri, 5 Feb
 2021 13:37:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3825.020; Fri, 5 Feb 2021
 13:37:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH v3 net-next 0/4] Automatically manage DSA master interface state
Date:   Fri,  5 Feb 2021 15:37:09 +0200
Message-Id: <20210205133713.4172846-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.12.227.87]
X-ClientProxiedBy: VI1PR09CA0138.eurprd09.prod.outlook.com
 (2603:10a6:803:12c::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (5.12.227.87) by VI1PR09CA0138.eurprd09.prod.outlook.com (2603:10a6:803:12c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20 via Frontend Transport; Fri, 5 Feb 2021 13:37:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f3746b5a-bdff-4f84-b922-08d8c9db2d48
X-MS-TrafficTypeDiagnostic: VI1PR04MB4910:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4910EAE384E33674D2E19F84E0B29@VI1PR04MB4910.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CTVUvcM5NfCcnzFHfEu9wjZBUQK8ZvKM2pDppiPVkQeaQgKhAqXdWuKk/BJFAJrEx+m5xNMMl/cBbbMS6VUBluG8c2TnEN1lnw8ypf5Ocl6LCyDUf94DkTMZtvkcgkbsnh0SCYy3YgKj+2me1tG0KLvD1MQ34EPwmnLGP/i0MArT0gv2rDpumIcT3oF9lhJxrzWG4TOVdvRncwXEcSo2jgjUGxSkgH4IbIk+ZQUki2BFmx5jW+yRGUP4UoIaIi57omzMEwOV/aS+fhSC/FkZsDIhHHs76ngaxYmtlU2lSbcSkpybQUr2u5jw6makWer0mLhZIaomq2hiRP4IGcjxejLFjFDoJ/74ym9gSeexQ60IjKdoNjbFrNqaaKD0B2KCInTZ9KssXaZ2RQ0qzkRotsDhl37ldOoSLQVQ+kZKkGlmpcbF9eG9EfosZ0R4DOREii3FRnDhNezvGg4BR9L6NHrhsk814I7oVBRPdOWXGqHdUbfJfOVKC4AuB6CdyXP9Fc5Udsb5ON0ZeqcIpdpAGcqw96QAnRPuuNb1UG0wz+yeWgOmumsFxwNbhlbB5cxsw25+Nrby5Q9gBM1yQkJ9Yg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(346002)(136003)(366004)(2906002)(16526019)(5660300002)(186003)(8936002)(69590400011)(8676002)(2616005)(1076003)(956004)(4744005)(44832011)(6486002)(478600001)(4326008)(54906003)(6506007)(66946007)(83380400001)(86362001)(66556008)(66476007)(26005)(316002)(110136005)(6512007)(52116002)(36756003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2g1T7knEfXwAS8B6JodfZwGVQcDfc13JfgIj8YLONxgxOO8eZVVN5yWsuTKh?=
 =?us-ascii?Q?BZplnDmx25NCyuFeIZpnU7i2YeZnS47g3HRWiOXLe9X3rSonyPVeZcQXgehh?=
 =?us-ascii?Q?NYwrdCFlaSNsjxW8dLIcLegIj7Txd0uEgoLn7CTTw8iNfLtgLnbz1iowT+FH?=
 =?us-ascii?Q?8BEvLUIlwAb7+mtGr2JupaQTS/rhZ6bKDFzBJhhm57XIo5RolUvfA0YRT6KG?=
 =?us-ascii?Q?7mTh8qWqlRldESZX1XkBlxXbmAuBCgt0+hBLwVEsjqiJjqc6+xUI12I3ouAB?=
 =?us-ascii?Q?CHtb/VvMJU63dseNpqsVkWRtxYSU6sLbdrF4tbM/stvJyckyC8r6UO020tfQ?=
 =?us-ascii?Q?4wIVGWDgtUBhJ7fWz52aBwOFhu7fqfxsX/gNrOCazjgildw9ZUJXpAgvD1NQ?=
 =?us-ascii?Q?TgIRUZLuFgsxPFrqdkZR8+Teqc96CGA8dNSTgy/WPXuaB+h9vBVgPDM5hbMB?=
 =?us-ascii?Q?z6BkWJD5H2dZa11uDhH6c5wqkl4wmuFEGLzi/mzmycWYaOIxEQXH3XtaV7mj?=
 =?us-ascii?Q?GvCOD1+vKNu8+livadklfd1+Kt19Vwh9gxQ8sbIJDFMWdTUsiRq0iBjxrnRm?=
 =?us-ascii?Q?6FwNp1yDz7aiZB0Q9PYBuw7OajdInNhLmrmPLKsJK5KWxL7bOrw/VyHNYKZG?=
 =?us-ascii?Q?r7FJi+sbO9IRvBs69VSrqbdCHdIc1JNby/zwmG9AmcHz4Jk294MhJDn0tYJR?=
 =?us-ascii?Q?9IOE3Gga2o8bkkpzeTRqT28DpkJt54S8jcE/RnI53O7i3TTfR6JhpTdRNyPh?=
 =?us-ascii?Q?y7s2SNEK0RGh0WG4KbbcHINXKQCsq11hKJ/r9VLJk0io8Mn7DT6T74dogW7U?=
 =?us-ascii?Q?kP/lUIO6s5m7KerNpZsIwxJR1UW4LIFfGUFlGe/am9LXh9+FIN62YN6vYX6H?=
 =?us-ascii?Q?4b4ZTU66Eo+hKyOa+W/SXBpCkRgYx/oCEAcl8z6xVnHhtf8CEkK+gJsmXfBH?=
 =?us-ascii?Q?i3q54xOD+d8MeTWh+ML/LsLuhrAJUnZNsh/Fq5LjoWOuwtPk7MPtgKM3XS9M?=
 =?us-ascii?Q?tZNJMG2Jn/QZWRd0XGkl8YXTPvqkNN1/mSk4FIPlqi07ca8NMTbeyP0ZGDWH?=
 =?us-ascii?Q?aI6AH/hguqOa3FlJxUdsqvedM6mEQRDvAjlfZViNW/S1RnylONY/1ZiPcyiI?=
 =?us-ascii?Q?0gRqnx+0ZhGnsb0UdLUX9IwxteWceF0zRjrdMGGZxnjJ1bOKqrrNj0pJ+uai?=
 =?us-ascii?Q?6TaDWnZJo9dBWGe3EEx8JMUhAB9AWR7JAeeIKEOXj9jtQl7kNgNmFPLXX5BS?=
 =?us-ascii?Q?uD26UsoPuoSh8JHHoOD5/QSja7U7wVma9SoOFXFjTzyj5emIF80otL9YI2YA?=
 =?us-ascii?Q?Dq/JrDiFv+BpiRSpWl+Jdv9J?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3746b5a-bdff-4f84-b922-08d8c9db2d48
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 13:37:26.9585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w72aAubcbAhV5sG40Xf1m0wcKwIbBugt55UsoVtWbdwdiWbbqu6AYlJKITup2FmyJNEMA969viC1RuCuPan5VA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4910
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds code that makes DSA open the master interface
automatically whenever one user interface gets opened, either by the
user, or by various networking subsystems: netconsole, nfsroot.
With that in place, we can remove some of the places in the network
stack where DSA-specific code was sprinkled.

Vladimir Oltean (4):
  net: dsa: automatically bring up DSA master when opening user port
  net: dsa: automatically bring user ports down when master goes down
  Revert "net: Have netpoll bring-up DSA management interface"
  Revert "net: ipv4: handle DSA enabled master network devices"

 Documentation/networking/dsa/dsa.rst |  4 ----
 net/core/netpoll.c                   | 22 ++++----------------
 net/dsa/slave.c                      | 31 ++++++++++++++++++++++++++--
 net/ipv4/ipconfig.c                  | 21 +++++++++++++++----
 4 files changed, 50 insertions(+), 28 deletions(-)

-- 
2.25.1

