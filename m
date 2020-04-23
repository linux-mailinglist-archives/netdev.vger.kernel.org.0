Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE37D1B56EA
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 10:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgDWIGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 04:06:31 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:48321 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725854AbgDWIGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 04:06:31 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 387795C0217;
        Thu, 23 Apr 2020 04:06:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 23 Apr 2020 04:06:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=rytz08
        /8hem93WByaKT1VEuUtBYCkH3Sr7hNZmPBFGU=; b=l4pR6INcU/jMtypKK2Z3tr
        sdUor0wrIYTITjKxK92D9K0GPfJGRUT8N9eJO6aIy9EnNGBtVIp7Td2HuId/m7Aw
        SgHXtTMPt5Eubck7x7TLahpwYu8+hWja2z+6FcOyDoqqDrexwcvy5Xig59AnS15x
        uowtF2CQYo5z1gPrgc/GSK2UnAYtRKPWgBfUEhbto2Osf/+8zPil61ktIfD1d1V3
        wO6/+pPTu57lCpKjKm8cK/w0f2ztpDnekkRuZOwV5uwWQyGj2621ZUE+bKBoulRG
        6soMCaLVJMMZUJmWJYbBYKGF7PcJkuJe8bugIqYlkJtGVxr0UA4FbrRf5eooEhdQ
        ==
X-ME-Sender: <xms:hUyhXnBToLvTqtzkMY5fMFnMH9qZyP-yT5xwf4r2SFkJ3ONRNa05_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrgeelucetufdoteggodetrfdotffvucfrrh
    hofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfutghhihhm
    mhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepjeelrddukedtrd
    ehgedrudduieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhr
    ohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:hUyhXt7aiMOK9vl1Ss4B3vQWBZoOHDf5WuHr9FB_gmT1Mms00xoMlg>
    <xmx:hUyhXjuySv0R9wfc10PrPki6Vrz0chMT_-QgjERZKgjkvSSVdnaZsw>
    <xmx:hUyhXlyWJAu_qO8sxUxnxfzSfDz2sq0cCR8Ix5e0WpqHUODcZt-RrQ>
    <xmx:hkyhXnWm4mD5uUhPckXU3zvrRhGzcQA2f-KZpwAyRH3fbAQ5SaNAYA>
Received: from localhost (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8E2703280064;
        Thu, 23 Apr 2020 04:06:29 -0400 (EDT)
Date:   Thu, 23 Apr 2020 11:06:27 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] mlxsw: Fix some IS_ERR() vs NULL bugs
Message-ID: <20200423080627.GA3616668@splinter>
References: <20200422093641.GA189235@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422093641.GA189235@mwanda>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 12:36:41PM +0300, Dan Carpenter wrote:
> The mlxsw_sp_acl_rulei_create() function is supposed to return an error
> pointer from mlxsw_afa_block_create().  The problem is that these
> functions both return NULL instead of error pointers.  Half the callers
> expect NULL and half expect error pointers so it could lead to a NULL
> dereference on failure.
> 
> This patch changes both of them to return error pointers and changes all
> the callers which checked for NULL to check for IS_ERR() instead.
> 
> Fixes: 4cda7d8d7098 ("mlxsw: core: Introduce flexible actions support")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Ido Schimmel <idosch@mellanox.com>

Thanks, Dan.
