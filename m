Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE6D610C079
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 23:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbfK0W6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 17:58:05 -0500
Received: from mail-qv1-f73.google.com ([209.85.219.73]:55109 "EHLO
        mail-qv1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727227AbfK0W6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 17:58:04 -0500
Received: by mail-qv1-f73.google.com with SMTP id q20so3285280qvl.21
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 14:58:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=mo5o+Ecd/yLI7tHcwQjCfzTu2XUere/oZo1lhAcUfOo=;
        b=PLqUksAJNKMrDkQktb55ZRr5VGYVQe5v+6KLWNXAPiQtZXRgMJQaHYUAXVG4i4n6J/
         XTJx8vOFoR+xki8GZ4sHnd9YSBRDHN5RSe+wRsm9qXlpht39a8vxo7oJ0ySWtsboMwEY
         JN4yot1nZvxM1ybgdIk4JenF4E4qemb/TrwwxiQAtuQpH0spHZQBKgzX8lmdAQtG7P5R
         01u8KoyRs6cLORQtT1R3DWKYbm3a9+/78w99JFhx2igCJvrJKmN1Usa+OUQ74UNl+/6k
         WpmTOhYJF56CthrgEk86v5hhb5XeXG+V96L9ICHsWM4UHhYhkXz3nNEJ73dWoT+e0sBj
         jSkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=mo5o+Ecd/yLI7tHcwQjCfzTu2XUere/oZo1lhAcUfOo=;
        b=Slq3zfmW/XbiuvhW+a//yaVccO2ExiHI0PJNVySEPWdgzR/l2BrVOFbOEcT6oV2a6y
         GEQ5BAZCK/mXeXqNwZkgU7v64+ZmqCgyk/5jnZknMflpo4YJArpPPFQiTLkBnJm4F2WU
         uoqVYJ0ZOKN5umINhDzDkpCfOzkMhj78NpoZEjWjY3BkuJDuvEsASpwRi0VvFfqKo25F
         46wAvIUK63eAqaS3Wu5xYLUippJEWHYyhGQv4pI7llFmSTj5HMIL1tDWf5ZRbxmoZvU4
         q25hdpJMk9DzqbcpfrCy+bKiIvfpgdERssANyB3Kh690rTNY+FBf/nCfSYWWY8LMrcOi
         Cklg==
X-Gm-Message-State: APjAAAUYHVs4qmFkQU4abI6dhkKfs+auyeM5McuxstiuHUuwBZ9bibEt
        q365xRUsvhwY9Uqa7OHvJbrzH5DWg2FEC8jSBdChO72rntBGG1eVaKvVq9ebClrAeINqIGX+pF2
        UdCdB9k9KaUfxsJ2NfBbiyJ51R473MLh0R+DFzeaOFiMSptdu33sJaw==
X-Google-Smtp-Source: APXvYqxqRrQck2Qg1SazChf5GGQyDSK+xKWIcVcoD5+klqd5qbdi9axf0rFQG4/RD2nh+N9PdFj0dJI=
X-Received: by 2002:a05:620a:134f:: with SMTP id c15mr7037653qkl.115.1574895481604;
 Wed, 27 Nov 2019 14:58:01 -0800 (PST)
Date:   Wed, 27 Nov 2019 14:57:59 -0800
Message-Id: <20191127225759.39923-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH bpf] bpf: force .BTF section start to zero when dumping from vmlinux
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

Cc: Andrii Nakryiko <andriin@fb.com>
Fixes: da5fb18225b4 ("bpf: Support pre-2.25-binutils objcopy for vmlinux BTF")
Signed-off-by: Stanislav Fomichev <sdf@google.com>
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
2.24.0.432.g9d3f5f5b63-goog

