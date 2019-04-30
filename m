Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C93A9FBF4
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 16:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbfD3O4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 10:56:44 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:58585 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726053AbfD3O4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 10:56:44 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0D362221CF;
        Tue, 30 Apr 2019 10:56:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 30 Apr 2019 10:56:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=bSOLY2
        IVtJIBQv5jsXX2XecWQPBoOXRwfdmB+D+xLhY=; b=PrJFHjBgHfVLmTKwWDFAue
        BlT+kq/qzWvYpDkhb5oxYaOt7l1GQhmtHX1EL8ml/RTnjAdtRW8pnjbmTe1ISg0A
        1Vw9RbmmdUuo9A/erKR/tAkI6B2vKZeErRve4GQ4NTwoKjjfsqeFyQ6hZqySFgTP
        NFzt5dWk2C/lx6o1NSi9cqR+Y50vZneB0tEgc2merHBhg/lirZngQcCId1um9+19
        yBtItHvkLfqg7K8fwrWU9TAsK/pj7aakdSni32ebvoSN7XaaNMOn5676R4OrAebM
        c6Zpbep4vaoYyuEqzxnKo4eJlwvPqnEiFahfYvipVbg6FMr3qshZ5gr77KnIDBug
        ==
X-ME-Sender: <xms:KGLIXM0Ok2fcVpoqjMH4Ga2-vHEyYQk0-fiY-3ef2Ab_fgDLi2cPcA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrieehgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepudelfe
    drgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:KGLIXBGZzhh6eQZa0m-CsvhIdp5yct76p7QQstOnNKNpONDRozLHlg>
    <xmx:KGLIXLgAZy9ghG6JtcmyJ3XTPTVqWe7OsqKTIuHqmbrKwjdWUfO-OA>
    <xmx:KGLIXECc2NOs7IAqC7vUyl9Hk9759e9ehcOMPdr3-hSOCxb3FrfHKQ>
    <xmx:KWLIXGBdz0M8rY_mie7LXqaM-YcW6nY94j9DThrsgroPfC1UaWM-4g>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id BAD4110319;
        Tue, 30 Apr 2019 10:56:39 -0400 (EDT)
Date:   Tue, 30 Apr 2019 17:56:37 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, idosch@mellanox.com,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v4 net-next 1/3] ipv4: Move cached routes to fib_nh_common
Message-ID: <20190430145637.GA20908@splinter>
References: <20190430144550.15033-1-dsahern@kernel.org>
 <20190430144550.15033-2-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430144550.15033-2-dsahern@kernel.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 30, 2019 at 07:45:48AM -0700, David Ahern wrote:
> From: David Ahern <dsahern@gmail.com>
> 
> While the cached routes, nh_pcpu_rth_output and nh_rth_input, are IPv4
> specific, a later patch wants to make them accessible for IPv6 nexthops
> with IPv4 routes using a fib6_nh. Move the cached routes from fib_nh to
> fib_nh_common and update references.
> 
> Initialization of the cached entries is moved to fib_nh_common_init,
> and free is moved to fib_nh_common_release.
> 
> Change in location only, from fib_nh up to fib_nh_common; no functional
> change intended.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>

Reviewed-by: Ido Schimmel <idosch@mellanox.com>
