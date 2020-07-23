Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D96C22B59F
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 20:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgGWS0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 14:26:30 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:60145 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726349AbgGWS00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 14:26:26 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1595528785; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: Date: Subject: In-Reply-To: References: Cc:
 To: From: Sender; bh=n1W6ocoKrcYfitGwsuovGrOv9EGxLgCgVMXxSlmwsjY=; b=ebarM5uIZMa6As2qwhzYoSGcGUfQgRO2IIOAaP55JZTvd3ZRbNgQ07xbzJ1j2DCRt583p8Vw
 p2a3vVX7xBSq1TJfv22kc0jZ3/N5UhshYpnlmBf1bBeYR+1BvaXEOjXcxyelaaMB8Wjo8oE0
 DEFpR8MkQkKSVeiLbqY5Vx/na38=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n10.prod.us-west-2.postgun.com with SMTP id
 5f19d6515b75bcda60cc9289 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 23 Jul 2020 18:26:25
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 12821C43395; Thu, 23 Jul 2020 18:26:25 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from Pillair (unknown [183.83.71.149])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: pillair)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 42796C433C9;
        Thu, 23 Jul 2020 18:26:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 42796C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   "Rakesh Pillai" <pillair@codeaurora.org>
To:     "'Johannes Berg'" <johannes@sipsolutions.net>,
        <ath10k@lists.infradead.org>
Cc:     <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <dianders@chromium.org>,
        <evgreen@chromium.org>
References: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>   <1595351666-28193-2-git-send-email-pillair@codeaurora.org> <0dbdef912f9d61521011f638200fd451a3530568.camel@sipsolutions.net>
In-Reply-To: <0dbdef912f9d61521011f638200fd451a3530568.camel@sipsolutions.net>
Subject: RE: [RFC 1/7] mac80211: Add check for napi handle before WARN_ON
Date:   Thu, 23 Jul 2020 23:56:18 +0530
Message-ID: <003201d6611e$c54a1c90$4fde55b0$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQG1Bu1FBYi7G1oVhHY/01uT1gSslwIktOPGArPni2WpMWqJMA==
Content-Language: en-us
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Johannes Berg <johannes@sipsolutions.net>
> Sent: Wednesday, July 22, 2020 6:26 PM
> To: Rakesh Pillai <pillair@codeaurora.org>; ath10k@lists.infradead.org
> Cc: linux-wireless@vger.kernel.org; linux-kernel@vger.kernel.org;
> kvalo@codeaurora.org; davem@davemloft.net; kuba@kernel.org;
> netdev@vger.kernel.org; dianders@chromium.org; evgreen@chromium.org
> Subject: Re: [RFC 1/7] mac80211: Add check for napi handle before
> WARN_ON
>=20
> On Tue, 2020-07-21 at 22:44 +0530, Rakesh Pillai wrote:
> > The function ieee80211_rx_napi can be now called
> > from a thread context as well, with napi context
> > being NULL.
> >
> > Hence add the napi context check before giving out
> > a warning for softirq count being 0.
> >
> > Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.1-01040-QCAHLSWMTPLZ-1
> >
> > Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> > ---
> >  net/mac80211/rx.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> > index a88ab6f..1e703f1 100644
> > --- a/net/mac80211/rx.c
> > +++ b/net/mac80211/rx.c
> > @@ -4652,7 +4652,7 @@ void ieee80211_rx_napi(struct ieee80211_hw
> *hw, struct ieee80211_sta *pubsta,
> >  	struct ieee80211_supported_band *sband;
> >  	struct ieee80211_rx_status *status =3D IEEE80211_SKB_RXCB(skb);
> >
> > -	WARN_ON_ONCE(softirq_count() =3D=3D 0);
> > +	WARN_ON_ONCE(napi && softirq_count() =3D=3D 0);
>=20
> FWIW, I'm pretty sure this is incorrect - we make assumptions on
> softirqs being disabled in mac80211 for serialization and in place of
> some locking, I believe.
>=20

I checked this, but let me double confirm.
But after this change, no packet is submitted from driver in a softirq =
context.
So ideally this should take care of serialization.


> johannes


