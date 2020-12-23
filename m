Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 769122E206A
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 19:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbgLWS1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 13:27:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726923AbgLWS1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 13:27:05 -0500
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A2FC061282
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 10:26:24 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4D1M9C28z1zQlTB;
        Wed, 23 Dec 2020 19:26:23 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1608747981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZQz9pyQAue7b9ak0HeIe8I2nr1BVjJQRUGeyEZGoQ+k=;
        b=Y7FhiH4p5Xmupju7UNQWRv1iejNBzjNPFF18ar/pxpWs6IhwTb1+gR7At7f+XSSG59DNGW
        +d9+15KUkTjuNrP/0JH9QnDFE8/txfaExM7kC6nSUGlmOlz3+zbE1y9qBmtfF1J9C04lUX
        U2Xi35ya6OLw5qOz4T90QJzFEA9fiuAwVaXBPk/ziXRjD3R+iIpU3oqvmK7up6vsf7H6Nr
        1XxrevmpqU+6kAuijHP0+GbZvCvpdrePS8G0zPqUgRceCWPPyaSIZD2hOjuN3qdqwNPxpP
        RqpfI/HL/FSftP31BzIBMXPgeyF8v5PYqVtMlCBQoB6DbFPJvYy1LLU5lSzDUw==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id CmGdquqQjPIG; Wed, 23 Dec 2020 19:26:20 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 6/9] dcb: Generalize dcb_get_attribute()
Date:   Wed, 23 Dec 2020 19:25:44 +0100
Message-Id: <156a2bab549d833c7f4471c1b580ede28ce68152.1608746691.git.me@pmachata.org>
In-Reply-To: <cover.1608746691.git.me@pmachata.org>
References: <cover.1608746691.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 0.41 / 15.00 / 15.00
X-Rspamd-Queue-Id: 457C11726
X-Rspamd-UID: 57ae9d
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

Rewrite dcb_get_attribute() in terms of the new dcb_get_attribute_va().

Signed-off-by: Petr Machata <me@pmachata.org>
---
 dcb/dcb.c | 79 ++++++++++++++++++++++++++++++++++++++++++++-----------
 dcb/dcb.h |  4 +++
 2 files changed, 68 insertions(+), 15 deletions(-)

diff --git a/dcb/dcb.c b/dcb/dcb.c
index 547c226280c1..a59b63ac9159 100644
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
2.25.1

