Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEAA495D75
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 11:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379934AbiAUKMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 05:12:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349528AbiAUKME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 05:12:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F78C06173F;
        Fri, 21 Jan 2022 02:12:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9B56B81F6D;
        Fri, 21 Jan 2022 10:12:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABFDC340E8;
        Fri, 21 Jan 2022 10:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642759921;
        bh=e9Hgvpkx/Or8YiqodlOoRf7P8uaEvhixi/SPk4kRqps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eo50M7/7aYOrGTzM0sTlop3nUPcbcpKBopkOhNP/Y3frypElxITtE4k0y655wyua9
         a+5DL03DDk8ADrC/sZf/Tj5vDlfKdTu8VcUzK3VQnHVfNPMTsLgoJsK/dp9eO9DwYL
         8ZC6NCS0/SEPgCD4cilAFlxqJjKxvKybX/eYXpXawKSF+zwF+jXsvfoUU02s7xGkmu
         aL7IHccpDkyI2XYjV2mpi/Uw5mtWE7PoKzOaCa85FQddowFGcMZ6kcK2HX/luMuGXT
         QKXNgEOwt/9cuGOTuvzt8Uf7if5K+PLfNYbnC03muUi4pZW37xBddIjemtQM21nG1l
         qNfFp8WfaKGfQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com,
        andrii.nakryiko@gmail.com
Subject: [PATCH v23 bpf-next 18/23] libbpf: Add SEC name for xdp frags programs
Date:   Fri, 21 Jan 2022 11:10:01 +0100
Message-Id: <af23b6e4841c171ad1af01917839b77847a4bc27.1642758637.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1642758637.git.lorenzo@kernel.org>
References: <cover.1642758637.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce support for the following SEC entries for XDP frags
property:
- SEC("xdp.frags")
- SEC("xdp.frags/devmap")
- SEC("xdp.frags/cpumap")

Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 tools/lib/bpf/libbpf.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index fc6d530e20db..a8c750373ad5 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -235,6 +235,8 @@ enum sec_def_flags {
 	SEC_SLEEPABLE = 8,
 	/* allow non-strict prefix matching */
 	SEC_SLOPPY_PFX = 16,
+	/* BPF program support non-linear XDP buffer */
+	SEC_XDP_FRAGS = 32,
 };
 
 struct bpf_sec_def {
@@ -6570,6 +6572,9 @@ static int libbpf_preload_prog(struct bpf_program *prog,
 	if (def & SEC_SLEEPABLE)
 		opts->prog_flags |= BPF_F_SLEEPABLE;
 
+	if (prog->type == BPF_PROG_TYPE_XDP && (def & SEC_XDP_FRAGS))
+		opts->prog_flags |= BPF_F_XDP_HAS_FRAGS;
+
 	if ((prog->type == BPF_PROG_TYPE_TRACING ||
 	     prog->type == BPF_PROG_TYPE_LSM ||
 	     prog->type == BPF_PROG_TYPE_EXT) && !prog->attach_btf_id) {
@@ -8608,8 +8613,11 @@ static const struct bpf_sec_def section_defs[] = {
 	SEC_DEF("lsm.s/",		LSM, BPF_LSM_MAC, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_lsm),
 	SEC_DEF("iter/",		TRACING, BPF_TRACE_ITER, SEC_ATTACH_BTF, attach_iter),
 	SEC_DEF("syscall",		SYSCALL, 0, SEC_SLEEPABLE),
+	SEC_DEF("xdp.frags/devmap",	XDP, BPF_XDP_DEVMAP, SEC_XDP_FRAGS),
 	SEC_DEF("xdp_devmap/",		XDP, BPF_XDP_DEVMAP, SEC_ATTACHABLE),
+	SEC_DEF("xdp.frags/cpumap",	XDP, BPF_XDP_CPUMAP, SEC_XDP_FRAGS),
 	SEC_DEF("xdp_cpumap/",		XDP, BPF_XDP_CPUMAP, SEC_ATTACHABLE),
+	SEC_DEF("xdp.frags",		XDP, BPF_XDP, SEC_XDP_FRAGS),
 	SEC_DEF("xdp",			XDP, BPF_XDP, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX),
 	SEC_DEF("perf_event",		PERF_EVENT, 0, SEC_NONE | SEC_SLOPPY_PFX),
 	SEC_DEF("lwt_in",		LWT_IN, 0, SEC_NONE | SEC_SLOPPY_PFX),
-- 
2.34.1

