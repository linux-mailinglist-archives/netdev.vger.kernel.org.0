Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38C182635B0
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgIISQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727005AbgIISQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 14:16:14 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797FEC061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:16:12 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id 205so1903756qkd.2
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 11:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=ciB3VOOAHjyuPpCFhFdWqapGvrcsn289by2Pr+lMdOo=;
        b=OPXWRmdrvjsf1BuXA3yHtxdO1Voz/2QEV0fWqUQc8TSdobyaCN3wGc0lD2vYQNP1Ob
         5D9DQodEdKcgLrPcbs5nRPRCjDogkK/SOC8w/3vSO4rNGq3k8fNqvNkPRdJr4M/0pbdb
         PA9aEA1XTVUWm7SonigGl+4wMDSseOBOjMqFJ1n21wYav8TCVGY4Vv+uJlgTHqsdYQIc
         kN5kpH7MbZQLCTcozUHL03w3IbRuihBedMVwchPu4ijxNtEsUWgxdk38CAkauBAH0mO4
         Nl1EXwOeVlPCYfThganu/sD+Vj81VTvl6ef84Gh17rX3aGCyiR80w5Z9TSYbYFWqoERx
         UHVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=ciB3VOOAHjyuPpCFhFdWqapGvrcsn289by2Pr+lMdOo=;
        b=mofmMYGpn7S+ZeudLZpzL+D7qLaIQOO9Q4Yg9oeDuKyUL3s+STm/VgZJ3otiGd7a06
         zFg8y9lOj3g+mgdLlWkISbM+Xt5f3uuY8CLyl+L5NLkWDpjGtYMOimASafPEazcWcd2O
         tYjNMUIYBAStQ1EBru8C1PtxfscgcZt1SABIhzb0Oy6uX5YX+EESUl2SMvvEz/Mr3s9w
         sPSv1lc+dqMzJe+XunZqzXsnfWb+UrRPllx/fLPRl4CZfepYY6sbEqd6t1bu+lGqOljq
         k1F+b8ds2j3b3akwDshLaDhJ9ATRwHrrnBE4Mz8l+V9ijkanJMMjH8HG9FSdfC8s1ROe
         BORQ==
X-Gm-Message-State: AOAM533zjoI5RRQRqLffpalF8ZF92ikUEL+TKHBpVUO0HI55G2rcz90H
        M3rizN59xb9wXBpS5Of4ZA5dwS44aU37FT4=
X-Google-Smtp-Source: ABdhPJw35DW1EId8AdD2uuWkEG3vsa8TNIWqdsc1q5eHmZTRFQdoJTWUoqrbN71oOweJ5hwp1MfQ/wtsmlHSk84=
X-Received: from soy.nyc.corp.google.com ([2620:0:1003:312:7220:84ff:fe09:3008])
 (user=ncardwell job=sendgmr) by 2002:a0c:ed31:: with SMTP id
 u17mr5351395qvq.21.1599675371598; Wed, 09 Sep 2020 11:16:11 -0700 (PDT)
Date:   Wed,  9 Sep 2020 14:15:52 -0400
Message-Id: <20200909181556.2945496-1-ncardwell@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH net-next 0/4] tcp: increase flexibility of EBPF congestion
 control initialization
From:   Neal Cardwell <ncardwell@google.com>
To:     David Miller <davem@davemloft.net>
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

Neal Cardwell (4):
  tcp: only init congestion control if not initialized already
  tcp: simplify EBPF TCP_CONGESTION to always init CC
  tcp: simplify tcp_set_congestion_control(): always reinitialize
  tcp: simplify _bpf_setsockopt(): remove flags argument

 include/net/inet_connection_sock.h |  3 ++-
 include/net/tcp.h                  |  2 +-
 net/core/filter.c                  | 18 ++++--------------
 net/ipv4/tcp.c                     |  3 ++-
 net/ipv4/tcp_cong.c                | 14 ++++----------
 net/ipv4/tcp_input.c               |  4 +++-
 6 files changed, 16 insertions(+), 28 deletions(-)

-- 
2.28.0.526.ge36021eeef-goog

