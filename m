Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C587B8EEE4
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 17:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733292AbfHOPAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 11:00:34 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34710 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733284AbfHOPAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 11:00:33 -0400
Received: by mail-wr1-f65.google.com with SMTP id s18so1727412wrn.1
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 08:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SHpZ4QmRLvu5QStiFloxnaEe5T1qWZxwzosx1ZcjyYQ=;
        b=ukoAf53Bsy/bOcsJFxcxJcpKiJcYp8IjD4tGnpHtoyKbikXDc1NDu7Xe0OOOL2jNwv
         S8hNlQMCAq4e4PoCYUKpgkQ6XYS0sGGMqcrfnG43cAagfG704+30EVb/MDWfFU2ZWP6B
         /3CpEyQxc279pqVZp1tFuF7M7ckS4OD1psI6aQAmsCCh5YUvdRY+GdX5C54FUi5yzMnu
         3KzkfKVDC+LvgB+FNdO55gkzbSjuxXkkpWKKpI4/LvGDuRunQCxxPTW/LiRGUZSzcvNb
         i9hRcmNoOd8wfVvKhMGmn0wHYojfPB++B7R6ZOmUXbxD6Nt7p8vwGZvO8Ps72w0IpQrb
         gvkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SHpZ4QmRLvu5QStiFloxnaEe5T1qWZxwzosx1ZcjyYQ=;
        b=K/ZXXRj13zhRSqtX07KWyrHaGxo//ymDsHT3usehx0RAu0zIYuQRh67YPU3lq0zznP
         AQmDnB0myFHzohXHSrZVJm56IWFlWb6+onKrXcJ3XYFgaCOxWPvQPV9gq8/lL6OXzkhL
         OsCmSgwg40lJ2Z9s5m3BZkQZOJQYXme98jTlmyn6bIF8uJp6xQF4msDmf/4JTcPhrwC8
         yYg/TwWETKKEKUevi3ujfGLVe+1m+9j037+9zkE7N/DGrmaHntjzWpxFQXwkZRb7/jmw
         jHzcwnQzgnHllkWAnXcNjSXcCX6Fi/K/myeFrvIxrb0+HksUq4BBFS9ZFsdGOEpqZBfj
         GMVA==
X-Gm-Message-State: APjAAAWuaNroHz7wE+J3qLgyjKOBMZJFD2fWPLtpNg0ziCMdhjTJKYjh
        BVLhTM8/wcf/msBAjTbkiH97Rg==
X-Google-Smtp-Source: APXvYqxwWiUAz+0j8qKwd6syVgnRK/tsO398dvNffHeLQE33E6k5hiddUP3gLIUPM/g/BuOqPcM4tA==
X-Received: by 2002:a5d:6a49:: with SMTP id t9mr5993705wrw.134.1565881231378;
        Thu, 15 Aug 2019 08:00:31 -0700 (PDT)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id a23sm2794857wma.24.2019.08.15.08.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 08:00:30 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH bpf-next 1/5] bpf: add new BPF_BTF_GET_NEXT_ID syscall command
Date:   Thu, 15 Aug 2019 16:00:15 +0100
Message-Id: <20190815150019.8523-2-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815150019.8523-1-quentin.monnet@netronome.com>
References: <20190815150019.8523-1-quentin.monnet@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new command for the bpf() system call: BPF_BTF_GET_NEXT_ID is used
to cycle through all BTF objects loaded on the system.

The motivation is to be able to inspect (list) all BTF objects presents
on the system.

Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 include/linux/bpf.h      | 3 +++
 include/uapi/linux/bpf.h | 1 +
 kernel/bpf/btf.c         | 4 ++--
 kernel/bpf/syscall.c     | 4 ++++
 4 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f9a506147c8a..279ea762c34e 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -24,6 +24,9 @@ struct seq_file;
 struct btf;
 struct btf_type;
 
+extern struct idr btf_idr;
+extern spinlock_t btf_idr_lock;
+
 /* map is generic key/value storage optionally accesible by eBPF programs */
 struct bpf_map_ops {
 	/* funcs callable from userspace (via syscall) */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4393bd4b2419..874bc5eefee1 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -106,6 +106,7 @@ enum bpf_cmd {
 	BPF_TASK_FD_QUERY,
 	BPF_MAP_LOOKUP_AND_DELETE_ELEM,
 	BPF_MAP_FREEZE,
+	BPF_BTF_GET_NEXT_ID,
 };
 
 enum bpf_map_type {
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 5fcc7a17eb5a..e716a64b2f7f 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -195,8 +195,8 @@
 	     i < btf_type_vlen(struct_type);					\
 	     i++, member++)
 
-static DEFINE_IDR(btf_idr);
-static DEFINE_SPINLOCK(btf_idr_lock);
+DEFINE_IDR(btf_idr);
+DEFINE_SPINLOCK(btf_idr_lock);
 
 struct btf {
 	void *data;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 5d141f16f6fa..407b7f840874 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2874,6 +2874,10 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 		err = bpf_obj_get_next_id(&attr, uattr,
 					  &map_idr, &map_idr_lock);
 		break;
+	case BPF_BTF_GET_NEXT_ID:
+		err = bpf_obj_get_next_id(&attr, uattr,
+					  &btf_idr, &btf_idr_lock);
+		break;
 	case BPF_PROG_GET_FD_BY_ID:
 		err = bpf_prog_get_fd_by_id(&attr);
 		break;
-- 
2.17.1

