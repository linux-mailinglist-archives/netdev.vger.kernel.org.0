Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBEDD2647C0
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 16:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731025AbgIJOIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 10:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731053AbgIJOEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 10:04:46 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66921C061344
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 07:04:41 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id j35so4220290qtk.14
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 07:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=1yaX4vwGF0AMgM4YczJzPYEiSQuz4+QT3oCMNcyfDQo=;
        b=eqpMioaN24DDoialM/WbdGpI2stAHizjIUpQ6mDJgIeFB4hgWtLbZk5ecKOkoLyOwH
         /KsB4uNV7aT7zXHdhdSiCY3Pu4S5Nw2XWnUFnsnzPoAICGbbULyt8R79ck7jGQZ35P2c
         y/1x2SgPsKECDyD2HNBxnaGqd+Yfoj8mgHGl7An4JRiuV45cZjSTyYS1hSRRAqsD9WsP
         P1ICEGU+geLU/Huk5UmQWMH0gPpHCH9eJcn23h4kAGDWrs21hruYdbNkn5DFB/gZ/wMD
         Fs8u3sIOjDXv6ygp8d6yixOxZD1koSmcbqsEhSLH+8pZDtdXQIsRO7WwuSjlTLeQEDOp
         K+lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=1yaX4vwGF0AMgM4YczJzPYEiSQuz4+QT3oCMNcyfDQo=;
        b=FOWgLJ2QKIr5WGIODZvwg6U0MvJfVzX5uVJnv4mXy3fo8MxiAnjg33GGigM4xDuc45
         QMO64rXxY7mZXBWIyaaSacAsKQSN3YuUF20Cy6WgVeV3fZ9X5T81K6+1iRVGqoI4M++p
         RabIdrUtxiSxEMwkzb4HmIN/mWrbRun2jxdU6Izskv5u49yxfiuzMwbc6M2q/QcNrpmp
         WQtRgTcy7aAGlIdokWvwmnH77c6iFgnwo9bKG7PNS84WcD4FRwZf7XHBdvtwTwhR+V0R
         QmMbXmHjEWPQBgKYcGpn+iO5NPZAe5q20RgkhESkQiVmiU4Fe6anLR/8oqPh+UnOTbki
         RkQQ==
X-Gm-Message-State: AOAM532BTiMrHa51XKDD/IrKl08tpyvrx/e16waU3Dg3ShHSpALrIg9b
        8d+fwGzV5IbBoqL+JbcI5BzHlIG9HdlyBdE=
X-Google-Smtp-Source: ABdhPJye7QFNmuu+/mgJr1MtQ/Q1gb2XMMBVZgCvZCV1tLV31zdEgHwQkCMmOOPtZQGBYUzZ9bfw9Z/2gPVr+Jg=
X-Received: from soy.nyc.corp.google.com ([2620:0:1003:312:7220:84ff:fe09:3008])
 (user=ncardwell job=sendgmr) by 2002:a05:6214:1225:: with SMTP id
 p5mr8428052qvv.29.1599746680049; Thu, 10 Sep 2020 07:04:40 -0700 (PDT)
Date:   Thu, 10 Sep 2020 10:04:23 -0400
Message-Id: <20200910140428.751193-1-ncardwell@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH bpf-next v2 0/5] tcp: increase flexibility of EBPF congestion
 control initialization
From:   Neal Cardwell <ncardwell@google.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

