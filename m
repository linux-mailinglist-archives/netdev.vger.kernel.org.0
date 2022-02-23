Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 285084C13E7
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 14:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240783AbiBWNTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 08:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234560AbiBWNTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 08:19:05 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638EB4BFE3;
        Wed, 23 Feb 2022 05:18:38 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id v5-20020a17090ac90500b001bc40b548f9so2194616pjt.0;
        Wed, 23 Feb 2022 05:18:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZUZG3KjnAxxCB6+9FUZe0tvQKSg2SGvjWAfnHHBC/vY=;
        b=ZvQtzORZz2amj9S+O4Q16N3ziMASxOGpXOKtIBwhBl6Y1LU7Rip2TPpaxE29FWIKMA
         tJDsHnsbGjK18hUjwNE2A9cEqz0hcB0XjvS5tTTQlJrzkG6NwhfNioZNGGZb2TzHhOZx
         DLC/c8JJm2ZPpJADcKChMQ+c4rO+MrBxWwiDoex7dlqyEXUx8GpMID2bIWhNmagrdmI4
         LW7HYXyHpDqvwXf3b7ABvP+nF4s/mPbkCJqei3pnSUaHvqLC13p07xbaTZHJBPInFLQp
         W4hyy2PUz4FS7ykZfp7/d23wNRo3sAOhkJeByYlwvV4IM26N7gmFKNFezU9rRJMdZedg
         4H3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZUZG3KjnAxxCB6+9FUZe0tvQKSg2SGvjWAfnHHBC/vY=;
        b=7FPqjbZLAubZkfae99bxMWcEcDujSF2its3Q1ZoOA6CzrgMHOslu3Lyz8MvViCXfRu
         q3S1S5cVUqfGLKWX4CUo/mvsPZcavyHBV1+6bYp+Ha6KnKF5F05wW40iQqSmo2oOVYom
         A6KDQFXieonjACb5Vh4qzIXMZVhSyzGtzsM/vKTAVuj6rT/cnCnRovxMb7zl69c/TXFq
         gRTLVAlOrLZ5yZ68px7+NS01CCFGPbjyVOvapG8ciNqMJ+wXW1Vv4kmF6scyvQdmoZ6i
         VBDEdEamkbI8CnqZzR3hbKfiZHEwyMPjD2eFdgvvPi/BfIn4FJqRj5qPJ+dG2kCBpA3h
         a6NQ==
X-Gm-Message-State: AOAM530o3bJXEK+B+aT5Aw5y7xCaI2OGS44511Tmsh6td6YTJaSIsAEM
        naPQUnTFg6DH+K6Xtj4OdT0mcf1EHHQBXA==
X-Google-Smtp-Source: ABdhPJzoek5PNQydgImMaQYXYhtwD4iI0pwxJNIcVnhUpE9DDMRJV94aEBeYv7xbLGx646g4kqQ7IA==
X-Received: by 2002:a17:90a:8588:b0:1bc:54b8:c3 with SMTP id m8-20020a17090a858800b001bc54b800c3mr9121468pjn.110.1645622317816;
        Wed, 23 Feb 2022 05:18:37 -0800 (PST)
Received: from vultr.guest ([149.248.7.47])
        by smtp.gmail.com with ESMTPSA id e10sm6189875pgw.16.2022.02.23.05.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 05:18:37 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] bpf: Refuse to mount bpffs on the same mount point multiple times
Date:   Wed, 23 Feb 2022 13:18:33 +0000
Message-Id: <20220223131833.51991-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We monitored an unexpected behavoir that bpffs is mounted on a same mount
point lots of times on some of our production envrionments. For example,
$ mount -t bpf
bpffs /sys/fs/bpf bpf rw,relatime 0 0
bpffs /sys/fs/bpf bpf rw,relatime 0 0
bpffs /sys/fs/bpf bpf rw,relatime 0 0
bpffs /sys/fs/bpf bpf rw,relatime 0 0
...

That was casued by a buggy user script which didn't check the mount
point correctly before mounting bpffs. But it also drives us to think more
about if it is okay to allow mounting bpffs on the same mount point
multiple times. After investigation we get the conclusion that it is bad
to allow that behavior, because it can cause unexpected issues, for
example it can break bpftool, which depends on the mount point to get
the pinned files.

Below is the test case wrt bpftool.
First, let's mount bpffs on /var/run/ltcp/bpf multiple times.
$ mount -t bpf
bpffs on /run/ltcp/bpf type bpf (rw,relatime)
bpffs on /run/ltcp/bpf type bpf (rw,relatime)
bpffs on /run/ltcp/bpf type bpf (rw,relatime)

After pinning some bpf progs on this mount point, let's check the pinned
files with bpftool,
$ bpftool prog list -f
87: sock_ops  name bpf_sockmap  tag a04f5eef06a7f555  gpl
        loaded_at 2022-02-23T16:27:38+0800  uid 0
        xlated 16B  jited 15B  memlock 4096B
        pinned /run/ltcp/bpf/bpf_sockmap
        pinned /run/ltcp/bpf/bpf_sockmap
        pinned /run/ltcp/bpf/bpf_sockmap
        btf_id 243
89: sk_msg  name bpf_redir_proxy  tag 57cd311f2e27366b  gpl
        loaded_at 2022-02-23T16:27:38+0800  uid 0
        xlated 16B  jited 18B  memlock 4096B
        pinned /run/ltcp/bpf/bpf_redir_proxy
        pinned /run/ltcp/bpf/bpf_redir_proxy
        pinned /run/ltcp/bpf/bpf_redir_proxy
        btf_id 244

The same pinned file will be showed multiple times.
Finnally after mounting bpffs on the same mount point again, we can't
get the pinnned files via bpftool,
$ bpftool prog list -f
87: sock_ops  name bpf_sockmap  tag a04f5eef06a7f555  gpl
        loaded_at 2022-02-23T16:27:38+0800  uid 0
        xlated 16B  jited 15B  memlock 4096B
        btf_id 243
89: sk_msg  name bpf_redir_proxy  tag 57cd311f2e27366b  gpl
        loaded_at 2022-02-23T16:27:38+0800  uid 0
        xlated 16B  jited 18B  memlock 4096B
        btf_id 244

We should better refuse to mount bpffs on the same mount point. Before
making this change, I also checked why it is allowed in the first place.
The related commits are commit e27f4a942a0e
("bpf: Use mount_nodev not mount_ns to mount the bpf filesystem") and
commit b2197755b263 ("bpf: add support for persistent maps/progs").
Unfortunately they didn't explain why it is allowed. But there should be
no use case which requires to mount bpffs on a same mount point multiple
times, so let's just refuse it.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
---
 kernel/bpf/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index 4f841e16779e..58374db9376f 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -763,7 +763,7 @@ static int bpf_fill_super(struct super_block *sb, struct fs_context *fc)
 
 static int bpf_get_tree(struct fs_context *fc)
 {
-	return get_tree_nodev(fc, bpf_fill_super);
+	return get_tree_single(fc, bpf_fill_super);
 }
 
 static void bpf_free_fc(struct fs_context *fc)
-- 
2.17.1

