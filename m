Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8D7613E22D
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 17:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731735AbgAPQyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:54:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:38776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731675AbgAPQyT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:54:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CAAE2176D;
        Thu, 16 Jan 2020 16:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193658;
        bh=uEbdXswwLVVYXOJIGfiADFINsVJhxIIscaqDI+gL9YQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LS31/I5bYnZbXP+dZP8BI4lrbsw8tBpoDtC2qPm1lGulbX+hpPGz0o0rFCPZfTJpi
         hSOvudfto/5gPNJposcbLytJ3bNe95JxSv5qKm0CHXyzBYfmU4ksijThsawvsN5DGT
         /CUhfQ6KxmRgphJIZzrXWqGxzGUtYHWJ4YEDajac=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 186/205] bpf: Force .BTF section start to zero when dumping from vmlinux
Date:   Thu, 16 Jan 2020 11:42:41 -0500
Message-Id: <20200116164300.6705-186-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stanislav Fomichev <sdf@google.com>

[ Upstream commit df786c9b947639aedbc7bb44b5dae2a7824af360 ]

While trying to figure out why fentry_fexit selftest doesn't pass for me
(old pahole, broken BTF), I found out that my latest patch can break vmlinux
.BTF generation. objcopy preserves section start when doing --only-section,
so there is a chance (depending on where pahole inserts .BTF section) to
have leading empty zeroes. Let's explicitly force section offset to zero.

Before:

$ objcopy --set-section-flags .BTF=alloc -O binary \
	--only-section=.BTF vmlinux .btf.vmlinux.bin
$ xxd .btf.vmlinux.bin | head -n1
00000000: 0000 0000 0000 0000 0000 0000 0000 0000  ................

After:

$ objcopy --change-section-address .BTF=0 \
	--set-section-flags .BTF=alloc -O binary \
	--only-section=.BTF vmlinux .btf.vmlinux.bin
$ xxd .btf.vmlinux.bin | head -n1
00000000: 9feb 0100 1800 0000 0000 0000 80e1 1c00  ................
          ^BTF magic

As part of this change, I'm also dropping '2>/dev/null' from objcopy
invocation to be able to catch possible other issues (objcopy doesn't
produce any warnings for me anymore, it did before with --dump-section).

Fixes: da5fb18225b4 ("bpf: Support pre-2.25-binutils objcopy for vmlinux BTF")
Signed-off-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Cc: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/20191127225759.39923-1-sdf@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/link-vmlinux.sh | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 2998ddb323e3..436379940356 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -127,8 +127,9 @@ gen_btf()
 		cut -d, -f1 | cut -d' ' -f2)
 	bin_format=$(LANG=C ${OBJDUMP} -f ${1} | grep 'file format' | \
 		awk '{print $4}')
-	${OBJCOPY} --set-section-flags .BTF=alloc -O binary \
-		--only-section=.BTF ${1} .btf.vmlinux.bin 2>/dev/null
+	${OBJCOPY} --change-section-address .BTF=0 \
+		--set-section-flags .BTF=alloc -O binary \
+		--only-section=.BTF ${1} .btf.vmlinux.bin
 	${OBJCOPY} -I binary -O ${bin_format} -B ${bin_arch} \
 		--rename-section .data=.BTF .btf.vmlinux.bin ${2}
 }
-- 
2.20.1

