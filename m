Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23E9011BFEA
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 23:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbfLKWer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 17:34:47 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:50874 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727118AbfLKWeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 17:34:44 -0500
Received: by mail-pl1-f202.google.com with SMTP id s4so188857plp.17
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 14:34:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lQpyK5Eg7lGx+o3sbDMKqWXZbBnjtobMbtVvJLV8vuU=;
        b=i6KUnPrg8wS8fz1OC/0FVlYjiKjXkPYU2ZAHAZqB4Kmj5Oa3h1CHwnILOk3hE97Auq
         yTVD2FtQL7GPkCAp3bU5NTy5AAYCPRjxRRLnBeI7nrHwYzYOOTj5hxX+lTPOzSW0yLLK
         SHABMziL+UoyOWehbOiYQRz7zzcY9P1ItJLZXrx3cdiFnW3FTVtwlNks6rCnlF2VUCE4
         LNZqp9hdmkSYTRSPO/w2VCySJAK+vOLKfFr23i8p3gnhRrz7uOAcro2a2YD1CvuwgUSj
         dZW9ZXNcOUTBFSKyA8yQMnip0xj9M07c7/NCe4rNhYTQF6k2aJ4BxRN0wbDu4xolfAaK
         qTTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lQpyK5Eg7lGx+o3sbDMKqWXZbBnjtobMbtVvJLV8vuU=;
        b=VhPjCA1ue0ptBRsQ2T7BTn8tjJV9TUk3WXz4SSmNYQl9g6f7dJWE4LQvHV7g3FrOxD
         iksHGPdb+ukUivkabJ7xrhbDCq7syFuxn9Ov1YIph/yUTgRcwkRr4v+Ej0KUpdNRLEvq
         Ewl8RWaxSdfcAHL8srPbOPiJpcr+auz40mFGBvnXfd2GabHB4C4LWqAQgN8PL+s3ebiU
         W5oeV5cxDpEtIHICjkEQKE0OiBUtOemyZ/ucW8uGL5VXoQ3LZDiz7l1tHDsT06nA4xBh
         btQWAWUj+RQGRD9jjWCVD8l3/AO0VS24Ms8MvKMSXxyWv6qpjOMeXOIbO8k9mJQ8/LWA
         ay7w==
X-Gm-Message-State: APjAAAXGYmFzW1MnQqEYiTIuj3IRnajHrQxKCjgv9wW86BF0yTngHRIL
        XRO9hUM0uRVDQfEhYykmJwTFoFxSN4Y0
X-Google-Smtp-Source: APXvYqyHtnoT9365ymVLlNBXEyHx74N+sr782SWuwTl1pDv4J6R0GdMSpVLwYZH0dkSCgSaY+jh5QQmING+u
X-Received: by 2002:a63:197:: with SMTP id 145mr6915703pgb.11.1576103683551;
 Wed, 11 Dec 2019 14:34:43 -0800 (PST)
Date:   Wed, 11 Dec 2019 14:33:41 -0800
In-Reply-To: <20191211223344.165549-1-brianvv@google.com>
Message-Id: <20191211223344.165549-9-brianvv@google.com>
Mime-Version: 1.0
References: <20191211223344.165549-1-brianvv@google.com>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH v3 bpf-next 08/11] libbpf: add libbpf support to batch ops
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Yonghong Song <yhs@fb.com>, Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

Added four libbpf API functions to support map batch operations:
  . int bpf_map_delete_batch( ... )
  . int bpf_map_lookup_batch( ... )
  . int bpf_map_lookup_and_delete_batch( ... )
  . int bpf_map_update_batch( ... )

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/lib/bpf/bpf.c      | 61 ++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/bpf.h      | 14 +++++++++
 tools/lib/bpf/libbpf.map |  4 +++
 3 files changed, 79 insertions(+)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 98596e15390fb..933a36a33d5a0 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -443,6 +443,67 @@ int bpf_map_freeze(int fd)
 	return sys_bpf(BPF_MAP_FREEZE, &attr, sizeof(attr));
 }
 
+static int bpf_map_batch_common(int cmd, int fd, void  *in_batch,
+				void *out_batch, void *keys, void *values,
+				__u32 *count, __u64 elem_flags,
+				__u64 flags)
+{
+	union bpf_attr attr = {};
+	int ret;
+
+	memset(&attr, 0, sizeof(attr));
+	attr.batch.map_fd = fd;
+	attr.batch.in_batch = ptr_to_u64(in_batch);
+	attr.batch.out_batch = ptr_to_u64(out_batch);
+	attr.batch.keys = ptr_to_u64(keys);
+	attr.batch.values = ptr_to_u64(values);
+	if (count)
+		attr.batch.count = *count;
+	attr.batch.elem_flags = elem_flags;
+	attr.batch.flags = flags;
+
+	ret = sys_bpf(cmd, &attr, sizeof(attr));
+	if (count)
+		*count = attr.batch.count;
+
+	return ret;
+}
+
+int bpf_map_delete_batch(int fd, void *keys, __u32 *count,
+			 __u64 elem_flags, __u64 flags)
+{
+	return bpf_map_batch_common(BPF_MAP_DELETE_BATCH, fd, NULL,
+				    NULL, keys, NULL, count,
+				    elem_flags, flags);
+}
+
+int bpf_map_lookup_batch(int fd, void *in_batch, void *out_batch, void *keys,
+			 void *values, __u32 *count,
+			 __u64 elem_flags, __u64 flags)
+{
+	return bpf_map_batch_common(BPF_MAP_LOOKUP_BATCH, fd, in_batch,
+				    out_batch, keys, values, count,
+				    elem_flags, flags);
+}
+
+int bpf_map_lookup_and_delete_batch(int fd, void *in_batch, void *out_batch,
+				    void *keys, void *values,
+				    __u32 *count, __u64 elem_flags,
+				    __u64 flags)
+{
+	return bpf_map_batch_common(BPF_MAP_LOOKUP_AND_DELETE_BATCH,
+				    fd, in_batch, out_batch, keys, values,
+				    count, elem_flags, flags);
+}
+
+int bpf_map_update_batch(int fd, void *keys, void *values, __u32 *count,
+			 __u64 elem_flags, __u64 flags)
+{
+	return bpf_map_batch_common(BPF_MAP_UPDATE_BATCH,
+				    fd, NULL, NULL, keys, values,
+				    count, elem_flags, flags);
+}
+
 int bpf_obj_pin(int fd, const char *pathname)
 {
 	union bpf_attr attr;
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 3c791fa8e68e8..51c577393ec48 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -126,6 +126,20 @@ LIBBPF_API int bpf_map_lookup_and_delete_elem(int fd, const void *key,
 LIBBPF_API int bpf_map_delete_elem(int fd, const void *key);
 LIBBPF_API int bpf_map_get_next_key(int fd, const void *key, void *next_key);
 LIBBPF_API int bpf_map_freeze(int fd);
+LIBBPF_API int bpf_map_delete_batch(int fd, void *keys,
+				    __u32 *count, __u64 elem_flags,
+				    __u64 flags);
+LIBBPF_API int bpf_map_lookup_batch(int fd, void *in_batch, void *out_batch,
+				    void *keys, void *values, __u32 *count,
+				    __u64 elem_flags, __u64 flags);
+LIBBPF_API int bpf_map_lookup_and_delete_batch(int fd, void *in_batch,
+					       void *out_batch, void *keys,
+					       void *values, __u32 *count,
+					       __u64 elem_flags, __u64 flags);
+LIBBPF_API int bpf_map_update_batch(int fd, void *keys, void *values,
+				    __u32 *count, __u64 elem_flags,
+				    __u64 flags);
+
 LIBBPF_API int bpf_obj_pin(int fd, const char *pathname);
 LIBBPF_API int bpf_obj_get(const char *pathname);
 LIBBPF_API int bpf_prog_attach(int prog_fd, int attachable_fd,
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 495df575f87f8..4efbf25888eb0 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -210,4 +210,8 @@ LIBBPF_0.0.6 {
 } LIBBPF_0.0.5;
 
 LIBBPF_0.0.7 {
+		bpf_map_delete_batch;
+		bpf_map_lookup_and_delete_batch;
+		bpf_map_lookup_batch;
+		bpf_map_update_batch;
 } LIBBPF_0.0.6;
-- 
2.24.1.735.g03f4e72817-goog

