Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC3864749C5
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 18:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233988AbhLNRix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 12:38:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43980 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236568AbhLNRgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 12:36:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7E55B81B9C;
        Tue, 14 Dec 2021 17:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362FFC34600;
        Tue, 14 Dec 2021 17:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639503413;
        bh=Mgw42nqNVH2UDsMBcL0QqjHMIZftvJst+KcMB+YFVpE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=VIQ3I1n1tha4LzAb/tfWCJJrcOUJip1scVHGVQm3Zqpl/kO/SuiJqjLOx40bx9RAy
         WvBSmIkR/u/7uy3jr2UtHGRblCSCBbRTMp+dKgn3h/0WzJ+NemKjW6ofPcWX7y+oqp
         mGnTL2qaHK1GzFe7N2oPkxgD8nCrS9qjVBvmwtLorLKFBsDHHGKQn4wde2MHmUYqHy
         agWQSjZNYO2q4G2uRGWo9EPavk6obeJlGIRyG6Fy6BlBAoeFuWJd/NnnI6II/cJeHP
         gChRJHfM29VsVtIS+W4+UNN2xWYgGhEuYlTQW8kRkmUeuOEZ8BjVf3YcH+fmg/5CLz
         vQfYGDYKIIt/Q==
From:   Kalle Valo <kvalo@kernel.org>
To:     David Mosberger-Tang <davidm@egauge.net>
Cc:     Ajay Singh <ajay.kathat@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: RFC: wilc1000: refactor TX path to use sk_buff queue
References: <e3502ecffe0c4c01b263ada8deed814d5135c24c.camel@egauge.net>
Date:   Tue, 14 Dec 2021 19:36:47 +0200
In-Reply-To: <e3502ecffe0c4c01b263ada8deed814d5135c24c.camel@egauge.net>
        (David Mosberger-Tang's message of "Sat, 11 Dec 2021 13:32:09 -0700")
Message-ID: <8735mvhyvk.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Mosberger-Tang <davidm@egauge.net> writes:

> I'd like to propose to restructure the wilc1000 TX path to take
> advantage of the existing sk_buff queuing and buffer operations rather
> than using a driver-specific solution.  To me, the resulting code looks
> simpler and the diffstat shows a fair amount of code-reduction:
>
>  cfg80211.c |   35 ----
>  mon.c      |   36 ----
>  netdev.c   |   28 ---
>  netdev.h   |   10 -
>  wlan.c     |  499 ++++++++++++++++++++++++++-----------------------------------
>  wlan.h     |   51 ++----
>  6 files changed, 255 insertions(+), 404 deletions(-)

Looks like a very good cleanup.

> +static void wilc_wlan_txq_drop_net_pkt(struct sk_buff *skb)
> +{
> +	struct wilc_vif *vif = netdev_priv(skb->dev);
> +	struct wilc *wilc = vif->wilc;
> +	struct wilc_skb_tx_cb *tx_cb = WILC_SKB_TX_CB(skb);
> +
> +	if ((u8)tx_cb->q_num >= NQUEUES) {
> +		netdev_err(vif->ndev, "Invalid AC queue number %d",
> +			   tx_cb->q_num);
> +		return;
> +	}

But why the cast here? Casting should be avoided as much as possible,
they just create so many problems if used badly.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
