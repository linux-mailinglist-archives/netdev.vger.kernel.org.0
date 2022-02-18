Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9F44BB5FA
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 10:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbiBRJ4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 04:56:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232816AbiBRJ4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 04:56:43 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 406956366;
        Fri, 18 Feb 2022 01:56:25 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id y5so1938388pfe.4;
        Fri, 18 Feb 2022 01:56:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ASeypXRihACV7GAUh7uwe5dr074v2W03J+WqWirP0qg=;
        b=TtP3a8fvx71ymXORVwJz5VvdiIKXHlGEQaF1fswtgYez7GykxxafxT3tThvW7rQBp+
         RVN8oyZkTf9vfw9yU66OSr/z9IDubO5v8CNmpjTR/xQnb2WFc4RZ5BINkPobC4KKEJbL
         Cf6WP98bXTcyftgUJi+vlq2oq7tRQiEtgpTlQwSCpOqOX9pC5u/txW2pI/JSjlSIKk2c
         KUxnc+tUTVdrqlIDZ8QqQDn/c9nj5qQezMUNRaI8U4fTcRUvOJ8TTjOMZX+GyGV2U5xw
         B2Dit8xdCj0GCtm5FIyiwVHKcZGuFQ5xs4GXJfyaFov2Mpz9LWYZ5C8qH/T7usppNHin
         wK/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ASeypXRihACV7GAUh7uwe5dr074v2W03J+WqWirP0qg=;
        b=L2xv6K+rfW5dtljJVMeKilFVKvCUiD933+wvqZec/GX4FOcOiVdnEDoFL6Ez9i4+cc
         L56sP4961uCVAURx0duY6BzSMWb6bq3oiZziLzG9riFEv+OsHu8pn/XsjiiZR0Df8xo3
         p9liCZsIjVAYtomesGvBdKpze5iHesEk/E/l+Ozux/+OYd6UiPBM+z5a/Zy7ky0nfsA7
         8mKHZczSeGMTIVezwqpf01xBtqNvO2/OAFSVGMA+YatnMlPcTchT3RP/P/RpVuPStw1T
         c875HzNhd+YBuzMBUtLCZNpYp75BEnYchZgnr4/S+15m+sWuhxDYCde3xIaQIsOpjoPt
         JTkQ==
X-Gm-Message-State: AOAM533mtpoX5/GBZNqrWRaGXtigTJpgc2czwl3VfL45PoCsWYrwfcVb
        +DICy4OqRTt380Yn4JYqOrQ=
X-Google-Smtp-Source: ABdhPJyGYravoPWA+7V/e14rAqNKZ++soM1WSQ15O73L+fXP8rw+tjDEDqtcxEoZ1394l+dE+depvQ==
X-Received: by 2002:a63:6985:0:b0:341:b238:7cb1 with SMTP id e127-20020a636985000000b00341b2387cb1mr5696159pgc.621.1645178184747;
        Fri, 18 Feb 2022 01:56:24 -0800 (PST)
Received: from vultr.guest ([149.248.7.47])
        by smtp.gmail.com with ESMTPSA id t22sm2750430pfg.92.2022.02.18.01.56.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 01:56:24 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH RFC 0/3] bpf: show attached name for progs without btf name
Date:   Fri, 18 Feb 2022 09:56:09 +0000
Message-Id: <20220218095612.52082-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With progs.debug we can get the attached name of the bpf prog which is
attached to a kernel function. But we can't get bpf progs which are
attached to others, like a cgroup, sockmap and etc. This patchset means
to extend the attached name to other types.

The member attach_func_name in struct bpf_prog_aux is renamed to
attach_name in patch #1, to avoid possible confusion. Then in patch #2
and #3 I extend the attached name to bpf progs which are attached to a
cgroup or a sockmap. If this solution is acceptable, I will extend it to
other attach types in the next step.

Yafang Shao (3):
  bpf: rename attach_func_name to attach_name
  bpf: set attached cgroup name in attach_name
  bpf: set attached sockmap id in attach_name

 include/linux/bpf.h                           |   3 +-
 kernel/bpf/bpf_iter.c                         |   2 +-
 kernel/bpf/bpf_lsm.c                          |   2 +-
 kernel/bpf/btf.c                              |   2 +-
 kernel/bpf/cgroup.c                           |   8 +
 kernel/bpf/preload/iterators/iterators.bpf.c  |   4 +-
 kernel/bpf/preload/iterators/iterators.skel.h | 488 +++++++++---------
 kernel/bpf/syscall.c                          |   2 +-
 kernel/bpf/verifier.c                         |   4 +-
 net/core/sock_map.c                           |   8 +-
 10 files changed, 276 insertions(+), 247 deletions(-)

-- 
2.17.1

