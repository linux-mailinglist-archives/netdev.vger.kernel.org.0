Return-Path: <netdev+bounces-3670-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F11B708430
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 16:47:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFD9B2819B3
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 14:47:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3307209A8;
	Thu, 18 May 2023 14:47:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F053823C6A;
	Thu, 18 May 2023 14:47:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3DF9C433EF;
	Thu, 18 May 2023 14:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684421252;
	bh=2mUFWBMt3SD4OqfgogzFleN6wtv8trWDKDzk1pYkPak=;
	h=Date:From:To:Cc:Subject:Reply-To:From;
	b=HCQJxTzN/eSvJVCwvt/F5YsT6qfyI3NmxwySbe9d88XHUbxKMU22KGe3DlLesmj7n
	 E8MrTx2TCEaZstsq5Em3AsdE8ol9KqPMl2n1iP4me57b8UhSbNIMsH0jD04sPISGjs
	 O6mJrkVxBEs7i2hpRZyquofGHF82/k1Cr0Yb3+6iZEVXIPAeHkwQDKGAafST6Bx3OE
	 yiKaihsBSVn0XwY23PdSRc1iluWYM879rdOx0n/C0mT7eZprP1gwESpDlxh5b7M2Df
	 dvJ3dZTphkcTHzz6g+XLankCH9Pn+CdShAM4yzbyl5zW+TZ8nF28iqD3xwzwCNSiqg
	 WJ4GmfV/Mm/5w==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 4C04BCE0CC3; Thu, 18 May 2023 07:47:32 -0700 (PDT)
Date: Thu, 18 May 2023 07:47:32 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>, Song Liu <song@kernel.org>,
	Yonghong Song <yhs@fb.com>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>,
	Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
	bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf] Use call_rcu_hurry() with synchronize_rcu_mult()
Message-ID: <358bde93-4933-4305-ac42-4d6f10c97c08@paulmck-laptop>
Reply-To: paulmck@kernel.org
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The bpf_struct_ops_map_free() function must wait for both an RCU grace
period and an RCU Tasks grace period, and so it passes call_rcu() and
call_rcu_tasks() to synchronize_rcu_mult().  This works, but on ChromeOS
and Android platforms call_rcu() can have lazy semantics, resulting in
multi-second delays between call_rcu() invocation and invocation of the
corresponding callback.

Therefore, substitute call_rcu_hurry() for call_rcu().

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Yonghong Song <yhs@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Stanislav Fomichev <sdf@google.com>
Cc: Hao Luo <haoluo@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: <bpf@vger.kernel.org>
Cc: <netdev@vger.kernel.org>

diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index d3f0a4825fa6..bacffd6cae60 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -634,7 +634,7 @@ static void bpf_struct_ops_map_free(struct bpf_map *map)
 	 * in the tramopline image to finish before releasing
 	 * the trampoline image.
 	 */
-	synchronize_rcu_mult(call_rcu, call_rcu_tasks);
+	synchronize_rcu_mult(call_rcu_hurry, call_rcu_tasks);
 
 	__bpf_struct_ops_map_free(map);
 }

