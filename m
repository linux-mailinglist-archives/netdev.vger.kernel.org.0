Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC7AC69FCD
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 02:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732984AbfGPA07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 20:26:59 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34895 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731522AbfGPA07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 20:26:59 -0400
Received: by mail-pg1-f194.google.com with SMTP id s1so2194663pgr.2;
        Mon, 15 Jul 2019 17:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fwlK1M4fb2tkuo8+0jNRCqdoKJePblfDoWTGTO4DzYw=;
        b=SaHFFy42TwDuAX36P3ETxVA9V3oMokG7G8271mlpnq5rKm01Nt99O/gAJgDL3xnYY+
         yv4GT5Gh+ZhQPHUJUnwJ0EHeskw6Zvb2+ExBUxkc2BHjWq/tq1OsTfdLcaMpwWWzQaJO
         X1IA3TlrJmGHNn6Fp+6P5VpX3qHuG5BRAAqKfIFZ6AgyEvtNZHi3lYyvvdI9RxQO2oOt
         l/ElBW6aljlxn7tivwbju/iiyg2tYCAKlnmga0mksvtwRPZtC9OOVMa0gIH8lJ53ZDMq
         VhQcKZ1tRw0rR4Bajoc3/L/FTfcv6rmFMiHjrPCBSeOZQ0PfcVZJOFF8nNLFGG8HJcmO
         q0yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fwlK1M4fb2tkuo8+0jNRCqdoKJePblfDoWTGTO4DzYw=;
        b=GSzt8LTlt5CoVfb4/jbWpSDDJoidgYyAFwzOphDYQI6xaEzjFWSx4mBCv8h/nyfJ0I
         BqkyhoDxpSC7OtwjXPMktmNh+qYGdnrOVoSMsWLjJWyxZEN0+ZYf5tkCyZ1qHH6R3jnU
         okBfop2I/6SsMobDlTmjUyf7Ii3Uisy9VfiNAmkRQobSphVmMDV2osssVbw2OuFoHVPV
         vNR1qA+d6wzP6gghp/b6ppHLRVTxucztZzdRea+dfanp0TBiwfcMKvyV9UdMPkdTBOqr
         z2gwG25L6OyVUPRj3mYxrI6xNV7v4BjE3e+b6f6nM2KpcX52Xwx0GMX+MZhEXxRzR+46
         H25A==
X-Gm-Message-State: APjAAAXaS5GmY3D0UhIzevXbLLCntTbaw68KdpPxKxlSaAl2wtDc8m9I
        IOexcmJtiDqApARV9jjxAwMqkH49
X-Google-Smtp-Source: APXvYqxYPEIAfM+8Lbk/jp1LepWH8ykLD62QEwsayiTpGoMjMe5aMcWokCnRpKfqPuo8PnPHC7mERw==
X-Received: by 2002:a17:90a:35e6:: with SMTP id r93mr32587029pjb.20.1563236818448;
        Mon, 15 Jul 2019 17:26:58 -0700 (PDT)
Received: from ppenkov.svl.corp.google.com ([2620:15c:2c4:201:7bd4:4f27:abe4:d695])
        by smtp.gmail.com with ESMTPSA id q24sm16775444pjp.14.2019.07.15.17.26.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 17:26:58 -0700 (PDT)
From:   Petar Penkov <ppenkov.kernel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        edumazet@google.com, lmb@cloudflare.com, sdf@google.com,
        Petar Penkov <ppenkov@google.com>
Subject: [bpf-next RFC 0/6] Introduce a BPF helper to generate SYN cookies
Date:   Mon, 15 Jul 2019 17:26:44 -0700
Message-Id: <20190716002650.154729-1-ppenkov.kernel@gmail.com>
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petar Penkov <ppenkov@google.com>

This patch series introduces a BPF helper function that allows generating SYN
cookies from BPF.

The first two patches in the series modify several TCP helper functions to
allow for SKB-less operation, as is the case with XDP.

The third patch introduces the bpf_tcp_gen_syncookie helper function which
generates a SYN cookie for either XDP or TC programs. 

The last three patches sync tools/ and add a test. 

The primary design consideration I see in the patch series is the return value
of the helper function. Currently bpf_tcp_gen_syncookie returns a 64-bit value
that contains both the 32-bit syncookie, and the 16-bit mss value which is
encoded in the cookie. On error, it would return a negative value instead. I
chose this over writing the cookie into the provided TCP packet to avoid writing
packet data as currently if a helper changes the packet data, the first argument
has to point to the context (can this be relaxed?). 

To make the API cleaner we can instead return something like the struct below
though the return type would then not really be RET_INTEGER or any of the
currently existing return types.
struct bpf_syncookie {
	u16 error; // or u8 error, u8 unused for future use
	u16 mss;
	u32 syncookie;
}

Petar Penkov (6):
  tcp: tcp_syn_flood_action read port from socket
  tcp: add skb-less helpers to retrieve SYN cookie
  bpf: add bpf_tcp_gen_syncookie helper
  bpf: sync bpf.h to tools/
  selftests/bpf: bpf_tcp_gen_syncookie->bpf_helpers
  selftests/bpf: add test for bpf_tcp_gen_syncookie

 include/net/tcp.h                             | 11 +++
 include/uapi/linux/bpf.h                      | 30 ++++++-
 net/core/filter.c                             | 62 +++++++++++++
 net/ipv4/tcp_input.c                          | 87 +++++++++++++++++--
 net/ipv4/tcp_ipv4.c                           |  8 ++
 net/ipv6/tcp_ipv6.c                           |  8 ++
 tools/include/uapi/linux/bpf.h                | 37 +++++++-
 tools/testing/selftests/bpf/bpf_helpers.h     |  3 +
 .../bpf/progs/test_tcp_check_syncookie_kern.c | 28 ++++--
 .../bpf/test_tcp_check_syncookie_user.c       | 61 +++++++++++--
 10 files changed, 313 insertions(+), 22 deletions(-)

-- 
2.22.0.510.g264f2c817a-goog

