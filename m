Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E021A2B3FED
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 10:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbgKPJfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 04:35:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbgKPJfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 04:35:23 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786E4C0613CF;
        Mon, 16 Nov 2020 01:35:21 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id 74so24196290lfo.5;
        Mon, 16 Nov 2020 01:35:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RcbO3/lWIjvlWcNYZu05m5zf0LbEgxCjEtnDLqiifRA=;
        b=Qs8RZt0v2t0cp7tKPg9Amk9trihavEMbblGJk916z4gTGEVir4aFJRMEaNeZdEkboJ
         bRVkiuTUxC/swzwXb6i0dP3BBfCU/ZPYVFiSCa+VDG2Ki6WrdY6k1W3OytvVjMDAxJcD
         p1XRLYja3UdbZMfM/VOaIr1MbnlrD9oHHPT8nh8HP7w5YfraTULjggaPUa0paktioWYQ
         1W2zomKKo5+5djtOwQFHQLA8cJOigSzgidwOlZlQlxsTxcJ1Brf/hDmVXdxab46cGztJ
         gKvM4xL+1lg3sIcJ2IYpuWPOEwZLQam7aXld60i+rdWz0Jyr59C7Oy+1umSvhzHA+UDz
         gowQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RcbO3/lWIjvlWcNYZu05m5zf0LbEgxCjEtnDLqiifRA=;
        b=DVVR3epnuG4XFAovhYlODuikxq3XdfZplJyyqGCG0/Jk+YataqeNAFSCuDSlQ0fNGX
         e9vvofPcdKLhdKarSF8eOqC15tq8LcH8pyLngjZQGdyIHW9mhGVbfS1nGztKmtJMJ/SI
         OvCP8a4OAyB/9U3SCf0kV9LegQIlRMiBmBKzFnVlcnc9C0MGTi0wWkbE7M7s3heKvoPq
         jwvcV0igBigKJeLoizAxXxQlBKdVjR+1YSPK/RKIkCF0MksZmjfr/sKvONwCeV5cHWH6
         Onq99BlsxNfAovCmGue7+NgQmQ9cxUUO0f4By56+J6fxGOrnlJ8+4x4524dN2xD7sWgS
         TAXw==
X-Gm-Message-State: AOAM532e7fnHhRAMEW++ppiwiy2Huixyu7FWn0yXESdSGgD1UEQ8uyUk
        rHCma3dVeYu1EQAmb/Rov8g=
X-Google-Smtp-Source: ABdhPJzD7HQSE7/yYyBUAO/dgvDkVrfSHyhaBleS0YPYrSNi6wj+CNL/GFKEU1yOE2YA0vWK0U/UJQ==
X-Received: by 2002:a05:6512:20cd:: with SMTP id u13mr5139352lfr.373.1605519319990;
        Mon, 16 Nov 2020 01:35:19 -0800 (PST)
Received: from localhost.localdomain (87-205-71-93.adsl.inetia.pl. [87.205.71.93])
        by smtp.gmail.com with ESMTPSA id t26sm2667986lfp.296.2020.11.16.01.35.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 01:35:19 -0800 (PST)
From:   alardam@gmail.com
X-Google-Original-From: marekx.majtyka@intel.com
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        andrii.nakryiko@gmail.com, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, davem@davemloft.net,
        john.fastabend@gmail.com, hawk@kernel.org, toke@redhat.com
Cc:     maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>
Subject: [PATCH 5/8] libbpf: extend netlink attribute API
Date:   Mon, 16 Nov 2020 10:34:49 +0100
Message-Id: <20201116093452.7541-6-marekx.majtyka@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201116093452.7541-1-marekx.majtyka@intel.com>
References: <20201116093452.7541-1-marekx.majtyka@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Majtyka <marekx.majtyka@intel.com>

Extend netlink attribute API to put a different attribute into
the netlink message (nest{start, end}, string, u32, flag, etc).
Add new API to parse attribute array.

Signed-off-by: Marek Majtyka <marekx.majtyka@intel.com>
---
 tools/lib/bpf/nlattr.c | 105 +++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/nlattr.h |  22 +++++++++
 2 files changed, 127 insertions(+)

diff --git a/tools/lib/bpf/nlattr.c b/tools/lib/bpf/nlattr.c
index b607fa9852b1..b37b4d266832 100644
--- a/tools/lib/bpf/nlattr.c
+++ b/tools/lib/bpf/nlattr.c
@@ -83,6 +83,52 @@ static inline int nlmsg_len(const struct nlmsghdr *nlh)
 	return nlh->nlmsg_len - NLMSG_HDRLEN;
 }
 
+/**
+ * Create attribute index table based on a stream of attributes.
+ * @arg tb		Index array to be filled (indexed from 0 to elem-1).
+ * @arg elem		Number of attributes in the table.
+ * @arg maxtype		Maximum attribute type expected and accepted.
+ * @arg head		Head of attribute stream.
+ * @arg policy		Attribute validation policy.
+ *
+ * Iterates over the stream of attributes and stores a pointer to each
+ * attribute in the index array using incremented counter as index to
+ * the array. Attribute with a index greater than or equal to the elem value
+ * specified will be ignored and function terminates with error. If a policy
+ * is not NULL, the attribute will be validated using the specified policy.
+ *
+ * @see nla_validate
+ * @return 0 on success or a negative error code.
+ */
+int libbpf_nla_parse_table(struct nlattr *tb[], int elem, struct nlattr *head,
+			   int maxtype, struct libbpf_nla_policy *policy)
+{
+	struct nlattr *nla;
+	int rem, err = 0;
+	int idx = 0;
+
+	memset(tb, 0, sizeof(struct nlattr *) * elem);
+
+	libbpf_nla_for_each_attr(nla, libbpf_nla_data(head), libbpf_nla_len(head), rem) {
+		if (idx >= elem) {
+			err = -EMSGSIZE;
+			goto errout;
+		}
+
+		if (policy) {
+			err = validate_nla(nla, maxtype, policy);
+			if (err < 0)
+				goto errout;
+		}
+
+		tb[idx] = nla;
+		idx++;
+	}
+
+errout:
+	return err;
+}
+
 /**
  * Create attribute index based on a stream of attributes.
  * @arg tb		Index array to be filled (maxtype+1 elements).
@@ -193,3 +239,62 @@ int libbpf_nla_dump_errormsg(struct nlmsghdr *nlh)
 
 	return 0;
 }
+
+struct nlattr *libbpf_nla_next(struct nlattr *current)
+{
+	return current + NLA_ALIGN(current->nla_len) / sizeof(struct nlattr);
+}
+
+struct nlattr *libbpf_nla_nest_start(struct nlattr *start, int attrtype)
+{
+	start->nla_len = NLA_HDRLEN;
+	start->nla_type = attrtype | NLA_F_NESTED;
+	return start + 1;
+}
+
+int libbpf_nla_nest_end(struct nlattr *start, struct nlattr *next)
+{
+	start->nla_len += (unsigned char *)next  - (unsigned char *)start - NLA_HDRLEN;
+	return start->nla_len;
+}
+
+struct nlattr *libbpf_nla_put_u32(struct nlattr *start, int attrtype, uint32_t val)
+{
+	struct nlattr *next = start + 1;
+
+	start->nla_type = attrtype;
+	start->nla_len = NLA_HDRLEN + NLA_ALIGN(sizeof(uint32_t));
+	memcpy((char *)next, &val, sizeof(uint32_t));
+
+	return next + 1;
+}
+
+struct nlattr *libbpf_nla_put_str(struct nlattr *start, int attrtype,
+				  const char *string, int max_len)
+{
+	struct nlattr *next = start + 1;
+	size_t len = max_len > 0 ? strnlen(string, max_len - 1) : 0;
+	char *ptr = ((char *)next) + len;
+
+	start->nla_type = attrtype;
+	start->nla_len = NLA_HDRLEN + NLA_ALIGN(len + 1);
+	strncpy((char *)next, string, len);
+
+	for (size_t idx = len; idx < start->nla_len; ++idx, ptr++)
+		*ptr = '\0';
+
+	return libbpf_nla_next(start);
+}
+
+struct nlattr *libbpf_nla_put_flag(struct nlattr *start, int attrtype)
+{
+	start->nla_type = attrtype;
+	start->nla_len = NLA_HDRLEN;
+
+	return start + 1;
+}
+
+int libbpf_nla_attrs_length(struct nlattr *start, struct nlattr *next)
+{
+	return ((unsigned char *)next  - (unsigned char *)start);
+}
diff --git a/tools/lib/bpf/nlattr.h b/tools/lib/bpf/nlattr.h
index 6cc3ac91690f..93e18accfce5 100644
--- a/tools/lib/bpf/nlattr.h
+++ b/tools/lib/bpf/nlattr.h
@@ -76,6 +76,11 @@ static inline uint8_t libbpf_nla_getattr_u8(const struct nlattr *nla)
 	return *(uint8_t *)libbpf_nla_data(nla);
 }
 
+static inline uint16_t libbpf_nla_getattr_u16(const struct nlattr *nla)
+{
+	return *(uint16_t *)libbpf_nla_data(nla);
+}
+
 static inline uint32_t libbpf_nla_getattr_u32(const struct nlattr *nla)
 {
 	return *(uint32_t *)libbpf_nla_data(nla);
@@ -100,7 +105,24 @@ int libbpf_nla_parse(struct nlattr *tb[], int maxtype, struct nlattr *head,
 int libbpf_nla_parse_nested(struct nlattr *tb[], int maxtype,
 			    struct nlattr *nla,
 			    struct libbpf_nla_policy *policy);
+int libbpf_nla_parse_table(struct nlattr *tb[], int elem, struct nlattr *head,
+			   int type, struct libbpf_nla_policy *policy);
 
 int libbpf_nla_dump_errormsg(struct nlmsghdr *nlh);
 
+struct nlattr *libbpf_nla_next(struct nlattr *current);
+
+struct nlattr *libbpf_nla_nest_start(struct nlattr *start, int attrtype);
+
+int libbpf_nla_nest_end(struct nlattr *start, struct nlattr *next);
+
+struct nlattr *libbpf_nla_put_u32(struct nlattr *start, int attrtype, uint32_t val);
+
+struct nlattr *libbpf_nla_put_str(struct nlattr *start, int attrtype,
+				  const char *string, int max_len);
+
+struct nlattr *libbpf_nla_put_flag(struct nlattr *start, int attrtype);
+
+int libbpf_nla_attrs_length(struct nlattr *start, struct nlattr *next);
+
 #endif /* __LIBBPF_NLATTR_H */
-- 
2.20.1

