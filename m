Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 285C8114118
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 13:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbfLEM6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 07:58:50 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38046 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729099AbfLEM6u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Dec 2019 07:58:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Re18R+zvHW22gTZUWM5G+y1mglFdF33WZZhd8u13ENU=; b=ISS+iwm4GEajcnWmdI+CAx1dLq
        /pA0TK0twSbpVXEiHZUfMswjcFncqO8a+fpeQuEx9p4FYARYyLozq/Jtwd5/XCSxYyY67Jk/7Sl7I
        hxY5Z3ZwD+8yUG/F1DJbo/zGql4/FJ/wj0M/YlPTTIBK/g0KfqVbGKLSUWXZF7RifIJE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1icqiB-0007OM-Fl; Thu, 05 Dec 2019 13:58:27 +0100
Date:   Thu, 5 Dec 2019 13:58:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexander Lobakin <alobakin@dlink.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Muciri Gatimu <muciri@openmesh.com>,
        Shashidhar Lakkavalli <shashidhar.lakkavalli@openmesh.com>,
        John Crispin <john@phrozen.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Matteo Croce <mcroce@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Paul Blakey <paulb@mellanox.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: fix flow dissection on Tx path
Message-ID: <20191205125827.GA28269@lunn.ch>
References: <20191205100235.14195-1-alobakin@dlink.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191205100235.14195-1-alobakin@dlink.ru>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 05, 2019 at 01:02:35PM +0300, Alexander Lobakin wrote:
> Commit 43e665287f93 ("net-next: dsa: fix flow dissection") added an
> ability to override protocol and network offset during flow dissection
> for DSA-enabled devices (i.e. controllers shipped as switch CPU ports)
> in order to fix skb hashing for RPS on Rx path.
> 
> However, skb_hash() and added part of code can be invoked not only on
> Rx, but also on Tx path if we have a multi-queued device and:
>  - kernel is running on UP system or
>  - XPS is not configured.
> 
> The call stack in this two cases will be like: dev_queue_xmit() ->
> __dev_queue_xmit() -> netdev_core_pick_tx() -> netdev_pick_tx() ->
> skb_tx_hash() -> skb_get_hash().
> 
> The problem is that skbs queued for Tx have both network offset and
> correct protocol already set up even after inserting a CPU tag by DSA
> tagger, so calling tag_ops->flow_dissect() on this path actually only
> breaks flow dissection and hashing.

Hi Alexander

What i'm missing here is an explanation why the flow dissector is
called here if the protocol is already set? It suggests there is a
case when the protocol is not correctly set, and we do need to look
into the frame?

     Andrew
