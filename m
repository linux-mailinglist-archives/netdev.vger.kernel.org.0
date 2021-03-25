Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE1F34916B
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 13:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbhCYMCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 08:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbhCYMBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 08:01:47 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5877EC06174A;
        Thu, 25 Mar 2021 05:01:47 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id c17so1820989pfn.6;
        Thu, 25 Mar 2021 05:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8ZdmWVh22wEQGLiJ+FhPGw4D/jYq9k5IInMg19pQeUk=;
        b=m63UBDmGnmHksGN2ohPYwim3kn54/fJkoUswX4VqFUJQwTzXilWGazjIj5llHGnJdm
         M1ye/SbgbAHa+cFQ/gFuWku3fnAUDUNJ2E700qFBJQQts+sttZjZxZOXUdOxsbMV8Jc8
         +2srlT4LkdG1HmBYA7Nk1hr5uDzH93mKx6RJSUdKJHi9PkDCu//jbRvvl3YC1h8e3RqQ
         hLd2Oxb1mZh6PEvy/BI6M5z/aB8DFs+dpsuoc59JVU2yhvzQaDtMq88fdzlOGluiT5w+
         KYGBlsB0RfQNFEe7lqB7Mw+BUd9q7fJqLs73/85gcLznEhfqLWoLLHtba/Gs5Aq0LcgP
         5BgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8ZdmWVh22wEQGLiJ+FhPGw4D/jYq9k5IInMg19pQeUk=;
        b=M/1H+wNyNiL9NV4aG9Tm8IIvry+5nazpnyxck/chvGrQ76HfmcNg+T52A9u89kR1v7
         ldSvLDUY9Z0Gv66H/gbT87iWH/2ufT854ZriiCwzMsXxJkncB3JGl7uzR6wKIy7DfjXw
         9WdU582UMP+wQpuR/zTKVkve+pnUI+RjBJQpF4/Z8kj4TLuKT1oGlVKTYqiclDDQ2yif
         M9JU894L9MzBMxyf91WK/M9kLf+BpcdpF+fj5atcBI+TccMtpnrX8z1cTqbxpMu5rmok
         eYRuG+UIiei80gipuVlpb6dxmCy+GQNhoiw8qhxIGGdSf87NhxrLRhaoGzpyO65j0EsW
         wQPA==
X-Gm-Message-State: AOAM533/t9FJdEQzwP8uB4S37eL/U/G3FkRSGxMmraU7Z8WOVqMHjlYS
        +p+NCGSN7BLurzjZJs9Wn3Lqb+BiAVib/g==
X-Google-Smtp-Source: ABdhPJyTK6btAvry0OkB+CX/KXna5g8e9ZIYZj69l+4NASqn6u3nRTIDHq6AWuyWAexuydexGhue/A==
X-Received: by 2002:a17:902:82c7:b029:e4:74ad:9450 with SMTP id u7-20020a17090282c7b02900e474ad9450mr9663515plz.58.1616673706627;
        Thu, 25 Mar 2021 05:01:46 -0700 (PDT)
Received: from localhost ([112.79.237.176])
        by smtp.gmail.com with ESMTPSA id d6sm5692770pfn.197.2021.03.25.05.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 05:01:46 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     brouer@redhat.com, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next 2/5] libbpf: add helpers for preparing netlink attributes
Date:   Thu, 25 Mar 2021 17:30:00 +0530
Message-Id: <20210325120020.236504-3-memxor@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325120020.236504-1-memxor@gmail.com>
References: <20210325120020.236504-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change introduces a few helpers to wrap open coded attribute
preparation in netlink.c.

Every nested attribute's closure must happen using the helper
end_nlattr_nested, which sets its length properly. NLA_F_NESTED is
enforeced using begin_nlattr_nested helper. Other simple attributes
can be added directly.

The maxsz parameter corresponds to the size of the request structure
which is being filled in, so for instance with req being:

struct {
	struct nlmsghdr nh;
	struct tcmsg t;
	char buf[4096];
} req;

Then, maxsz should be sizeof(req).

This change also converts the open coded attribute preparation with the
helpers. Note that the only failure the internal call to add_nlattr
could result in the nested helper would be -EMSGSIZE, hence that is what
we return to our caller.

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/netlink.c | 37 +++++++++++++++--------------------
 tools/lib/bpf/nlattr.h  | 43 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+), 21 deletions(-)

diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index 4dd73de00b6f..f448c29de76d 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -135,7 +135,7 @@ static int __bpf_set_link_xdp_fd_replace(int ifindex, int fd, int old_fd,
 					 __u32 flags)
 {
 	int sock, seq = 0, ret;
-	struct nlattr *nla, *nla_xdp;
+	struct nlattr *nla;
 	struct {
 		struct nlmsghdr  nh;
 		struct ifinfomsg ifinfo;
@@ -157,36 +157,31 @@ static int __bpf_set_link_xdp_fd_replace(int ifindex, int fd, int old_fd,
 	req.ifinfo.ifi_index = ifindex;
 
 	/* started nested attribute for XDP */
-	nla = (struct nlattr *)(((char *)&req)
-				+ NLMSG_ALIGN(req.nh.nlmsg_len));
-	nla->nla_type = NLA_F_NESTED | IFLA_XDP;
-	nla->nla_len = NLA_HDRLEN;
+	nla = begin_nlattr_nested(&req.nh, sizeof(req), IFLA_XDP);
+	if (!nla) {
+		ret = -EMSGSIZE;
+		goto cleanup;
+	}
 
 	/* add XDP fd */
-	nla_xdp = (struct nlattr *)((char *)nla + nla->nla_len);
-	nla_xdp->nla_type = IFLA_XDP_FD;
-	nla_xdp->nla_len = NLA_HDRLEN + sizeof(int);
-	memcpy((char *)nla_xdp + NLA_HDRLEN, &fd, sizeof(fd));
-	nla->nla_len += nla_xdp->nla_len;
+	ret = add_nlattr(&req.nh, sizeof(req), IFLA_XDP_FD, &fd, sizeof(fd));
+	if (ret < 0)
+		goto cleanup;
 
 	/* if user passed in any flags, add those too */
 	if (flags) {
-		nla_xdp = (struct nlattr *)((char *)nla + nla->nla_len);
-		nla_xdp->nla_type = IFLA_XDP_FLAGS;
-		nla_xdp->nla_len = NLA_HDRLEN + sizeof(flags);
-		memcpy((char *)nla_xdp + NLA_HDRLEN, &flags, sizeof(flags));
-		nla->nla_len += nla_xdp->nla_len;
+		ret = add_nlattr(&req.nh, sizeof(req), IFLA_XDP_FLAGS, &flags, sizeof(flags));
+		if (ret < 0)
+			goto cleanup;
 	}
 
 	if (flags & XDP_FLAGS_REPLACE) {
-		nla_xdp = (struct nlattr *)((char *)nla + nla->nla_len);
-		nla_xdp->nla_type = IFLA_XDP_EXPECTED_FD;
-		nla_xdp->nla_len = NLA_HDRLEN + sizeof(old_fd);
-		memcpy((char *)nla_xdp + NLA_HDRLEN, &old_fd, sizeof(old_fd));
-		nla->nla_len += nla_xdp->nla_len;
+		ret = add_nlattr(&req.nh, sizeof(req), IFLA_XDP_EXPECTED_FD, &flags, sizeof(flags));
+		if (ret < 0)
+			goto cleanup;
 	}
 
-	req.nh.nlmsg_len += NLA_ALIGN(nla->nla_len);
+	end_nlattr_nested(&req.nh, nla);
 
 	if (send(sock, &req, req.nh.nlmsg_len, 0) < 0) {
 		ret = -errno;
diff --git a/tools/lib/bpf/nlattr.h b/tools/lib/bpf/nlattr.h
index 6cc3ac91690f..463a53bf3022 100644
--- a/tools/lib/bpf/nlattr.h
+++ b/tools/lib/bpf/nlattr.h
@@ -10,7 +10,10 @@
 #define __LIBBPF_NLATTR_H
 
 #include <stdint.h>
+#include <string.h>
+#include <errno.h>
 #include <linux/netlink.h>
+
 /* avoid multiple definition of netlink features */
 #define __LINUX_NETLINK_H
 
@@ -103,4 +106,44 @@ int libbpf_nla_parse_nested(struct nlattr *tb[], int maxtype,
 
 int libbpf_nla_dump_errormsg(struct nlmsghdr *nlh);
 
+
+/* Helpers for preparing/consuming attributes */
+
+#define NLA_DATA(nla) ((struct nlattr *)((char *)(nla) + NLA_HDRLEN))
+
+static inline int add_nlattr(struct nlmsghdr *nh, size_t maxsz, int type,
+			     const void *data, int len)
+{
+	struct nlattr *nla;
+
+	if (NLMSG_ALIGN(nh->nlmsg_len) + NLA_ALIGN(NLA_HDRLEN + len) > maxsz)
+		return -EMSGSIZE;
+	if ((!data && len) || (data && !len))
+		return -EINVAL;
+
+	nla = (struct nlattr *)((char *)nh + NLMSG_ALIGN(nh->nlmsg_len));
+	nla->nla_type = type;
+	nla->nla_len = NLA_HDRLEN + len;
+	if (data)
+		memcpy((char *)nla + NLA_HDRLEN, data, len);
+	nh->nlmsg_len = NLMSG_ALIGN(nh->nlmsg_len) + NLA_ALIGN(nla->nla_len);
+	return 0;
+}
+
+static inline struct nlattr *begin_nlattr_nested(struct nlmsghdr *nh, size_t maxsz,
+					       int type)
+{
+	struct nlattr *tail;
+
+	tail = (struct nlattr *)((char *)nh + NLMSG_ALIGN(nh->nlmsg_len));
+	if (add_nlattr(nh, maxsz, type | NLA_F_NESTED, NULL, 0))
+		return NULL;
+	return tail;
+}
+
+static inline void end_nlattr_nested(struct nlmsghdr *nh, struct nlattr *tail)
+{
+	tail->nla_len = ((char *)nh + NLMSG_ALIGN(nh->nlmsg_len)) - (char *)(tail);
+}
+
 #endif /* __LIBBPF_NLATTR_H */
-- 
2.30.2

