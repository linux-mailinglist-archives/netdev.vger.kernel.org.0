Return-Path: <netdev+bounces-423-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D8CA6F769F
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 22:11:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58A262811F6
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 20:10:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2862517ADC;
	Thu,  4 May 2023 19:49:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B749C101CF
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:49:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8AB5C433EF;
	Thu,  4 May 2023 19:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683229771;
	bh=0vnWX0MVgGb7iZDFbJNjeohEnUpVDAWB+6di4E0lEvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ur/8H1nzsWMd18UFJSis2LzxRxMT0etGQY1EU7tUxDgM429eBXfOEl20eRm0+AwOG
	 rOlwDzpJPJSatY0y8PG3jpjwrKdKSL35Dhr99Pv/HdYIOEVGQkOFDI8j3MR5Y3MQZS
	 XiZVfsJMgZ6SbILiTAzPAYeGgNfdtIgAx+HcIXw28YmlsoUi0FvCCM4Rh4G0o+AssT
	 SH+kcAfYo764Pz4HWUPREOvWlHdcLy5xJexKqHEdvBOva0JdNGT/4JjdjRYKixqhYi
	 MJFCVMLaeWaCCnYlgHzEMoCXjH1t32ewMtksK2Qh/IUaRtCAbgf4lk6hW/nMiICdqO
	 yjhGXAzoVKZDw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Simon Horman <horms@kernel.org>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	dsahern@kernel.org,
	horms@verge.net.au,
	ja@ssi.bg,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	kadlec@netfilter.org,
	fw@strlen.de,
	netdev@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: [PATCH AUTOSEL 5.15 27/30] ipvs: Update width of source for ip_vs_sync_conn_options
Date: Thu,  4 May 2023 15:48:20 -0400
Message-Id: <20230504194824.3808028-27-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230504194824.3808028-1-sashal@kernel.org>
References: <20230504194824.3808028-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Simon Horman <horms@kernel.org>

[ Upstream commit e3478c68f6704638d08f437cbc552ca5970c151a ]

In ip_vs_sync_conn_v0() copy is made to struct ip_vs_sync_conn_options.
That structure looks like this:

struct ip_vs_sync_conn_options {
        struct ip_vs_seq        in_seq;
        struct ip_vs_seq        out_seq;
};

The source of the copy is the in_seq field of struct ip_vs_conn.  Whose
type is struct ip_vs_seq. Thus we can see that the source - is not as
wide as the amount of data copied, which is the width of struct
ip_vs_sync_conn_option.

The copy is safe because the next field in is another struct ip_vs_seq.
Make use of struct_group() to annotate this.

Flagged by gcc-13 as:

 In file included from ./include/linux/string.h:254,
                  from ./include/linux/bitmap.h:11,
                  from ./include/linux/cpumask.h:12,
                  from ./arch/x86/include/asm/paravirt.h:17,
                  from ./arch/x86/include/asm/cpuid.h:62,
                  from ./arch/x86/include/asm/processor.h:19,
                  from ./arch/x86/include/asm/timex.h:5,
                  from ./include/linux/timex.h:67,
                  from ./include/linux/time32.h:13,
                  from ./include/linux/time.h:60,
                  from ./include/linux/stat.h:19,
                  from ./include/linux/module.h:13,
                  from net/netfilter/ipvs/ip_vs_sync.c:38:
 In function 'fortify_memcpy_chk',
     inlined from 'ip_vs_sync_conn_v0' at net/netfilter/ipvs/ip_vs_sync.c:606:3:
 ./include/linux/fortify-string.h:529:25: error: call to '__read_overflow2_field' declared with attribute warning: detected read beyond size of field (2nd parameter); maybe use struct_group()? [-Werror=attribute-warning]
   529 |                         __read_overflow2_field(q_size_field, size);
       |

Compile tested only.

Signed-off-by: Simon Horman <horms@kernel.org>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip_vs.h             | 6 ++++--
 net/netfilter/ipvs/ip_vs_sync.c | 2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 7cb5a1aace40d..59f8412de45ac 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -549,8 +549,10 @@ struct ip_vs_conn {
 	 */
 	struct ip_vs_app        *app;           /* bound ip_vs_app object */
 	void                    *app_data;      /* Application private data */
-	struct ip_vs_seq        in_seq;         /* incoming seq. struct */
-	struct ip_vs_seq        out_seq;        /* outgoing seq. struct */
+	struct_group(sync_conn_opt,
+		struct ip_vs_seq  in_seq;       /* incoming seq. struct */
+		struct ip_vs_seq  out_seq;      /* outgoing seq. struct */
+	);
 
 	const struct ip_vs_pe	*pe;
 	char			*pe_data;
diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index a56fd0b5a430a..0d89e68dc9d18 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -603,7 +603,7 @@ static void ip_vs_sync_conn_v0(struct netns_ipvs *ipvs, struct ip_vs_conn *cp,
 	if (cp->flags & IP_VS_CONN_F_SEQ_MASK) {
 		struct ip_vs_sync_conn_options *opt =
 			(struct ip_vs_sync_conn_options *)&s[1];
-		memcpy(opt, &cp->in_seq, sizeof(*opt));
+		memcpy(opt, &cp->sync_conn_opt, sizeof(*opt));
 	}
 
 	m->nr_conns++;
-- 
2.39.2


