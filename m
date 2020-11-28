Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5C22C7333
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389536AbgK1VuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:50:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:42330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387768AbgK1VHh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Nov 2020 16:07:37 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78B2A221FF;
        Sat, 28 Nov 2020 21:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606597616;
        bh=0FtJipypMefHOwLe6IsxhRNduZi6omWRZL/pUaoKeoo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F5qVNoDZJGzrPYMm4cIz5OnI9e5JI1P883sMfeB7W07aeseEZJPot8YxXyhDpmg66
         bEDDicKeyjb56kcZgKwkyB9o/ZUlKJHvCNdL3EUtDhGcfQLcERBuGHNSetK6Ltd10P
         OV3R7XnhyTpZl1GRjUyhbWzYQ8aFjyKr8cYck/p4=
Date:   Sat, 28 Nov 2020 13:06:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH net-next v6 08/14] net/smc: Introduce generic netlink
 interface for diagnostic purposes
Message-ID: <20201128130655.0540f3e5@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201126203916.56071-9-kgraul@linux.ibm.com>
References: <20201126203916.56071-1-kgraul@linux.ibm.com>
        <20201126203916.56071-9-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Nov 2020 21:39:10 +0100 Karsten Graul wrote:
> +/* SMC_GENL family definition */
> +struct genl_family smc_gen_nl_family __ro_after_init = {
> +	.hdrsize = 0,
> +	.name = SMC_GENL_FAMILY_NAME,
> +	.version = SMC_GENL_FAMILY_VERSION,
> +	.maxattr = SMC_GEN_MAX,
> +	.netnsok = true,
> +	.module = THIS_MODULE,
> +	.ops = smc_gen_nl_ops,
> +	.n_ops =  ARRAY_SIZE(smc_gen_nl_ops)
> +};

Sorry, one more spin.

Now you'll let any attribute in. We try to reject any input that won't
be acted on in the kernel these days to allow the interfaces to be
extended in the future without worrying that something that was
throwing random data in the messages will suddenly start misbehaving.

You should still declare a policy just make it empty. And you can make
the policy array size 1, and set .maxattr to 1, AFAIK. These are both
pretty much* for input validation only.

* the only exception is dumping the policy to be able to tell types in
  user space automatically, but I don't think you'll care.
