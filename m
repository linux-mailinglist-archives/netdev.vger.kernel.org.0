Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7C92E85F4
	for <lists+netdev@lfdr.de>; Sat,  2 Jan 2021 01:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbhABAFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jan 2021 19:05:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726991AbhABAE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jan 2021 19:04:58 -0500
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840ADC0613ED
        for <netdev@vger.kernel.org>; Fri,  1 Jan 2021 16:04:17 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4D72Dw0bm5zQlLR;
        Sat,  2 Jan 2021 01:04:16 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1609545854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FJUI2dGhHtfKWleLwRophAipJoErJkQPpC8VPpOOkUo=;
        b=kv3WcbLOXJ9ugL/8ELOc+blq0mdpGMR0lsmweXSvDAuWIKjHBXb1iLpzYYrIWaHZuSdvJs
        CiXKmxOlyNZvmLELiJj+R9Dswc8D9Emx7n54meTyZ9kK0rkQ6u5NQzsGbK3DD7lsLKBUxW
        QfoBxK5t3USGdbW/KE0JmqAfKKRXlsXPF9bzQbkF7XET9+6ax49PjZLvLe9def989LosS2
        Wn04bCWeQ7uR027ziOCAgQQL51yeavHAdvYmTrMF0YTwR//DUFcB7tA1seoTs/jNY5qAXi
        5ylcVWd1rqf5k5cfwLYCuvZLShw3aoBnlahMV4ARduDL1AdZBWy5Oae4Y3QI+A==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by hefe.heinlein-support.de (hefe.heinlein-support.de [91.198.250.172]) (amavisd-new, port 10030)
        with ESMTP id yl0vEKvbYo-y; Sat,  2 Jan 2021 01:04:10 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next v2 4/7] dcb: Generalize dcb_get_attribute()
Date:   Sat,  2 Jan 2021 01:03:38 +0100
Message-Id: <a86324114b156310d071a9c18a18315877625f0e.1609544200.git.me@pmachata.org>
In-Reply-To: <cover.1609544200.git.me@pmachata.org>
References: <cover.1609544200.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -0.07 / 15.00 / 15.00
X-Rspamd-Queue-Id: 0CCEE1726
X-Rspamd-UID: 42578d
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function dcb_get_attribute() assumes that the caller knows the exact
size of the looked-for payload. It also assumes that the response comes
wrapped in an DCB_ATTR_IEEE nest. The former assumption does not hold for
the IEEE APP table, which has variable size. The latter one does not hold
for DCBX, which is not IEEE-nested, and also for any CEE attributes, which
would come CEE-nested.

Factor out the payload extractor from the current dcb_get_attribute() code,
and put into a helper. Then rewrite dcb_get_attribute() compatibly in terms
of the new function. Introduce dcb_get_attribute_va() as a thin wrapper for
IEEE-nested access, and dcb_get_attribute_bare() for access to attributes
that are not nested.

Signed-off-by: Petr Machata <me@pmachata.org>
---
 dcb/dcb.c | 79 ++++++++++++++++++++++++++++++++++++++++++++-----------
 dcb/dcb.h |  4 +++
 2 files changed, 68 insertions(+), 15 deletions(-)

diff --git a/dcb/dcb.c b/dcb/dcb.c
index 9bbbbfa74619..89f9b0ec7ef9 100644
--- a/dcb/dcb.c
+++ b/dcb/dcb.c
@@ -59,25 +59,19 @@ static void dcb_free(struct dcb *dcb)
 struct dcb_get_attribute {
 	struct dcb *dcb;
 	int attr;
-	void *data;
-	size_t data_len;
+	void *payload;
+	__u16 payload_len;
 };
 
 static int dcb_get_attribute_attr_ieee_cb(const struct nlattr *attr, void *data)
 {
 	struct dcb_get_attribute *ga = data;
-	uint16_t len;
 
 	if (mnl_attr_get_type(attr) != ga->attr)
 		return MNL_CB_OK;
 
-	len = mnl_attr_get_payload_len(attr);
-	if (len != ga->data_len) {
-		fprintf(stderr, "Wrong len %d, expected %zd\n", len, ga->data_len);
-		return MNL_CB_ERROR;
-	}
-
-	memcpy(ga->data, mnl_attr_get_payload(attr), ga->data_len);
+	ga->payload = mnl_attr_get_payload(attr);
+	ga->payload_len = mnl_attr_get_payload_len(attr);
 	return MNL_CB_STOP;
 }
 
@@ -94,6 +88,16 @@ static int dcb_get_attribute_cb(const struct nlmsghdr *nlh, void *data)
 	return mnl_attr_parse(nlh, sizeof(struct dcbmsg), dcb_get_attribute_attr_cb, data);
 }
 
+static int dcb_get_attribute_bare_cb(const struct nlmsghdr *nlh, void *data)
+{
+	/* Bare attributes (e.g. DCB_ATTR_DCBX) are not wrapped inside an IEEE
+	 * container, so this does not have to go through unpacking in
+	 * dcb_get_attribute_attr_cb().
+	 */
+	return mnl_attr_parse(nlh, sizeof(struct dcbmsg),
+			      dcb_get_attribute_attr_ieee_cb, data);
+}
+
 struct dcb_set_attribute_response {
 	int response_attr;
 };
@@ -155,25 +159,70 @@ static struct nlmsghdr *dcb_prepare(struct dcb *dcb, const char *dev,
 	return nlh;
 }
 
-int dcb_get_attribute(struct dcb *dcb, const char *dev, int attr, void *data, size_t data_len)
+static int __dcb_get_attribute(struct dcb *dcb, int command,
+			       const char *dev, int attr,
+			       void **payload_p, __u16 *payload_len_p,
+			       int (*get_attribute_cb)(const struct nlmsghdr *nlh,
+						       void *data))
 {
 	struct dcb_get_attribute ga;
 	struct nlmsghdr *nlh;
 	int ret;
 
-	nlh = dcb_prepare(dcb, dev, RTM_GETDCB, DCB_CMD_IEEE_GET);
+	nlh = dcb_prepare(dcb, dev, RTM_GETDCB, command);
 
 	ga = (struct dcb_get_attribute) {
 		.dcb = dcb,
 		.attr = attr,
-		.data = data,
-		.data_len = data_len,
+		.payload = NULL,
 	};
-	ret = dcb_talk(dcb, nlh, dcb_get_attribute_cb, &ga);
+	ret = dcb_talk(dcb, nlh, get_attribute_cb, &ga);
 	if (ret) {
 		perror("Attribute read");
 		return ret;
 	}
+	if (ga.payload == NULL) {
+		perror("Attribute not found");
+		return -ENOENT;
+	}
+
+	*payload_p = ga.payload;
+	*payload_len_p = ga.payload_len;
+	return 0;
+}
+
+int dcb_get_attribute_va(struct dcb *dcb, const char *dev, int attr,
+			 void **payload_p, __u16 *payload_len_p)
+{
+	return __dcb_get_attribute(dcb, DCB_CMD_IEEE_GET, dev, attr,
+				   payload_p, payload_len_p,
+				   dcb_get_attribute_cb);
+}
+
+int dcb_get_attribute_bare(struct dcb *dcb, int cmd, const char *dev, int attr,
+			   void **payload_p, __u16 *payload_len_p)
+{
+	return __dcb_get_attribute(dcb, cmd, dev, attr,
+				   payload_p, payload_len_p,
+				   dcb_get_attribute_bare_cb);
+}
+
+int dcb_get_attribute(struct dcb *dcb, const char *dev, int attr, void *data, size_t data_len)
+{
+	__u16 payload_len;
+	void *payload;
+	int ret;
+
+	ret = dcb_get_attribute_va(dcb, dev, attr, &payload, &payload_len);
+	if (ret)
+		return ret;
+
+	if (payload_len != data_len) {
+		fprintf(stderr, "Wrong len %d, expected %zd\n", payload_len, data_len);
+		return -EINVAL;
+	}
+
+	memcpy(data, payload, data_len);
 	return 0;
 }
 
diff --git a/dcb/dcb.h b/dcb/dcb.h
index da14937c8925..8c7327a43588 100644
--- a/dcb/dcb.h
+++ b/dcb/dcb.h
@@ -33,9 +33,13 @@ int dcb_get_attribute(struct dcb *dcb, const char *dev, int attr,
 		      void *data, size_t data_len);
 int dcb_set_attribute(struct dcb *dcb, const char *dev, int attr,
 		      const void *data, size_t data_len);
+int dcb_get_attribute_va(struct dcb *dcb, const char *dev, int attr,
+			 void **payload_p, __u16 *payload_len_p);
 int dcb_set_attribute_va(struct dcb *dcb, int command, const char *dev,
 			 int (*cb)(struct dcb *dcb, struct nlmsghdr *nlh, void *data),
 			 void *data);
+int dcb_get_attribute_bare(struct dcb *dcb, int cmd, const char *dev, int attr,
+			   void **payload_p, __u16 *payload_len_p);
 int dcb_set_attribute_bare(struct dcb *dcb, int command, const char *dev,
 			   int attr, const void *data, size_t data_len,
 			   int response_attr);
-- 
2.26.2

