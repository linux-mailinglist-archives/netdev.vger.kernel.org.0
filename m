Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54044CDAF9
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 18:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241331AbiCDRgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 12:36:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241341AbiCDRgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 12:36:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0150A1D3DB0
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 09:34:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646415287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G/shJm1MeQ7S0DudVE/fEwfDM0MCEACLr6XHTMqvVM4=;
        b=VkXjanbAdVzsCIfdUK4xdjZU5/vIe0OAzr+P+2YeInQRR5PvbFXYPgsScHKu1iXuZbJoGF
        byJDBassDkOM5NVT65KP2EYzDv/HzcCV57UKvKaxbYITN/b9K5LN8itw26cyYVjMYywkiB
        i/uKt2uGEPxMM3AFS/bi2KFVKO+KVWw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-451-GhrcENtyOjS9MMXFgSLOeQ-1; Fri, 04 Mar 2022 12:34:41 -0500
X-MC-Unique: GhrcENtyOjS9MMXFgSLOeQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E877E824FA8;
        Fri,  4 Mar 2022 17:34:38 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA81886595;
        Fri,  4 Mar 2022 17:34:34 +0000 (UTC)
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
Subject: [PATCH bpf-next v2 25/28] bpf/hid: Add a flag to add the program at the beginning of the list
Date:   Fri,  4 Mar 2022 18:28:49 +0100
Message-Id: <20220304172852.274126-26-benjamin.tissoires@redhat.com>
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

When tracing the incoming events, if a bpf program is already loaded,
the next bpf program will see the potentially changed data.

Add a flag to BPF_LINK_CREATE that allows to chose the position of the
inserted program: at the beginning or at the end.

This way, we can have a tracing program that compare the raw event from
the device and the transformed stream from all the other bpf programs.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

new in v2
---
 include/uapi/linux/bpf.h | 10 ++++++++++
 kernel/bpf/hid.c         | 11 +++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 417cf1c31579..23ebe5e96d69 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
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
diff --git a/kernel/bpf/hid.c b/kernel/bpf/hid.c
index b3dc1cd37a3e..141eb4169079 100644
--- a/kernel/bpf/hid.c
+++ b/kernel/bpf/hid.c
@@ -416,7 +416,7 @@ static int bpf_hid_max_progs(enum bpf_hid_attach_type type)
 }
 
 static int bpf_hid_link_attach(struct hid_device *hdev, struct bpf_link *link,
-			       enum bpf_hid_attach_type type)
+			       enum bpf_hid_attach_type type, u32 flags)
 {
 	struct bpf_hid_link *hid_link =
 		container_of(link, struct bpf_hid_link, link);
@@ -443,7 +443,10 @@ static int bpf_hid_link_attach(struct hid_device *hdev, struct bpf_link *link,
 		goto out_unlock;
 	}
 
-	list_add_tail(&hid_link->node, &hdev->bpf.links[type]);
+	if (flags & BPF_F_INSERT_HEAD)
+		list_add(&hid_link->node, &hdev->bpf.links[type]);
+	else
+		list_add_tail(&hid_link->node, &hdev->bpf.links[type]);
 
 	fill_prog_array(hdev, type, run_array);
 	run_array = rcu_replace_pointer(hdev->bpf.run_array[type], run_array,
@@ -467,7 +470,7 @@ int bpf_hid_link_create(const union bpf_attr *attr, struct bpf_prog *prog)
 	struct hid_device *hdev;
 	int err;
 
-	if (attr->link_create.flags || !hid_hooks.hdev_from_fd)
+	if ((attr->link_create.flags & ~BPF_F_INSERT_HEAD) || !hid_hooks.hdev_from_fd)
 		return -EINVAL;
 
 	type = attr->link_create.attach_type;
@@ -495,7 +498,7 @@ int bpf_hid_link_create(const union bpf_attr *attr, struct bpf_prog *prog)
 		return err;
 	}
 
-	err = bpf_hid_link_attach(hdev, &hid_link->link, hid_type);
+	err = bpf_hid_link_attach(hdev, &hid_link->link, hid_type, attr->link_create.flags);
 	if (err) {
 		bpf_link_cleanup(&link_primer);
 		return err;
-- 
2.35.1

