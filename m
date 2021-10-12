Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DEA342A92A
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 18:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbhJLQRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbhJLQRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 12:17:49 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07863C061745
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 09:15:48 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id i83-20020a256d56000000b005b706d1417bso27676707ybc.6
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 09:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ET8OOPB0TmiiG669U/jrXIpK1+Qik7SS+NO0SsWrLZE=;
        b=tYY7At+5aaRUPE8SjpCkeXSQp6zpyVqB8MOPZB8PHkRE3OAIgmvmmCm3Ue4ChgK/gm
         +er44amPoy8fNYrsAeWEa0l0tx9APGSb6zdvVHXtl+OAKS8WuphT6/q8lTiRlIB+Q/og
         n3l4uwKWjWXVWDi3i3l4RP/07f0d7Nu7tACVy6wu65cmpVxzZC4fvcAskYFFO7D+xJ44
         A+nqh3HcfRDKVsmb6OzKs3CBbkW3I//PvbPGQcB9HEcVbxjLRecHO98wWv+j59+hCHMt
         6u6gO3qjPKXzd+is2pgyIlUFQTQ4hcpyMhlleRl77Tp0EgiBe+GaS7J3R2AEAx+7ofg9
         sAXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ET8OOPB0TmiiG669U/jrXIpK1+Qik7SS+NO0SsWrLZE=;
        b=7kor05aNrZYupWfbWAO+2BtQ796bUcsnznelBm/rEXCaVG6VoFvTR7SgUq4OeU/WWk
         UeJ4bQBpfF7gGkKN7cU00IrTqyGuoY2W73UHihiGj7qFUXIvY0opKA9npoUBE1uF6F8A
         ZwbnHjFij+W3Ew8R2bea4GDl6hAmFNmVZTUiY8VxZlj/uhYnHssQIUMaVlVYwLJ6frLH
         xPpS+NMVeFhfNSr6fOscva5brLlSSoygeY2ZNl4tenbmGa0LLHIYbmjeB3YbZ0W/Q4yS
         H8FBp3MYU/f0GC8kM1wP4T8qJH5tWcdmfc8uBy7DevBoLvl6LhGTZAfLoqbO7mVHm+py
         0LNA==
X-Gm-Message-State: AOAM531+W4bBZYZt8XLS7XubzveHIuS8a8V9dMKIymtyzJqMc/1P+yOJ
        kc8f+iF8rcKI1mwu7W4vI7JMvBUwbNlvlr9hu0myBVdAjU11jJRwKCVC0wHfwgcsSjAsVyxiWMJ
        Zi0Kx7F1U4CJvbIt1L0tyMBaEmdSroaXBPjI3VMXBzxiw47SGnLzkLw==
X-Google-Smtp-Source: ABdhPJw2xK60SXPcScUuarL7LW6FSTpF4smGWK5kb0C9zqFhp1CEAShgg36N5fWFF951PZXXXNgMpRU=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:4060:335c:dc47:9fc2])
 (user=sdf job=sendgmr) by 2002:a25:81c5:: with SMTP id n5mr28959042ybm.276.1634055347127;
 Tue, 12 Oct 2021 09:15:47 -0700 (PDT)
Date:   Tue, 12 Oct 2021 09:15:41 -0700
Message-Id: <20211012161544.660286-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH bpf-next v2 0/3] libbpf: use func name when pinning programs
 with LIBBPF_STRICT_SEC_NAME
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 15669e1dcd75 ("selftests/bpf: Normalize all the rest SEC() uses")
broke flow dissector tests. With the strict section names, bpftool isn't
able to pin all programs of the objects (all section names are the
same now). To bring it back to life let's do the following:

- teach libbpf to pin by func name with LIBBPF_STRICT_SEC_NAME
- enable strict mode in bpftool (breaking cli change)
- fix custom flow_dissector loader to use strict mode
- fix flow_dissector tests to use new pin names (func vs sec)

v2:
- add github issue (Andrii Nakryiko)
- remove sec_name from bpf_program.pin_name comment (Andrii Nakryiko)
- clarify program pinning in LIBBPF_STRICT_SEC_NAME (Andrii Nakryiko)
- add cover letter (Andrii Nakryiko)

Stanislav Fomichev (3):
  libbpf: use func name when pinning programs with
    LIBBPF_STRICT_SEC_NAME
  bpftool: don't append / to the progtype
  selftests/bpf: fix flow dissector tests

 tools/bpf/bpftool/main.c                       |  4 ++++
 tools/bpf/bpftool/prog.c                       | 15 +--------------
 tools/lib/bpf/libbpf.c                         | 10 ++++++++--
 .../selftests/bpf/flow_dissector_load.c        | 18 +++++++++++-------
 .../selftests/bpf/flow_dissector_load.h        | 10 ++--------
 .../selftests/bpf/test_flow_dissector.sh       | 10 +++++-----
 6 files changed, 31 insertions(+), 36 deletions(-)

-- 
2.33.0.882.g93a45727a2-goog

