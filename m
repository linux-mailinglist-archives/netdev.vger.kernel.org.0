Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21DF602EAB
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 16:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbiJROiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 10:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbiJROiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 10:38:20 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2077.outbound.protection.outlook.com [40.107.244.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00D1CA8A5
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 07:38:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I2ogggZxKxi3PjHvR2QS/+3zxGth6QBD4uaL4HdGPch16bPMtiLU+AqeElUSslQaKz1rFe87Jw9loMxzbEgOW9qpf0uPcJu4eOSzQS4yWGa0Wrj6R1o1NTYwkZ4mSjbz+0VfDxtrW/KuNjbhoCmWEvjLlnDG88gX40DdUOr9oOE1FYC8zk+T4ZgtR8SrNadBMyn3d/eUVf+6AwvjkqrB9JQPL+Q0nOVtnD88jl14uQI8m4UnVFIEARPAtpCe5pweT0msnGMxFJCG+AGlCnZaFhTw3L3tB+UDlZ1U2u7omV2fSeDRTnqoPAUe8D2GWsS78tIf0y73WxxQ5B2xYc5QMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PKg8DRClCVYCVCWsgF81j/3SDgWtqVowIX7sCM63oUc=;
 b=LOe6UBnB1eAsICyYXgJ33qlKrjISYT50pxSvkSUd1urO6rh88Z2g60WzTcVBFaEeSMMetin5gbXRt++VLN7y6NCZ7Db7VpI4socgXawxnQ5TrmtLG7g6Ssf5WGdxDOjc5BtE2FYR1x/M0mk8XeUed8DlCiEdMRmRPkl5bzmB7h0ZFQcs1/yycffaAy8pfNSyOKVLUgRBrd79MJY3brPRymnC1NzOM0ALa2rLRhP9L9LSo7C+H8ws//VWRTf2Uo3qFI11+bE00xfEgDEtwNrumdpDBYcU6/iUtubUvm4CK71sRBiDSwVStQG1FBCACCQ33IXtuDoIRkZk3nl0Iex1bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PKg8DRClCVYCVCWsgF81j/3SDgWtqVowIX7sCM63oUc=;
 b=uif7J4kS9I23tstPNMGk6TvLqV1cJODhcQ1d4FKQtwSzytluCGNpDNEm7IzcINsdp3uZ+i8L39i2IJELcSNQsM8O8vJsOSf0sRYfz7uai9TRU9ZNkJxeSYbkJoGpsqhxQZ2Br5GO5XjmnZayJ8t7M9RNl35F6aJvgVS1n+fL1uw=
Received: from DM6PR01CA0009.prod.exchangelabs.com (2603:10b6:5:296::14) by
 DM6PR12MB4926.namprd12.prod.outlook.com (2603:10b6:5:1bb::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.29; Tue, 18 Oct 2022 14:38:17 +0000
Received: from DM6NAM11FT077.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::b7) by DM6PR01CA0009.outlook.office365.com
 (2603:10b6:5:296::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30 via Frontend
 Transport; Tue, 18 Oct 2022 14:38:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT077.mail.protection.outlook.com (10.13.173.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Tue, 18 Oct 2022 14:38:16 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 18 Oct
 2022 09:38:13 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31 via Frontend
 Transport; Tue, 18 Oct 2022 09:38:05 -0500
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <johannes@sipsolutions.net>, <marcelo.leitner@gmail.com>,
        <jiri@resnulli.us>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v3 net-next 0/3] netlink: formatted extacks
Date:   Tue, 18 Oct 2022 15:37:26 +0100
Message-ID: <cover.1666102698.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT077:EE_|DM6PR12MB4926:EE_
X-MS-Office365-Filtering-Correlation-Id: c95577ec-8eca-47dc-f78e-08dab1166522
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 44ynUQgH3n/0fmVyiwb1DdImq6+RDw0u0EUd30b2+HmGAk347TMFkOziTA2LCUtIrfslqzvcRGizXou4yqr3BvyWaOmJ/SgAyzyqbDoabc25fPQhJRgPW1Up6dVvTdSaJOLMkTrtXE+cnrAavR89vnb3wWmleGvtP3dDzb62Ho8IyiSxfMn6uoqKF5J3keVYDAGZ+ZxBfc7tkAKtuaj86CLaVnPz3c1mUlGvkQeRbcFexhS/e8PAkaL0K4bt69s7QHUdD+li/g8cwk/gJhk6yEk5/5W89NNumlphdsexl1dLIfaVM+JNdidjE5zHzgo6UQBr8rRmhFM9X2WH9QdFjw6K+mMyh6OLgyitMaOyoVlDQ/w9SCCnVZWPwjdoKWassrhWlwKPvLeikwlP7QSJIwkitzJaL0DDlx1njg559PYUJegGlrpXssfvY2uJnSOxY0bcC44ntbFRiJzgBl4DO+YvTQrFdQPbc0NIaKWfVEmMHC63xcEMTBfXa3LzxIh6LjyQzT1forJ68fq6IcoYYyxWNKoZjF9NOeq8LAjljBcxruWN574hq2/Cf/y9q+2zIGRyXU5Vrg6yRUyNEQ7Dqmr3SX13Now+4pcgHsKxpYyFzaD94lVao3HVScguTpSBQcEIWokw3J7MvDubOH1FolOKCXRgXB6+EFjmfPtV/eZJAJBonK7CkU41tQ+HVB53QtufWcHnpNQLmr/vN9rKp3KThpqJXRH3lEkWHvGG+lm5BBf2lHrbklM+gckK17XsUL4TUeURvyzRKGwwzGXG80mRJ0CDgm8LxivyjvnIkQQ=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(346002)(39860400002)(136003)(451199015)(40470700004)(36840700001)(46966006)(83380400001)(2906002)(336012)(2876002)(186003)(426003)(36756003)(54906003)(40460700003)(81166007)(4326008)(8676002)(26005)(82740400003)(47076005)(40480700001)(86362001)(55446002)(356005)(9686003)(82310400005)(36860700001)(316002)(41300700001)(8936002)(6636002)(5660300002)(110136005)(7416002)(70206006)(6666004)(70586007)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 14:38:16.8971
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c95577ec-8eca-47dc-f78e-08dab1166522
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT077.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4926
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Currently, netlink extacks can only carry fixed string messages, which
 is limiting when reporting failures in complex systems.  This series
 adds the ability to return printf-formatted messages, and uses it in
 the sfc driver's TC offload code.
Formatted extack messages are limited in length to a fixed buffer size,
 currently 80 characters.  If the message exceeds this, the full message
 will be logged (ratelimited) to the console and a truncated version
 returned over netlink.
There is no change to the netlink uAPI; only internal kernel changes
 are needed.

Changed in v3:
* altered string splicing in NL_SET_ERR_MSG_FMT to avoid storing the
  format string twice in .rodata
* removed RFC tags

Changed in v2:
* fixed null-checking of extack (with break; as suggested by kuba)
* added logging of full string on truncation (Johannes)

Edward Cree (3):
  netlink: add support for formatted extack messages
  sfc: use formatted extacks instead of efx_tc_err()
  sfc: remove 'log-tc-errors' ethtool private flag

 drivers/net/ethernet/sfc/ef100_ethtool.c  |  2 -
 drivers/net/ethernet/sfc/ethtool_common.c | 37 ------------------
 drivers/net/ethernet/sfc/ethtool_common.h |  2 -
 drivers/net/ethernet/sfc/mae.c            |  5 +--
 drivers/net/ethernet/sfc/net_driver.h     |  2 -
 drivers/net/ethernet/sfc/tc.c             | 47 ++++++++++-------------
 drivers/net/ethernet/sfc/tc.h             | 18 ---------
 include/linux/netlink.h                   | 29 +++++++++++++-
 8 files changed, 50 insertions(+), 92 deletions(-)

