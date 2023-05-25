Return-Path: <netdev+bounces-5403-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA1C57111A6
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 19:07:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F44F281045
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 17:07:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51CFB1D2B8;
	Thu, 25 May 2023 17:07:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDE77E3
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 17:07:14 +0000 (UTC)
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB44135
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 10:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685034433; x=1716570433;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=beCNnZJObXzL2xfYsr0CfHXvir18ERwDCJTrcgHdgto=;
  b=TRTdW6tl1QwTdWlqR/BcOEZlr85spD5jjmQjER2Qyy72QtYNadOjH+Ir
   Ga6LJTVEn9u+OEfwuAcpIc2/NR3I/2NrO8WGnF4sX8l+v9pqKs4xK/3kz
   BpuUXI1FsJfbBbfXCBFh90/8IZDZGSoqfWqGO/StYAiULn4W0XhzNPti0
   k=;
X-IronPort-AV: E=Sophos;i="6.00,191,1681171200"; 
   d="scan'208";a="341479835"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-3e1fab07.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 17:07:07 +0000
Received: from EX19MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
	by email-inbound-relay-iad-1e-m6i4x-3e1fab07.us-east-1.amazon.com (Postfix) with ESMTPS id EDDB482FBF;
	Thu, 25 May 2023 17:07:04 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 25 May 2023 17:07:04 +0000
Received: from 88665a182662.ant.amazon.com (10.187.170.54) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.26;
 Thu, 25 May 2023 17:07:01 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <fw@strlen.de>
CC: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<kuni1840@gmail.com>, <kuniyu@amazon.com>, <netdev@vger.kernel.org>,
	<pabeni@redhat.com>, <syzbot+444ca0907e96f7c5e48b@syzkaller.appspotmail.com>
Subject: Re: [PATCH v1 net] udplite: Fix NULL pointer dereference in __sk_mem_raise_allocated().
Date: Thu, 25 May 2023 10:06:53 -0700
Message-ID: <20230525170653.99846-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230525163342.GB25057@breakpoint.cc>
References: <20230525163342.GB25057@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.170.54]
X-ClientProxiedBy: EX19D035UWB004.ant.amazon.com (10.13.138.104) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Florian Westphal <fw@strlen.de>
Date: Thu, 25 May 2023 18:33:42 +0200
> Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > I'd remove it in -next.  Same for DCCP.
> > 
> > Ok, I'll do for UDP Lite.
> 
> Thanks.
> 
> > +1 for DCCP, but we know there are real?
> > still experimenting? users ... ?
> 
> Yes, and they can continue to work on their out of tree fork
> and research projects, no problem.
> 
> I'd say next time some net/core change needs dccp changes,
> remove dccp first (or mark it as CONFIG_BROKEN) so it doesn't
> cause extra work.

FWIW, I was going to post such a patch that removes .twsk_unique
and .twsk_destructor handler in timewait_sock_ops, which is only
used by TCP but exists just because DCCP shares the struct.


> DCCP can be brought back when someone has interest to maintain it.
> 
> Looking at DCCP patches its either:
> 1. odd syzbot fixes
> 2. api changes in net that need folloup changes in dccp
> 3. automated transformations
> 
> There is no sign that anyone is maintaining this (or running it
> in a production environment...).

Exactly.  It's now kind of bleeding ground of CVE.

Actualy, we disable CONFIG_IP_DCCP for our latest distribution (AL2023)
for the reason, and RHEL 7.8+ also prevents the module from being loaded
by default.

If there's no objection, I can remove it after UDP Lite.

https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/7.8_release_notes/deprecated_functionality#automatic_loading_of_dccp_modules_through_socket_layer_is_now_disabled_by_default

