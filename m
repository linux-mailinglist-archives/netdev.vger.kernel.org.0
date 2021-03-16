Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF1E33DED6
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 21:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbhCPUdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 16:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhCPUce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 16:32:34 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994F5C06174A;
        Tue, 16 Mar 2021 13:32:33 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lMGMb-00H4jl-H3; Tue, 16 Mar 2021 21:32:25 +0100
Message-ID: <8a5845b49b6dc03b8d6f8fe9915034178be992ae.camel@sipsolutions.net>
Subject: Re: [PATCH] net: wireless: search and hold bss in
 cfg80211_connect_done
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Abhishek Kumar <kuabhs@chromium.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        briannorris@chromium.org, linux-wireless@vger.kernel.org
Date:   Tue, 16 Mar 2021 21:32:24 +0100
In-Reply-To: <20210316192919.1.I26d48d8a4d06ef9bd2b57f857c58ae681cc33783@changeid> (sfid-20210316_203101_193722_2D56E503)
References: <20210316192919.1.I26d48d8a4d06ef9bd2b57f857c58ae681cc33783@changeid>
         (sfid-20210316_203101_193722_2D56E503)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-03-16 at 19:29 +0000, Abhishek Kumar wrote:
> If BSS instance is not provided in __cfg80211_connect_result then
> a get bss is performed. This can return NULL if the BSS for the
> given SSID is expired due to delayed scheduling of connect result event
> in rdev->event_work. This can cause WARN_ON(!cr->bss) in
> __cfg80211_connect_result to be triggered and cause cascading
> failures. To mitigate this, initiate a get bss call in
> cfg80211_connect_done itself and hold it to ensure that the BSS
> instance does not get expired.

I'm not sure I see the value in this.

You're basically picking a slightly earlier point in time where cfg80211
might know about the BSS entry still, so you're really just making the
problem window a few microseconds or perhaps milliseconds (whatever ends
up being the worker delay) shorter.

Compared to the 30s entry lifetime, that's nothing.

So what's the point? Please fix the driver instead to actually hold on
to it and report it back.

johannes

