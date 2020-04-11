Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 614C81A5B5B
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgDKXEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:04:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727077AbgDKXET (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:04:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A40720708;
        Sat, 11 Apr 2020 23:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646259;
        bh=CUt+1MvioeiDPiQK9Zh7ckRIYPWV0LcGrYNTJZ3Hvws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q2NECbj4tTI4vcmoam3QW1DFC6VDMLI2uTLopGtXGvjU3cQlQDgF0QZGyHhhH7jmf
         74PDB1OpqX97LfhEOlrcra4fG3Bb9kHQALB2qhlXaxiP4x0pKFe7pJZyAwMRs8Duzf
         FK7HV4aBHq74ZQAxtXPenghJpwoKI/jL+yEPMomw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 025/149] libbpf: Ignore incompatible types with matching name during CO-RE relocation
Date:   Sat, 11 Apr 2020 19:01:42 -0400
Message-Id: <20200411230347.22371-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit d121e1d34b72c4975ff0340901d926c0aaf98174 ]

When finding target type candidates, ignore forward declarations, functions,
and other named types of incompatible kind. Not doing this can cause false
errors.  See [0] for one such case (due to struct pt_regs forward
declaration).

  [0] https://github.com/iovisor/bcc/pull/2806#issuecomment-598543645

Fixes: ddc7c3042614 ("libbpf: implement BPF CO-RE offset relocation algorithm")
Reported-by: Wenbo Zhang <ethercflow@gmail.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/20200313172336.1879637-3-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 7469c7dcc15e7..80ab0acc9dcdd 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3868,6 +3868,10 @@ static struct ids_vec *bpf_core_find_cands(const struct btf *local_btf,
 		if (str_is_empty(targ_name))
 			continue;
 
+		t = skip_mods_and_typedefs(targ_btf, i, NULL);
+		if (!btf_is_composite(t) && !btf_is_array(t))
+			continue;
+
 		targ_essent_len = bpf_core_essential_name_len(targ_name);
 		if (targ_essent_len != local_essent_len)
 			continue;
-- 
2.20.1

