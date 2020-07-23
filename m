Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D62322B72A
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 22:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgGWUHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 16:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgGWUHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 16:07:18 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D096EC0619DC;
        Thu, 23 Jul 2020 13:07:17 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jyhUc-009mYg-5X; Thu, 23 Jul 2020 22:07:02 +0200
Message-ID: <ce380ea1fd1f5db40a92f67673f070a1f88eee50.camel@sipsolutions.net>
Subject: Re: [RFC 1/7] mac80211: Add check for napi handle before WARN_ON
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Rakesh Pillai <pillair@codeaurora.org>, ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, dianders@chromium.org, evgreen@chromium.org
Date:   Thu, 23 Jul 2020 22:06:46 +0200
In-Reply-To: <003201d6611e$c54a1c90$4fde55b0$@codeaurora.org>
References: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>
                 <1595351666-28193-2-git-send-email-pillair@codeaurora.org>
         <0dbdef912f9d61521011f638200fd451a3530568.camel@sipsolutions.net>
         <003201d6611e$c54a1c90$4fde55b0$@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-07-23 at 23:56 +0530, Rakesh Pillai wrote:

> > > -	WARN_ON_ONCE(softirq_count() == 0);
> > > +	WARN_ON_ONCE(napi && softirq_count() == 0);
> > 
> > FWIW, I'm pretty sure this is incorrect - we make assumptions on
> > softirqs being disabled in mac80211 for serialization and in place of
> > some locking, I believe.
> > 
> 
> I checked this, but let me double confirm.
> But after this change, no packet is submitted from driver in a softirq context.
> So ideally this should take care of serialization.

I'd guess that we have some reliance on BHs already being disabled, for
things like u64 sync updates, or whatnot. I mean, we did "rx_ni()" for a
reason ... Maybe lockdep can help catch some of the issues.

But couldn't you be in a thread and have BHs disabled too?

johannes

