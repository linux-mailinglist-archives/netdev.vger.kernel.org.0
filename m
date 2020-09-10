Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFF5264E9E
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgIJTVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727853AbgIJTUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:20:55 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD14C061573
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:20:55 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id p65so5802765qtd.2
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xFR2Yl1VXmUkltXiUiHvDrYe5v/sEn4ViY0MFETLCp0=;
        b=unx0f9IHD+HLkMwZIE8jJ94bPJiVVtq0i5+HSBlZgNsbn2UxPQPtPVFjEBl6RHhlWU
         nR9qM5Qv0pONuO4yIwsfGqEsoTuh2+9tJkt3MYkuMjclAqucSyydqL1hHPxpgtvwIbyj
         eLiRNPzcDVSYvLNqOno5kwxlCeeQsVru1PjDNYSBCPpKy+C7cwisJG0V5OlDpjEAWER0
         Mv/rroad12gd4Uk8/bHq7CFjC9FdTWx/eSDNHlM26hrrqkkBt43zFt8JPz2J3THHEXZx
         cVnYzyD6qOZw9U9zOmU5Sn7tHBKrKKRLP51sV9b5Tckuga4+dxSVcGXagB20PYpy5dw9
         gB2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xFR2Yl1VXmUkltXiUiHvDrYe5v/sEn4ViY0MFETLCp0=;
        b=isKNZPDxfUqObD9dDI0SdbQ0GG2lclUI0hoyHrilN6bE5JhvcRGScugqZkCsaY3dJQ
         Ml3cvD/AxVVaa4iT4MS4rElcviCcQC5FFaIFZcDffAkBOOX/u4cbj+dukrdMuYfyckUZ
         JeHqXsbCI29A3HYJg84rFShu7qYEWQCRJ8Yq2mowyv7QLD0crjPuOuc1WOXFo44cfUWn
         c4etwdIreUELDtGQCkgJxnL9N1yw5M//40wbja4amB6i6wf4lCiv53ZAbdpxPrNzkpLY
         KPW11H/EawxiDmZJoHdmGy334BJoIxOAxrr1nJbhUAOEncCmJ9cAMRtKLEsQSnRVv3by
         YDrQ==
X-Gm-Message-State: AOAM533LcZOnFApTjLw0sTafOAGy6iJwQ6dx0RSEeHoyyhzNd2TbT2QX
        /8qCrl9G8KWzCVtzH2kTt2I=
X-Google-Smtp-Source: ABdhPJxzxVLbCOdrzkuKftmAC6TWHR1xlwm7tkCKYhYnXKuLBsSw4pYG6vDsIqT3KdMMJYwObS9KeQ==
X-Received: by 2002:ac8:1c43:: with SMTP id j3mr9562393qtk.302.1599765654579;
        Thu, 10 Sep 2020 12:20:54 -0700 (PDT)
Received: from soy.nyc.corp.google.com ([2620:0:1003:312:7220:84ff:fe09:3008])
        by smtp.gmail.com with ESMTPSA id z6sm7315158qkl.39.2020.09.10.12.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 12:20:54 -0700 (PDT)
From:   Neal Cardwell <ncardwell.kernel@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, Neal Cardwell <ncardwell@google.com>
Subject: [PATCH bpf-next v2 0/5] tcp: increase flexibility of EBPF congestion control initialization
Date:   Thu, 10 Sep 2020 15:20:51 -0400
Message-Id: <20200910192053.2884884-1-ncardwell.kernel@gmail.com>
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
2.28.0.526.ge36021eeef-goog

