Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5142414767
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 13:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235461AbhIVLN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 07:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235337AbhIVLN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 07:13:27 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D248C061574
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 04:11:57 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id u15so5593328wru.6
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 04:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l4RZloahyjRG1N22DwCCx53LlP6k68dsBh8lyrVMOyo=;
        b=gbswmujyBsd2CIJuI3gzzCLsbyFRnmyRBqDclILKZVritJh8jDMpBlnTOO0nocX0fp
         zovRbA0fyZmPgqOOQ0nsexInmOgyXqDrjcdUBsd2RXmZu7p3acio55fC35YScnlktUIm
         kHLMdb8Q4R0CA61qA3ED8wj5iB2eicH7aUeg0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l4RZloahyjRG1N22DwCCx53LlP6k68dsBh8lyrVMOyo=;
        b=Ad3xSJaKG+Y4kjvbnigNGRvNujYaiasV/fD9jY/vfKPmG0Ovs+wa8npbUrrAPFCIej
         7Nebk1H+dJnqeFSZpT+PCTXv0HdeWFgBEhLo4wibVJKT5KDPINGP23XUWyP+tPSAi+tV
         4XDXfyzaG09akKOTT/KrQz2APXGPIfbjDVgLq6RsPdUOLL2Sel6zv6JmHye9qttZeUyl
         9yTGB6TYeS+pTdaU65M+Uar+bmEAc5DMLDql3kwAYXmqkmuR0joN5Vo/bNLLx1ENItUs
         WETPoua4nZ6HDnNo13rCnM/G0Hm4lTaREbFbcTh6/5ahQ6vrw8L5COVN0vITXSHUByQc
         xv7A==
X-Gm-Message-State: AOAM531uda+eQjgRtghElLMGTOKl6sLCrKUvz3uMJ8qvn9Af0GFxczZB
        nROXvaemZwffGZ/zgnp4mdch2R74szez0w==
X-Google-Smtp-Source: ABdhPJxtHsOFHbiS/18610VQUz0RdN+h1oScAaTvhgCh5TQSBq2i0RtCNIFMgN7xQj9MNjrtbXENQg==
X-Received: by 2002:a05:600c:3543:: with SMTP id i3mr9852341wmq.64.1632309115787;
        Wed, 22 Sep 2021 04:11:55 -0700 (PDT)
Received: from antares.. (5.a.d.0.d.e.5.9.1.b.e.2.d.e.9.c.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:c9ed:2eb1:95ed:da5])
        by smtp.gmail.com with ESMTPSA id i9sm5966205wmi.44.2021.09.22.04.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 04:11:55 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf] bpf: exempt CAP_BPF from checks against bpf_jit_limit
Date:   Wed, 22 Sep 2021 12:11:52 +0100
Message-Id: <20210922111153.19843-1-lmb@cloudflare.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When introducing CAP_BPF, bpf_jit_charge_modmem was not changed to
treat programs with CAP_BPF as privileged for the purpose of JIT
memory allocation. This means that a program without CAP_BPF can
block a program with CAP_BPF from loading a program.

Fix this by checking bpf_capable in bpf_jit_charge_modmem.

Fixes: 2c78ee898d8f ("bpf: Implement CAP_BPF")
Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 kernel/bpf/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 6fddc13fe67f..ea8a468dbded 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -827,7 +827,7 @@ int bpf_jit_charge_modmem(u32 pages)
 {
 	if (atomic_long_add_return(pages, &bpf_jit_current) >
 	    (bpf_jit_limit >> PAGE_SHIFT)) {
-		if (!capable(CAP_SYS_ADMIN)) {
+		if (!bpf_capable()) {
 			atomic_long_sub(pages, &bpf_jit_current);
 			return -EPERM;
 		}
-- 
2.30.2

