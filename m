Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E33C3EB1B3
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 09:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239566AbhHMHkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 03:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238787AbhHMHku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 03:40:50 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB43C061756;
        Fri, 13 Aug 2021 00:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=sJrRyJAk0s7nMFwbcLX8dMSTh66Xp6VqgCIIZV7nbU4=;
        t=1628840423; x=1630050023; b=Kdt+VYOuseLyRh98tKIyHWM0dDqNuy9A1CLDJZZBvyBMhRp
        MaRTVKSHX6U8PutiB796fn/6fdQtu6q4Zj8yL6pw35jdHVV1JhOcUcHFAPyN+kvCeOo/R5y62vdI+
        ppF7+qvJr4CWRzMaVGKxyapI/npTavpqjhPUFXu7eXYC9ZlbkVVKtNI3r9DNlQc0cmd0JOte/9r5z
        Z0arFTGU6S374xTr+wCs/trETSWIqQar3VoNH2wfMcVRVIxeR8bq8M7q0n3+lwLDeR2Sm1jHh0FfN
        RP/hfK0EG0fGP6eKsoe7XyhwN1YNNwa6sP4ulj8D/etp5Mld1jHk72oegvQAWNqg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mERnV-00A8zH-4r; Fri, 13 Aug 2021 09:40:09 +0200
Message-ID: <bb01e784dddf6a297025981a2a000a4d3fdaf2ba.camel@sipsolutions.net>
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
Date:   Fri, 13 Aug 2021 09:40:07 +0200
In-Reply-To: <202107310852.551B66EE32@keescook>
References: <20210727205855.411487-1-keescook@chromium.org>
         <20210727205855.411487-40-keescook@chromium.org>
         <202107310852.551B66EE32@keescook>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-07-31 at 08:55 -0700, Kees Cook wrote:
> On Tue, Jul 27, 2021 at 01:58:30PM -0700, Kees Cook wrote:
> > In preparation for FORTIFY_SOURCE performing compile-time and run-time
> > field bounds checking for memset(), avoid intentionally writing across
> > neighboring fields.
> > 
> > Use memset_after() so memset() doesn't get confused about writing
> > beyond the destination member that is intended to be the starting point
> > of zeroing through the end of the struct.
> > 
> > Note that the common helper, ieee80211_tx_info_clear_status(), does NOT
> > clear ack_signal, but the open-coded versions do. All three perform
> > checks that the ack_signal position hasn't changed, though.
> 
> Quick ping on this question: there is a mismatch between the common
> helper and the other places that do this. Is there a bug here?

Yes.

The common helper should also clear ack_signal, but that was broken by
commit e3e1a0bcb3f1 ("mac80211: reduce IEEE80211_TX_MAX_RATES"), because
that commit changed the order of the fields and updated carl9170 and p54
properly but not the common helper...

It doesn't actually matter much because ack_signal is normally filled in
afterwards, and even if it isn't, it's just for statistics.

The correct thing to do here would be to

	memset_after(&info->status, 0, rates);

johannes

