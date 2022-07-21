Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5F757C912
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 12:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233274AbiGUKfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 06:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233269AbiGUKfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 06:35:14 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BFF65F95;
        Thu, 21 Jul 2022 03:35:13 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id l11so2009330ybu.13;
        Thu, 21 Jul 2022 03:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l/wpKnsu88iqqnfQdZ4Rl466UVvkTC5XsY5VfmsKtYI=;
        b=PJTOs+N2jt8yf/67NT167TvH6DD8Y3ZJumINeZjx9cSXM0wGDQChdKBgqakWHscLZ8
         mMeMgtVDgTaj2Ws9/7A1OyYJJtnq1s+t9b6G6f3qBk9uy9i8TJR/urjlOXWBvS9Ou8Dy
         G5WyLfZUAXlIGX1DFUKCLcG+SE6+n5VXHyfH8b0oNtfLyVWCbQl+QklA+WZPEFPvGdfh
         pSmFNJ1CzOWkikmj6PJqm21BXcNmyxw4zMB3J0SJDj/bTn/usUYVrqVuX9kzlA81l7CS
         Hu7SqlrhfXC/4JM5Aewz9qfCMOXtrT6hzDCCBRuldoQL5nAm4xXON+gzwYkYvcbeDvK+
         MP2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l/wpKnsu88iqqnfQdZ4Rl466UVvkTC5XsY5VfmsKtYI=;
        b=mgQvcBaQB2Kp2oiUDBRNIl3XiVWAonDkHVQwVf83PO8OTIlvGvaFNuun5rQ/qwOtb5
         ezHc+W/Ux34THtlFn7mYziXzOAf35cGAna2vhU7Q2OstxYJFyEKRZKCjSAD2HFzlC9LF
         Q8QlFbAXIozuIiHinqhe4H+I3hAHWdi5Z5DODl2+hEPBBlebncxD0uDwiunBVWe8bLJL
         pPhVM6831pfyLfFYHxN3x79DRUfEmweo90UWJ6VY437IvipodL7azYfrITFTOTcMdfz8
         fb+FuU45z6B26PV24tq3ilS6s1gl/hxAcN5mDAEM1VhlC7fgFPMYxmcSpYGMB5Tq5Bbz
         g42g==
X-Gm-Message-State: AJIora+SdY+gsv+XNdOYgRgqxcZ5g3k5X5wUpBczGSK5uTuQqOmhTr/Z
        wKpE1eWD7YDhSXh4plO9raXky2d4krXwW6930Dc=
X-Google-Smtp-Source: AGRyM1t95qmA6+uFKxTLfYEcuVdCSnnm/ebRqAwuj9nRI/4RcogNDmKQInBOxclPWV0zPYGj6zuLhcDTZUj/bFuJQC8=
X-Received: by 2002:a25:850b:0:b0:66c:d287:625a with SMTP id
 w11-20020a25850b000000b0066cd287625amr41901100ybk.31.1658399712184; Thu, 21
 Jul 2022 03:35:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220721101018.17902-1-code@siddh.me>
In-Reply-To: <20220721101018.17902-1-code@siddh.me>
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date:   Thu, 21 Jul 2022 12:35:01 +0200
Message-ID: <CAKXUXMzeSLuH31zQDe3Q_1YAvfmFR16ZsfFGmxEMiMQSKcp_Nw@mail.gmail.com>
Subject: Re: [RESEND PATCH] net: Fix UAF in ieee80211_scan_rx()
To:     Siddh Raman Pant <code@siddh.me>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        syzbot+6cb476b7c69916a0caca@syzkaller.appspotmail.com,
        linux-wireless <linux-wireless@vger.kernel.org>,
        syzbot+f9acff9bf08a845f225d@syzkaller.appspotmail.com,
        syzbot+9250865a55539d384347@syzkaller.appspotmail.com,
        linux-kernel-mentees 
        <linux-kernel-mentees@lists.linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 12:11 PM Siddh Raman Pant via
Linux-kernel-mentees <linux-kernel-mentees@lists.linuxfoundation.org>
wrote:
>
> ieee80211_scan_rx() tries to access scan_req->flags after a null check
> (see line 303 of mac80211/scan.c), but ___cfg80211_scan_done() uses
> kfree() on the scan_req (see line 991 of wireless/scan.c).
>
> This results in a UAF.
>
> ieee80211_scan_rx() is called inside a RCU read-critical section
> initiated by ieee80211_rx_napi() (see line 5043 of mac80211/rx.c).
>
> Thus, add an rcu_head to the scan_req struct so as to use kfree_rcu()
> instead of kfree() so that we don't free during the critical section.
>
> Bug report (3): https://syzkaller.appspot.com/bug?extid=f9acff9bf08a845f225d
> Reported-by: syzbot+f9acff9bf08a845f225d@syzkaller.appspotmail.com
> Reported-by: syzbot+6cb476b7c69916a0caca@syzkaller.appspotmail.com
> Reported-by: syzbot+9250865a55539d384347@syzkaller.appspotmail.com
>
> Signed-off-by: Siddh Raman Pant <code@siddh.me>
> ---
> Resending because didn't get any reply from maintainers for more
> than 2 weeks.
>

Siddh,

I had a look at the Bug report above. Currently, we do not have any
syzkaller or C reproducer to confirm that the bug was actually fixed.

Now, that you have a supposed fix for the issue:
Can you write a 'stress test' and (qemu) setup script that eventually
makes that bug trigger (e.g., if we run the stress test for two or
three days it will eventually trigger)? Then, we can also use that to
confirm that your patch fixes the issue (beyond the normal sanity code
review).

This is certainly something you can do on your side to move this patch
forward, and other developers with testing infrastructure can pick up
and confirm your tests and results independently.

I hope this helps, otherwise you will just need to have some patience.

Best regards,

Lukas

>  include/net/cfg80211.h | 2 ++
>  net/wireless/scan.c    | 2 +-
>  2 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 6d02e12e4702..ba4a49884de8 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -2368,6 +2368,7 @@ struct cfg80211_scan_6ghz_params {
>   * @n_6ghz_params: number of 6 GHz params
>   * @scan_6ghz_params: 6 GHz params
>   * @bssid: BSSID to scan for (most commonly, the wildcard BSSID)
> + * @rcu_head: (internal) RCU head to use for freeing
>   */
>  struct cfg80211_scan_request {
>         struct cfg80211_ssid *ssids;
> @@ -2397,6 +2398,7 @@ struct cfg80211_scan_request {
>         bool scan_6ghz;
>         u32 n_6ghz_params;
>         struct cfg80211_scan_6ghz_params *scan_6ghz_params;
> +       struct rcu_head rcu_head;
>
>         /* keep last */
>         struct ieee80211_channel *channels[];
> diff --git a/net/wireless/scan.c b/net/wireless/scan.c
> index 6d82bd9eaf8c..638b2805222c 100644
> --- a/net/wireless/scan.c
> +++ b/net/wireless/scan.c
> @@ -988,7 +988,7 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev,
>         kfree(rdev->int_scan_req);
>         rdev->int_scan_req = NULL;
>
> -       kfree(rdev->scan_req);
> +       kfree_rcu(rdev->scan_req, rcu_head);
>         rdev->scan_req = NULL;
>
>         if (!send_message)
> --
> 2.35.1
>
>
> _______________________________________________
> Linux-kernel-mentees mailing list
> Linux-kernel-mentees@lists.linuxfoundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/linux-kernel-mentees
