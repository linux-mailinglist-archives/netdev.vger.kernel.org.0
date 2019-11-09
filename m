Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA98F617D
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 21:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfKIUhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 15:37:35 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37254 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726485AbfKIUhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 15:37:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573331852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ShjURwV1pMiGnWc15Y9RqDoj+KHWqv/A8WsqK9DmPCI=;
        b=V4goYI4D1RCo1EzhaItwnkua9odg736+qP79yWCPRCaesO1vEo1gUQqgXTV1d83HtumUN7
        HW4GNmOMAJLK56+Qlr53igWOED+ZLxANv7mUO/3tIdVBxWRO5wUupOywnIpuYRdZru47fp
        JJYUK7f9I9iezmTH/GuE01BQJk9QvJk=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-jB_GYFXtOT2tUnlsXggNIA-1; Sat, 09 Nov 2019 15:37:31 -0500
Received: by mail-lj1-f199.google.com with SMTP id h9so1910680ljc.6
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 12:37:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=nbp3QfN0TQNkDe9Q9+yAlcUGzwTWjk7ZLS5MnwIXPgY=;
        b=sWvk0+N74hKWat5SAgsPBY4pAoMQAZfxHIwg6rLXMUWhucBeIwlRKldpD3OsaK7khv
         EVPvHVd2VKEenAcUnmMxYIGn0SDIl4BqEno0fv7iJOq5sY50bok4bG3zoIxR63qHT9XK
         Q+OWoOP2Cane16mtTX6e54bI5lBYi547o++AVaJzHbDbWwolApDpO3KSMV4zP/Z14DV8
         qOQosAWrY2fVNz+NYJWdOqhmtuwI4YpUGk3PxWgUfnHV0R8C/wgVYUOc9E1XYbOueq5C
         6u1KGwHKan0klQwa+B1cp/ktUQfzxSwRbRLedvTGds+JqWAPVxTPQqjEW1Jn5y6QSFVz
         jexw==
X-Gm-Message-State: APjAAAV+JCXXcNFm5AthnDbRk/CERgM4CdPW/Rn54MKzEGt5GCsme718
        VZIJd7WKBbl6GDkP4FlijMUS4VcwZSzLfvW31a++04b8n6in+V7tsfLIOdZh3hChp8VWgF/QyRc
        ezVEtn2azfhhyvF4F
X-Received: by 2002:a2e:9904:: with SMTP id v4mr1146516lji.211.1573331850139;
        Sat, 09 Nov 2019 12:37:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqyAnfzo4hKQPET5sJkwq2JRyKrDI/3MOUeac0pIKwMZuJDAl193Z7qRwm9MlJM6Zb4vcRv3+Q==
X-Received: by 2002:a2e:9904:: with SMTP id v4mr1146507lji.211.1573331849999;
        Sat, 09 Nov 2019 12:37:29 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id r9sm5406245ljm.7.2019.11.09.12.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 12:37:28 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 71B0D1800CC; Sat,  9 Nov 2019 21:37:28 +0100 (CET)
Subject: [PATCH bpf-next v4 2/6] selftests/bpf: Add tests for automatic map
 unpinning on load failure
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Sat, 09 Nov 2019 21:37:28 +0100
Message-ID: <157333184838.88376.8243704248624814775.stgit@toke.dk>
In-Reply-To: <157333184619.88376.13377736576285554047.stgit@toke.dk>
References: <157333184619.88376.13377736576285554047.stgit@toke.dk>
User-Agent: StGit/0.21
MIME-Version: 1.0
X-MC-Unique: jB_GYFXtOT2tUnlsXggNIA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

This add tests for the different variations of automatic map unpinning on
load failure.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
---
 tools/testing/selftests/bpf/prog_tests/pinning.c |   20 +++++++++++++++++-=
--
 tools/testing/selftests/bpf/progs/test_pinning.c |    2 +-
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/pinning.c b/tools/testi=
ng/selftests/bpf/prog_tests/pinning.c
index 525388971e08..041952524c55 100644
--- a/tools/testing/selftests/bpf/prog_tests/pinning.c
+++ b/tools/testing/selftests/bpf/prog_tests/pinning.c
@@ -163,12 +163,15 @@ void test_pinning(void)
 =09=09goto out;
 =09}
=20
-=09/* swap pin paths of the two maps */
+=09/* set pin paths so that nopinmap2 will attempt to reuse the map at
+=09 * pinpath (which will fail), but not before pinmap has already been
+=09 * reused
+=09 */
 =09bpf_object__for_each_map(map, obj) {
 =09=09if (!strcmp(bpf_map__name(map), "nopinmap"))
+=09=09=09err =3D bpf_map__set_pin_path(map, nopinpath2);
+=09=09else if (!strcmp(bpf_map__name(map), "nopinmap2"))
 =09=09=09err =3D bpf_map__set_pin_path(map, pinpath);
-=09=09else if (!strcmp(bpf_map__name(map), "pinmap"))
-=09=09=09err =3D bpf_map__set_pin_path(map, NULL);
 =09=09else
 =09=09=09continue;
=20
@@ -181,6 +184,17 @@ void test_pinning(void)
 =09if (CHECK(err !=3D -EINVAL, "param mismatch load", "err %d errno %d\n",=
 err, errno))
 =09=09goto out;
=20
+=09/* nopinmap2 should have been pinned and cleaned up again */
+=09err =3D stat(nopinpath2, &statbuf);
+=09if (CHECK(!err || errno !=3D ENOENT, "stat nopinpath2",
+=09=09  "err %d errno %d\n", err, errno))
+=09=09goto out;
+
+=09/* pinmap should still be there */
+=09err =3D stat(pinpath, &statbuf);
+=09if (CHECK(err, "stat pinpath", "err %d errno %d\n", err, errno))
+=09=09goto out;
+
 =09bpf_object__close(obj);
=20
 =09/* test auto-pinning at custom path with open opt */
diff --git a/tools/testing/selftests/bpf/progs/test_pinning.c b/tools/testi=
ng/selftests/bpf/progs/test_pinning.c
index f69a4a50d056..f20e7e00373f 100644
--- a/tools/testing/selftests/bpf/progs/test_pinning.c
+++ b/tools/testing/selftests/bpf/progs/test_pinning.c
@@ -21,7 +21,7 @@ struct {
 } nopinmap SEC(".maps");
=20
 struct {
-=09__uint(type, BPF_MAP_TYPE_ARRAY);
+=09__uint(type, BPF_MAP_TYPE_HASH);
 =09__uint(max_entries, 1);
 =09__type(key, __u32);
 =09__type(value, __u64);

