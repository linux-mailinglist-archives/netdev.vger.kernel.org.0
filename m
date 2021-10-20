Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84AA54346F4
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 10:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbhJTIc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 04:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbhJTIcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 04:32:22 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4929BC061746
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 01:30:07 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id d198-20020a1c1dcf000000b00322f53b9b89so8303901wmd.0
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 01:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CbvtrLjcUbfgAMTLROLIlvj1tZ7LmmnXHpndaPRCItA=;
        b=UCGyUGeVpWan4WCX6U/T8SPsoDfVI8CRM1oqIfsJkpGsZUjZ1PJjuoy0Yx2XdBYhOA
         FDjDLlXRKmgBMVew3f4H+plLhk3YEnccbeLeSMewyXqwlvLWiTZXI6oGP5do8odiS9yj
         oG7NPxnJhXvgZTREotbgPMKNA+K7wPzH1puMc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CbvtrLjcUbfgAMTLROLIlvj1tZ7LmmnXHpndaPRCItA=;
        b=C27h1ctAIkoTOTj/C0d8J5gpq8e6ytVQ/8JqZ3q54BhSE3pXlgB/kGBOVfK7i2jd6J
         n/3RmYwxQCSEsjKe1cGIlWzqrgDhocM8ieij1UeoH2T09LE1L3xXEE89GHminmNm5whs
         dpxR7xCbMJAHW1wo8tjKSPQMDCoWdVLcRCjtHHWSl1WKiofJfvSeBKElxNY6qE/QUex/
         rqJ6fCct+MTaKcrEAeF1PIsyIMDExwsPMFMmjiR6NfF9G/HO+tZV+7OuoAgcptyVeIAS
         Lw9+6RAwrtwc/Ah1bKaQMNsIgr0Zkd8puJ6SVpaO6E035S5+tw8relfTzvjD5PMP9Zd/
         8y1w==
X-Gm-Message-State: AOAM530hFRvobqLiNhL0OdhpVygdH47Ltf9zpEx1nvIYtQ4Zdsg4CnoH
        hHCWyNfNVmOOfaS0XfFr0nYSdA==
X-Google-Smtp-Source: ABdhPJyg6rc1ETglY+0y14Mx0eWUrqdIrqIr0lV69WB2xP4oiYg+1LoVvxPsJJ+sjjQmknd4sqwsyQ==
X-Received: by 2002:a05:6000:1acc:: with SMTP id i12mr49580282wry.249.1634718605797;
        Wed, 20 Oct 2021 01:30:05 -0700 (PDT)
Received: from antares.. (d.5.c.c.6.2.1.6.f.5.3.5.c.9.c.f.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:fc9c:535f:6126:cc5d])
        by smtp.gmail.com with ESMTPSA id s13sm4473133wmc.47.2021.10.20.01.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 01:30:05 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next 1/2] libfs: support RENAME_EXCHANGE in simple_rename()
Date:   Wed, 20 Oct 2021 09:29:55 +0100
Message-Id: <20211020082956.8359-2-lmb@cloudflare.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211020082956.8359-1-lmb@cloudflare.com>
References: <20211020082956.8359-1-lmb@cloudflare.com>
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
2.30.2

