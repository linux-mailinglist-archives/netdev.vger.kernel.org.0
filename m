Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69CDFC901B
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 19:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbfJBRnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 13:43:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35954 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726076AbfJBRnm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 13:43:42 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 029293082231;
        Wed,  2 Oct 2019 17:43:42 +0000 (UTC)
Received: from krava (ovpn-204-114.brq.redhat.com [10.40.204.114])
        by smtp.corp.redhat.com (Postfix) with SMTP id A7E83600CE;
        Wed,  2 Oct 2019 17:43:32 +0000 (UTC)
Date:   Wed, 2 Oct 2019 19:43:31 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Julia Kartseva <hex@fb.com>, Yonghong Song <yhs@fb.com>
Cc:     "debian-kernel@lists.debian.org" <debian-kernel@lists.debian.org>,
        "md@linux.it" <md@linux.it>, Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        "labbott@redhat.com" <labbott@redhat.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        iovisor-dev@lists.iovisor.org
Subject: libbpf-devel rpm uapi headers
Message-ID: <20191002174331.GA13941@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Wed, 02 Oct 2019 17:43:42 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
we'd like to have bcc linked with libbpf instead of the
github submodule, initial change is discussed in here:
  https://github.com/iovisor/bcc/pull/2535

In order to do that, we need to have access to uapi headers
compatible with libbpf rpm, bcc is attaching and using them
during compilation.

I added them in the fedora spec below (not submitted yet),
so libbpf would carry those headers.

Thoughts? thanks,
jirka


---
Subject: [PATCH] Package uapi headers under /usr/include/bpf/uapi/linux

The full list of files for libbpf-devel is now:

  /usr/include/bpf
  /usr/include/bpf/bpf.h
  /usr/include/bpf/btf.h
  /usr/include/bpf/libbpf.h
  /usr/include/bpf/libbpf_util.h
  /usr/include/bpf/uapi
  /usr/include/bpf/uapi/linux
  /usr/include/bpf/uapi/linux/compiler.h
  /usr/include/bpf/uapi/linux/err.h
  /usr/include/bpf/uapi/linux/filter.h
  /usr/include/bpf/uapi/linux/kernel.h
  /usr/include/bpf/uapi/linux/list.h
  /usr/include/bpf/uapi/linux/overflow.h
  /usr/include/bpf/uapi/linux/ring_buffer.h
  /usr/include/bpf/uapi/linux/types.h
  /usr/include/bpf/xsk.h
  /usr/lib64/libbpf.so
  /usr/lib64/pkgconfig/libbpf.pc
---
 libbpf.spec | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/libbpf.spec b/libbpf.spec
index 5d0f29718cac..681800c7f93e 100644
--- a/libbpf.spec
+++ b/libbpf.spec
@@ -4,7 +4,7 @@
 
 Name:           %{githubname}
 Version:        %{githubver}
-Release:        2%{?dist}
+Release:        3%{?dist}
 Summary:        Libbpf library
 
 License:        LGPLv2 or BSD
@@ -48,6 +48,8 @@ developing applications that use %{name}
 
 %install
 %make_install -C ./src %{make_flags}
+install -d -m 755  %{buildroot}/usr/include/bpf/uapi/linux
+cp include/linux/* %{buildroot}/usr/include/bpf/uapi/linux
 
 %files
 %{_libdir}/libbpf.so.%{version}
@@ -62,6 +64,9 @@ developing applications that use %{name}
 %{_libdir}/libbpf.a
 
 %changelog
+* Wed Oct 02 2019 Jiri Olsa <jolsa@redhat.com> - 0.0.3-3
+- Add uapi headers
+
 * Wed Sep 25 2019 Jiri Olsa <jolsa@redhat.com> - 0.0.3-2
 - Fix libelf linking (BZ#1755317)
 
-- 
2.21.0

