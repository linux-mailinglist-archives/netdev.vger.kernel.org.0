Return-Path: <netdev+bounces-4719-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15BC770E014
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 17:13:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BAB8C28135B
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 15:13:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4912B1F93B;
	Tue, 23 May 2023 15:13:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D07D1F939
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 15:13:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B85AC433D2;
	Tue, 23 May 2023 15:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684854815;
	bh=c2ZZismw085K/86omhVayi5O5C8nuCR7l8WRnWRu3Ug=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HjXNNiJ82Da3DVQjdYugyQGcQ7TIf4amMYWy55TTnybYlxnxt0W8aoy7lLNlVXhRl
	 IX1ECKXBxBXfPghMohTiwi8kokYZS4XxuGWolkrjlSYnebLjQjbYFnCuyV04CaGC6w
	 Awhfj9XqAhNjVqPQguhFRiTK/GwOItMRtSI7+vNOnClRR0k4KgANsz+ctq/qNkIfKT
	 jsPkj1zqG0P1f9h43gBm0+VQhVXC5xJZ+TC4GVqJC3y7lc+gnjg+0hhsByNyPDe0N4
	 R1PhxvBnvvlAmtZO5EyXZgwZQLVxyI/rEvr+OMAPqvxH7JLjpQKWO4FkJa6LUOEiKE
	 e/oi0jQRtI1iw==
Message-ID: <4927162d-1766-c495-4be2-873fa280218f@kernel.org>
Date: Tue, 23 May 2023 09:13:35 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 2/3] raw: Stop using RTO_ONLINK.
Content-Language: en-US
To: Guillaume Nault <gnault@redhat.com>, David Miller <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org, Willem de Bruijn <willemdebruijn.kernel@gmail.com>
References: <cover.1684764727.git.gnault@redhat.com>
 <6ca7a70859803ff272cc965409856de354fa4e6c.1684764727.git.gnault@redhat.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <6ca7a70859803ff272cc965409856de354fa4e6c.1684764727.git.gnault@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/22/23 8:38 AM, Guillaume Nault wrote:
> Use ip_sendmsg_scope() to properly initialise the scope in
> flowi4_init_output(), instead of overriding tos with the RTO_ONLINK
> flag. The objective is to eventually remove RTO_ONLINK, which will
> allow converting .flowi4_tos to dscp_t.
> 
> The MSG_DONTROUTE and SOCK_LOCALROUTE cases were already handled by
> raw_sendmsg() (SOCK_LOCALROUTE was handled by the RT_CONN_FLAGS*()
> macros called by get_rtconn_flags()). However, opt.is_strictroute
> wasn't taken into account. Therefore, a side effect of this patch is to
> now honour opt.is_strictroute, and thus align raw_sendmsg() with
> ping_v4_sendmsg() and udp_sendmsg().
> 
> Since raw_sendmsg() was the only user of get_rtconn_flags(), we can now
> remove this function.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  include/net/ip.h |  5 -----
>  net/ipv4/raw.c   | 10 ++++------
>  2 files changed, 4 insertions(+), 11 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>



