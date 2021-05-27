Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C7939241F
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 03:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233387AbhE0BNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 21:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbhE0BNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 21:13:42 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C5BC061574;
        Wed, 26 May 2021 18:12:09 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 6so2434940pgk.5;
        Wed, 26 May 2021 18:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WoNF6hLx6jB4LaIfSRfhN9vxeSN8aKr789qteHGDr68=;
        b=mmn4kn0UL8n8cTmuUcXRA9RGLU27e40bYDZF6fBqY1Gkl5paO92FOb5eh9A62KfHw+
         HUux/maoOmmn6FCa0dtMkfFgJD6MFVBg92QfYbojzs5huU901Sli5vkG8Wo1Z1rKPL8O
         qsD73qtY1r+Xie3Ypg8gzuZNpwCv3yp05JrAJDyWYqiJIpElQM6E+RXdYxTL2w5Ooigo
         wQDOShonQBu7p991xRq8ud7Jx34rN0xLMqTqKEr1an2rKWg500nAGy62Xwb9MKQ5b6po
         jU+jIgDQoRp+Vjn6nbi+mWm8M3EuByvZkhSMcMZBzNobDcfTLFHQwBsBhPls69mcApXV
         b2UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WoNF6hLx6jB4LaIfSRfhN9vxeSN8aKr789qteHGDr68=;
        b=SK0yGqx19G+WQQ5RndPC+7D6n8n6TGxmIy5w8crodeCh31ObHagBvAO2mbojj0b0zm
         7baZsz77PSuc2FFjjnri5R1X7rny0tLjGCxBTfU/IAX6ThzmyJrAT2cRZ+ATEwBeiQr+
         gqGdPjg6FzpXMOUNLKUAqtPtcp/DreaM3hcdvfxD2z0xxzF4UBGk5mcw3/jVyfIezBgY
         HXEJTya74c1zMAw/kFgGGgX8F3ERg1Be9jv/LpXl5Xi/qqwOUJEkrFOe5i4kaJFPCh1t
         rF072WE8uwyOmmPfwtOI1mFFEpQmChAYLYHWGB4eyQdDWKdA6QHaCT2Wsrh4yjgoLepu
         gAog==
X-Gm-Message-State: AOAM530tmBTDZRTXaJC/eP24xGLrr1lysiXTSX5FnEZY6jTT5gUdssuh
        S+H48il1VDd+XUg04sGr9AujNn8RtLVf1g==
X-Google-Smtp-Source: ABdhPJyDaCF3tAs9gU7hCKFQfbjJqJeBaZrVo4A4l//SEIxP0ej6o7AjliieCPoyXOg+lIAEnaew2Q==
X-Received: by 2002:aa7:88c3:0:b029:2e3:d6dc:7c6f with SMTP id k3-20020aa788c30000b02902e3d6dc7c6fmr1198779pff.35.1622077929211;
        Wed, 26 May 2021 18:12:09 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:991:63cd:5e03:9e3a])
        by smtp.gmail.com with ESMTPSA id n21sm360282pfu.99.2021.05.26.18.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 18:12:08 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf v3 0/8] sock_map: some bug fixes and improvements
Date:   Wed, 26 May 2021 18:11:47 -0700
Message-Id: <20210527011155.10097-1-xiyou.wangcong@gmail.com>
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
failure rate of the UDP test case goes down from 10% to 1%.

Patch 3 is memory leak fix I posted, no change since v1. The rest
patches address similar memory leaks or improve error handling,
including one increases sk_drops counter for error cases. Please
check each patch description for more details.

---
v3: add another bug fix as patch 4
    update patch 5 accordingly
    address John's review on the last patch
    fix a few typos in patch descriptions

v2: group all patches together
    set max for retries of EAGAIN

Cong Wang (8):
  skmsg: improve udp_bpf_recvmsg() accuracy
  selftests/bpf: Retry for EAGAIN in udp_redir_to_connected()
  udp: fix a memory leak in udp_read_sock()
  skmsg: clear skb redirect pointer before dropping it
  skmsg: fix a memory leak in sk_psock_verdict_apply()
  skmsg: teach sk_psock_verdict_apply() to return errors
  skmsg: pass source psock to sk_psock_skb_redirect()
  skmsg: increase sk->sk_drops when dropping packets

 include/linux/skmsg.h                         |  2 -
 net/core/skmsg.c                              | 82 +++++++++----------
 net/ipv4/tcp_bpf.c                            | 24 +++++-
 net/ipv4/udp.c                                |  2 +
 net/ipv4/udp_bpf.c                            | 47 +++++++++--
 .../selftests/bpf/prog_tests/sockmap_listen.c |  7 +-
 6 files changed, 112 insertions(+), 52 deletions(-)

-- 
2.25.1

