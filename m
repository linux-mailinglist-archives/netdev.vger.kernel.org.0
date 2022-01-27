Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2539249D705
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 01:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234068AbiA0A4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 19:56:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234031AbiA0A4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 19:56:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8FCDC06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 16:56:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D668B81FB0
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 00:56:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1603C340E3;
        Thu, 27 Jan 2022 00:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643245009;
        bh=CmEC/+UnNh2x54A3F/e6mlJC1HH/aZudsoIJ3gGwz6s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g5ErgqEorFlemZ/Ud+8VIs3ggrzyXAHyRaLYkVX1bcWIU+LVbO0dt1mst/EOR/bSz
         IMQG94UiyKoWvxEZAyq7KSOKM3vRaVw9aEA6aEPjUMUKpJBEN7QX77PQSwRH/iG+ar
         4Ksu1rREHGQS9KvbWmvPt59w1mOXONm8XM8E2Xj+NLD2LQwVnW5zH79XPSutiC1MBv
         aXaveq0RSs8TRtaKt6uur3hph+8QvEb1fI2zwJ2odvuOWfViVGufk5vTxg3KcoT0HD
         dP6PEy/JC04VTM3zHcszPfrzleXsPaHu/LR/53FTanf1cKGBMy7dx+8pbPSmMtj58q
         xaOHhXg0r4/lw==
Date:   Wed, 26 Jan 2022 16:56:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Ray Che <xijiache@gmail.com>,
        Geoff Alexander <alexandg@cs.unm.edu>, Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH net 1/2] ipv4: tcp: send zero IPID in SYNACK messages
Message-ID: <20220126165647.237f16e3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220126200518.990670-2-eric.dumazet@gmail.com>
References: <20220126200518.990670-1-eric.dumazet@gmail.com>
        <20220126200518.990670-2-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Jan 2022 12:05:17 -0800 Eric Dumazet wrote:
> +		/* TCP packets here are SYNACK with fat IPv4/TCP options.
> +		 * Avoid using the hashed IP ident generator.
> +		 */
> +		if (sk->sk_protocol == IPPROTO_TCP)
> +			iph->id = prandom_u32();

Is it worth marking this as (__force __be32) to avoid the false
positive sparse warning?
