Return-Path: <netdev+bounces-11790-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 555B9734761
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 19:50:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B65D1C20957
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 17:50:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C9AF6FC9;
	Sun, 18 Jun 2023 17:50:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5C41386
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 17:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5F9C433C0;
	Sun, 18 Jun 2023 17:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687110640;
	bh=bLzXVhy+xeEKfGXoMV41qKelHKb8eMbvoUzE4zOYJjc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lU0/Nnr5fMWEeIs6RsF8lhHQWpJV4b/CGrN5ZAiQQeVXnHYWyes798NUt+Amw8BHz
	 Wv/DWmw3sfwYsNE/hU+Smut3RXEf36m2m+d+9x5SFu5viohtOhnFHZtceeQc5D3eeH
	 LCcaQGBIaRoHzNxwsat4Pbz8OI0ZtOK/hDht2pRQ7kzi2BFnPzjVT7cFCQ7AUIg27B
	 FBHMgcPefrFrRzRdj0i/vRDOLigCOroqFQZLDk85kC8YZyosm2+ndM5FW14elYbwSo
	 J7zRN3sqVRyoUmUhtDzZtrUDbcAOSrIkqi/Lu2XPH49Fw/yjDaHe23suXK72cIzlHN
	 wUaZAFEAgzlJw==
Message-ID: <85077827-d11d-d3e6-0d23-9e60974cad0f@kernel.org>
Date: Sun, 18 Jun 2023 10:50:38 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [PATCH v7 04/22] net/tcp: Prevent TCP-MD5 with TCP-AO being set
To: Dmitry Safonov <dima@arista.com>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
 "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
 Ard Biesheuvel <ardb@kernel.org>, Bob Gilligan <gilligan@arista.com>,
 Dan Carpenter <error27@gmail.com>, David Laight <David.Laight@aculab.com>,
 Dmitry Safonov <0x7f454c46@gmail.com>, Donald Cassidy <dcassidy@redhat.com>,
 Eric Biggers <ebiggers@kernel.org>, "Eric W. Biederman"
 <ebiederm@xmission.com>, Francesco Ruggeri <fruggeri05@gmail.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
 Ivan Delalande <colona@arista.com>, Leonard Crestez <cdleonard@gmail.com>,
 Salam Noureddine <noureddine@arista.com>, netdev@vger.kernel.org
References: <20230614230947.3954084-1-dima@arista.com>
 <20230614230947.3954084-5-dima@arista.com>
Content-Language: en-US
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <20230614230947.3954084-5-dima@arista.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/14/23 4:09 PM, Dmitry Safonov wrote:
> Be as conservative as possible: if there is TCP-MD5 key for a given peer
> regardless of L3 interface - don't allow setting TCP-AO key for the same
> peer. According to RFC5925, TCP-AO is supposed to replace TCP-MD5 and
> there can't be any switch between both on any connected tuple.
> Later it can be relaxed, if there's a use, but in the beginning restrict
> any intersection.
> 
> Note: it's still should be possible to set both TCP-MD5 and TCP-AO keys
> on a listening socket for *different* peers.

Does the testsuite cover use of both MD5 and AO for a single listening
socket with different peers and then other tests covering attempts to
use both for a same peer?

