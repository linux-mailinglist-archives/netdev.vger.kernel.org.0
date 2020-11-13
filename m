Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F8A2B19B5
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 12:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgKMLMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 06:12:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbgKMLMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 06:12:24 -0500
Received: from confino.investici.org (confino.investici.org [IPv6:2a00:c38:11e:ffff::a020])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06077C061A47;
        Fri, 13 Nov 2020 03:11:59 -0800 (PST)
Received: from mx1.investici.org (unknown [127.0.0.1])
        by confino.investici.org (Postfix) with ESMTP id 4CXbQP5WJyz12Wr;
        Fri, 13 Nov 2020 11:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=privacyrequired.com;
        s=stigmate; t=1605265917;
        bh=az8vXACnXCrrlm+mlYfWgmmAHGbI8U0rxGYjAqmlxs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N4oRNM/gTPU0pJVaWO2a8sO3sI7Xh3SQaitwwqRDGfypNcQ6xkjuUj5nerNQxiaBQ
         1bpACjPJi9eDrznTQPGV6VH5YdPNLcb+5GpjQJ1R1j7ye3cBohByz3sux/ieTAvk4d
         6GVNOWrXBfX39NMbMGj9YJNPrgB81fVma2wtxFvo=
Received: from [212.103.72.250] (mx1.investici.org [212.103.72.250]) (Authenticated sender: laniel_francis@privacyrequired.com) by localhost (Postfix) with ESMTPSA id 4CXbQP3fBqz12W4;
        Fri, 13 Nov 2020 11:11:57 +0000 (UTC)
From:   laniel_francis@privacyrequired.com
To:     linux-hardening@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, keescook@chromium.org,
        Francis Laniel <laniel_francis@privacyrequired.com>
Subject: [PATCH v5 2/3] Modify return value of nla_strlcpy to match that of strscpy.
Date:   Fri, 13 Nov 2020 12:11:32 +0100
Message-Id: <20201113111133.15011-3-laniel_francis@privacyrequired.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201113111133.15011-1-laniel_francis@privacyrequired.com>
References: <20201113111133.15011-1-laniel_francis@privacyrequired.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Francis Laniel <laniel_francis@privacyrequired.com>

nla_strlcpy now returns -E2BIG if src was truncated when written to dst.
It also returns this error value if dstsize is 0 or higher than INT_MAX.

For example, if src is "foo\0" and dst is 3 bytes long, the result will be:
1. "foG" after memcpy (G means garbage).
2. "fo\0" after memset.
3. -E2BIG is returned because src was not completely written into dst.

The callers of nla_strlcpy were modified to take into account this modification.

Signed-off-by: Francis Laniel <laniel_francis@privacyrequired.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 include/net/netlink.h |  2 +-
 include/net/pkt_cls.h |  2 +-
 lib/nlattr.c          | 39 +++++++++++++++++++++++++--------------
 net/sched/act_api.c   |  2 +-
 net/sched/cls_api.c   |  2 +-
 net/sched/sch_api.c   |  2 +-
 6 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 7356f41d23ba..446ca182e13d 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -506,7 +506,7 @@ int __nla_parse(struct nlattr **tb, int maxtype, const struct nlattr *head,
 		struct netlink_ext_ack *extack);
 int nla_policy_len(const struct nla_policy *, int);
 struct nlattr *nla_find(const struct nlattr *head, int len, int attrtype);
-size_t nla_strlcpy(char *dst, const struct nlattr *nla, size_t dstsize);
+ssize_t nla_strlcpy(char *dst, const struct nlattr *nla, size_t dstsize);
 char *nla_strdup(const struct nlattr *nla, gfp_t flags);
 int nla_memcpy(void *dest, const struct nlattr *src, int count);
 int nla_memcmp(const struct nlattr *nla, const void *data, size_t size);
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index d4d461236351..db9a828f4f4f 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -512,7 +512,7 @@ tcf_change_indev(struct net *net, struct nlattr *indev_tlv,
 	char indev[IFNAMSIZ];
 	struct net_device *dev;
 
-	if (nla_strlcpy(indev, indev_tlv, IFNAMSIZ) >= IFNAMSIZ) {
+	if (nla_strlcpy(indev, indev_tlv, IFNAMSIZ) < 0) {
 		NL_SET_ERR_MSG_ATTR(extack, indev_tlv,
 				    "Interface name too long");
 		return -EINVAL;
diff --git a/lib/nlattr.c b/lib/nlattr.c
index 07156e581997..447182543c03 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -710,33 +710,44 @@ EXPORT_SYMBOL(nla_find);
 
 /**
  * nla_strlcpy - Copy string attribute payload into a sized buffer
- * @dst: where to copy the string to
- * @nla: attribute to copy the string from
- * @dstsize: size of destination buffer
+ * @dst: Where to copy the string to.
+ * @nla: Attribute to copy the string from.
+ * @dstsize: Size of destination buffer.
  *
  * Copies at most dstsize - 1 bytes into the destination buffer.
- * The result is always a valid NUL-terminated string. Unlike
- * strlcpy the destination buffer is always padded out.
+ * Unlike strlcpy the destination buffer is always padded out.
  *
- * Returns the length of the source buffer.
+ * Return:
+ * * srclen - Returns @nla length (not including the trailing %NUL).
+ * * -E2BIG - If @dstsize is 0 or greater than U16_MAX or @nla length greater
+ *            than @dstsize.
  */
-size_t nla_strlcpy(char *dst, const struct nlattr *nla, size_t dstsize)
+ssize_t nla_strlcpy(char *dst, const struct nlattr *nla, size_t dstsize)
 {
 	size_t srclen = nla_len(nla);
 	char *src = nla_data(nla);
+	ssize_t ret;
+	size_t len;
+
+	if (dstsize == 0 || WARN_ON_ONCE(dstsize > U16_MAX))
+		return -E2BIG;
 
 	if (srclen > 0 && src[srclen - 1] == '\0')
 		srclen--;
 
-	if (dstsize > 0) {
-		size_t len = (srclen >= dstsize) ? dstsize - 1 : srclen;
-
-		memcpy(dst, src, len);
-		/* Zero pad end of dst. */
-		memset(dst + len, 0, dstsize - len);
+	if (srclen >= dstsize) {
+		len = dstsize - 1;
+		ret = -E2BIG;
+	} else {
+		len = srclen;
+		ret = len;
 	}
 
-	return srclen;
+	memcpy(dst, src, len);
+	/* Zero pad end of dst. */
+	memset(dst + len, 0, dstsize - len);
+
+	return ret;
 }
 EXPORT_SYMBOL(nla_strlcpy);
 
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index f66417d5d2c3..541574520c52 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -935,7 +935,7 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 			NL_SET_ERR_MSG(extack, "TC action kind must be specified");
 			goto err_out;
 		}
-		if (nla_strlcpy(act_name, kind, IFNAMSIZ) >= IFNAMSIZ) {
+		if (nla_strlcpy(act_name, kind, IFNAMSIZ) < 0) {
 			NL_SET_ERR_MSG(extack, "TC action name too long");
 			goto err_out;
 		}
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 838b3fd94d77..d3787a67b3da 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -223,7 +223,7 @@ static inline u32 tcf_auto_prio(struct tcf_proto *tp)
 static bool tcf_proto_check_kind(struct nlattr *kind, char *name)
 {
 	if (kind)
-		return nla_strlcpy(name, kind, IFNAMSIZ) >= IFNAMSIZ;
+		return nla_strlcpy(name, kind, IFNAMSIZ) < 0;
 	memset(name, 0, IFNAMSIZ);
 	return false;
 }
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 2a76a2f5ed88..05449286d889 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1170,7 +1170,7 @@ static struct Qdisc *qdisc_create(struct net_device *dev,
 #ifdef CONFIG_MODULES
 	if (ops == NULL && kind != NULL) {
 		char name[IFNAMSIZ];
-		if (nla_strlcpy(name, kind, IFNAMSIZ) < IFNAMSIZ) {
+		if (nla_strlcpy(name, kind, IFNAMSIZ) >= 0) {
 			/* We dropped the RTNL semaphore in order to
 			 * perform the module load.  So, even if we
 			 * succeeded in loading the module we have to
-- 
2.20.1

