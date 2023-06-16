Return-Path: <netdev+bounces-11274-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DAFB7732586
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 05:00:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 145931C20F36
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 03:00:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 388E064D;
	Fri, 16 Jun 2023 03:00:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFBE648
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 03:00:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0281BC433C8;
	Fri, 16 Jun 2023 03:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686884437;
	bh=KtarcQcqPvVMaHA7NepiYQKPWgrCYgXN27YHR0qK70w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=u3wKYfmp31ylPDFl+J3yrv9m0ANNxQ6AcVP9aS9v0s48xuSqCWDjEkrU3GAHqG0Kh
	 P7dbQz2Vc834rXQg1bD1NkwdLRmn8K/igrFBXwkaJcdMuXWW7sOLLkbrP8jcqyekEU
	 CGpbJe2gtusNC6yXqBen0gjP+YjADUSe2Y8tvEBiAw6OFfowbz1h19AhDGs5UObsHs
	 gFV5YkR0tDfIMMDH/3kxe+KfPvkqMuZHcpRyOvKjJce7SGlkcbXQN0PTdvk8ydFa5f
	 0tugxdY/qpZmZO8EI6hkv7Pg1XD92qGuhCeB+Vffnpc5n0jkaADggwhilzKKMCv0bQ
	 GbrAlym2GZQhQ==
Date: Thu, 15 Jun 2023 20:00:36 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Donald Hunter <donald.hunter@gmail.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 donald.hunter@redhat.com
Subject: Re: [RFC net-next v1] tools: ynl: Add an strace rendering mode to
 ynl-gen
Message-ID: <20230615200036.393179ae@kernel.org>
In-Reply-To: <20230615151336.77589-1-donald.hunter@gmail.com>
References: <20230615151336.77589-1-donald.hunter@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 15 Jun 2023 16:13:36 +0100 Donald Hunter wrote:
> Add --mode strace to ynl-gen-c.py to generate source files for strace
> that teach it to understand how to decode genetlink messages defined
> in the spec. I successfully used this to add openvswitch message
> decoding to strace as I described in:
> 
> https://donaldh.wtf/2023/06/teaching-strace-new-tricks/
> 
> It successfully generated ovs_datapath and ovs_vport but ovs_flow
> needed manual fixes to fix code ordering and forward declarations.
> 
> Limitations:
> 
> - Uses a crude mechanism to try and emit functions in the right order
>   which fails for ovs_flow

What's the dependency? I pushed some stuff recently to try to order
types more intelligently but for normal C netlink it still won't deal
with cycles :(

Actually I think that you're using raw family info rather than the
codegen-focused structs, maybe that's why?

> - Outputs all strace sources to stdout or a single file
> - Does not use the right semantic strace decoders for e.g. IP or MAC
>   addresses because there is no schema information to say what the
>   domain type is.

The interpretation depends on another attribute or we expose things 
as binary with no machine-readable indication if its IP addr or MAC etc?

> This seems like a useful tool to have as part of the ynl suite since
> it lowers the cost of getting good strace support for new netlink
> families. But I realise that the generated format is dependent on an
> out of tree project. If there is interest in having this in-tree then
> I can clean it up and address some of the limitations before
> submission.

I think it's fine, we'll have to cross this bridge sooner or later.
I suspect we'll need to split ynl-gen-c once again (like the
tools/net/ynl/lib/nlspec.py, maybe we need another layer for code 
generators? nlcodegen or some such?) before we add codegen for more
languages. I'm not sure you actually need that yet, maybe the strace
generator needs just nlspec.py and it can be a separate script?

