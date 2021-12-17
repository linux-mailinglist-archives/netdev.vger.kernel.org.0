Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99C48478141
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 01:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbhLQA14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 19:27:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54938 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230508AbhLQA1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 19:27:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639700875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=sGiY06eJUnJelowV0duRk6M7Xu4oJBxXzdoeEDXuknA=;
        b=EZEOBqJzo81ALMHR6XT5OtTn/x0AQS7HHUOBHLpZJTmXSGmvCz4hBUkTHJVPLOqEBHm6q3
        OQDlHtombrn6W49fFePCo4hP9WOngEM/F3DbPlJYeUqLfWyBZTFLafSN3Qha7TSNXtOgBg
        yzKyR0nAhRODKl+oQaXQQ+JOkmg2UL0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-294-GxYCroCuNT2ccubfGBcY7w-1; Thu, 16 Dec 2021 19:27:54 -0500
X-MC-Unique: GxYCroCuNT2ccubfGBcY7w-1
Received: by mail-ed1-f69.google.com with SMTP id y17-20020a056402271100b003f7ef5ca612so379913edd.17
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 16:27:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sGiY06eJUnJelowV0duRk6M7Xu4oJBxXzdoeEDXuknA=;
        b=MUKDcZ0HVn0RjNotC3I/LomZ7AY+hdp+ED2WoFQSCupseh7WlQ9nIoUJNquYumpb0u
         i7dwUMD6tKYCYz/Sh/JAOttvVps6txkywKo0MAKCtXN+HK4ZBu96t/gDCZpxYfaqpVNz
         xxlAlFFeXnpnKPk1A18pPqmHDDn8tdbh2+3wElWlpylnubfmCaxXrOVcHhIG2TPlZjN1
         qOkfC0NHF8SwD2iFT6LONozjM9i2gXUaLEmDXE/rV30mSoEVhb8ns0PvHoMmhTcphpMu
         s+4DuL3ME80aNvo3jQWCk3EgY5DYo4yaaEbSXH6FWZjpvhSiAchQ8yFkWuTcM22GQ/S1
         BbQw==
X-Gm-Message-State: AOAM532+g5uhyY0xxTQO0L4sgWxQOevAR5ZTTnJEXUWb3zh289CF+hC/
        JZ3HJuXfX2XILPwZSlrcnhSI+u4LZCY/IB4kIcjo44M376ARDvAlacZSIw0HHQS8YyxGMjy5hes
        X6m+swJNHRsDIPWr6
X-Received: by 2002:a17:906:1db2:: with SMTP id u18mr422991ejh.729.1639700872907;
        Thu, 16 Dec 2021 16:27:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyq84bfJgVqoU58VJi3VeZK2UgRTS9dAmF8c1xE/hAHYZXe/NHZfzssfVfIsAluMfWNuetAOA==
X-Received: by 2002:a17:906:1db2:: with SMTP id u18mr422968ejh.729.1639700872573;
        Thu, 16 Dec 2021 16:27:52 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id dd5sm1985325ejc.59.2021.12.16.16.27.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 16:27:51 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2FFF81802E8; Fri, 17 Dec 2021 01:27:50 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v4 0/7] Add support for transmitting packets using XDP in bpf_prog_run()
Date:   Fri, 17 Dec 2021 01:27:34 +0100
Message-Id: <20211217002741.146797-1-toke@redhat.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for transmitting packets using XDP in
bpf_prog_run(), by enabling a new mode "live packet" mode which will handle
the XDP program return codes and redirect the packets to the stack or other
devices.

The primary use case for this is testing the redirect map types and the
ndo_xdp_xmit driver operation without an external traffic generator. But it
turns out to also be useful for creating a programmable traffic generator
in XDP, as well as injecting frames into the stack. A sample traffic
generator, which was included in previous versions of the series, but now
moved to xdp-tools, transmits up to 11.5 Mpps/core on my test machine.

To transmit the frames, the new mode instantiates a page_pool structure in
bpf_prog_run() and initialises the pages to contain XDP frames with the
data passed in by userspace. These frames can then be handled as though
they came from the hardware XDP path, and the existing page_pool code takes
care of returning and recycling them. The setup is optimised for high
performance with a high number of repetitions to support stress testing and
the traffic generator use case; see patch 6 for details.

The series is structured as follows: Patches 1-5 adds a few features to
page_pool that are needed for the usage in bpf_prog_run() and perform a
couple of preparatory refactorings of the XDP redirect and memory
management code. Patch 6 adds the support to bpf_prog_run() itself and
patch 7 adds a selftest that exercises all the XDP return codes.

v4:
- Fix a few code style issues (Alexei)
- Also handle the other return codes: XDP_PASS builds skbs and injects them
  into the stack, and XDP_TX is turned into a redirect out the same
  interface (Alexei).
- Drop the last patch adding an xdp_trafficgen program to samples/bpf; this
  will live in xdp-tools instead (Alexei).
- Add a separate bpf_test_run_xdp_live() function to test_run.c instead of
  entangling the new mode in the existing bpf_test_run().

v3:
- Reorder patches to make sure they all build individually (Patchwork)
- Remove a couple of unused variables (Patchwork)
- Remove unlikely() annotation in slow path and add back John's ACK that I
  accidentally dropped for v2 (John)

v2:
- Split up up __xdp_do_redirect to avoid passing two pointers to it (John)
- Always reset context pointers before each test run (John)
- Use get_mac_addr() from xdp_sample_user.h instead of rolling our own (Kumar)
- Fix wrong offset for metadata pointer

Toke Høiland-Jørgensen (7):
  xdp: Allow registering memory model without rxq reference
  page_pool: Add callback to init pages when they are allocated
  page_pool: Store the XDP mem id
  xdp: Move conversion to xdp_frame out of map functions
  xdp: add xdp_do_redirect_frame() for pre-computed xdp_frames
  bpf: Add "live packet" mode for XDP in bpf_prog_run()
  selftests/bpf: Add selftest for XDP_REDIRECT in bpf_prog_run()

 include/linux/bpf.h                           |  20 +-
 include/linux/filter.h                        |   4 +
 include/net/page_pool.h                       |  11 +-
 include/net/xdp.h                             |   3 +
 include/uapi/linux/bpf.h                      |   2 +
 kernel/bpf/Kconfig                            |   1 +
 kernel/bpf/cpumap.c                           |   8 +-
 kernel/bpf/devmap.c                           |  32 +-
 net/bpf/test_run.c                            | 287 +++++++++++++++++-
 net/core/filter.c                             |  73 ++++-
 net/core/page_pool.c                          |   6 +-
 net/core/xdp.c                                |  94 ++++--
 tools/include/uapi/linux/bpf.h                |   2 +
 .../bpf/prog_tests/xdp_do_redirect.c          | 118 +++++++
 .../bpf/progs/test_xdp_do_redirect.c          |  39 +++
 15 files changed, 610 insertions(+), 90 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c

-- 
2.34.1

