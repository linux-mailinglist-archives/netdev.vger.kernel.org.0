Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C23714A97B
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 20:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730213AbfFRSJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 14:09:04 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:45195 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729491AbfFRSJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 14:09:04 -0400
Received: by mail-pl1-f202.google.com with SMTP id y9so8251366plp.12
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 11:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Wep6s4agu8rdLcULIO3ntDstkZX56019pOAE+BsZxVM=;
        b=CeY+n5eaOCWxgLRYJddzsMjZnGLLh/cNYbOTpV/yh1G5G47CjqTogtjgtE6Qxan7oH
         3lGoViGmZuwtsoIrNWRBA+GuIRKjf2mEYFwGtvdx5JK4RUCjpNZ6t1ZAstlg988Buk5c
         RNGz7ioviSX8m3uln1xCbgheu8upyT1frht7fSuKV6KSARhElBDJind2zYpCcjXGBu8Y
         nNKodq6anm2pj21qdlAauNxuYYq0g3bcjkFwQnUu+3ngX8sJWTPYaPAIF3IAivS+oB9Q
         yWeMsWbsgiOwLNxZzfvbrGBAH+lD3m8nBGG8gddeI7eyzn4R+5Qd09jziGwSWc2jO1c8
         Wnmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Wep6s4agu8rdLcULIO3ntDstkZX56019pOAE+BsZxVM=;
        b=inEYDQnxORBwyZ4ncs6S4kszm5Lc4VZCKua3kvBk7DehtWM2Kq9LbkC9lXgJOJg6Qw
         KgjqQ043o5kKIsfNsX+QDideLK4NyogzT7cBIdJVyQc95O6JIEb1Sg+Ph/kGdQwh6l06
         FRiFagLfXgzx4gYH3cdYsLm3E+6JoJCnSbxfQhi2jltUPhaQFVUyIJE6nzxGaFQGZ4ay
         nY49DKJuT7ys5e1pbf5ZaiAFR3epDQego0Iuuv0bQYeSOf0rN2hniepzWQEUmRkIgYD4
         8fMwkyY3sKRuIdm1c3bgZ4pz2s26oN4cYrjcSQp4RiCvF/n229lmGc/2pdfGhFnRQiW1
         TzbA==
X-Gm-Message-State: APjAAAVx7/r5fUvmvQjbQaVhyg6+yNGXXOLNB19ZzPDf1VyZPEwcJVoN
        g6vkl4ZLKq2ZeeC0GE5HaDQPugVBOT6qNQ==
X-Google-Smtp-Source: APXvYqwwhvK12TLGfLFKq72tFbt0tjcWizrm1Nn8hKLmnIW06t7GfcVlpewcc5lsenen1oP6ybvpJABN3voawg==
X-Received: by 2002:a17:902:3a5:: with SMTP id d34mr30399011pld.239.1560881343584;
 Tue, 18 Jun 2019 11:09:03 -0700 (PDT)
Date:   Tue, 18 Jun 2019 11:08:58 -0700
Message-Id: <20190618180900.88939-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH net-next 0/2] inet: fix defrag units dismantle races
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series add a new pre_exit() method to struct pernet_operations
to solve a race in defrag units dismantle, without adding extra
delays to netns dismantles.

Eric Dumazet (2):
  netns: add pre_exit method to struct pernet_operations
  inet: fix various use-after-free in defrags units

 include/net/inet_frag.h                 |  8 ++++++-
 include/net/ipv6_frag.h                 |  2 ++
 include/net/net_namespace.h             |  5 +++++
 net/core/net_namespace.c                | 28 +++++++++++++++++++++++++
 net/ieee802154/6lowpan/reassembly.c     | 13 ++++++++++--
 net/ipv4/inet_fragment.c                | 19 ++++-------------
 net/ipv4/ip_fragment.c                  | 14 +++++++++++--
 net/ipv6/netfilter/nf_conntrack_reasm.c | 10 +++++++--
 net/ipv6/reassembly.c                   | 10 +++++++--
 9 files changed, 85 insertions(+), 24 deletions(-)

-- 
2.22.0.410.gd8fdbe21b5-goog

