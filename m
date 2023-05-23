Return-Path: <netdev+bounces-4800-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D756B70E672
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 22:29:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D688281325
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 20:29:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E604B22606;
	Tue, 23 May 2023 20:29:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397C41F957
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 20:29:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DBFAC433EF;
	Tue, 23 May 2023 20:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684873793;
	bh=IHjbqY3L6Kyfcn6EpLoF0/oL2Mhj/pa0C03BNaUDdRA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=f927S0xcFxI0gxvFiUOfBlRQurEehM21aLB0J2XqXylNcF4K2tWGunR3CsmaKWnKZ
	 HsjK0JEWYUUCJx3qGRXgBdfxOa9p6j3+3UnOCp3uQxeIeGslL8zGOkV7yGLECXoFCU
	 EnEtYG0tkE/5yel26sT1dLtezMniy+BGxpSScMU1FZwSvVcrpSTnVG5R18UOqDcElG
	 LOKrPwldMCMb/QONgY2/JqVXJCFCh8M8SuVOqpj2ZH0tCXfxg8aLLLucnfckhxROH9
	 bUj+nt1hvd0nkxWTeLOJjrELsoyUU9WggNpwGHAlXgyRCM22bU7CyMcCrmfGtsJNZi
	 OROB0fJRGbHYQ==
Date: Tue, 23 May 2023 13:29:51 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Ido Schimmel <idosch@nvidia.com>
Cc: razor@blackwall.org, netdev@vger.kernel.org,
 bridge@lists.linux-foundation.org, davem@davemloft.net, pabeni@redhat.com,
 edumazet@google.com, roopa@nvidia.com, taras.chornyi@plvision.eu,
 saeedm@nvidia.com, leon@kernel.org, petrm@nvidia.com,
 vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
 alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
 jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
 taspelund@nvidia.com
Subject: Re: [PATCH net-next 1/5] skbuff: bridge: Add layer 2 miss
 indication
Message-ID: <20230523132951.623288cb@kernel.org>
In-Reply-To: <ZGx0/hwPmFFN2ivS@shredder>
References: <20230518113328.1952135-1-idosch@nvidia.com>
	<20230518113328.1952135-2-idosch@nvidia.com>
	<1ed139d5-6cb9-90c7-323c-22cf916e96a0@blackwall.org>
	<ZGd+9CUBM+eWG5FR@shredder>
	<20230519145218.659b0104@kernel.org>
	<ZGx0/hwPmFFN2ivS@shredder>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 23 May 2023 11:10:38 +0300 Ido Schimmel wrote:
> > Can we possibly put the new field at the end of the CB and then have TC
> > look at it in the CB? We already do a bit of such CB juggling in strp
> > (first member of struct sk_skb_cb).  
> 
> Using the CB between different layers is very fragile and I would like
> to avoid it. Note that the skb can pass various layers until hitting the
> classifier, each of which can decide to memset() the CB.
> 
> Anyway, I think I have a better alternative. I added the 'l2_miss' bit
> to the tc skb extension and adjusted the bridge to mark packets via this
> extension. The entire thing is protected by the existing 'tc_skb_ext_tc'
> static key, so overhead is kept to a minimum when feature is disabled.
> Extended flower to enable / disable this key when filters that match on
> 'l2_miss' are added / removed.
> 
> bridge change to mark the packet:
> https://github.com/idosch/linux/commit/3fab206492fcad9177f2340680f02ced1b9a0dec.patch
> 
> flow_dissector change to dissect the info from the extension:
> https://github.com/idosch/linux/commit/1533c078b02586547817a4e63989a0db62aa5315.patch
> 
> flower change to enable / disable the key:
> https://github.com/idosch/linux/commit/cf84b277511ec80fe565c41271abc6b2e2f629af.patch
> 
> Advantages compared to the previous approach are that we do not need a
> new bit in the skb and that overhead is kept to a minimum when feature
> is disabled. Disadvantage is that overhead is higher when feature is
> enabled.
> 
> WDYT?

Sounds good, yup. Thanks!

