Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E492032B38D
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449688AbhCCECC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:02:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448253AbhCBOTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 09:19:02 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8411EC061756;
        Tue,  2 Mar 2021 06:18:22 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lH5qr-00AnJW-Vv; Tue, 02 Mar 2021 15:18:18 +0100
Message-ID: <0a0573f07a7e1468f83d52afcf8f5ba356725740.camel@sipsolutions.net>
Subject: Re: BUG: soft lockup in ieee80211_tasklet_handler
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+27df43cf7ae73de7d8ee@syzkaller.appspotmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Date:   Tue, 02 Mar 2021 15:18:16 +0100
In-Reply-To: <20210224023026.3001-1-hdanton@sina.com>
References: <00000000000039404305bc049fa5@google.com>
         <20210224023026.3001-1-hdanton@sina.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-02-24 at 10:30 +0800, Hillf Danton wrote:
> 
> Add budget for the 80211 softint handler - it's feasible not to try to
> build the giant pyramid in a week.
> 
> --- x/net/mac80211/main.c
> +++ y/net/mac80211/main.c
> @@ -224,9 +224,15 @@ static void ieee80211_tasklet_handler(un
>  {
>  	struct ieee80211_local *local = (struct ieee80211_local *) data;
>  	struct sk_buff *skb;
> +	int i = 0;
> +
> +	while (i++ < 64) {
> +		skb = skb_dequeue(&local->skb_queue);
> +		if (!skb)
> +			skb = skb_dequeue(&local->skb_queue_unreliable);
> +		if (!skb)
> +			return;

I guess that's not such a bad idea, but I do wonder how we get here,
userspace can submit packets faster than we can process?

It feels like a simulation-only case, tbh, since over the air you have
limits how much bandwidth you can get ... unless you have a very slow
CPU?

In any case, if you want anything merged you're going to have to submit
a proper patch with a real commit message and Signed-off-by, etc.

johannes

