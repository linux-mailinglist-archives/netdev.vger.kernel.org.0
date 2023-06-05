Return-Path: <netdev+bounces-8138-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 54B1F722E52
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 20:06:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 61B581C20C80
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 18:06:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39BA12260F;
	Mon,  5 Jun 2023 18:06:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89DBAD2E
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 18:06:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17CAC433D2;
	Mon,  5 Jun 2023 18:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685988393;
	bh=140neydbH4NqzueFi/85G/gtjGnfr6/Oyl6MerHqEJU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Ho2ugw8Dg07or4Fp1vy7jflDC1s+g84MnwRmDDKuGLEQbpTxvhPn5lsrmZTyKsD18
	 nqzwogkfebsMUdpKDyJ/jGyyfnpLb8j9OyJKBHGy28xtpT7a59QohfImK07jz9nPC1
	 AuBjAV1HON8TDCSyGs1qY7jNAFkihFTaZc8quFVfvjg7Ttd1oNBBVXlBQ1vZCO4Cox
	 H5maUUFbo7YwAgZmMBHQ6mvbO6bTXu4ItY2cqKsWrVQTbzEAZlYXeTWulQ7WUHbPei
	 rMvaDg2QC0FTXcFdwcb23Ahc6dX1fQ1crzYhS4d9pTsO5t7hefF9Z42N/DAYRgbSGG
	 nClEkX1QwEvRA==
Date: Mon, 5 Jun 2023 11:06:31 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 chuck.lever@oracle.com
Subject: Re: [PATCH 66/69] ynl: fix nested policy attribute type
Message-ID: <20230605110631.5a7d8074@kernel.org>
In-Reply-To: <20230605094617.3564079-1-arkadiusz.kubalewski@intel.com>
References: <20230605094617.3564079-1-arkadiusz.kubalewski@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon,  5 Jun 2023 11:46:17 +0200 Arkadiusz Kubalewski wrote:
> When nested attribute is used, generated type in the netlink policy
> is NLA_NEST, which is wrong as there is no such type. Fix be adding
> `ed` sufix for policy generated for 'nest' type attribute.
> 
> Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
> ---
>  tools/net/ynl/ynl-gen-c.py | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
> index 28afb0846143..89603866d4a0 100755
> --- a/tools/net/ynl/ynl-gen-c.py
> +++ b/tools/net/ynl/ynl-gen-c.py
> @@ -113,7 +113,10 @@ class Type(SpecAttr):
>          return '{ .type = ' + policy + ', }'
>  
>      def attr_policy(self, cw):
> -        policy = c_upper('nla-' + self.attr['type'])
> +        if (self.attr['type'] == 'nest'):
> +            policy = c_upper('nla-' + self.attr['type'] + 'ed')
> +        else:
> +            policy = c_upper('nla-' + self.attr['type'])
>  
>          spec = self._attr_policy(policy)
>          cw.p(f"\t[{self.enum_name}] = {spec},")

For nests the policy should come from

  class TypeNest -> def _attr_policy()

why do we need to tweak the default implementation in the parent class?
-- 
pw-bot: cr

