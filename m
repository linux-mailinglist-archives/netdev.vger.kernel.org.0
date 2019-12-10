Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB88F118AE0
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 15:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbfLJObK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 09:31:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39889 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727272AbfLJObK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 09:31:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575988268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=huNWTawb+BzW4Y59E1UWx3k52jbIXd0hQSz50hy5O4I=;
        b=hoyCv7NsCrTizX0u+4QQRtdYXcg+2JWvEPRfo13PXNChhtPCLwAut1G7PPZlJrQuCQdzsK
        7+qRxepaRCY8kgiKjTpMkXK/ZxaGp87w3h6+8x/DhUxV4Xw7QH3BtmGUduWLvP43IWR1Sh
        yBRftG8f15HbXxbZ4Q0vYUgbL1hE9lA=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-h0K4bPOEPz6mzoMhr6hDNA-1; Tue, 10 Dec 2019 09:31:05 -0500
Received: by mail-lf1-f72.google.com with SMTP id f22so3153493lfh.4
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 06:31:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iog97vb7UE8EJV6SLzpptV2/d5Gnn074vofpjb5er8U=;
        b=b0FaVm+X7ZqCzySDxRREVXiFlNCfUphTOP5sKVjXJjiM9aI2fDRzHbfqtvYFPhGH8z
         GY67ef6KgNQ5hbygjhIbHqTFlTjSNu+Q+c2cxodRHpWiyAjrBjKI1I/IaBsP4Sl8alBv
         TCl6ITJIPuhHbcRpw8AZYlFLKu07mmJFWrUbNGV61Jfeg5Xc8CyeCiwxBfVYlhX+A4KZ
         IW0td91BcHbd67s9GGuKK0PFu9S3DkJQBL7FHbsVA1E6QCUsXo5XIpt47Sg47dkhQdDi
         eUz+ZTDQvWhkM6FmQIBse4ZFJmZfWgaTy58Q9Bq2e0Y2eL6LzNaj30qSHVfIPopeTqCj
         TY0g==
X-Gm-Message-State: APjAAAUeeSjEXIMZTV3/rWdygYRritF65S/aDXesMVduP4i+WymsZikE
        FRfRVnp2uNiACL1pBt4r7gWJbAahmr57jnQJQB6zn8N/+H18K20sMdFxmTglBpfs2RWDFJd4Hrx
        XC661XjR7fZaDqBEz
X-Received: by 2002:ac2:5287:: with SMTP id q7mr11942111lfm.66.1575988264230;
        Tue, 10 Dec 2019 06:31:04 -0800 (PST)
X-Google-Smtp-Source: APXvYqyVqsvLkTJ2noEGSfdHt3lybF4HPTE2NrQeBlidKwZ8pjcwGqiRTy0mkQRgWp+fWlQNIq+R9A==
X-Received: by 2002:ac2:5287:: with SMTP id q7mr11942091lfm.66.1575988263997;
        Tue, 10 Dec 2019 06:31:03 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id e20sm1850036ljl.59.2019.12.10.06.31.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 06:31:03 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 76651181AC8; Tue, 10 Dec 2019 15:31:01 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf] bpftool: Don't crash on missing jited insns or ksyms
Date:   Tue, 10 Dec 2019 15:30:47 +0100
Message-Id: <20191210143047.142347-1-toke@redhat.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
X-MC-Unique: h0K4bPOEPz6mzoMhr6hDNA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When JIT hardening is turned on, the kernel can fail to return jited_ksyms
or jited_prog_insns, but still have positive values in nr_jited_ksyms and
jited_prog_len. This causes bpftool to crash when trying to dump the
program because it only checks the len fields not the actual pointers to
the instructions and ksyms.

Fix this by adding the missing checks.

Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
---
 tools/bpf/bpftool/prog.c          | 2 +-
 tools/bpf/bpftool/xlated_dumper.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 4535c863d2cd..2ce9c5ba1934 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -493,7 +493,7 @@ static int do_dump(int argc, char **argv)
=20
 =09info =3D &info_linear->info;
 =09if (mode =3D=3D DUMP_JITED) {
-=09=09if (info->jited_prog_len =3D=3D 0) {
+=09=09if (info->jited_prog_len =3D=3D 0 || !info->jited_prog_insns) {
 =09=09=09p_info("no instructions returned");
 =09=09=09goto err_free;
 =09=09}
diff --git a/tools/bpf/bpftool/xlated_dumper.c b/tools/bpf/bpftool/xlated_d=
umper.c
index 494d7ae3614d..5b91ee65a080 100644
--- a/tools/bpf/bpftool/xlated_dumper.c
+++ b/tools/bpf/bpftool/xlated_dumper.c
@@ -174,7 +174,7 @@ static const char *print_call(void *private_data,
 =09struct kernel_sym *sym;
=20
 =09if (insn->src_reg =3D=3D BPF_PSEUDO_CALL &&
-=09    (__u32) insn->imm < dd->nr_jited_ksyms)
+=09    (__u32) insn->imm < dd->nr_jited_ksyms && dd->jited_ksyms)
 =09=09address =3D dd->jited_ksyms[insn->imm];
=20
 =09sym =3D kernel_syms_search(dd, address);
--=20
2.24.0

