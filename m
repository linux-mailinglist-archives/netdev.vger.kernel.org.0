Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87CFE54CDAF
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 18:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348588AbiFOQAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 12:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239277AbiFOQAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 12:00:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F581BF0
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 09:00:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CFEAB8200E
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 16:00:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E6CC34115;
        Wed, 15 Jun 2022 16:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655308846;
        bh=NJeXr98im4n1duHlWN6+djqiJdK70vDo23Q1BuH++GU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lhX9XIxuLNUE4ihJ+WNFvXJMylSuJU5wXJRKpVLKJHH/hp1D3H3x1U3ysSZ4l++g+
         yd56lGMYY0lG4eZ51jO2oHqluOPn3912grPotL4RdCdVcw8kSF72ZTmmiH55jkRsot
         IdJxO+QLvazSpUHq0eUxxZVLcNJSBmOAic/RFPAsdNCUslK/32CN0cpH+LZr6rKCUZ
         UeTXfZMUtkWPJYwfZRT8tvPcopz9pMKZqWviH8kcIMaUBzV0qLdg+qUd9sIBjrfopR
         TvHed4JMX5zOxp7z9FTmT0XdFl8+cZA4mSszj975lIIJnucVSUCCt83MwOjMpDGcv0
         LYxvEAbribmsw==
Date:   Wed, 15 Jun 2022 09:00:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ismael Luceno <iluceno@suse.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Netlink NLM_F_DUMP_INTR flag lost
Message-ID: <20220615090044.54229e73@kernel.org>
In-Reply-To: <20220615171113.7d93af3e@pirotess>
References: <20220615171113.7d93af3e@pirotess>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CC: netdev ML

On Wed, 15 Jun 2022 17:11:13 +0200 Ismael Luceno wrote:
> It seems a RTM_GETADDR request with AF_UNSPEC has a corner case where
> the NLM_F_DUMP_INTR flag is lost.
> 
> After a change in an address table, if a packet has been fully filled
> just previous, and if the end of the table is found at the same time,
> then the next packet should be flagged, which works fine when it's
> NLMSG_DONE, but gets clobbered when another table is to be dumped next.

Could you describe how it gets clobbered? You mean that prev_seq gets
updated somewhere without setting the flag or something overwrites
nlmsg_flags? Or we set _INTR on an empty skb which never ends up
getting sent? Or..

> A customer noticed the issue using kubernetes, when a large
> number of short-lived containers would push the system constantly
> towards this corner case.
> 
> I'm entertaining the following options:
> 
> 1) introduce a new packet type just to convey flags in cases like this.
> 2) preserve the flag and apply it to the NLMSG_DONE packet.
> 3) flag the first packet of the following table.
> 
> I don't like option 2 and 3 because we can't tell which table is
> affected, which I'm guessing programs might be relying on.
> 
> Option 1 adds a little bit of overhead, but enables us to tell which
> table is affected, and can be ignored by existing software that doesn't
> understand it, so IMHO it's the least disruptive option.
> 
> I want to have a little discussion before introducing a patch, since
> option 1 might have other implications I'm not aware of...
