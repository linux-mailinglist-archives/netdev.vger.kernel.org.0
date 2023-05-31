Return-Path: <netdev+bounces-6890-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B659571892E
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 20:16:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4FF7A1C20F12
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 18:16:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B22E819BB9;
	Wed, 31 May 2023 18:16:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831B7171BB
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 18:16:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31C8C433D2;
	Wed, 31 May 2023 18:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685556964;
	bh=0iS4QEZtR9R14+8r9lidPyx64MxNgwHzBGnd4gRrIV8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Vs8CeFQRe9fRbvMmR0S/zocnCs7QJhJ7gyu+urrAAFLV3XXO9la5SApk3p7INC+5e
	 ZjDbjo7nu3ytwZc0o6BUyCmNN9L9kpK5x3RlR8af5fZC5PcJ1S/QQ/PzZHcZuYaga6
	 rLeN27HZDXmD5PwG5XhLy4cJkqZRXQ64/5CO0mmWOFe0ZzJg+qPKzrDHZz9TJ4mN9y
	 85qUD9KFKyDcWp0H5Ebthgt1H0nqbYlG3JonroemeI6mePWXtBeyzZyd13G3w8GQh/
	 EGTrn+8gGsLnWmnmHzA2IoT47IwTqUbkWweY2dPh1w6ynNiaxW1K58VByuzCKtu0Cz
	 2mTGTq806G1tw==
Date: Wed, 31 May 2023 11:16:02 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Qingfang DENG <dqfext@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, YOSHIFUJI Hideaki
 <yoshfuji@linux-ipv6.org>, Ville Nuorvala <vnuorval@tcs.hut.fi>, Masahide
 NAKAMURA <nakam@linux-ipv6.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, Qingfang DENG <qingfang.deng@siflower.com.cn>
Subject: Re: [PATCH net] neighbour: fix unaligned access to pneigh_entry
Message-ID: <20230531111602.7ecf401b@kernel.org>
In-Reply-To: <20230531104233.50645-1-dqfext@gmail.com>
References: <20230531104233.50645-1-dqfext@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 31 May 2023 18:42:33 +0800 Qingfang DENG wrote:
> +#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>  	u8			key[];
> +#else
> +	u8			key[] __aligned(4);
> +#endif

I'd appreciate a second opinion, but to me it's very unlikely we'd save
any memory even with efficient aligned access here. No reasonably key
will fit into 3 bytes, right? So we can as well avoid the ifdef and
make the key[] always aligned. Or preferably, if it doesn't cause
compilation issues, make the type of the key u32?

