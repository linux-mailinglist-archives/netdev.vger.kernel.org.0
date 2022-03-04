Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCBC4CDB0A
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 18:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241421AbiCDRgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 12:36:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241268AbiCDRg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 12:36:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EFDBE4F9E2
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 09:35:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646415304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P4dsF2EhkFauEdp0HjjqmUlAUUQayYI3BzeDrS6IW5o=;
        b=UboHNQDsGgU0dhebtdjsi4+lIEYgzrisMwsPJR8NWLqeja/WHnpaWEV7yYkt2/WXe1xANY
        yPD2VP1+07Vvqsf81aZhBGKy5GRNxut8IU20G0xZMJb+kJw5DS22UAmdUzuakBG/w2CkQn
        V5zFJIlgZbkixldCMH6ucx/I+Q31/Oc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-425-XrAQH9HIPDG3yTSLSPEL1A-1; Fri, 04 Mar 2022 12:35:01 -0500
X-MC-Unique: XrAQH9HIPDG3yTSLSPEL1A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CD1E805EE5;
        Fri,  4 Mar 2022 17:34:58 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 45EE386595;
        Fri,  4 Mar 2022 17:34:39 +0000 (UTC)
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
        Joe Stringer <joe@cilium.io>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v2 26/28] libbpf: add handling for BPF_F_INSERT_HEAD in HID programs
Date:   Fri,  4 Mar 2022 18:28:50 +0100
Message-Id: <20220304172852.274126-27-benjamin.tissoires@redhat.com>
In-Reply-To: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export the newly created flag to libbpf.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

new in v2
---
 tools/include/uapi/linux/bpf.h | 10 ++++++++++
 tools/lib/bpf/libbpf.c         | 17 +++++++++--------
 tools/lib/bpf/libbpf.h         |  2 +-
 3 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 417cf1c31579..23ebe5e96d69 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1123,6 +1123,16 @@ enum bpf_link_type {
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
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index d1e305f760bb..6f0cb6717207 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10533,10 +10533,11 @@ static struct bpf_link *attach_lsm(const struct bpf_program *prog, long cookie)
 
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
@@ -10570,19 +10571,19 @@ bpf_program__attach_fd(const struct bpf_program *prog, int target_fd, int btf_id
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
@@ -10608,7 +10609,7 @@ struct bpf_link *bpf_program__attach_freplace(const struct bpf_program *prog,
 		if (btf_id < 0)
 			return libbpf_err_ptr(btf_id);
 
-		return bpf_program__attach_fd(prog, target_fd, btf_id, "freplace");
+		return bpf_program__attach_fd(prog, target_fd, btf_id, "freplace", 0);
 	} else {
 		/* no target, so use raw_tracepoint_open for compatibility
 		 * with old kernels
@@ -10663,9 +10664,9 @@ static struct bpf_link *attach_iter(const struct bpf_program *prog, long cookie)
 }
 
 struct bpf_link *
-bpf_program__attach_hid(const struct bpf_program *prog, int hid_fd)
+bpf_program__attach_hid(const struct bpf_program *prog, int hid_fd, __u32 flags)
 {
-	return bpf_program__attach_fd(prog, hid_fd, 0, "hid");
+	return bpf_program__attach_fd(prog, hid_fd, 0, "hid", flags);
 }
 
 struct bpf_link *bpf_program__attach(const struct bpf_program *prog)
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index f677ac0a9ede..65be3e2ec62d 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -530,7 +530,7 @@ LIBBPF_API struct bpf_link *
 bpf_program__attach_iter(const struct bpf_program *prog,
 			 const struct bpf_iter_attach_opts *opts);
 LIBBPF_API struct bpf_link *
-bpf_program__attach_hid(const struct bpf_program *prog, int hid_fd);
+bpf_program__attach_hid(const struct bpf_program *prog, int hid_fd, __u32 flags);
 
 /*
  * Libbpf allows callers to adjust BPF programs before being loaded
-- 
2.35.1

