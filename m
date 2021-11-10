Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D971044C5EE
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 18:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbhKJR2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 12:28:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbhKJR2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 12:28:46 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CC0C061764;
        Wed, 10 Nov 2021 09:25:58 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so2231505pju.3;
        Wed, 10 Nov 2021 09:25:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jxsEFlYIf6e7+lQEXRxrewNE2YsLXosTxzqGZrpdI4Q=;
        b=EF3fmcyfSgmZQ7SqVtVixsGDpWOXRk7ujmlg/YXhtkvPyowEJWpz2VtXmTIGnTKlSi
         f0yX6bSs6YC5nKb8MT1EtKEee2qtfThBbCRhLHK8QTZLfZILbxLcLGPojn6YhueUA+4n
         1Q8Qy2gk/ZdndY+WBCgiSGhfxHSB/b4od26qdSTLjrR2TpBOijoLu6gutZtQxvs7fTKa
         48fyyflcf4Uen/cfsSrVRrgf16vLpJZQMsT1Pfu5rGM9V3eJSWD2dFGWXS6Itr03eS/o
         iE0NzFcOX+0RAKgA145f2PPE1AXmVZCJeo6ksR8LqjJrv9zfcIBudbgsYDIMpzTjuOtX
         Bojw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jxsEFlYIf6e7+lQEXRxrewNE2YsLXosTxzqGZrpdI4Q=;
        b=pd58uSo6q1/i21oHXZz1fwF2wUs8iJZdU4tijb3hS+x5msM0Ng8sXpDHrJFjuW83tg
         BLQ/O9OBCIVUd2Dqe/HA3EF4j6VEdfKlTs/uE6Qacy0yrFkp60r57ph6nZessHT9clmz
         68f2PB+LxspzlhUQ0tn/7r3GJ5ud4qhiuVMG0rIfq//rxaAZKI8U1Zzat7k3AQkdPDxK
         +PbGzHNmoOdnvGeoQ6OdEm4pmHatO4nw+AIWvhkLZzoT+tt/sZf3ZkXeAmBkzmUFOSnr
         C13NMs1TLG4CRMM/V5av8AZaG3iXFFPVoSwEgFwtrtmd+Yt1/y9mVFIRMz1lZYcW100m
         NJWA==
X-Gm-Message-State: AOAM531Fc98zDgXOmmZrudKc61QC7F5MvfJO9pTs5X3KsyHAXOhI6EsG
        psSJv10WtLMz2QNSJ3nSTcAmNBlGYU0=
X-Google-Smtp-Source: ABdhPJzMvCpX69izWbpiL0sWIBc9ONUJ5tN4dhA77zi6+Lf2qmTsQNklDBIuc5pK/gSW5OLZ0wSNng==
X-Received: by 2002:a17:902:8695:b0:142:7171:abf5 with SMTP id g21-20020a170902869500b001427171abf5mr811220plo.74.1636565158285;
        Wed, 10 Nov 2021 09:25:58 -0800 (PST)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:7abd])
        by smtp.gmail.com with ESMTPSA id g5sm6201149pjt.15.2021.11.10.09.25.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Nov 2021 09:25:57 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, lmb@cloudflare.com, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf] bpf: Fix inner map state pruning regression.
Date:   Wed, 10 Nov 2021 09:25:56 -0800
Message-Id: <20211110172556.20754-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Introduction of map_uid made two lookups from outer map to be distinct.
That distinction is only necessary when inner map has an embedded timer.
Otherwise it will make the verifier state pruning to be conservative
which will cause complex programs to hit 1M insn_processed limit.
Tighten map_uid logic to apply to inner maps with timers only.

Fixes: 3e8ce29850f1 ("bpf: Prevent pointer mismatch in bpf_timer_init.")
Reported-by: Lorenz Bauer <lmb@cloudflare.com>
Tested-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/verifier.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 890b3ec375a3..aab7482ed1c3 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1151,7 +1151,8 @@ static void mark_ptr_not_null_reg(struct bpf_reg_state *reg)
 			/* transfer reg's id which is unique for every map_lookup_elem
 			 * as UID of the inner map.
 			 */
-			reg->map_uid = reg->id;
+			if (map_value_has_timer(map->inner_map_meta))
+				reg->map_uid = reg->id;
 		} else if (map->map_type == BPF_MAP_TYPE_XSKMAP) {
 			reg->type = PTR_TO_XDP_SOCK;
 		} else if (map->map_type == BPF_MAP_TYPE_SOCKMAP ||
-- 
2.30.2

