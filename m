Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E373D5967C6
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 05:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiHQDeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 23:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbiHQDeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 23:34:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3726402EB
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 20:34:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 738D3B81ACC
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 03:34:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998C3C433D6;
        Wed, 17 Aug 2022 03:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660707259;
        bh=UhsR0mzXQ32m9D40YuMydHIgxBUcK2uI+Es6E5ap5co=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aEUYtA0W5hpKRoFF5oIGgCWi6wkfUBGZrDf3ZP0uVUHMRCyeMNZJ4Xvxs18tRUF2C
         8qX90txWmAht3fO23pyXdAukTiawXlFf8bpcttWdR6TRYMSIe3+13+m2CbmWsd47HF
         tNqa/8AUsRJHBusokouxW8dof1z+tJM3P1awUXpxOptHGbDx9ER1WFBRevW7Gwhs8c
         qf9u6IjGZFTLWPLJiDM7dUSMKEBW3tXXJYhWMtd6UTfs4dim++7WE2uPamFWcuskpW
         zvrZylPj0yrPGmxuelN5UrP86QK0r9fUDRl/y1EFDXou0ZKlKrjPL+XHgJtsyNrny6
         ohWKiKmIlshDw==
Date:   Tue, 16 Aug 2022 20:34:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>
Subject: Re: [RFC PATCH net-next 0/7] 802.1Q Frame Preemption and 802.3 MAC
 Merge support via ethtool
Message-ID: <20220816203417.45f95215@kernel.org>
In-Reply-To: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
References: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Aug 2022 01:29:13 +0300 Vladimir Oltean wrote:
>   What also exists but is not exported here are PAUSE stats for the
>   pMAC. Since those are also protocol-specific stats, I'm not sure how
>   to mix the 2 (MAC Merge layer + PAUSE). Maybe just extend
>   ETHTOOL_A_PAUSE_STAT_TX_FRAMES and ETHTOOL_A_PAUSE_STAT_RX_FRAMES with
>   the pMAC variants?

I have a couple of general questions. The mm and fp are related but fp
can be implemented without mm or they must always come together? (I'd
still split patch 2 for ease of review, tho.)

When we have separate set of stats for pMAC the normal stats are sum of
all traffic, right? So normal - pMAC == eMAC, everything that's not
preemptible is express?

Did you consider adding an attribute for switching between MAC and pMAC
for stats rather than duplicating things?
