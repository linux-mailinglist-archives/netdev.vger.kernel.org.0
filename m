Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E534E18B4DB
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 14:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729126AbgCSNNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 09:13:19 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:35056 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729134AbgCSNNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 09:13:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584623596;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=/JXninvH+RdnStJw90/1R2Gh04fLw+7yo4mXtcZuoRo=;
        b=fqI3TVT6y1j1sKhyMZI0Kd3SDM/6O1utwlvjNTwLFvsybyXYJzBYJu/ZnqmvWQZWg8z7w4
        nZP1pnweDv2yafDIcyd30WKCO7hSEmL3OWdi24H09BBIZ0yLZpKVy1K5vWpZkb+Zwgf82z
        Vnf03BDiQ0qmomvKjLUepAcYtvAxub0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-6aeYBSaAPx6_ceT_EIoPKw-1; Thu, 19 Mar 2020 09:13:14 -0400
X-MC-Unique: 6aeYBSaAPx6_ceT_EIoPKw-1
Received: by mail-wm1-f71.google.com with SMTP id n25so974831wmi.5
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 06:13:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=/JXninvH+RdnStJw90/1R2Gh04fLw+7yo4mXtcZuoRo=;
        b=OYL3hXZ1DxOo66cCPpP+SwHiQ1dM95goGor7IcpGGnIuRl+rYo2vinI4VoHwdlYdSV
         g5JBGoyYkuwjEHVBM7GEeiHH30Usk1u8JVa5dme9PeUSHBhREKhApXz9hNO2gTH5yQrq
         SDxcRJABQVMXu2Y0/d8CJ49AmtLEhAqQiX2gPSJq+2uEO3M0HhHsqK34SoWvCdGvKyoo
         koBVQjS8Ll7jQ/R+/ThhDuhrsFK7EiZ9FPWboawX2BTdETzvWjeHz7FbMsDLc+IUwDEX
         wk7UElHrJsrV8vq3w7q6dEipblFHXMGjry+rRrZ6dzi7mSFcrJBNb6XER76uQSRat45Q
         JdtA==
X-Gm-Message-State: ANhLgQ0sy3E1L+FBqACbc6BHMqsMe6kWQQ2C6SypV+LpV8cTaeIJ0mVp
        6H+3R6npOLAOocY1Z3EoYztNgGN2xCoHQsLJTfZCFmziUn+hubmi4R/me/7MsW1G17w3wKlDgYK
        76c2EBt4xywu659IM
X-Received: by 2002:a05:6000:10c6:: with SMTP id b6mr4195809wrx.130.1584623593595;
        Thu, 19 Mar 2020 06:13:13 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsHs7Csf5zw3jTuAfcePVNSFZzN1H/mq5k3NBtrL03r2aaKDqaLsbrQPFLeKHjc4oDSFFTKfg==
X-Received: by 2002:a05:6000:10c6:: with SMTP id b6mr4195781wrx.130.1584623593428;
        Thu, 19 Mar 2020 06:13:13 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id r3sm3588487wrw.76.2020.03.19.06.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 06:13:12 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 24A9C180371; Thu, 19 Mar 2020 14:13:12 +0100 (CET)
Subject: [PATCH bpf-next 0/4] XDP: Support atomic replacement of XDP interface
 attachments
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
Date:   Thu, 19 Mar 2020 14:13:12 +0100
Message-ID: <158462359206.164779.15902346296781033076.stgit@toke.dk>
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

---

Toke Høiland-Jørgensen (4):
      xdp: Support specifying expected existing program when attaching XDP
      tools: Add EXPECTED_FD-related definitions in if_link.h
      libbpf: Add function to set link XDP fd while specifying old fd
      selftests/bpf: Add tests for attaching XDP programs


 include/linux/netdevice.h                          |  2 +-
 include/uapi/linux/if_link.h                       |  4 +-
 net/core/dev.c                                     | 25 ++++++++--
 net/core/rtnetlink.c                               | 11 +++++
 tools/include/uapi/linux/if_link.h                 |  4 +-
 tools/lib/bpf/libbpf.h                             |  2 +
 tools/lib/bpf/libbpf.map                           |  1 +
 tools/lib/bpf/netlink.c                            | 22 ++++++++-
 .../testing/selftests/bpf/prog_tests/xdp_attach.c  | 55 ++++++++++++++++++++++
 9 files changed, 117 insertions(+), 9 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_attach.c

