Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEB89270AFC
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 07:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgISFnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 01:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgISFnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 01:43:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D22CC0613CE;
        Fri, 18 Sep 2020 22:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vvTIfOMrF/K28gn1rdDUOkl6tcD+Ap5D1LjFi+tAeZI=; b=k9oElFkU0HYYvkzZUyJXGOOjbU
        ocOfSvJsP37wPpHmhEZCalbB0gv/vJiCHLDwGtwA4QO2w3cWO52Ro+ddGyGm9ntefgEsrdg/qd0SC
        GOWq/AGYXDgxw/8x6IHFEyzl+WVJ/b3aAyYU1q1CUYPRVoF5Gy4CwenUVOaiyp8R33Jp4drppPDlU
        EWDJlTuePhwX64dsuv85e+OzAVqFCW9TWYZB6kZguBAVp7297su+p8Les9kOYLejwu5V0dWiuYmAE
        3jyTXQ6aCdztynY3thT1/smazWXHcncO+N9f8x3ftNGvGW55saqjLf1ge05nQFgdIraIxXFh+WRou
        UeRv4BQA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJVen-0001IU-UP; Sat, 19 Sep 2020 05:43:34 +0000
Date:   Sat, 19 Sep 2020 06:43:33 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] ethtool: improve compat ioctl handling
Message-ID: <20200919054333.GM30063@infradead.org>
References: <20200918120536.1464804-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918120536.1464804-1-arnd@arndb.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	if (ethtool_translate_compat()) {
> +		struct compat_ethtool_rxnfc crxnfc = {};
> +
> +		if (copy_from_user(&crxnfc, useraddr,
> +				   min(size, sizeof(crxnfc))))
> +			return -EFAULT;
> +
> +		*rxnfc = (struct ethtool_rxnfc) {
> +			.cmd		= crxnfc.cmd,
> +			.flow_type	= crxnfc.flow_type,
> +			.data		= crxnfc.data,
> +			.fs		= {
> +				.flow_type	= crxnfc.fs.flow_type,
> +				.h_u		= crxnfc.fs.h_u,
> +				.h_ext		= crxnfc.fs.h_ext,
> +				.m_u		= crxnfc.fs.m_u,
> +				.m_ext		= crxnfc.fs.m_ext,
> +				.ring_cookie	= crxnfc.fs.ring_cookie,
> +				.location	= crxnfc.fs.location,
> +			},
> +			.rule_cnt	= crxnfc.rule_cnt,
> +		};

I'd split the compat version into a self-contained noinline helper.
Same for ethtool_rxnfc_copy_to_user.

Otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
