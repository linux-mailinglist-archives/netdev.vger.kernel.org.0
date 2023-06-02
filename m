Return-Path: <netdev+bounces-7462-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C2F72720660
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 17:38:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 084EB1C20B71
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 15:38:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0FA01B8EE;
	Fri,  2 Jun 2023 15:38:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D3A19BDD
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 15:38:18 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B1B10E0;
	Fri,  2 Jun 2023 08:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=4s8x5vVE/Cay1BwiwX0ciNJuUa4uFZj6eThK63GoGsM=; b=OBXdg6pT2cvgUDIqntv8wb8CKo
	POcPsQZvD0rAOTSsqppoQofHNt/77/9bKwEqHgqEBrRNsLJ9EifmOPsMe3j/cWNFtvgWB1YxbfPGu
	2TXUowdHNf2bTCia0mdlFbUlcmhkdCIt/aGXVXZy12WPsWEBSEyk072HRy9QS0n3Glsg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q56q7-00Egjo-TY; Fri, 02 Jun 2023 17:37:19 +0200
Date: Fri, 2 Jun 2023 17:37:19 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Ding Hui <dinghui@sangfor.com.cn>
Cc: Alexander H Duyck <alexander.duyck@gmail.com>, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	pengdonglin@sangfor.com.cn, huangcun@sangfor.com.cn
Subject: Re: [PATCH net-next] net: ethtool: Fix out-of-bounds copy to user
Message-ID: <6e28cea9-d615-449d-9c68-aa155efc8444@lunn.ch>
References: <20230601112839.13799-1-dinghui@sangfor.com.cn>
 <135a45b2c388fbaf9db4620cb01b95230709b9ac.camel@gmail.com>
 <eed0cbf7-ff12-057e-e133-0ddf5e98ef68@sangfor.com.cn>
 <6110cf9f-c10e-4b9b-934d-8d202b7f5794@lunn.ch>
 <f7e23fe6-4d30-ef1b-a431-3ef6ec6f77ba@sangfor.com.cn>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7e23fe6-4d30-ef1b-a431-3ef6ec6f77ba@sangfor.com.cn>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> > Also, RTNL should be held during the time both calls are made into the
> > driver. So nothing from userspace should be able to get in the middle
> > of these calls to change the number of queues.
> > 
> 
> The RTNL lock is already be held during every each ioctl in dev_ethtool().
> 
>     rtnl_lock();
>     rc = __dev_ethtool(net, ifr, useraddr, ethcmd, state);
>     rtnl_unlock();

Yes, exactly. So the kernel should be safe from buffer overruns.

Userspace will not get more than it asked for. It might get less, and
it could be different to the previous calls. But i'm not aware of
anything which says anything about the consistency between different
invocations of ethtool -S.

	Andrew

