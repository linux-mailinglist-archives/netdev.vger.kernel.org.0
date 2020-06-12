Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFA61F77F7
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 14:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgFLMco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 08:32:44 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33527 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726024AbgFLMcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 08:32:43 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 2A9435C013E;
        Fri, 12 Jun 2020 08:32:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 12 Jun 2020 08:32:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ggWp/s
        qcRfTrALvKWXDugiB3f5JfbUJOAKovN41x6sg=; b=ZeUJIiYNbzVE5TIQXce6Vr
        Ca6yEWJ64Naam4DAdqelgSse1HTtkwkLte+aHSaZuXNL3ttA4o11rAKGViJ2k7Yq
        /p3vNs8HZsIsOAZq76IEA5KUkhYKjGlg3Kzt6QlKjP1oOEKaWzlZsmxmGozDzDHk
        UEr9T4fGszPswCym7eQ24WYoMfplgTERVBHbSyCLeekUwgaPfH6J4LUguuiAYuNR
        P4rMMkrju8mmtGC2PgQCBjSOxUyjBSv1CUxXeYzF+kC3GPAizr841VY3ZwPBSw7T
        9jRh8byxreCdVWQ8D09PkXxRZdBinU/o5wVYOp2Vks9tNS5IsVyU2lPfw6imcM1A
        ==
X-ME-Sender: <xms:6XXjXnre0UilmsHOeuW263KMK6XfTHRj-VShbKCBw4zns1_Y9CURvg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeiuddgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnheptdffkeekfeduffevgeeujeffjefhte
    fgueeugfevtdeiheduueeukefhudehleetnecukfhppeejledrudejledrledtrdefvden
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:6nXjXhpyq7trQ4Qe5s-TFJkSKu8yU0sFIaejluI0jFXVr5-bfcv4Fw>
    <xmx:6nXjXkNJ26OrAPqNOxxeLfSBrzCFghdLjz3svjuhbiBMVG6OypxSyg>
    <xmx:6nXjXq7P17Bgm5p336_syLWLAy06Mv5HlAbS9PWCxPYSN9xeVbrfyw>
    <xmx:6nXjXlIHe3NsH4mgKDp0YYTfGuPh2Ef2TxF6R0wymQ1rjIeJatyH_A>
Received: from localhost (bzq-79-179-90-32.red.bezeqint.net [79.179.90.32])
        by mail.messagingengine.com (Postfix) with ESMTPA id 06435328013B;
        Fri, 12 Jun 2020 08:31:11 -0400 (EDT)
Date:   Fri, 12 Jun 2020 15:31:09 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [Patch net] genetlink: clean up family attributes allocations
Message-ID: <20200612123109.GA22179@splinter>
References: <20200612071655.8009-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200612071655.8009-1-xiyou.wangcong@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 12, 2020 at 12:16:55AM -0700, Cong Wang wrote:
> genl_family_rcv_msg_attrs_parse() and genl_family_rcv_msg_attrs_free()
> take a boolean parameter to determine whether allocate/free the family
> attrs. This is unnecessary as we can just check family->parallel_ops.
> More importantly, callers would not need to worry about pairing these
> parameters correctly after this patch.
> 
> And this fixes a memory leak, as after commit c36f05559104
> ("genetlink: fix memory leaks in genl_family_rcv_msg_dumpit()")
> we call genl_family_rcv_msg_attrs_parse() for both parallel and
> non-parallel cases.
> 
> Fixes: c36f05559104 ("genetlink: fix memory leaks in genl_family_rcv_msg_dumpit()")
> Reported-by: Ido Schimmel <idosch@idosch.org>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Reviewed-by: Ido Schimmel <idosch@mellanox.com>
Tested-by: Ido Schimmel <idosch@mellanox.com>

Thanks!
