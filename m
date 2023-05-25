Return-Path: <netdev+bounces-5345-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA9BA710E6F
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 16:35:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64F0D2810B4
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 14:35:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49CFD156D4;
	Thu, 25 May 2023 14:35:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4C4BE62
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 14:35:14 +0000 (UTC)
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E9A2191
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 07:35:11 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id e9e14a558f8ab-3381a0cae92so15977575ab.0
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 07:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google; t=1685025311; x=1687617311;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JahCaEAcBw9V6auX2WbLCtlVTk1hNDt7t03CHUqfyvo=;
        b=SILAZmmgq40xZgWfpxY3p9hsAyde96AlkJ5qyeD39YtWBjB5PFhdA77+izm6ZtU36Z
         2p3oRgcC5agZmP2e1FhX/XDexpm6x0N7qxAhYSLz3aMVpvqITip0GgGm50berArVoVSG
         PJThuD0bxmiNPDl6RLIREMJ4ptm4V1BQgu80Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685025311; x=1687617311;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JahCaEAcBw9V6auX2WbLCtlVTk1hNDt7t03CHUqfyvo=;
        b=ECliL0oEB9qMNTiEr/orVqdOAP4WlEZLwl2qQlGBNFHF1jYC8u0CAJxBGYdOl0qvOz
         pyGFNpkgGhK+7bfvcwzPjXRQjbJHJZ0mFuAZpemUT6a2cvm++KomHt8miXxcmMAOU6do
         adQMqg7OhD39hfkxyEWiL7rsFMQib4Xi6SxDaI3xcI+ee+PAWvAz0Gio7YoK7QWsyPlB
         jSyxCg6w/1v8rKZKtBTHymEdOZX+hr3vMRw+pJhcks8J+kllm9jXJBv2tsNPm/tNsJeq
         AzjqorPkpT205rRVzdKFW9XwZd4rrQ6/aVzPr2nVrvG+LPrRU3RaA6zm9vp5bAZUuPc8
         HR2g==
X-Gm-Message-State: AC+VfDwL5oOfY5zoXqqaY4WxEOGZmYaJ7XfwpCMKRK5j6XMlkqp+ZEFo
	j2MBaDtlW6WMnQmOXKff+Z2tcw==
X-Google-Smtp-Source: ACHHUZ57NPBBTPwP4lbLmEm986qk4qyv9srWKqLvNVrBhAlVekEW1NwCP5+Y04iPFmqJa7342e+Cpg==
X-Received: by 2002:a92:bf06:0:b0:33a:2863:2c57 with SMTP id z6-20020a92bf06000000b0033a28632c57mr7791038ilh.9.1685025310896;
        Thu, 25 May 2023 07:35:10 -0700 (PDT)
Received: from fastly.com ([216.80.70.252])
        by smtp.gmail.com with ESMTPSA id o14-20020a92c04e000000b0032648a86067sm374789ilf.4.2023.05.25.07.35.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 May 2023 07:35:10 -0700 (PDT)
Date: Thu, 25 May 2023 07:35:08 -0700
From: Joe Damato <jdamato@fastly.com>
To: Yonghong Song <yhs@meta.com>
Cc: bpf@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, ast@kernel.org, edumazet@google.com,
	martin.lau@linux.dev, song@kernel.org, john.fastabend@gmail.com,
	kpsingh@kernel.org, sdf@google.com, jolsa@kernel.org,
	haoluo@google.com
Subject: Re: [PATCH bpf-next] bpf: Export rx queue info for reuseport ebpf
 prog
Message-ID: <20230525143508.GA21064@fastly.com>
References: <20230525033757.47483-1-jdamato@fastly.com>
 <26c90595-f45e-a813-d538-0892c3ef2424@meta.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26c90595-f45e-a813-d538-0892c3ef2424@meta.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 10:26:32PM -0700, Yonghong Song wrote:
> 
> 
> On 5/24/23 8:37 PM, Joe Damato wrote:
> >BPF_PROG_TYPE_SK_REUSEPORT / sk_reuseport ebpf programs do not have
> >access to the queue_mapping or napi_id of the incoming skb. Having
> >this information can help ebpf progs determine which listen socket to
> >select.
> >
> >This patch exposes both queue_mapping and napi_id so that
> >sk_reuseport ebpf programs can use this information to direct incoming
> >connections to the correct listen socket in the SOCKMAP.
> >
> >For example:
> >
> >A multi-threaded userland program with several threads accepting client
> >connections via a reuseport listen socket group might want to direct
> >incoming connections from specific receive queues (or NAPI IDs) to specific
> >listen sockets to maximize locality or for use with epoll busy-poll.
> >
> >Signed-off-by: Joe Damato <jdamato@fastly.com>
> >---
> >  include/uapi/linux/bpf.h |  2 ++
> >  net/core/filter.c        | 10 ++++++++++
> >  2 files changed, 12 insertions(+)
> >
> >diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> >index 9273c654743c..31560b506535 100644
> >--- a/include/uapi/linux/bpf.h
> >+++ b/include/uapi/linux/bpf.h
> >@@ -6286,6 +6286,8 @@ struct sk_reuseport_md {
> >  	 */
> >  	__u32 eth_protocol;
> >  	__u32 ip_protocol;	/* IP protocol. e.g. IPPROTO_TCP, IPPROTO_UDP */
> >+	__u32 rx_queue_mapping; /* Rx queue associated with the skb */
> >+	__u32 napi_id;          /* napi id associated with the skb */
> >  	__u32 bind_inany;	/* Is sock bound to an INANY address? */
> >  	__u32 hash;		/* A hash of the packet 4 tuples */
> 
> This won't work. You will need to append to the end of data structure
> to keep it backward compatibility.
> 
> Also, recent kernel has a kfunc bpf_cast_to_kern_ctx() which converts
> a ctx to a kernel ctx and you can then use tracing-coding-style to
> access those fields. In this particular case, you can do
> 
>    struct sk_reuseport_kern *kctx = bpf_cast_to_kern_ctx(ctx);
> 
> We have
> 
> struct sk_reuseport_kern {
>         struct sk_buff *skb;
>         struct sock *sk;
>         struct sock *selected_sk;
>         struct sock *migrating_sk;
>         void *data_end;
>         u32 hash;
>         u32 reuseport_id;
>         bool bind_inany;
> };
> 
> through sk and skb pointer, you should be access the fields presented in
> this patch. You can access more fields too.
> 
> So using bpf_cast_to_kern_ctx(), there is no need for more uapi changes.
> Please give a try.

Thanks! I was looking at an LTS kernel tree that didn't have
bpf_cast_to_kern_ctx; this is very helpful and definitely a better way to
go.

Sorry for the noise.

