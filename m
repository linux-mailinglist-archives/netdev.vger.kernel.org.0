Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9F543BC8E
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 23:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235253AbhJZVoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 17:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbhJZVoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 17:44:01 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB2DAC061570;
        Tue, 26 Oct 2021 14:41:36 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id i5so511058pla.5;
        Tue, 26 Oct 2021 14:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QxlHN3JQfgAN+PUbtWRzUIRlta1H+DUwqpcC39t0BDo=;
        b=PMOfz7kSK2HvsPZFvdil2CIyuC3QtwD9qW/AmyP3pa/ESGFBKps2+zuf8RQviQoxqp
         6NK8T0feBkgebzS0JYO4+f1ueTXhgI1QvjX5sTe1UkQG3+WlIVJdKU1Kd8lNp7Xh2m4r
         WsYzdHo9ig6A8l5bvQo7anlPicUHDgtllJkl4V9QyOvz3uCqbs9TKbhBh+es62b+De0K
         VdjWjFIf8vbdKZ4QjaKc795yJj/TCtlF57bsm604ghk+lyn1QU+EP4HhjrSlv0lkCe4G
         M27rBSkEG9lQZ1MUEVPd6DvuQs+RLROBiVkZbNiRI8qtxJCI7mvVqXtZtgJh4JnmcIIt
         zqCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QxlHN3JQfgAN+PUbtWRzUIRlta1H+DUwqpcC39t0BDo=;
        b=slZGSQB+IYxUL2TAZYIwSWROoSmjM8gBnUz8fOE2RVM/2XRYmGCZ30E0X3aJh1teX8
         mayODkooKulxRrKpUZ2z82AB6Micr9YQSn10YRIwytwGJUpkihqgPxXb41WU7RAKUlnL
         WHXu0QPcZZbRei2s/mg/4yTY8n61fWO8UnJLSXCMNtqWUb9N6z6zIjZ6IVL/DTePhJhq
         /Xgnd14b3hb/bG48fU4QfmBEmln/iaaoWs1HoxUwIeuRrdyJD5PFGruuvdOd6mus43+J
         wSMPUBOZ6qwFjE8o1qMJkVtvtl+LCGwcmnEegfPnDIQmBDH4Nwaz5ELLHZEyUzj8lc2v
         7i0A==
X-Gm-Message-State: AOAM532Z0pF4c7jiY0ZCoFDBLCPzaDc3z6J33ulIvtSWSEHoovQ0sSTj
        BnshVBvrwVgGoav3MdmGgFM=
X-Google-Smtp-Source: ABdhPJzlHQ7N5DgcY8pJlMRhjGvV35B5mp4JgRqoOwSEAhDWu933uT4reHBHljhkM+RCd6yixYlqVw==
X-Received: by 2002:a17:903:1111:b0:13f:d1d7:fb5c with SMTP id n17-20020a170903111100b0013fd1d7fb5cmr24945601plh.47.1635284496367;
        Tue, 26 Oct 2021 14:41:36 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:207c:7102:7bd7:80eb])
        by smtp.gmail.com with ESMTPSA id g22sm6495400pfj.181.2021.10.26.14.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 14:41:35 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        bpf <bpf@vger.kernel.org>
Subject: [PATCH V2 bpf-next 0/3] bpf: use 32bit safe version of u64_stats
Date:   Tue, 26 Oct 2021 14:41:30 -0700
Message-Id: <20211026214133.3114279-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Two first patches fix bugs added in 5.1 and 5.5

Third patch replaces the u64 fields in struct bpf_prog_stats
with u64_stats_t ones to avoid possible sampling errors,
in case of load/store stearing.

Eric Dumazet (3):
  bpf: avoid races in __bpf_prog_run() for 32bit arches
  bpf: fixes possible race in update_prog_stats() for 32bit arches
  bpf: use u64_stats_t in struct bpf_prog_stats

 include/linux/filter.h  | 15 ++++++++-------
 kernel/bpf/syscall.c    | 18 ++++++++++++------
 kernel/bpf/trampoline.c | 12 +++++++-----
 3 files changed, 27 insertions(+), 18 deletions(-)

-- 
2.33.0.1079.g6e70778dc9-goog

