Return-Path: <netdev+bounces-11532-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD0377337EC
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:11:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9139F281824
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 18:11:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7E4E1DCAC;
	Fri, 16 Jun 2023 18:11:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D765719E69
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 18:11:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372A9C433C8;
	Fri, 16 Jun 2023 18:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686939090;
	bh=DcqdUc9Yd6KPGIAGEJUqqcblFBRa/0z0FweAoSQyQdc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WWFz7oa/mGnmm35ecO5TOQcYHW0o7wj9R5zmh5HYuQNw+gLwkwo9rSM83S/QQqAv9
	 5YD0YoRw0cZzJePtDdB6ap+F8kBr1nzHMfjl6vvHAjBpG0vHhqRIkKJSKju4He0X2N
	 3KrY6uPfcGBBEzdlyhGNQQ976am2quvrP42V4tldNlYx3JwA4d3GmfGTutnSsESDEj
	 ojjkKooRj0XDekedFly8MGqWAc2/3Ol2rqK/WH4RfB8kVJQOW0ckxdRs8zddpNCZvx
	 +H9u2tMUtTwSmXwE2rr/oYvu25tlCzIE8zAO2b8ppml4mSYm/EZgrnHK68UIlQXF+e
	 6dQg0Qkjl35ug==
Date: Fri, 16 Jun 2023 11:11:29 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Donald Hunter <donald.hunter@gmail.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 donald.hunter@redhat.com
Subject: Re: [RFC net-next v1] tools: ynl: Add an strace rendering mode to
 ynl-gen
Message-ID: <20230616111129.311dfd2d@kernel.org>
In-Reply-To: <m2o7lfhft6.fsf@gmail.com>
References: <20230615151336.77589-1-donald.hunter@gmail.com>
	<20230615200036.393179ae@kernel.org>
	<m2o7lfhft6.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 16 Jun 2023 11:17:25 +0100 Donald Hunter wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> 
> > On Thu, 15 Jun 2023 16:13:36 +0100 Donald Hunter wrote:  
> >> Add --mode strace to ynl-gen-c.py to generate source files for strace
> >> that teach it to understand how to decode genetlink messages defined
> >> in the spec. I successfully used this to add openvswitch message
> >> decoding to strace as I described in:
> >> 
> >> https://donaldh.wtf/2023/06/teaching-strace-new-tricks/
> >> 
> >> It successfully generated ovs_datapath and ovs_vport but ovs_flow
> >> needed manual fixes to fix code ordering and forward declarations.
> >> 
> >> Limitations:
> >> 
> >> - Uses a crude mechanism to try and emit functions in the right order
> >>   which fails for ovs_flow  
> >
> > What's the dependency? I pushed some stuff recently to try to order
> > types more intelligently but for normal C netlink it still won't deal
> > with cycles :(  
> 
> For strace I need to emit attr decoder functions before referencing them
> in dispatch tables. The crude mechanism I used was to emit decoders for
> nested attributes first, which worked okay for e.g. ovs_vport. But
> ovs_flow has I think at least 1 cycle.
> 
> > Actually I think that you're using raw family info rather than the
> > codegen-focused structs, maybe that's why?  
> 
> Yes, that's a fair point. I'm just walking through the declared
> attribute-sets in the order defined in the schema. I can take a look at
> what the codegen-focused structs provide.
> 
> >> - Outputs all strace sources to stdout or a single file
> >> - Does not use the right semantic strace decoders for e.g. IP or MAC
> >>   addresses because there is no schema information to say what the
> >>   domain type is.  
> >
> > The interpretation depends on another attribute or we expose things 
> > as binary with no machine-readable indication if its IP addr or MAC etc?  
> 
> Yeah, it's the lack of machine-readable indication. I'd suggest adding
> something like 'format: ipv4-address' to the schema.

I'd prefer to avoid defining our own names, too much thinking :)
Two ideas which come to mind are to either add a struct reference
(struct in_addr, in this case) or use the printk formats
Documentation/core-api/printk-formats.rst (%pI4).

> >> This seems like a useful tool to have as part of the ynl suite since
> >> it lowers the cost of getting good strace support for new netlink
> >> families. But I realise that the generated format is dependent on an
> >> out of tree project. If there is interest in having this in-tree then
> >> I can clean it up and address some of the limitations before
> >> submission.  
> >
> > I think it's fine, we'll have to cross this bridge sooner or later.
> > I suspect we'll need to split ynl-gen-c once again (like the
> > tools/net/ynl/lib/nlspec.py, maybe we need another layer for code 
> > generators? nlcodegen or some such?) before we add codegen for more
> > languages. I'm not sure you actually need that yet, maybe the strace
> > generator needs just nlspec.py and it can be a separate script?  
> 
> The strace generator uses CodeWriter and makes partial use of the Type*
> classes as well. If we split those out of ynl-gen-c then it could be a
> separate script. A first step could be to move all but main() into a
> lib?

Hm, my instinct was the opposite, move as little as possible while
avoiding duplication. I was thinking about the split in context of
C++ and Rust, there's a lot of C intermixed with the code currently
in ynl-gen-c. But you need the C, AFAIU.

You shouldn't need all the print_ stuff, tho, do you? So we could split
more or less around where _C_KW is defined? Anything above it would be
shared among C codegens?

