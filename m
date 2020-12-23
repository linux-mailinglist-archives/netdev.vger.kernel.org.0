Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844FA2E2068
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 19:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbgLWS1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 13:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbgLWS1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 13:27:04 -0500
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050::465:103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ABCDC06179C
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 10:26:24 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4D1M9B3m7VzQlLY;
        Wed, 23 Dec 2020 19:26:22 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1608747980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cdnsxb3DII6O8OYFuLAeukAMqzahrHZBViHkPydbjrE=;
        b=V6a5X3dkdG84bYgPKR5H0ho1Mx8gBqLraaNTcZM/vzOiHx09lzoJOyaJDkEGSFiK1Mn8gk
        K9nkc2eS999MDuMkg3kCAJ8Bk5LSe7x2G8E/EctZNc2C65b/X1DpocenI9zZo819h37fwo
        tU1jwuWtWX52d/YEBBlLRG5sNQ8qz0cP5C0QSLu9p92q05HzGNXuY+CLZMctDqM2QKXDxa
        lpxwKalW4I2l0NYTpu2q4G4Ays3mGUKyhytQVmYNJ25XgZ+24xa0OEbnZT18F9jvjjAoPG
        GH0vEoj2/JIbd8hI0dQHxJGau8pMOg8wtw5Pdyl21PnlXYFpjIyF0Nme8kNhQg==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id 8zaNYva-nkBV; Wed, 23 Dec 2020 19:26:19 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 5/9] dcb: Generalize dcb_set_attribute()
Date:   Wed, 23 Dec 2020 19:25:43 +0100
Message-Id: <1b719db83621ee5d256bce4487f6cc29233f58c1.1608746691.git.me@pmachata.org>
In-Reply-To: <cover.1608746691.git.me@pmachata.org>
References: <cover.1608746691.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 0.00 / 15.00 / 15.00
X-Rspamd-Queue-Id: 83876171D
X-Rspamd-UID: 14c072
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function dcb_set_attribute() takes a fully-formed payload as an
argument. For callers that need to build a nested attribute, such as is the
case for DCB APP table, this is not great, because with libmnl, they would
need to construct a separate netlink message just to pluck out the payload
and hand it over to this function.

Currently, dcb_set_attribute() also always wraps the payload in an
DCB_ATTR_IEEE container, because that is what all the dcb subtools so far
needed. But that is not appropriate for DCBX in particular, and in fact a
handful other attributes, as well as any CEE payloads.

Instead, generalize this code by adding parameters for constructing a
custom payload and for fetching the response from a custom response
attribute. Then add dcb_set_attribute_va(), which takes a callback to
invoke in the right place for the nest to be built, and
dcb_set_attribute_bare(), which is similar to dcb_set_attribute(), but does
not encapsulate the payload in an IEEE container. Rewrite
dcb_set_attribute() compatibly in terms of the new functions.

Signed-off-by: Petr Machata <me@pmachata.org>
---
 dcb/dcb.c | 99 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
 dcb/dcb.h |  7 ++++
 2 files changed, 98 insertions(+), 8 deletions(-)

diff --git a/dcb/dcb.c b/dcb/dcb.c
index 0e3c87484f2a..547c226280c1 100644
--- a/dcb/dcb.c
+++ b/dcb/dcb.c
@@ -94,12 +94,17 @@ static int dcb_get_attribute_cb(const struct nlmsghdr *nlh, void *data)
 	return mnl_attr_parse(nlh, sizeof(struct dcbmsg), dcb_get_attribute_attr_cb, data);
 }
 
+struct dcb_set_attribute_response {
+	int response_attr;
+};
+
 static int dcb_set_attribute_attr_cb(const struct nlattr *attr, void *data)
 {
+	struct dcb_set_attribute_response *resp = data;
 	uint16_t len;
 	uint8_t err;
 
-	if (mnl_attr_get_type(attr) != DCB_ATTR_IEEE)
+	if (mnl_attr_get_type(attr) != resp->response_attr)
 		return MNL_CB_OK;
 
 	len = mnl_attr_get_payload_len(attr);
@@ -172,19 +177,23 @@ int dcb_get_attribute(struct dcb *dcb, const char *dev, int attr, void *data, si
 	return 0;
 }
 
-int dcb_set_attribute(struct dcb *dcb, const char *dev, int attr, const void *data, size_t data_len)
+static int __dcb_set_attribute(struct dcb *dcb, int command, const char *dev,
+			       int (*cb)(struct dcb *, struct nlmsghdr *, void *),
+			       void *data, int response_attr)
 {
+	struct dcb_set_attribute_response resp = {
+		.response_attr = response_attr,
+	};
 	struct nlmsghdr *nlh;
-	struct nlattr *nest;
 	int ret;
 
-	nlh = dcb_prepare(dcb, dev, RTM_SETDCB, DCB_CMD_IEEE_SET);
+	nlh = dcb_prepare(dcb, dev, RTM_SETDCB, command);
 
-	nest = mnl_attr_nest_start(nlh, DCB_ATTR_IEEE);
-	mnl_attr_put(nlh, attr, data_len, data);
-	mnl_attr_nest_end(nlh, nest);
+	ret = cb(dcb, nlh, data);
+	if (ret)
+		return ret;
 
-	ret = dcb_talk(dcb, nlh, dcb_set_attribute_cb, NULL);
+	ret = dcb_talk(dcb, nlh, dcb_set_attribute_cb, &resp);
 	if (ret) {
 		perror("Attribute write");
 		return ret;
@@ -192,6 +201,80 @@ int dcb_set_attribute(struct dcb *dcb, const char *dev, int attr, const void *da
 	return 0;
 }
 
+struct dcb_set_attribute_ieee_cb {
+	int (*cb)(struct dcb *dcb, struct nlmsghdr *nlh, void *data);
+	void *data;
+};
+
+static int dcb_set_attribute_ieee_cb(struct dcb *dcb, struct nlmsghdr *nlh, void *data)
+{
+	struct dcb_set_attribute_ieee_cb *ieee_data = data;
+	struct nlattr *nest;
+	int ret;
+
+	nest = mnl_attr_nest_start(nlh, DCB_ATTR_IEEE);
+	ret = ieee_data->cb(dcb, nlh, ieee_data->data);
+	if (ret)
+		return ret;
+	mnl_attr_nest_end(nlh, nest);
+
+	return 0;
+}
+
+int dcb_set_attribute_va(struct dcb *dcb, int command, const char *dev,
+			 int (*cb)(struct dcb *dcb, struct nlmsghdr *nlh, void *data),
+			 void *data)
+{
+	struct dcb_set_attribute_ieee_cb ieee_data = {
+		.cb = cb,
+		.data = data,
+	};
+
+	return __dcb_set_attribute(dcb, command, dev,
+				   &dcb_set_attribute_ieee_cb, &ieee_data,
+				   DCB_ATTR_IEEE);
+}
+
+struct dcb_set_attribute {
+	int attr;
+	const void *data;
+	size_t data_len;
+};
+
+static int dcb_set_attribute_put(struct dcb *dcb, struct nlmsghdr *nlh, void *data)
+{
+	struct dcb_set_attribute *dsa = data;
+
+	mnl_attr_put(nlh, dsa->attr, dsa->data_len, dsa->data);
+	return 0;
+}
+
+int dcb_set_attribute(struct dcb *dcb, const char *dev, int attr, const void *data, size_t data_len)
+{
+	struct dcb_set_attribute dsa = {
+		.attr = attr,
+		.data = data,
+		.data_len = data_len,
+	};
+
+	return dcb_set_attribute_va(dcb, DCB_CMD_IEEE_SET, dev,
+				    &dcb_set_attribute_put, &dsa);
+}
+
+int dcb_set_attribute_bare(struct dcb *dcb, int command, const char *dev,
+			   int attr, const void *data, size_t data_len,
+			   int response_attr)
+{
+	struct dcb_set_attribute dsa = {
+		.attr = attr,
+		.data = data,
+		.data_len = data_len,
+	};
+
+	return __dcb_set_attribute(dcb, command, dev,
+				   &dcb_set_attribute_put, &dsa, response_attr);
+}
+
 void dcb_print_array_u8(const __u8 *array, size_t size)
 {
 	SPRINT_BUF(b);
diff --git a/dcb/dcb.h b/dcb/dcb.h
index 388a4204b95c..da14937c8925 100644
--- a/dcb/dcb.h
+++ b/dcb/dcb.h
@@ -2,6 +2,7 @@
 #ifndef __DCB_H__
 #define __DCB_H__ 1
 
+#include <libmnl/libmnl.h>
 #include <stdbool.h>
 #include <stddef.h>
 
@@ -32,6 +33,12 @@ int dcb_get_attribute(struct dcb *dcb, const char *dev, int attr,
 		      void *data, size_t data_len);
 int dcb_set_attribute(struct dcb *dcb, const char *dev, int attr,
 		      const void *data, size_t data_len);
+int dcb_set_attribute_va(struct dcb *dcb, int command, const char *dev,
+			 int (*cb)(struct dcb *dcb, struct nlmsghdr *nlh, void *data),
+			 void *data);
+int dcb_set_attribute_bare(struct dcb *dcb, int command, const char *dev,
+			   int attr, const void *data, size_t data_len,
+			   int response_attr);
 
 void dcb_print_named_array(const char *json_name, const char *fp_name,
 			   const __u8 *array, size_t size,
-- 
2.25.1

