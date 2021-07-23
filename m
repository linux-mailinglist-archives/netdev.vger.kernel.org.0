Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E18723D378E
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 11:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234256AbhGWIhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 04:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231994AbhGWIht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 04:37:49 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9FDC061575;
        Fri, 23 Jul 2021 02:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=K0D57hY2oduItIBhxD08gu3o/OffxO5BlZSmT2p5cZc=;
        t=1627031903; x=1628241503; b=tZIS8ZhKdrx0Zip5fcU06KVeEFWdoYsQBzFDAG0rzUMf7pg
        R9B8ufPPVyh9+7iyi2tRZzOHSO5+0aQOUD4qCJ7XDLXn/+zSBolHiOdSxhbhWPCPpIrD0GRvk78Cr
        ktRpbW0ml+2fVf6PjewzDEuA/6BZbi1Gi4Zwrhb3meFmWSO48jw6U90py+W8xdo1Gr8yJCBwozSGQ
        7n8JytqDclH0Z4Jyq/oQ2wYqn45ysE6ZOuXmQX4uurUt2HCuCUigFwmMoKca7jTBMumB9f1bKuMJN
        XFvo4eyyTbD0DMoptsdwTSfhLKaW6ovSPiqgbmaGnWuaeoTBaHU38nJrBt1McdKA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1m6rHI-000TqY-HV; Fri, 23 Jul 2021 11:18:11 +0200
Message-ID: <11ba299b812212a07fe3631b7be0e8b8fd5fb569.camel@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: free the object allocated in
 wiphy_apply_custom_regulatory
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        Ilan Peer <ilan.peer@intel.com>,
        syzbot+1638e7c770eef6b6c0d0@syzkaller.appspotmail.com,
        linux-wireless@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Date:   Fri, 23 Jul 2021 11:18:10 +0200
In-Reply-To: <CAD-N9QWDNvo_3bdB=8edyYWvEV=b-66Tx-P6_7JGgrSYshDh0A@mail.gmail.com>
References: <20210723050919.1910964-1-mudongliangabcd@gmail.com>
         <d2b0f847dbf6b6d1e585ef8de1d9d367f8d9fd3b.camel@sipsolutions.net>
         <CAD-N9QWDNvo_3bdB=8edyYWvEV=b-66Tx-P6_7JGgrSYshDh0A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-07-23 at 17:13 +0800, Dongliang Mu wrote:
> On Fri, Jul 23, 2021 at 4:37 PM Johannes Berg <johannes@sipsolutions.net> wrote:
> > 
> > On Fri, 2021-07-23 at 13:09 +0800, Dongliang Mu wrote:
> > > The commit beee24695157 ("cfg80211: Save the regulatory domain when
> > > setting custom regulatory") forgets to free the newly allocated regd
> > > object.
> > 
> > Not really? It's not forgetting it, it just saves it?
> 
> Yes, it saves the regd object in the function wiphy_apply_custom_regulatory.

Right.

> But its parent function - mac80211_hwsim_new_radio forgets to free
> this object when the ieee80211_register_hw fails.

But why is this specific to mac80211-hwsim?

Any other code calling wiphy_apply_custom_regulatory() and then failing
the subsequent wiphy_register() or otherwise calling wiphy_free() will
run into the same situation.

So why wouldn't we free this in wiphy_free(), if it exists?

johannes

