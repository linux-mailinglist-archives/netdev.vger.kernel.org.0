Return-Path: <netdev+bounces-3721-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C7F117086BD
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 19:25:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83DFC2817EF
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 17:25:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A35CE271EE;
	Thu, 18 May 2023 17:25:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6088718C15;
	Thu, 18 May 2023 17:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB0CC433D2;
	Thu, 18 May 2023 17:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684430706;
	bh=1xXEc3Q960cFBOJsgYU1M/OH6jSEXjQSfflTdxhXDZA=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=hG1yEhY2MjQ8nGW7uNJwo2jReDLQmXM9P6n4qGRX/XhGMlh75vk9U5iV671U1JarL
	 FSTamFfSa3agJDtP9Gp31gfATJJpgDZgD6PR/SKOmwzgerS8M4HbO1QYq1JN3a2phj
	 FO+INUF9rGLs8NmyxwoPIXGjjgu1LoipOZS34Kp0ePV9JPRD0f+QOvNV1CU15iVgP0
	 ixL50LLLd+tcTf2/lQNt7hUkm14xDKEih4OX7CHlape1n6/PBanN3rOlxr39V2LzXx
	 kRkPQZauZgYqJVXvDsIljvWaLk/KfZPQH+xP5OdF+RXbdvXNDTxdELJFoGszHD4YsD
	 vLcKn+Htfmqfg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 9ED4ECE0CC3; Thu, 18 May 2023 10:25:05 -0700 (PDT)
Date: Thu, 18 May 2023 10:25:05 -0700
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
Subject: Re: [PATCH bpf] Use call_rcu_hurry() with synchronize_rcu_mult()
Message-ID: <2cc44c11-bcdc-4ae4-a42d-d6d46cf1da6e@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <358bde93-4933-4305-ac42-4d6f10c97c08@paulmck-laptop>
 <b18fdfc3-987d-9351-ca6c-5d4cb2d71af1@linux.dev>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b18fdfc3-987d-9351-ca6c-5d4cb2d71af1@linux.dev>

On Thu, May 18, 2023 at 09:51:39AM -0700, Martin KaFai Lau wrote:
> On 5/18/23 7:47 AM, Paul E. McKenney wrote:
> > The bpf_struct_ops_map_free() function must wait for both an RCU grace
> > period and an RCU Tasks grace period, and so it passes call_rcu() and
> > call_rcu_tasks() to synchronize_rcu_mult().  This works, but on ChromeOS
> > and Android platforms call_rcu() can have lazy semantics, resulting in
> > multi-second delays between call_rcu() invocation and invocation of the
> > corresponding callback.
> > 
> > Therefore, substitute call_rcu_hurry() for call_rcu().
> 
> My understanding on the net-effect is to free up the struct_ops resources faster.
> 
> I believe call_rcu() should be fine. struct_ops freeing should not happen
> very often. For example, when a bpf written tcp congestion control
> (struct_ops) is registered, it will stay in the kernel for a long time. A
> couple seconds delay in releasing the struct_ops should be acceptable.

Very good, and sorry for the noise!

							Thanx, Paul

