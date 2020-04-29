Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2005B1BE5FD
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 20:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgD2SL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 14:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726423AbgD2SL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 14:11:57 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3879CC03C1AE
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 11:11:57 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id i10so3675801wrv.10
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 11:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ryUFaJ+61X3pzz7HW3AjoxfMyaLsi/WhEIy5/h3CzoM=;
        b=Hik43EzbKRZNwN4TwmwvCzr+RxkJYWkqQKMjCZBYtN4kRnwYCe2bJ7T6B1pq8EwVtF
         uqpjuaNRCfCnD9Px/rCzWvW1uxMyXaKNhkGh96+M4T8p2oAwjPdVUqk2Tbbfnho7TxD/
         kgfPWNPDjfVuPTwPfFRTtTvxxSD8UlUVxWW/E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ryUFaJ+61X3pzz7HW3AjoxfMyaLsi/WhEIy5/h3CzoM=;
        b=Vjt9ZSJhkAQUiljL8Q2GxUIXaTRFJW+XF0o8xp5CpZRf9O1cP6hHN9ihfWthmOqqgJ
         F0Myj90dO1tAYGIj6hv5M0C/BoT90Q3JTD+MG23Nw7N0oZBV/hx/ghMsJzsOdLz3fqW/
         jrBPrnmL93MA+SBJUHbkf5Lssi7W99ugHERrbQW82QjoV34tiH1czkZFjkJE4VB0f6vA
         he6xL8CWgYUGnAdJtUlN3qVDKj5FEFodzu3YGoFakjlA6xfa1rL6KfwZquWalWMUx0WH
         qAJwEseZZATbYDR670xeNyVVbMYLHiqdUksCxJyRQGExxF1XLw2n/ME6EjoksIRSqt9h
         4ONw==
X-Gm-Message-State: AGi0Pua/o7oxBLa477ZI9NW9tbtZhwMCT9krHUbm3binDU1rNzW4Phtt
        5lkIpUk0bgI5CKaSUQnxFpWHfQ==
X-Google-Smtp-Source: APiQypKLuiWG4KER2XgSYxbhPUNXiJNyN4jfAN84VIxZx7sSzpALAVb3Gubv7peT4z+zoc4Uz0SydQ==
X-Received: by 2002:adf:f40b:: with SMTP id g11mr43099508wro.178.1588183915794;
        Wed, 29 Apr 2020 11:11:55 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id p6sm72145wrt.3.2020.04.29.11.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 11:11:55 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Joe Stringer <joe@wand.net.nz>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next 0/3] Enable socket lookup in SOCKMAP/SOCKHASH from BPF
Date:   Wed, 29 Apr 2020 20:11:51 +0200
Message-Id: <20200429181154.479310-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series enables BPF programs to fetch sockets from SOCKMAP/SOCKHASH by
doing a map lookup, as proposed during virtual BPF conference.

Patch 1 description covers changes on verifier side needed to make it work.

Fetched socket can be inspected or passed to helpers such as bpf_sk_assign,
which is demonstrated by the test updated in patch 3.

Thanks,
Jakub

Jakub Sitnicki (3):
  bpf: Allow bpf_map_lookup_elem for SOCKMAP and SOCKHASH
  selftests/bpf: Test that lookup on SOCKMAP/SOCKHASH is allowed
  selftests/bpf: Use SOCKMAP for server sockets in bpf_sk_assign test

 kernel/bpf/verifier.c                         | 45 +++++++---
 net/core/filter.c                             |  4 +
 net/core/sock_map.c                           | 18 +++-
 tools/testing/selftests/bpf/Makefile          |  2 +-
 .../selftests/bpf/prog_tests/sk_assign.c      | 21 ++++-
 .../selftests/bpf/progs/test_sk_assign.c      | 82 ++++++++-----------
 .../bpf/verifier/prevent_map_lookup.c         | 30 -------
 tools/testing/selftests/bpf/verifier/sock.c   | 70 ++++++++++++++++
 8 files changed, 178 insertions(+), 94 deletions(-)

-- 
2.25.3

