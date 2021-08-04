Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C992A3DFBAF
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 09:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235819AbhHDHD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 03:03:57 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:41864 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235740AbhHDHDr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 03:03:47 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 41DE3205EA;
        Wed,  4 Aug 2021 09:03:34 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9yR2SVZFQLZq; Wed,  4 Aug 2021 09:03:33 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8BEC2205F0;
        Wed,  4 Aug 2021 09:03:32 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 86D7080004A;
        Wed,  4 Aug 2021 09:03:32 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 4 Aug 2021 09:03:32 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 4 Aug 2021
 09:03:31 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 19F123180AA8; Wed,  4 Aug 2021 09:03:31 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 5/6] selftests/net/ipsec: Add test for xfrm_spdattr_type_t
Date:   Wed, 4 Aug 2021 09:03:28 +0200
Message-ID: <20210804070329.1357123-6-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804070329.1357123-1-steffen.klassert@secunet.com>
References: <20210804070329.1357123-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Safonov <dima@arista.com>

Set hthresh, dump it again and verify thresh.lbits && thresh.rbits.
They are passed as attributes of xfrm_spdattr_type_t, different from
other message attributes that use xfrm_attr_type_t.
Also, test attribute that is bigger than XFRMA_SPD_MAX, currently it
should be silently ignored.

Cc: Shuah Khan <shuah@kernel.org>
Cc: linux-kselftest@vger.kernel.org
Signed-off-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 tools/testing/selftests/net/ipsec.c | 165 +++++++++++++++++++++++++++-
 1 file changed, 163 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/ipsec.c b/tools/testing/selftests/net/ipsec.c
index f23438d512c5..3d7dde2c321b 100644
--- a/tools/testing/selftests/net/ipsec.c
+++ b/tools/testing/selftests/net/ipsec.c
@@ -484,13 +484,16 @@ enum desc_type {
 	MONITOR_ACQUIRE,
 	EXPIRE_STATE,
 	EXPIRE_POLICY,
+	SPDINFO_ATTRS,
 };
 const char *desc_name[] = {
 	"create tunnel",
 	"alloc spi",
 	"monitor acquire",
 	"expire state",
-	"expire policy"
+	"expire policy",
+	"spdinfo attributes",
+	""
 };
 struct xfrm_desc {
 	enum desc_type	type;
@@ -1593,6 +1596,155 @@ static int xfrm_expire_policy(int xfrm_sock, uint32_t *seq,
 	return ret;
 }
 
+static int xfrm_spdinfo_set_thresh(int xfrm_sock, uint32_t *seq,
+		unsigned thresh4_l, unsigned thresh4_r,
+		unsigned thresh6_l, unsigned thresh6_r,
+		bool add_bad_attr)
+
+{
+	struct {
+		struct nlmsghdr		nh;
+		union {
+			uint32_t	unused;
+			int		error;
+		};
+		char			attrbuf[MAX_PAYLOAD];
+	} req;
+	struct xfrmu_spdhthresh thresh;
+
+	memset(&req, 0, sizeof(req));
+	req.nh.nlmsg_len	= NLMSG_LENGTH(sizeof(req.unused));
+	req.nh.nlmsg_type	= XFRM_MSG_NEWSPDINFO;
+	req.nh.nlmsg_flags	= NLM_F_REQUEST | NLM_F_ACK;
+	req.nh.nlmsg_seq	= (*seq)++;
+
+	thresh.lbits = thresh4_l;
+	thresh.rbits = thresh4_r;
+	if (rtattr_pack(&req.nh, sizeof(req), XFRMA_SPD_IPV4_HTHRESH, &thresh, sizeof(thresh)))
+		return -1;
+
+	thresh.lbits = thresh6_l;
+	thresh.rbits = thresh6_r;
+	if (rtattr_pack(&req.nh, sizeof(req), XFRMA_SPD_IPV6_HTHRESH, &thresh, sizeof(thresh)))
+		return -1;
+
+	if (add_bad_attr) {
+		BUILD_BUG_ON(XFRMA_IF_ID <= XFRMA_SPD_MAX + 1);
+		if (rtattr_pack(&req.nh, sizeof(req), XFRMA_IF_ID, NULL, 0)) {
+			pr_err("adding attribute failed: no space");
+			return -1;
+		}
+	}
+
+	if (send(xfrm_sock, &req, req.nh.nlmsg_len, 0) < 0) {
+		pr_err("send()");
+		return -1;
+	}
+
+	if (recv(xfrm_sock, &req, sizeof(req), 0) < 0) {
+		pr_err("recv()");
+		return -1;
+	} else if (req.nh.nlmsg_type != NLMSG_ERROR) {
+		printk("expected NLMSG_ERROR, got %d", (int)req.nh.nlmsg_type);
+		return -1;
+	}
+
+	if (req.error) {
+		printk("NLMSG_ERROR: %d: %s", req.error, strerror(-req.error));
+		return -1;
+	}
+
+	return 0;
+}
+
+static int xfrm_spdinfo_attrs(int xfrm_sock, uint32_t *seq)
+{
+	struct {
+		struct nlmsghdr			nh;
+		union {
+			uint32_t	unused;
+			int		error;
+		};
+		char			attrbuf[MAX_PAYLOAD];
+	} req;
+
+	if (xfrm_spdinfo_set_thresh(xfrm_sock, seq, 32, 31, 120, 16, false)) {
+		pr_err("Can't set SPD HTHRESH");
+		return KSFT_FAIL;
+	}
+
+	memset(&req, 0, sizeof(req));
+
+	req.nh.nlmsg_len	= NLMSG_LENGTH(sizeof(req.unused));
+	req.nh.nlmsg_type	= XFRM_MSG_GETSPDINFO;
+	req.nh.nlmsg_flags	= NLM_F_REQUEST;
+	req.nh.nlmsg_seq	= (*seq)++;
+	if (send(xfrm_sock, &req, req.nh.nlmsg_len, 0) < 0) {
+		pr_err("send()");
+		return KSFT_FAIL;
+	}
+
+	if (recv(xfrm_sock, &req, sizeof(req), 0) < 0) {
+		pr_err("recv()");
+		return KSFT_FAIL;
+	} else if (req.nh.nlmsg_type == XFRM_MSG_NEWSPDINFO) {
+		size_t len = NLMSG_PAYLOAD(&req.nh, sizeof(req.unused));
+		struct rtattr *attr = (void *)req.attrbuf;
+		int got_thresh = 0;
+
+		for (; RTA_OK(attr, len); attr = RTA_NEXT(attr, len)) {
+			if (attr->rta_type == XFRMA_SPD_IPV4_HTHRESH) {
+				struct xfrmu_spdhthresh *t = RTA_DATA(attr);
+
+				got_thresh++;
+				if (t->lbits != 32 || t->rbits != 31) {
+					pr_err("thresh differ: %u, %u",
+							t->lbits, t->rbits);
+					return KSFT_FAIL;
+				}
+			}
+			if (attr->rta_type == XFRMA_SPD_IPV6_HTHRESH) {
+				struct xfrmu_spdhthresh *t = RTA_DATA(attr);
+
+				got_thresh++;
+				if (t->lbits != 120 || t->rbits != 16) {
+					pr_err("thresh differ: %u, %u",
+							t->lbits, t->rbits);
+					return KSFT_FAIL;
+				}
+			}
+		}
+		if (got_thresh != 2) {
+			pr_err("only %d thresh returned by XFRM_MSG_GETSPDINFO", got_thresh);
+			return KSFT_FAIL;
+		}
+	} else if (req.nh.nlmsg_type != NLMSG_ERROR) {
+		printk("expected NLMSG_ERROR, got %d", (int)req.nh.nlmsg_type);
+		return KSFT_FAIL;
+	} else {
+		printk("NLMSG_ERROR: %d: %s", req.error, strerror(-req.error));
+		return -1;
+	}
+
+	/* Restore the default */
+	if (xfrm_spdinfo_set_thresh(xfrm_sock, seq, 32, 32, 128, 128, false)) {
+		pr_err("Can't restore SPD HTHRESH");
+		return KSFT_FAIL;
+	}
+
+	/*
+	 * At this moment xfrm uses nlmsg_parse_deprecated(), which
+	 * implies NL_VALIDATE_LIBERAL - ignoring attributes with
+	 * (type > maxtype). nla_parse_depricated_strict() would enforce
+	 * it. Or even stricter nla_parse().
+	 * Right now it's not expected to fail, but to be ignored.
+	 */
+	if (xfrm_spdinfo_set_thresh(xfrm_sock, seq, 32, 32, 128, 128, true))
+		return KSFT_PASS;
+
+	return KSFT_PASS;
+}
+
 static int child_serv(int xfrm_sock, uint32_t *seq,
 		unsigned int nr, int cmd_fd, void *buf, struct xfrm_desc *desc)
 {
@@ -1717,6 +1869,9 @@ static int child_f(unsigned int nr, int test_desc_fd, int cmd_fd, void *buf)
 		case EXPIRE_POLICY:
 			ret = xfrm_expire_policy(xfrm_sock, &seq, nr, &desc);
 			break;
+		case SPDINFO_ATTRS:
+			ret = xfrm_spdinfo_attrs(xfrm_sock, &seq);
+			break;
 		default:
 			printk("Unknown desc type %d", desc.type);
 			exit(KSFT_FAIL);
@@ -1994,8 +2149,10 @@ static int write_proto_plan(int fd, int proto)
  *   sizeof(xfrm_user_polexpire)  = 168  |  sizeof(xfrm_user_polexpire)  = 176
  *
  * Check the affected by the UABI difference structures.
+ * Also, check translation for xfrm_set_spdinfo: it has it's own attributes
+ * which needs to be correctly copied, but not translated.
  */
-const unsigned int compat_plan = 4;
+const unsigned int compat_plan = 5;
 static int write_compat_struct_tests(int test_desc_fd)
 {
 	struct xfrm_desc desc = {};
@@ -2019,6 +2176,10 @@ static int write_compat_struct_tests(int test_desc_fd)
 	if (__write_desc(test_desc_fd, &desc))
 		return -1;
 
+	desc.type = SPDINFO_ATTRS;
+	if (__write_desc(test_desc_fd, &desc))
+		return -1;
+
 	return 0;
 }
 
-- 
2.25.1

