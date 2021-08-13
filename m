Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFA23EB1CD
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 09:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239601AbhHMHma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 03:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239590AbhHMHm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 03:42:29 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FCEC061756;
        Fri, 13 Aug 2021 00:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=v5GvruCHAD5VdGVp7rPAa70pStcYZ0dgf5ANMBb+4wc=;
        t=1628840522; x=1630050122; b=ZFr3C2+x1UejITvtIoKSlKqWMYfmd05UvxUUYJmP8dCuqZf
        xyL7kJF2m31ZbzvXMxn0Qfo/LsIdqEv+uDFADyYhkZH/gq1wVfAYpfvvHz0euyfwDe4RouS03or0e
        dhM0p+QuyBPDtIGV/IMKk1eKz1XNqmGv+GvQfUkGGjKbUrsOm2gJYmA2ysm9KYtgwfby3qUVcH8sl
        Em7NK+clrwAnkRPjbj1+yEyh6lQteTdvCAFF8IgnmzxiwzICRKC0V7EKQwyQx3nhr6bgSbitEHW5S
        L0dfMV1v8YGd5+WQxoBO0iPtQJn5nzXhREzUcX2n0+AZqqvEooJKIpQ+7q6elHMA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mERoz-00A937-Sm; Fri, 13 Aug 2021 09:41:42 +0200
Message-ID: <347234b097eb93a0882ad2a3a209c2b7923ff611.camel@sipsolutions.net>
Subject: Re: [PATCH 39/64] mac80211: Use memset_after() to clear tx status
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        linux-hardening@vger.kernel.org
Date:   Fri, 13 Aug 2021 09:41:40 +0200
In-Reply-To: <202107310852.551B66EE32@keescook>
References: <20210727205855.411487-1-keescook@chromium.org>
         <20210727205855.411487-40-keescook@chromium.org>
         <202107310852.551B66EE32@keescook>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-07-31 at 08:55 -0700, Kees Cook wrote:
> 
> > @@ -278,9 +278,7 @@ static void carl9170_tx_release(struct kref *ref)
> >  	BUILD_BUG_ON(
> >  	    offsetof(struct ieee80211_tx_info, status.ack_signal) != 20);
> >  
> > 
> > -	memset(&txinfo->status.ack_signal, 0,
> > -	       sizeof(struct ieee80211_tx_info) -
> > -	       offsetof(struct ieee80211_tx_info, status.ack_signal));
> > +	memset_after(&txinfo->status, 0, rates);

FWIW, I think we should also remove the BUILD_BUG_ON() now in all the
places - that was meant to give people a hint to update if some field
ordering etc. changed, but now that it's "after rates" this is no longer
necessary.

johannes

