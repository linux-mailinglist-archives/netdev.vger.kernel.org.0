Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA64AFC21
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 14:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbfIKMEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 08:04:41 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:37674 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726696AbfIKMEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 08:04:40 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1i81MN-0006HO-EX; Wed, 11 Sep 2019 14:04:31 +0200
Message-ID: <30679d3f86731475943856196478677e70a349a9.camel@sipsolutions.net>
Subject: Re: WARNING at net/mac80211/sta_info.c:1057
 (__sta_info_destroy_part2())
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
Date:   Wed, 11 Sep 2019 14:04:30 +0200
In-Reply-To: <CAHk-=wj_jneK+UYzHhjwsH0XxP0knM+2o2OeFVEz-FjuQ77-ow@mail.gmail.com> (sfid-20190911_135849_146176_004B38CD)
References: <CAHk-=wgBuu8PiYpD7uWgxTSY8aUOJj6NJ=ivNQPYjAKO=cRinA@mail.gmail.com>
         <feecebfcceba521703f13c8ee7f5bb9016924cb6.camel@sipsolutions.net>
         <CAHk-=wj_jneK+UYzHhjwsH0XxP0knM+2o2OeFVEz-FjuQ77-ow@mail.gmail.com>
         (sfid-20190911_135849_146176_004B38CD)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-09-11 at 12:58 +0100, Linus Torvalds wrote:
> 
> And I didn't think about it or double-check, because the errors that
> then followed later _looked_ like that TX power failing that I thought
> hadn't happened.

Yeah, it could be something already got stuck there, hard to say.

> > Since we see that something actually did an rfkill operation. Did you
> > push a button there?
> 
> No, I tried to turn off and turn on Wifi manually (no button, just the
> settings panel).

That does usually also cause rfkill, so that explains how we got down
this particular code path.

> I didn't notice the WARN_ON(), I just noticed that there was no
> networking, and "turn it off and on again" is obviously the first
> thing to try ;)

:-)

> Sep 11 10:27:13 xps13 kernel: WARNING: CPU: 4 PID: 1246 at
> net/mac80211/sta_info.c:1057 __sta_info_destroy_part2+0x147/0x150
> [mac80211]
> 
> but if you want full logs I can send them in private to you.

No, it's fine, though maybe Kalle does - he was stepping out for a while
but said he'd look later.

This is the interesting time - 10:27:13 we get one of the first
failures. Really the first one was this:

> Sep 11 10:27:07 xps13 kernel: ath10k_pci 0000:02:00.0: wmi command 16387 timeout, restarting hardware


> I do suspect it's atheros and suspend/resume or something. The
> wireless clearly worked for a while after the resume, but then at some
> point it stopped.

I'm not really sure it's related to suspend/resume at all, the firmware
seems to just have gotten stuck, and the device and firmware most likely
got reset over the suspend/resume anyway.

> > The only explanation I therefore have is that something is just taking
> > *forever* in that code path, hence my question about timing information
> > on the logs.
> 
> Yeah, maybe it would time out everything eventually. But not for a
> long time. It hadn't cleared up by
> 
>   Sep 11 10:36:21 xps13 gnome-session-f[6837]: gnome-session-failed:
> Fatal IO error 0 (Success) on X server :0.

Ok, that's way longer than I would have guessed even! That's over 9
minutes, that'd be close to 200 commands having to be issued and timing
out ...

I don't know. What I wrote before is basically all I can say, I think
the driver gets stuck somewhere waiting for the device "forever", and
the stack just doesn't get to release the lock, causing all the follow-
up problems.

johannes

