Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE5A447FD3A
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 14:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbhL0NHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 08:07:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbhL0NHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 08:07:36 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FADC06173E
        for <netdev@vger.kernel.org>; Mon, 27 Dec 2021 05:07:35 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id 8so13642051pfo.4
        for <netdev@vger.kernel.org>; Mon, 27 Dec 2021 05:07:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y24iSF3ID8CUJS4FrvPuWUAAeYS2AO0M/jvrLGgFbaw=;
        b=ZrIbG5bUpVdp4lZFLowZk4DxTKvkx1+CQ12zbAujnzKU/3o/oZliX8SF8mSeKscTIx
         wZlrh6q13r9Wh/coRRafQbspg07tbrhgIf1cHvEksbFr4cda2Nfc6ieTzTE+WNhjN6ie
         0+TPijORNIGlfxHSMgTKcQaLGSmp4HYeCzI0mL7XscBBVlSz5Pmqcw7mehJgFBy7wCUo
         w7CGuRLjHaiw5gzVYbB7+hNUgqfxHLVgZPdB3dPbTA9JLJSGBc5/PH2Ocq8rVmNnD8I8
         vXAwb7WM16/wmi1QohSiej50yB4nKc+99E3uxjEaRTYRPfbtXBvQajRKMV7JJJdg64Tf
         G79Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y24iSF3ID8CUJS4FrvPuWUAAeYS2AO0M/jvrLGgFbaw=;
        b=P4UM8s0WROW1s9NABPRIZGVGV88SMYaDsKOb+e4h+5zCqey8tcHfuEL3WwPmreRnfq
         tCzN693xHfp12OnBNEcP+TQdLnp3kbfffhsvdCVi6tOXUI+PtlTjG3uJssSK6lZ7+LPU
         rn1vxZZKeyJfWt+H1BC8W+Nh3OufS0qVxmJTV/pSvxOYid4sMWHIfLi9uNKC3RcUMNX5
         tsnBo6OjFp/BEL9JwySnSKUlB9SPDFDRYYLiqGWBJMqsbJMzPIRCRc32QQrufPXcinDa
         8wJvCTVISfALPhy0jBA5jAIJoUzMI438Yh4jML6E3xLX+fW6505MGo3y29xP2pf4fZZi
         CqMw==
X-Gm-Message-State: AOAM531gGSZEZ3oks1QpCjb85DaIM4fF+CW+uZigNvHa297Vd8RA6Ugm
        dJqUVMtOz2YXkxzZdzW9AEFLXA==
X-Google-Smtp-Source: ABdhPJzKdxOFpsR/ezcVv2IbNLcTNk8WTaCUNsbNZ6DpCtojj8YifP//Qk2WQcO0cr4spwiYuZpXBA==
X-Received: by 2002:a63:3c0c:: with SMTP id j12mr6889915pga.305.1640610455270;
        Mon, 27 Dec 2021 05:07:35 -0800 (PST)
Received: from C02FJ0LUMD6V.bytedance.net ([139.177.225.228])
        by smtp.gmail.com with ESMTPSA id d21sm18060136pfv.45.2021.12.27.05.07.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Dec 2021 05:07:34 -0800 (PST)
From:   Qiang Wang <wangqiang.wq.frank@bytedance.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, hengqi.chen@gmail.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhouchengming@bytedance.com,
        songmuchun@bytedance.com, duanxiongchun@bytedance.com,
        shekairui@bytedance.com,
        Qiang Wang <wangqiang.wq.frank@bytedance.com>
Subject: [PATCH v2 1/2] libbpf: Use probe_name for legacy kprobe
Date:   Mon, 27 Dec 2021 21:07:12 +0800
Message-Id: <20211227130713.66933-1-wangqiang.wq.frank@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a bug in commit 46ed5fc33db9, which wrongly used the
func_name instead of probe_name to register legacy kprobe.

Fixes: 46ed5fc33db9 ("libbpf: Refactor and simplify legacy kprobe code")
Reviewed-by: Hengqi Chen <hengqi.chen@gmail.com>
Tested-by: Hengqi Chen <hengqi.chen@gmail.com>
Co-developed-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Qiang Wang <wangqiang.wq.frank@bytedance.com>
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 7c74342bb668..b7d6c951fa09 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -9735,7 +9735,7 @@ bpf_program__attach_kprobe_opts(const struct bpf_program *prog,
 		gen_kprobe_legacy_event_name(probe_name, sizeof(probe_name),
 					     func_name, offset);
 
-		legacy_probe = strdup(func_name);
+		legacy_probe = strdup(probe_name);
 		if (!legacy_probe)
 			return libbpf_err_ptr(-ENOMEM);
 
-- 
2.20.1

