Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1B1C2AD59D
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 12:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730001AbgKJLub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 06:50:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgKJLua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 06:50:30 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19D7C0613CF;
        Tue, 10 Nov 2020 03:50:30 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id i13so5156046pgm.9;
        Tue, 10 Nov 2020 03:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=p+dPo5Nor05wuovR0c6UnJD/voeXx9YRJtXia/hy3Zw=;
        b=fCg0TgR+jpA9j9Y/VEr97afhrKhAbL5CDvKaW/BiZ/hckKXTrhB6EcteF272R8ZGHl
         8h7kXUZI5/b55N9GDe1Yz25nefwGwVoDeRvp5VRyY8NOHQ/Q5qHQvbT5t1iCkoIGFZ1o
         56CF74awHofGO37uIOV5GiBDQI7xEA33IeRtTQ8mMVL1bW87XVZMzOzvIaEvWKAX2lPd
         o3wGywZwup31qatKFNtxH5vaGmFuYIQWCpPigDO4N52sIAgLLOAl/VbT+t9+RrRv3RbC
         4nIvcgGFR4WzJHEawZgNX9EjPmMqlm2GrGMeVUdG3BG6ellwE4HlR6fGPCj7ymRJEUhe
         G3Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=p+dPo5Nor05wuovR0c6UnJD/voeXx9YRJtXia/hy3Zw=;
        b=KS9XGNhLnclrMrSAVjtCwnkL81ybDA9nIu5c0uFipoOrwEVgL1YB5cfejnsbuqULOv
         8/fN1vRulhfvlmmCn8jIUzerb32w/JlsHSIYFMxK5wSGSAS7Ft8S+PUyfn0HokjzspQ/
         ce+sJxPuQb10yKXRPHubT7f/W40naOJOr4kUtbalhScQ8RUxaQH5JUrZLBAcPME7fHtK
         RJPN9hM5zR6wM6kI6KsYiG4ECFwBWVHIcoVaaow55tKR+UBwRUzG3AmsmWmyprFNlxpC
         /PsAHT0jQYtkdWxScPryf1WeUkrQr4oMT+9vUpM78fWTmtdDI9cFOWhcAs9KwQ4ep9yX
         +ezQ==
X-Gm-Message-State: AOAM531z2SWVbObBeEOtNXzt/UPaxNPbnnc7tOfH4Lt+ZmYmAII/JDrD
        BtalffHl42ruhLpZ19/UsA==
X-Google-Smtp-Source: ABdhPJzPiPFDINPvm4OQBQAe67qMavnKXd/PMDotrvrXwYDZEWQtxrXgQY/wUV/xJlwBW3JB3aoyOA==
X-Received: by 2002:a62:b417:0:b029:18b:8c55:849f with SMTP id h23-20020a62b4170000b029018b8c55849fmr17446444pfn.27.1605009030471;
        Tue, 10 Nov 2020 03:50:30 -0800 (PST)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id t18sm2978679pjs.56.2020.11.10.03.50.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Nov 2020 03:50:29 -0800 (PST)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andrii@kernel.org,
        john.fastabend@gmail.com, kpsingh@chromium.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] bpf: Fix unsigned 'datasec_id' compared with zero in check_pseudo_btf_id
Date:   Tue, 10 Nov 2020 19:50:19 +0800
Message-Id: <1605009019-22310-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

The unsigned variable datasec_id is assigned a return value from the call
to check_pseudo_btf_id(), which may return negative error code.

Fixes coccicheck warning:

./kernel/bpf/verifier.c:9616:5-15: WARNING: Unsigned expression compared with zero: datasec_id > 0

Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 kernel/bpf/verifier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6200519582a6..e9d8d4309bb4 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9572,7 +9572,7 @@ static int check_pseudo_btf_id(struct bpf_verifier_env *env,
 			       struct bpf_insn *insn,
 			       struct bpf_insn_aux_data *aux)
 {
-	u32 datasec_id, type, id = insn->imm;
+	s32 datasec_id, type, id = insn->imm;
 	const struct btf_var_secinfo *vsi;
 	const struct btf_type *datasec;
 	const struct btf_type *t;
-- 
2.20.0

