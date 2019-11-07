Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B052CF30C5
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 15:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388949AbfKGODi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 09:03:38 -0500
Received: from mail.aperture-lab.de ([138.201.29.205]:38906 "EHLO
        mail.aperture-lab.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387662AbfKGODi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 09:03:38 -0500
Date:   Thu, 7 Nov 2019 15:03:31 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c0d3.blue; s=2018;
        t=1573135414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sVnu6nCQ25Lb7LRGNb26Av76cKgMfU15iK7bwIMmrkQ=;
        b=dYwqJQkwh4WV7+jIWWMyyAf4ucAUIhVJrLGYNADu4ppqY0960M1DIF1mShrpRVQARoaF1R
        ABE+moZw9r24XKdGiE4vj+gTAJN0ulxg3NZwzuMcXs4IU/k+7UN8jRxfVbP0Kij/JIUNtS
        Ao2Obm4TPa/OoVid/jAjtWsiCXjaFbgsK5q+olzKybAPsmiwtoyVw0e0+6VP0mQEaD95fK
        N97ngKZkvoJgQaWTpJ7WPvMg+v3Y1ldKNn5uP0tr1wMYFJLhgNo2SplymeWhgAz4lTRSFk
        IwxMHX9greRFCrwGjw2MJ2yOJZsp6F1bhAsjmeElLe2RO6wZetmGNJkK3LchQg==
From:   Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
To:     Ben Greear <greearb@candelatech.com>
Cc:     Linus =?utf-8?Q?L=C3=BCssing?= <ll@simonwunderlich.de>,
        ath10k@lists.infradead.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] ath10k: fix RX of frames with broken FCS in
 monitor mode
Message-ID: <20191107140149.GB19482@otheros>
References: <20191105164932.11799-1-linus.luessing@c0d3.blue>
 <927cea69-7afc-5c35-df8d-9813392e8928@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <927cea69-7afc-5c35-df8d-9813392e8928@candelatech.com>
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=c0d3.blue;
        s=2018; t=1573135414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sVnu6nCQ25Lb7LRGNb26Av76cKgMfU15iK7bwIMmrkQ=;
        b=pH7WY4TroqspfcVfiNfk4KF2KGn4YJqmi3dA4tuxptME+Hwrjl1w83PTsY8oUwJ/qR81i8
        NBNIN9LoYylB2UpMzQU0lVkuEIt0mNBOshzxuyUdbcI/yNsWmmGkpJaHH4rDK+4Chr+LjD
        6FaRkZdEfQHwqyg9WSpOcAhhnAUuTssNhHbp3zjDvIHiLnwVKcG/ZWvXsQ10fAioL1O762
        aeTzx5BMGWroW0N924bOV9bzUPItQCKdpDsvDC3TjKbLJPVJbXh2Cs5xVadw0CspiS/jHv
        YlD0ujULBQa8RMsp/1Gi2tmlfshKXhFHDBBNl6YNjDTAOie6+NF138Y+kVfM5Q==
ARC-Seal: i=1; s=2018; d=c0d3.blue; t=1573135414; a=rsa-sha256; cv=none;
        b=ojLgZKgBfl52b4RxlLVRGRhHIpo/O3YWrsNgNoHy4/Cx3XnFKTiuCZyxp0QWBaWN91QJLI
        M0ntFuUrIRXGKw6DnsF4CZJ4j9VB/vxa/xkA+2v0zdY72Fs73U1L+5OIZW9sEznBHUbj9Z
        HvlAqoA7JskhU2ou7UmkV3cDYADkKMst3/9pQsVvdDHneOi1IRD7hsHAwPdLEOi5y6Oujd
        ErDjYV6t1kEDkPRkPk0F5wkfKO9t1JjOhkiBHyAbYpypBGJe0GCSiWw+w88vcqA+U8Vzqy
        mtJYoYCCKfYiCaZFMJ64p3wnxRcumvidJHuBAD2iZtPvUIAtCrxjhHI97/hCng==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=linus.luessing@c0d3.blue smtp.mailfrom=linus.luessing@c0d3.blue
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=linus.luessing@c0d3.blue smtp.mailfrom=linus.luessing@c0d3.blue
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 05, 2019 at 09:19:20AM -0800, Ben Greear wrote:
> Thanks for adding the counter.  Since it us u32, I doubt you need the spin lock
> below?

Ok, I can remove the spin-lock.

Just for clarification though, if I recall correctly then an increment operator
is not guaranteed to work atomically. But you think it's unlikely
to race with a concurrent ++ and therefore it's fine for just a debug counter?
(and if it were racing, it'd just be a missed +1)

Or is there another mechanism that avoids concurrency in the
ath10k RX path?


> 
> --Ben
> 
> > +	if (!(ar->filter_flags & FIF_FCSFAIL) &&
> > +	    status->flag & RX_FLAG_FAILED_FCS_CRC) {
> > +		spin_lock_bh(&ar->data_lock);
> > +		ar->stats.rx_crc_err_drop++;
> > +		spin_unlock_bh(&ar->data_lock);
> > +
> > +		dev_kfree_skb_any(skb);
> > +		return;
> > +	}
> > +
> >   	ath10k_dbg(ar, ATH10K_DBG_DATA,
> >   		   "rx skb %pK len %u peer %pM %s %s sn %u %s%s%s%s%s%s %srate_idx %u vht_nss %u freq %u band %u flag 0x%x fcs-err %i mic-err %i amsdu-more %i\n",
> >   		   skb,
> > 
> 
> 
> -- 
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
> 
