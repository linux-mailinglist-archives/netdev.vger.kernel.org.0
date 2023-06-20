Return-Path: <netdev+bounces-12098-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07810736163
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 04:09:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E46B31C20A57
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 02:09:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1F631119;
	Tue, 20 Jun 2023 02:09:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372511360;
	Tue, 20 Jun 2023 02:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 910E7C433C8;
	Tue, 20 Jun 2023 02:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687226968;
	bh=TBAuPDZ4ZIJJqnKHAAtmN9rFin/Sn5+rIr+zk1Fviiw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VhAGSw+8AxIJS0XH/VyoJz0CgNamR62jHZV6R4jjyHJyClJtOi+P4yF+QgKT4x6ql
	 kQSHnfpqYY7mz/meatf5sNYRl9JWyf3A4O86rHtssihIwi/Xdg5ZIT8B2JxrjH1FeJ
	 YPrkB6q2NFjt0ZNTfEY86/X6CBLDgQ2V/12YNyY6FkWCzuLA3wZmUqMeU0ZIezvLXH
	 we75IHXE78D5FHaZyBBwWxwf8dcmdg1qXOdNr7yzdWYKtVcBvWY2yPnLNWexoDQvZs
	 82+yLU6Pm7s4XD10AZCFdStwWu2lMwwtrMktRwYCPwAxSKkOGAk7+I3CpWi+NAzv1J
	 ZEcdY7ufoVlTA==
Message-ID: <d289ab2c-dd5a-fd35-2a2a-7ccdfb947873@kernel.org>
Date: Mon, 19 Jun 2023 19:09:27 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [RFC PATCH v2 1/4] net: wire up support for
 file_operations->uring_cmd()
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, Breno Leitao
 <leitao@debian.org>, io-uring@vger.kernel.org, axboe@kernel.dk,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, Matthieu Baerts <matthieu.baerts@tessares.net>,
 Mat Martineau <martineau@kernel.org>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Xin Long <lucien.xin@gmail.com>
Cc: leit@fb.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 dccp@vger.kernel.org, mptcp@lists.linux.dev, linux-sctp@vger.kernel.org,
 ast@kernel.org, kuniyu@amazon.com, martin.lau@kernel.org,
 Jason Xing <kernelxing@tencent.com>, Joanne Koong <joannelkoong@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Jason A. Donenfeld" <Jason@zx2c4.com>, Willem de Bruijn
 <willemb@google.com>, Guillaume Nault <gnault@redhat.com>,
 Andrea Righi <andrea.righi@canonical.com>
References: <20230614110757.3689731-1-leitao@debian.org>
 <20230614110757.3689731-2-leitao@debian.org>
 <6b5e5988-3dc7-f5d6-e447-397696c0d533@kernel.org>
 <d9c9bd5f-b17e-fbd8-5646-4f51b927cc6b@gmail.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <d9c9bd5f-b17e-fbd8-5646-4f51b927cc6b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/19/23 2:28 AM, Pavel Begunkov wrote:
> That callback is all about file dependent operations, just like ioctl.
> And as the patch in question is doing socket specific stuff, I think
> architecturally it fits well. I also believe Breno wants to extend it
> later to support more operations.
> 
> Sockets are a large chunk of use cases, it can be implemented as a
> separate io_uring request type if nothing else works, but in general
> that might not be as scalable.

The io_uring commands are wrappers to existing networking APIs - doing
via io_uring what userspace apps can do via system calls. As such, the
translations should be done in io_uring code and then invoking in-kernel
APIs.

Same comment applies to sockopts when those come around and any other
future extensions.

