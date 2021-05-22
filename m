Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059F638D728
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 21:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbhEVTP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 May 2021 15:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbhEVTPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 May 2021 15:15:54 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 949CFC061574;
        Sat, 22 May 2021 12:14:27 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id x18so13186511pfi.9;
        Sat, 22 May 2021 12:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0OXyBjG7qnUD1D3OaIyoOtN17qx/OM0QIPESYVdnBz0=;
        b=Ih2gDswofcH/vVBBTza0W4UKOzKPQrMQ+HF2TfP2J1LpMqei+6e9me81RstWTGDEDQ
         6eatMyg8D7SID8px0ciY6sE2jmYNJpWoJTZCioiUi4ZBej9Napmk2VhiT8yFrpMYWJyL
         beWQ5z0FqVkGt0w8lUaN/UKYXu0oRdC/TlI8Dc0at78SnPF2sqsu9DKvRzmTw5Ywdrqn
         uQkW8UeVZLXbUG1SJm3on0i1TzCOZHzPKnmvO7DgO+lPmh14IbcPqvtSP8ZDR9jWGbkd
         Jan0hzYmf1KB+9r/KKVR0QZmfiJHE9p77Bs6Itw/TwQ4iGIFayxIp/gawpq2UrqNbsXh
         sL1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0OXyBjG7qnUD1D3OaIyoOtN17qx/OM0QIPESYVdnBz0=;
        b=XUsd2HQIHP9YMzj4ejAJK6RxlUE2mnN2lWS1LIrNDlrjImsLAi3HTj/CxJX3NmtRqK
         cOUe6euxjnedvrVBF8h36YABZE+IGSo2nSMdorAfXyGUm6zqYsK7cjyPXx3IGQExGKrx
         ai3nyl19Asru5b5D9q8SL2Cx1acpU1O63UCWWOqvA8LvKd2vjcX8k/uBQNMPgNZwiKn3
         JJwuc6lDwwRNlWFQ1AkSBlWGU8HaPUr1CqdtfJ+HdC5WHRkegWTQP36QtPUiYPPvgZKm
         TiwgDTZp4MIlE23b15zEn5AtF9zmXq0JLGu1dhvqQzrv4kSSSl2xGkFygtXQcPprhfzO
         dfzg==
X-Gm-Message-State: AOAM5325eg12kI6vcUIO/SuJKaVHE3MzQhxdkwwve4zx11d+fmNfz1kK
        etNtTaT8CEIzIvYbM9m929KJsyOTyKf8iA==
X-Google-Smtp-Source: ABdhPJzK4u4BZ7OVudaFeT/NzV+ZEMhkcXR6I+oIChPW6lredScKurF6iDOlO3dasCGHaFE0sjBXTQ==
X-Received: by 2002:a62:1d52:0:b029:2dd:ee:1439 with SMTP id d79-20020a621d520000b02902dd00ee1439mr16257939pfd.57.1621710866378;
        Sat, 22 May 2021 12:14:26 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:14cd:343f:4e27:51d7])
        by smtp.gmail.com with ESMTPSA id 5sm6677531pfe.32.2021.05.22.12.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 May 2021 12:14:26 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf v2 0/7] sock_map: some bug fixes and improvements
Date:   Sat, 22 May 2021 12:14:04 -0700
Message-Id: <20210522191411.21446-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

This patchset contains a few bug fixes and improvements for sock_map.

Patch 1 improves recvmsg() accuracy for UDP, patch 2 improves UDP
non-blocking read() by retrying on EAGAIN. With both of them, the
failure rate of the UDP test case goes down from 10% to 0%.

Patch 3 is memory leak fix I posted, no change since v1. The rest
patches address similar memory leaks or improve error handling,
including one increases sk_drops counter in error cases. Please
check each patch description for more details.

---
Cong Wang (7):
  skmsg: improve udp_bpf_recvmsg() accuracy
  selftests/bpf: Retry for EAGAIN in udp_redir_to_connected()
  udp: fix a memory leak in udp_read_sock()
  skmsg: fix a memory leak in sk_psock_verdict_apply()
  skmsg: teach sk_psock_verdict_apply() to return errors
  skmsg: pass source psock to sk_psock_skb_redirect()
  skmsg: increase sk->sk_drops when dropping packets

 include/linux/skmsg.h                         |  2 -
 net/core/skmsg.c                              | 80 +++++++++----------
 net/ipv4/tcp_bpf.c                            | 24 +++++-
 net/ipv4/udp.c                                |  2 +
 net/ipv4/udp_bpf.c                            | 47 +++++++++--
 .../selftests/bpf/prog_tests/sockmap_listen.c |  7 +-
 6 files changed, 109 insertions(+), 53 deletions(-)

-- 
2.25.1

