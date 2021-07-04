Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63843BAE7D
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 21:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhGDTFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 15:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbhGDTFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 15:05:42 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5AF3C061574;
        Sun,  4 Jul 2021 12:03:06 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id 11so18320082oid.3;
        Sun, 04 Jul 2021 12:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0gFQKmLg5gxqbNPzlX5yQKUjc+GqritKMy7EfYLzw0M=;
        b=FBzl7BflcBaD5IzCL8bhLgzNGwi8HR9yW2tXY2ibYpsg5pfHS9vMkLv6oOBNFFAZEz
         afvlIndvArYCBaxG8LZqROW4dnu6uU9W3jN5LSCv/RW3DxsMIctQlOO3255ReDgc5ggm
         1Lcwf3IZ3y5MiTKfa88f7HFDzw9QALA5TMMxz/lCHna8usRIVWS+S5jdwOrKOEOlYpQn
         7ifCTIJOEjT1nASV9bD5WrAijo3dcGrnOtomDO8Clfa8qYHIA1xBTP/emOOMeHdiEMC3
         xCNcKf566S2hQOTHBWFIUQ3d5jrjFTUAO4HDxGPYAc6vIKTvExDg+esMuRoG1/5KHTtx
         RiqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0gFQKmLg5gxqbNPzlX5yQKUjc+GqritKMy7EfYLzw0M=;
        b=bNSykFW/hAAWffjRNPUNnpBl8C5FdWWDSF8AbWX5Q+oBof+4yNTj8HAIuFPmIr5mMJ
         Fi627aZeAql0p7PvSwZD0k+6mWyrhAbYzPTM8RxhGgGssLStIqVdXHUUe+4WcHwem0dA
         Axxj/E3VFU9x2frWWBdl1WS4Lx8hafSfgeOeAzN1N4thPCLmqfLccK7E35kmfSPLzWTL
         /v1tg1xeEL+aF7FOmLgdtol7QpfhBwcm56yOOAETgBOxxMBby1HI4TZOWwjvRu+uL1OI
         CNbNJ/L9kVWNoTukp0bpFvdj/NmHMuj5KiNtx7oyqlTD+oLGzJA1ffXNzoN4OcGQ51Nf
         Rdfw==
X-Gm-Message-State: AOAM5338J1wpj31ymnbrOmkCer2yi65R2rGzUbYN3eXhXSn5CIf0hbzj
        IQE/0XpSJdXc6gJCt601mZeIGoDYH8E=
X-Google-Smtp-Source: ABdhPJxP1zx0Cwqxn4nWQQej2dqoh3Ud+UOu+ZWgEsjGMmNPC+GtgvnPdmiNqu/D01/1egGX15WK5g==
X-Received: by 2002:aca:f105:: with SMTP id p5mr7361392oih.141.1625425386089;
        Sun, 04 Jul 2021 12:03:06 -0700 (PDT)
Received: from unknown.attlocal.net (76-217-55-94.lightspeed.sntcca.sbcglobal.net. [76.217.55.94])
        by smtp.gmail.com with ESMTPSA id 186sm1865848ooe.28.2021.07.04.12.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jul 2021 12:03:05 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: [PATCH bpf-next v5 00/11] sockmap: add sockmap support for unix datagram socket
Date:   Sun,  4 Jul 2021 12:02:41 -0700
Message-Id: <20210704190252.11866-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

This is the last patchset of the original large patchset. In the
previous patchset, a new BPF sockmap program BPF_SK_SKB_VERDICT
was introduced and UDP began to support it too. In this patchset,
we add BPF_SK_SKB_VERDICT support to Unix datagram socket, so that
we can finally splice Unix datagram socket and UDP socket. Please
check each patch description for more details.

To see the big picture, the previous patchsets are available here:
https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=1e0ab70778bd86a90de438cc5e1535c115a7c396
https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=89d69c5d0fbcabd8656459bc8b1a476d6f1efee4

and this patchset is available here:
https://github.com/congwang/linux/tree/sockmap3

---
v5: lift socket state check for dgram
    remove ->unhash() case
    add retries for EAGAIN in all test cases
    remove an unused parameter of __unix_dgram_recvmsg()
    rebase on the latest bpf-next

v4: fix af_unix disconnect case
    add unix_unhash()
    split out two small patches
    reduce u->iolock critical section
    remove an unused parameter of __unix_dgram_recvmsg()

v3: fix Kconfig dependency
    make unix_read_sock() static
    fix a UAF in unix_release()
    add a missing header unix_bpf.c

v2: separate out from the original large patchset
    rebase to the latest bpf-next
    clean up unix_read_sock()
    export sock_map_close()
    factor out some helpers in selftests for code reuse

Cong Wang (11):
  sock_map: relax config dependency to CONFIG_NET
  sock_map: lift socket state restriction for datagram sockets
  af_unix: implement ->read_sock() for sockmap
  af_unix: set TCP_ESTABLISHED for datagram sockets too
  af_unix: add a dummy ->close() for sockmap
  af_unix: implement ->psock_update_sk_prot()
  af_unix: implement unix_dgram_bpf_recvmsg()
  selftests/bpf: factor out udp_socketpair()
  selftests/bpf: factor out add_to_sockmap()
  selftests/bpf: add a test case for unix sockmap
  selftests/bpf: add test cases for redirection between udp and unix

 MAINTAINERS                                   |   1 +
 include/linux/bpf.h                           |  38 +-
 include/net/af_unix.h                         |  12 +
 kernel/bpf/Kconfig                            |   2 +-
 net/core/Makefile                             |   2 -
 net/core/sock_map.c                           |  22 +-
 net/ipv4/udp_bpf.c                            |   1 -
 net/unix/Makefile                             |   1 +
 net/unix/af_unix.c                            |  85 +++-
 net/unix/unix_bpf.c                           | 122 ++++++
 .../selftests/bpf/prog_tests/sockmap_listen.c | 406 ++++++++++++++----
 11 files changed, 564 insertions(+), 128 deletions(-)
 create mode 100644 net/unix/unix_bpf.c

-- 
2.27.0

