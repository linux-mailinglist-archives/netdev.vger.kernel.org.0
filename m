Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC033EBBF7
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 20:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbhHMSUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 14:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232796AbhHMSUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 14:20:20 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E470EC061756;
        Fri, 13 Aug 2021 11:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=rq6VfTjLJfvWeGU0hw3GUv7MRF3dGVPTx8dKGrBFFlo=;
        t=1628878793; x=1630088393; b=I5S0gRU1+S7GtJy5aucqUbOjnJXdvDVKjcmWggxsgLj+Opo
        fyzGd1Bxvte1qlq90HpPXLYOG5gI5qMJ7VnNQl1B4jan0JC4gHk2zw75449DN/FGvBQKNyN+RVPPQ
        Yv0F94jwEyHXmz9q7GfJpw7qFXxpYv1ji2N+o4yfZwwFYekhLwwD6pno1DHlKCG4v8p6HAB8055oi
        cGfDJwwYyYvzjoEsDzLEkxB5wgw5S08ft+zSZYxxSmDLzTiwJBJ/FDpq6hWKKzZhz6typDdPRVMvM
        bIqKAX1GvQmBOLCjqk//FqnBP0mvuceUUgRl16qmg0f0wnFBITH4K6XjE7wWI/mg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mEbmM-00ALlG-5g; Fri, 13 Aug 2021 20:19:38 +0200
Message-ID: <465daabf002e098f0a24cf07f72a69d7e20c7440.camel@sipsolutions.net>
Subject: Re: [PATCH 39/64] mac80211: Use memset_after() to clear tx status
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kees Cook <keescook@chromium.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        linux-hardening@vger.kernel.org
Date:   Fri, 13 Aug 2021 20:19:36 +0200
In-Reply-To: <202108130907.FD09C6B@keescook>
References: <20210727205855.411487-1-keescook@chromium.org>
         <20210727205855.411487-40-keescook@chromium.org>
         <202107310852.551B66EE32@keescook>
         <bb01e784dddf6a297025981a2a000a4d3fdaf2ba.camel@sipsolutions.net>
         <202108130907.FD09C6B@keescook>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-08-13 at 09:08 -0700, Kees Cook wrote:
> > 
> > The common helper should also clear ack_signal, but that was broken by
> > commit e3e1a0bcb3f1 ("mac80211: reduce IEEE80211_TX_MAX_RATES"), because
> > that commit changed the order of the fields and updated carl9170 and p54
> > properly but not the common helper...
> 
> It looks like p54 actually uses the rates, which is why it does this
> manually. I can't see why carl9170 does this manually, though.

mac80211 also uses the rates later again on status reporting, it just
expects the # of attempts to be filled etc. I haven't looked at
carl9170, but I would expect it to do something there and do it
correctly, even though old it's a well-written driver and uses mac80211
rate control, so this would need to be correct for decent performance.

But I guess it could be that the helper could be used because the rates
were already handed to the firmware, and the code was just copy/pasted
from p54 (the drivers were, IIRC, developed by the same folks)

johannes

