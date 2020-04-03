Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B765D19E143
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 01:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728639AbgDCXGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 19:06:01 -0400
Received: from mail-eopbgr20069.outbound.protection.outlook.com ([40.107.2.69]:53598
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728432AbgDCXGA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Apr 2020 19:06:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BQVa5RQ0NvsxNClUT6yneLcr54o/1BO1HqRX+5xcRdGxbs9rfiza1En0XgjW/b0uEkxgPGh4HuuzRgNdyCNT0nGcONZz57bVHxb9RPl2koKZhqWHnlJpqkP05YUetv7qAkopvdMChXCkWTUf72cw8y4vLNIjbsfuRFDEAeoRgq1c9gFfiWuDd9kFe5WvK9mB7dLH2MWk/kTRcZ/SwDNCxRVPx/AU6ujQL4QVKNojZ1r1mJophuWtEq7iDV9z2go1lLA177R7wKSso19g7+RP/aT8fShTjxQFmmGW/WTekZMrTkVjvtmtD0xuXe1bcn9kgg7ffo7cpBHu4jgHLoXQag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W7Hq+MlMeGeXjR0KiPz5QyHWurxyWZF+u6pUygI7tP4=;
 b=lfPghZQcycxlDOhC+eI8wtlhbLgFhmtq/XfyLNwganSxPyoLDNgAQYI3eNqUN8bpyhYz4lbFpIG7mMMcmyjYPYMUeK/DJoO2Hi4MC2Ufkwp3Kpd9mntWnLzSjExuxYY9qZRJPeeyPRx0QXvpHr6UX14qE35mwjaOFMDJoVAY9ZrRs2TpQZoiVqf/m30yVy+hYPHCbw2hX0vUIp2sdg56Fn3ExioJO/Inv/+vISqOAfirzzAkwR7cKzETsjmwmRPEaGyzFPceJjO+RuH0Me7NScgR5rTeidkrqMVpHPs+SJd8t4x/SJnU65cRR3bfGE8e328b+CXvB+mdo8YpDGxtJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W7Hq+MlMeGeXjR0KiPz5QyHWurxyWZF+u6pUygI7tP4=;
 b=LlRzLlkioeE4oTkYO6c1TsCKLyClCHh1g2EHPKWXH5rd3Juh0AZ3us+JQjXntXzJJAzLtF13OnW6aI3W6ToWXJZezfUiyNwF+AdpegktcICCQbbj1BtkVpYSVS/jBEtrv4kzEQfX6df7tfZ0PtjztQydl8aqoAtDBdjhffAVBlE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB4652.eurprd05.prod.outlook.com (2603:10a6:7:99::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2878.17; Fri, 3 Apr 2020 23:05:55 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b%6]) with mapi id 15.20.2856.019; Fri, 3 Apr 2020
 23:05:55 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2-next v2 1/3] tc: p_ip6: Support pedit of IPv6 dsfield
Date:   Sat,  4 Apr 2020 02:05:29 +0300
Message-Id: <3ed04b5d061b87d2310ac394284dbd88c2014b5a.1585954968.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1585954968.git.petrm@mellanox.com>
References: <cover.1585954968.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P193CA0039.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:102:51::14) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR3P193CA0039.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:51::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16 via Frontend Transport; Fri, 3 Apr 2020 23:05:54 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e7bdc3e0-8a2f-4395-cb92-08d7d823904f
X-MS-TrafficTypeDiagnostic: HE1PR05MB4652:|HE1PR05MB4652:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB4652FFF0B76FE11C0B0F340EDBC70@HE1PR05MB4652.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0362BF9FDB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(376002)(366004)(39860400002)(136003)(346002)(54906003)(6916009)(2616005)(956004)(36756003)(86362001)(81166006)(52116002)(2906002)(5660300002)(8676002)(8936002)(478600001)(81156014)(16526019)(186003)(66556008)(6506007)(6486002)(316002)(26005)(66476007)(66946007)(6666004)(4326008)(6512007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +QBWuEVPXf40o6XAx31GJFHp5RWSVRpSZoUUlalipvucX3uB0947Jrwmv67LtQVmwo90PLEDMk+lkBVw7g7W1Wzse5hX+CsV1KJUVb8ChhUSxU43wsXqCnqUkAl3GmgMwRxFkwK6XedF4+77HWdxnN5miDBdMzb/wcTLycxb8w0hfvI7YW/vQ3mqIr4AvTC0CqfsdI2vZOLkFYZOAM+OdgohQvapaWlpBEPtztcSgh3JpvdgIQ0SLCVpHN3mw+SsiLE78I524DsP2vmkNN880J8HQfHUuECkLGCU+p8LKz3TqfW7w54js7mtMzGDO6kQX2psZykI8uyIBPrbzHuitPAZA3YTbOGcVNmHA/aVq+ke2jFGhxyntUQZBBYy64+RfG64HvronPbMiB+0DEY+42ezPsw+KoYIbf1U7FxySmht0hwLx2wChPoXC2CzUdYR
X-MS-Exchange-AntiSpam-MessageData: JdjfST90RLyAZ6dI5sOHWKwZqa0DrgGSaKVJzbhP3JUUl1hVfqnOHPxrwVaGrzIPd1fs+l5zzxk/f+6DnIqeGw4amxPy0ip9VCDFcZCmDWQrRgf89VvYkPU7J9NIczFrUimbiCat2jT3r5POauur4w==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7bdc3e0-8a2f-4395-cb92-08d7d823904f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2020 23:05:55.7665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lvJ1WzGQEhqQvnorCq74d0tg6xaHtTJ4ancRa4A98JUIG8K4WyQW37/Okj/NAE2vNk7MfrS3ncC1r1Ea2QEMcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB4652
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support keywords dsfield, traffic_class and tos in the IPv6 context.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---

Notes:
    v2:
    - Only accept 'traffic_class'.
    - Move the if-branch that matches it to the end of the list.
    - man: Drop the untrue statement that the traffic_class field needs
      to be sandwiched between two 4-bit zeroes.

 man/man8/tc-pedit.8 |  6 ++++--
 tc/p_ip6.c          | 15 +++++++++++++++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/man/man8/tc-pedit.8 b/man/man8/tc-pedit.8
index bbd725c4..3f6baa3d 100644
--- a/man/man8/tc-pedit.8
+++ b/man/man8/tc-pedit.8
@@ -60,8 +60,8 @@ pedit - generic packet editor action
 
 .ti -8
 .IR IP6HDR_FIELD " := { "
-.BR src " | " dst " | " flow_lbl " | " payload_len " | " nexthdr " |"
-.BR hoplimit " }"
+.BR src " | " dst " | " traffic_class " | " flow_lbl " | " payload_len " | "
+.BR nexthdr " | " hoplimit " }"
 
 .ti -8
 .IR TCPHDR_FIELD " := { "
@@ -229,6 +229,8 @@ are:
 .TQ
 .B dst
 .TQ
+.B traffic_class
+.TQ
 .B flow_lbl
 .TQ
 .B payload_len
diff --git a/tc/p_ip6.c b/tc/p_ip6.c
index 7cc7997b..71660c61 100644
--- a/tc/p_ip6.c
+++ b/tc/p_ip6.c
@@ -74,6 +74,21 @@ parse_ip6(int *argc_p, char ***argv_p,
 		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey);
 		goto done;
 	}
+	if (strcmp(*argv, "traffic_class") == 0) {
+		NEXT_ARG();
+		tkey->off = 1;
+		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey);
+
+		/* Shift the field by 4 bits on success. */
+		if (!res) {
+			int nkeys = sel->sel.nkeys;
+			struct tc_pedit_key *key = &sel->sel.keys[nkeys - 1];
+
+			key->mask = htonl(ntohl(key->mask) << 4 | 0xf);
+			key->val = htonl(ntohl(key->val) << 4);
+		}
+		goto done;
+	}
 
 	return -1;
 
-- 
2.20.1

