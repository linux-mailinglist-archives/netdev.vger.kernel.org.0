Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF434365BD
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 17:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbhJUPSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 11:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231828AbhJUPSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 11:18:16 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76867C06122E
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 08:16:00 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id p21so47569wmq.1
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 08:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k+el4LssRR48MXi9zHjZky4nWABgnOCsHjGg/d8oAg4=;
        b=FsnxtymjLqZS2VFG04DvIpLqgieKtVBHjHP93zwTtnR5kU0AQ0H7Txhivy0MI6r3F+
         4ti4PHUooqoxlBofAnmjSThJWtmu00KP3f4qIow3SpAzH8sOiz2MUHysGzF0AqYS8isQ
         X/khq1aIqEF1IRXsINLNgw93KFmokB2bYNY5I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k+el4LssRR48MXi9zHjZky4nWABgnOCsHjGg/d8oAg4=;
        b=kJoMY0REFTazfLJVO9mzzOIW6ULGXySXwleCO2SAwbywPFpp9Jkaf4bPJDCZhHcu0L
         vb9PcI8Fc+wZQ/mzChQpkHIm2QyRpETOM+3shYvSh74/uARG8w5PvlFyn5v/owg2KVoJ
         sXzzuB1xe9yjWqfUj8VZAYKS97zrmuSrlT7/G4CXc3yxdHYxsiQVlH+WNyNhxDzjQ0dA
         PHNlLsjHRMHzZ09dihMDjeLKvtJQUYrSSLAFibUSMBhuWulmSeIV7uAXcSKkO1wBpIvJ
         F+tw+saceNQ9cleVXoC73cWmHDFdpiOKMrYJxjhP/RodKddu804rFWWUO8aT84yBcdPh
         XaGA==
X-Gm-Message-State: AOAM530/TN3czJJV5FdvXZSO+iJXhO8NE5wz5Lsj4fsynL6vYWHvPZ1+
        /fDud+CzZxLq9sSeqjDMFQXpfg==
X-Google-Smtp-Source: ABdhPJy2h51ESbpe/ACQzNHuZP5xG4x2CZXy7D5ddfeiaaqbvULX+oBLkAEKf1/ueSmOhDE9tPdDhg==
X-Received: by 2002:a7b:c183:: with SMTP id y3mr21815596wmi.2.1634829359046;
        Thu, 21 Oct 2021 08:15:59 -0700 (PDT)
Received: from altair.lan (7.2.6.0.8.8.2.4.4.c.c.f.b.1.5.4.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:451b:fcc4:4288:627])
        by smtp.googlemail.com with ESMTPSA id z1sm5098562wrt.94.2021.10.21.08.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 08:15:58 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 1/3] libfs: support RENAME_EXCHANGE in simple_rename()
Date:   Thu, 21 Oct 2021 16:15:26 +0100
Message-Id: <20211021151528.116818-2-lmb@cloudflare.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211021151528.116818-1-lmb@cloudflare.com>
References: <20211021151528.116818-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow atomic exchange via RENAME_EXCHANGE when using simple_rename.
This affects binderfs, ramfs, hubetlbfs and bpffs. There isn't much
to do except update the various *time fields.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 fs/libfs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index 51b4de3b3447..93c03d593749 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -455,9 +455,12 @@ int simple_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 	struct inode *inode = d_inode(old_dentry);
 	int they_are_dirs = d_is_dir(old_dentry);
 
-	if (flags & ~RENAME_NOREPLACE)
+	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
 		return -EINVAL;
 
+	if (flags & RENAME_EXCHANGE)
+		goto done;
+
 	if (!simple_empty(new_dentry))
 		return -ENOTEMPTY;
 
@@ -472,6 +475,7 @@ int simple_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 		inc_nlink(new_dir);
 	}
 
+done:
 	old_dir->i_ctime = old_dir->i_mtime = new_dir->i_ctime =
 		new_dir->i_mtime = inode->i_ctime = current_time(old_dir);
 
-- 
2.32.0

