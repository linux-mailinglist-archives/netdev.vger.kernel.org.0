Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1D6285E70
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 13:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgJGLsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 07:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbgJGLst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 07:48:49 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFBCC061755;
        Wed,  7 Oct 2020 04:48:49 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kQ7w5-000t7x-Bn; Wed, 07 Oct 2020 13:48:45 +0200
Message-ID: <bec6415925c213a2e3eb86e80d6982b82180f019.camel@sipsolutions.net>
Subject: Re: [PATCH 0/2] net, mac80211: enable KCOV remote coverage
 collection for 802.11 frame handling
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Aleksandr Nogikh <a.nogikh@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     edumazet@google.com, andreyknvl@google.com, dvyukov@google.com,
        elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        nogikh@google.com
Date:   Wed, 07 Oct 2020 13:48:43 +0200
In-Reply-To: <20201007101726.3149375-1-a.nogikh@gmail.com> (sfid-20201007_121750_390860_16179DAD)
References: <20201007101726.3149375-1-a.nogikh@gmail.com>
         (sfid-20201007_121750_390860_16179DAD)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-10-07 at 10:17 +0000, Aleksandr Nogikh wrote:
> From: Aleksandr Nogikh <nogikh@google.com>
> 
> This patch series enables remote KCOV coverage collection for the
> mac80211 code that processes incoming 802.11 frames. These changes
> make it possible to perform coverage-guided fuzzing in search of
> remotely triggerable bugs.
> 
> 
> The series consists of two commits.
> 1. Remember kcov_handle for each sk_buff. This can later be used to
> enable remote coverage for other network subsystems.
> 2. Annotate the code that processes incoming 802.11 frames.
> 
> Aleksandr Nogikh (2):
>   net: store KCOV remote handle in sk_buff

Can you explain that a bit better? What is a "remote handle"? What does
it do in the SKB?

I guess I'd have to know more about "kcov_common_handle()" to understand
this bit.

>   mac80211: add KCOV remote annotations to incoming frame processing

This seems fine, but a bit too limited? You tagged
only ieee80211_tasklet_handler() which calls ieee80211_rx()
or ieee80211_tx_status(), but

1) I'm not even sure ieee80211_tx_status() counts (it's processing
locally generated frames after they round-tripped into the driver
(although in mesh it could be remote originated but retransmitted
frames, so I guess it makes some sense?); and

2) there are many other ways that ieee80211_rx() could get called.

It seems to me it'd make more sense to (also) annotate ieee80211_rx()
itself?

johannes

