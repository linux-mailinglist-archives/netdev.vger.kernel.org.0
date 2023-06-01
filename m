Return-Path: <netdev+bounces-7108-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ABC5071A020
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:34:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 422992817BB
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 14:34:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B868BA2F;
	Thu,  1 Jun 2023 14:34:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C0F23D7;
	Thu,  1 Jun 2023 14:34:08 +0000 (UTC)
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30AA4132;
	Thu,  1 Jun 2023 07:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=MWJtZj0Bpj3Pq6TDmueRGH0j6tzTZD1Xncj+xQHm8EA=; b=hqEdim2p/+8tyODB2E8AnJkmTv
	FdsA862hCwoOSdmFuqEkBHRS1MLlAx2LyN0vY99TLusl588BHd/teL4BjqtW0fOtqfX/27iLK2VmN
	DQZydjWoD5isP5ar7TSfIVsmRMK9WfwKYKAPjUHBfcZXL/xegMm1B6viBayRU7S1Xv/CjEjRHuQU+
	iEFb6T2L8fVcvTc+aPAUa/AljAG8Sb95nu84mcawwp8J9e/k+MANR/4gvS3ZPwTu/OnF62fqubpv/
	OspnNmbvRnoMedZ2WCBhi3o+Bz6JAy9j7wU7zn+xQvdK0WYhY5nnJP7gbiiHDnwSbWXU2tF+HXBU6
	U1rntztQ==;
Received: from sslproxy06.your-server.de ([78.46.172.3])
	by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <daniel@iogearbox.net>)
	id 1q4jN8-000BGz-Qe; Thu, 01 Jun 2023 16:33:50 +0200
Received: from [85.1.206.226] (helo=linux.home)
	by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <daniel@iogearbox.net>)
	id 1q4jN8-0003wa-6b; Thu, 01 Jun 2023 16:33:50 +0200
Subject: Re: [PATCH net] bpf, sockmap: avoid potential NULL dereference in
 sk_psock_verdict_data_ready()
To: Eric Dumazet <edumazet@google.com>, "David S . Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrii Nakryiko <andrii@kernel.org>
Cc: netdev@vger.kernel.org, bpf@vger.kernel.org, eric.dumazet@gmail.com,
 syzbot <syzkaller@googlegroups.com>,
 John Fastabend <john.fastabend@gmail.com>,
 Jakub Sitnicki <jakub@cloudflare.com>
References: <20230530195149.68145-1-edumazet@google.com>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2c46e753-e287-dd38-8ade-0655a7a43987@iogearbox.net>
Date: Thu, 1 Jun 2023 16:33:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230530195149.68145-1-edumazet@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26925/Thu Jun  1 09:27:46 2023)
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/30/23 9:51 PM, Eric Dumazet wrote:
> syzbot found sk_psock(sk) could return NULL when called
> from sk_psock_verdict_data_ready().

Looks like patchbot didn't answer. Applied, thanks Eric!

