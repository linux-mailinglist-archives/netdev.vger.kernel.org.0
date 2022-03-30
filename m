Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB2804EC58C
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 15:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345904AbiC3NZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 09:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345896AbiC3NZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 09:25:00 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C82F112616;
        Wed, 30 Mar 2022 06:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=3r7vBX0LriRKdIQzmN7YVXyZS3866KYwIxb7pHXFPXE=;
        t=1648646593; x=1649856193; b=QgNwkqmK8xzVDDhWqOvhgFiWz8LKnlceg0gGbIHT92J2evT
        Itx/rXW0rskJS/l/4yZsRw6+JegfIivDKc1l8x8FFuX089kbxdCR7ZkViF59onBWtVCrQnPM0o2DU
        N2f2MauI6v5g9I/WVhNFhF4eXfh27VfSN5GmWaZ+dT1SZEbxOeMexV225uwfJaM9N4my4HLh6qo/8
        g8Sj9GvegJSAeUcW9Zeo59QoX+X6WA/H22pLeAsQb8H16iPhj0O4LNg7EJQCXxda5tOsvaFBsZFKM
        JgmigR/W5GIzUncvy309gYpbdshEPx+/3csDopt7xcC6fJjMc/vBqf5yYlpjBlbw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nZYHz-002SJl-Ac;
        Wed, 30 Mar 2022 15:23:07 +0200
Message-ID: <892635fbacdc171baba2cba1b501f30b6a4faeca.camel@sipsolutions.net>
Subject: Re: UBSAN: invalid-load in net/mac80211/status.c:1164:21
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Bagas Sanjaya <bagasdotme@gmail.com>,
        'Linux Kernel' <linux-kernel@vger.kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Kurt Cancemi <kurt@x64architecture.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Date:   Wed, 30 Mar 2022 15:23:06 +0200
In-Reply-To: <395d9e22-8b28-087a-5c5d-61a43db527ac@gmail.com>
References: <395d9e22-8b28-087a-5c5d-61a43db527ac@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-03-30 at 18:49 +0700, Bagas Sanjaya wrote:
> 
> [ 1152.928312] UBSAN: invalid-load in net/mac80211/status.c:1164:21
> [ 1152.928318] load of value 255 is not a valid value for type '_Bool'


That's loading status->is_valid_ack_signal, it seems.

Note how that's in a union, shadowed by the 0x00ff0000'00000000 byte of
the control.vif pointer (if I'm counting bytes correctly). That's kind
of expected to be 0xff.

> [ 1152.928323] CPU: 1 PID: 857 Comm: rs:main Q:Reg Not tainted 5.17.1-kernelorg-stable-generic #1
> [ 1152.928329] Hardware name: Acer Aspire E5-571/EA50_HB   , BIOS V1.04 05/06/2014
> [ 1152.928331] Call Trace:
> [ 1152.928334]  <TASK>
> [ 1152.928338]  dump_stack_lvl+0x4c/0x63
> [ 1152.928350]  dump_stack+0x10/0x12
> [ 1152.928354]  ubsan_epilogue+0x9/0x45
> [ 1152.928359]  __ubsan_handle_load_invalid_value.cold+0x44/0x49
> [ 1152.928365]  ieee80211_tx_status_ext.cold+0xa3/0xb8 [mac80211]
> [ 1152.928467]  ieee80211_tx_status+0x7d/0xa0 [mac80211]
> [ 1152.928535]  ath_txq_unlock_complete+0x15c/0x170 [ath9k]
> [ 1152.928553]  ath_tx_edma_tasklet+0xe5/0x4c0 [ath9k]
> [ 1152.928567]  ath9k_tasklet+0x14e/0x280 [ath9k]

Which sort of means that ath9k isn't setting up the status area
correctly?

> The bisection process, starting from v5.17 (the first tag with the warning),
> found first 'oops' commit at 837d9e49402eaf (net: phy: marvell: Fix invalid
> comparison in the resume and suspend functions, 2022-03-12). However, since
> the commit didn't touch net/mac80211/status.c, it wasn't the root cause
> commit.

Well you'd look for something in ath9k, I guess. But you didn't limit
the bisect, so not sure why it went off into the weeds. Maybe you got
one of them wrong.

> The latest commit that touch the file in question is commit
> ea5907db2a9ccf (mac80211: fix struct ieee80211_tx_info size, 2022-02-02).

That's after 5.17 though, and it replaced the bool by just a flag.


Seems to me ath9k should use something like
ieee80211_tx_info_clear_status() or do the memset by itself? This bug
would now not be reported, but it might report the flag erroneously.

johannes
