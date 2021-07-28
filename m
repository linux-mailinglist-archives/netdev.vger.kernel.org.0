Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617903D8A89
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 11:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235496AbhG1J0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 05:26:12 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:46536 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbhG1J0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 05:26:11 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 9CE3A222EA;
        Wed, 28 Jul 2021 09:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1627464368;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5viwOi0Ex8EMpcyt5fZAmdaE8zZE3JenBgOEfHjTO8U=;
        b=s2tZ7LKmgkhy+ZcYKXY0OMBdF6rgfEncaTSZK7ZE/m30LIKZxGFisayoitYrPoUKgQFilK
        JvtrvqLBc81t+lTUPqdiALN99CIl4lL5iiGoJzH4SmvIp9lTCLyWsuBMqJ5PpfanZxmV/N
        Ro/wN4dr9AdUz3PKRKyK9FUdOlBL5bs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1627464368;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5viwOi0Ex8EMpcyt5fZAmdaE8zZE3JenBgOEfHjTO8U=;
        b=XqnccbRI7Ba90MUmDKttFQTuMWonwuyX1swzv/h7m5E54hesuDgaFK/aI8UPg+OaZi/FOS
        XAEigI499ra4OLDQ==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 8903AA3B8C;
        Wed, 28 Jul 2021 09:26:08 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C207DDA8CC; Wed, 28 Jul 2021 11:23:23 +0200 (CEST)
Date:   Wed, 28 Jul 2021 11:23:23 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Kees Cook <keescook@chromium.org>, linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH 02/64] mac80211: Use flex-array for radiotap header bitmap
Message-ID: <20210728092323.GW5047@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Dan Carpenter <dan.carpenter@oracle.com>,
        Kees Cook <keescook@chromium.org>, linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-3-keescook@chromium.org>
 <20210728073556.GP1931@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728073556.GP1931@kadam>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 10:35:56AM +0300, Dan Carpenter wrote:
> @@ -372,7 +372,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
>  			ieee80211_calculate_rx_timestamp(local, status,
>  							 mpdulen, 0),
>  			pos);
> -		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_TSFT);
> +		rthdr->data.it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_TSFT);

A drive-by comment, not related to the patchset, but rather the
ieee80211 driver itself.

Shift expressions with (1 << NUMBER) can be subtly broken once the
NUMBER is 31 and the value gets silently cast to a 64bit type. It will
become 0xfffffffff80000000.

I've checked the IEEE80211_RADIOTAP_* defintions if this is even remotely
possible and yes, IEEE80211_RADIOTAP_EXT == 31. Fortunatelly it seems to
be used with used with a 32bit types (eg. _bitmap_shifter) so there are
no surprises.

The recommended practice is to always use unsigned types for shifts, so
"1U << ..." at least.
