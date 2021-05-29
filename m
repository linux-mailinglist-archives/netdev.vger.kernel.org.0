Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7933949DD
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 03:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhE2Bno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 21:43:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229559AbhE2Bno (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 21:43:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5095D611BD;
        Sat, 29 May 2021 01:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622252528;
        bh=y7LUuJftdiQz8M2wOXJ1RV2ynfT0a07wWVlsquq28DA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ijHnhDi1eUm6j4mBS2bCzjhVed24k6/m29vQIN7GSViRuvnsKJ2oINY414i3OQUhu
         0oB/Rf0pf6MXHj/vaXaWrsqrWIuTRT3HbA7ocDTcnV7UGti6TZaAUxGWNmJ2FUhsMM
         9rnVO0ectBAx2xsG9+S5pPs1YyeKfXXwyDPZ44x3oaPPH4sRhZOOA1CF0tmxcPw3xC
         EoH+OuPhD5N5CnC0++9mwcFmfU0QHoGV1z3jItpYbr6ebDdNY0LMcxLvjZlNkwNLZb
         O0JCl5ZontgELwj470s0zSV4+HH3WLAZWQhqxKnh1DJU+OGAte8FbaDT6wSwvgWXds
         CatoJuvmRoZaA==
Date:   Fri, 28 May 2021 18:42:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, gospo@broadcom.com,
        richardcochran@gmail.com, pavan.chebbi@broadcom.com,
        edwin.peer@broadcom.com
Subject: Re: [PATCH net-next 3/7] bnxt_en: Add PTP clock APIs, ioctls, and
 ethtool methods.
Message-ID: <20210528184207.321d56df@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1622249601-7106-4-git-send-email-michael.chan@broadcom.com>
References: <1622249601-7106-1-git-send-email-michael.chan@broadcom.com>
        <1622249601-7106-4-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 May 2021 20:53:17 -0400 Michael Chan wrote:
> +int bnxt_ptp_init(struct bnxt *bp)

This function never fails.

> +	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
> +
> +	if (!ptp)
> +		return 0;
> +
> +	atomic_set(&ptp->tx_avail, BNXT_MAX_TX_TS);
> +
> +	memset(&ptp->cc, 0, sizeof(ptp->cc));
> +	ptp->cc.read = bnxt_cc_read;
> +	ptp->cc.mask = CYCLECOUNTER_MASK(64);
> +	ptp->cc.shift = 0;
> +	ptp->cc.mult = 1;
> +
> +	timecounter_init(&ptp->tc, &ptp->cc, ktime_to_ns(ktime_get_real()));
> +
> +	ptp->ptp_info = bnxt_ptp_caps;
> +	ptp->ptp_clock = ptp_clock_register(&ptp->ptp_info, &bp->pdev->dev);
> +	if (IS_ERR(ptp->ptp_clock))
> +		ptp->ptp_clock = NULL;

Why not propagate the error? I thought only NULL should be silently
ignored? I could be confused about the rules, tho :)

> +	return 0;
