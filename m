Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 509F31BAC10
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 20:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgD0SMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 14:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726213AbgD0SMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 14:12:30 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3EFAC0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 11:12:30 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7D28E15D53D2B;
        Mon, 27 Apr 2020 11:12:30 -0700 (PDT)
Date:   Mon, 27 Apr 2020 11:12:27 -0700 (PDT)
Message-Id: <20200427.111227.1036449542794050922.davem@davemloft.net>
To:     scott@scottdial.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] net: macsec: preserve ingress frame ordering
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200424225108.956252-1-scott@scottdial.com>
References: <20200424225108.956252-1-scott@scottdial.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Apr 2020 11:12:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Scott Dial <scott@scottdial.com>
Date: Fri, 24 Apr 2020 18:51:08 -0400

> While it's presumable that the pure AES-NI version of gcm(aes)
> is more performant, the hybrid solution is capable of gigabit
> speeds on modest hardware. Regardless, preserving the order
> of frames is paramount for many network protocols (e.g.,
> triggering TCP retries). Within the MACsec driver itself, the
> replay protection is tripped by the out-of-order frames, and
> can cause frames to be dropped.

It's a real shame that instead of somehow fixing the most performant
setup to be actually usable, we are just throwing our hands up in
the air and simply avoiding to use it.

I feel _really_ bad for the person trying to figure out why they
aren't getting the macsec performance they expect, scratching their
heads for hours trying to figure out why the AES-NI x86 code isn't
being used, and after days finding a commit like this.

> -	tfm = crypto_alloc_aead("gcm(aes)", 0, 0);
> +	/* Pick a sync gcm(aes) cipher to ensure order is preserved. */
> +	tfm = crypto_alloc_aead("gcm(aes)", 0, CRYPTO_ALG_ASYNC);

How does this mask argument passed to crypto_alloc_aead() work?  You
are specifying async, does this mean you're asking for async or
non-async?
