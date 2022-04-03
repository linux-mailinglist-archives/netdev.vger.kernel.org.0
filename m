Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE5E4F0A47
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 16:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357765AbiDCOpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 10:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349257AbiDCOpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 10:45:04 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997A53388D;
        Sun,  3 Apr 2022 07:43:10 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id o13so6258346pgc.12;
        Sun, 03 Apr 2022 07:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0/gazJHiFlW/AH9lpgprZLWTjDNEOQetSqqSN3/vwJQ=;
        b=IAbsiGLJqJXA0e+WJB17R+9efTUYcfEoWJ6fvP3P3DGoR50WrRGFJXBCp+9dNDXaz/
         w4RrQBfn9QfgqGVQFtWeI9t+jVTpKIBR9J9T4TOW8JsL4CByJV5kZpwnCO0n4pvnp12Y
         1rILQbBxqLurJF1BH7dJ3T8q277p0i0kPQ8pXDG9PA8omynjSQ4XMox06Tx7yAFxIhF2
         0hlAXeHK04T5ykB/dWj8UKGfdFr+2bSt98TAAzn8PfQMjpNInrMhKgDzqyd9QRPdj+OL
         qnP2w6YkJeRcqrifwQ9RHl4JM27+1Dqcqj4zxDoSx9BiU2CQGVCqYUl9T5mBcRb1wC2j
         y8Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0/gazJHiFlW/AH9lpgprZLWTjDNEOQetSqqSN3/vwJQ=;
        b=50T43s6P++dU2aqAs/smQdl5+u0n7sh+HigKGRL4l1zrJhaEKj9vr/OV7Y1oXf+vBj
         wE7+QH/Ao4mgtK/iVbYRIdwvafS592RCQKYdPvT2KLe7a7W5XWuCNJmKkOmxsuqUUpZT
         5pkVzoiVbWuA+hq5OLxKk6LkVQxxEa8yvW7uZdtvG7201Z1y+milJVTVBdjR1FoGWSSl
         jW1KcLCsoocNWDssHgFLX54MN3nradDkGTKN4a17gmSl6S9QSLcvCDb/UIzJQu3zXPby
         DRnvkehCV/yT858i70Ozdlwv4q4l2PuRBs1FL96zHdVRndJGryXy0y8+7zYZGDOMI09/
         guWg==
X-Gm-Message-State: AOAM532OdCuYx/mECDoqW5QW413UgWkgarMO8V48Jnw/OvLAa+6hnzYs
        W9FHF4d8Xg/dUkEYApdo88rIjYD47wphMQ==
X-Google-Smtp-Source: ABdhPJyjGb+Hsubix+rFuBuYHoQL4VmJ7RUlCyydkotI6lWSKAyNX7VnNjdNjPyvrRByg8j3um+78w==
X-Received: by 2002:a05:6a00:1312:b0:4e1:58c4:ddfd with SMTP id j18-20020a056a00131200b004e158c4ddfdmr19666180pfu.65.1648996989793;
        Sun, 03 Apr 2022 07:43:09 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:51a7:5400:3ff:feee:9f61])
        by smtp.gmail.com with ESMTPSA id c18-20020a056a000ad200b004cdccd3da08sm9464910pfl.44.2022.04.03.07.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 07:43:09 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v2 0/9] bpf: RLIMIT_MEMLOCK cleanups
Date:   Sun,  3 Apr 2022 14:42:51 +0000
Message-Id: <20220403144300.6707-1-laoar.shao@gmail.com>
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

We have switched to memcg based memory accouting and thus the rlimit is
not needn't any more. LIBBPF_STRICT_AUTO_RLIMIT_MEMLOCK is introduced in
libbpf for backward compatibility, so we can use it instead now.

v2: use libbpf_set_strict_mode instead. (Andrii)
v1: https://lore.kernel.org/bpf/20220320060815.7716-2-laoar.shao@gmail.com/

Yafang Shao (9):
  bpf: selftests: Use libbpf 1.0 API mode in bpf constructor
  bpf: selftests: Use bpf strict all ctor in xdping
  bpf: selftests: Use bpf strict all ctor in xdpxceiver
  bpf: samples: Replace RLIMIT_MEMLOCK with LIBBPF_STRICT_ALL in
    xdpsock_user
  bpf: samples: Replace RLIMIT_MEMLOCK with LIBBPF_STRICT_ALL in xsk_fwd
  bpf: runqslower: Replace RLIMIT_MEMLOCK with LIBBPF_STRICT_ALL
  bpf: bpftool: Remove useless return value of libbpf_set_strict_mode
  bpf: bpftool: Set LIBBPF_STRICT_AUTO_RLIMIT_MEMLOCK for legacy libbpf
  bpf: bpftool: Remove useless rlimit setting

 samples/bpf/xdpsock_user.c               |  9 ++------
 samples/bpf/xsk_fwd.c                    |  7 ++-----
 tools/bpf/bpftool/common.c               |  7 -------
 tools/bpf/bpftool/feature.c              |  2 --
 tools/bpf/bpftool/main.c                 |  6 +++---
 tools/bpf/bpftool/main.h                 |  2 --
 tools/bpf/bpftool/map.c                  |  2 --
 tools/bpf/bpftool/pids.c                 |  1 -
 tools/bpf/bpftool/prog.c                 |  3 ---
 tools/bpf/bpftool/struct_ops.c           |  2 --
 tools/bpf/runqslower/runqslower.c        | 17 ++--------------
 tools/testing/selftests/bpf/bpf_rlimit.h | 26 +++---------------------
 tools/testing/selftests/bpf/xdping.c     |  8 +-------
 tools/testing/selftests/bpf/xdpxceiver.c |  7 ++-----
 14 files changed, 15 insertions(+), 84 deletions(-)

-- 
2.17.1

