Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E9E2DA13D
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 21:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503082AbgLNUMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 15:12:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503038AbgLNUMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 15:12:10 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06901C0613D6;
        Mon, 14 Dec 2020 12:11:30 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id j12so17027363ota.7;
        Mon, 14 Dec 2020 12:11:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZyDzn2+LRGnv+MKKkwj6dT7+oXF09NwrSJVoJaJ6uqw=;
        b=pUGi1FMMZYqAGrElyyecwiPhuV2Fx/WIY5NaySJsGHDD7E1fYwX6RRrmqZyRphNPdO
         2McjbAZ/cS6MWq0/G3oYu9h5mGo1MvAlLJvdbzUQyi4HJ4V0Jfkx7zqi9Wsk3BS/EB8I
         /9lokOGfcZHu1TFZvgIFu3+71SzswlGwuv+bILcrhb5gewMXDfZFujSSGgZyv4IwP8FD
         OiUuMqyJ25Ek1IlhNMVRNONG4LuK8LxS+osWVb77GQe+tAFGHZbf+qqKEU9ASRw9LxaC
         roDqgUxe7y6eDpDy3BdkhJ39V8Vt0sbS6RIJxgrmY+ONGS452+vZc1Pnw7C755Dv+FQa
         2k/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZyDzn2+LRGnv+MKKkwj6dT7+oXF09NwrSJVoJaJ6uqw=;
        b=USfpgTGOnE5o69MvTzXsbJN8ysslggGzPAfyEWgFDmcUn04CzVwX7GpWHCagT6MjvJ
         F2PsJVxcJ+wxQDaNUJvx4b1bSjwk9GchxCr+AzatPA6I/X+4Ia/3iDwhFUn7wrYHWPF1
         gNjQoDOKhB8AOWiFIozv4DNT4QX/4Qmfg4kKx8Z/g0gyQ+qH2ZEJLtkPnasiEAWODBTy
         R/5Mc10CtNTtLCQXI+enkOecDP6VI3OcuZhuP6wmNoGGeqh1HAFc1HsyAzTFElPdAi0l
         W5ZvctL+x+HARS9YTGiybqWMk0YjuU+5Q+MKdm1XCmX+Dztxqk3c7YTjzu14rnaE28IA
         983A==
X-Gm-Message-State: AOAM5327KbM9kKq8gndIUhyI+LcuXGZfEU2P9grxZbpGgLTdNK/y8e4v
        x4St3fZz8J5b7iq0OPbaz6MGr/X8gQsvgg==
X-Google-Smtp-Source: ABdhPJwxB8k78VVWShs9FLYm8eP3wjTJzml7wt5UJsrbcuOMNLcqOrru/64iFxPmNyssYX5IlFDBGA==
X-Received: by 2002:a05:6830:1d71:: with SMTP id l17mr21261793oti.269.1607976689065;
        Mon, 14 Dec 2020 12:11:29 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:3825:1c64:a3d3:108])
        by smtp.gmail.com with ESMTPSA id h26sm3905850ots.9.2020.12.14.12.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 12:11:28 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf-next v2 0/5] bpf: introduce timeout map
Date:   Mon, 14 Dec 2020 12:11:13 -0800
Message-Id: <20201214201118.148126-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

This patchset introduces a new bpf hash map which has timeout.
Patch 1 is a preparation, patch 2 is the implementation of timeout
map, patch 3 updates an existing hash map ptr test, patch 4 and
patch 5 contain two test cases for timeout map.

Please check each patch description for more details.

---
v2: fix hashmap ptr test
    add a test case in map ptr test
    factor out htab_timeout_map_alloc()

Cong Wang (5):
  bpf: use index instead of hash for map_locked[]
  bpf: introduce timeout map
  selftests/bpf: update elem_size check in map ptr test
  selftests/bpf: add a test case for bpf timeout map
  selftests/bpf: add timeout map check in map_ptr tests

 include/linux/bpf_types.h                     |   1 +
 include/uapi/linux/bpf.h                      |   3 +-
 kernel/bpf/hashtab.c                          | 301 ++++++++++++++++--
 kernel/bpf/syscall.c                          |   3 +-
 tools/include/uapi/linux/bpf.h                |   1 +
 .../selftests/bpf/progs/map_ptr_kern.c        |  22 +-
 tools/testing/selftests/bpf/test_maps.c       |  41 +++
 7 files changed, 340 insertions(+), 32 deletions(-)

-- 
2.25.1

