Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F653D37E3
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 11:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbhGWJCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 05:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbhGWJCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 05:02:15 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77354C061575;
        Fri, 23 Jul 2021 02:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=QL92lUyzg90XLPkGnyYRK/cIIOXbUO/VZDi5JxFk4aQ=;
        t=1627033369; x=1628242969; b=UvFIjfYU8BvW5RN2N50q0aLQrge7TE0SXPuq3D72g9CsYBt
        dvjqdaACHDOWOtk3gGjEuQjRgftzY3o/NU7qzya7xJoEYY4aay1SAih7/knD/cAI5vv7fkBpxJMME
        xj8oOJHm3pRCCOrRy61gjo7ZcMPkqynQU5bg5q9QN2CpHz5sQJRzeAaU01BR9dHQEAPeesMmcT+kg
        BcwwX+ae6d2OBBB7nNHPk56/IgRlQUWUvid54j7VAB6iWSxQw0DE9OfZmj/r2D0kWe43aQXbE96lp
        e7zGptITyorX2awH77SfiO88SDBPRNP4h40/MkRm9qoJWH+1wFYAX84SkKBJx8wg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1m6rf0-000UUq-A6; Fri, 23 Jul 2021 11:42:41 +0200
Message-ID: <e549fbb09d7c618762996aca4242c2ae50f85a5c.camel@sipsolutions.net>
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
Date:   Fri, 23 Jul 2021 11:42:40 +0200
In-Reply-To: <CAD-N9QWRNyZnnDQ3XTQ_SAWNEgiMCJV+5Z69eHtRVcxYtXcM+A@mail.gmail.com>
References: <20210723050919.1910964-1-mudongliangabcd@gmail.com>
         <d2b0f847dbf6b6d1e585ef8de1d9d367f8d9fd3b.camel@sipsolutions.net>
         <CAD-N9QWDNvo_3bdB=8edyYWvEV=b-66Tx-P6_7JGgrSYshDh0A@mail.gmail.com>
         <11ba299b812212a07fe3631b7be0e8b8fd5fb569.camel@sipsolutions.net>
         <CAD-N9QWRNyZnnDQ3XTQ_SAWNEgiMCJV+5Z69eHtRVcxYtXcM+A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, 2021-07-23 at 17:30 +0800, Dongliang Mu wrote:
> if zhao in the thread is right, we don't need to add this free
> operation to wiphy_free().

Actually, no, that statement is not true.

All that zhao claimed was that the free happens correctly during
unregister (or later), and that is indeed true, since it happens from

ieee80211_unregister_hw()
 -> wiphy_unregister()
 -> wiphy_regulatory_deregister()


However, syzbot of course is also correct. Abstracting a bit and
ignoring mac80211, the problem is that here we assign it before
wiphy_register(), then wiphy_register() doesn't get called or fails, and
therefore we don't call wiphy_unregister(), only wiphy_free().

Hence the leak.

But you can also easily see from that description that it's not related
to hwsim - we should add a secondary round of cleanups in wiphy_free()
or even move the call to wiphy_regulatory_deregister() into
wiphy_free(), we need to look what else this does to see if we can move
it or not.

johannes

