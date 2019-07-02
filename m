Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04FB05DA14
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 03:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbfGCBAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 21:00:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45408 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727408AbfGCBAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 21:00:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DE44B13F24734;
        Tue,  2 Jul 2019 14:23:47 -0700 (PDT)
Date:   Tue, 02 Jul 2019 14:23:47 -0700 (PDT)
Message-Id: <20190702.142347.1440800997923616328.davem@davemloft.net>
To:     stephen@networkplumber.org
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: don't warn in inet diag when IPV6 is disabled
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190701152303.4031-1-stephen@networkplumber.org>
References: <20190701152303.4031-1-stephen@networkplumber.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Jul 2019 14:23:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>
Date: Mon,  1 Jul 2019 08:23:03 -0700

> @@ -19,9 +19,11 @@ raw_get_hashinfo(const struct inet_diag_req_v2 *r)
>  {
>  	if (r->sdiag_family == AF_INET) {
>  		return &raw_v4_hashinfo;
> -#if IS_ENABLED(CONFIG_IPV6)
>  	} else if (r->sdiag_family == AF_INET6) {
> +#if IS_ENABLED(CONFIG_IPV6)
>  		return &raw_v6_hashinfo;
> +#else
> +		return ERR_PTR(-EOPNOTSUPP);
>  #endif
>  	} else {
>  		pr_warn_once("Unexpected inet family %d\n",

Let's make some consistency in this area please.

The inet_diag code returns -EINVAL, and that's been that way forever.
It also doesn't print a weird warning for unexpected sdiag_family
values outside of AF_INET and AF_INET6.

That's been that way for so long that's probably the behavior to
revolve everything around.

Therefore, please just get rid of the warning message instead of
all of these other changes.

Thank you.
