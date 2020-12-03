Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A0D2CDB09
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 17:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbgLCQVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 11:21:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:45364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726869AbgLCQVV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 11:21:21 -0500
Date:   Thu, 3 Dec 2020 08:20:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607012440;
        bh=pDjtHBWRp2TtH9qIwtNPK7fsHmGwumvtg/UIs1NJBCQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=NcX02tLib+GY0bhZePF9tkZN/5fGQfApdD1Keqr2C30ER7qB2xX6uFdDa7uNGl5wZ
         XASljJyNcL/nHhkrlW47eMk8LFTiXo7fC6i6CuxEnwFuGkiRank9z232DNnDdEUDru
         CU0i/+hS67+yQg2Eoux/0pDbx/+gA30guTc28NgDXOPJmKvKjlgrjZ7fuWfBRn3al2
         nRQwwyepfhVGowvCqkoZrn5uQh4WWHn9niZEul57/Uk9R+Zlc9/u/GpJ8z69zM8GfU
         VEXwWf5LLOA2o3pxpnxYHISf9KF/hKPXruvanlEFnuHfRQ2pI7/NDjaN2S/eBO89W9
         OAxFASib6mh0Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Karlsson <thomas.karlsson@paneda.se>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>, <jiri@resnulli.us>,
        <kaber@trash.net>, <edumazet@google.com>, <vyasevic@redhat.com>,
        <alexander.duyck@gmail.com>
Subject: Re: [PATCH net-next v4] macvlan: Support for high multicast packet
 rate
Message-ID: <20201203082038.3dab8511@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <dd4673b2-7eab-edda-6815-85c67ce87f63@paneda.se>
References: <485531aec7e243659ee4e3bb7fa2186d@paneda.se>
        <147b704ac1d5426fbaa8617289dad648@paneda.se>
        <20201123143052.1176407d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <dd4673b2-7eab-edda-6815-85c67ce87f63@paneda.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Dec 2020 19:49:58 +0100 Thomas Karlsson wrote:
> Background:
> Broadcast and multicast packages are enqueued for later processing.
> This queue was previously hardcoded to 1000.
> 
> This proved insufficient for handling very high packet rates.
> This resulted in packet drops for multicast.
> While at the same time unicast worked fine.
> 
> The change:
> This patch make the queue length adjustable to accommodate
> for environments with very high multicast packet rate.
> But still keeps the default value of 1000 unless specified.
> 
> The queue length is specified as a request per macvlan
> using the IFLA_MACVLAN_BC_QUEUE_LEN parameter.
> 
> The actual used queue length will then be the maximum of
> any macvlan connected to the same port. The actual used
> queue length for the port can be retrieved (read only)
> by the IFLA_MACVLAN_BC_QUEUE_LEN_USED parameter for verification.
> 
> This will be followed up by a patch to iproute2
> in order to adjust the parameter from userspace.
> 
> Signed-off-by: Thomas Karlsson <thomas.karlsson@paneda.se>

> @@ -1658,6 +1680,8 @@ static const struct nla_policy macvlan_policy[IFLA_MACVLAN_MAX + 1] = {
>  	[IFLA_MACVLAN_MACADDR] = { .type = NLA_BINARY, .len = MAX_ADDR_LEN },
>  	[IFLA_MACVLAN_MACADDR_DATA] = { .type = NLA_NESTED },
>  	[IFLA_MACVLAN_MACADDR_COUNT] = { .type = NLA_U32 },
> +	[IFLA_MACVLAN_BC_QUEUE_LEN] = { .type = NLA_U32 },

I wonder whether we should require that the queue_len is > 0? Is there 
a valid use case for the queue to be completely disabled? If you agree
please follow up with a simple patch which adds a NLA_POLICY_MIN() here.

Applied to net-next, thank you!
