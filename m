Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0203F0218
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 12:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235168AbhHRK7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 06:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234824AbhHRK7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 06:59:02 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C7CC061764;
        Wed, 18 Aug 2021 03:58:28 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id qe12-20020a17090b4f8c00b00179321cbae7so2082003pjb.2;
        Wed, 18 Aug 2021 03:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6ngK5o3Hm/CpUkzhL3Cyg+OZKC3Si1CRqzv7qINSgho=;
        b=PiI9i5ZYroCC69aFh91sgtINbzIk21xXLbRfiYx+oN2vINQgXhehdpC7o5mW5HwNP+
         54TAvaVs7QucAR6LJ74UBzt5oiHi+PzqMi4HRNealzu0jEr3Ro0O69onqCi1ulP2VY9r
         7Ddrhh1x7uUBClXdzERg9alS1lqKq6dXCVRgAVlmTRK7ZwVT3cnMe29m69Z5xk9dQGS9
         /Ug3NBJXl0NICSjqSusQfyJMrI3AGy3lW4V4S2esjGvieKbrUvFlaIsG2leQ1NsgRn/N
         r5D1yKEpHJHibv1ldTNpkyQuEOauSUe+K/BXhxWdGdfggyKuCRd0h6N/dBBPTNJm3Ywo
         2M7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6ngK5o3Hm/CpUkzhL3Cyg+OZKC3Si1CRqzv7qINSgho=;
        b=uLdOQKX2PDm7CMJAP1yziB1bBs5xk8szG8AulCquq7PIErE4whvkH9stbPGITl571a
         Qv3ccN/uKUGitTAgkbd5KIPae/97ir9wmOHiLc91aQQoxvs+rSav5z+90yZ5kyQMCDrx
         IfIEpeLwY4/DvqiDEvNtV6iX98Y4bFAsqH1pF6n8e3jfKqA9th+NW/QUlg48rK+0CZvb
         zC3/4M9OXsEiGGeNNJacEN4Q5ztoBGO7/pkdKUoDPkiY+dpHgCQL3n90Ze/Wt6w3luji
         SusolY2guWpc23Jxl8lEopF/oXARSGEK/f+6nS9bU4HYPof/55le08+YI4HDT8bhy6Ix
         kHXA==
X-Gm-Message-State: AOAM532SRmSFlqVv9I2VbFZE9f/x7Gt5XucDfrTs1xOkIJl6EUKdrvc9
        cNr7FIIdFX326VkqtE8bxOU=
X-Google-Smtp-Source: ABdhPJy1i3wSsQA/+NBCDkc5WkPVGMtAoKpeW6gJCWCQDfB0jSEzx8/O4GU7Rq/dm33pgBap9E1gtQ==
X-Received: by 2002:a17:90a:116:: with SMTP id b22mr8525019pjb.97.1629284307907;
        Wed, 18 Aug 2021 03:58:27 -0700 (PDT)
Received: from IRVINGLIU-MB0.tencent.com ([203.205.141.117])
        by smtp.gmail.com with ESMTPSA id b190sm7099440pgc.91.2021.08.18.03.58.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Aug 2021 03:58:27 -0700 (PDT)
From:   Xu Liu <liuxu623@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xu Liu <liuxu623@gmail.com>
Subject: [PATCH bpf-next v2 0/2] bpf: Allow bpf_get_netns_cookie in BPF_PROG_TYPE_SOCK_OPS
Date:   Wed, 18 Aug 2021 18:58:18 +0800
Message-Id: <20210818105820.91894-1-liuxu623@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2: Added selftests

Xu Liu (2):
  bpf: Allow bpf_get_netns_cookie in BPF_PROG_TYPE_SOCK_OPS
  selftests/bpf: Test for get_netns_cookie

 net/core/filter.c                             | 14 +++++
 .../selftests/bpf/prog_tests/netns_cookie.c   | 61 +++++++++++++++++++
 .../selftests/bpf/progs/netns_cookie_prog.c   | 39 ++++++++++++
 3 files changed, 114 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/netns_cookie.c
 create mode 100644 tools/testing/selftests/bpf/progs/netns_cookie_prog.c

-- 
2.28.0

