Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E9B3F3792
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 02:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbhHUAVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 20:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240908AbhHUAVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 20:21:11 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F9BC061575;
        Fri, 20 Aug 2021 17:20:32 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id y23so10803188pgi.7;
        Fri, 20 Aug 2021 17:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v8/K5I2fQPtp6vCigst1Xg1F2TEisQ0O4autAAoKNdg=;
        b=mvzRymbGOoiI9tK0P47suAyYSdvntwS+xpldQCvHxlg251AX2+RqbC0EpwMANUj0im
         +SpIniWv8H8vQyjRviQ5HDrHbzvbcdoIOjE9MTgtdU8fTBfmo4SKNT2S/kp8a1PaDSEX
         68jNDUC9jlma0JlpDr1UKJOYwAxR0HEMll2QBJE+dB0v7w7V4XVSS6M/655Ven7QN0Sp
         4FLsKIDWuhkOzXtv2BpBlY/yzs6FcE17aA/FFO/Q7zhxkk8oDP2lfdacI8k+UDudJAKG
         yFWULrLJCsXEAp4Nt7J0J6aso7zgE4L2gEwkp9OCWA2lrSo1IKbsSaShzEsi1ihkatEO
         oRjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v8/K5I2fQPtp6vCigst1Xg1F2TEisQ0O4autAAoKNdg=;
        b=BBTRtYzdnn4MNkDFxheSmy3XaMprbUhl8vAE62cEtcHgZ5HMVA7ZGnpU0I3opapVRO
         93jfowOdpNvuqGJi3rUWuVag8SEWLY4L/BO4wRqCiFW8LHrB4ovfSuSW/ekl+zdx2muM
         4bIUSzhfaBWo0ln/9epxUird3CBLjh8bz4dD2+yg806F1BC29CmaV0z2dFc9PUxkVvgO
         DdQU4WqgWAG+4jDsCvrdfMzC2GhKa2ZUgu36J7f52GTq01fTXErw18PC6vSckKeRaPOi
         aVIOhfD2WtyI32ytUIM9dj37vq3mvsntRd6fEHKcgWjb57bdinZO2EevY61Tt6tWgy+M
         Cq7g==
X-Gm-Message-State: AOAM533l1zC7E5AffDu8h3SDlPgramvr3GMD4cIYw4yF3kMh37n+Qs5r
        Wk8eMu9q/lnqpJmHoUDzRLrSoYcxwoA=
X-Google-Smtp-Source: ABdhPJx6267pwGb8wvSykhUUr51/qDdYXZUbWLWwr2wd5pow5gt9qAQToN51SKEjLjOR/+ZnB8txdA==
X-Received: by 2002:a65:5a89:: with SMTP id c9mr21072821pgt.274.1629505232002;
        Fri, 20 Aug 2021 17:20:32 -0700 (PDT)
Received: from localhost ([2405:201:6014:d820:9cc6:d37f:c2fd:dc6])
        by smtp.gmail.com with ESMTPSA id g26sm9498889pgb.45.2021.08.20.17.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 17:20:31 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v4 06/22] samples: bpf: Add BPF support for xdp_exception tracepoint
Date:   Sat, 21 Aug 2021 05:49:54 +0530
Message-Id: <20210821002010.845777-7-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210821002010.845777-1-memxor@gmail.com>
References: <20210821002010.845777-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This would allow us to store stats for each XDP action, including their
per-CPU counts. Consolidating this here allows all redirect samples to
detect xdp_exception events.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/xdp_sample.bpf.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/samples/bpf/xdp_sample.bpf.c b/samples/bpf/xdp_sample.bpf.c
index e22f2a97a988..53ab5a972405 100644
--- a/samples/bpf/xdp_sample.bpf.c
+++ b/samples/bpf/xdp_sample.bpf.c
@@ -8,6 +8,7 @@
 
 array_map rx_cnt SEC(".maps");
 array_map redir_err_cnt SEC(".maps");
+array_map exception_cnt SEC(".maps");
 
 const volatile int nr_cpus = 0;
 
@@ -110,3 +111,29 @@ int BPF_PROG(tp_xdp_redirect_map, const struct net_device *dev,
 {
 	return xdp_redirect_collect_stat(dev->ifindex, err);
 }
+
+SEC("tp_btf/xdp_exception")
+int BPF_PROG(tp_xdp_exception, const struct net_device *dev,
+	     const struct bpf_prog *xdp, u32 act)
+{
+	u32 cpu = bpf_get_smp_processor_id();
+	struct datarec *rec;
+	u32 key = act, idx;
+
+	if (!IN_SET(from_match, dev->ifindex))
+		return 0;
+	if (!IN_SET(to_match, dev->ifindex))
+		return 0;
+
+	if (key > XDP_REDIRECT)
+		key = XDP_REDIRECT + 1;
+
+	idx = key * nr_cpus + cpu;
+	rec = bpf_map_lookup_elem(&exception_cnt, &idx);
+	if (!rec)
+		return 0;
+	NO_TEAR_INC(rec->dropped);
+
+	return 0;
+}
+
-- 
2.33.0

