Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B617314401C
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 16:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbgAUPEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 10:04:37 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44327 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727255AbgAUPEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 10:04:34 -0500
Received: by mail-wr1-f68.google.com with SMTP id q10so3550597wrm.11
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 07:04:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=3fX8yqVdokeUbIrwEfgnVCmcXTtAwRGxuX8ZNd4rp/U=;
        b=lqbjIQovQBhxj+xtgVpB8uPL58iOhyecjOyhwTyWj62vfntLi4PpGJ6VfGKjJ2QUnK
         JMumsdiQl5V6T7LB2vFENkf8ojE07zTSr/3BJxxB/9O7BC4rZwYKSzfyCvx7JknD3GMV
         Ea2K+iKl2ejNEzovb915Aw97aYSA1UGVo51PM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=3fX8yqVdokeUbIrwEfgnVCmcXTtAwRGxuX8ZNd4rp/U=;
        b=GQYLtd9v/1pcdDVUeUTowhJE0+97TFXmdKvtZwuToY5xiwj2CmibPmLTrxr/beEBty
         KIcupttf6rNrG2pbc8jsCVOZ1DdLGsUDo334qoMEWrQkCsRTWVDS711DPkbQt6BbVzqa
         /qvWIazcgZmpnOgo/IxrbI8HxCQryKLxlJj/xWJDfQyyZulDZLnDGuzZW0eaUIaLsxsT
         /L54gE8mUZqEmxN81wSmyHjZHeawLyDjWl35jiyO8dMxWha2eZZV6Da1NihDCOsUzYVr
         pOv1omrGRTcVKzAmq5Z+kMRi5Z3GUiyCGy/h1NKZ6TttIvWr48sR/Vlmx2roXlT/l2wT
         ro0g==
X-Gm-Message-State: APjAAAXzMa5jnAo78FpEBjPioWO+jf0kBmD+sKtkH2OvCyv8qhBKR/0N
        xojt0mEtvz8m5WvpYEbcinFQxw==
X-Google-Smtp-Source: APXvYqw/n/eK5Xu7u+qMpNfuL8mmr6BDT1kDRYsC9l5O4JsvXRyvkzv097K0+46FPQDNAoOyCpapCg==
X-Received: by 2002:a5d:4d8d:: with SMTP id b13mr5816499wru.6.1579619072431;
        Tue, 21 Jan 2020 07:04:32 -0800 (PST)
Received: from localhost ([2620:10d:c092:180::1:db6c])
        by smtp.gmail.com with ESMTPSA id s15sm49352115wrp.4.2020.01.21.07.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 07:04:31 -0800 (PST)
Date:   Tue, 21 Jan 2020 15:04:31 +0000
From:   Chris Down <chris@chrisdown.name>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH] bpf: btf: Always output invariant hit in pahole DWARF to BTF
 transform
Message-ID: <20200121150431.GA240246@chrisdown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When trying to compile with CONFIG_DEBUG_INFO_BTF enabled, I got this
error:

    % make -s
    Failed to generate BTF for vmlinux
    Try to disable CONFIG_DEBUG_INFO_BTF
    make[3]: *** [vmlinux] Error 1

Compiling again without -s shows the true error (that pahole is
missing), but since this is fatal, we should show the error
unconditionally on stderr as well, not silence it using the `info`
function. With this patch:

    % make -s
    BTF: .tmp_vmlinux.btf: pahole (pahole) is not available
    Failed to generate BTF for vmlinux
    Try to disable CONFIG_DEBUG_INFO_BTF
    make[3]: *** [vmlinux] Error 1

Signed-off-by: Chris Down <chris@chrisdown.name>
Cc: Stanislav Fomichev <sdf@google.com>
Cc: Andrii Nakryiko <andriin@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: bpf@vger.kernel.org
Cc: kernel-team@fb.com
---
 scripts/link-vmlinux.sh | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index c287ad9b3a67..c8e9f49903a0 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -108,13 +108,15 @@ gen_btf()
 	local bin_arch
 
 	if ! [ -x "$(command -v ${PAHOLE})" ]; then
-		info "BTF" "${1}: pahole (${PAHOLE}) is not available"
+		printf 'BTF: %s: pahole (%s) is not available\n' \
+			"${1}" "${PAHOLE}" >&2
 		return 1
 	fi
 
 	pahole_ver=$(${PAHOLE} --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/')
 	if [ "${pahole_ver}" -lt "113" ]; then
-		info "BTF" "${1}: pahole version $(${PAHOLE} --version) is too old, need at least v1.13"
+		printf 'BTF: %s: pahole version %s is too old, need at least v1.13\n' \
+			"${1}" "$(${PAHOLE} --version)" >&2
 		return 1
 	fi
 
-- 
2.25.0

