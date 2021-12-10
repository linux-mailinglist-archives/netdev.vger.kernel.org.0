Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67021470A29
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 20:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343586AbhLJTUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 14:20:09 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37320 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343582AbhLJTUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 14:20:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B295FB829CE;
        Fri, 10 Dec 2021 19:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82369C00446;
        Fri, 10 Dec 2021 19:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639163791;
        bh=2Uiev2Gd++p9Jx2dTIUZq75K9CFvUPYhLwOc1rjsGnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n87ODAE3U2puy+pvvX/1R+iyaqgPcbT/9cyGmNaEAqM0h1eZ3GmVgIiug4wk56GOi
         JzRpHkZQJdDqOI3Dbnzv603fFX+2MLy8IlbSplS8aM4q6jWaIC+DP+/iEw05LoouwT
         FX209xKp2A+LPrMWEqtR789WKOOsvUplG0KYW9a6DqYYVebYXZ//73izVy6cNXnD13
         emVvuvp4VLY5vyORfZ9H55/KALkyRX7yf3M1UnuaStlla3viHpcnPPk3E5w4GDN+PH
         EJaiLgbZqV2t0jvvEW3p0GiFty/20KgRK6ExjiiuAkQtaCmLjsPPiC1DJJB47/f0cM
         yv7SHIyCwE9AA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v20 bpf-next 18/23] libbpf: Add SEC name for xdp_mb programs
Date:   Fri, 10 Dec 2021 20:14:25 +0100
Message-Id: <3c85baafcca54718ad84b7a2c013fa037a4c2af2.1639162845.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1639162845.git.lorenzo@kernel.org>
References: <cover.1639162845.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce support for the following SEC entries for XDP multi-buff
property:
- SEC("xdp_mb/")
- SEC("xdp_devmap_mb/")
- SEC("xdp_cpumap_mb/")

Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 tools/lib/bpf/libbpf.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index d027e1d620fc..71781e4516b7 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -271,6 +271,8 @@ enum sec_def_flags {
 	SEC_SLEEPABLE = 8,
 	/* allow non-strict prefix matching */
 	SEC_SLOPPY_PFX = 16,
+	/* BPF program support XDP multi-buff */
+	SEC_XDP_MB = 32,
 };
 
 struct bpf_sec_def {
@@ -6565,6 +6567,9 @@ static int libbpf_preload_prog(struct bpf_program *prog,
 	if (def & SEC_SLEEPABLE)
 		opts->prog_flags |= BPF_F_SLEEPABLE;
 
+	if (prog->type == BPF_PROG_TYPE_XDP && (def & SEC_XDP_MB))
+		opts->prog_flags |= BPF_F_XDP_MB;
+
 	if ((prog->type == BPF_PROG_TYPE_TRACING ||
 	     prog->type == BPF_PROG_TYPE_LSM ||
 	     prog->type == BPF_PROG_TYPE_EXT) && !prog->attach_btf_id) {
@@ -8603,8 +8608,11 @@ static const struct bpf_sec_def section_defs[] = {
 	SEC_DEF("lsm.s/",		LSM, BPF_LSM_MAC, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_lsm),
 	SEC_DEF("iter/",		TRACING, BPF_TRACE_ITER, SEC_ATTACH_BTF, attach_iter),
 	SEC_DEF("syscall",		SYSCALL, 0, SEC_SLEEPABLE),
+	SEC_DEF("xdp_devmap_mb/",	XDP, BPF_XDP_DEVMAP, SEC_ATTACHABLE | SEC_XDP_MB),
 	SEC_DEF("xdp_devmap/",		XDP, BPF_XDP_DEVMAP, SEC_ATTACHABLE),
+	SEC_DEF("xdp_cpumap_mb/",	XDP, BPF_XDP_CPUMAP, SEC_ATTACHABLE | SEC_XDP_MB),
 	SEC_DEF("xdp_cpumap/",		XDP, BPF_XDP_CPUMAP, SEC_ATTACHABLE),
+	SEC_DEF("xdp_mb/",		XDP, BPF_XDP, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX | SEC_XDP_MB),
 	SEC_DEF("xdp",			XDP, BPF_XDP, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX),
 	SEC_DEF("perf_event",		PERF_EVENT, 0, SEC_NONE | SEC_SLOPPY_PFX),
 	SEC_DEF("lwt_in",		LWT_IN, 0, SEC_NONE | SEC_SLOPPY_PFX),
-- 
2.33.1

