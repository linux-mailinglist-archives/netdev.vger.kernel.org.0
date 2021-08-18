Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3233EFEB1
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 10:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239974AbhHRIHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 04:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239328AbhHRIHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 04:07:38 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF55C061764;
        Wed, 18 Aug 2021 01:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=6OzbSXXafKMA7YgF8k8Tjy+aXQW8YBJ4OWUwbnu8sQw=;
        t=1629274024; x=1630483624; b=kJyjXbrF4QQPa7P0m74IZPrJWoLrDTxa4wVNaIbHD1uWT4j
        94WcxbQAV4TBftGHgR329zxhDjZNz7es6pyN/wpL5DykoZrLKDy+5V50AnCaJX+RB0rwLYWUMlzhA
        igPDdKjMIr2nyFrQ/XoBar1CpS8wdVIZOEG3ybj9NN/FCmGOfNXMtAgc+85M3I2EdA+rtCjkjk0jY
        bgOjGKzxaGuhAJAIqL2SVyK7V0LZy1FtoJm/RkCU3WpNw+IDtKAOWRcO1CbbgT0YU5ML//+xvQCsR
        zbdz7SZvj2MgHC4iyZ63vwVgx9FT/wPYMeK12sHtb41zcjTDVR5DvWPiHPKT0nZQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mGGb6-00CcdG-FE; Wed, 18 Aug 2021 10:06:52 +0200
Message-ID: <8b48dac4c40127366e91855306d24e07eb0b81d9.camel@sipsolutions.net>
Subject: Re: [PATCH v2 44/63] mac80211: Use memset_after() to clear tx status
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        dri-devel@lists.freedesktop.org, linux-staging@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Date:   Wed, 18 Aug 2021 10:06:51 +0200
In-Reply-To: <11db2cdc5316b51f3fa2f34e813a458e455c763d.camel@sipsolutions.net>
References: <20210818060533.3569517-1-keescook@chromium.org>
         <20210818060533.3569517-45-keescook@chromium.org>
         <11db2cdc5316b51f3fa2f34e813a458e455c763d.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-08-18 at 09:08 +0200, Johannes Berg wrote:
> On Tue, 2021-08-17 at 23:05 -0700, Kees Cook wrote:
> > 
> > @@ -275,12 +275,11 @@ static void carl9170_tx_release(struct kref *ref)
> >  	if (WARN_ON_ONCE(!ar))
> >  		return;
> >  
> > 
> > 
> > 
> > -	BUILD_BUG_ON(
> > -	    offsetof(struct ieee80211_tx_info, status.ack_signal) != 20);
> > -
> > -	memset(&txinfo->status.ack_signal, 0,
> > -	       sizeof(struct ieee80211_tx_info) -
> > -	       offsetof(struct ieee80211_tx_info, status.ack_signal));
> > +	/*
> > +	 * Should this call ieee80211_tx_info_clear_status() instead of clearing
> > +	 * manually? txinfo->status.rates do not seem to be used here.
> > +	 */
> 
> Since you insist, I went digging :)
> 
> It should not, carl9170_tx_fill_rateinfo() has filled the rate
> information before we get to this point.

Otherwise, looks fine, FWIW.

Are you going to apply all of these together somewhere? I (we) can't,
since memset_after() doesn't exist yet.

johannes

