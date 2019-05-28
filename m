Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C13532BDAF
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 05:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbfE1DX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 23:23:58 -0400
Received: from mail-eopbgr690059.outbound.protection.outlook.com ([40.107.69.59]:32996
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727342AbfE1DX6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 23:23:58 -0400
Received: from DM6PR07CA0038.namprd07.prod.outlook.com (2603:10b6:5:74::15) by
 DM6PR07MB4442.namprd07.prod.outlook.com (2603:10b6:5:c0::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Tue, 28 May 2019 03:23:56 +0000
Received: from DM3NAM05FT042.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e51::209) by DM6PR07CA0038.outlook.office365.com
 (2603:10b6:5:74::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1943.16 via Frontend
 Transport; Tue, 28 May 2019 03:23:56 +0000
Authentication-Results: spf=fail (sender IP is 199.233.58.38)
 smtp.mailfrom=marvell.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=fail action=none
 header.from=marvell.com;
Received-SPF: Fail (protection.outlook.com: domain of marvell.com does not
 designate 199.233.58.38 as permitted sender) receiver=protection.outlook.com;
 client-ip=199.233.58.38; helo=CAEXCH02.caveonetworks.com;
Received: from CAEXCH02.caveonetworks.com (199.233.58.38) by
 DM3NAM05FT042.mail.protection.outlook.com (10.152.98.156) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id
 15.20.1943.9 via Frontend Transport; Tue, 28 May 2019 03:23:55 +0000
Received: from dut1171.mv.qlogic.com (10.112.88.18) by
 CAEXCH02.caveonetworks.com (10.67.98.110) with Microsoft SMTP Server (TLS) id
 14.2.347.0; Mon, 27 May 2019 20:21:43 -0700
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])    by
 dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x4S3LjZx005784;    Mon, 27
 May 2019 20:21:45 -0700
Received: (from root@localhost) by dut1171.mv.qlogic.com
 (8.14.7/8.14.7/Submit) id x4S3LiiI005783;      Mon, 27 May 2019 20:21:44 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <mkalderon@marvell.com>,
        <aelior@marvell.com>
Subject: [PATCH net-next 0/2] qed*: Fix inifinite spinning of PTP poll thread.
Date:   Mon, 27 May 2019 20:21:31 -0700
Message-ID: <20190528032133.5745-1-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Matching-Connectors: 132034874360841115;(abac79dc-c90b-41ba-8033-08d666125e47);(abac79dc-c90b-41ba-8033-08d666125e47)
X-Forefront-Antispam-Report: CIP:199.233.58.38;IPV:CAL;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(979002)(396003)(376002)(136003)(346002)(39850400004)(2980300002)(1110001)(339900001)(199004)(189003)(1076003)(4744005)(50466002)(70586007)(70206006)(305945005)(2906002)(80596001)(105606002)(2351001)(48376002)(54906003)(86362001)(50226002)(87636003)(81166006)(81156014)(8936002)(26826003)(26005)(47776003)(69596002)(498600001)(8676002)(76130400001)(336012)(476003)(107886003)(36756003)(4326008)(51416003)(6666004)(356004)(6862004)(5660300002)(68736007)(53936002)(316002)(16586007)(42186006)(36906005)(126002)(2616005)(486006)(85426001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR07MB4442;H:CAEXCH02.caveonetworks.com;FPR:;SPF:Fail;LANG:en;PTR:InfoDomainNonexistent;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af842230-e567-433b-d2d0-08d6e31beaac
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(5600148)(711020)(4605104)(1401327)(2017052603328);SRVR:DM6PR07MB4442;
X-MS-TrafficTypeDiagnostic: DM6PR07MB4442:
X-Microsoft-Antispam-PRVS: <DM6PR07MB4442540A2124A21CD1F2F5B8D31E0@DM6PR07MB4442.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 00514A2FE6
X-Microsoft-Antispam-Message-Info: N+4VumsIiidak9WKR24o8ud+0+CMXPfzgCh89ZHfQ8barS8KpSOgvG+h9+1jUK8cD4XbW1j0RccnOOYf7SxUYIvS+ejrVujpYBFokUnaM5UNKYfofwbtuYNwEj9c7nJoGKVv47pVbPhnHS/Hvcey+j3ouQwK1asRs4HNQ53BowAurr5sGQPRcBKzsyQXDmhixBU03e8MqJREpU14D4huArPpAfNXoSu5fA+mnLE4gBlMrjKeZBgQXTQMuaPbTCbaY2daM6apVtQxLCXGDodr/HcR4v+Z1Il3SDYKyRUdlHfRaG0YoOuXkjGjQjmGQc+H26GXzmjY4yVvbHz1BGG2fIWSQ/Kv+W0MMfLMEnfMHCQRe0oTJapexZLuj5/gOyjiGbQD+kAj2tMEuvHh4bieUPihfDG6tXe7BPE/et80ow0=
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2019 03:23:55.6831
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af842230-e567-433b-d2d0-08d6e31beaac
X-MS-Exchange-CrossTenant-Id: 5afe0b00-7697-4969-b663-5eab37d5f47e
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5afe0b00-7697-4969-b663-5eab37d5f47e;Ip=[199.233.58.38];Helo=[CAEXCH02.caveonetworks.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB4442
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch series addresses an error scenario in the PTP Tx implementation.

Please consider applying it to net-next.

Sudarsana Reddy Kalluru (2):
  qed: Reduce the severity of the debug message.
  qede: Handle driver spin for Tx timestamp.

 drivers/net/ethernet/qlogic/qed/qed_ptp.c       |  3 +-
 drivers/net/ethernet/qlogic/qede/qede.h         |  2 ++
 drivers/net/ethernet/qlogic/qede/qede_ethtool.c |  1 +
 drivers/net/ethernet/qlogic/qede/qede_main.c    |  3 ++
 drivers/net/ethernet/qlogic/qede/qede_ptp.c     | 37 ++++++++++++++++++++-----
 5 files changed, 38 insertions(+), 8 deletions(-)

-- 
1.8.3.1

