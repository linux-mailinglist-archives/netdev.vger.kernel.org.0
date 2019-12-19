Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0B991264AF
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 15:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbfLSO3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 09:29:36 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44718 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726759AbfLSO3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 09:29:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576765775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=XXaL0Ehva81EpX1fgLORIXhqiGmMAsoySk2W7xqmZvc=;
        b=Izvzm/Hhn1xPE6iHmadJbQI9Z+s7gzPVDk9bXkuqGslnaBZ0OqR0AClmjcZ8R1b4VEPTlh
        QamzUujB58s7jSMUA4EUXShazqIF6AQndlB0gJTEcHAiu4oIitBD9V5SUpzFKo2BJPetGf
        B38Au3ptW8ZmWKHdc9AQf49lqQFI8yE=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-jyZ4ZaBYP_Slihgy_BMudw-1; Thu, 19 Dec 2019 09:29:34 -0500
X-MC-Unique: jyZ4ZaBYP_Slihgy_BMudw-1
Received: by mail-lj1-f199.google.com with SMTP id z18so1977975ljm.22
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 06:29:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=XXaL0Ehva81EpX1fgLORIXhqiGmMAsoySk2W7xqmZvc=;
        b=iFNk9x9P/XErisP7VG/WIQ4/QdFy97QHnd5Bl88OSw40sVZ+560zMqXf/yQkcFN4kO
         /6aS+b+dBFePUEPvLdP3XcSEbBddD+2+PVBNgm+3SbiFUm2YYR2jrOxVdBhjkhko1S34
         fEmhHQBuBpfqxaaz9JqAA4+cjQP0eMZWLCv27e03GPFeu+7T11VgX14sv0kwRExYuzdS
         RtiFPu9GlBkgz4zV+BwTYZcCpSqE527Uq8o6g+khrwdzCMnZqsmU2PvNwgFqYGmYhAlX
         nrQWGVChcLb1wg4C+L1lq6bhwdTIVQFGhA3IPthUk53A0O+Lm+L16cieK+L/zWdJK82O
         /mKQ==
X-Gm-Message-State: APjAAAXyLwm76xJTu9upd/aDFAisJjg6cZngBdC1i3vMX8+qChPpPWlM
        yH0Bzlg2700kBjygSk8RCRq2YJ/tEijAINB1khHrbn62Fv0E6y2EzoT0bekkdHRy/XDZaRWMzf/
        waxclM6KdD7Y9XzTB
X-Received: by 2002:a2e:8e72:: with SMTP id t18mr6212560ljk.132.1576765772518;
        Thu, 19 Dec 2019 06:29:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqyWzHIpBrjXnAT0Xq2Y3XNH6XrhBLKBgA/hSFlWsvcUqO1ekrRgkQ3EDYnwqgoLsqjlnQNdfw==
X-Received: by 2002:a2e:8e72:: with SMTP id t18mr6212540ljk.132.1576765772350;
        Thu, 19 Dec 2019 06:29:32 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id v24sm3515868ljc.18.2019.12.19.06.29.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 06:29:31 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 92EED180969; Thu, 19 Dec 2019 15:29:30 +0100 (CET)
Subject: [PATCH RFC bpf-next 0/3] libbpf: Add support for extern function
 calls
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Thu, 19 Dec 2019 15:29:30 +0100
Message-ID: <157676577049.957277.3346427306600998172.stgit@toke.dk>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for resolving function calls to functions marked as
'extern' in eBPF source files, by resolving the function call targets at load
time. For now, this only works by static linking (i.e., copying over the
instructions from the function target. Once the kernel support for dynamic
linking lands, support can be added for having a function target be an already
loaded program fd instead of a bpf object.

The API I'm proposing for this is that the caller specifies an explicit mapping
between extern function names and function names in the target object file.
This is to support the XDP multi-prog case, where the dispatcher program may not
necessarily have control over function names in the target programs, so simple
function name resolution can't be used.

I'm sending this series as an RFC because it's still a bit rough around the
edges: There are several places where I'm handling things in a way I'm pretty
sure is not the right way. And while this works for the simple programs added to
the selftest in patch 3, it fails with more complicated target programs.

My problem is that I don't really know what the right thing to do is for these
things, so I've marked them with FIXME comments in the code, in the hope that
someone more knowledgeable can suggest fixes.

Other regular RFC comments are welcome as well, of course; the API in particular
could use a second set of eyes or two :)

---

Toke Høiland-Jørgensen (3):
      libbpf: Add new bpf_object__load2() using new-style opts
      libbpf: Handle function externs and support static linking
      selftests/bpf: Add selftest for XDP multiprogs


 tools/lib/bpf/btf.c                                |   10 +
 tools/lib/bpf/libbpf.c                             |  299 ++++++++++++++++----
 tools/lib/bpf/libbpf.h                             |   28 ++
 tools/lib/bpf/libbpf.map                           |    1 
 .../selftests/bpf/prog_tests/xdp_multiprog.c       |   52 +++
 tools/testing/selftests/bpf/progs/xdp_drop.c       |   13 +
 tools/testing/selftests/bpf/progs/xdp_multiprog.c  |   26 ++
 7 files changed, 366 insertions(+), 63 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_multiprog.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_drop.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_multiprog.c

