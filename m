Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3798E599191
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 02:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239993AbiHSAHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 20:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234482AbiHSAHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 20:07:17 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D4EC7FBC;
        Thu, 18 Aug 2022 17:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660867637; x=1692403637;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SaRfa3u26PjTQ23fCghirKypq5/HaGgCZmKXwPI3ZTs=;
  b=U1vxZMT5A9XD3/jgm7SUwGJ14bsWZvRLQHGePIjYqWrkZz73D3r7tU0f
   dmlZmp4gDybaoSlihXkWcJKV8pFaoNmI5anl17Whz2E2tCydSst4Xjcig
   tvTDzPq+nxQxLFykrJei1fZHB/hTGdtX3q25RqZTItOmri/mcM0Z6UZ8m
   k=;
X-IronPort-AV: E=Sophos;i="5.93,247,1654560000"; 
   d="scan'208";a="250466127"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-8be8ed69.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 00:07:01 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-8be8ed69.us-east-1.amazon.com (Postfix) with ESMTPS id 79894C0AB4;
        Fri, 19 Aug 2022 00:06:59 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Fri, 19 Aug 2022 00:06:56 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.162.85) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Fri, 19 Aug 2022 00:06:54 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <alexei.starovoitov@gmail.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 bpf 1/4] bpf: Fix data-races around bpf_jit_enable.
Date:   Thu, 18 Aug 2022 17:06:45 -0700
Message-ID: <20220819000645.55413-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CAADnVQ+H2n5-Gwgq-OZu-WZKRsg=kq7FtOGXJu6YNHoCEBap6w@mail.gmail.com>
References: <CAADnVQ+H2n5-Gwgq-OZu-WZKRsg=kq7FtOGXJu6YNHoCEBap6w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.85]
X-ClientProxiedBy: EX13D30UWB001.ant.amazon.com (10.43.161.80) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 18 Aug 2022 15:49:46 -0700
> On Wed, Aug 17, 2022 at 9:24 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > A sysctl variable bpf_jit_enable is accessed concurrently, and there is
> > always a chance of data-race.  So, all readers and a writer need some
> > basic protection to avoid load/store-tearing.
> >
> > Fixes: 0a14842f5a3c ("net: filter: Just In Time compiler for x86-64")
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > ---
> >  arch/arm/net/bpf_jit_32.c        | 2 +-
> >  arch/arm64/net/bpf_jit_comp.c    | 2 +-
> >  arch/mips/net/bpf_jit_comp.c     | 2 +-
> >  arch/powerpc/net/bpf_jit_comp.c  | 5 +++--
> >  arch/riscv/net/bpf_jit_core.c    | 2 +-
> >  arch/s390/net/bpf_jit_comp.c     | 2 +-
> >  arch/sparc/net/bpf_jit_comp_32.c | 5 +++--
> >  arch/sparc/net/bpf_jit_comp_64.c | 5 +++--
> >  arch/x86/net/bpf_jit_comp.c      | 2 +-
> >  arch/x86/net/bpf_jit_comp32.c    | 2 +-
> >  include/linux/filter.h           | 2 +-
> >  net/core/sysctl_net_core.c       | 4 ++--
> >  12 files changed, 19 insertions(+), 16 deletions(-)
> >
> > diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
> > index 6a1c9fca5260..4b6b62a6fdd4 100644
> > --- a/arch/arm/net/bpf_jit_32.c
> > +++ b/arch/arm/net/bpf_jit_32.c
> > @@ -1999,7 +1999,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
> >         }
> >         flush_icache_range((u32)header, (u32)(ctx.target + ctx.idx));
> >
> > -       if (bpf_jit_enable > 1)
> > +       if (READ_ONCE(bpf_jit_enable) > 1)
> 
> Nack.
> Even if the compiler decides to use single byte loads for some
> odd reason there is no issue here.

I see, and same for 2nd/3rd patches, right?

Then how about this part?
It's not data-race nor problematic in practice, but should the value be
consistent in the same function?
The 2nd/3rd patches also have this kind of part.

---8<---
diff --git a/arch/powerpc/net/bpf_jit_comp.c b/arch/powerpc/net/bpf_jit_comp.c
index 43e634126514..c71d1e94ee7e 100644
--- a/arch/powerpc/net/bpf_jit_comp.c
+++ b/arch/powerpc/net/bpf_jit_comp.c
@@ -122,6 +122,7 @@ bool bpf_jit_needs_zext(void)
 
 struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 {
+	int jit_enable = READ_ONCE(bpf_jit_enable);
 	u32 proglen;
 	u32 alloclen;
 	u8 *image = NULL;
@@ -263,13 +264,13 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 		}
 		bpf_jit_build_epilogue(code_base, &cgctx);
 
-		if (bpf_jit_enable > 1)
+		if (jit_enable > 1)
 			pr_info("Pass %d: shrink = %d, seen = 0x%x\n", pass,
 				proglen - (cgctx.idx * 4), cgctx.seen);
 	}
 
 skip_codegen_passes:
-	if (bpf_jit_enable > 1)
+	if (jit_enable > 1)
 		/*
 		 * Note that we output the base address of the code_base
 		 * rather than image, since opcodes are in code_base.
---8<---
