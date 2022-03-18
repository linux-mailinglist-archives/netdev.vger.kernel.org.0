Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 556D94DDE7C
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238861AbiCRQTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238826AbiCRQSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:18:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 724C81D78A3
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 09:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647620197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8pb2b2yBvlyePXc4neaXnpSmeAYYQklyRoO6YAaoGbs=;
        b=CgFRV8nMCc4NPi95IwikJfyHz/rHRrU+t/08kCa9ZA1rvdLgO0KOEo1IcsaAzP8tU2MuXT
        2QDVNcZZt/sDmhMjlAvvlEaJyGHG21JcWOCdjgg5j71qOHdKgmohhL35PTUPCWlVO1eU+u
        8pnRtOBAWduGz977b2JvF2ECR97dnnk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-137-AanS3ePaM0SrClnrgLZ8Og-1; Fri, 18 Mar 2022 12:16:35 -0400
X-MC-Unique: AanS3ePaM0SrClnrgLZ8Og-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D9A6C899EC1;
        Fri, 18 Mar 2022 16:16:28 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 95DC833250;
        Fri, 18 Mar 2022 16:16:22 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v3 04/17] libbpf: add HID program type and API
Date:   Fri, 18 Mar 2022 17:15:15 +0100
Message-Id: <20220318161528.1531164-5-benjamin.tissoires@redhat.com>
In-Reply-To: <20220318161528.1531164-1-benjamin.tissoires@redhat.com>
References: <20220318161528.1531164-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HID-bpf program type are needing new SECs.
To bind a hid-bpf program, we can rely on bpf_program__attach_fd()
so export a new function to the API.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v3:
- squashed the libbpf changes into 1
- moved bpf_program__attach_hid to 0.8.0
- added SEC_DEF("hid/driver_event")

changes in v2:
- split the series by bpf/libbpf/hid/selftests and samples
---
 tools/include/uapi/linux/bpf.h | 31 +++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.c         | 23 +++++++++++++++++------
 tools/lib/bpf/libbpf.h         |  2 ++
 tools/lib/bpf/libbpf.map       |  1 +
 4 files changed, 51 insertions(+), 6 deletions(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 99fab54ae9c0..0e8438e93768 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -952,6 +952,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_LSM,
 	BPF_PROG_TYPE_SK_LOOKUP,
 	BPF_PROG_TYPE_SYSCALL, /* a program that can execute syscalls */
+	BPF_PROG_TYPE_HID,
 };
 
 enum bpf_attach_type {
@@ -997,6 +998,10 @@ enum bpf_attach_type {
 	BPF_SK_REUSEPORT_SELECT,
 	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	BPF_PERF_EVENT,
+	BPF_HID_DEVICE_EVENT,
+	BPF_HID_RDESC_FIXUP,
+	BPF_HID_USER_EVENT,
+	BPF_HID_DRIVER_EVENT,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -1011,6 +1016,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_NETNS = 5,
 	BPF_LINK_TYPE_XDP = 6,
 	BPF_LINK_TYPE_PERF_EVENT = 7,
+	BPF_LINK_TYPE_HID = 8,
 
 	MAX_BPF_LINK_TYPE,
 };
@@ -1118,6 +1124,16 @@ enum bpf_link_type {
  */
 #define BPF_F_XDP_HAS_FRAGS	(1U << 5)
 
+/* HID flag used in BPF_LINK_CREATE command
+ *
+ * NONE(default): The bpf program will be added at the tail of the list
+ * of existing bpf program for this type.
+ *
+ * BPF_F_INSERT_HEAD: The bpf program will be added at the beginning
+ * of the list of existing bpf program for this type..
+ */
+#define BPF_F_INSERT_HEAD	(1U << 0)
+
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
  * the following extensions:
  *
@@ -5129,6 +5145,16 @@ union bpf_attr {
  *		The **hash_algo** is returned on success,
  *		**-EOPNOTSUP** if the hash calculation failed or **-EINVAL** if
  *		invalid arguments are passed.
+ *
+ * void *bpf_hid_get_data(void *ctx, u64 offset, u64 size)
+ *	Description
+ *		Returns a pointer to the data associated with context at the given
+ *		offset and size (in bytes).
+ *
+ *		Note: the returned pointer is refcounted and must be dereferenced
+ *		by a call to bpf_hid_discard;
+ *	Return
+ *		The pointer to the data. On error, a null value is returned.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5325,6 +5351,7 @@ union bpf_attr {
 	FN(copy_from_user_task),	\
 	FN(skb_set_tstamp),		\
 	FN(ima_file_hash),		\
+	FN(hid_get_data),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
@@ -5925,6 +5952,10 @@ struct bpf_link_info {
 		struct {
 			__u32 ifindex;
 		} xdp;
+		struct  {
+			__s32 hidraw_number;
+			__u32 attach_type;
+		} hid;
 	};
 } __attribute__((aligned(8)));
 
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 43161fdd44bb..6b9ba313eb5b 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8675,6 +8675,10 @@ static const struct bpf_sec_def section_defs[] = {
 	SEC_DEF("cgroup/setsockopt",	CGROUP_SOCKOPT, BPF_CGROUP_SETSOCKOPT, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
 	SEC_DEF("struct_ops+",		STRUCT_OPS, 0, SEC_NONE),
 	SEC_DEF("sk_lookup",		SK_LOOKUP, BPF_SK_LOOKUP, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
+	SEC_DEF("hid/device_event",	HID, BPF_HID_DEVICE_EVENT, SEC_ATTACHABLE_OPT),
+	SEC_DEF("hid/rdesc_fixup",	HID, BPF_HID_RDESC_FIXUP, SEC_ATTACHABLE_OPT),
+	SEC_DEF("hid/user_event",	HID, BPF_HID_USER_EVENT, SEC_ATTACHABLE_OPT),
+	SEC_DEF("hid/driver_event",	HID, BPF_HID_DRIVER_EVENT, SEC_ATTACHABLE_OPT),
 };
 
 static size_t custom_sec_def_cnt;
@@ -10630,10 +10634,11 @@ static int attach_lsm(const struct bpf_program *prog, long cookie, struct bpf_li
 
 static struct bpf_link *
 bpf_program__attach_fd(const struct bpf_program *prog, int target_fd, int btf_id,
-		       const char *target_name)
+		       const char *target_name, __u32 flags)
 {
 	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts,
-			    .target_btf_id = btf_id);
+			    .target_btf_id = btf_id,
+			    .flags = flags);
 	enum bpf_attach_type attach_type;
 	char errmsg[STRERR_BUFSIZE];
 	struct bpf_link *link;
@@ -10667,19 +10672,19 @@ bpf_program__attach_fd(const struct bpf_program *prog, int target_fd, int btf_id
 struct bpf_link *
 bpf_program__attach_cgroup(const struct bpf_program *prog, int cgroup_fd)
 {
-	return bpf_program__attach_fd(prog, cgroup_fd, 0, "cgroup");
+	return bpf_program__attach_fd(prog, cgroup_fd, 0, "cgroup", 0);
 }
 
 struct bpf_link *
 bpf_program__attach_netns(const struct bpf_program *prog, int netns_fd)
 {
-	return bpf_program__attach_fd(prog, netns_fd, 0, "netns");
+	return bpf_program__attach_fd(prog, netns_fd, 0, "netns", 0);
 }
 
 struct bpf_link *bpf_program__attach_xdp(const struct bpf_program *prog, int ifindex)
 {
 	/* target_fd/target_ifindex use the same field in LINK_CREATE */
-	return bpf_program__attach_fd(prog, ifindex, 0, "xdp");
+	return bpf_program__attach_fd(prog, ifindex, 0, "xdp", 0);
 }
 
 struct bpf_link *bpf_program__attach_freplace(const struct bpf_program *prog,
@@ -10705,7 +10710,7 @@ struct bpf_link *bpf_program__attach_freplace(const struct bpf_program *prog,
 		if (btf_id < 0)
 			return libbpf_err_ptr(btf_id);
 
-		return bpf_program__attach_fd(prog, target_fd, btf_id, "freplace");
+		return bpf_program__attach_fd(prog, target_fd, btf_id, "freplace", 0);
 	} else {
 		/* no target, so use raw_tracepoint_open for compatibility
 		 * with old kernels
@@ -10760,6 +10765,12 @@ static int attach_iter(const struct bpf_program *prog, long cookie, struct bpf_l
 	return libbpf_get_error(*link);
 }
 
+struct bpf_link *
+bpf_program__attach_hid(const struct bpf_program *prog, int hid_fd, __u32 flags)
+{
+	return bpf_program__attach_fd(prog, hid_fd, 0, "hid", flags);
+}
+
 struct bpf_link *bpf_program__attach(const struct bpf_program *prog)
 {
 	struct bpf_link *link = NULL;
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index c1b0c2ef14d8..13dff4865da5 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -529,6 +529,8 @@ struct bpf_iter_attach_opts {
 LIBBPF_API struct bpf_link *
 bpf_program__attach_iter(const struct bpf_program *prog,
 			 const struct bpf_iter_attach_opts *opts);
+LIBBPF_API struct bpf_link *
+bpf_program__attach_hid(const struct bpf_program *prog, int hid_fd, __u32 flags);
 
 /*
  * Libbpf allows callers to adjust BPF programs before being loaded
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index df1b947792c8..cd8da9a8bf36 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -442,6 +442,7 @@ LIBBPF_0.7.0 {
 
 LIBBPF_0.8.0 {
 	global:
+		bpf_program__attach_hid;
 		libbpf_register_prog_handler;
 		libbpf_unregister_prog_handler;
 } LIBBPF_0.7.0;
-- 
2.35.1

