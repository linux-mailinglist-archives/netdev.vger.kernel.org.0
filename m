Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25183B03E2
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 20:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730174AbfIKSsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 14:48:16 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:60890 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729016AbfIKSsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 14:48:16 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 09CC460A50; Wed, 11 Sep 2019 18:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568227695;
        bh=fqLyZWfORQEC6v2+nP26Sy1WzgSPYbYDAMK27hsI/aM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Zmn0VYxjz9scf466LpHylBrRTkA2pA87LGVT89iiuYIuLXGwPHR1DYgX3FGiwmobS
         t+QCf0mnrQE34HEKrj2FVXLJWMbnGg00k1c+uS9U6DL4OSlAbkh93773cXZTkJdPXk
         cd1r9XzktA6BDPbemGmGON23N1VwkRuUO5MMHrvo=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6633560256;
        Wed, 11 Sep 2019 18:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568227694;
        bh=fqLyZWfORQEC6v2+nP26Sy1WzgSPYbYDAMK27hsI/aM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ELVDQ4yBwmWuMQqmVGmxRYOhTtlyRU6jCwAb3UnUg0v9ooHc0HPskOWE89vdnBX8c
         4eFlpirL9TxhLpPpLbUhMzNgtwIR3iCm8UGMDqdPlni9ZRfN8TbtNlstGC1/lXFnmK
         /qKvzz3JVyycQejo+UVgQZ1uvFkEJzaWP6DdAEjA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6633560256
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        ath10k@lists.infradead.org
Subject: Re: WARNING at net/mac80211/sta_info.c:1057 (__sta_info_destroy_part2())
References: <CAHk-=wgBuu8PiYpD7uWgxTSY8aUOJj6NJ=ivNQPYjAKO=cRinA@mail.gmail.com>
        <feecebfcceba521703f13c8ee7f5bb9016924cb6.camel@sipsolutions.net>
        <87ef0mlmqg.fsf@tynnyri.adurom.net>
        <383b145b608e0fe3a35ffb0ceb99fdf938d4e2bb.camel@sipsolutions.net>
Date:   Wed, 11 Sep 2019 21:48:09 +0300
In-Reply-To: <383b145b608e0fe3a35ffb0ceb99fdf938d4e2bb.camel@sipsolutions.net>
        (Johannes Berg's message of "Wed, 11 Sep 2019 20:23:33 +0200")
Message-ID: <87zhjak6ty.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2019-09-11 at 21:19 +0300, Kalle Valo wrote:
>> > Looks like indeed the driver gives the device at least *3 seconds* for
>> > every command, see ath10k_wmi_cmd_send(), so most likely this would
>> > eventually have finished, but who knows how many firmware commands it
>> > would still have attempted to send...
>> 
>> 3 seconds is a bit short but in normal cases it should be enough. Of
>> course we could increase the delay but I'm skeptic it would help here.
>
> I was thinking 3 seconds is way too long :-)

Heh :)

>> > Perhaps the driver should mark the device as dead and fail quickly once
>> > it timed out once, or so, but I'll let Kalle comment on that.
>> 
>> Actually we do try to restart the device when a timeout happens in
>> ath10k_wmi_cmd_send():
>> 
>>         if (ret == -EAGAIN) {
>>                 ath10k_warn(ar, "wmi command %d timeout, restarting hardware\n",
>>                             cmd_id);
>>                 queue_work(ar->workqueue, &ar->restart_work);
>>         }
>
> Yeah, and this is the problem, in a sense, I'd think. It seems to me
> that at this point the code needs to tag the device as "dead" and
> immediately return from any further commands submitted to it with an
> error (e.g. -EIO).

Yeah, ath10k_core_restart() is supposed change to state
ATH10K_STATE_RESTARTING but very few mac80211 ops in ath10k_ops are
checking for it, and to me it looks like quite late even. I think a
proper fix for ops which can sleep is to check ar->state is
ATH10K_STATE_ON and for ops which cannot sleep check
ATH10K_FLAG_CRASH_FLUSH.

But of course this just fixes the symptoms, the root cause for timeouts
needs to be found as well.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
