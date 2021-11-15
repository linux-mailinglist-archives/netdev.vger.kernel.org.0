Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AED84517E4
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 23:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350341AbhKOWt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 17:49:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:46810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351194AbhKOWlU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 17:41:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D29D63255;
        Mon, 15 Nov 2021 22:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637015701;
        bh=73lxYFHaHxeaMF6Swom4qxMjlX8GumGdORwW2xtMj8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eM+UElAqTmuKMzw3CxuUSHdcxJM+Ybnlu/PLTocPGcwImWIaedZxv1+lsTmPEjvxZ
         DE9/7q2LPHxLZ/XzTA009qvUoQq/b+ffH2njJcP3NRuLKcrT5YojyEryUyMkuqLHGR
         qibKVTY/35YDb18Mej5ANaRQ0zZpP8eSjJ+q314V2PXq/5hr1UpiSR2w3GNey64169
         52xU3Eyxo7xHoDoG5tdWWJVISdkQK0G/1bS/9CYe7tVzL8yG9qgQZXRr1RygMmNxqn
         3awvTi+XDFd2PHtoBemYtWGDmtysisMyQhBsRMwLJVstwzBCezHfYLnxjB4O/Oq5t9
         w6POuBsN1zrcw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v18 bpf-next 18/23] libbpf: Add SEC name for xdp_mb programs
Date:   Mon, 15 Nov 2021 23:33:12 +0100
Message-Id: <847d484d767e81d845c628e8f24693b45c2dfaf0.1637013639.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1637013639.git.lorenzo@kernel.org>
References: <cover.1637013639.git.lorenzo@kernel.org>
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

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 tools/lib/bpf/libbpf.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index de7e09a6b5ec..fc0540d334c4 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -246,6 +246,8 @@ enum sec_def_flags {
 	SEC_SLEEPABLE = 8,
 	/* allow non-strict prefix matching */
 	SEC_SLOPPY_PFX = 16,
+	/* BPF program support XDP multi-buff */
+	SEC_XDP_MB = 32,
 };
 
 struct bpf_sec_def {
@@ -6384,6 +6386,9 @@ static int libbpf_preload_prog(struct bpf_program *prog,
 	if (def & SEC_SLEEPABLE)
 		opts->prog_flags |= BPF_F_SLEEPABLE;
 
+	if (prog->type == BPF_PROG_TYPE_XDP && (def & SEC_XDP_MB))
+		opts->prog_flags |= BPF_F_XDP_MB;
+
 	if ((prog->type == BPF_PROG_TYPE_TRACING ||
 	     prog->type == BPF_PROG_TYPE_LSM ||
 	     prog->type == BPF_PROG_TYPE_EXT) && !prog->attach_btf_id) {
@@ -8350,8 +8355,11 @@ static const struct bpf_sec_def section_defs[] = {
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
2.31.1

