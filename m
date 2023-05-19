Return-Path: <netdev+bounces-4030-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CB2F70A2C7
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 00:27:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CC511C211B5
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 22:27:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D3EA1800C;
	Fri, 19 May 2023 22:27:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2677318000
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 22:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46EB8C433D2;
	Fri, 19 May 2023 22:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684535237;
	bh=3++Hz/H0Ny8iNnJK/HwTOxVy8iKIyU2vlNFkX6To6V8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pMNQ+KnSqIGNuGe3uYk1BjH4DhXTj3M0pEM6ts97Oe75qGoI4/bM7UJ81xFdYa01/
	 28QeawEBbtM6Ou0uajuvn0QxJuWgODz3qt/84ZM5TDU5ZMAmrMzNW//56/tPSHI5yR
	 DEgaNOKopY4SR0Zf/rw+81uy8zk+qRItdlE/WesPVVbQRc2OAYOJIqlBsAqNQPMEPo
	 WC2oIi13vw709nUDVb48rqMMBjWwfojI1SgsVv3Xg0ManDOdMtIinOCKdXeHoYuiS9
	 1ifR2XvFgM3XuVICy2X5RVtCXDlD21fS50Q5udLIhvdsGkyLDtEWTYInCEx3MTkyos
	 YntJnPPLrqioA==
Date: Fri, 19 May 2023 15:27:15 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Min-Hua Chen <minhuadotchen@gmail.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>, Alexandre Torgue
 <alexandre.torgue@foss.st.com>, Jose Abreu <joabreu@synopsys.com>, "David
 S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: stmmac: compare p->des0 and p->des1 with __le32
 type values
Message-ID: <20230519152715.7d1c3a49@kernel.org>
In-Reply-To: <20230519115030.74493-1-minhuadotchen@gmail.com>
References: <20230519115030.74493-1-minhuadotchen@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 19 May 2023 19:50:28 +0800 Min-Hua Chen wrote:
> -		if ((p->des0 == 0xffffffff) && (p->des1 == 0xffffffff))
> +		if (p->des0 == cpu_to_le32(0xffffffff) &&
> +		    p->des1 == cpu_to_le32(0xffffffff))

Can you try to fix the sparse tool instead? I believe it already
ignores such errors for the constant of 0, maybe it can be taught 
to ignore all "isomorphic" values?

By "isomorphic" I mean that 0xffffffff == cpu_to_le32(0xffffffff)
so there's no point complaining.
-- 
pw-bot: reject

