Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15E1CEF3D4
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 04:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729822AbfKEDNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 22:13:23 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:37320 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729543AbfKEDNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 22:13:23 -0500
Received: by mail-pf1-f202.google.com with SMTP id z21so5986018pfr.4
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 19:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Y0aSdelV2Jcu+Tnjn2ZV97PPrM1Mi5oX1M7dcbCmK9s=;
        b=a6eNWC0FqTwe4Fy0u2aMfixU2O1vy4LUGYxA9QQ6e+M/YjN82S6Cjslp+HQT0jKTXU
         U7pYxPesJrvF2rgssHK0MeqY39MLoBfJS/rYVcaw3GOXZKlM9jtXRukKE3sPi0RrwFs/
         KpX1MY7VnAeM+nHdFDykoT5/81gHLoWAuOTYDUD6kWY+ww/HdLktcDhVOO+V+CjPBCVP
         Di0j4Iin/J/+mtr9gv0SHilSKSKD8nPT9Kj9AatalZnLCKeakvhaZe9kfKnUChimXI0s
         AVXjQayiI3aRIY+MUzvCJfMiQn6u039Xor2O6R06Tci7LG6KSpWQNVUvtoALa3c6Pk8w
         qNCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Y0aSdelV2Jcu+Tnjn2ZV97PPrM1Mi5oX1M7dcbCmK9s=;
        b=gchG6t9qulrAjOtFCmTVOir50mVyf5640eqK0sLvcKsMlDQkNjLMuvcaFTYn0VO6Df
         YzI4vp0rkCk61X4g3cTC0rD9VqH88aGTiLftvnDHSef1jewkEeCGeScNTP/9I/8egaaF
         J37rHNHopRq5NmM6cBuDVL8nWaybdkmxeT3/PBhhzcLoUwBp8+OO6uNYhppD1mRST/TN
         FI65RcWFvIXXOXgv2O5kZ24CzxoWv//7xf4cJXwWvV7CzlQN/pn9AEzRRS+oPCqbNv6v
         o1D+pM7/UPI5M4J687Smcg7Ro+nBRPVB+/rG7lzYi6GKiJYDap7NgMLkoyHJwo7lro5Z
         eRWg==
X-Gm-Message-State: APjAAAXOAmD9n/Pd2qu+WkAa+VYrNGaebOFCdFU3+yUdqEmVKTDpuIsq
        uQytirLJwsAxzOTp0jFMpG0xnLreXly/Iw==
X-Google-Smtp-Source: APXvYqyyhF9rnLNCLG8vmF4mNtNq2K3YQxPNK0VHeRn92AMY0jHla6887AtU0koasS5QUXkyeCGma65oxbaJgg==
X-Received: by 2002:a63:5619:: with SMTP id k25mr33792193pgb.439.1572923602141;
 Mon, 04 Nov 2019 19:13:22 -0800 (PST)
Date:   Mon,  4 Nov 2019 19:13:12 -0800
Message-Id: <20191105031315.90137-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH net-next 0/3] net_sched: convert packet counters to 64bit
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small patch series add 64bit support for packet counts.

Fact that the counters were still 32bit has been quite painful.

tc -s -d qd sh dev eth0 | head -3
qdisc mq 1: root 
 Sent 665706335338 bytes 6526520373 pkt (dropped 2441, overlimits 0 requeues 91) 
 backlog 0b 0p requeues 91


Eric Dumazet (3):
  net_sched: do not export gnet_stats_basic_packed to uapi
  net_sched: extend packet counter to 64bit
  net_sched: add TCA_STATS_PKT64 attribute

 include/net/gen_stats.h        |  6 ++++++
 include/uapi/linux/gen_stats.h |  5 +----
 net/core/gen_stats.c           | 12 ++++++++----
 net/sched/act_api.c            |  2 ++
 net/sched/act_simple.c         |  2 +-
 5 files changed, 18 insertions(+), 9 deletions(-)

-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

