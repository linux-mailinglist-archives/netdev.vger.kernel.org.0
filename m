Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCFE488C7F
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 22:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbiAIVQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 16:16:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231980AbiAIVQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 16:16:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B20C06173F
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 13:16:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1073B80E37
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 21:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E423C36AE3;
        Sun,  9 Jan 2022 21:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641762981;
        bh=2j4rj7riGgcvkkGY1Q8v9z1ZwTypDT77aGYr/844Y0w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gI1LoLIVlHlsFlC/0+SyuoEjhE1kD6oUbXJ3yLYD0G6pyoXTxdk1Kw1GY61j7x9Ze
         albPKom2MCfJog753bpTZLygRh42kohltf+q16gzolhVlrtuusdoLeOCUtSRsShHNr
         8sRcAcrBlrnQKThXfYPoRlNj7+nLySlPXlY+VgCU4VJ6i1fpjqW9WqDziFdR5PG5Hq
         5O6cuOKJh/3pwlw2B/5jv4d17NQn3gtc5ZX6KcVSruTjXjorKzEETzCYZeQJ4AUJBi
         EbjRHjmNEIujBOX9aHwuHz3jbJe18E8rAFg1C0mSQHluEkJlSczGbQSpWEDFSrBPxI
         Cp3I+G9/KqqXg==
Date:   Sun, 9 Jan 2022 13:16:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gal Pressman <gal@nvidia.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [RFC PATCH] net/tls: Fix skb memory leak when running kTLS
 traffic
Message-ID: <20220109131620.66901e7a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <e632a338-e4f1-cc27-7c18-b3642a27b57b@nvidia.com>
References: <20220102081253.9123-1-gal@nvidia.com>
        <20220107105106.680cd28f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iJqgJjpFEaYPLuVAAzwwC_y3O6se2pChj40=zTAyWN=6w@mail.gmail.com>
        <20220107184436.758e15c4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <e632a338-e4f1-cc27-7c18-b3642a27b57b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 9 Jan 2022 13:49:42 +0200 Gal Pressman wrote:
> So you want one patch that adds a sk_defer_free_flush() call in
> tls_sw_splice_read(), and a second one that adds the WARN_ON_ONCE to
> sk_free()?

Two separate patches is probably the best way to go.
