Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED541499A0
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 09:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbgAZITp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 03:19:45 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:48247 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726438AbgAZITp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 03:19:45 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id D9E0E21EC3;
        Sun, 26 Jan 2020 03:19:43 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 26 Jan 2020 03:19:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=OwfykH
        ST6emhj2qWXbkJDIvppm6lZI4tYBHZDFu02j4=; b=vY8KB5IY8uC3RgCweCMkct
        Ts7HKVZonwawtRHzi7wVju60LoK3uPkvMx+h4GR9XARhiQX6+loHiOGlIv3Lpbqv
        eP4Lz0KIxnekEMxlgCtmdWLbIQLNJM6PFY1bg6VO3BwJhL4kxb2InqhzgByY7BnA
        3RuhQZ86tzsYhgBgxXAMCkaC/gbxRBa5f+x55axdUGZRgYNtvK7tVtAqJyErJnON
        90ZLLxJjv3caQflx4eqfI6C3Ne7YLzC4vuqMbOGONuYQktE6i4L5GJJHvvH6ne7s
        RmXlfb8Z5VscKzuaOSBFYyBP9809ZVXJFqLdLcbhuAjAviU/HTj4S1n1cJMtxtpQ
        ==
X-ME-Sender: <xms:n0stXtEj2g4vXOty7h8TYiIJWo3kNQBZavIcJlonLlYAgTSJMbe7Iw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrvdelgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppeduleefrd
    egjedrudeihedrvdehudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:n0stXjl6kD2gxBiW5EXnrQrbrvBnzJyEIw79kSbAlmnKyh_G4udnaQ>
    <xmx:n0stXsOd8bls5iQM77WU5ZOGQ_UAtXtbENyGVLhPa5E5OGEA9UKL7A>
    <xmx:n0stXmFghZwLwr4iQQrFFpkzxjTNQEMsRonbImnaeV1yLp9u4w2ELw>
    <xmx:n0stXnZLoq0fNxvP5g2M-q2eAPmmfMgXScRr1WRcaYgxYIGq1cXgXQ>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3B81430673CF;
        Sun, 26 Jan 2020 03:19:43 -0500 (EST)
Date:   Sun, 26 Jan 2020 10:19:41 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     jiri@mellanox.com, idosch@mellanox.com, davem@davemloft.net,
        vadimp@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] mlxsw: minimal: Fix an error handling path in
 'mlxsw_m_port_create()'
Message-ID: <20200126081941.GA794072@splinter>
References: <20200125211847.12755-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200125211847.12755-1-christophe.jaillet@wanadoo.fr>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 25, 2020 at 10:18:47PM +0100, Christophe JAILLET wrote:
> An 'alloc_etherdev()' called is not ballanced by a corresponding
> 'free_netdev()' call in one error handling path.
> 
> Slighly reorder the error handling code to catch the missed case.
> 
> Fixes: c100e47caa8e ("mlxsw: minimal: Add ethtool support")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

For net:

Reviewed-by: Ido Schimmel <idosch@mellanox.com>

Thanks!
