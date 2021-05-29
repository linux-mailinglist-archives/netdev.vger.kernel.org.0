Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D4F3949DB
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 03:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbhE2Bkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 21:40:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229541AbhE2Bkp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 21:40:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7D26613F0;
        Sat, 29 May 2021 01:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622252350;
        bh=byi1UQsPeI9z5N3RC5Ga88WMEtV9nkYSNMII/e16zOU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hXbv/M4oxVE8W+sQCnaJqqoKMafuo4sFCv1lyt8HjyPV3XhIRqIl8JAuQYkeYNR3G
         t8XxYU7jfZAGqw456wqAQgC/YogaQYqFJKqsgcgRZaETENZXIK+n2UuYMLTIJY00kD
         uSHUumH3Ny3rMxLV1zBd7E3XKxRazuDc8iuvCYjo5JRW7s8ROk4y8xQoFyBYTSmxYG
         indSY5xr3H4SEyqTa8rB2SH1N8xRVr5ulEQitRFWOwm4P3kQZXZkba+isirbRcAYk3
         xN2TYE0IpgVzhF2U4LRcbQX1ppMRW8LeHh3almouUBJNOtt8qUszby8xUVfxHJ0uAz
         1GpJoS+IfhfGg==
Date:   Fri, 28 May 2021 18:39:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, gospo@broadcom.com,
        richardcochran@gmail.com, pavan.chebbi@broadcom.com,
        edwin.peer@broadcom.com
Subject: Re: [PATCH net-next 5/7] bnxt_en: Get the RX packet timestamp.
Message-ID: <20210528183908.3c84bff4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1622249601-7106-6-git-send-email-michael.chan@broadcom.com>
References: <1622249601-7106-1-git-send-email-michael.chan@broadcom.com>
        <1622249601-7106-6-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 May 2021 20:53:19 -0400 Michael Chan wrote:
> +	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
> +	u64 time;
> +
> +	if (!ptp)
> +		return -ENODEV;
> +
> +	time = READ_ONCE(ptp->old_time);

READ_ONCE() on a u64? That's not gonna prevent tearing the read on 32
bit architectures, right?

> +	*ts = (time & BNXT_HI_TIMER_MASK) | pkt_ts;
> +	if (pkt_ts < (time & BNXT_LO_TIMER_MASK))
> +		*ts += BNXT_LO_TIMER_MASK + 1;

The stamp is from the MAC, I hope, or otherwise packet which could have
been sitting on the ring for some approximation of eternity. You can
easily see a packet stamp older than the value stashed in ptp->old_time
if you run soon after the refresh.
