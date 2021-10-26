Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B6B43BBAF
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 22:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239233AbhJZUk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 16:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239230AbhJZUkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 16:40:55 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB042C061570;
        Tue, 26 Oct 2021 13:38:31 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id y1-20020a17090a134100b001a27a7e9c8dso2918835pjf.3;
        Tue, 26 Oct 2021 13:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fknUh9gFZDY7Qs8RRkbBMbjy5NGCHFipP/1lmyKoBoA=;
        b=cCQOBVPFiAYJOP0XntWfTgJ0nzj695/Uuw90z9fJLywUvIAFYdDYd0sidx0zdEyrEB
         lUrqvA1slYJ8FtWR7R/9MF4Elv/HmEHkRUQWApXmLgrDUCtJIrXu42W9SM/ukIPo5jIi
         4hcEY1mMG0ewG8aHYNJ+zzaYCVnvn4a3DLC5XYkModhVRPBvVNtyKOlEjFsgl5mMOTbU
         V1SuiDj3n1kU3WdNjSluD81rPYcotlu+tuf18GMZZVJgYyn5ptRZgjcmEuSRddx+nZ2+
         fJlwkTwyVTfOw+5sIQ02RgqUMuSBlnMxUCuz1UwGsks1xhwPM+UV0MW1c4FtKV2RQVz0
         xNMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fknUh9gFZDY7Qs8RRkbBMbjy5NGCHFipP/1lmyKoBoA=;
        b=sYqt0qP8vhQoiDDcwBm17CxjvgigaqGMGzLDZBh2Q5kpzq2qq+yOaxkjGbtM/J9XDN
         y3r3jGZoT0cQRO7OH8sPtIMdbv4RD4V22BYO85OaPE5qrmD/fA8HrOjHAVveSMFCKDuP
         v9fhCQHxb6x+j2OZCUpApRbjqaIMo1rUpntzqcIq6zkbEZjdFFDlv93BGCCNnxxnZCX4
         x5mwySkBa6514pju9txtDRl5KjJBeDw77YuCY3ju6y0GAzrS7JNleWuohcL2AfqfTwcD
         gZNDqrPNm94R/SwbZ6uuaAVs1M2wgFhQevhHrtqfliIf0QLYnpf/uExD4U6Sf3TDMPIf
         0haA==
X-Gm-Message-State: AOAM533iQsjKtEBXj7YA/RtuO4BYp5XEWxnyTM/7YQWjJmd2ojW//Ckk
        4PBFs2vPOSoeuB/LISmzoo0=
X-Google-Smtp-Source: ABdhPJyFuRO1ZcrmP4n1Rhx2IOy7PXoLHK5pShAXIaGKccOPDydAvBWKFpEkW27v47RGBdVy4VYaQQ==
X-Received: by 2002:a17:90a:7d11:: with SMTP id g17mr1108730pjl.19.1635280711463;
        Tue, 26 Oct 2021 13:38:31 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:207c:7102:7bd7:80eb])
        by smtp.gmail.com with ESMTPSA id ip8sm1944477pjb.9.2021.10.26.13.38.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 13:38:30 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        bpf <bpf@vger.kernel.org>
Subject: [PATCH bpf 0/2] bpf: use 32bit safe version of u64_stats
Date:   Tue, 26 Oct 2021 13:38:23 -0700
Message-Id: <20211026203825.2720459-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Two patches, fixing bugs added in 5.1 and 5.5

I have a followup patch for bpf-next, replacing the u64 fields
in struct bpf_prog_stats with u64_stats_t ones to avoid
possible sampling errors.

Eric Dumazet (2):
  bpf: avoid races in __bpf_prog_run() for 32bit arches
  bpf: fixes possible race in update_prog_stats() for 32bit arches

 include/linux/filter.h  | 5 +++--
 kernel/bpf/trampoline.c | 6 ++++--
 2 files changed, 7 insertions(+), 4 deletions(-)

-- 
2.33.0.1079.g6e70778dc9-goog

