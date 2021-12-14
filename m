Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5E14749E7
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 18:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236678AbhLNRnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 12:43:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233430AbhLNRnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 12:43:49 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF3FC061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 09:43:48 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id m12so5084526ild.0
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 09:43:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=egauge.net; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :organization:user-agent:mime-version:content-transfer-encoding;
        bh=6xxVWvKA+UXRrE4WdRTVMYnDU2WqlCY05bx0BgLV8+s=;
        b=sKT9O2PtSmRvNUrhSXmZMaOhZ0YDCUWb+0KnNelRY49ur1d3An+xqzvYIiQOkVG+ak
         9cpnu5WWWyFXaF2nym9fPKiS256xJuPzh47py/i6uuG4e7YCdI40NSK5MW5ZOy08LV1a
         RudI8vo4XBC+2suNb5I3ozt1OwyJs9hwnlCpz+DV5E4K6QqY057Z2zl/ZYvWkQVUOXHr
         vDBUz9TJp3tJPXOJ1KF1oFOCA4HFqwb7vGthlzqfw9Qp0tNoaBDPfp4dVXgfiXcWlZG0
         hQV0CTxTBwROQzQbIiLwsvwv5FZnIxzPmPGw5h5NGKnkyLHIIndibTC+J09GwGqWOLOV
         R8Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=6xxVWvKA+UXRrE4WdRTVMYnDU2WqlCY05bx0BgLV8+s=;
        b=V2SLfejc4wbDtZUi6xvWbwmXMN1gkqfG46JUZSBQvfkArx0YccFusprOZ8plpZpNmN
         a4gQp3y00iX5W+qitxRhN5pkGpdaRiUAF7T3WJ0B6SJke/QFhsS17FhzkdJKj1Kv4NXF
         r0CwzRHf08PZwdY6ZpbIKpiZaCa0RRK1QyLICFuSVzbZ4TfYjb8k1J3lr0RVNiuszh9G
         fV7PVGm8qYqXoYr+kx3cNGx1vrav9UoP6nYtsDpbGCL54J8Twng+hRG0jJcJa6bxptMS
         W2/T78BjSOku/svVQS1DAQBzBmz35PV3VWATeaTjvMd2ATOL5f/VmddEf87ibFA82//o
         mIAQ==
X-Gm-Message-State: AOAM532NhPhuvt962PcQCNkqmLwCaGrygA+Fyi4m+l53w/YLD9XgiK3A
        PqEx5ckvxvuuA6pt+HegkTh/KXS42cEdVxY=
X-Google-Smtp-Source: ABdhPJzvdRIe9ydq70hDI/4Fwv9iPMnB4GP1N0PuDzX5NaJARKSk7Uo+6krHOIXK5AE0p2ojWYr3rA==
X-Received: by 2002:a05:6e02:16cd:: with SMTP id 13mr4520885ilx.255.1639503828272;
        Tue, 14 Dec 2021 09:43:48 -0800 (PST)
Received: from ?IPv6:2601:281:8300:4e0:2ba9:697d:eeec:13b? ([2601:281:8300:4e0:2ba9:697d:eeec:13b])
        by smtp.gmail.com with ESMTPSA id d16sm218104ila.51.2021.12.14.09.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 09:43:47 -0800 (PST)
Message-ID: <57d8cdfe5c22bf3df2727a18a6096026c59729da.camel@egauge.net>
Subject: Re: RFC: wilc1000: refactor TX path to use sk_buff queue
From:   David Mosberger-Tang <davidm@egauge.net>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Ajay Singh <ajay.kathat@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Tue, 14 Dec 2021 10:43:35 -0700
In-Reply-To: <8735mvhyvk.fsf@codeaurora.org>
References: <e3502ecffe0c4c01b263ada8deed814d5135c24c.camel@egauge.net>
         <8735mvhyvk.fsf@codeaurora.org>
Organization: eGauge Systems LLC
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-12-14 at 19:36 +0200, Kalle Valo wrote:
> David Mosberger-Tang <davidm@egauge.net> writes:
> 
> > I'd like to propose to restructure the wilc1000 TX path to take
> > advantage of the existing sk_buff queuing and buffer operations rather
> > than using a driver-specific solution.  To me, the resulting code looks
> > simpler and the diffstat shows a fair amount of code-reduction:
> > 
> >  cfg80211.c |   35 ----
> >  mon.c      |   36 ----
> >  netdev.c   |   28 ---
> >  netdev.h   |   10 -
> >  wlan.c     |  499 ++++++++++++++++++++++++++-----------------------------------
> >  wlan.h     |   51 ++----
> >  6 files changed, 255 insertions(+), 404 deletions(-)
> 
> Looks like a very good cleanup.

Thanks!

> > +static void wilc_wlan_txq_drop_net_pkt(struct sk_buff *skb)
> > +{
> > +	struct wilc_vif *vif = netdev_priv(skb->dev);
> > +	struct wilc *wilc = vif->wilc;
> > +	struct wilc_skb_tx_cb *tx_cb = WILC_SKB_TX_CB(skb);
> > +
> > +	if ((u8)tx_cb->q_num >= NQUEUES) {
> > +		netdev_err(vif->ndev, "Invalid AC queue number %d",
> > +			   tx_cb->q_num);
> > +		return;
> > +	}
> 
> But why the cast here? Casting should be avoided as much as possible,
> they just create so many problems if used badly.

tx_cb->q_num is declared as:

       enum ip_pkt_priority q_num;     /* AC queue number */

so the cast to (u8) is to protect against negative values (which, of
course, should never really be the case).  Would you rather have the
code check explicitly for negative numbers, i.e.:

    if (tx_cb->q_num < 0 || tx_cb->q_num >= NQUEUES)

?

  --david


