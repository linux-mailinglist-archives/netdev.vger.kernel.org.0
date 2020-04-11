Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 851BE1A58D0
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729397AbgDKXKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:10:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728435AbgDKXKD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:10:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0D05217D8;
        Sat, 11 Apr 2020 23:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646603;
        bh=SgzdHlPA0YNVJ4tnWzeOsi3XQodzjcdy9mwjJz+LEZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1rXGf1sMGHSo7VVu7rogBCpR3KSMPaeUbCRqFwcYPvWYQRjgvzw7ZqPZd5CwMrORK
         J26/z6g0s2gV5ezPfVl1FebLh2vEicNor01+l3JBIx9zNgt7cjFV3Zt7MmxBrUIfiR
         GA9I96Nmq8O5G//iNLtbX0TuZkKY+tt+Zxfo+Z2Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 016/108] libbpf: Ignore incompatible types with matching name during CO-RE relocation
Date:   Sat, 11 Apr 2020 19:08:11 -0400
Message-Id: <20200411230943.24951-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230943.24951-1-sashal@kernel.org>
References: <20200411230943.24951-1-sashal@kernel.org>
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
index b6403712c2f4c..5f3a8b3a54ad7 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2534,6 +2534,10 @@ static struct ids_vec *bpf_core_find_cands(const struct btf *local_btf,
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

