Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 590BC43DE03
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 11:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbhJ1Juw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 05:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbhJ1Juu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 05:50:50 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447CBC061243
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 02:48:23 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id d13so9052833wrf.11
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 02:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Yiz7MiIC+w5wxi7ovhqP5wkmEdrKSKSQKMo0rSjvbko=;
        b=JTF2MCL5w0PpoQtF94DGwsa3VstO6Faq3yeusALoRsVLeuyTY044h/nYCZyewX8A8U
         cuiaM0GLTss4nOzwJOrpPfli1mxpQmBUtu80yJDHR5FZJvA+ua9/iVIeuVeM7By/QYbM
         9FQxfRPwyDhdvuvHLcS2ZW1LnvCLIR6WqZtkI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yiz7MiIC+w5wxi7ovhqP5wkmEdrKSKSQKMo0rSjvbko=;
        b=WcJvK/C5Zrjl4Bn2YIGqEBPBLfiVBFv6biCb00JXPWM5ct/2lDO/oGNVtoMpRroKxR
         tcyYNUa0/MRcuSDX+L3w+mS7FN28bY74O9iU+hRS0B/aunv6St8Grxd0iimNBGuakl6b
         sSlRDalXNKAav6/WgzEEZFTwoN1TPvyNDWbxSb/6I7X0D9KU3W03Qk/YGHnePifKYYVU
         zAI4o9J448k+sIXF+zXlwEMB8Yt8JoNYiaeYqU211ek6TNaySyFgxDHkI1DA1/kjoBkp
         W0bYDiHEhl0Tp96PoMnPPgX5YpbmrT2hCYLonwDTSSubABO04ZEh/h1RX9TiiK5of15O
         35mw==
X-Gm-Message-State: AOAM5339lypQJd+i3t8AdhuMdR6u2Kn2DBPmXxPTOJZgcwcsDv6GJP88
        U+aYrmeARViRkK/mZzmacOQ6SA==
X-Google-Smtp-Source: ABdhPJzHZI6Qzejpe7gF+o+e2+cssreAhde5t4LpII5b7rhQbXbt4OeISNb7STE/0Jv9wfcQoGsYuw==
X-Received: by 2002:adf:e483:: with SMTP id i3mr4231238wrm.175.1635414501867;
        Thu, 28 Oct 2021 02:48:21 -0700 (PDT)
Received: from altair.lan (2.f.6.6.b.3.3.0.3.a.d.b.6.0.6.0.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:606:bda3:33b:66f2])
        by smtp.googlemail.com with ESMTPSA id i6sm3378029wry.71.2021.10.28.02.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 02:48:21 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     viro@zeniv.linux.org.uk, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     mszeredi@redhat.com, gregkh@linuxfoundation.org,
        Lorenz Bauer <lmb@cloudflare.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v3 2/4] libfs: support RENAME_EXCHANGE in simple_rename()
Date:   Thu, 28 Oct 2021 10:47:22 +0100
Message-Id: <20211028094724.59043-3-lmb@cloudflare.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211028094724.59043-1-lmb@cloudflare.com>
References: <20211028094724.59043-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow atomic exchange via RENAME_EXCHANGE when using simple_rename.
This affects binderfs, ramfs, hubetlbfs and bpffs.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 fs/libfs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index 1cf144dc9ed2..ba7438ab9371 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -479,9 +479,12 @@ int simple_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 	struct inode *inode = d_inode(old_dentry);
 	int they_are_dirs = d_is_dir(old_dentry);
 
-	if (flags & ~RENAME_NOREPLACE)
+	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
 		return -EINVAL;
 
+	if (flags & RENAME_EXCHANGE)
+		return simple_rename_exchange(old_dir, old_dentry, new_dir, new_dentry);
+
 	if (!simple_empty(new_dentry))
 		return -ENOTEMPTY;
 
-- 
2.32.0

