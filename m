Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D21242F1E9
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 15:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239364AbhJONMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 09:12:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239358AbhJONMn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 09:12:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBDF161151;
        Fri, 15 Oct 2021 13:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634303436;
        bh=y+VIQ6gYgEGg+yQtJUDCekJ1gmSJf3kzkfaDMO+CdMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UgPq/X1wgcPYX+m5hpVZlHH8z1r/2X4ZIT0scdxtLsyTjsWIVAfGKBsgfb2TtQFi5
         PlnSnxrkAc2zbyLrD+E8t9VBjUV7ziqFsT2+QFvL6KbT+fvcmBW4KQit64DdrbMcPb
         j9gCWopKxN4S1yJuLbTbnVb6sdUETZTYvZDlJS5kIxAX94Pg7HnIdDQ5pnTQVBt/1O
         KRXAlXWIcyYkwrt7KO8EH2WJ2/sRXI3OJmxmd4FzXzPlvqTDq82S9TdhQND/B8oYsD
         J3QwLldZ7oJ3ZSz4xC1pNKmOBJWMTcdgb1J0wFXsjw+g4dn9GwIpNr7vO/kQtcCsY0
         s7jBAElPBao8A==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v16 bpf-next 18/20] libbpf: Add SEC name for xdp_mb programs
Date:   Fri, 15 Oct 2021 15:08:55 +0200
Message-Id: <682d2fdae2f89e540377dfccee502b1e9dc2f0c4.1634301224.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1634301224.git.lorenzo@kernel.org>
References: <cover.1634301224.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce support SEC("xdp_mb") as a short cut for loading
the program with type BPF_PROG_TYPE_XDP that fully supports
XDP multi-buffer.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 tools/lib/bpf/libbpf.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index ae0889bebe32..d5ae2716d08b 100644
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
@@ -6171,6 +6173,9 @@ static int libbpf_preload_prog(struct bpf_program *prog,
 	if (def & SEC_SLEEPABLE)
 		attr->prog_flags |= BPF_F_SLEEPABLE;
 
+	if (prog->type == BPF_PROG_TYPE_XDP && (def & SEC_XDP_MB))
+		attr->prog_flags |= BPF_F_XDP_MB;
+
 	if ((prog->type == BPF_PROG_TYPE_TRACING ||
 	     prog->type == BPF_PROG_TYPE_LSM ||
 	     prog->type == BPF_PROG_TYPE_EXT) && !prog->attach_btf_id) {
@@ -8094,6 +8099,7 @@ static const struct bpf_sec_def section_defs[] = {
 	SEC_DEF("xdp_devmap/",		XDP, BPF_XDP_DEVMAP, SEC_ATTACHABLE),
 	SEC_DEF("xdp_cpumap/",		XDP, BPF_XDP_CPUMAP, SEC_ATTACHABLE),
 	SEC_DEF("xdp",			XDP, BPF_XDP, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX),
+	SEC_DEF("xdp_mb/",		XDP, BPF_XDP, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX | SEC_XDP_MB),
 	SEC_DEF("perf_event",		PERF_EVENT, 0, SEC_NONE | SEC_SLOPPY_PFX),
 	SEC_DEF("lwt_in",		LWT_IN, 0, SEC_NONE | SEC_SLOPPY_PFX),
 	SEC_DEF("lwt_out",		LWT_OUT, 0, SEC_NONE | SEC_SLOPPY_PFX),
-- 
2.31.1

