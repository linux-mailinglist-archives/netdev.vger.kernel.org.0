Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 889A565FED6
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 11:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233866AbjAFKZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 05:25:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233923AbjAFKY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 05:24:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 319F96C2A2
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 02:24:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673000644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yMx0VFWSe/HSirwwjeE/1mnBkcQMvjFqn8mb9g1aYYU=;
        b=KJ20i/YvjWM5r9AQ7AJDcYXpzLExIlbQcQNvhpo+/IgnmW9QiX89hKqnMf5ah1lfeAfW5l
        P42M84a9fQ71XNeOG2qmqG9Vd0pvSOUxtFfmK6r0diyOps24IuiOqJ6iml+c1JhKw9PtR4
        UjcnLnbeNFOKiR12rL4E/XtgMebCKYc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-155-XGZ97nDGNW2cpzInjHf2Pg-1; Fri, 06 Jan 2023 05:23:58 -0500
X-MC-Unique: XGZ97nDGNW2cpzInjHf2Pg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1F51E380662E;
        Fri,  6 Jan 2023 10:23:58 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D376C15BAD;
        Fri,  6 Jan 2023 10:23:55 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH HID for-next v1 8/9] HID: bpf: clean up entrypoint
Date:   Fri,  6 Jan 2023 11:23:31 +0100
Message-Id: <20230106102332.1019632-9-benjamin.tissoires@redhat.com>
In-Reply-To: <20230106102332.1019632-1-benjamin.tissoires@redhat.com>
References: <20230106102332.1019632-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't need to watch for calls on bpf_prog_put_deferred(), so remove
that from the entrypoints.bpf.c file.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/bpf/entrypoints/entrypoints.bpf.c |   9 -
 .../hid/bpf/entrypoints/entrypoints.lskel.h   | 188 +++++-------------
 drivers/hid/bpf/hid_bpf_dispatch.c            |   1 -
 drivers/hid/bpf/hid_bpf_dispatch.h            |   3 -
 4 files changed, 53 insertions(+), 148 deletions(-)

diff --git a/drivers/hid/bpf/entrypoints/entrypoints.bpf.c b/drivers/hid/bpf/entrypoints/entrypoints.bpf.c
index 7c1895d9e5c0..c22921125a1a 100644
--- a/drivers/hid/bpf/entrypoints/entrypoints.bpf.c
+++ b/drivers/hid/bpf/entrypoints/entrypoints.bpf.c
@@ -7,8 +7,6 @@
 
 #define HID_BPF_MAX_PROGS 1024
 
-extern void call_hid_bpf_prog_put_deferred(struct work_struct *work) __ksym;
-
 struct {
 	__uint(type, BPF_MAP_TYPE_PROG_ARRAY);
 	__uint(max_entries, HID_BPF_MAX_PROGS);
@@ -24,11 +22,4 @@ int BPF_PROG(hid_tail_call, struct hid_bpf_ctx *hctx)
 	return 0;
 }
 
-SEC("fentry/bpf_prog_put_deferred")
-int BPF_PROG(hid_bpf_prog_put_deferred, struct work_struct *work)
-{
-	call_hid_bpf_prog_put_deferred(work);
-	return 0;
-}
-
 char LICENSE[] SEC("license") = "GPL";
diff --git a/drivers/hid/bpf/entrypoints/entrypoints.lskel.h b/drivers/hid/bpf/entrypoints/entrypoints.lskel.h
index 9ffb991b3e6f..35618051598c 100644
--- a/drivers/hid/bpf/entrypoints/entrypoints.lskel.h
+++ b/drivers/hid/bpf/entrypoints/entrypoints.lskel.h
@@ -12,11 +12,9 @@ struct entrypoints_bpf {
 	} maps;
 	struct {
 		struct bpf_prog_desc hid_tail_call;
-		struct bpf_prog_desc hid_bpf_prog_put_deferred;
 	} progs;
 	struct {
 		int hid_tail_call_fd;
-		int hid_bpf_prog_put_deferred_fd;
 	} links;
 };
 
@@ -31,24 +29,12 @@ entrypoints_bpf__hid_tail_call__attach(struct entrypoints_bpf *skel)
 	return fd;
 }
 
-static inline int
-entrypoints_bpf__hid_bpf_prog_put_deferred__attach(struct entrypoints_bpf *skel)
-{
-	int prog_fd = skel->progs.hid_bpf_prog_put_deferred.prog_fd;
-	int fd = skel_raw_tracepoint_open(NULL, prog_fd);
-
-	if (fd > 0)
-		skel->links.hid_bpf_prog_put_deferred_fd = fd;
-	return fd;
-}
-
 static inline int
 entrypoints_bpf__attach(struct entrypoints_bpf *skel)
 {
 	int ret = 0;
 
 	ret = ret < 0 ? ret : entrypoints_bpf__hid_tail_call__attach(skel);
-	ret = ret < 0 ? ret : entrypoints_bpf__hid_bpf_prog_put_deferred__attach(skel);
 	return ret < 0 ? ret : 0;
 }
 
@@ -56,7 +42,6 @@ static inline void
 entrypoints_bpf__detach(struct entrypoints_bpf *skel)
 {
 	skel_closenz(skel->links.hid_tail_call_fd);
-	skel_closenz(skel->links.hid_bpf_prog_put_deferred_fd);
 }
 static void
 entrypoints_bpf__destroy(struct entrypoints_bpf *skel)
@@ -65,7 +50,6 @@ entrypoints_bpf__destroy(struct entrypoints_bpf *skel)
 		return;
 	entrypoints_bpf__detach(skel);
 	skel_closenz(skel->progs.hid_tail_call.prog_fd);
-	skel_closenz(skel->progs.hid_bpf_prog_put_deferred.prog_fd);
 	skel_closenz(skel->maps.hid_jmp_table.map_fd);
 	skel_free(skel);
 }
@@ -91,7 +75,7 @@ entrypoints_bpf__load(struct entrypoints_bpf *skel)
 	int err;
 
 	opts.ctx = (struct bpf_loader_ctx *)skel;
-	opts.data_sz = 3792;
+	opts.data_sz = 2856;
 	opts.data = (void *)"\
 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
@@ -126,7 +110,7 @@ entrypoints_bpf__load(struct entrypoints_bpf *skel)
 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x9f\xeb\x01\0\
-\x18\0\0\0\0\0\0\0\xa4\x03\0\0\xa4\x03\0\0\x54\x03\0\0\0\0\0\0\0\0\0\x02\x03\0\
+\x18\0\0\0\0\0\0\0\x60\x02\0\0\x60\x02\0\0\x12\x02\0\0\0\0\0\0\0\0\0\x02\x03\0\
 \0\0\x01\0\0\0\0\0\0\x01\x04\0\0\0\x20\0\0\x01\0\0\0\0\0\0\0\x03\0\0\0\0\x02\0\
 \0\0\x04\0\0\0\x03\0\0\0\x05\0\0\0\0\0\0\x01\x04\0\0\0\x20\0\0\0\0\0\0\0\0\0\0\
 \x02\x06\0\0\0\0\0\0\0\0\0\0\x03\0\0\0\0\x02\0\0\0\x04\0\0\0\0\x04\0\0\0\0\0\0\
@@ -139,25 +123,14 @@ entrypoints_bpf__load(struct entrypoints_bpf *skel)
 \0\0\0\0\0\0\0\x1b\x01\0\0\x12\0\0\0\x40\0\0\0\x1f\x01\0\0\x10\0\0\0\x80\0\0\0\
 \x2e\x01\0\0\x14\0\0\0\xa0\0\0\0\0\0\0\0\x15\0\0\0\xc0\0\0\0\x3a\x01\0\0\0\0\0\
 \x08\x11\0\0\0\x40\x01\0\0\0\0\0\x01\x04\0\0\0\x20\0\0\0\0\0\0\0\0\0\0\x02\x13\
-\0\0\0\0\0\0\0\0\0\0\x0a\x2d\0\0\0\x4d\x01\0\0\x04\0\0\x06\x04\0\0\0\x5d\x01\0\
+\0\0\0\0\0\0\0\0\0\0\x0a\x1c\0\0\0\x4d\x01\0\0\x04\0\0\x06\x04\0\0\0\x5d\x01\0\
 \0\0\0\0\0\x6e\x01\0\0\x01\0\0\0\x80\x01\0\0\x02\0\0\0\x93\x01\0\0\x03\0\0\0\0\
 \0\0\0\x02\0\0\x05\x04\0\0\0\xa4\x01\0\0\x16\0\0\0\0\0\0\0\xab\x01\0\0\x16\0\0\
-\0\0\0\0\0\xb0\x01\0\0\0\0\0\x08\x02\0\0\0\0\0\0\0\x01\0\0\x0d\x02\0\0\0\x5f\0\
-\0\0\x0b\0\0\0\xec\x01\0\0\x01\0\0\x0c\x17\0\0\0\0\0\0\0\x01\0\0\x0d\0\0\0\0\
-\x49\x03\0\0\x1a\0\0\0\0\0\0\0\0\0\0\x02\x1b\0\0\0\x8c\x02\0\0\x03\0\0\x04\x20\
-\0\0\0\x98\x02\0\0\x1c\0\0\0\0\0\0\0\x9d\x02\0\0\x22\0\0\0\x40\0\0\0\xa3\x02\0\
-\0\x24\0\0\0\xc0\0\0\0\xa8\x02\0\0\0\0\0\x08\x1d\0\0\0\xb6\x02\0\0\0\0\0\x08\
-\x1e\0\0\0\0\0\0\0\x01\0\0\x04\x08\0\0\0\xc1\x02\0\0\x1f\0\0\0\0\0\0\0\xc9\x02\
-\0\0\0\0\0\x08\x20\0\0\0\xcd\x02\0\0\0\0\0\x08\x21\0\0\0\xd3\x02\0\0\0\0\0\x01\
-\x08\0\0\0\x40\0\0\x01\xdd\x02\0\0\x02\0\0\x04\x10\0\0\0\xe7\x02\0\0\x23\0\0\0\
-\0\0\0\0\xec\x02\0\0\x23\0\0\0\x40\0\0\0\0\0\0\0\0\0\0\x02\x22\0\0\0\xf1\x02\0\
-\0\0\0\0\x08\x25\0\0\0\0\0\0\0\0\0\0\x02\x19\0\0\0\xfd\x02\0\0\x01\0\0\x0c\x19\
-\0\0\0\x1c\x03\0\0\0\0\0\x01\x01\0\0\0\x08\0\0\x01\0\0\0\0\0\0\0\x03\0\0\0\0\
-\x27\0\0\0\x04\0\0\0\x04\0\0\0\x21\x03\0\0\0\0\0\x0e\x28\0\0\0\x01\0\0\0\x29\
-\x03\0\0\x01\0\0\x0f\x04\0\0\0\x2e\0\0\0\0\0\0\0\x04\0\0\0\x30\x03\0\0\x01\0\0\
-\x0f\x20\0\0\0\x0a\0\0\0\0\0\0\0\x20\0\0\0\x36\x03\0\0\x01\0\0\x0f\x04\0\0\0\
-\x29\0\0\0\0\0\0\0\x04\0\0\0\x3e\x03\0\0\0\0\0\x07\0\0\0\0\x49\x03\0\0\0\0\0\
-\x0e\x02\0\0\0\x01\0\0\0\0\x69\x6e\x74\0\x5f\x5f\x41\x52\x52\x41\x59\x5f\x53\
+\0\0\0\0\0\xb0\x01\0\0\0\0\0\x08\x02\0\0\0\xec\x01\0\0\0\0\0\x01\x01\0\0\0\x08\
+\0\0\x01\0\0\0\0\0\0\0\x03\0\0\0\0\x17\0\0\0\x04\0\0\0\x04\0\0\0\xf1\x01\0\0\0\
+\0\0\x0e\x18\0\0\0\x01\0\0\0\xf9\x01\0\0\x01\0\0\x0f\x20\0\0\0\x0a\0\0\0\0\0\0\
+\0\x20\0\0\0\xff\x01\0\0\x01\0\0\x0f\x04\0\0\0\x19\0\0\0\0\0\0\0\x04\0\0\0\x07\
+\x02\0\0\0\0\0\x07\0\0\0\0\0\x69\x6e\x74\0\x5f\x5f\x41\x52\x52\x41\x59\x5f\x53\
 \x49\x5a\x45\x5f\x54\x59\x50\x45\x5f\x5f\0\x74\x79\x70\x65\0\x6d\x61\x78\x5f\
 \x65\x6e\x74\x72\x69\x65\x73\0\x6b\x65\x79\x5f\x73\x69\x7a\x65\0\x76\x61\x6c\
 \x75\x65\x5f\x73\x69\x7a\x65\0\x68\x69\x64\x5f\x6a\x6d\x70\x5f\x74\x61\x62\x6c\
@@ -182,119 +155,64 @@ entrypoints_bpf__load(struct entrypoints_bpf *skel)
 \x5f\x5f\x73\x33\x32\0\x30\x3a\x30\0\x09\x62\x70\x66\x5f\x74\x61\x69\x6c\x5f\
 \x63\x61\x6c\x6c\x28\x63\x74\x78\x2c\x20\x26\x68\x69\x64\x5f\x6a\x6d\x70\x5f\
 \x74\x61\x62\x6c\x65\x2c\x20\x68\x63\x74\x78\x2d\x3e\x69\x6e\x64\x65\x78\x29\
-\x3b\0\x68\x69\x64\x5f\x62\x70\x66\x5f\x70\x72\x6f\x67\x5f\x70\x75\x74\x5f\x64\
-\x65\x66\x65\x72\x72\x65\x64\0\x66\x65\x6e\x74\x72\x79\x2f\x62\x70\x66\x5f\x70\
-\x72\x6f\x67\x5f\x70\x75\x74\x5f\x64\x65\x66\x65\x72\x72\x65\x64\0\x69\x6e\x74\
-\x20\x42\x50\x46\x5f\x50\x52\x4f\x47\x28\x68\x69\x64\x5f\x62\x70\x66\x5f\x70\
-\x72\x6f\x67\x5f\x70\x75\x74\x5f\x64\x65\x66\x65\x72\x72\x65\x64\x2c\x20\x73\
-\x74\x72\x75\x63\x74\x20\x77\x6f\x72\x6b\x5f\x73\x74\x72\x75\x63\x74\x20\x2a\
-\x77\x6f\x72\x6b\x29\0\x09\x63\x61\x6c\x6c\x5f\x68\x69\x64\x5f\x62\x70\x66\x5f\
-\x70\x72\x6f\x67\x5f\x70\x75\x74\x5f\x64\x65\x66\x65\x72\x72\x65\x64\x28\x77\
-\x6f\x72\x6b\x29\x3b\0\x77\x6f\x72\x6b\x5f\x73\x74\x72\x75\x63\x74\0\x64\x61\
-\x74\x61\0\x65\x6e\x74\x72\x79\0\x66\x75\x6e\x63\0\x61\x74\x6f\x6d\x69\x63\x5f\
-\x6c\x6f\x6e\x67\x5f\x74\0\x61\x74\x6f\x6d\x69\x63\x36\x34\x5f\x74\0\x63\x6f\
-\x75\x6e\x74\x65\x72\0\x73\x36\x34\0\x5f\x5f\x73\x36\x34\0\x6c\x6f\x6e\x67\x20\
-\x6c\x6f\x6e\x67\0\x6c\x69\x73\x74\x5f\x68\x65\x61\x64\0\x6e\x65\x78\x74\0\x70\
-\x72\x65\x76\0\x77\x6f\x72\x6b\x5f\x66\x75\x6e\x63\x5f\x74\0\x63\x61\x6c\x6c\
-\x5f\x68\x69\x64\x5f\x62\x70\x66\x5f\x70\x72\x6f\x67\x5f\x70\x75\x74\x5f\x64\
-\x65\x66\x65\x72\x72\x65\x64\0\x63\x68\x61\x72\0\x4c\x49\x43\x45\x4e\x53\x45\0\
-\x2e\x6b\x73\x79\x6d\x73\0\x2e\x6d\x61\x70\x73\0\x6c\x69\x63\x65\x6e\x73\x65\0\
-\x68\x69\x64\x5f\x64\x65\x76\x69\x63\x65\0\x64\x75\x6d\x6d\x79\x5f\x6b\x73\x79\
-\x6d\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x10\x07\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x03\
+\x3b\0\x63\x68\x61\x72\0\x4c\x49\x43\x45\x4e\x53\x45\0\x2e\x6d\x61\x70\x73\0\
+\x6c\x69\x63\x65\x6e\x73\x65\0\x68\x69\x64\x5f\x64\x65\x76\x69\x63\x65\0\0\0\0\
+\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x8a\x04\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x03\
 \0\0\0\x04\0\0\0\x04\0\0\0\0\x04\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x68\x69\x64\x5f\
 \x6a\x6d\x70\x5f\x74\x61\x62\x6c\x65\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
 \0\0\0\0\0\0\0\0\0\0\x47\x50\x4c\0\0\0\0\0\x79\x12\0\0\0\0\0\0\x61\x23\0\0\0\0\
 \0\0\x18\x52\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x85\0\0\0\x0c\0\0\0\xb7\0\0\0\0\0\0\0\
-\x95\0\0\0\0\0\0\0\0\0\0\0\x0e\0\0\0\0\0\0\0\x8e\0\0\0\xd3\0\0\0\x05\x50\0\0\
-\x01\0\0\0\x8e\0\0\0\xba\x01\0\0\x02\x58\0\0\x05\0\0\0\x8e\0\0\0\xd3\0\0\0\x05\
-\x50\0\0\x08\0\0\0\x0f\0\0\0\xb6\x01\0\0\0\0\0\0\x1a\0\0\0\x07\0\0\0\0\0\0\0\0\
+\x95\0\0\0\0\0\0\0\0\0\0\0\x0e\0\0\0\0\0\0\0\x8e\0\0\0\xd3\0\0\0\x05\x48\0\0\
+\x01\0\0\0\x8e\0\0\0\xba\x01\0\0\x02\x50\0\0\x05\0\0\0\x8e\0\0\0\xd3\0\0\0\x05\
+\x48\0\0\x08\0\0\0\x0f\0\0\0\xb6\x01\0\0\0\0\0\0\x1a\0\0\0\x07\0\0\0\0\0\0\0\0\
 \0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x68\x69\
 \x64\x5f\x74\x61\x69\x6c\x5f\x63\x61\x6c\x6c\0\0\0\0\0\0\0\x1a\0\0\0\0\0\0\0\
 \x08\0\0\0\0\0\0\0\0\0\0\0\x01\0\0\0\x10\0\0\0\0\0\0\0\0\0\0\0\x03\0\0\0\x01\0\
 \0\0\0\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x10\0\0\0\0\0\0\0\x5f\
 \x5f\x68\x69\x64\x5f\x62\x70\x66\x5f\x74\x61\x69\x6c\x5f\x63\x61\x6c\x6c\0\0\0\
-\0\0\x47\x50\x4c\0\0\0\0\0\x79\x11\0\0\0\0\0\0\x85\x20\0\0\0\0\0\0\xb7\0\0\0\0\
-\0\0\0\x95\0\0\0\0\0\0\0\0\0\0\0\x18\0\0\0\0\0\0\0\x8e\0\0\0\x23\x02\0\0\x05\
-\x70\0\0\x01\0\0\0\x8e\0\0\0\x65\x02\0\0\x02\x78\0\0\x02\0\0\0\x8e\0\0\0\x23\
-\x02\0\0\x05\x70\0\0\x1a\0\0\0\x04\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
-\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x68\x69\x64\x5f\x62\x70\x66\x5f\x70\
-\x72\x6f\x67\x5f\x70\x75\0\0\0\0\0\x18\0\0\0\0\0\0\0\x08\0\0\0\0\0\0\0\0\0\0\0\
-\x01\0\0\0\x10\0\0\0\0\0\0\0\0\0\0\0\x03\0\0\0\x01\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
-\0\0\0\0\0\0\0\0\0\0\0\0\0\x10\0\0\0\0\0\0\0\x62\x70\x66\x5f\x70\x72\x6f\x67\
-\x5f\x70\x75\x74\x5f\x64\x65\x66\x65\x72\x72\x65\x64\0\0\0\x63\x61\x6c\x6c\x5f\
-\x68\x69\x64\x5f\x62\x70\x66\x5f\x70\x72\x6f\x67\x5f\x70\x75\x74\x5f\x64\x65\
-\x66\x65\x72\x72\x65\x64\0\0";
-	opts.insns_sz = 2056;
+\0\0";
+	opts.insns_sz = 1192;
 	opts.insns = (void *)"\
 \xbf\x16\0\0\0\0\0\0\xbf\xa1\0\0\0\0\0\0\x07\x01\0\0\x78\xff\xff\xff\xb7\x02\0\
-\0\x88\0\0\0\xb7\x03\0\0\0\0\0\0\x85\0\0\0\x71\0\0\0\x05\0\x14\0\0\0\0\0\x61\
+\0\x88\0\0\0\xb7\x03\0\0\0\0\0\0\x85\0\0\0\x71\0\0\0\x05\0\x11\0\0\0\0\0\x61\
 \xa1\x78\xff\0\0\0\0\xd5\x01\x01\0\0\0\0\0\x85\0\0\0\xa8\0\0\0\x61\xa1\x7c\xff\
 \0\0\0\0\xd5\x01\x01\0\0\0\0\0\x85\0\0\0\xa8\0\0\0\x61\xa1\x80\xff\0\0\0\0\xd5\
-\x01\x01\0\0\0\0\0\x85\0\0\0\xa8\0\0\0\x61\xa1\x84\xff\0\0\0\0\xd5\x01\x01\0\0\
-\0\0\0\x85\0\0\0\xa8\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x61\x01\0\0\0\0\
-\0\0\xd5\x01\x02\0\0\0\0\0\xbf\x19\0\0\0\0\0\0\x85\0\0\0\xa8\0\0\0\xbf\x70\0\0\
-\0\0\0\0\x95\0\0\0\0\0\0\0\x61\x60\x08\0\0\0\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\
-\x28\x0c\0\0\x63\x01\0\0\0\0\0\0\x61\x60\x0c\0\0\0\0\0\x18\x61\0\0\0\0\0\0\0\0\
-\0\0\x24\x0c\0\0\x63\x01\0\0\0\0\0\0\x79\x60\x10\0\0\0\0\0\x18\x61\0\0\0\0\0\0\
-\0\0\0\0\x18\x0c\0\0\x7b\x01\0\0\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\0\x05\0\0\
-\x18\x61\0\0\0\0\0\0\0\0\0\0\x10\x0c\0\0\x7b\x01\0\0\0\0\0\0\xb7\x01\0\0\x12\0\
-\0\0\x18\x62\0\0\0\0\0\0\0\0\0\0\x10\x0c\0\0\xb7\x03\0\0\x1c\0\0\0\x85\0\0\0\
-\xa6\0\0\0\xbf\x07\0\0\0\0\0\0\xc5\x07\xd4\xff\0\0\0\0\x63\x7a\x78\xff\0\0\0\0\
-\x61\x60\x1c\0\0\0\0\0\x15\0\x03\0\0\0\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x3c\x0c\
-\0\0\x63\x01\0\0\0\0\0\0\xb7\x01\0\0\0\0\0\0\x18\x62\0\0\0\0\0\0\0\0\0\0\x30\
-\x0c\0\0\xb7\x03\0\0\x48\0\0\0\x85\0\0\0\xa6\0\0\0\xbf\x07\0\0\0\0\0\0\xc5\x07\
-\xc7\xff\0\0\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x63\x71\0\0\0\0\0\0\x18\
-\x60\0\0\0\0\0\0\0\0\0\0\x78\x0c\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x10\x0d\0\0\
-\x7b\x01\0\0\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\x80\x0c\0\0\x18\x61\0\0\0\0\0\
-\0\0\0\0\0\x08\x0d\0\0\x7b\x01\0\0\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\xb8\x0c\
-\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x50\x0d\0\0\x7b\x01\0\0\0\0\0\0\x18\x60\0\0\0\
-\0\0\0\0\0\0\0\xc0\x0c\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x60\x0d\0\0\x7b\x01\0\0\
-\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\xf0\x0c\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\
-\x80\x0d\0\0\x7b\x01\0\0\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x18\x61\0\
-\0\0\0\0\0\0\0\0\0\x78\x0d\0\0\x7b\x01\0\0\0\0\0\0\x61\x60\x08\0\0\0\0\0\x18\
-\x61\0\0\0\0\0\0\0\0\0\0\x18\x0d\0\0\x63\x01\0\0\0\0\0\0\x61\x60\x0c\0\0\0\0\0\
-\x18\x61\0\0\0\0\0\0\0\0\0\0\x1c\x0d\0\0\x63\x01\0\0\0\0\0\0\x79\x60\x10\0\0\0\
-\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x20\x0d\0\0\x7b\x01\0\0\0\0\0\0\x61\xa0\x78\
-\xff\0\0\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x48\x0d\0\0\x63\x01\0\0\0\0\0\0\x18\
-\x61\0\0\0\0\0\0\0\0\0\0\x90\x0d\0\0\xb7\x02\0\0\x14\0\0\0\xb7\x03\0\0\x0c\0\0\
-\0\xb7\x04\0\0\0\0\0\0\x85\0\0\0\xa7\0\0\0\xbf\x07\0\0\0\0\0\0\xc5\x07\x8e\xff\
-\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\0\x0d\0\0\x63\x70\x6c\0\0\0\0\0\x77\x07\0\
-\0\x20\0\0\0\x63\x70\x70\0\0\0\0\0\xb7\x01\0\0\x05\0\0\0\x18\x62\0\0\0\0\0\0\0\
-\0\0\0\0\x0d\0\0\xb7\x03\0\0\x8c\0\0\0\x85\0\0\0\xa6\0\0\0\xbf\x07\0\0\0\0\0\0\
-\x18\x60\0\0\0\0\0\0\0\0\0\0\x70\x0d\0\0\x61\x01\0\0\0\0\0\0\xd5\x01\x02\0\0\0\
-\0\0\xbf\x19\0\0\0\0\0\0\x85\0\0\0\xa8\0\0\0\xc5\x07\x7c\xff\0\0\0\0\x63\x7a\
-\x80\xff\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\xa8\x0d\0\0\x18\x61\0\0\0\0\0\0\0\
-\0\0\0\x18\x0e\0\0\x7b\x01\0\0\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\xb0\x0d\0\0\
-\x18\x61\0\0\0\0\0\0\0\0\0\0\x10\x0e\0\0\x7b\x01\0\0\0\0\0\0\x18\x60\0\0\0\0\0\
-\0\0\0\0\0\xd0\x0d\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x58\x0e\0\0\x7b\x01\0\0\0\0\
-\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\xd8\x0d\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x68\
-\x0e\0\0\x7b\x01\0\0\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\x08\x0e\0\0\x18\x61\0\
-\0\0\0\0\0\0\0\0\0\x88\x0e\0\0\x7b\x01\0\0\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\
-\0\0\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x80\x0e\0\0\x7b\x01\0\0\0\0\0\0\x61\x60\
-\x08\0\0\0\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x20\x0e\0\0\x63\x01\0\0\0\0\0\0\x61\
-\x60\x0c\0\0\0\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x24\x0e\0\0\x63\x01\0\0\0\0\0\0\
-\x79\x60\x10\0\0\0\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x28\x0e\0\0\x7b\x01\0\0\0\0\
-\0\0\x61\xa0\x78\xff\0\0\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x50\x0e\0\0\x63\x01\0\
-\0\0\0\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x98\x0e\0\0\xb7\x02\0\0\x16\0\0\0\xb7\
-\x03\0\0\x0c\0\0\0\xb7\x04\0\0\0\0\0\0\x85\0\0\0\xa7\0\0\0\xbf\x07\0\0\0\0\0\0\
-\xc5\x07\x45\xff\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\x08\x0e\0\0\x63\x70\x6c\0\
-\0\0\0\0\x77\x07\0\0\x20\0\0\0\x63\x70\x70\0\0\0\0\0\x18\x68\0\0\0\0\0\0\0\0\0\
-\0\xb8\x0d\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\xb0\x0e\0\0\xb7\x02\0\0\x1f\0\0\0\
-\xb7\x03\0\0\x0c\0\0\0\xb7\x04\0\0\0\0\0\0\x85\0\0\0\xa7\0\0\0\xbf\x07\0\0\0\0\
-\0\0\xc5\x07\x36\xff\0\0\0\0\x75\x07\x03\0\0\0\0\0\x62\x08\x04\0\0\0\0\0\x6a\
-\x08\x02\0\0\0\0\0\x05\0\x0a\0\0\0\0\0\x63\x78\x04\0\0\0\0\0\xbf\x79\0\0\0\0\0\
-\0\x77\x09\0\0\x20\0\0\0\x55\x09\x02\0\0\0\0\0\x6a\x08\x02\0\0\0\0\0\x05\0\x04\
-\0\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\0\x01\0\0\x63\x90\0\0\0\0\0\0\x6a\x08\
-\x02\0\x40\0\0\0\xb7\x01\0\0\x05\0\0\0\x18\x62\0\0\0\0\0\0\0\0\0\0\x08\x0e\0\0\
-\xb7\x03\0\0\x8c\0\0\0\x85\0\0\0\xa6\0\0\0\xbf\x07\0\0\0\0\0\0\x18\x60\0\0\0\0\
-\0\0\0\0\0\0\0\x01\0\0\x61\x01\0\0\0\0\0\0\xd5\x01\x02\0\0\0\0\0\xbf\x19\0\0\0\
-\0\0\0\x85\0\0\0\xa8\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\x78\x0e\0\0\x61\x01\0\0\
-\0\0\0\0\xd5\x01\x02\0\0\0\0\0\xbf\x19\0\0\0\0\0\0\x85\0\0\0\xa8\0\0\0\xc5\x07\
-\x15\xff\0\0\0\0\x63\x7a\x84\xff\0\0\0\0\x61\xa1\x78\xff\0\0\0\0\xd5\x01\x02\0\
-\0\0\0\0\xbf\x19\0\0\0\0\0\0\x85\0\0\0\xa8\0\0\0\x61\xa0\x80\xff\0\0\0\0\x63\
-\x06\x28\0\0\0\0\0\x61\xa0\x84\xff\0\0\0\0\x63\x06\x2c\0\0\0\0\0\x18\x61\0\0\0\
-\0\0\0\0\0\0\0\0\0\0\0\x61\x10\0\0\0\0\0\0\x63\x06\x18\0\0\0\0\0\xb7\0\0\0\0\0\
-\0\0\x95\0\0\0\0\0\0\0";
+\x01\x01\0\0\0\0\0\x85\0\0\0\xa8\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x61\
+\x01\0\0\0\0\0\0\xd5\x01\x02\0\0\0\0\0\xbf\x19\0\0\0\0\0\0\x85\0\0\0\xa8\0\0\0\
+\xbf\x70\0\0\0\0\0\0\x95\0\0\0\0\0\0\0\x61\x60\x08\0\0\0\0\0\x18\x61\0\0\0\0\0\
+\0\0\0\0\0\xa8\x09\0\0\x63\x01\0\0\0\0\0\0\x61\x60\x0c\0\0\0\0\0\x18\x61\0\0\0\
+\0\0\0\0\0\0\0\xa4\x09\0\0\x63\x01\0\0\0\0\0\0\x79\x60\x10\0\0\0\0\0\x18\x61\0\
+\0\0\0\0\0\0\0\0\0\x98\x09\0\0\x7b\x01\0\0\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\
+\0\x05\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x90\x09\0\0\x7b\x01\0\0\0\0\0\0\xb7\x01\
+\0\0\x12\0\0\0\x18\x62\0\0\0\0\0\0\0\0\0\0\x90\x09\0\0\xb7\x03\0\0\x1c\0\0\0\
+\x85\0\0\0\xa6\0\0\0\xbf\x07\0\0\0\0\0\0\xc5\x07\xd7\xff\0\0\0\0\x63\x7a\x78\
+\xff\0\0\0\0\x61\x60\x1c\0\0\0\0\0\x15\0\x03\0\0\0\0\0\x18\x61\0\0\0\0\0\0\0\0\
+\0\0\xbc\x09\0\0\x63\x01\0\0\0\0\0\0\xb7\x01\0\0\0\0\0\0\x18\x62\0\0\0\0\0\0\0\
+\0\0\0\xb0\x09\0\0\xb7\x03\0\0\x48\0\0\0\x85\0\0\0\xa6\0\0\0\xbf\x07\0\0\0\0\0\
+\0\xc5\x07\xca\xff\0\0\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x63\x71\0\0\0\0\
+\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\xf8\x09\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x90\
+\x0a\0\0\x7b\x01\0\0\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\0\x0a\0\0\x18\x61\0\0\
+\0\0\0\0\0\0\0\0\x88\x0a\0\0\x7b\x01\0\0\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\
+\x38\x0a\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\xd0\x0a\0\0\x7b\x01\0\0\0\0\0\0\x18\
+\x60\0\0\0\0\0\0\0\0\0\0\x40\x0a\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\xe0\x0a\0\0\
+\x7b\x01\0\0\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\x70\x0a\0\0\x18\x61\0\0\0\0\0\
+\0\0\0\0\0\0\x0b\0\0\x7b\x01\0\0\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\0\0\0\0\
+\x18\x61\0\0\0\0\0\0\0\0\0\0\xf8\x0a\0\0\x7b\x01\0\0\0\0\0\0\x61\x60\x08\0\0\0\
+\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x98\x0a\0\0\x63\x01\0\0\0\0\0\0\x61\x60\x0c\0\
+\0\0\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x9c\x0a\0\0\x63\x01\0\0\0\0\0\0\x79\x60\
+\x10\0\0\0\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\xa0\x0a\0\0\x7b\x01\0\0\0\0\0\0\x61\
+\xa0\x78\xff\0\0\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\xc8\x0a\0\0\x63\x01\0\0\0\0\0\
+\0\x18\x61\0\0\0\0\0\0\0\0\0\0\x10\x0b\0\0\xb7\x02\0\0\x14\0\0\0\xb7\x03\0\0\
+\x0c\0\0\0\xb7\x04\0\0\0\0\0\0\x85\0\0\0\xa7\0\0\0\xbf\x07\0\0\0\0\0\0\xc5\x07\
+\x91\xff\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\x80\x0a\0\0\x63\x70\x6c\0\0\0\0\0\
+\x77\x07\0\0\x20\0\0\0\x63\x70\x70\0\0\0\0\0\xb7\x01\0\0\x05\0\0\0\x18\x62\0\0\
+\0\0\0\0\0\0\0\0\x80\x0a\0\0\xb7\x03\0\0\x8c\0\0\0\x85\0\0\0\xa6\0\0\0\xbf\x07\
+\0\0\0\0\0\0\x18\x60\0\0\0\0\0\0\0\0\0\0\xf0\x0a\0\0\x61\x01\0\0\0\0\0\0\xd5\
+\x01\x02\0\0\0\0\0\xbf\x19\0\0\0\0\0\0\x85\0\0\0\xa8\0\0\0\xc5\x07\x7f\xff\0\0\
+\0\0\x63\x7a\x80\xff\0\0\0\0\x61\xa1\x78\xff\0\0\0\0\xd5\x01\x02\0\0\0\0\0\xbf\
+\x19\0\0\0\0\0\0\x85\0\0\0\xa8\0\0\0\x61\xa0\x80\xff\0\0\0\0\x63\x06\x28\0\0\0\
+\0\0\x18\x61\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x61\x10\0\0\0\0\0\0\x63\x06\x18\0\0\0\
+\0\0\xb7\0\0\0\0\0\0\0\x95\0\0\0\0\0\0\0";
 	err = bpf_load_and_run(&opts);
 	if (err < 0)
 		return err;
diff --git a/drivers/hid/bpf/hid_bpf_dispatch.c b/drivers/hid/bpf/hid_bpf_dispatch.c
index 8d29fd361ab9..26117b4ec016 100644
--- a/drivers/hid/bpf/hid_bpf_dispatch.c
+++ b/drivers/hid/bpf/hid_bpf_dispatch.c
@@ -173,7 +173,6 @@ hid_bpf_get_data(struct hid_bpf_ctx *ctx, unsigned int offset, const size_t rdwr
  * can use.
  */
 BTF_SET8_START(hid_bpf_kfunc_ids)
-BTF_ID_FLAGS(func, call_hid_bpf_prog_put_deferred)
 BTF_ID_FLAGS(func, hid_bpf_get_data, KF_RET_NULL)
 BTF_SET8_END(hid_bpf_kfunc_ids)
 
diff --git a/drivers/hid/bpf/hid_bpf_dispatch.h b/drivers/hid/bpf/hid_bpf_dispatch.h
index 2eeab1f746dd..63dfc8605cd2 100644
--- a/drivers/hid/bpf/hid_bpf_dispatch.h
+++ b/drivers/hid/bpf/hid_bpf_dispatch.h
@@ -22,7 +22,4 @@ int hid_bpf_reconnect(struct hid_device *hdev);
 
 struct bpf_prog;
 
-/* HID-BPF internal kfuncs API */
-void call_hid_bpf_prog_put_deferred(struct work_struct *work);
-
 #endif
-- 
2.38.1

