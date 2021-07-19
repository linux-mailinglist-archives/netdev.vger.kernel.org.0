Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5194B3CCE03
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 08:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234253AbhGSGjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 02:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233048AbhGSGjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 02:39:07 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AAC2C061762;
        Sun, 18 Jul 2021 23:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=5NrnS2Yq56znVmTxYxB3qTnbwKzTQfFAIeiV2C3dA0w=;
        t=1626676568; x=1627886168; b=Uw7PILSM8BIf+nGBbASBFPJ5QrZxRBSaFq/gCUmRH5tSo2d
        j+fhER3QwrjqIsInaQnMAma1z+TTFDJER6ssH+S06c9+rqQ4HCasjDap/seb0Px+YWxFRY9dekzek
        mw4PiTaE7yzDsDA0sR+D1lLrsvr9L10Z4L4x8TL4q9ba1DXCTynee85fNii5spVwHLpPQllWVOXgi
        2blkrcqPx5thFslvbIIDmy/SkvYrjM1LIRUT+e6M4P+BEaTvBtbnUDm66IxeH0Ydeb86e+cIfVS0Y
        JLgxQ7+PZHgYSkLMSGGjEQXfNszk2Qd3ugY5x0QRwacv7QTux6id+jj9sv1Vu7xw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1m5Msm-004FwI-Rj; Mon, 19 Jul 2021 08:36:04 +0200
Message-ID: <27d8246ef3c9755b3e6e908188ca36f7b0fab3fc.camel@sipsolutions.net>
Subject: Re: [PATCH RFC v1 3/7] rtw88: Use rtw_iterate_stas where the
 iterator reads or writes registers
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Date:   Mon, 19 Jul 2021 08:36:04 +0200
In-Reply-To: <20210717204057.67495-4-martin.blumenstingl@googlemail.com>
References: <20210717204057.67495-1-martin.blumenstingl@googlemail.com>
         <20210717204057.67495-4-martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-07-17 at 22:40 +0200, Martin Blumenstingl wrote:
> 
> --- a/drivers/net/wireless/realtek/rtw88/mac80211.c
> +++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
> @@ -721,7 +721,7 @@ static void rtw_ra_mask_info_update(struct rtw_dev *rtwdev,
>  	br_data.rtwdev = rtwdev;
>  	br_data.vif = vif;
>  	br_data.mask = mask;
> -	rtw_iterate_stas_atomic(rtwdev, rtw_ra_mask_info_update_iter, &br_data);
> +	rtw_iterate_stas(rtwdev, rtw_ra_mask_info_update_iter, &br_data);

And then you pretty much immediately break that invariant here, namely
that you're calling this within the set_bitrate_mask() method called by
mac80211.

That's not actually fundamentally broken today, but it does *severely*
restrict what we can do in mac80211 wrt. locking, and I really don't
want to keep the dozen or so locks forever, this needs simplification
because clearly we don't even know what should be under what lock.

So like I said on the other patch, I don't have a fundamental objection
to taking such a patch, but the locking mess that this gets us into is
something I'd rather not have.

Maybe just don't support set_bitrate_mask for SDIO drivers for now?

The other cases look OK, it's being called from outside contexts
(wowlan, etc.)

johannes

