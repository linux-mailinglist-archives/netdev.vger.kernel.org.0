Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 264F64883CE
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 14:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234338AbiAHNqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 08:46:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiAHNqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 08:46:36 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4DFC061574;
        Sat,  8 Jan 2022 05:46:36 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id f5so8249772pgk.12;
        Sat, 08 Jan 2022 05:46:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LdhsOz/TVy+7sBqNrF7zmiF6jDZHeuAcusWoEon0Rs0=;
        b=mGEH1h/el6gtMlL+pAu6ho3wsXocQd5URdEvK6ZK7SzyVX+lOgnru1bR/aFzToROcx
         //RQ4kKGwIkKRmlgsuTHQ9mhtLFB+4WAWoTHIDFsi5DB4mcuqoRfBlxSRYYwvil+ubdE
         Zjuf2KecH1Miyd6CKEMwZnlNFqmM8qzHmVjqAjiq+6+qa5MwG9CIn0XPScupHqe0eDtl
         pLSHFxlwTv0fDQnQLYGyJyc1n22c9X6EvDhZLsZHvtbQP/S7tb24lrp1vinBvh8djfC/
         +z6O7qfEA39rwnLn7lKrGsiugIzoPArcGOLrQcQSH/bT6kijf2CU6isseijXv7OJLdtF
         HHVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LdhsOz/TVy+7sBqNrF7zmiF6jDZHeuAcusWoEon0Rs0=;
        b=brwYTeuqxc+W49qWsl0CcloX/giFG+QjZczIPpa/fT0ahPyjbKFg5F9IL8ETCeMYvo
         DI7WB/HILaB6nFwkHSsmsDKzMSmzQ4AuMDS8Xbr+NNBgAXq5utIGIeaSPqyVDDgf2wvB
         I4ikhUHsskA8vrA7xcY34C0OaiOIkZAdFpfR5g0VIIjNmrvRy7UsFTZswIXlWFqjVoKv
         f8mW/CU2hlgVxcF+xU005i/6QdFgVP6wdUxGoWUK28179www31sCT12JGetT/3/b/Kzg
         KTDp3DXRnXSX5V+dmHLsFpH1UaHdPq/4ZFs2zJHA9ZoCGdC4Cs0e0ANOg9vjv9ObfcVd
         jNRg==
X-Gm-Message-State: AOAM531jOfPNtvBnJkl5NRrOo5z9BceCtZwiiNB0PYuoMK5S3so92AFk
        kxWv1LC3XJjd42iHFUbxr0A=
X-Google-Smtp-Source: ABdhPJxba9noFkWmHICtZIkCB9bc26Uanx9kz8adLbnv9++B80KA5v8B+nVOcNDR65cF1wEBqkcz1g==
X-Received: by 2002:a63:b245:: with SMTP id t5mr14602666pgo.231.1641649595919;
        Sat, 08 Jan 2022 05:46:35 -0800 (PST)
Received: from vultr.guest ([45.76.74.237])
        by smtp.gmail.com with ESMTPSA id 190sm1366633pgh.23.2022.01.08.05.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 05:46:35 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        christian.brauner@ubuntu.com, Yafang Shao <laoar.shao@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v2] bpf: fix mount source show for bpffs
Date:   Sat,  8 Jan 2022 13:46:23 +0000
Message-Id: <20220108134623.32467-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We noticed our tc ebpf tools can't start after we upgrade our in-house
kernel version from 4.19 to 5.10. That is because of the behaviour change
in bpffs caused by commit
d2935de7e4fd ("vfs: Convert bpf to use the new mount API").

In our tc ebpf tools, we do strict environment check. If the enrioment is
not match, we won't allow to start the ebpf progs. One of the check is
whether bpffs is properly mounted. The mount information of bpffs in
kernel-4.19 and kernel-5.10 are as follows,

- kenrel 4.19
$ mount -t bpf bpffs /sys/fs/bpf
$ mount -t bpf
bpffs on /sys/fs/bpf type bpf (rw,relatime)

- kernel 5.10
$ mount -t bpf bpffs /sys/fs/bpf
$ mount -t bpf
none on /sys/fs/bpf type bpf (rw,relatime)

The device name in kernel-5.10 is displayed as none instead of bpffs,
then our environment check fails. Currently we modify the tools to adopt to
the kernel behaviour change, but I think we'd better change the kernel code
to keep the behavior consistent.

After this change, the mount information will be displayed the same with
the behavior in kernel-4.19, for example,

$ mount -t bpf bpffs /sys/fs/bpf
$ mount -t bpf
bpffs on /sys/fs/bpf type bpf (rw,relatime)

Fixes: d2935de7e4fd ("vfs: Convert bpf to use the new mount API")
Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>

---
v1->v2:
use the helper vfs_parse_fs_param_source() instead of open-coded (Daniel)
---
 kernel/bpf/inode.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index 80da1db47c68..5a8d9f7467bf 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -648,12 +648,22 @@ static int bpf_parse_param(struct fs_context *fc, struct fs_parameter *param)
 	int opt;
 
 	opt = fs_parse(fc, bpf_fs_parameters, param, &result);
-	if (opt < 0)
+	if (opt < 0) {
 		/* We might like to report bad mount options here, but
 		 * traditionally we've ignored all mount options, so we'd
 		 * better continue to ignore non-existing options for bpf.
 		 */
-		return opt == -ENOPARAM ? 0 : opt;
+		if (opt == -ENOPARAM) {
+			opt = vfs_parse_fs_param_source(fc, param);
+			if (opt != -ENOPARAM)
+				return opt;
+
+			return 0;
+		}
+
+		if (opt < 0)
+			return opt;
+	}
 
 	switch (opt) {
 	case OPT_MODE:
-- 
2.17.1

