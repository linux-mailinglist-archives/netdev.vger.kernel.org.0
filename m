Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1717047F856
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 17:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232877AbhLZQ44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 11:56:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbhLZQ44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Dec 2021 11:56:56 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086E5C06173E;
        Sun, 26 Dec 2021 08:56:56 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id 205so11910984pfu.0;
        Sun, 26 Dec 2021 08:56:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1vtB4zSWEd+mzMw7k7zC4ebpjbJkDLgH/0D+65o5eMY=;
        b=AU6v5k8/Wqlgq3kZrAnO2P6IoVfzz7Q4wHYtb3zEA6i+N+wVFGYCHa2vKgVpVH6Y3D
         QkALbVpU8AWxGLJT4NehXhXJLt9PcgTGvGXC9tGZ/zIkm4FplG/zFWNSKcuOpmOIH6Pd
         5vtdjb1TgTsY3CSmsCKj4wEBoY6VuxW+EtplPTsqt2N3MM4sKRQbepAXtGZ5qv6+bl8/
         p2KukY3Pi9WQXfouZ9iLIOdJ8wuQvIktznS842uJfFdR2F50LgcDPlGjc4mZ2wJ42pcg
         E4QGMzDBgtFt1GK44QGhjRPlCr2KSJ1LhGbFSu+9KSrxzl78IIMnBp4968PsDwrfjxDk
         iBsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1vtB4zSWEd+mzMw7k7zC4ebpjbJkDLgH/0D+65o5eMY=;
        b=0ZHyiyyyOe1nud6jjXcdLvWbq/FnL2Cz2jreyQ1b1mF2BNzCc8oFjgQjL7vVOtXHhh
         9NX4FAaVk6f1J1kjaUrUfQq3NB0QLGepl6sW0SDWFEgRAlPhs0JFcobyHDXyoxRspXMz
         o1cNvesr150zAwYT3MwHZRCqSNs+LU1d0S/HSxHnbfcJMnm9aVKrbanarr4DWvxj5Ch2
         4p1vNfTQF55USBRhuev1Ztt6c8mnFznYSupsVAKHpxHNmZaMVVmWCLzlepYdzfC5D/DL
         SqGJhwcLr5V952B9QN/AjMr3rHjjurY54kiLaOwikvzct2R6Gl2Q2iYRZxKrEZ2HKxLD
         832g==
X-Gm-Message-State: AOAM532bmtjWVbQmV72o9AZKtfknOLupMd4aqg1+Nz/v5z+Zo3GB+EmT
        njgIh87vDvHR61C6pNIWDoatTFbFigpCm442
X-Google-Smtp-Source: ABdhPJyLF7IFMHweBjbsN6/rvYtE4N3sLAm7AE1ZjVFVBLFKlg6Mss0Tj6beK5t7Liu/YQmnMc4MUg==
X-Received: by 2002:a63:5fc6:: with SMTP id t189mr12891600pgb.249.1640537815531;
        Sun, 26 Dec 2021 08:56:55 -0800 (PST)
Received: from vultr.guest ([45.76.74.237])
        by smtp.gmail.com with ESMTPSA id on7sm14395735pjb.50.2021.12.26.08.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Dec 2021 08:56:55 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH] bpf: allow setting mount device for bpffs
Date:   Sun, 26 Dec 2021 16:56:49 +0000
Message-Id: <20211226165649.7178-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
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
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: David Howells <dhowells@redhat.com>
---
 kernel/bpf/inode.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index 80da1db47c68..5a8b729afa91 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -648,12 +648,26 @@ static int bpf_parse_param(struct fs_context *fc, struct fs_parameter *param)
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
+			if (strcmp(param->key, "source") == 0) {
+				if (param->type != fs_value_is_string)
+					return 0;
+				if (fc->source)
+					return 0;
+				fc->source = param->string;
+				param->string = NULL;
+			}
+
+			return 0;
+		}
+
+		return opt;
+	}
 
 	switch (opt) {
 	case OPT_MODE:
-- 
2.17.1

