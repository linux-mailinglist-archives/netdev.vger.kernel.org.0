Return-Path: <netdev+bounces-7624-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE14C720E14
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 08:17:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1A8A1C212B8
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 06:17:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E4955C98;
	Sat,  3 Jun 2023 06:17:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57AE9847F
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 06:17:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C61AC433D2;
	Sat,  3 Jun 2023 06:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685773074;
	bh=GPNN/sqyg5NjDyqSyJLKgKnyIYY0cqzOmeAO64X/57g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=noVM8XZwxGSJiWxLyOrROy5aXdxAFstWLy1e6I429cNpUVeEYga36y42TJ3UWtMmH
	 W+xl+/uY0CxNImEJmJqDjp6MyBH0hk+QS+63e+oJ6As8Fitu3i5FDj3tQg4X3vHM2c
	 jPRGQtJsMdrGIvYZPYbF5HkzSZBHB3XqMaVqlwvzCv02VIJi9t4n6X16plbb9qQwZ2
	 S52/Icu9WxbSy2PVKWnl+mFRpaTW19iA1sgVRG+pLqe/5SD0T8n9NVt6b8wTc5tJOd
	 0uRaPeFqtrnWw71ujN9tTk0R7G9Ky5jftFk9QIuZvOI7k76XO9KRbMNocCaKQh6Q3H
	 XpsvU5LcWwcCw==
Date: Fri, 2 Jun 2023 23:17:53 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Amritha Nambiar <amritha.nambiar@intel.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, sridhar.samudrala@intel.com
Subject: Re: [net-next/RFC PATCH v1 4/4] netdev-genl: Add support for
 exposing napi info from netdev
Message-ID: <20230602231753.37ec92b9@kernel.org>
In-Reply-To: <168564136118.7284.18138054610456895287.stgit@anambiarhost.jf.intel.com>
References: <168564116688.7284.6877238631049679250.stgit@anambiarhost.jf.intel.com>
	<168564136118.7284.18138054610456895287.stgit@anambiarhost.jf.intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 01 Jun 2023 10:42:41 -0700 Amritha Nambiar wrote:
> Add support in ynl/netdev.yaml for napi related information. The
> netdev structure tracks all the napi instances and napi fields.
> The napi instances and associated queue[s] can be retrieved this way.
> 
> Refactored netdev-genl to support exposing napi<->queue[s] mapping
> that is retained in a netdev.
> 
> Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>
> ---
>  Documentation/netlink/specs/netdev.yaml |   39 +++++
>  include/uapi/linux/netdev.h             |    4 +
>  net/core/netdev-genl.c                  |  239 ++++++++++++++++++++++++++-----
>  tools/include/uapi/linux/netdev.h       |    4 +
>  4 files changed, 247 insertions(+), 39 deletions(-)
> 
> diff --git a/Documentation/netlink/specs/netdev.yaml b/Documentation/netlink/specs/netdev.yaml
> index b99e7ffef7a1..8d0edb529563 100644
> --- a/Documentation/netlink/specs/netdev.yaml
> +++ b/Documentation/netlink/specs/netdev.yaml
> @@ -62,6 +62,44 @@ attribute-sets:
>          type: u64
>          enum: xdp-act
>          enum-as-flags: true
> +      -
> +        name: napi-info
> +        doc: napi information such as napi-id, napi queues etc.
> +        type: nest
> +        multi-attr: true

Let's make a new attr space for the napi info command.
We don't reuse much of the attributes, and as the commands 
grow stuffing all attrs into one space makes finding stuff 
harder.

> +        nested-attributes: dev-napi-info

And what's inside this nest should also be a separate attr space.


> +      -
> +        name: napi-id
> +        doc: napi id
> +        type: u32
> +      -
> +        name: rx-queues
> +        doc: list of rx queues associated with a napi
> +        type: u16

Make it u32, at the uAPI level we're tried to the width of fields, and
u16 ends up being the same size as u32 "on the wire" due to padding.

> +        multi-attr: true
> +      -
> +        name: tx-queues
> +        doc: list of tx queues associated with a napi
> +        type: u16
> +        multi-attr: true


> +  -
> +    name: dev-napi-info
> +    subset-of: dev

Yeah, this shouldn't be a subset just a full-on separate attr space.
The handshake family may be a good example to look at, it's the biggest
so far written with the new rules in mind. 

> +    attributes:
> +      -
> +        name: napi-id
> +        doc: napi id
> +        type: u32
> +      -
> +        name: rx-queues
> +        doc: list rx of queues associated with a napi
> +        type: u16
> +        multi-attr: true
> +      -
> +        name: tx-queues
> +        doc: list tx of queues associated with a napi
> +        type: u16
> +        multi-attr: true
>  
>  operations:
>    list:
> @@ -77,6 +115,7 @@ operations:
>            attributes:
>              - ifindex
>              - xdp-features
> +            - napi-info

Aaah, separate command, please. Let's not stuff all the information
into a single command like we did for rtnl.

>        dump:
>          reply: *dev-all
>      -

