Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46A634CDA9D
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 18:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241114AbiCDRdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 12:33:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbiCDRck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 12:32:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 947521D084E
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 09:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646415108;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=63XOkucXPoA9BHtkIxmyyJJF1thlmZZsP4rRoHSnHtU=;
        b=YAUWPZQ/5TceItxSJPloCNljtvMwFRwvQeJLIxrdc1N/U6vUIQwZqcE156EVXKaVMkxFoS
        ABqL6XNmibqEqlrJRVnBboS4bsJ87STUabtFcyQtQ6oqeMV3U+MGYL6rucWokDfKkAvh0r
        jomePCRjC8w4LQVnpNnIVkjLPvAUs98=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-kbUcF6rtML6PKyFbOs9qiw-1; Fri, 04 Mar 2022 12:31:43 -0500
X-MC-Unique: kbUcF6rtML6PKyFbOs9qiw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 25CE618766D2;
        Fri,  4 Mar 2022 17:31:40 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F6C286595;
        Fri,  4 Mar 2022 17:31:15 +0000 (UTC)
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
Subject: [PATCH bpf-next v2 07/28] bpf/hid: add a new attach type to change the report descriptor
Date:   Fri,  4 Mar 2022 18:28:31 +0100
Message-Id: <20220304172852.274126-8-benjamin.tissoires@redhat.com>
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

The report descriptor is the dictionary of the HID protocol specific
to the given device.
Changing it is a common habit in the HID world, and making that feature
accessible from eBPF allows to fix devices without having to install a
new kernel.

However, the report descriptor is supposed to be static on a device.
To be able to change it, we need to reconnect the device at the HID
level.
So whenever the report descriptor program type is attached or detached,
we call on a hook on HID to notify it that there is something to be
done.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v2:
- split the series by bpf/libbpf/hid/selftests and samples
- unsigned long -> __u16 in uapi/linux/bpf_hid.h
---
 include/linux/bpf-hid.h        | 4 ++++
 include/uapi/linux/bpf.h       | 1 +
 include/uapi/linux/bpf_hid.h   | 1 +
 kernel/bpf/hid.c               | 5 +++++
 kernel/bpf/syscall.c           | 2 ++
 tools/include/uapi/linux/bpf.h | 1 +
 6 files changed, 14 insertions(+)

diff --git a/include/linux/bpf-hid.h b/include/linux/bpf-hid.h
index 3cda78051b5f..0c5000b28b20 100644
--- a/include/linux/bpf-hid.h
+++ b/include/linux/bpf-hid.h
@@ -15,6 +15,7 @@ struct hid_device;
 enum bpf_hid_attach_type {
 	BPF_HID_ATTACH_INVALID = -1,
 	BPF_HID_ATTACH_DEVICE_EVENT = 0,
+	BPF_HID_ATTACH_RDESC_FIXUP,
 	MAX_BPF_HID_ATTACH_TYPE
 };
 
@@ -32,6 +33,8 @@ to_bpf_hid_attach_type(enum bpf_attach_type attach_type)
 	switch (attach_type) {
 	case BPF_HID_DEVICE_EVENT:
 		return BPF_HID_ATTACH_DEVICE_EVENT;
+	case BPF_HID_RDESC_FIXUP:
+		return BPF_HID_ATTACH_RDESC_FIXUP;
 	default:
 		return BPF_HID_ATTACH_INVALID;
 	}
@@ -88,6 +91,7 @@ static inline bool bpf_hid_link_empty(struct bpf_hid *bpf,
 struct bpf_hid_hooks {
 	struct hid_device *(*hdev_from_fd)(int fd);
 	int (*link_attach)(struct hid_device *hdev, enum bpf_hid_attach_type type);
+	void (*link_attached)(struct hid_device *hdev, enum bpf_hid_attach_type type);
 	void (*array_detached)(struct hid_device *hdev, enum bpf_hid_attach_type type);
 };
 
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 5978b92cacd3..a7a8d9cfcf24 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -999,6 +999,7 @@ enum bpf_attach_type {
 	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	BPF_PERF_EVENT,
 	BPF_HID_DEVICE_EVENT,
+	BPF_HID_RDESC_FIXUP,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/include/uapi/linux/bpf_hid.h b/include/uapi/linux/bpf_hid.h
index 975ca5bd526f..634f17c0b1cb 100644
--- a/include/uapi/linux/bpf_hid.h
+++ b/include/uapi/linux/bpf_hid.h
@@ -24,6 +24,7 @@ struct hid_device;
 enum hid_bpf_event {
 	HID_BPF_UNDEF = 0,
 	HID_BPF_DEVICE_EVENT,		/* when attach type is BPF_HID_DEVICE_EVENT */
+	HID_BPF_RDESC_FIXUP,		/* ................... BPF_HID_RDESC_FIXUP */
 };
 
 struct hid_bpf_ctx {
diff --git a/kernel/bpf/hid.c b/kernel/bpf/hid.c
index db7f75a0a812..37500313e270 100644
--- a/kernel/bpf/hid.c
+++ b/kernel/bpf/hid.c
@@ -315,6 +315,8 @@ static int bpf_hid_max_progs(enum bpf_hid_attach_type type)
 	switch (type) {
 	case BPF_HID_ATTACH_DEVICE_EVENT:
 		return 64;
+	case BPF_HID_ATTACH_RDESC_FIXUP:
+		return 1;
 	default:
 		return 0;
 	}
@@ -355,6 +357,9 @@ static int bpf_hid_link_attach(struct hid_device *hdev, struct bpf_link *link,
 					lockdep_is_held(&bpf_hid_mutex));
 	bpf_prog_array_free(run_array);
 
+	if (hid_hooks.link_attached)
+		hid_hooks.link_attached(hdev, type);
+
 out_unlock:
 	mutex_unlock(&bpf_hid_mutex);
 	return err;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index a94e78ec3211..7428a1a512c6 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3203,6 +3203,7 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
 	case BPF_XDP:
 		return BPF_PROG_TYPE_XDP;
 	case BPF_HID_DEVICE_EVENT:
+	case BPF_HID_RDESC_FIXUP:
 		return BPF_PROG_TYPE_HID;
 	default:
 		return BPF_PROG_TYPE_UNSPEC;
@@ -3348,6 +3349,7 @@ static int bpf_prog_query(const union bpf_attr *attr,
 	case BPF_SK_SKB_VERDICT:
 		return sock_map_bpf_prog_query(attr, uattr);
 	case BPF_HID_DEVICE_EVENT:
+	case BPF_HID_RDESC_FIXUP:
 		return bpf_hid_prog_query(attr, uattr);
 	default:
 		return -EINVAL;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 5978b92cacd3..a7a8d9cfcf24 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -999,6 +999,7 @@ enum bpf_attach_type {
 	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	BPF_PERF_EVENT,
 	BPF_HID_DEVICE_EVENT,
+	BPF_HID_RDESC_FIXUP,
 	__MAX_BPF_ATTACH_TYPE
 };
 
-- 
2.35.1

