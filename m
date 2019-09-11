Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15D5BB0388
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 20:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730026AbfIKSXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 14:23:42 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:48026 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728105AbfIKSXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 14:23:42 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1i87HD-000795-UV; Wed, 11 Sep 2019 20:23:36 +0200
Message-ID: <383b145b608e0fe3a35ffb0ceb99fdf938d4e2bb.camel@sipsolutions.net>
Subject: Re: WARNING at net/mac80211/sta_info.c:1057
 (__sta_info_destroy_part2())
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        ath10k@lists.infradead.org
Date:   Wed, 11 Sep 2019 20:23:33 +0200
In-Reply-To: <87ef0mlmqg.fsf@tynnyri.adurom.net>
References: <CAHk-=wgBuu8PiYpD7uWgxTSY8aUOJj6NJ=ivNQPYjAKO=cRinA@mail.gmail.com>
         <feecebfcceba521703f13c8ee7f5bb9016924cb6.camel@sipsolutions.net>
         <87ef0mlmqg.fsf@tynnyri.adurom.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-09-11 at 21:19 +0300, Kalle Valo wrote:
> > Looks like indeed the driver gives the device at least *3 seconds* for
> > every command, see ath10k_wmi_cmd_send(), so most likely this would
> > eventually have finished, but who knows how many firmware commands it
> > would still have attempted to send...
> 
> 3 seconds is a bit short but in normal cases it should be enough. Of
> course we could increase the delay but I'm skeptic it would help here.

I was thinking 3 seconds is way too long :-)

> > Perhaps the driver should mark the device as dead and fail quickly once
> > it timed out once, or so, but I'll let Kalle comment on that.
> 
> Actually we do try to restart the device when a timeout happens in
> ath10k_wmi_cmd_send():
> 
>         if (ret == -EAGAIN) {
>                 ath10k_warn(ar, "wmi command %d timeout, restarting hardware\n",
>                             cmd_id);
>                 queue_work(ar->workqueue, &ar->restart_work);
>         }

Yeah, and this is the problem, in a sense, I'd think. It seems to me
that at this point the code needs to tag the device as "dead" and
immediately return from any further commands submitted to it with an
error (e.g. -EIO). You can can actually see in the initial report that
while the restart was triggered, it too is waiting to acquire the RTNL:

>    Workqueue: events_freezable ieee80211_restart_work [mac80211]
>    Call Trace:
>     schedule+0x39/0xa0
>     schedule_preempt_disabled+0xa/0x10
>     __mutex_lock.isra.0+0x263/0x4b0
>     ieee80211_restart_work+0x54/0xe0 [mac80211]
>     process_one_work+0x1cf/0x370
>     worker_thread+0x4a/0x3c0
>     kthread+0xfb/0x130
>     ret_from_fork+0x35/0x40


So basically all this delay is mac80211 and the driver doing stuff with
the device, but every single thing has to time out and probably some
stuff loops etc., and then it just takes long enough with the RTNL held
that everything goes south.

johannes

