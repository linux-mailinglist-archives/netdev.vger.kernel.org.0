Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCA44458B9
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 18:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbhKDRj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 13:39:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:49194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233937AbhKDRj5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 13:39:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61D1860EE9;
        Thu,  4 Nov 2021 17:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636047439;
        bh=mW5ZjbyPPi2DH2+lgYFNf1lKmOrMkpha488cmzwdbvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fi+HT/C983f9he9aEGBzNR1WBiBhfT16wLSVieu4yR1dqbDMlsAwKCAdCm/j3ITYH
         ViUMOou5WsCSvvG2tuUQPc6aCG7cmU9YXyJo9HdZePAFgj/liRDI5zC5z14xQGsmCq
         M8Aee4CJWMue3B2kki8UVoxaz59TtErJ/DptJ28LwbjOIbXRtLRusjOB7hxim3GZBl
         AmQQrhzzdwJZ11isRRHwmcGID5J7Z5o+m2hDcAFb2TNs2LcRvM+bYbrtUm2ykS2l0v
         4T7vKsdekmgwGn8Mp/mcX1iDv6OmKMJJsgGng6UuCgwDieoDdfhARMeMRVGH7obxEc
         xeLRY4pzZX1Fw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v17 bpf-next 18/23] libbpf: Add SEC name for xdp_mb programs
Date:   Thu,  4 Nov 2021 18:35:38 +0100
Message-Id: <b92cfb4772aef9e09587bb14693c6d545ce09bdc.1636044387.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1636044387.git.lorenzo@kernel.org>
References: <cover.1636044387.git.lorenzo@kernel.org>
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
index 7fcea11ecaa9..e5c668dc685c 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -244,6 +244,8 @@ enum sec_def_flags {
 	SEC_SLEEPABLE = 8,
 	/* allow non-strict prefix matching */
 	SEC_SLOPPY_PFX = 16,
+	/* BPF program support XDP multi-buff */
+	SEC_XDP_MB = 32,
 };
 
 struct bpf_sec_def {
@@ -6402,6 +6404,9 @@ static int libbpf_preload_prog(struct bpf_program *prog,
 	if (def & SEC_SLEEPABLE)
 		attr->prog_flags |= BPF_F_SLEEPABLE;
 
+	if (prog->type == BPF_PROG_TYPE_XDP && (def & SEC_XDP_MB))
+		attr->prog_flags |= BPF_F_XDP_MB;
+
 	if ((prog->type == BPF_PROG_TYPE_TRACING ||
 	     prog->type == BPF_PROG_TYPE_LSM ||
 	     prog->type == BPF_PROG_TYPE_EXT) && !prog->attach_btf_id) {
@@ -8351,8 +8356,11 @@ static const struct bpf_sec_def section_defs[] = {
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

