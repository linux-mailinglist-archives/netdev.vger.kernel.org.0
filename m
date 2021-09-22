Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECE34142B9
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 09:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233338AbhIVHfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 03:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233208AbhIVHfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 03:35:36 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 846FBC061574;
        Wed, 22 Sep 2021 00:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=9AY8F16aIJoBespGhpIqcYrXI4qFapt3L2VJxzUtRcw=;
        t=1632296046; x=1633505646; b=uL+8G9BJdNnflVui72S/UFRPGdPpibVKacv9sdfFtCBJvm9
        r7WOkC8DsJy6gUqePqokQqqkh7L+31IrKUv5QCqHkp2jJTJWx3ug3OVl/pyw9jws/ws1QlPYQYPeQ
        /YhILgz/GTRNPaK8kU+njjiHzmXqUw3FeLUn+o/SpvGvYFxDLDuwrsHaNdtnLqTnH6R6HZFJx9mp4
        gwQbgXgV5Rq/VvyCrX9eUA2sVYjPhdt4Oe1zKGT2mziJUj58qEcRRHFFxcr45ppZ/0oihiEmXwyev
        WGMCnMKOGc8p9mSRb7xQuUOxuNgW1uPhx1xIwUpbxBke1J+2uG8qJDYLy+rpF99w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95-RC2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mSwlR-00ACry-SN;
        Wed, 22 Sep 2021 09:33:58 +0200
Message-ID: <e0522c7845390a71203744d209a9516cb8a562e6.camel@sipsolutions.net>
Subject: Re: [EXTERNAL] Re: [PATCH] [v15] wireless: Initial driver
 submission for pureLiFi STA devices
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Srinivasan Raju <srini.raju@purelifi.com>
Cc:     Mostafa Afgani <mostafa.afgani@purelifi.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Date:   Wed, 22 Sep 2021 09:33:56 +0200
In-Reply-To: <87ee9iun4o.fsf@codeaurora.org>
References: <20210226130810.119216-1-srini.raju@purelifi.com>
         <20210818141343.7833-1-srini.raju@purelifi.com>
         <87o88nwg74.fsf@codeaurora.org>
         <CWLP265MB3217BB5AA5F102629A3AD204E0A19@CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM>
         <87ee9iun4o.fsf@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-09-21 at 15:30 +0300, Kalle Valo wrote:
> > 
> > Yes, I agree, As LiFi is not standardized yet we are using the
> > existing wireless frameworks. For now, piggy backing with 2.4GHz is
> > seamless for users. We will undertake band and other wider change once
> > IEEE 802.11bb is standardized.
> 
> I don't see why the IEEE standard needs to be final before adding the
> band. Much better to add a band which is in draft stage compared to
> giving false information to the user space.

I tend to agree, but looking at the current draft (D0.6), that's ...
vague? Maybe it's obvious to somebody familiar with the technology, but
I really don't understand how 800-1000nm infrared band maps to 21 MHz +
channel offset? Isn't the frequency there a couple hundred THz?

Regardless, if the channelisation plan says 21 MHz + n_ch * 5 MHz, then
I think we can just define NL80211_BAND_LC and the driver advertises
those channels - that even gets you easy access to all the defined
channels (apparently today all the odd channels from 1-61, split into
20/40/80/160 MHz bandwidth).

I guess I'm really not sure how that maps to the actual infrared, but
reusing all the 20/40/80/160 machinery from VHT means we can actually do
a lot of things in mac80211/etc. without much changes, which isn't bad.

Anyway, I'd feel more comfortable defining an LC band here, even if it
potentially changes later. Or maybe especially if the actual channels
there change later.

johannes

