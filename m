Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C72B18D50E
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 17:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727456AbgCTQ4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 12:56:12 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:45988 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727101AbgCTQ4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 12:56:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584723371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=0Dog7Bihu/EtIkqW4Ws4dWoROrng8jKbNX56m++cX6U=;
        b=PnURID3n42TCyF2thf1EDMRz9FPF51aYUxiQSwNGRelZ199mBTKEWyKPHzIi91wrSyh9og
        azBnlIPycoaqBBznKMLmb8Gd5eIBjWaBXUG6+2vZjyA7Phzsb92g/cCndAdqboUwNz2K/1
        0+l/xeUT0xWwR2t5anWOUoc8S2LDXaQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-7jJTUIKKPDWqMNjzD2kpBA-1; Fri, 20 Mar 2020 12:56:10 -0400
X-MC-Unique: 7jJTUIKKPDWqMNjzD2kpBA-1
Received: by mail-wr1-f70.google.com with SMTP id d17so2901928wrw.19
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 09:56:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=0Dog7Bihu/EtIkqW4Ws4dWoROrng8jKbNX56m++cX6U=;
        b=d1uttoYRpjVchSWqaeCe9QZr3QgBe0TpoJdu16zlig5BDqrMtdvr4e9LUllytFa2+s
         dAoYGR7sQk1F8r2pnUfzpbkra/3nsdKS0NK3JVq5aOdZBydn0mgos/YccrWxiGGB4Hm/
         K82iyRsUoivgaJjLbj7UV8i+934Lx9xHfVTyXW1iYT+pfCSd7chH/F8jZzEoSHTp6N8J
         YML+zw7oEBrEzHgAgkDoOwTQfMzw/aN34H0ale3Jt+AFn7bAb3yiHNghWraYp5cDHHLr
         FDNdMJE+0VQ7tWN0njWlEYHYjIErQhBgPrqTZMlQ4vxpnHMoeEWsGdGg7UCnWcPgyQR3
         eW/w==
X-Gm-Message-State: ANhLgQ3SijMwzjlrL6PEUS0xFonn4Ao8YAeY3eSSxwIBG526ow4J6+1L
        gVjlKFXANQsV5+9H5qGy+ke6NbWYLKP4MffAccctjR2jwgpk5FQjl9HxlhptuHXv7lsbaH8rreU
        lAZkZ5imVBmGIdOkT
X-Received: by 2002:a7b:c08a:: with SMTP id r10mr11128379wmh.130.1584723369175;
        Fri, 20 Mar 2020 09:56:09 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuwnC1MjfCP56QbU/oSMYcrjbejzGjrLIhpH6bRbAERBK9s05zy6jTJACfMejmrSUPUp5/KZQ==
X-Received: by 2002:a7b:c08a:: with SMTP id r10mr11128356wmh.130.1584723368974;
        Fri, 20 Mar 2020 09:56:08 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id l17sm2491615wrm.57.2020.03.20.09.56.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 09:56:08 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8E2F2180371; Fri, 20 Mar 2020 17:56:07 +0100 (CET)
Subject: [PATCH bpf-next v2 0/4] XDP: Support atomic replacement of XDP
 interface attachments
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Fri, 20 Mar 2020 17:56:07 +0100
Message-ID: <158472336748.296548.5028326196275429565.stgit@toke.dk>
User-Agent: StGit/0.22
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for atomically replacing the XDP program loaded on an
interface. This is achieved by means of a new netlink attribute that can specify
the expected previous program to replace on the interface. If set, the kernel
will compare this "expected fd" attribute with the program currently loaded on
the interface, and reject the operation if it does not match.

With this primitive, userspace applications can avoid stepping on each other's
toes when simultaneously updating the loaded XDP program.

Changelog:

v2:
- Fix checkpatch nits and add .strict_start_type to netlink policy (Jakub)

---

Toke Høiland-Jørgensen (4):
      xdp: Support specifying expected existing program when attaching XDP
      tools: Add EXPECTED_FD-related definitions in if_link.h
      libbpf: Add function to set link XDP fd while specifying old fd
      selftests/bpf: Add tests for attaching XDP programs


 include/linux/netdevice.h                          |  2 +-
 include/uapi/linux/if_link.h                       |  4 +-
 net/core/dev.c                                     | 26 ++++++++--
 net/core/rtnetlink.c                               | 13 +++++
 tools/include/uapi/linux/if_link.h                 |  4 +-
 tools/lib/bpf/libbpf.h                             |  2 +
 tools/lib/bpf/libbpf.map                           |  1 +
 tools/lib/bpf/netlink.c                            | 22 ++++++++-
 .../testing/selftests/bpf/prog_tests/xdp_attach.c  | 55 ++++++++++++++++++++++
 9 files changed, 120 insertions(+), 9 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_attach.c

