Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C49B10ACDE
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 10:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfK0JtG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 27 Nov 2019 04:49:06 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50928 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727028AbfK0JtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 04:49:04 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-yIZDgltBOCi24p8VomOABg-1; Wed, 27 Nov 2019 04:48:59 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51972102CE16;
        Wed, 27 Nov 2019 09:48:54 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0988C5D6C8;
        Wed, 27 Nov 2019 09:48:50 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH 2/3] libbpf: Export netlink functions used by bpftool
Date:   Wed, 27 Nov 2019 10:48:36 +0100
Message-Id: <20191127094837.4045-3-jolsa@kernel.org>
In-Reply-To: <20191127094837.4045-1-jolsa@kernel.org>
References: <20191127094837.4045-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: yIZDgltBOCi24p8VomOABg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

There are a couple of netlink-related symbols in libbpf that is used by
bpftool, but not exported in the .so version of libbpf. This makes it
impossible to link bpftool dynamically against libbpf. Fix this by adding
the missing function exports.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/libbpf.h   | 22 +++++++++++++---------
 tools/lib/bpf/libbpf.map |  7 +++++++
 tools/lib/bpf/nlattr.h   | 15 ++++++++++-----
 3 files changed, 30 insertions(+), 14 deletions(-)

diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 0dbf4bfba0c4..ba32eb0b2b99 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -514,15 +514,19 @@ bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
 
 struct nlattr;
 typedef int (*libbpf_dump_nlmsg_t)(void *cookie, void *msg, struct nlattr **tb);
-int libbpf_netlink_open(unsigned int *nl_pid);
-int libbpf_nl_get_link(int sock, unsigned int nl_pid,
-		       libbpf_dump_nlmsg_t dump_link_nlmsg, void *cookie);
-int libbpf_nl_get_class(int sock, unsigned int nl_pid, int ifindex,
-			libbpf_dump_nlmsg_t dump_class_nlmsg, void *cookie);
-int libbpf_nl_get_qdisc(int sock, unsigned int nl_pid, int ifindex,
-			libbpf_dump_nlmsg_t dump_qdisc_nlmsg, void *cookie);
-int libbpf_nl_get_filter(int sock, unsigned int nl_pid, int ifindex, int handle,
-			 libbpf_dump_nlmsg_t dump_filter_nlmsg, void *cookie);
+LIBBPF_API int libbpf_netlink_open(unsigned int *nl_pid);
+LIBBPF_API int libbpf_nl_get_link(int sock, unsigned int nl_pid,
+				  libbpf_dump_nlmsg_t dump_link_nlmsg,
+				  void *cookie);
+LIBBPF_API int libbpf_nl_get_class(int sock, unsigned int nl_pid, int ifindex,
+				   libbpf_dump_nlmsg_t dump_class_nlmsg,
+				   void *cookie);
+LIBBPF_API int libbpf_nl_get_qdisc(int sock, unsigned int nl_pid, int ifindex,
+				   libbpf_dump_nlmsg_t dump_qdisc_nlmsg,
+				   void *cookie);
+LIBBPF_API int libbpf_nl_get_filter(int sock, unsigned int nl_pid, int ifindex,
+				    int handle, libbpf_dump_nlmsg_t dump_filter_nlmsg,
+				    void *cookie);
 
 struct bpf_prog_linfo;
 struct bpf_prog_info;
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 8ddc2c40e482..fbd08911ec9e 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -207,4 +207,11 @@ LIBBPF_0.0.6 {
 		bpf_program__size;
 		btf__find_by_name_kind;
 		libbpf_find_vmlinux_btf_id;
+		libbpf_netlink_open;
+		libbpf_nl_get_class;
+		libbpf_nl_get_filter;
+		libbpf_nl_get_link;
+		libbpf_nl_get_qdisc;
+		libbpf_nla_parse;
+		libbpf_nla_parse_nested;
 } LIBBPF_0.0.5;
diff --git a/tools/lib/bpf/nlattr.h b/tools/lib/bpf/nlattr.h
index 6cc3ac91690f..91119ff5701a 100644
--- a/tools/lib/bpf/nlattr.h
+++ b/tools/lib/bpf/nlattr.h
@@ -14,6 +14,10 @@
 /* avoid multiple definition of netlink features */
 #define __LINUX_NETLINK_H
 
+#ifndef LIBBPF_API
+#define LIBBPF_API __attribute__((visibility("default")))
+#endif
+
 /**
  * Standard attribute types to specify validation policy
  */
@@ -95,11 +99,12 @@ static inline int libbpf_nla_len(const struct nlattr *nla)
 	return nla->nla_len - NLA_HDRLEN;
 }
 
-int libbpf_nla_parse(struct nlattr *tb[], int maxtype, struct nlattr *head,
-		     int len, struct libbpf_nla_policy *policy);
-int libbpf_nla_parse_nested(struct nlattr *tb[], int maxtype,
-			    struct nlattr *nla,
-			    struct libbpf_nla_policy *policy);
+LIBBPF_API int libbpf_nla_parse(struct nlattr *tb[], int maxtype,
+				struct nlattr *head, int len,
+				struct libbpf_nla_policy *policy);
+LIBBPF_API int libbpf_nla_parse_nested(struct nlattr *tb[], int maxtype,
+				       struct nlattr *nla,
+				       struct libbpf_nla_policy *policy);
 
 int libbpf_nla_dump_errormsg(struct nlmsghdr *nlh);
 
-- 
2.21.0

