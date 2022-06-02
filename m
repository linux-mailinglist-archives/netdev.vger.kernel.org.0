Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA3AF53BD62
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 19:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237524AbiFBRhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 13:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232302AbiFBRho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 13:37:44 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A639DF2;
        Thu,  2 Jun 2022 10:37:43 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id r71so5364392pgr.0;
        Thu, 02 Jun 2022 10:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VIw0jx/gMUEvsJmM+/5RlSJMb06H6BJ9K5QCFP2rQMg=;
        b=KtlTfiCq4PT65fZ4LfDMNcvBagLpBZb2uplPAkwVnDKaP0Aqc/BBWCAzjjE9D4cQPr
         G3jTTfXDqkoKwETeuNqYqCcuPIqp9QG00jyo1nHZ1j1w4w3/WJWsTxdIsH60Nm9MuSdp
         gI3H6bssJdvBQzZbjg3G/xGe/kJObR8tfJP1RDKrjpjxJSey1v+VK6CE/FYg5rq9RTVj
         wzEd3OIkBeY45OrX2JJ2mnihyo2QkppqMOrpR8c4aYaBAP9BYfWMH0BK0pE5A3DfUHSG
         cnbLEPxrZMg+QRIPKSxqG2M+tI//RZ31kW56WDby0VrdehEkD8pwUqdMYb4hOY1PDpfL
         gXPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VIw0jx/gMUEvsJmM+/5RlSJMb06H6BJ9K5QCFP2rQMg=;
        b=Y3PtCuTLbO/guBsJzkK4oYcm/xAeP3/I0FtgDYqbw6DTi2liQbh+QR9Bh0fJRDkuu1
         MmhrGg/9mQwzlrCyvXrZICHwhRuF+8WYMOc3JPOFbLre6P0dc6n68VaCa1HUO0O2ye4n
         Ljw+sTWY+L7NWY6NBwXxd82cXKeiYTBwd52PToxchWtsJCJgJqhXG3XdEfoOat2tBm15
         7Aihh+DPH0tvgxnhz9L/G+rb4xDm0SC6lyPIWbdzfMPn5r7/eb3n9LJMAKcAZLb/JnaG
         FdbvuRfI6DC3CNJcHe20TwmTSOXQ9/yyYlEMxF4hr4FXPI7p8HUSuQ/4il+rJRiU1GRm
         Cr+A==
X-Gm-Message-State: AOAM530qXjTUz19m2NMPXZ/ye9Bt6wKH00wQw5YTLbw/QxLgSe6oHEX3
        m17eic97+fmEDBgblix7X0Y=
X-Google-Smtp-Source: ABdhPJwBC2SS+XVoOiwT4apRShJMjxpAz3y5y/KAfeeUbASgNegfjXk0ofOupgBnKGuMCTDiRAS+6w==
X-Received: by 2002:a65:5cc2:0:b0:3fc:20d2:30ed with SMTP id b2-20020a655cc2000000b003fc20d230edmr5114720pgt.158.1654191462889;
        Thu, 02 Jun 2022 10:37:42 -0700 (PDT)
Received: from localhost.localdomain ([122.179.233.138])
        by smtp.googlemail.com with ESMTPSA id a1-20020a056a001d0100b00518950bfc82sm3714767pfx.10.2022.06.02.10.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 10:37:42 -0700 (PDT)
From:   Varshini Elangovan <varshini.elangovan@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Varshini Elangovan <varshini.elangovan@gmail.com>
Subject: [PATCH] staging: r8188eu: Add queue_index to xdp_rxq_info
Date:   Thu,  2 Jun 2022 23:06:57 +0530
Message-Id: <20220602173657.36252-1-varshini.elangovan@gmail.com>
X-Mailer: git-send-email 2.25.1
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

Queue_index from the xdp_rxq_info is populated in cpumap file.
Using the NR_CPUS, results in patch check warning, as recommended,
using the num_possible_cpus() instead of NR_CPUS

Signed-off-by: Varshini Elangovan <varshini.elangovan@gmail.com>
---
 kernel/bpf/cpumap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 650e5d21f90d..756fd81f474c 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -102,8 +102,8 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 
 	bpf_map_init_from_attr(&cmap->map, attr);
 
-	/* Pre-limit array size based on NR_CPUS, not final CPU check */
-	if (cmap->map.max_entries > NR_CPUS) {
+	/* Pre-limit array size based on num_possible_cpus, not final CPU check */
+	if (cmap->map.max_entries > num_possible_cpus()) {
 		err = -E2BIG;
 		goto free_cmap;
 	}
@@ -227,7 +227,7 @@ static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_map_entry *rcpu,
 
 		rxq.dev = xdpf->dev_rx;
 		rxq.mem = xdpf->mem;
-		/* TODO: report queue_index to xdp_rxq_info */
+		rxq.queue_index = ++i;
 
 		xdp_convert_frame_to_buff(xdpf, &xdp);
 
-- 
2.25.1

