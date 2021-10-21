Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEFFC436D0A
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 23:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbhJUVuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 17:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbhJUVue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 17:50:34 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E75C061348
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 14:48:16 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id s4-20020a252c04000000b005be94057849so1507184ybs.21
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 14:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=SI+BBdqJzQqSjLEg/0uepgZqMzAE1ojqn2ZCRKGW16A=;
        b=aqxPaB1RFkPWOR4WYP96ThWAfNUWroNIGoS+AFbLwJ4PBhtRyMnkl6RyA/KtWLAnGx
         cN1K0Lj6WEtzIKL1wj7vjuwd8e6nNN3yz4vL1ec1h/uM9hQ7yz+xeT0m5tvwHgh3atgK
         0n16YmZAXpBVaBJqG1+KPlQtu9hYeE7IsHoKE0I/+520/bmsSvOCQB1+pZN7OEz70Jaa
         Ko+3hOFqNz7bOFozuIus/Sh0lBcauWPQEnZzA7JaZtsFO4f1OMk+sTRHkKUmLiLx90jN
         B3H4rER/XTVUpoHOvRdk3q8Hk/JsHhBS7X2FEa/HvTKrMwLS7vrHFATlAG7Yk5z6wgiQ
         t/ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=SI+BBdqJzQqSjLEg/0uepgZqMzAE1ojqn2ZCRKGW16A=;
        b=HUk5YC5T3CcoW6wcunhHD3PhvucfXyGD5UbvbGczwPb1WS1b5XSLDmxRIQJwN6bKuL
         2DvCjq5fuWhRdigiZrNRZwVLAmxbTPWuIz/IGVsWLqxoKeBv0778iCR2jEsM49cQmiwY
         oLEJ5SIn4U1YmZexazRyfJyRMKpw7mOOBTI2QNgHccnjDfrfeRlNJUrsYKzSC+MAj2sD
         7Soe1jiwXmOSwjbpySIUm3qdG2zvTq2MK4eaeXM2UliKMgOX6KOcez0SMZQPGRykA1Dj
         R0nUVkixWnzhLiQ2FtQwfQ8FVWRdHk4g0dhgBjyZaN8/k/y0oOSVcC6c4YbqLFKvKvR3
         5jpQ==
X-Gm-Message-State: AOAM531YW1By/oc4sl4ge/x48BV4P04rkExTjY4Dwcio+krrtRKji8v9
        WkTLrF0/HMfv8M91u3BKDFQdSw9P8GhWOZ2jYgdKdJBTiAXK3UIW/I4BUMmpnK//h8y0YkthdAb
        te3uBwgmk8tzbEpwEeIFiNHV3po5dWxpp1V8pDyucabN5OKGT+9cptQ==
X-Google-Smtp-Source: ABdhPJxkRp9yWnx+3x93Yxbe2R8URuY7QM+VQfYgdhIgmYMC4I+nqe0YHg8YOSNPmC4rmdJhLUThuMg=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:5d22:afc4:e329:550e])
 (user=sdf job=sendgmr) by 2002:a25:1e02:: with SMTP id e2mr8988402ybe.39.1634852895795;
 Thu, 21 Oct 2021 14:48:15 -0700 (PDT)
Date:   Thu, 21 Oct 2021 14:48:11 -0700
Message-Id: <20211021214814.1236114-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH bpf-next v5 0/3] libbpf: use func name when pinning programs
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

v5:
- get rid of error when retrying with '/' (Quentin Monnet)

v4:
- fix comment spelling (Quentin Monnet)
- retry progtype without / (Quentin Monnet)

v3:
- clarify program pinning in LIBBPF_STRICT_SEC_NAME,
  for real this time (Andrii Nakryiko)
- fix possible segfault in __bpf_program__pin_name (Andrii Nakryiko)

v2:
- add github issue (Andrii Nakryiko)
- remove sec_name from bpf_program.pin_name comment (Andrii Nakryiko)
- add cover letter (Andrii Nakryiko)

Stanislav Fomichev (3):
  libbpf: use func name when pinning programs with
    LIBBPF_STRICT_SEC_NAME
  bpftool: conditionally append / to the progtype
  selftests/bpf: fix flow dissector tests

 tools/bpf/bpftool/main.c                      |  4 +++
 tools/bpf/bpftool/prog.c                      | 35 ++++++++++---------
 tools/lib/bpf/libbpf.c                        | 13 +++++--
 tools/lib/bpf/libbpf_legacy.h                 |  3 ++
 .../selftests/bpf/flow_dissector_load.c       | 18 ++++++----
 .../selftests/bpf/flow_dissector_load.h       | 10 ++----
 .../selftests/bpf/test_flow_dissector.sh      | 10 +++---
 7 files changed, 55 insertions(+), 38 deletions(-)

-- 
2.33.0.1079.g6e70778dc9-goog

