Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B9E21243F
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 15:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729172AbgGBNLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 09:11:45 -0400
Received: from mail-eopbgr150084.outbound.protection.outlook.com ([40.107.15.84]:26558
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729147AbgGBNLo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 09:11:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BpDvjrzcAekH2IAal3Phwq1kpIbS04425dv11HyOakpHvBFIUojEv1lu3RQy5wpdND5JMoBrTNrob+vK8kNlMldG4bRYRmILnStRbDNHBDpmPRXMzwQk4mt+tAzcQQ0mHJEkGaZCDAO+1CEMpf1qIaG2rRLERIBNkV3VkSg2yhEEQEgCfCXSmCo79jXtcgUJeEeb1whcZOXL1vgBA2UM/eurrVYvXk+GAnyNjKNGbG6jBm6lsYEMbFKo7O8ghUc8CN66MfPzfbc7r41xPRVY83immdSVdAM2nmyh40vJ/Ca1gKt5EtEb/bQMC7AegO1UTV6fNkPDfZUhUMBMtsxs0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VmIXNZmcK0uIoKT6xpho4BWc7mk6RQhv2Fmg5s9XMF4=;
 b=eE/62ct8bj3CXtEyaJj2D+vXdEHB4gOKDpDKx5x/w/G03aHGaLrcjaM0h/wYpYFQ7SxNZqd63mAfzMpzu21BhIcmKngbYrfko6jde2nasJkeLfCLF39j1pTl6F5nFZoR8l1YeEd/uWA2679TyzS4qrmKAjO3cykhuQU1Ak+VQI3nUWcDboQAI+cQox5t9c+viT81Fcp1wT3uw00uziAgH3qFQyUNfZP4c8o6JdQx4lvEYB0JDEgg/HaUE2vNIjlgZqFV701zDiK7GRTKA8zDTQsApRNQnsMu2ZWsgLFUCDlOC6BVXw4JcNQ8SXydVAcuvGY5Bcz8TrKQF2CrVwlygg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VmIXNZmcK0uIoKT6xpho4BWc7mk6RQhv2Fmg5s9XMF4=;
 b=rQf+YabeZ+GmGBLoW1p2to8T5W0E3ca0JEQyWYsFfXDfBLvkogR1F9y8B7NT/yqyyAZePPgPLPpbkWTayYCPJj61GQDl3y2v03tMOeXUikAyitYjIGO1V4x7/PCa0Wl5tvgkVtaNTuC8AvNksxhz8CJnCelbR+pGGhb89m/11jQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR0502MB3834.eurprd05.prod.outlook.com (2603:10a6:7:83::17)
 by HE1PR0502MB3722.eurprd05.prod.outlook.com (2603:10a6:7:85::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.26; Thu, 2 Jul
 2020 13:11:33 +0000
Received: from HE1PR0502MB3834.eurprd05.prod.outlook.com
 ([fe80::7c6f:47a:35a4:ffa2]) by HE1PR0502MB3834.eurprd05.prod.outlook.com
 ([fe80::7c6f:47a:35a4:ffa2%5]) with mapi id 15.20.3153.021; Thu, 2 Jul 2020
 13:11:33 +0000
From:   Amit Cohen <amitc@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, o.rempel@pengutronix.de, andrew@lunn.ch,
        f.fainelli@gmail.com, jacob.e.keller@intel.com, mlxsw@mellanox.com,
        Amit Cohen <amitc@mellanox.com>
Subject: [PATCH ethtool v2 3/3] netlink: settings: expand linkstate_reply_cb() to support link extended state
Date:   Thu,  2 Jul 2020 16:11:11 +0300
Message-Id: <20200702131111.23105-4-amitc@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200702131111.23105-1-amitc@mellanox.com>
References: <20200702131111.23105-1-amitc@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0117.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::22) To HE1PR0502MB3834.eurprd05.prod.outlook.com
 (2603:10a6:7:83::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-155.mtr.labs.mlnx (37.142.13.130) by AM0PR01CA0117.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20 via Frontend Transport; Thu, 2 Jul 2020 13:11:32 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6981799b-60db-4460-636e-08d81e897123
X-MS-TrafficTypeDiagnostic: HE1PR0502MB3722:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0502MB3722D9A76B4DBD29528FB68DD76D0@HE1PR0502MB3722.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:576;
X-Forefront-PRVS: 0452022BE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P6DY8Dx6LkZQKnXAGqfsZPAy7eh/g6GwUoFlsl93J5MGSTdikqTP2torEka92Q2GcNxJFtwmlDpRalYTmWlOz4DH7YpJ6GQiilDGqswlD9iPpmeCX7oCGnvREq+XQtFUlVK9YKZnAA/PiZ3V3CnaJBnRe+nKMcAXASlawEcgR6CiEHNXL5Xb/jqtHM/kqlodAHY6suvD2S9NaVIExoGJ1YGUwjK9OIP3xA6jBq2j3JA/sCRv24x/dL5ilrxo6lSJcxkXl9I+V1J6eZb8A0DYSsPgP3XfJ2aaI4NC8KZV92G7+jOmIbtlMJHAcYV1WJEpAT4TTyRkCthgkMnduD490g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0502MB3834.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(366004)(376002)(396003)(136003)(2616005)(36756003)(478600001)(1076003)(6486002)(107886003)(6506007)(86362001)(83380400001)(6666004)(52116002)(26005)(956004)(4326008)(8936002)(6512007)(8676002)(186003)(316002)(6916009)(66556008)(5660300002)(66946007)(66476007)(16526019)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: y0LqeApKfxJGwH72sYxjulx7tPPgU8gfCahChEYS+RH1F4KyaIPLQJt/AdWQ4pSJCO51794HDMN14ZkGnUgWeKScbv056pOiAQ9DhubcfrBH/Kfz0TZyJoCo/RIXHYDzoxLv1/ujglbIye4edjWDaWQM4eIZ8hOgxb355PbbPMubXg7rnAKrtc0XnYG4M8oeASxcxwYPLSn/Osnk66VCkBlVlv2qaL+YEV/rN1G+9uBDnJQGnuyUibjo6VZfi0qtEfXmu0K+E5G/U+SG1C2ttSKUtDMBAW4N8XsKwx3z0URJ/jRoYbTfZ7X8zMsT7oDhRSvmDrzEAcYyvOpoOY8TuwTHnbMFmp/nA9rfGomQ8vs9YrTLzOV1dCfK20BIeLLqkjfXQ81VerwhawXbDLgbWYP3skC4flJjnygxKu4SzpqHhbgwvyWC2OBjaVubKxXy8Yv+pVfiSyRKYD5VrsObZyxdKIuSdW5NAlBfeAZvyMbOtICWLin/OHwG0q93dzZJ
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6981799b-60db-4460-636e-08d81e897123
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0502MB3834.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2020 13:11:33.3051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o6zOgOOkGhwii5hG1n7sLjIJzr2GisPXJ49xjUm+olgN8i2hshDSYOuof5ez/mQCYTrFpvdPLGsjtknt+0s3pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0502MB3722
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Print extended state in addition to link state.

In case that extended state is not provided, print state only.
If extended substate is provided in addition to the extended state,
print it also.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
---
 netlink/settings.c | 147 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 146 insertions(+), 1 deletion(-)

diff --git a/netlink/settings.c b/netlink/settings.c
index 35ba2f5..2f5875d 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -604,6 +604,149 @@ int linkinfo_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 	return MNL_CB_OK;
 }
 
+static const char *get_enum_string(const char *const *string_table, unsigned int n_string_table,
+				   unsigned int val)
+{
+	if (val >= n_string_table || !string_table[val])
+		return NULL;
+	else
+		return string_table[val];
+}
+
+static const char *const names_link_ext_state[] = {
+	[ETHTOOL_LINK_EXT_STATE_AUTONEG]		= "Autoneg",
+	[ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE]	= "Link training failure",
+	[ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH]	= "Logical mismatch",
+	[ETHTOOL_LINK_EXT_STATE_BAD_SIGNAL_INTEGRITY]	= "Bad signal integrity",
+	[ETHTOOL_LINK_EXT_STATE_NO_CABLE]		= "No cable",
+	[ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE]		= "Cable issue",
+	[ETHTOOL_LINK_EXT_STATE_EEPROM_ISSUE]		= "EEPROM issue",
+	[ETHTOOL_LINK_EXT_STATE_CALIBRATION_FAILURE]	= "Calibration failure",
+	[ETHTOOL_LINK_EXT_STATE_POWER_BUDGET_EXCEEDED]	= "Power budget exceeded",
+	[ETHTOOL_LINK_EXT_STATE_OVERHEAT]		= "Overheat",
+};
+
+static const char *const names_autoneg_link_ext_substate[] = {
+	[ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED]		=
+		"No partner detected",
+	[ETHTOOL_LINK_EXT_SUBSTATE_AN_ACK_NOT_RECEIVED]			=
+		"Ack not received",
+	[ETHTOOL_LINK_EXT_SUBSTATE_AN_NEXT_PAGE_EXCHANGE_FAILED]	=
+		"Next page exchange failed",
+	[ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED_FORCE_MODE]	=
+		"No partner detected during force mode",
+	[ETHTOOL_LINK_EXT_SUBSTATE_AN_FEC_MISMATCH_DURING_OVERRIDE]	=
+		"FEC mismatch during override",
+	[ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_HCD]				=
+		"No HCD",
+};
+
+static const char *const names_link_training_link_ext_substate[] = {
+	[ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_FRAME_LOCK_NOT_ACQUIRED]			=
+		"KR frame lock not acquired",
+	[ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_LINK_INHIBIT_TIMEOUT]				=
+		"KR link inhibit timeout",
+	[ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_LINK_PARTNER_DID_NOT_SET_RECEIVER_READY]	=
+		"KR Link partner did not set receiver ready",
+	[ETHTOOL_LINK_EXT_SUBSTATE_LT_REMOTE_FAULT]					=
+		"Remote side is not ready yet",
+};
+
+static const char *const names_link_logical_mismatch_link_ext_substate[] = {
+	[ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_ACQUIRE_BLOCK_LOCK]	=
+		"PCS did not acquire block lock",
+	[ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_ACQUIRE_AM_LOCK]	=
+		"PCS did not acquire AM lock",
+	[ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_GET_ALIGN_STATUS]	=
+		"PCS did not get align_status",
+	[ETHTOOL_LINK_EXT_SUBSTATE_LLM_FC_FEC_IS_NOT_LOCKED]		=
+		"FC FEC is not locked",
+	[ETHTOOL_LINK_EXT_SUBSTATE_LLM_RS_FEC_IS_NOT_LOCKED]		=
+		"RS FEC is not locked",
+};
+
+static const char *const names_bad_signal_integrity_link_ext_substate[] = {
+	[ETHTOOL_LINK_EXT_SUBSTATE_BSI_LARGE_NUMBER_OF_PHYSICAL_ERRORS]	=
+		"Large number of physical errors",
+	[ETHTOOL_LINK_EXT_SUBSTATE_BSI_UNSUPPORTED_RATE]		=
+		"Unsupported rate",
+};
+
+static const char *const names_cable_issue_link_ext_substate[] = {
+	[ETHTOOL_LINK_EXT_SUBSTATE_CI_UNSUPPORTED_CABLE]	=
+		"Unsupported cable",
+	[ETHTOOL_LINK_EXT_SUBSTATE_CI_CABLE_TEST_FAILURE]	=
+		"Cable test failure",
+};
+
+static const char *link_ext_substate_get(uint8_t link_ext_state_val, uint8_t link_ext_substate_val)
+{
+	switch (link_ext_state_val) {
+	case ETHTOOL_LINK_EXT_STATE_AUTONEG:
+		return get_enum_string(names_autoneg_link_ext_substate,
+				       ARRAY_SIZE(names_autoneg_link_ext_substate),
+				       link_ext_substate_val);
+	case ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE:
+		return get_enum_string(names_link_training_link_ext_substate,
+				       ARRAY_SIZE(names_link_training_link_ext_substate),
+				       link_ext_substate_val);
+	case ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH:
+		return get_enum_string(names_link_logical_mismatch_link_ext_substate,
+				       ARRAY_SIZE(names_link_logical_mismatch_link_ext_substate),
+				       link_ext_substate_val);
+	case ETHTOOL_LINK_EXT_STATE_BAD_SIGNAL_INTEGRITY:
+		return get_enum_string(names_bad_signal_integrity_link_ext_substate,
+				       ARRAY_SIZE(names_bad_signal_integrity_link_ext_substate),
+				       link_ext_substate_val);
+	case ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE:
+		return get_enum_string(names_cable_issue_link_ext_substate,
+				       ARRAY_SIZE(names_cable_issue_link_ext_substate),
+				       link_ext_substate_val);
+	default:
+		return NULL;
+	}
+}
+
+static void linkstate_link_ext_substate_print(const struct nlattr *tb[], struct nl_context *nlctx,
+					      uint8_t link_ext_state_val)
+{
+	uint8_t link_ext_substate_val;
+	const char *link_ext_substate_str;
+
+	if (!tb[ETHTOOL_A_LINKSTATE_EXT_SUBSTATE])
+		return;
+
+	link_ext_substate_val = mnl_attr_get_u8(tb[ETHTOOL_A_LINKSTATE_EXT_SUBSTATE]);
+
+	link_ext_substate_str = link_ext_substate_get(link_ext_state_val, link_ext_substate_val);
+	if (!link_ext_substate_str)
+		printf(", %u", link_ext_substate_val);
+	else
+		printf(", %s", link_ext_substate_str);
+}
+
+static void linkstate_link_ext_state_print(const struct nlattr *tb[], struct nl_context *nlctx)
+{
+	uint8_t link_ext_state_val;
+	const char *link_ext_state_str;
+
+	if (!tb[ETHTOOL_A_LINKSTATE_EXT_STATE])
+		return;
+
+	link_ext_state_val = mnl_attr_get_u8(tb[ETHTOOL_A_LINKSTATE_EXT_STATE]);
+
+	link_ext_state_str = get_enum_string(names_link_ext_state,
+					     ARRAY_SIZE(names_link_ext_state),
+					     link_ext_state_val);
+	if (!link_ext_state_str)
+		printf(" (%u", link_ext_state_val);
+	else
+		printf(" (%s", link_ext_state_str);
+
+	linkstate_link_ext_substate_print(tb, nlctx, link_ext_state_val);
+	printf(")");
+}
+
 int linkstate_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 {
 	const struct nlattr *tb[ETHTOOL_A_LINKSTATE_MAX + 1] = {};
@@ -624,7 +767,9 @@ int linkstate_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 		uint8_t val = mnl_attr_get_u8(tb[ETHTOOL_A_LINKSTATE_LINK]);
 
 		print_banner(nlctx);
-		printf("\tLink detected: %s\n", val ? "yes" : "no");
+		printf("\tLink detected: %s", val ? "yes" : "no");
+		linkstate_link_ext_state_print(tb, nlctx);
+		printf("\n");
 	}
 
 	if (tb[ETHTOOL_A_LINKSTATE_SQI]) {
-- 
2.20.1

