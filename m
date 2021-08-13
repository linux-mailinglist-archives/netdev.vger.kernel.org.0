Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7CB93EB236
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 10:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239756AbhHMIG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 04:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239706AbhHMIGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 04:06:18 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18C7C061756;
        Fri, 13 Aug 2021 01:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=9+EPWKLBRJolwP8aFlJWDp26AmwHK39v/QqkRv5Vil8=;
        t=1628841857; x=1630051457; b=RWx/A0yybpo4f43qP3+gm2rYqp46XcDtPuQ/qCtOtmQX1sN
        IaKQfQbgauZRKQ08xv90/STdI9sNn4MnFUHmnjEgCx+qxPHmwyC9BiA/Cji5p17lFePE/IoTS+L+U
        +rPq0E2H+oMcV4gwxgZ49mqraPgiENWJtYWf2rIX8RviJxn2i4ZdCjWlFRZjguPCMp2M/7VbguDY2
        b28LPcjcGkqeJydXiT0dCR6XKhITnbW58xUjTsAZurvCFbzIJhjmhHB8qOkFZMQBazNcXy1Dxxe5N
        A09aXoGbBW8l7D6CS2EBQMuWv2SFtw/QVRB6DJFWqXdXD2qazECg+tjPmp0o9xZA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mESAk-00A9Tn-Sj; Fri, 13 Aug 2021 10:04:11 +0200
Message-ID: <a9c8ae9e05cfe2679cd8a7ef0ab20b66cf38b930.camel@sipsolutions.net>
Subject: Re: [PATCH 10/64] lib80211: Use struct_group() for memcpy() region
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kees Cook <keescook@chromium.org>, linux-hardening@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Date:   Fri, 13 Aug 2021 10:04:09 +0200
In-Reply-To: <20210727205855.411487-11-keescook@chromium.org>
References: <20210727205855.411487-1-keescook@chromium.org>
         <20210727205855.411487-11-keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-07-27 at 13:58 -0700, Kees Cook wrote:
> 
> +++ b/include/linux/ieee80211.h
> @@ -297,9 +297,11 @@ static inline u16 ieee80211_sn_sub(u16 sn1, u16 sn2)
>  struct ieee80211_hdr {
>  	__le16 frame_control;
>  	__le16 duration_id;
> -	u8 addr1[ETH_ALEN];
> -	u8 addr2[ETH_ALEN];
> -	u8 addr3[ETH_ALEN];
> +	struct_group(addrs,
> +		u8 addr1[ETH_ALEN];
> +		u8 addr2[ETH_ALEN];
> +		u8 addr3[ETH_ALEN];
> +	);
>  	__le16 seq_ctrl;
>  	u8 addr4[ETH_ALEN];
>  } __packed __aligned(2);

This file isn't really just lib80211, it's also used by everyone else
for 802.11, but I guess that's OK - after all, this doesn't really
result in any changes here.

> +++ b/net/wireless/lib80211_crypt_ccmp.c
> @@ -136,7 +136,8 @@ static int ccmp_init_iv_and_aad(const struct ieee80211_hdr *hdr,
>  	pos = (u8 *) hdr;
>  	aad[0] = pos[0] & 0x8f;
>  	aad[1] = pos[1] & 0xc7;
> -	memcpy(aad + 2, hdr->addr1, 3 * ETH_ALEN);
> +	BUILD_BUG_ON(sizeof(hdr->addrs) != 3 * ETH_ALEN);
> +	memcpy(aad + 2, &hdr->addrs, ETH_ALEN);


However, how is it you don't need the same change in net/mac80211/wpa.c?

We have three similar instances:

        /* AAD (extra authenticate-only data) / masked 802.11 header
         * FC | A1 | A2 | A3 | SC | [A4] | [QC] */
        put_unaligned_be16(len_a, &aad[0]);
        put_unaligned(mask_fc, (__le16 *)&aad[2]);
        memcpy(&aad[4], &hdr->addr1, 3 * ETH_ALEN);


and

        memcpy(&aad[4], &hdr->addr1, 3 * ETH_ALEN);

and

        memcpy(aad + 2, &hdr->addr1, 3 * ETH_ALEN);

so those should also be changed, it seems?

In which case I'd probably prefer to do this separately from the staging
drivers ...

johannes

