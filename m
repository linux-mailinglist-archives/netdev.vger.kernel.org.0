Return-Path: <netdev+bounces-12035-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB22D735BF7
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 18:13:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C6C691C20B29
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 16:13:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D27613AD7;
	Mon, 19 Jun 2023 16:12:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EAEF12B72;
	Mon, 19 Jun 2023 16:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC27CC433C0;
	Mon, 19 Jun 2023 16:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687191178;
	bh=/H6FT3FrmV0NJ8VWtFxL0MtU2bSU6n73mHMPI4XRQBE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AMT5ndmgubCl23aIo/nslz/83VJoyve6t1E7pDI6/gvbGLCGEeffTuifbdDruLHnw
	 /ZavuMYavxaQvsrl4Z7lJ3hIVyzoV/Yija9MfeosJqe2JJb5Fpk7jUW+jheAw193/f
	 a+zX4Q8als5VJohEMnSGRu96dNhsX47Ow+96ej/XH6EAgw/Jom+Wnhf4j6e3eDHh43
	 kyomnYLtcLz4LCgssPyWNZe0DELwCVJ6iKrbUTGu7BD4hCybUfag8OcQSWN50eczp7
	 qq7lFI+Absa8n68blhi7JegCSxKbT9bBkVMdXbTvXqtH/zp7BtzAMlojViKcSVYZz0
	 9vD/P0wNcndWw==
Message-ID: <f9a85fcc-33e3-b47b-9c32-1d680edadcf8@kernel.org>
Date: Mon, 19 Jun 2023 09:12:55 -0700
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
To: Breno Leitao <leitao@debian.org>, axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com,
 Matthieu Baerts <matthieu.baerts@tessares.net>,
 Mat Martineau <martineau@kernel.org>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Xin Long <lucien.xin@gmail.com>, leit@fb.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, dccp@vger.kernel.org, mptcp@lists.linux.dev,
 linux-sctp@vger.kernel.org, ast@kernel.org, kuniyu@amazon.com,
 martin.lau@kernel.org, Jason Xing <kernelxing@tencent.com>,
 Joanne Koong <joannelkoong@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Jason A. Donenfeld" <Jason@zx2c4.com>, Willem de Bruijn
 <willemb@google.com>, Guillaume Nault <gnault@redhat.com>,
 Andrea Righi <andrea.righi@canonical.com>
References: <20230614110757.3689731-1-leitao@debian.org>
 <20230614110757.3689731-2-leitao@debian.org>
 <6b5e5988-3dc7-f5d6-e447-397696c0d533@kernel.org>
 <ZJA6AwbRWtSiJ5pL@gmail.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <ZJA6AwbRWtSiJ5pL@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/19/23 4:20 AM, Breno Leitao wrote:
> On Wed, Jun 14, 2023 at 08:15:10AM -0700, David Ahern wrote:
>> On 6/14/23 5:07 AM, Breno Leitao wrote:
>> io_uring is just another in-kernel user of sockets. There is no reason
>> for io_uring references to be in core net code. It should be using
>> exposed in-kernel APIs and doing any translation of its op codes in
>> io_uring/  code.
> Thanks for the feedback. If we want to keep the network subsystem
> untouched, then I we can do it using an approach similar to the
> following. Is this a better approach moving forward?

yes. It keeps the translation from io_uring commands to networking APIs
in one place and does not need to propagate that translation through the
networking code.

