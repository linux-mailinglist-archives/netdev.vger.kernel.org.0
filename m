Return-Path: <netdev+bounces-1062-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 13CE46FC0B4
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 09:48:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4030F1C20AD8
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 07:48:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3840D171C4;
	Tue,  9 May 2023 07:48:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324AC38C
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 07:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 524BBC433EF;
	Tue,  9 May 2023 07:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683618513;
	bh=kn7A1+T99E1FKZC0BJ22g760Ya5SfTmJ926W17rznv0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t4wANhp1DJPCqx6rCKJx3DEJgk46DbPQ7Ojp76+U9vtMjQfpU1tQk/kH/KgtssYsy
	 CI4rnYu8RM8R1YnxBHyqZM5izl2hnh4gS3ZObmfLLh0YAXsoUm2zRM/NWT6Qgk8bn1
	 yyqsn3DAdVxjjS4WgLwX4AIkhgD7RlJEQy3jIhPWPKwk23NpbyQHjLbNqJ+Do1DVLP
	 IZit9EAuXHfmQAdYnWD7f+FGdwOQSTwm707OtlyMIeYhER7FwJmpobK067NZjoow7x
	 ajsQP2nyvFChaV3fwBsXBOVsag/f4WBj2g+3tpy+HGQpE7nx4zYhleOJVu9heP3TpN
	 RUJK3mqFXzD5A==
Date: Tue, 9 May 2023 10:48:29 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: netdev@vger.kernel.org, patryk.sondej@gmail.com
Subject: Re: [PATCH net] inet_diag: fix inet_diag_msg_attrs_fill() for
 net_cls cgroup
Message-ID: <20230509074829.GC38143@unreal>
References: <20230508061749.GC6195@unreal>
 <20230508162126.39146-1-kuniyu@amazon.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508162126.39146-1-kuniyu@amazon.com>

On Mon, May 08, 2023 at 09:21:26AM -0700, Kuniyuki Iwashima wrote:
> From: Leon Romanovsky <leon@kernel.org>
> Date: Mon, 8 May 2023 09:17:49 +0300
> > On Mon, May 08, 2023 at 05:32:33AM +0200, Patryk Sondej wrote:
> > > This commit fixes inet_diag_msg_attrs_fill() function in the ipv4/inet_diag.c file.
> > > The problem was that the function was using CONFIG_SOCK_CGROUP_DATA to check for the net_cls cgroup.
> > > However, the net_cls cgroup is defined by CONFIG_CGROUP_NET_CLASSID instead.
> > > 
> > > Therefore, this commit updates the #ifdef statement to CONFIG_CGROUP_NET_CLASSID,
> > > and uses the sock_cgroup_classid() function to retrieve the classid from the socket cgroup.
> > > 
> > > This change ensures that the function correctly retrieves the classid for the net_cls cgroup
> > > and fixes any issues related to the use of the function in this context.
> > > 
> > 
> > Please add Fixes line here.
> > 
> > > Signed-off-by: Patryk Sondej <patryk.sondej@gmail.com>
> > > ---
> > >  net/ipv4/inet_diag.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
> > > index b812eb36f0e3..7017f88911a6 100644
> > > --- a/net/ipv4/inet_diag.c
> > > +++ b/net/ipv4/inet_diag.c
> > > @@ -157,7 +157,7 @@ int inet_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
> > >  	    ext & (1 << (INET_DIAG_TCLASS - 1))) {
> > >  		u32 classid = 0;
> > >  
> > > -#ifdef CONFIG_SOCK_CGROUP_DATA
> > > +#ifdef CONFIG_CGROUP_NET_CLASSID
> > 
> > This ifdef should be deleted as sock_cgroup_classid() already has right ifdef.
> 
> sock_cgroup_classid() is defined under #ifdef CONFIG_SOCK_CGROUP_DATA,

Not in my kernel tree, where do you see it?

https://elixir.bootlin.com/linux/v6.4-rc1/source/include/linux/cgroup-defs.h#L809
include/linux/cgroup-defs.h
  809 static inline u32 sock_cgroup_classid(const struct sock_cgroup_data *skcd)
  810 {
  811 #ifdef CONFIG_CGROUP_NET_CLASSID
  812         return READ_ONCE(skcd->classid);
  813 #else
  814         return 0;
  815 #endif
  816 }

Thanks

