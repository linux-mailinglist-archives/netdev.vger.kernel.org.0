Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4C3463398
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 12:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbhK3L7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 06:59:06 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:59178 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232493AbhK3L6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 06:58:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9A1F7CE18C4;
        Tue, 30 Nov 2021 11:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F247FC53FCF;
        Tue, 30 Nov 2021 11:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638273316;
        bh=Ds+j+lQV8UcaewkPlo3JdvD2NXuVKhhliI2fPe2o+6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W3bxph7LtE3cUeIPJaaPbffGjvi51NWII/Go0rPVHTyvvZ88TM7YQtZQR7gLY6kAy
         x7B8lttEKeeoW1rHQnILjD1TyXp2TMd18+GrDDqUzwycTWsm264pAS7FfvirFXD+xN
         Gt+v3xRayaubqfDCKCC6gpq1ohFlRiJ8EakhsmhWx7JOYXbrFs75wYZlvTh9hgE6cY
         Sj6TaDb+VU1busDpp7Vz2VuJwTzRHGT0WiEgkCWWlf9qK7Kl04Z5PTarqE64Eg2MwN
         bTWhVaeKrHRlel877cqTI5KXweFh/fJP/NbayGkGg+UDLhMGb0GMA+fkt0Jx2y9X0X
         hZWeAgPZt7JMA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v19 bpf-next 18/23] libbpf: Add SEC name for xdp_mb programs
Date:   Tue, 30 Nov 2021 12:53:02 +0100
Message-Id: <d388fc02aa0c3cb031f832d98f305db878e3a6e6.1638272239.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1638272238.git.lorenzo@kernel.org>
References: <cover.1638272238.git.lorenzo@kernel.org>
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
index b59fede08ba7..ddad9eb2826a 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -265,6 +265,8 @@ enum sec_def_flags {
 	SEC_SLEEPABLE = 8,
 	/* allow non-strict prefix matching */
 	SEC_SLOPPY_PFX = 16,
+	/* BPF program support XDP multi-buff */
+	SEC_XDP_MB = 32,
 };
 
 struct bpf_sec_def {
@@ -6505,6 +6507,9 @@ static int libbpf_preload_prog(struct bpf_program *prog,
 	if (def & SEC_SLEEPABLE)
 		opts->prog_flags |= BPF_F_SLEEPABLE;
 
+	if (prog->type == BPF_PROG_TYPE_XDP && (def & SEC_XDP_MB))
+		opts->prog_flags |= BPF_F_XDP_MB;
+
 	if ((prog->type == BPF_PROG_TYPE_TRACING ||
 	     prog->type == BPF_PROG_TYPE_LSM ||
 	     prog->type == BPF_PROG_TYPE_EXT) && !prog->attach_btf_id) {
@@ -8468,8 +8473,11 @@ static const struct bpf_sec_def section_defs[] = {
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

