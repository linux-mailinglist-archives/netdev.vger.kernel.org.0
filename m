Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B482E669B59
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 16:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbjAMPFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 10:05:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjAMPEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 10:04:54 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569E3B92
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 06:56:27 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id qk9so52930518ejc.3
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 06:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PVJiZRnZgpTYiN4FNxophNlibIpTboLF6WJiWLea66Q=;
        b=V6pdegotXYvm1pbllvAFnpEOWGwnCZDatL98LeipcAQ7cTi2EZ5mo087SZTjueU2Hx
         J8j/M0U8XDUamo9uD8eOeCXP6HaN9CkXtGNxhukBUr5S/89o98hw309LDW5yEr1FGUc3
         rZ3nP7t5iPdgVtWDrguuYmrUK+XWIMo1ysNis=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PVJiZRnZgpTYiN4FNxophNlibIpTboLF6WJiWLea66Q=;
        b=bEvbJBJl4FEZ0CBGmOUvCA/Zolc8I47cf0gF2U3ro3jY3QJ0JbNggTFb9yhCGQ31xE
         bkksxyKjjwVc+ystZy5ZzFPYRFjcz7d9cMoC1nG/gDSAvbUWzXLWm7D1xEckj9eXFKtw
         9WIlHh49iWWxOkAEa0fADcOX21axpeUzWplkHRVNaJPc9qui68HCmNzoURWl52OwKL8w
         VRsgmA0vP4hWs5qTEsDgMI9bWKEBNlQ9pJf7qcOdSEMPDbT1DRmM9nAGGu78xmOpWCHM
         LSTFewSoP1iupT3NEHL3E3X7eyB4SdQfpqmdfUOfl9cxlq/SzvgNrCQScSKUWJE+HUtd
         hMAA==
X-Gm-Message-State: AFqh2ko6e4s0mFurUNK+pABH/o0X+GIihkveU+8MKYNrK9dHciz7QCbM
        M0fFxMUC43Lfwu+7PlHQQiU+YfYWwVbu/kNJ
X-Google-Smtp-Source: AMrXdXt56jvphyX+qWF2dCPBN1oeuUilHfgatVW33N2z3VE4/jbLy0RSZ8mB4d9sukHrkeeYqLudcQ==
X-Received: by 2002:a17:907:8c0c:b0:7c1:1901:a445 with SMTP id ta12-20020a1709078c0c00b007c11901a445mr71993245ejc.20.1673621785489;
        Fri, 13 Jan 2023 06:56:25 -0800 (PST)
Received: from cloudflare.com (79.184.151.107.ipv4.supernova.orange.pl. [79.184.151.107])
        by smtp.gmail.com with ESMTPSA id ov38-20020a170906fc2600b0084d4733c428sm6141108ejb.88.2023.01.13.06.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 06:56:24 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH bpf 0/3] bpf, sockmap: Fix infinite recursion in sock_map_close
Date:   Fri, 13 Jan 2023 15:56:20 +0100
Message-Id: <20230113-sockmap-fix-v1-0-d3cad092ee10@cloudflare.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set addresses the syzbot report in [1].

Please see patch #1 for the analysis and the fix.
Patches #2 & #3 add coverage to selftests.

I still need to address Eric's suggestion to break out of sock_map_close when we
detect that sock_map_close is calling itself. Will do it in a separate patch or
the next iteration, if there is any review feedback to address.

[1] https://lore.kernel.org/all/00000000000073b14905ef2e7401@google.com/

To: bpf@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: kernel-team@cloudflare.com
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>

---
Jakub Sitnicki (3):
      bpf, sockmap: Check for any of tcp_bpf_prots when cloning a listener
      selftests/bpf: Pass BPF skeleton to sockmap_listen ops tests
      selftests/bpf: Cover listener cloning with progs attached to sockmap

 net/ipv4/tcp_bpf.c                                 |  3 +-
 .../selftests/bpf/prog_tests/sockmap_listen.c      | 81 +++++++++++++++++-----
 2 files changed, 64 insertions(+), 20 deletions(-)
---
base-commit: e7895f017b79410bf4591396a733b876dc1e0e9d
change-id: 20230113-sockmap-fix-83d0359301b7

Best regards,
-- 
Jakub Sitnicki <jakub@cloudflare.com>
