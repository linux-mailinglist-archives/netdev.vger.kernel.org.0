Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEF84A360F
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 12:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354712AbiA3LzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 06:55:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236399AbiA3LzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 06:55:22 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA20C061714
        for <netdev@vger.kernel.org>; Sun, 30 Jan 2022 03:55:21 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id h21so20013909wrb.8
        for <netdev@vger.kernel.org>; Sun, 30 Jan 2022 03:55:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zgAN6AfkAHmymf1Qj+a2DASXNblLOsBwBSSNe3gcYkE=;
        b=P58c/Xiod8wKiTNWJWDNjxA3x0tmrYvILy+U717qHcslUbw7oUnl1cCWAF+hO739sB
         fXMgMwy7EUpE/72lbd96STM39OYjTn3+itMdiC41bBgkawoIxsfcoMqiOG9WzSmaGcBd
         3l/a1ZcZoBunrSm3w6/mJcM97xct28T603/SM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zgAN6AfkAHmymf1Qj+a2DASXNblLOsBwBSSNe3gcYkE=;
        b=BqyM82f4nFlr86C52KRx9cYa9XXZtf3/A7ztbM38KUAtXnr67428r0tuvSeH7tnPzB
         SO988hB2qIl+L0I0XQEZ6f8X4OxkYff857AXgKAkypo7Lb5/wQitKjKVscR8woQTIOQm
         HHirmBvacEAKShLVlb6CpJdzVOzv9GcnkB8ftDkttwa65j1B29mbcl9qqNrNbSv/i6vE
         e8yU7vHIdeK8KgJFiy8mSJNMWyLggm65nehjQ012Egr550s6s8jW+FqUYm4oQmB7BmQI
         R5xRf31QuG/XHLqrtFLq4g0bkFaFQpvMn5+xig3r2jTFDX3nhahaPGrNwnG2x6pLLfyt
         VQEA==
X-Gm-Message-State: AOAM531qey+tOrPn0lt6PYQLK7fttMggDEjAY9gpKakE7QHBOat3Kwyx
        l7v/Ovrg9PS6jMByFljA54fI6A==
X-Google-Smtp-Source: ABdhPJwNmoxEk89FcTGAahyRrFCzr1Ei7psU4G9u/ToIiPbziij7BjxkxIhbp97RYlxys4KQcSK3ig==
X-Received: by 2002:adf:f80a:: with SMTP id s10mr13097614wrp.440.1643543720071;
        Sun, 30 Jan 2022 03:55:20 -0800 (PST)
Received: from cloudflare.com (2a01-110f-4809-d800-0000-0000-0000-0e00.aa.ipv6.supernova.orange.pl. [2a01:110f:4809:d800::e00])
        by smtp.gmail.com with ESMTPSA id ay3sm3255446wmb.44.2022.01.30.03.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jan 2022 03:55:19 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Menglong Dong <imagedong@tencent.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next v2 0/2] Split bpf_sock dst_port field
Date:   Sun, 30 Jan 2022 12:55:16 +0100
Message-Id: <20220130115518.213259-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a follow-up to discussion around the idea of making dst_port in struct
bpf_sock a 16-bit field that happened in [1].

v2:
- use an anonymous field for zero padding (Alexei)

v1:
- keep dst_field offset unchanged to prevent existing BPF program breakage
  (Martin)
- allow 8-bit loads from dst_port[0] and [1]
- add test coverage for the verifier and the context access converter

[1] https://lore.kernel.org/bpf/87sftbobys.fsf@cloudflare.com/

Jakub Sitnicki (2):
  bpf: Make dst_port field in struct bpf_sock 16-bit wide
  selftests/bpf: Extend verifier and bpf_sock tests for dst_port loads

 include/uapi/linux/bpf.h                      |  3 +-
 net/core/filter.c                             | 10 ++-
 tools/include/uapi/linux/bpf.h                |  3 +-
 .../selftests/bpf/prog_tests/sock_fields.c    | 58 +++++++++----
 .../selftests/bpf/progs/test_sock_fields.c    | 41 ++++++++++
 tools/testing/selftests/bpf/verifier/sock.c   | 81 ++++++++++++++++++-
 6 files changed, 173 insertions(+), 23 deletions(-)

-- 
2.31.1

