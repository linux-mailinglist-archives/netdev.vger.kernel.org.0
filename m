Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFB5249075
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 23:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbgHRV72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 17:59:28 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52794 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726482AbgHRV7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 17:59:24 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07ILueAS029177
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 14:59:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=L22QB57rbbI6IRTtTZoCGLnh+xhOJYWp6OKFcKntTLQ=;
 b=N2aJ7TS8XwdRzHQ+0EfBVE2WxbJ5PZ9cmSDgvUohE09o/CewpEpbq7yHUxJeVl5pVKHK
 Gao8JRcpkkGjvWO6Nu6vZ5akbr1dgiOdZC2XF/8khBZEpOK+3bcno5NGyrbH7JqxlW5Q
 lXMDtC0cE3B0/7Q4ewKj11Ox4rDdYNWHQe8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304p3d887-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 14:59:22 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 14:59:19 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 1C5932EC5EB3; Tue, 18 Aug 2020 14:59:16 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/4] tools/bpftool: remove libbpf_internal.h usage in bpftool
Date:   Tue, 18 Aug 2020 14:59:06 -0700
Message-ID: <20200818215908.2746786-3-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200818215908.2746786-1-andriin@fb.com>
References: <20200818215908.2746786-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_16:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 spamscore=0 mlxscore=0 clxscore=1015 suspectscore=8 adultscore=0
 bulkscore=0 impostorscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180157
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most netlink-related functions were unique to bpftool usage, so I moved t=
hem
into net.c. Few functions are still used by both bpftool and libbpf itsel=
f
internally, so I've copy-pasted them (libbpf_nl_get_link,
libbpf_netlink_open). It's a bit of duplication of code, but better separ=
ation
of libbpf as a library with public API and bpftool, relying on unexposed
functions in libbpf.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/gen.c         |   2 -
 tools/bpf/bpftool/net.c         | 299 ++++++++++++++++++++++++++++++--
 tools/lib/bpf/libbpf_internal.h |  12 --
 tools/lib/bpf/netlink.c         | 125 +------------
 4 files changed, 288 insertions(+), 150 deletions(-)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index f61184653633..4033c46d83e7 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -19,11 +19,9 @@
 #include <sys/mman.h>
 #include <bpf/btf.h>
=20
-#include "bpf/libbpf_internal.h"
 #include "json_writer.h"
 #include "main.h"
=20
-
 #define MAX_OBJ_NAME_LEN 64
=20
 static void sanitize_identifier(char *name)
diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
index 56c3a2bae3ef..910e7bac6e9e 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -6,22 +6,27 @@
 #include <fcntl.h>
 #include <stdlib.h>
 #include <string.h>
+#include <time.h>
 #include <unistd.h>
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
 #include <net/if.h>
 #include <linux/if.h>
 #include <linux/rtnetlink.h>
+#include <linux/socket.h>
 #include <linux/tc_act/tc_bpf.h>
 #include <sys/socket.h>
 #include <sys/stat.h>
 #include <sys/types.h>
=20
 #include "bpf/nlattr.h"
-#include "bpf/libbpf_internal.h"
 #include "main.h"
 #include "netlink_dumper.h"
=20
+#ifndef SOL_NETLINK
+#define SOL_NETLINK 270
+#endif
+
 struct ip_devname_ifindex {
 	char	devname[64];
 	int	ifindex;
@@ -85,6 +90,266 @@ static enum net_attach_type parse_attach_type(const c=
har *str)
 	return net_attach_type_size;
 }
=20
+typedef int (*dump_nlmsg_t)(void *cookie, void *msg, struct nlattr **tb)=
;
+
+typedef int (*__dump_nlmsg_t)(struct nlmsghdr *nlmsg, dump_nlmsg_t, void=
 *cookie);
+
+static int netlink_open(__u32 *nl_pid)
+{
+	struct sockaddr_nl sa;
+	socklen_t addrlen;
+	int one =3D 1, ret;
+	int sock;
+
+	memset(&sa, 0, sizeof(sa));
+	sa.nl_family =3D AF_NETLINK;
+
+	sock =3D socket(AF_NETLINK, SOCK_RAW, NETLINK_ROUTE);
+	if (sock < 0)
+		return -errno;
+
+	if (setsockopt(sock, SOL_NETLINK, NETLINK_EXT_ACK,
+		       &one, sizeof(one)) < 0) {
+		p_err("Netlink error reporting not supported");
+	}
+
+	if (bind(sock, (struct sockaddr *)&sa, sizeof(sa)) < 0) {
+		ret =3D -errno;
+		goto cleanup;
+	}
+
+	addrlen =3D sizeof(sa);
+	if (getsockname(sock, (struct sockaddr *)&sa, &addrlen) < 0) {
+		ret =3D -errno;
+		goto cleanup;
+	}
+
+	if (addrlen !=3D sizeof(sa)) {
+		ret =3D -LIBBPF_ERRNO__INTERNAL;
+		goto cleanup;
+	}
+
+	*nl_pid =3D sa.nl_pid;
+	return sock;
+
+cleanup:
+	close(sock);
+	return ret;
+}
+
+static int netlink_recv(int sock, __u32 nl_pid, __u32 seq,
+			    __dump_nlmsg_t _fn, dump_nlmsg_t fn,
+			    void *cookie)
+{
+	bool multipart =3D true;
+	struct nlmsgerr *err;
+	struct nlmsghdr *nh;
+	char buf[4096];
+	int len, ret;
+
+	while (multipart) {
+		multipart =3D false;
+		len =3D recv(sock, buf, sizeof(buf), 0);
+		if (len < 0) {
+			ret =3D -errno;
+			goto done;
+		}
+
+		if (len =3D=3D 0)
+			break;
+
+		for (nh =3D (struct nlmsghdr *)buf; NLMSG_OK(nh, len);
+		     nh =3D NLMSG_NEXT(nh, len)) {
+			if (nh->nlmsg_pid !=3D nl_pid) {
+				ret =3D -LIBBPF_ERRNO__WRNGPID;
+				goto done;
+			}
+			if (nh->nlmsg_seq !=3D seq) {
+				ret =3D -LIBBPF_ERRNO__INVSEQ;
+				goto done;
+			}
+			if (nh->nlmsg_flags & NLM_F_MULTI)
+				multipart =3D true;
+			switch (nh->nlmsg_type) {
+			case NLMSG_ERROR:
+				err =3D (struct nlmsgerr *)NLMSG_DATA(nh);
+				if (!err->error)
+					continue;
+				ret =3D err->error;
+				libbpf_nla_dump_errormsg(nh);
+				goto done;
+			case NLMSG_DONE:
+				return 0;
+			default:
+				break;
+			}
+			if (_fn) {
+				ret =3D _fn(nh, fn, cookie);
+				if (ret)
+					return ret;
+			}
+		}
+	}
+	ret =3D 0;
+done:
+	return ret;
+}
+
+static int __dump_class_nlmsg(struct nlmsghdr *nlh,
+			      dump_nlmsg_t dump_class_nlmsg,
+			      void *cookie)
+{
+	struct nlattr *tb[TCA_MAX + 1], *attr;
+	struct tcmsg *t =3D NLMSG_DATA(nlh);
+	int len;
+
+	len =3D nlh->nlmsg_len - NLMSG_LENGTH(sizeof(*t));
+	attr =3D (struct nlattr *) ((void *) t + NLMSG_ALIGN(sizeof(*t)));
+	if (libbpf_nla_parse(tb, TCA_MAX, attr, len, NULL) !=3D 0)
+		return -LIBBPF_ERRNO__NLPARSE;
+
+	return dump_class_nlmsg(cookie, t, tb);
+}
+
+static int netlink_get_class(int sock, unsigned int nl_pid, int ifindex,
+			     dump_nlmsg_t dump_class_nlmsg, void *cookie)
+{
+	struct {
+		struct nlmsghdr nlh;
+		struct tcmsg t;
+	} req =3D {
+		.nlh.nlmsg_len =3D NLMSG_LENGTH(sizeof(struct tcmsg)),
+		.nlh.nlmsg_type =3D RTM_GETTCLASS,
+		.nlh.nlmsg_flags =3D NLM_F_DUMP | NLM_F_REQUEST,
+		.t.tcm_family =3D AF_UNSPEC,
+		.t.tcm_ifindex =3D ifindex,
+	};
+	int seq =3D time(NULL);
+
+	req.nlh.nlmsg_seq =3D seq;
+	if (send(sock, &req, req.nlh.nlmsg_len, 0) < 0)
+		return -errno;
+
+	return netlink_recv(sock, nl_pid, seq, __dump_class_nlmsg,
+			    dump_class_nlmsg, cookie);
+}
+
+static int __dump_qdisc_nlmsg(struct nlmsghdr *nlh,
+			      dump_nlmsg_t dump_qdisc_nlmsg,
+			      void *cookie)
+{
+	struct nlattr *tb[TCA_MAX + 1], *attr;
+	struct tcmsg *t =3D NLMSG_DATA(nlh);
+	int len;
+
+	len =3D nlh->nlmsg_len - NLMSG_LENGTH(sizeof(*t));
+	attr =3D (struct nlattr *) ((void *) t + NLMSG_ALIGN(sizeof(*t)));
+	if (libbpf_nla_parse(tb, TCA_MAX, attr, len, NULL) !=3D 0)
+		return -LIBBPF_ERRNO__NLPARSE;
+
+	return dump_qdisc_nlmsg(cookie, t, tb);
+}
+
+static int netlink_get_qdisc(int sock, unsigned int nl_pid, int ifindex,
+			     dump_nlmsg_t dump_qdisc_nlmsg, void *cookie)
+{
+	struct {
+		struct nlmsghdr nlh;
+		struct tcmsg t;
+	} req =3D {
+		.nlh.nlmsg_len =3D NLMSG_LENGTH(sizeof(struct tcmsg)),
+		.nlh.nlmsg_type =3D RTM_GETQDISC,
+		.nlh.nlmsg_flags =3D NLM_F_DUMP | NLM_F_REQUEST,
+		.t.tcm_family =3D AF_UNSPEC,
+		.t.tcm_ifindex =3D ifindex,
+	};
+	int seq =3D time(NULL);
+
+	req.nlh.nlmsg_seq =3D seq;
+	if (send(sock, &req, req.nlh.nlmsg_len, 0) < 0)
+		return -errno;
+
+	return netlink_recv(sock, nl_pid, seq, __dump_qdisc_nlmsg,
+			    dump_qdisc_nlmsg, cookie);
+}
+
+static int __dump_filter_nlmsg(struct nlmsghdr *nlh,
+			       dump_nlmsg_t dump_filter_nlmsg,
+			       void *cookie)
+{
+	struct nlattr *tb[TCA_MAX + 1], *attr;
+	struct tcmsg *t =3D NLMSG_DATA(nlh);
+	int len;
+
+	len =3D nlh->nlmsg_len - NLMSG_LENGTH(sizeof(*t));
+	attr =3D (struct nlattr *) ((void *) t + NLMSG_ALIGN(sizeof(*t)));
+	if (libbpf_nla_parse(tb, TCA_MAX, attr, len, NULL) !=3D 0)
+		return -LIBBPF_ERRNO__NLPARSE;
+
+	return dump_filter_nlmsg(cookie, t, tb);
+}
+
+static int netlink_get_filter(int sock, unsigned int nl_pid, int ifindex=
, int handle,
+			      dump_nlmsg_t dump_filter_nlmsg, void *cookie)
+{
+	struct {
+		struct nlmsghdr nlh;
+		struct tcmsg t;
+	} req =3D {
+		.nlh.nlmsg_len =3D NLMSG_LENGTH(sizeof(struct tcmsg)),
+		.nlh.nlmsg_type =3D RTM_GETTFILTER,
+		.nlh.nlmsg_flags =3D NLM_F_DUMP | NLM_F_REQUEST,
+		.t.tcm_family =3D AF_UNSPEC,
+		.t.tcm_ifindex =3D ifindex,
+		.t.tcm_parent =3D handle,
+	};
+	int seq =3D time(NULL);
+
+	req.nlh.nlmsg_seq =3D seq;
+	if (send(sock, &req, req.nlh.nlmsg_len, 0) < 0)
+		return -errno;
+
+	return netlink_recv(sock, nl_pid, seq, __dump_filter_nlmsg,
+			    dump_filter_nlmsg, cookie);
+}
+
+static int __dump_link_nlmsg(struct nlmsghdr *nlh,
+			     dump_nlmsg_t dump_link_nlmsg, void *cookie)
+{
+	struct nlattr *tb[IFLA_MAX + 1], *attr;
+	struct ifinfomsg *ifi =3D NLMSG_DATA(nlh);
+	int len;
+
+	len =3D nlh->nlmsg_len - NLMSG_LENGTH(sizeof(*ifi));
+	attr =3D (struct nlattr *) ((void *) ifi + NLMSG_ALIGN(sizeof(*ifi)));
+	if (libbpf_nla_parse(tb, IFLA_MAX, attr, len, NULL) !=3D 0)
+		return -LIBBPF_ERRNO__NLPARSE;
+
+	return dump_link_nlmsg(cookie, ifi, tb);
+}
+
+static int netlink_get_link(int sock, unsigned int nl_pid,
+			    dump_nlmsg_t dump_link_nlmsg, void *cookie)
+{
+	struct {
+		struct nlmsghdr nlh;
+		struct ifinfomsg ifm;
+	} req =3D {
+		.nlh.nlmsg_len =3D NLMSG_LENGTH(sizeof(struct ifinfomsg)),
+		.nlh.nlmsg_type =3D RTM_GETLINK,
+		.nlh.nlmsg_flags =3D NLM_F_DUMP | NLM_F_REQUEST,
+		.ifm.ifi_family =3D AF_PACKET,
+	};
+	int seq =3D time(NULL);
+
+	req.nlh.nlmsg_seq =3D seq;
+	if (send(sock, &req, req.nlh.nlmsg_len, 0) < 0)
+		return -errno;
+
+	return netlink_recv(sock, nl_pid, seq, __dump_link_nlmsg,
+			    dump_link_nlmsg, cookie);
+}
+
 static int dump_link_nlmsg(void *cookie, void *msg, struct nlattr **tb)
 {
 	struct bpf_netdev_t *netinfo =3D cookie;
@@ -168,14 +433,14 @@ static int show_dev_tc_bpf(int sock, unsigned int n=
l_pid,
 	tcinfo.array_len =3D 0;
=20
 	tcinfo.is_qdisc =3D false;
-	ret =3D libbpf_nl_get_class(sock, nl_pid, dev->ifindex,
-				  dump_class_qdisc_nlmsg, &tcinfo);
+	ret =3D netlink_get_class(sock, nl_pid, dev->ifindex,
+				dump_class_qdisc_nlmsg, &tcinfo);
 	if (ret)
 		goto out;
=20
 	tcinfo.is_qdisc =3D true;
-	ret =3D libbpf_nl_get_qdisc(sock, nl_pid, dev->ifindex,
-				  dump_class_qdisc_nlmsg, &tcinfo);
+	ret =3D netlink_get_qdisc(sock, nl_pid, dev->ifindex,
+				dump_class_qdisc_nlmsg, &tcinfo);
 	if (ret)
 		goto out;
=20
@@ -183,9 +448,9 @@ static int show_dev_tc_bpf(int sock, unsigned int nl_=
pid,
 	filter_info.ifindex =3D dev->ifindex;
 	for (i =3D 0; i < tcinfo.used_len; i++) {
 		filter_info.kind =3D tcinfo.handle_array[i].kind;
-		ret =3D libbpf_nl_get_filter(sock, nl_pid, dev->ifindex,
-					   tcinfo.handle_array[i].handle,
-					   dump_filter_nlmsg, &filter_info);
+		ret =3D netlink_get_filter(sock, nl_pid, dev->ifindex,
+					 tcinfo.handle_array[i].handle,
+					 dump_filter_nlmsg, &filter_info);
 		if (ret)
 			goto out;
 	}
@@ -193,22 +458,22 @@ static int show_dev_tc_bpf(int sock, unsigned int n=
l_pid,
 	/* root, ingress and egress handle */
 	handle =3D TC_H_ROOT;
 	filter_info.kind =3D "root";
-	ret =3D libbpf_nl_get_filter(sock, nl_pid, dev->ifindex, handle,
-				   dump_filter_nlmsg, &filter_info);
+	ret =3D netlink_get_filter(sock, nl_pid, dev->ifindex, handle,
+				 dump_filter_nlmsg, &filter_info);
 	if (ret)
 		goto out;
=20
 	handle =3D TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_INGRESS);
 	filter_info.kind =3D "clsact/ingress";
-	ret =3D libbpf_nl_get_filter(sock, nl_pid, dev->ifindex, handle,
-				   dump_filter_nlmsg, &filter_info);
+	ret =3D netlink_get_filter(sock, nl_pid, dev->ifindex, handle,
+				 dump_filter_nlmsg, &filter_info);
 	if (ret)
 		goto out;
=20
 	handle =3D TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_EGRESS);
 	filter_info.kind =3D "clsact/egress";
-	ret =3D libbpf_nl_get_filter(sock, nl_pid, dev->ifindex, handle,
-				   dump_filter_nlmsg, &filter_info);
+	ret =3D netlink_get_filter(sock, nl_pid, dev->ifindex, handle,
+				 dump_filter_nlmsg, &filter_info);
 	if (ret)
 		goto out;
=20
@@ -386,7 +651,7 @@ static int do_show(int argc, char **argv)
 	struct bpf_attach_info attach_info =3D {};
 	int i, sock, ret, filter_idx =3D -1;
 	struct bpf_netdev_t dev_array;
-	unsigned int nl_pid;
+	unsigned int nl_pid =3D 0;
 	char err_buf[256];
=20
 	if (argc =3D=3D 2) {
@@ -401,7 +666,7 @@ static int do_show(int argc, char **argv)
 	if (ret)
 		return -1;
=20
-	sock =3D libbpf_netlink_open(&nl_pid);
+	sock =3D netlink_open(&nl_pid);
 	if (sock < 0) {
 		fprintf(stderr, "failed to open netlink sock\n");
 		return -1;
@@ -416,7 +681,7 @@ static int do_show(int argc, char **argv)
 		jsonw_start_array(json_wtr);
 	NET_START_OBJECT;
 	NET_START_ARRAY("xdp", "%s:\n");
-	ret =3D libbpf_nl_get_link(sock, nl_pid, dump_link_nlmsg, &dev_array);
+	ret =3D netlink_get_link(sock, nl_pid, dump_link_nlmsg, &dev_array);
 	NET_END_ARRAY("\n");
=20
 	if (!ret) {
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_inter=
nal.h
index 2c9fe73b71e0..013053c59614 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -130,18 +130,6 @@ int bpf_object__section_size(const struct bpf_object=
 *obj, const char *name,
 int bpf_object__variable_offset(const struct bpf_object *obj, const char=
 *name,
 				__u32 *off);
=20
-struct nlattr;
-typedef int (*libbpf_dump_nlmsg_t)(void *cookie, void *msg, struct nlatt=
r **tb);
-int libbpf_netlink_open(unsigned int *nl_pid);
-int libbpf_nl_get_link(int sock, unsigned int nl_pid,
-		       libbpf_dump_nlmsg_t dump_link_nlmsg, void *cookie);
-int libbpf_nl_get_class(int sock, unsigned int nl_pid, int ifindex,
-			libbpf_dump_nlmsg_t dump_class_nlmsg, void *cookie);
-int libbpf_nl_get_qdisc(int sock, unsigned int nl_pid, int ifindex,
-			libbpf_dump_nlmsg_t dump_qdisc_nlmsg, void *cookie);
-int libbpf_nl_get_filter(int sock, unsigned int nl_pid, int ifindex, int=
 handle,
-			 libbpf_dump_nlmsg_t dump_filter_nlmsg, void *cookie);
-
 struct btf_ext_info {
 	/*
 	 * info points to the individual info section (e.g. func_info and
diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index 312f887570b2..2465538a5ba9 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -22,6 +22,8 @@
 #define SOL_NETLINK 270
 #endif
=20
+typedef int (*libbpf_dump_nlmsg_t)(void *cookie, void *msg, struct nlatt=
r **tb);
+
 typedef int (*__dump_nlmsg_t)(struct nlmsghdr *nlmsg, libbpf_dump_nlmsg_=
t,
 			      void *cookie);
=20
@@ -31,7 +33,7 @@ struct xdp_id_md {
 	struct xdp_link_info info;
 };
=20
-int libbpf_netlink_open(__u32 *nl_pid)
+static int libbpf_netlink_open(__u32 *nl_pid)
 {
 	struct sockaddr_nl sa;
 	socklen_t addrlen;
@@ -283,6 +285,9 @@ static int get_xdp_info(void *cookie, void *msg, stru=
ct nlattr **tb)
 	return 0;
 }
=20
+static int libbpf_nl_get_link(int sock, unsigned int nl_pid,
+			      libbpf_dump_nlmsg_t dump_link_nlmsg, void *cookie);
+
 int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
 			  size_t info_size, __u32 flags)
 {
@@ -368,121 +373,3 @@ int libbpf_nl_get_link(int sock, unsigned int nl_pi=
d,
 	return bpf_netlink_recv(sock, nl_pid, seq, __dump_link_nlmsg,
 				dump_link_nlmsg, cookie);
 }
-
-static int __dump_class_nlmsg(struct nlmsghdr *nlh,
-			      libbpf_dump_nlmsg_t dump_class_nlmsg,
-			      void *cookie)
-{
-	struct nlattr *tb[TCA_MAX + 1], *attr;
-	struct tcmsg *t =3D NLMSG_DATA(nlh);
-	int len;
-
-	len =3D nlh->nlmsg_len - NLMSG_LENGTH(sizeof(*t));
-	attr =3D (struct nlattr *) ((void *) t + NLMSG_ALIGN(sizeof(*t)));
-	if (libbpf_nla_parse(tb, TCA_MAX, attr, len, NULL) !=3D 0)
-		return -LIBBPF_ERRNO__NLPARSE;
-
-	return dump_class_nlmsg(cookie, t, tb);
-}
-
-int libbpf_nl_get_class(int sock, unsigned int nl_pid, int ifindex,
-			libbpf_dump_nlmsg_t dump_class_nlmsg, void *cookie)
-{
-	struct {
-		struct nlmsghdr nlh;
-		struct tcmsg t;
-	} req =3D {
-		.nlh.nlmsg_len =3D NLMSG_LENGTH(sizeof(struct tcmsg)),
-		.nlh.nlmsg_type =3D RTM_GETTCLASS,
-		.nlh.nlmsg_flags =3D NLM_F_DUMP | NLM_F_REQUEST,
-		.t.tcm_family =3D AF_UNSPEC,
-		.t.tcm_ifindex =3D ifindex,
-	};
-	int seq =3D time(NULL);
-
-	req.nlh.nlmsg_seq =3D seq;
-	if (send(sock, &req, req.nlh.nlmsg_len, 0) < 0)
-		return -errno;
-
-	return bpf_netlink_recv(sock, nl_pid, seq, __dump_class_nlmsg,
-				dump_class_nlmsg, cookie);
-}
-
-static int __dump_qdisc_nlmsg(struct nlmsghdr *nlh,
-			      libbpf_dump_nlmsg_t dump_qdisc_nlmsg,
-			      void *cookie)
-{
-	struct nlattr *tb[TCA_MAX + 1], *attr;
-	struct tcmsg *t =3D NLMSG_DATA(nlh);
-	int len;
-
-	len =3D nlh->nlmsg_len - NLMSG_LENGTH(sizeof(*t));
-	attr =3D (struct nlattr *) ((void *) t + NLMSG_ALIGN(sizeof(*t)));
-	if (libbpf_nla_parse(tb, TCA_MAX, attr, len, NULL) !=3D 0)
-		return -LIBBPF_ERRNO__NLPARSE;
-
-	return dump_qdisc_nlmsg(cookie, t, tb);
-}
-
-int libbpf_nl_get_qdisc(int sock, unsigned int nl_pid, int ifindex,
-			libbpf_dump_nlmsg_t dump_qdisc_nlmsg, void *cookie)
-{
-	struct {
-		struct nlmsghdr nlh;
-		struct tcmsg t;
-	} req =3D {
-		.nlh.nlmsg_len =3D NLMSG_LENGTH(sizeof(struct tcmsg)),
-		.nlh.nlmsg_type =3D RTM_GETQDISC,
-		.nlh.nlmsg_flags =3D NLM_F_DUMP | NLM_F_REQUEST,
-		.t.tcm_family =3D AF_UNSPEC,
-		.t.tcm_ifindex =3D ifindex,
-	};
-	int seq =3D time(NULL);
-
-	req.nlh.nlmsg_seq =3D seq;
-	if (send(sock, &req, req.nlh.nlmsg_len, 0) < 0)
-		return -errno;
-
-	return bpf_netlink_recv(sock, nl_pid, seq, __dump_qdisc_nlmsg,
-				dump_qdisc_nlmsg, cookie);
-}
-
-static int __dump_filter_nlmsg(struct nlmsghdr *nlh,
-			       libbpf_dump_nlmsg_t dump_filter_nlmsg,
-			       void *cookie)
-{
-	struct nlattr *tb[TCA_MAX + 1], *attr;
-	struct tcmsg *t =3D NLMSG_DATA(nlh);
-	int len;
-
-	len =3D nlh->nlmsg_len - NLMSG_LENGTH(sizeof(*t));
-	attr =3D (struct nlattr *) ((void *) t + NLMSG_ALIGN(sizeof(*t)));
-	if (libbpf_nla_parse(tb, TCA_MAX, attr, len, NULL) !=3D 0)
-		return -LIBBPF_ERRNO__NLPARSE;
-
-	return dump_filter_nlmsg(cookie, t, tb);
-}
-
-int libbpf_nl_get_filter(int sock, unsigned int nl_pid, int ifindex, int=
 handle,
-			 libbpf_dump_nlmsg_t dump_filter_nlmsg, void *cookie)
-{
-	struct {
-		struct nlmsghdr nlh;
-		struct tcmsg t;
-	} req =3D {
-		.nlh.nlmsg_len =3D NLMSG_LENGTH(sizeof(struct tcmsg)),
-		.nlh.nlmsg_type =3D RTM_GETTFILTER,
-		.nlh.nlmsg_flags =3D NLM_F_DUMP | NLM_F_REQUEST,
-		.t.tcm_family =3D AF_UNSPEC,
-		.t.tcm_ifindex =3D ifindex,
-		.t.tcm_parent =3D handle,
-	};
-	int seq =3D time(NULL);
-
-	req.nlh.nlmsg_seq =3D seq;
-	if (send(sock, &req, req.nlh.nlmsg_len, 0) < 0)
-		return -errno;
-
-	return bpf_netlink_recv(sock, nl_pid, seq, __dump_filter_nlmsg,
-				dump_filter_nlmsg, cookie);
-}
--=20
2.24.1

