Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19B724CB725
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 07:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbiCCGpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 01:45:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiCCGpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 01:45:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403D2CF
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 22:44:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9254B823F1
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 06:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94C1C004E1;
        Thu,  3 Mar 2022 06:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646289867;
        bh=IPIWL93CitFupKb2+rVPgiJQKWJW1pzmhFZdb4kZqEE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hrvUiX3MVlYRM/R5Vkd587cTOtgZXtV37xULw5OgvHimGSMt30l/W8lRWJKRG0ACf
         5/hCw5uhXDZBlw9u1NRuCjt22A6KR6Bk0D/s/iLBlYtMQgEukdZsYLZjd5kLh7VvpL
         PxlYb0v/MStoHazJse3SztvB93PhkUZVUtBm1yB7SOjEhSfDqUTvVpzN17nAYrJ2b1
         +C56JoQD4WHT/V7lQftfpIVyDN9U/g23YHAlKXIBdWF1x6L9Sd6raL+Fo4ME5SXRa0
         ufPedb2T+dSiwRTGNvi0NMp7g+gp3Yhbsi65k51sbaaVKsZmMEVJlZgBBjhMfMySur
         3gwXtcGgRkOpg==
Date:   Wed, 2 Mar 2022 22:44:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        Paul Blakey <paulb@nvidia.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        zhang kai <zhangkaiheb@126.com>,
        Juhee Kang <claudiajkang@gmail.com>,
        Andreas Oetken <ennoerlangen@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org,
        Anthony Harivel <anthony.harivel@linutronix.de>
Subject: Re: [PATCH net-next v1] flow_dissector: Add support for HSR
Message-ID: <20220302224425.410e1f15@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220228195856.88187-1-kurt@linutronix.de>
References: <20220228195856.88187-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Feb 2022 20:58:56 +0100 Kurt Kanzenbach wrote:
> Network drivers such as igb or igc call eth_get_headlen() to determine the
> header length for their to be constructed skbs in receive path.
> 
> When running HSR on top of these drivers, it results in triggering BUG_ON() in
> skb_pull(). The reason is the skb headlen is not sufficient for HSR to work
> correctly. skb_pull() notices that.

Should that also be fixed? BUG_ON() seems pretty drastic.

> For instance, eth_get_headlen() returns 14 bytes for TCP traffic over HSR which
> is not correct. The problem is, the flow dissection code does not take HSR into
> account. Therefore, add support for it.
