Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 091E5F617B
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 21:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfKIUhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 15:37:34 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55850 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726383AbfKIUhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 15:37:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573331854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YoGx4j4EJeY43EHTYAjERmWYAXK1PFM/qGcoII7ng1Y=;
        b=hJQNHlI8KrOOh28S3z1PIrLb0bi9tAQjCvuyfeOsGxiK8YVeYSPW7WjQa9sPVC0sNlqQbK
        WWJFdnDHUSWqIVaBPSoaaXR94GSCVzjNesYiudj6FfvcDXUM0gfJ/d8KdYIcpvI7g/YY2c
        hvqY253UCfbqLg0MU83Y0C/GRLnT4Qw=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-Ru3cS7O3OF-Og_4SIWcS4w-1; Sat, 09 Nov 2019 15:37:32 -0500
Received: by mail-lj1-f197.google.com with SMTP id u6so1912027ljg.8
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 12:37:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=4Cvrxa7IvHFSSb8C+MCZfXx4kZGTNEaBrWFzvNfBaO0=;
        b=Z3W4ynscVtKIewQJLsrfCydGpXTggw5lLUenLJ/yszOfekHZK09VyNGYPRYziWdbgl
         Th9bps8Y5mZQIm7PQUsLIRlxZoNcfFKjkPoQ+Gtw2TUK5HtzDYD+1ne+0jMkF2DUFICL
         f7qdRTVySyIC45q2ZMeH9xYuzRJnHC3NlPYI/z0NkdV6LE1ORzoA7DsxreR/Djvr2qUU
         ZYjZuCnqSI7WnBu2nkYXxAYA4x8msl80lJtv6xicYV8eusCPKa0lzs3/Xf3+H37jlLm5
         Yt7/tgGOSIjB4rpYx9ihts9b2VSaagXBN/jQZLLqq22b71/Z+ofZqRGVunhEMAFqvKJs
         nKIw==
X-Gm-Message-State: APjAAAVd3YJkNV5Q/SKWivmtX0MsjXjTmOIkXAhavfLx77EqdHeZWYwV
        5aLBGBAIkYkDl33J24L0LTMyW7jpRqvSPd0d4nBxw0jAZj6Os9dYHTL0h2D949jNv3xZ+NezORp
        vkBjy3RcEwr4Y1kF+
X-Received: by 2002:ac2:48af:: with SMTP id u15mr10474020lfg.151.1573331851284;
        Sat, 09 Nov 2019 12:37:31 -0800 (PST)
X-Google-Smtp-Source: APXvYqzOULTBv6amA+anb9FPQhw5rLs7XjtcGb4bnE6Nw6HDelmLIUZ3fzr0Ih2/4LaWZUtMKfaI3g==
X-Received: by 2002:ac2:48af:: with SMTP id u15mr10474015lfg.151.1573331851131;
        Sat, 09 Nov 2019 12:37:31 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id g13sm4856847lfj.91.2019.11.09.12.37.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 12:37:30 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 860DF1800CE; Sat,  9 Nov 2019 21:37:29 +0100 (CET)
Subject: [PATCH bpf-next v4 3/6] libbpf: Propagate EPERM to caller on program
 load
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Sat, 09 Nov 2019 21:37:29 +0100
Message-ID: <157333184946.88376.11768171652794234561.stgit@toke.dk>
In-Reply-To: <157333184619.88376.13377736576285554047.stgit@toke.dk>
References: <157333184619.88376.13377736576285554047.stgit@toke.dk>
User-Agent: StGit/0.21
MIME-Version: 1.0
X-MC-Unique: Ru3cS7O3OF-Og_4SIWcS4w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

When loading an eBPF program, libbpf overrides the return code for EPERM
errors instead of returning it to the caller. This makes it hard to figure
out what went wrong on load.

In particular, EPERM is returned when the system rlimit is too low to lock
the memory required for the BPF program. Previously, this was somewhat
obscured because the rlimit error would be hit on map creation (which does
return it correctly). However, since maps can now be reused, object load
can proceed all the way to loading programs without hitting the error;
propagating it even in this case makes it possible for the caller to react
appropriately (and, e.g., attempt to raise the rlimit before retrying).

Acked-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
---
 tools/lib/bpf/libbpf.c |   27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index a70ade546a73..094f5c64611a 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3721,7 +3721,7 @@ load_program(struct bpf_program *prog, struct bpf_ins=
n *insns, int insns_cnt,
 =09=09free(log_buf);
 =09=09goto retry_load;
 =09}
-=09ret =3D -LIBBPF_ERRNO__LOAD;
+=09ret =3D -errno;
 =09cp =3D libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
 =09pr_warn("load bpf program failed: %s\n", cp);
=20
@@ -3734,23 +3734,18 @@ load_program(struct bpf_program *prog, struct bpf_i=
nsn *insns, int insns_cnt,
 =09=09pr_warn("Program too large (%zu insns), at most %d insns\n",
 =09=09=09load_attr.insns_cnt, BPF_MAXINSNS);
 =09=09ret =3D -LIBBPF_ERRNO__PROG2BIG;
-=09} else {
+=09} else if (load_attr.prog_type !=3D BPF_PROG_TYPE_KPROBE) {
 =09=09/* Wrong program type? */
-=09=09if (load_attr.prog_type !=3D BPF_PROG_TYPE_KPROBE) {
-=09=09=09int fd;
-
-=09=09=09load_attr.prog_type =3D BPF_PROG_TYPE_KPROBE;
-=09=09=09load_attr.expected_attach_type =3D 0;
-=09=09=09fd =3D bpf_load_program_xattr(&load_attr, NULL, 0);
-=09=09=09if (fd >=3D 0) {
-=09=09=09=09close(fd);
-=09=09=09=09ret =3D -LIBBPF_ERRNO__PROGTYPE;
-=09=09=09=09goto out;
-=09=09=09}
-=09=09}
+=09=09int fd;
=20
-=09=09if (log_buf)
-=09=09=09ret =3D -LIBBPF_ERRNO__KVER;
+=09=09load_attr.prog_type =3D BPF_PROG_TYPE_KPROBE;
+=09=09load_attr.expected_attach_type =3D 0;
+=09=09fd =3D bpf_load_program_xattr(&load_attr, NULL, 0);
+=09=09if (fd >=3D 0) {
+=09=09=09close(fd);
+=09=09=09ret =3D -LIBBPF_ERRNO__PROGTYPE;
+=09=09=09goto out;
+=09=09}
 =09}
=20
 out:

