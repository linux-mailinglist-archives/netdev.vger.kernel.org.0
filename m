Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83173264F2B
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbgIJThW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbgIJTfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:35:39 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB1DC061573
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:35:38 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id v123so7291307qkd.9
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G5mR7sqa3OMkADCrSlmWh0HWvg0TPMzltXKkfho0ibw=;
        b=pBPD/GDd97hSYukOY748i4Yn4mf0Ek7FR1z1mSIQgQZpaC/AZ4uLhxiZ5murc+GCPC
         SvB0oP4yOxkBIYz42iyjPQHj896rhPqOelTH4tAf0nLzE7X2L3GVnit3zKi2P2jLuig3
         zEPkKSyLKcxCeZiKLDlpwEsQY/QcQ4t9gklTz8yksChnI8MttMvkqL6F03v8DRp0cii0
         aY1chbb/uUIGgQtxL9hxEh4mFpEkNhoWm7FHXPWfae9h28jqTZh6e4loluTKO+7yXQs/
         VHCjv2HhZAJOtGmFkiVCpYWMOnB/byDdMKl8/CjS9yvC6mHKjqgOj80l/fkcuiEx33zm
         w+DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G5mR7sqa3OMkADCrSlmWh0HWvg0TPMzltXKkfho0ibw=;
        b=YvJZgXLr+nl6xBEM1UnVqFEzKV7RtuXjn4Z/JROwWo4NW052LybvbzyHyYmzuwQcWO
         P3bomxZU+LcZCR2UGTNz+h4wGp93EmAt6WQQVMx51Xy0NYBikFn6IAxHhp/okjchRY2q
         4HeZqtEHy3LlFsT+lM7nV3XgsJ8K/fflJ2eBe1/6ef1aJ2Pw7e/zh1NKTzhvOQGL1qRA
         +0cF2eQmgrmT0Ia7i86KLJWJoao7ikBz2Xm/aZaGNCY9ru74rVR4NEKlBirvCDorPmWF
         wwsxee7FDbJGSNks7TTdvGtkDV+cWApJkYFhsxWt25YW3ijkGaX+nRrq/ahUZQdh9rF5
         YWVw==
X-Gm-Message-State: AOAM532aP0X4emzUdWU9p8B37SlmIcYrCti6Xw33sYaydFea8EBco0f4
        MgzWm3DJY7ZN+th+4LVUaDPSBmOAOJsBBTD3
X-Google-Smtp-Source: ABdhPJz2mPE4kDl8hASrKUqaANBmwHgqx6QfPlwJpR5eXx7/kXuaZzU/jTP6+hxV8YOAutVWaOM89g==
X-Received: by 2002:a37:6595:: with SMTP id z143mr9921427qkb.244.1599766538171;
        Thu, 10 Sep 2020 12:35:38 -0700 (PDT)
Received: from soy.nyc.corp.google.com ([2620:0:1003:312:7220:84ff:fe09:3008])
        by smtp.gmail.com with ESMTPSA id f13sm7735484qko.122.2020.09.10.12.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 12:35:37 -0700 (PDT)
From:   Neal Cardwell <ncardwell.kernel@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, Neal Cardwell <ncardwell@google.com>
Subject: [PATCH bpf-next v3 0/5] tcp: increase flexibility of EBPF congestion control initialization
Date:   Thu, 10 Sep 2020 15:35:31 -0400
Message-Id: <20200910193536.2980613-1-ncardwell.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neal Cardwell <ncardwell@google.com>

This patch series reorganizes TCP congestion control initialization so that if
EBPF code called by tcp_init_transfer() sets the congestion control algorithm
by calling setsockopt(TCP_CONGESTION) then the TCP stack initializes the
congestion control module immediately, instead of having tcp_init_transfer()
later initialize the congestion control module.

This increases flexibility for the EBPF code that runs at connection
establishment time, and simplifies the code.

This has the following benefits:

(1) This allows CC module customizations made by the EBPF called in
    tcp_init_transfer() to persist, and not be wiped out by a later
    call to tcp_init_congestion_control() in tcp_init_transfer().

(2) Does not flip the order of EBPF and CC init, to avoid causing bugs
    for existing code upstream that depends on the current order.

(3) Does not cause 2 initializations for for CC in the case where the
    EBPF called in tcp_init_transfer() wants to set the CC to a new CC
    algorithm.

(4) Allows follow-on simplifications to the code in net/core/filter.c
    and net/ipv4/tcp_cong.c, which currently both have some complexity
    to special-case CC initialization to avoid double CC
    initialization if EBPF sets the CC.

changes in v2:

o rebase onto bpf-next

o add another follow-on simplification suggested by Martin KaFai Lau:
   "tcp: simplify tcp_set_congestion_control() load=false case"

changes in v3:

o no change in commits

o resent patch series from @gmail.com, since mail from ncardwell@google.com
  stopped being accepted at netdev@vger.kernel.org mid-way through processing
  the v2 patch series (between patches 2 and 3), confusing patchwork about
  which patches belonged to the v2 patch series

Neal Cardwell (5):
  tcp: only init congestion control if not initialized already
  tcp: simplify EBPF TCP_CONGESTION to always init CC
  tcp: simplify tcp_set_congestion_control(): always reinitialize
  tcp: simplify _bpf_setsockopt(): remove flags argument
  tcp: simplify tcp_set_congestion_control() load=false case

 include/net/inet_connection_sock.h |  3 ++-
 include/net/tcp.h                  |  2 +-
 net/core/filter.c                  | 18 ++++--------------
 net/ipv4/tcp.c                     |  3 ++-
 net/ipv4/tcp_cong.c                | 27 +++++++--------------------
 net/ipv4/tcp_input.c               |  4 +++-
 6 files changed, 19 insertions(+), 38 deletions(-)

-- 
2.28.0.618.gf4bc123cb7-goog

