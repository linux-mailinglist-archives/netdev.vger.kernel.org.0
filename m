Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0953F6018
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 16:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237709AbhHXOVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 10:21:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237629AbhHXOVe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 10:21:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4AA3611EF;
        Tue, 24 Aug 2021 14:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629814850;
        bh=Vqxn9Pp2lymDhFqYmDN38oKpw1DF8fgwY36r0tJnI4k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DUYI5+eAnGsGPwfI6lc9pgui0ozgRu3RfoRFSo2Gs1fjIo2cksIb8eG29Bp8hfrH1
         aoh+kUUaDyLBSIRlFrN/lwJPVYPMCZDifzXkb8L+CPfOer1wdVORIkpAs2WezzSolk
         +XXwxlw2Ov+IqdOdoCYtYXBcEVqoDDiUfarOYLTfd9ZlQSlF137aDAkWy22mbvAEoP
         qv0iPtd459s7K8qY7BOjlAuQfSBY7Y7kO+GCC45QnJCI7bo28bUipPNJUaMZ84PMHn
         OWVckqCTQfLBJp3b4dSWt9r3VIhJyXLBkKnPuw2/hFK7Hi4VZCrVCaOOtkiZ3Xcp9I
         mnQ1QKPwL7CxA==
Date:   Tue, 24 Aug 2021 07:20:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhongya Yan <yan2228598786@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        edumazet@google.com, rostedt@goodmis.org, mingo@redhat.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        hengqi.chen@gmail.com, yhs@fb.com
Subject: Re: [PATCH] net: tcp_drop adds `reason` parameter for tracing
Message-ID: <20210824072049.76789bba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210824125140.190253-1-yan2228598786@gmail.com>
References: <20210824125140.190253-1-yan2228598786@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Aug 2021 05:51:40 -0700 Zhongya Yan wrote:
> +enum tcp_drop_reason {
> +	TCP_OFO_QUEUE = 1,
> +	TCP_DATA_QUEUE_OFO = 2,
> +	TCP_DATA_QUEUE = 3,
> +	TCP_PRUNE_OFO_QUEUE = 4,
> +	TCP_VALIDATE_INCOMING = 5,
> +	TCP_RCV_ESTABLISHED = 6,
> +	TCP_RCV_SYNSENT_STATE_PROCESS = 7,
> +	TCP_RCV_STATE_PROCESS = 8
> +};

This is basically tracking the caller, each may have multiple reasons
for dropping. Is tracking the caller sufficient? Should we at least
make this a bitmask so we can set multiple bits (caller and more
precise reason)? Or are we going to add another field in that case?

> -static void tcp_drop(struct sock *sk, struct sk_buff *skb)
> +static void __tcp_drop(struct sock *sk,
> +		   struct sk_buff *skb)
>  {
>  	sk_drops_add(sk, skb);
>  	__kfree_skb(skb);
>  }

Why keep this function if there is only one caller?

> +/* tcp_drop whit reason,for epbf trace
> + */

This comment is (a) misspelled, (b) doesn't add much value.

> +static void tcp_drop(struct sock *sk, struct sk_buff *skb,
> +		 enum tcp_drop_reason reason)
> +{
> +	trace_tcp_drop(sk, skb, reason);
> +	__tcp_drop(sk, skb);
> +}
