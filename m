Return-Path: <netdev+bounces-3427-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 60585707115
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 20:48:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 550B11C20F6F
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 18:48:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D27731F06;
	Wed, 17 May 2023 18:48:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B95B4420
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 18:48:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE443C433D2;
	Wed, 17 May 2023 18:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684349307;
	bh=0wwL2+NXSkmPfNrLmHdlLeDAx4VxNIV7troyimyoYxE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=kSMgvqNIyW74smSyIMZr6dOQQXAsSrCfLV9GC2GllU7IqZY2LERlvM0h4DrOy80lS
	 CQNhX5DMLOC+w5ZXhy0CHWPDvu9UvFfxDg9IvbPHCwH/2Qw18QUqvPX9iN3MvcNKsJ
	 no4UeUK8405fuXOCY8ZSGZmds0zQTTvw/LH8+pW3Jka5uiU4uOrydGRA3OBwOwo6AW
	 kMFZFSafBCqBeav+Fb1KAjHCHfvDP8im+/E81T9Rj5XCxkIl11RdHZ7FMSdG5LtsgM
	 PJgRg9QD9it1cz6vvNEXuGRuqzqSGT3I2+lYlUVN5RQe611M6pozW51WGkxZ/KRCgI
	 LJJLasJpHuNrQ==
Date: Wed, 17 May 2023 11:48:25 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Peilin Ye <yepeilin.cs@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Jamal Hadi Salim
 <jhs@mojatatu.com>, Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko
 <jiri@resnulli.us>, Peilin Ye <peilin.ye@bytedance.com>, Daniel Borkmann
 <daniel@iogearbox.net>, John Fastabend <john.r.fastabend@intel.com>, Vlad
 Buslov <vladbu@mellanox.com>, Pedro Tammela <pctammela@mojatatu.com>, Hillf
 Danton <hdanton@sina.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
Message-ID: <20230517114825.5d7c85a4@kernel.org>
In-Reply-To: <e6c4681dd9205d702ae2e6124e20c6210520e76e.1683326865.git.peilin.ye@bytedance.com>
References: <cover.1683326865.git.peilin.ye@bytedance.com>
	<e6c4681dd9205d702ae2e6124e20c6210520e76e.1683326865.git.peilin.ye@bytedance.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  5 May 2023 17:16:10 -0700 Peilin Ye wrote:
>  		} else {
> -			dev_queue = dev_ingress_queue(dev);
> -			old = dev_graft_qdisc(dev_queue, new);
> +			old = dev_graft_qdisc(dev_queue, NULL);
> +
> +			/* {ingress,clsact}_destroy() "old" before grafting "new" to avoid
> +			 * unprotected concurrent accesses to net_device::miniq_{in,e}gress
> +			 * pointer(s) in mini_qdisc_pair_swap().
> +			 */
> +			qdisc_notify(net, skb, n, classid, old, new, extack);
> +			qdisc_destroy(old);
> +
> +			dev_graft_qdisc(dev_queue, new);

BTW can't @old be NULL here?

