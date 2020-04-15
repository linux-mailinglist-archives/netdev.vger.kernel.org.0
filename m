Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A311AA371
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 15:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505975AbgDONKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 09:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2897075AbgDOLfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 07:35:43 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BCF9C061A10
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 04:35:42 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id h25so3252790lja.10
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 04:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KBpalj9lT5kvxcjd5x3o+owJyJdduvaY1jMLu6w9DYI=;
        b=nHw/ApgLmxZUw2uFNTIAg/ctnJ7fmQ28uOV3gnu5UtZgIkXAbP43vB4FqdI4Q4eHiy
         2VvlqpmAjlL2m4089uAWAE9xB5Ij13OPiCOtrf4qvHEmXCD8KwnyKwA0EWo8HZChlWN+
         JP5Lx0ENlM/A4M96Hqzs+VVLySNgd7BTG9tGk1/+1/8BNdJAK0Qro1X93sr+kCJZx9YI
         SsvZM5+XuXR4L5fiXPNooZkqV2DvAJbk2cInkjEV6Tg5dAhu5lnQsxh/ygiRSfyx5XSN
         dx3OxqOfJ4SnxBViMHsrwgFydTWVJwl4ADXgcN5Of6iXY0A1K6+HLBQBGetTQbzJ6n/0
         Di6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KBpalj9lT5kvxcjd5x3o+owJyJdduvaY1jMLu6w9DYI=;
        b=o+gzNv2LsYMFtK58rkkT2/XmhZlCTMnVDBDv/kb2jWkNyOIijKN3pKqdPZPcWaTnxv
         2OLvcdrV5o3gQi/EkzZ5CsCdTf/vjndsmWHy0McCNms6u6fajL9+tE7zGf1CBTsaB0Ny
         mmo34+V+q2DJcFJIN8eDWp62padk4BKmfpKnR0/PjTBLLBzmmWjrsc3lilgAZufVlg4O
         Ix9bi/VnAHCW+DJmtvmxGMKn+lw4wb9NLhlW91KeaXMtPZHv4Nre90PKbqVsmzKsHHHc
         5q9pXMs5jTSSYmhXQNU/3PkqDFGg0D716iAOfvPQlAlpSyRySHCb9fk1tj/dOvGc/3F6
         OZ0A==
X-Gm-Message-State: AGi0PuYvkvWf5R0ngEld9I4EID8Sj0Y/TUkhNlJETRRxEgoT8sCq5m+u
        /+d7PGSnxhQHEsTaJ7E5x257yURSGMOqLi+hvZNiYg==
X-Google-Smtp-Source: APiQypJk41kgiRI94BIMANGlD8TkJQffUXgc/CbpBaQcp5YFitlmaZ4ssDBWSOD5V3uSRs0pfIVRVVkAG2pELd1X3B0=
X-Received: by 2002:a2e:b8c1:: with SMTP id s1mr3169915ljp.0.1586950540057;
 Wed, 15 Apr 2020 04:35:40 -0700 (PDT)
MIME-Version: 1.0
References: <1586254255-28713-1-git-send-email-sumit.garg@linaro.org>
 <CABPxzY+hL=jD6Zy=netP3oqNXg69gDL2g0KiPe40eaXXgZBnxw@mail.gmail.com> <CAFA6WYMZAq6X5m++h33ySCa6jOQCq_tHL=8mUi-kPMcn4FH=jA@mail.gmail.com>
In-Reply-To: <CAFA6WYMZAq6X5m++h33ySCa6jOQCq_tHL=8mUi-kPMcn4FH=jA@mail.gmail.com>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Wed, 15 Apr 2020 17:05:28 +0530
Message-ID: <CAFA6WYOW9ne0iffwC1dc48a_aSaYkkxQzyHQXTV2Wkob9KOXQg@mail.gmail.com>
Subject: Re: [PATCH v2] mac80211: fix race in ieee80211_register_hw()
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Krishna Chaitanya <chaitanya.mgit@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Matthias=2DPeter_Sch=C3=B6pfer?= 
        <matthias.schoepfer@ithinx.io>,
        "Berg Philipp (HAU-EDS)" <Philipp.Berg@liebherr.com>,
        "Weitner Michael (HAU-EDS)" <Michael.Weitner@liebherr.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Apr 2020 at 10:12, Sumit Garg <sumit.garg@linaro.org> wrote:
>
> Hi Johannes,
>
> On Wed, 8 Apr 2020 at 00:55, Krishna Chaitanya <chaitanya.mgit@gmail.com> wrote:
> >
> > On Tue, Apr 7, 2020 at 3:41 PM Sumit Garg <sumit.garg@linaro.org> wrote:
> > >
> > > A race condition leading to a kernel crash is observed during invocation
> > > of ieee80211_register_hw() on a dragonboard410c device having wcn36xx
> > > driver built as a loadable module along with a wifi manager in user-space
> > > waiting for a wifi device (wlanX) to be active.
> > >
> > > Sequence diagram for a particular kernel crash scenario:
> > >
> > >     user-space  ieee80211_register_hw()  ieee80211_tasklet_handler()
> > >     ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >        |                    |                 |
> > >        |<---phy0----wiphy_register()          |
> > >        |-----iwd if_add---->|                 |
> > just a nitpick, a better one would be (iwd: if_add + ap_start) since
> > we need to have 'iwctl ap start'
> > to trigger the interrupts.
> > >        |                    |<---IRQ----(RX packet)
> > >        |              Kernel crash            |
> > >        |              due to unallocated      |
> > >        |              workqueue.              |
> > >        |                    |                 |
> > >        |       alloc_ordered_workqueue()      |
> > >        |                    |                 |
> > >        |              Misc wiphy init.        |
> > >        |                    |                 |
> > >        |            ieee80211_if_add()        |
> > >        |                    |                 |
> > >
> > > As evident from above sequence diagram, this race condition isn't specific
> > > to a particular wifi driver but rather the initialization sequence in
> > > ieee80211_register_hw() needs to be fixed. So re-order the initialization
> > > sequence and the updated sequence diagram would look like:
> > >
> > >     user-space  ieee80211_register_hw()  ieee80211_tasklet_handler()
> > >     ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >        |                    |                 |
> > >        |       alloc_ordered_workqueue()      |
> > >        |                    |                 |
> > >        |              Misc wiphy init.        |
> > >        |                    |                 |
> > >        |<---phy0----wiphy_register()          |
> > >        |-----iwd if_add---->|                 |
> > same as above.
> > >        |                    |<---IRQ----(RX packet)
> > >        |                    |                 |
> > >        |            ieee80211_if_add()        |
> > >        |                    |                 |
> > >
> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> > > ---
> > >
>
> In case we don't have any further comments, could you fix this nitpick
> from Chaitanya while applying or would you like me to respin and send
> v3?

A gentle ping. Is this patch a good candidate for 5.7-rc2?

-Sumit

>
> -Sumit
>
> > > Changes in v2:
> > > - Move rtnl_unlock() just after ieee80211_init_rate_ctrl_alg().
> > > - Update sequence diagrams in commit message for more clarification.
> > >
> > >  net/mac80211/main.c | 22 +++++++++++++---------
> > >  1 file changed, 13 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> > > index 4c2b5ba..d497129 100644
> > > --- a/net/mac80211/main.c
> > > +++ b/net/mac80211/main.c
> > > @@ -1051,7 +1051,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
> > >                 local->hw.wiphy->signal_type = CFG80211_SIGNAL_TYPE_UNSPEC;
> > >                 if (hw->max_signal <= 0) {
> > >                         result = -EINVAL;
> > > -                       goto fail_wiphy_register;
> > > +                       goto fail_workqueue;
> > >                 }
> > >         }
> > >
> > > @@ -1113,7 +1113,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
> > >
> > >         result = ieee80211_init_cipher_suites(local);
> > >         if (result < 0)
> > > -               goto fail_wiphy_register;
> > > +               goto fail_workqueue;
> > >
> > >         if (!local->ops->remain_on_channel)
> > >                 local->hw.wiphy->max_remain_on_channel_duration = 5000;
> > > @@ -1139,10 +1139,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
> > >
> > >         local->hw.wiphy->max_num_csa_counters = IEEE80211_MAX_CSA_COUNTERS_NUM;
> > >
> > > -       result = wiphy_register(local->hw.wiphy);
> > > -       if (result < 0)
> > > -               goto fail_wiphy_register;
> > > -
> > >         /*
> > >          * We use the number of queues for feature tests (QoS, HT) internally
> > >          * so restrict them appropriately.
> > > @@ -1207,6 +1203,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
> > >                 goto fail_rate;
> > >         }
> > >
> > > +       rtnl_unlock();
> > > +
> > >         if (local->rate_ctrl) {
> > >                 clear_bit(IEEE80211_HW_SUPPORTS_VHT_EXT_NSS_BW, hw->flags);
> > >                 if (local->rate_ctrl->ops->capa & RATE_CTRL_CAPA_VHT_EXT_NSS_BW)
> > > @@ -1254,6 +1252,12 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
> > >                 local->sband_allocated |= BIT(band);
> > >         }
> > >
> > > +       result = wiphy_register(local->hw.wiphy);
> > > +       if (result < 0)
> > > +               goto fail_wiphy_register;
> > > +
> > > +       rtnl_lock();
> > > +
> > >         /* add one default STA interface if supported */
> > >         if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_STATION) &&
> > >             !ieee80211_hw_check(hw, NO_AUTO_VIF)) {
> > > @@ -1293,6 +1297,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
> > >  #if defined(CONFIG_INET) || defined(CONFIG_IPV6)
> > >   fail_ifa:
> > >  #endif
> > > +       wiphy_unregister(local->hw.wiphy);
> > > + fail_wiphy_register:
> > >         rtnl_lock();
> > >         rate_control_deinitialize(local);
> > >         ieee80211_remove_interfaces(local);
> > > @@ -1302,8 +1308,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
> > >         ieee80211_led_exit(local);
> > >         destroy_workqueue(local->workqueue);
> > >   fail_workqueue:
> > > -       wiphy_unregister(local->hw.wiphy);
> > > - fail_wiphy_register:
> > >         if (local->wiphy_ciphers_allocated)
> > >                 kfree(local->hw.wiphy->cipher_suites);
> > >         kfree(local->int_scan_req);
> > > @@ -1353,8 +1357,8 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
> > >         skb_queue_purge(&local->skb_queue_unreliable);
> > >         skb_queue_purge(&local->skb_queue_tdls_chsw);
> > >
> > > -       destroy_workqueue(local->workqueue);
> > >         wiphy_unregister(local->hw.wiphy);
> > > +       destroy_workqueue(local->workqueue);
> > >         ieee80211_led_exit(local);
> > >         kfree(local->int_scan_req);
> > >  }
> > > --
> > > 2.7.4
> > >
> >
> >
> > --
> > Thanks,
> > Regards,
> > Chaitanya T K.
