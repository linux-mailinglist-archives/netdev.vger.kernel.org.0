Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC6F20F185
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 11:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731936AbgF3JYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 05:24:49 -0400
Received: from mail-eopbgr80078.outbound.protection.outlook.com ([40.107.8.78]:21154
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727059AbgF3JYs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 05:24:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=maJH7vj+SJ8IsmAto71Kbib8Xk4N9/wZFV2g84CtPOlI11lMoEQwwoz56Gr1Pp2uxa0smsTz+aXLXvBC+3S4/vyvpTFGJaxhtXUfWRj2mwZ3vWmE/1dfQXhEk16XAbSZhzmesiw98DdygOJuuTdUeK7ktKjtHnsk26jyPpqfHepV/I6+iX6Q5R8zBaw8WSA0ke4EDafzN1ocHCBPiAvIrKgrJJXBIyAzcRgyLp1g5TAeIAZzlgVkX4jEx8ejdUe3utkJHpgYC9E7eeHiU9ptmOXFclE7tcWF1i0+clIbXgsP3k9knVPX34EbRj3huCmgwJACg85w+mNjH7AwFncHyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xQZkl1cM2JTNdxRxXpcNlGaL//AR5O5qmePpU8H+w98=;
 b=TXwt53IQ01oMHk4cqq8c53Nx/QA27ijE7T5yH1UpTWfGsECIp7mLgptFkszIw44llZwpgC6lJ1RzJ134lX7xRqsemt8IEi5Vj1vrjP9xUv5DlbwtdSPKeE1926Q0AzU02glxHNurMg8LPnWBCjlJguKewevVcWSeIxNeGyeqHdwwAzmYee6litt4YVYEKrItarpsCYZo8B+95cHZ85vAFNHw4HLkCUbwasv1F8C6OfwYbAk0IhsefSx0vZNxKkxGTuIJsSQ/p/eU4//1Ni6PLlyDGyjG1u4v9f+r3/3XRalfRxxJ6IRLC6NIHwL1OUZqyOzERKIafSQtWayAi2jQSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xQZkl1cM2JTNdxRxXpcNlGaL//AR5O5qmePpU8H+w98=;
 b=OGhFi4GzLmsKqcPBeAidoPqqXkHNshUbrgYC6lXgRHby/ybX+XmTYQb3l7G4jUJ+TTjzdnBOHDtbGgctt17G1JNO4z14413/4GNNTG1atn3ex6+iSqg3XQK/U7i54gdj2niw5gbxAJmFT/7i0rhqA27wdNdecvUjGNVeKQznhRQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25) by AM0PR05MB4450.eurprd05.prod.outlook.com
 (2603:10a6:208:61::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23; Tue, 30 Jun
 2020 09:24:40 +0000
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2534:ddc7:1744:fea9]) by AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2534:ddc7:1744:fea9%7]) with mapi id 15.20.3131.027; Tue, 30 Jun 2020
 09:24:40 +0000
From:   Amit Cohen <amitc@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, davem@davemloft.net, o.rempel@pengutronix.de,
        andrew@lunn.ch, f.fainelli@gmail.com, jacob.e.keller@intel.com,
        mlxsw@mellanox.com, Amit Cohen <amitc@mellanox.com>
Subject: [PATCH ethtool 2/3] common: add infrastructure to convert kernel values to userspace strings
Date:   Tue, 30 Jun 2020 12:24:11 +0300
Message-Id: <20200630092412.11432-3-amitc@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200630092412.11432-1-amitc@mellanox.com>
References: <20200630092412.11432-1-amitc@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0044.eurprd03.prod.outlook.com (2603:10a6:208::21)
 To AM0PR0502MB3826.eurprd05.prod.outlook.com (2603:10a6:208:1b::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-155.mtr.labs.mlnx (37.142.13.130) by AM0PR03CA0044.eurprd03.prod.outlook.com (2603:10a6:208::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Tue, 30 Jun 2020 09:24:39 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8258003f-db77-4c42-5149-08d81cd76a49
X-MS-TrafficTypeDiagnostic: AM0PR05MB4450:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB4450C053474A129248CA19FBD76F0@AM0PR05MB4450.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-Forefront-PRVS: 0450A714CB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a0mvBhusUzTDYZKFOfaZJfpjZ6zPVo3bvKiTKcCm/uuG1YgBHcw+iXl8dreXlfpB5FrKrAoSFM71S426yOGn/+Zy/LlsPmLJ1JfRjVDnOq+9d0rSefkkCmBXgAJjcTejUCa7YdRj/tLcJcL/E543k4JAewCkEgEnha363plhHVnmTmgB2g0UfHk98sbpH09NbKFw4u4Nil2y8egalROUm/wtqVpaPxlaZHZ1Y8LNzqNqjz9gYAJIPyov7MRdw8xqmbUIiXQbEnpumUBADIUfKJlZdQObWcVOe2NM1otywh1eNnsw1590gymE9EF6bCq8PeX89M/NsApXdOBJm2knCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0502MB3826.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(52116002)(478600001)(2616005)(956004)(4326008)(2906002)(5660300002)(8936002)(316002)(6512007)(6916009)(66476007)(66556008)(8676002)(66946007)(6666004)(107886003)(86362001)(26005)(6506007)(186003)(83380400001)(36756003)(6486002)(1076003)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Hks1sdLo2th/2tGbHDo3BTesxPGATv++XFeFE33hhjEpkr54ZzmyU4oYXpIPApXLNkrwxN5/sg4oeTZExJVjT43a8P8lQBfr1cbnB+YHY5a2eYIBnH7Trcp3ETZMc5qJIP5kwemykDhk65ScEO0ixe4UEzRtjPYfVcqpnnNXNY2OczSwWp2qihrl4C8xThs/ZwheDl/hNgLtebSMLXvXbLuaAWh2B/Z5vzjCcJuZ9hFjFQxgwLPIORPkNcF0cy/vHP5RiIpFMF8Ljk6CtEcTdfA8dhFvWUZbjAAdjMGC1ZRkxknCqJsMvtcABE9ooNHb8bWiCQExF1OjPgbOKbB3hBsaLq679XYBfPvq6hvKdSwSJzFGFn5+/qXyV+Wli+h4cHjt2/VIhQfgkSZJAHCf/8+D2nTqYpZjzH/grFWgQvpqvcEO0AaRM3n4DmFx8iiHwrjlIm2FC/EH5r0gY557rT0caT/X/p1Uvej1I7UKSzU=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8258003f-db77-4c42-5149-08d81cd76a49
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0502MB3826.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2020 09:24:40.2149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9wLjnpV40lHzcOttGvi9j5KPhDZD2Ysk8EKk6ays6t9HoxPoR9z7nNFXsXNRIFhSzB3xZD+vM+iuuHXenl7Tqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4450
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add enums and functions to covert extended state values sent from kernel to
appropriate strings to expose in userspace.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
---
 common.c | 171 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 common.h |   2 +
 2 files changed, 173 insertions(+)

diff --git a/common.c b/common.c
index 2630e73..ac848f7 100644
--- a/common.c
+++ b/common.c
@@ -127,6 +127,177 @@ static char *unparse_wolopts(int wolopts)
 	return buf;
 }
 
+enum link_ext_state {
+	ETHTOOL_LINK_EXT_STATE_AUTONEG,
+	ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE,
+	ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH,
+	ETHTOOL_LINK_EXT_STATE_BAD_SIGNAL_INTEGRITY,
+	ETHTOOL_LINK_EXT_STATE_NO_CABLE,
+	ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE,
+	ETHTOOL_LINK_EXT_STATE_EEPROM_ISSUE,
+	ETHTOOL_LINK_EXT_STATE_CALIBRATION_FAILURE,
+	ETHTOOL_LINK_EXT_STATE_POWER_BUDGET_EXCEEDED,
+	ETHTOOL_LINK_EXT_STATE_OVERHEAT,
+};
+
+enum link_ext_substate_autoneg {
+	ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED = 1,
+	ETHTOOL_LINK_EXT_SUBSTATE_AN_ACK_NOT_RECEIVED,
+	ETHTOOL_LINK_EXT_SUBSTATE_AN_NEXT_PAGE_EXCHANGE_FAILED,
+	ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED_FORCE_MODE,
+	ETHTOOL_LINK_EXT_SUBSTATE_AN_FEC_MISMATCH_DURING_OVERRIDE,
+	ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_HCD,
+};
+
+enum link_ext_substate_link_training {
+	ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_FRAME_LOCK_NOT_ACQUIRED = 1,
+	ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_LINK_INHIBIT_TIMEOUT,
+	ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_LINK_PARTNER_DID_NOT_SET_RECEIVER_READY,
+	ETHTOOL_LINK_EXT_SUBSTATE_LT_REMOTE_FAULT,
+};
+
+enum link_ext_substate_link_logical_mismatch {
+	ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_ACQUIRE_BLOCK_LOCK = 1,
+	ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_ACQUIRE_AM_LOCK,
+	ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_GET_ALIGN_STATUS,
+	ETHTOOL_LINK_EXT_SUBSTATE_LLM_FC_FEC_IS_NOT_LOCKED,
+	ETHTOOL_LINK_EXT_SUBSTATE_LLM_RS_FEC_IS_NOT_LOCKED,
+};
+
+enum link_ext_substate_bad_signal_integrity {
+	ETHTOOL_LINK_EXT_SUBSTATE_BSI_LARGE_NUMBER_OF_PHYSICAL_ERRORS = 1,
+	ETHTOOL_LINK_EXT_SUBSTATE_BSI_UNSUPPORTED_RATE,
+};
+
+enum ethtool_link_ext_substate_cable_issue {
+	ETHTOOL_LINK_EXT_SUBSTATE_CI_UNSUPPORTED_CABLE = 1,
+	ETHTOOL_LINK_EXT_SUBSTATE_CI_CABLE_TEST_FAILURE,
+};
+
+const char *link_ext_state_get(uint8_t link_ext_state_val)
+{
+	switch (link_ext_state_val) {
+	case ETHTOOL_LINK_EXT_STATE_AUTONEG:
+		return "Autoneg";
+	case ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE:
+		return "Link training failure";
+	case ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH:
+		return "Logical mismatch";
+	case ETHTOOL_LINK_EXT_STATE_BAD_SIGNAL_INTEGRITY:
+		return "Bad signal integrity";
+	case ETHTOOL_LINK_EXT_STATE_NO_CABLE:
+		return "No cable";
+	case ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE:
+		return "Cable issue";
+	case ETHTOOL_LINK_EXT_STATE_EEPROM_ISSUE:
+		return "EEPROM issue";
+	case ETHTOOL_LINK_EXT_STATE_CALIBRATION_FAILURE:
+		return "Calibration failure";
+	case ETHTOOL_LINK_EXT_STATE_POWER_BUDGET_EXCEEDED:
+		return "Power budget exceeded";
+	case ETHTOOL_LINK_EXT_STATE_OVERHEAT:
+		return "Overheat";
+	default:
+		return NULL;
+	}
+}
+
+static const char *autoneg_link_ext_substate_get(uint8_t link_ext_substate_val)
+{
+	switch (link_ext_substate_val) {
+	case ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED:
+		return "No partner detected";
+	case ETHTOOL_LINK_EXT_SUBSTATE_AN_ACK_NOT_RECEIVED:
+		return "Ack not received";
+	case ETHTOOL_LINK_EXT_SUBSTATE_AN_NEXT_PAGE_EXCHANGE_FAILED:
+		return "Next page exchange failed";
+	case ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED_FORCE_MODE:
+		return "No partner detected during force mode";
+	case ETHTOOL_LINK_EXT_SUBSTATE_AN_FEC_MISMATCH_DURING_OVERRIDE:
+		return "FEC mismatch during override";
+	case ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_HCD:
+		return "No HCD";
+	default:
+		return NULL;
+	}
+}
+
+static const char *link_training_link_ext_substate_get(uint8_t link_ext_substate_val)
+{
+	switch (link_ext_substate_val) {
+	case ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_FRAME_LOCK_NOT_ACQUIRED:
+		return "KR frame lock not acquired";
+	case ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_LINK_INHIBIT_TIMEOUT:
+		return "KR link inhibit timeout";
+	case ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_LINK_PARTNER_DID_NOT_SET_RECEIVER_READY:
+		return "KR Link partner did not set receiver ready";
+	case ETHTOOL_LINK_EXT_SUBSTATE_LT_REMOTE_FAULT:
+		return "Remote side is not ready yet";
+	default:
+		return NULL;
+	}
+}
+
+static const char *link_logical_mismatch_link_ext_substate_get(uint8_t link_ext_substate_val)
+{
+	switch (link_ext_substate_val) {
+	case ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_ACQUIRE_BLOCK_LOCK:
+		return "PCS did not acquire block lock";
+	case ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_ACQUIRE_AM_LOCK:
+		return "PCS did not acquire AM lock";
+	case ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_GET_ALIGN_STATUS:
+		return "PCS did not get align_status";
+	case ETHTOOL_LINK_EXT_SUBSTATE_LLM_FC_FEC_IS_NOT_LOCKED:
+		return "FC FEC is not locked";
+	case ETHTOOL_LINK_EXT_SUBSTATE_LLM_RS_FEC_IS_NOT_LOCKED:
+		return "RS FEC is not locked";
+	default:
+		return NULL;
+	}
+}
+
+static const char *bad_signal_integrity_link_ext_substate_get(uint8_t link_ext_substate_val)
+{
+	switch (link_ext_substate_val) {
+	case ETHTOOL_LINK_EXT_SUBSTATE_BSI_LARGE_NUMBER_OF_PHYSICAL_ERRORS:
+		return "Large number of physical errors";
+	case ETHTOOL_LINK_EXT_SUBSTATE_BSI_UNSUPPORTED_RATE:
+		return "Unsupported rate";
+	default:
+		return NULL;
+	}
+}
+
+static const char *cable_issue_link_ext_substate_get(uint8_t link_ext_substate_val)
+{
+	switch (link_ext_substate_val) {
+	case ETHTOOL_LINK_EXT_SUBSTATE_CI_UNSUPPORTED_CABLE:
+		return "Unsupported cable";
+	case ETHTOOL_LINK_EXT_SUBSTATE_CI_CABLE_TEST_FAILURE:
+		return "Cable test failure";
+	default:
+		return NULL;
+	}
+}
+
+const char *link_ext_substate_get(uint8_t link_ext_state_val, uint8_t link_ext_substate_val)
+{
+	switch (link_ext_state_val) {
+	case ETHTOOL_LINK_EXT_STATE_AUTONEG:
+		return autoneg_link_ext_substate_get(link_ext_substate_val);
+	case ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE:
+		return link_training_link_ext_substate_get(link_ext_substate_val);
+	case ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH:
+		return link_logical_mismatch_link_ext_substate_get(link_ext_substate_val);
+	case ETHTOOL_LINK_EXT_STATE_BAD_SIGNAL_INTEGRITY:
+		return bad_signal_integrity_link_ext_substate_get(link_ext_substate_val);
+	case ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE:
+		return cable_issue_link_ext_substate_get(link_ext_substate_val);
+	default:
+		return NULL;
+	}
+}
+
 int dump_wol(struct ethtool_wolinfo *wol)
 {
 	fprintf(stdout, "	Supports Wake-on: %s\n",
diff --git a/common.h b/common.h
index b74fdfa..26bec2f 100644
--- a/common.h
+++ b/common.h
@@ -39,6 +39,8 @@ struct off_flag_def {
 extern const struct off_flag_def off_flag_def[OFF_FLAG_DEF_SIZE];
 
 void print_flags(const struct flag_info *info, unsigned int n_info, u32 value);
+const char *link_ext_state_get(uint8_t link_ext_state_val);
+const char *link_ext_substate_get(uint8_t link_ext_state_val, uint8_t link_ext_substate_val);
 int dump_wol(struct ethtool_wolinfo *wol);
 void dump_mdix(u8 mdix, u8 mdix_ctrl);
 
-- 
2.20.1

