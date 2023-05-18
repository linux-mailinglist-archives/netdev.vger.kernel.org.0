Return-Path: <netdev+bounces-3707-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 179AD70863A
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 18:51:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4DAB1C2116B
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 16:51:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C03D624E81;
	Thu, 18 May 2023 16:51:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B614C18C15
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 16:51:47 +0000 (UTC)
Received: from out-15.mta1.migadu.com (out-15.mta1.migadu.com [IPv6:2001:41d0:203:375::f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EEF1F0
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 09:51:45 -0700 (PDT)
Message-ID: <b18fdfc3-987d-9351-ca6c-5d4cb2d71af1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1684428703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ACL37b8C6uNkXt0bSkAGiLPWMou3pgeqO2fRgTHx++Y=;
	b=tntsPjNhZ3Zrby4uL1wiEM2ftSOQn9JbHLbKbrfL5dgpftLaT1zllCny1Ot9IL1xctPVmh
	DWOZ9qFwep8t4Z2ogRopExgyDY8duLyk1/9OBU8Q+Q3NzOK/LBBEF6ISpDcwU2iOe3GMPM
	zmC8ecsEAHt52WTUftwyIrcRxxLcH7k=
Date: Thu, 18 May 2023 09:51:39 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH bpf] Use call_rcu_hurry() with synchronize_rcu_mult()
Content-Language: en-US
To: paulmck@kernel.org
Cc: Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
 John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>,
 Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>,
 Jiri Olsa <jolsa@kernel.org>, bpf@vger.kernel.org, netdev@vger.kernel.org
References: <358bde93-4933-4305-ac42-4d6f10c97c08@paulmck-laptop>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <358bde93-4933-4305-ac42-4d6f10c97c08@paulmck-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/18/23 7:47 AM, Paul E. McKenney wrote:
> The bpf_struct_ops_map_free() function must wait for both an RCU grace
> period and an RCU Tasks grace period, and so it passes call_rcu() and
> call_rcu_tasks() to synchronize_rcu_mult().  This works, but on ChromeOS
> and Android platforms call_rcu() can have lazy semantics, resulting in
> multi-second delays between call_rcu() invocation and invocation of the
> corresponding callback.
> 
> Therefore, substitute call_rcu_hurry() for call_rcu().

My understanding on the net-effect is to free up the struct_ops resources faster.

I believe call_rcu() should be fine. struct_ops freeing should not happen very 
often. For example, when a bpf written tcp congestion control (struct_ops) is 
registered, it will stay in the kernel for a long time. A couple seconds delay 
in releasing the struct_ops should be acceptable.


