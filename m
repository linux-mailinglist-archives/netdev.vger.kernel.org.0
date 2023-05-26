Return-Path: <netdev+bounces-5818-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C919712EBA
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 23:09:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD9FB2819A7
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 21:09:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A0A42A9D9;
	Fri, 26 May 2023 21:08:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2102A9C2
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 21:08:58 +0000 (UTC)
Received: from out-15.mta0.migadu.com (out-15.mta0.migadu.com [IPv6:2001:41d0:1004:224b::f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3FF6D9
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 14:08:56 -0700 (PDT)
Message-ID: <2ccea8e0-e36e-a53a-2d30-9ce1bcdb873f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1685135334;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HzRw1oRxlSNTx6McqZxAIkAguO7L3LEtbLLna+/HiDQ=;
	b=eLU3Q3olJ5f5nJw5ZjYEMKeVpvStAUc+wsa8L5kodN8djo1NoC6AO/uDLCwgK/RBPUXdTA
	Znc2cDBnilkhWzCRvhn3Z8a2XhfT9daITUlHCnxN025SnM4acixDr1u0kUKH7lMTub9ULb
	+APhSsIBkvoRTJ2QYtRwfVGf5j5hNwE=
Date: Fri, 26 May 2023 14:08:48 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next 1/2] bpf, net: Support SO_REUSEPORT sockets with
 bpf_sk_assign
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
 daniel@iogearbox.net, davem@davemloft.net, dsahern@kernel.org,
 edumazet@google.com, haoluo@google.com, joe@cilium.io, joe@wand.net.nz,
 john.fastabend@gmail.com, jolsa@kernel.org, kafai@fb.com,
 kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
 lmb@isovalent.com, netdev@vger.kernel.org, pabeni@redhat.com,
 sdf@google.com, song@kernel.org, willemdebruijn.kernel@gmail.com, yhs@fb.com
References: <20230526014317.80715-1-kuniyu@amazon.com>
 <20230526024931.88117-1-kuniyu@amazon.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20230526024931.88117-1-kuniyu@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/25/23 7:49 PM, Kuniyuki Iwashima wrote:
>> We may want to use rcu_access_pointer(sk->sk_reuseport_cb) in
>> each lookup_reuseport() instead of adding sk_state check ?

> And if someone has a weird program that creates multiple listeners and
> disable SO_REUSEPORT for a listener that hits first in lhash2, checking
> sk_reuseport_cb might not work ?  

I am also not sure what the correct expectation is if the application disable 
SO_REUSEPORT in a sk after bind(). This is not something new or specific from 
the current patch though.

> I hope no one does such though, checking sk_reuseport 
> and sk_state could be better.

My previous comment on checking sk_state is to avoid the unnecessary 
inet_ehashfn() for the TCP_ESTABLISHED sk. Checking sk_reuseport_cb could also 
work since it should be NULL for established sk. However, not sure if it could 
be another cacheline access. The udp one is checking the sk_state also: 
"sk->sk_reuseport && sk->sk_state != TCP_ESTABLISHED".

