Return-Path: <netdev+bounces-9427-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 507FE728E4B
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 05:06:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D0D31C2100B
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 03:06:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B948186B;
	Fri,  9 Jun 2023 03:06:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733771865;
	Fri,  9 Jun 2023 03:06:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5189AC4339B;
	Fri,  9 Jun 2023 03:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686279992;
	bh=gsCtAHudw+LCKL9X0U1FJenLoxKzgteNYBvrPVGH2XU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=nqDe4zqgZpz8nUrWvrZxeA/E7iL6DtNpJWQ0GEGM73v+Wk5AIMkxgA35xi2h70xMe
	 8C0KlvIBhH5M9O/ZwOb5JvRKvGrS4xYCInOVlKg40C34QEvvDOb+MvIqTDMucLK4+b
	 pUFFCpkyg6xKnZGYrvU1iVk5S7hkgOuH8gv6QexzQ5mKBrgDdzWXYYk2UQDsJThoZe
	 f1hXMCT7T1luMu2khr+4toh6WyLHOK+XfeDt5JIRXir7cXigub+kp+dXsa3Csu7/nK
	 Mv9tPNFna4H0IjtPqSJs60dt+VYzmtSrjuImffTiMmhVMkcjbv0TO4VB4fX2wAwNBW
	 q3+0ZZ4gXoKRQ==
Date: Thu, 8 Jun 2023 20:06:31 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: ast@kernel.org, andrii@kernel.org, martin.lau@linux.dev,
 razor@blackwall.org, sdf@google.com, john.fastabend@gmail.com,
 dxu@dxuuu.xyz, joe@cilium.io, toke@kernel.org, davem@davemloft.net,
 bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 2/7] bpf: Add fd-based tcx multi-prog infra
 with link support
Message-ID: <20230608200631.65833760@kernel.org>
In-Reply-To: <20230607192625.22641-3-daniel@iogearbox.net>
References: <20230607192625.22641-1-daniel@iogearbox.net>
	<20230607192625.22641-3-daniel@iogearbox.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  7 Jun 2023 21:26:20 +0200 Daniel Borkmann wrote:
> +	dev = dev_get_by_index(net, attr->link_create.target_ifindex);
> +	if (!dev)
> +		return -EINVAL;
> +	link = kzalloc(sizeof(*link), GFP_USER);
> +	if (!link) {
> +		err = -ENOMEM;
> +		goto out_put;
> +	}
> +
> +	bpf_link_init(&link->link, BPF_LINK_TYPE_TCX, &tcx_link_lops, prog);
> +	link->location = attr->link_create.attach_type;
> +	link->flags = attr->link_create.flags & (BPF_F_FIRST | BPF_F_LAST);
> +	link->dev = dev;
> +
> +	err = bpf_link_prime(&link->link, &link_primer);
> +	if (err) {
> +		kfree(link);
> +		goto out_put;
> +	}
> +	rtnl_lock();

How does this work vs device unregistering? 

Best I can tell (and it is a large patch :() the device may have passed
dev_tcx_uninstall() by the time we take the lock.

> +	err = tcx_link_prog_attach(&link->link, attr->link_create.flags,
> +				   attr->link_create.tcx.relative_fd,
> +				   attr->link_create.tcx.expected_revision);
> +	if (!err)
> +		fd = bpf_link_settle(&link_primer);
> +	rtnl_unlock();

