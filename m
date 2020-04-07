Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A444A1A15F1
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 21:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgDGTZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 15:25:16 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:46952 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbgDGTZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 15:25:16 -0400
Received: by mail-yb1-f195.google.com with SMTP id f14so2413056ybr.13;
        Tue, 07 Apr 2020 12:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7Hzvtg6W0i9DvnOErHW1hryLvey/3wLijh3fHGUEWdw=;
        b=s/kJS3q1UOBpbuEZ+pkttGQ5l06EF7BUXxAUEee2bEUKn6ltPTrIePhhewjMEG2m+R
         Dpu8sLfRYsNkGWBrd1aS2/rr5414FSnmOk6dpj+Q7rXj81MhSFqAEDHXzzVohJiJgSOC
         yidiTuF+4+cE9iC5aJXqW/SlO7Agso91d4Z47zNynyIFBAp3XuKjCroR4zllE6ENgJz9
         djhC88WaA0dtRdvNNs6cKuw8GfZdCaKXhR17AG/gOuVWkBZlR6D8ZwgG6rlEQGlpscBX
         CYiTKitbuQaTXGxTN5iZx1oAHJ8SA6thrmOQDQGQLNvbFmB8TrJL45WUDIpG3hdCrFf3
         YF0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7Hzvtg6W0i9DvnOErHW1hryLvey/3wLijh3fHGUEWdw=;
        b=OgfAqqyxnfH2tyZgJERMTpdAI22KZCvvA+1Jtl6JEkvrkdbRGdorQr3udwrMG8qg3V
         A/s0m6ZaWIn2SIC38My5OI9cyvxKdJBK6cTLdl5F8xjZIAJjBBEE4x7VUhdtpo9KS5Vt
         3haRpFyjBSz4WDYsG5Uo13T64XvcOwuKl6RM79vyB++gz+LK5FRtT9pCjJ1IrGgiSfON
         eia7A0o/jBZMsQ8Lj8AQ/rQ+NK5v1e678f7n/8CxHUzoHXAVvtoK4lFWuD54z2H4x5Gr
         oQ5ibfcyGz2eEKv9RoKzHsTL2cVd51J+GLYyw0B1GDsUOkipK0yTOIht8o+YhsYMqpSv
         sqOw==
X-Gm-Message-State: AGi0PuZEejlI5GDKFeoLe9ftmn3eFEbGkrmPbh9QlJrALUgG+wIzA2FV
        KoU7VHgBT2sDDgU62m4gfPN+ewkhgu/m2XmdRlY=
X-Google-Smtp-Source: APiQypICC/AIYivmuvOLIsjtwfRyZYvNSJhSUAjN47Px/dH2plt/G0bwyMVa2Ih1Ik90fo2CZ8pphvVAoAlAxIcpkbk=
X-Received: by 2002:a5b:443:: with SMTP id s3mr6522316ybp.14.1586287514312;
 Tue, 07 Apr 2020 12:25:14 -0700 (PDT)
MIME-Version: 1.0
References: <1586254255-28713-1-git-send-email-sumit.garg@linaro.org>
In-Reply-To: <1586254255-28713-1-git-send-email-sumit.garg@linaro.org>
From:   Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date:   Wed, 8 Apr 2020 00:55:02 +0530
Message-ID: <CABPxzY+hL=jD6Zy=netP3oqNXg69gDL2g0KiPe40eaXXgZBnxw@mail.gmail.com>
Subject: Re: [PATCH v2] mac80211: fix race in ieee80211_register_hw()
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
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

On Tue, Apr 7, 2020 at 3:41 PM Sumit Garg <sumit.garg@linaro.org> wrote:
>
> A race condition leading to a kernel crash is observed during invocation
> of ieee80211_register_hw() on a dragonboard410c device having wcn36xx
> driver built as a loadable module along with a wifi manager in user-space
> waiting for a wifi device (wlanX) to be active.
>
> Sequence diagram for a particular kernel crash scenario:
>
>     user-space  ieee80211_register_hw()  ieee80211_tasklet_handler()
>     ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>        |                    |                 |
>        |<---phy0----wiphy_register()          |
>        |-----iwd if_add---->|                 |
just a nitpick, a better one would be (iwd: if_add + ap_start) since
we need to have 'iwctl ap start'
to trigger the interrupts.
>        |                    |<---IRQ----(RX packet)
>        |              Kernel crash            |
>        |              due to unallocated      |
>        |              workqueue.              |
>        |                    |                 |
>        |       alloc_ordered_workqueue()      |
>        |                    |                 |
>        |              Misc wiphy init.        |
>        |                    |                 |
>        |            ieee80211_if_add()        |
>        |                    |                 |
>
> As evident from above sequence diagram, this race condition isn't specific
> to a particular wifi driver but rather the initialization sequence in
> ieee80211_register_hw() needs to be fixed. So re-order the initialization
> sequence and the updated sequence diagram would look like:
>
>     user-space  ieee80211_register_hw()  ieee80211_tasklet_handler()
>     ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>        |                    |                 |
>        |       alloc_ordered_workqueue()      |
>        |                    |                 |
>        |              Misc wiphy init.        |
>        |                    |                 |
>        |<---phy0----wiphy_register()          |
>        |-----iwd if_add---->|                 |
same as above.
>        |                    |<---IRQ----(RX packet)
>        |                    |                 |
>        |            ieee80211_if_add()        |
>        |                    |                 |
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> ---
>
> Changes in v2:
> - Move rtnl_unlock() just after ieee80211_init_rate_ctrl_alg().
> - Update sequence diagrams in commit message for more clarification.
>
>  net/mac80211/main.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
>
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index 4c2b5ba..d497129 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -1051,7 +1051,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>                 local->hw.wiphy->signal_type = CFG80211_SIGNAL_TYPE_UNSPEC;
>                 if (hw->max_signal <= 0) {
>                         result = -EINVAL;
> -                       goto fail_wiphy_register;
> +                       goto fail_workqueue;
>                 }
>         }
>
> @@ -1113,7 +1113,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>
>         result = ieee80211_init_cipher_suites(local);
>         if (result < 0)
> -               goto fail_wiphy_register;
> +               goto fail_workqueue;
>
>         if (!local->ops->remain_on_channel)
>                 local->hw.wiphy->max_remain_on_channel_duration = 5000;
> @@ -1139,10 +1139,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>
>         local->hw.wiphy->max_num_csa_counters = IEEE80211_MAX_CSA_COUNTERS_NUM;
>
> -       result = wiphy_register(local->hw.wiphy);
> -       if (result < 0)
> -               goto fail_wiphy_register;
> -
>         /*
>          * We use the number of queues for feature tests (QoS, HT) internally
>          * so restrict them appropriately.
> @@ -1207,6 +1203,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>                 goto fail_rate;
>         }
>
> +       rtnl_unlock();
> +
>         if (local->rate_ctrl) {
>                 clear_bit(IEEE80211_HW_SUPPORTS_VHT_EXT_NSS_BW, hw->flags);
>                 if (local->rate_ctrl->ops->capa & RATE_CTRL_CAPA_VHT_EXT_NSS_BW)
> @@ -1254,6 +1252,12 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>                 local->sband_allocated |= BIT(band);
>         }
>
> +       result = wiphy_register(local->hw.wiphy);
> +       if (result < 0)
> +               goto fail_wiphy_register;
> +
> +       rtnl_lock();
> +
>         /* add one default STA interface if supported */
>         if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_STATION) &&
>             !ieee80211_hw_check(hw, NO_AUTO_VIF)) {
> @@ -1293,6 +1297,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>  #if defined(CONFIG_INET) || defined(CONFIG_IPV6)
>   fail_ifa:
>  #endif
> +       wiphy_unregister(local->hw.wiphy);
> + fail_wiphy_register:
>         rtnl_lock();
>         rate_control_deinitialize(local);
>         ieee80211_remove_interfaces(local);
> @@ -1302,8 +1308,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>         ieee80211_led_exit(local);
>         destroy_workqueue(local->workqueue);
>   fail_workqueue:
> -       wiphy_unregister(local->hw.wiphy);
> - fail_wiphy_register:
>         if (local->wiphy_ciphers_allocated)
>                 kfree(local->hw.wiphy->cipher_suites);
>         kfree(local->int_scan_req);
> @@ -1353,8 +1357,8 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
>         skb_queue_purge(&local->skb_queue_unreliable);
>         skb_queue_purge(&local->skb_queue_tdls_chsw);
>
> -       destroy_workqueue(local->workqueue);
>         wiphy_unregister(local->hw.wiphy);
> +       destroy_workqueue(local->workqueue);
>         ieee80211_led_exit(local);
>         kfree(local->int_scan_req);
>  }
> --
> 2.7.4
>


-- 
Thanks,
Regards,
Chaitanya T K.
