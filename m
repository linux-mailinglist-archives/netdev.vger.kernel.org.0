Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1D7471179
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 05:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345848AbhLKEgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 23:36:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244482AbhLKEgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 23:36:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15999C061714
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 20:33:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BB07B829E0
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 04:32:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2225C004DD;
        Sat, 11 Dec 2021 04:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639197178;
        bh=A9Yb1WGF9UMo7GBTb/ieuYXq7SxyI9+Qt7nr8eqz3us=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UCLHnfQjCybWye1b+b+Z0BriADrbkXLSsCFWWDMbPHEXhAaB0mURPul/vz5QiFXLm
         CA+WNosUwI91jAIhTmZ733GYLTnXMg5TadTQrMYg1LWtXBt8niiB3bq/cRx4Ia3vi8
         +S+B0FVoCLcA3ZcR9ThpL7klBWlmp3rNLzcs1OznDjGQbgWTqogiTlvuyL+5FYsNvA
         MBSj8SCAi1LWMtL5DleNFf73/4HH92MKXouv75J2czmEN9edM/kdBRI3B9DzYgUu/S
         78B7mcbyW71cyrzaxUu9HfUlkevKwWoWYLjoeXFf1EVxV23VtwoVlKYACX59BAWdQQ
         b9+ZoNhduN7Fw==
Date:   Fri, 10 Dec 2021 20:32:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next] net: dev: Always serialize on Qdisc::busylock
 in __dev_xmit_skb() on PREEMPT_RT.
Message-ID: <20211210203256.09eec931@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YbN1OL0I1ja4Fwkb@linutronix.de>
References: <YbN1OL0I1ja4Fwkb@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Dec 2021 16:41:44 +0100 Sebastian Andrzej Siewior wrote:
> -	contended = qdisc_is_running(q);
> +	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
> +		contended = qdisc_is_running(q);
> +	else
> +		contended = true;

Why not:

	contended = qdisc_is_running(q) || IS_ENABLED(CONFIG_PREEMPT_RT);
