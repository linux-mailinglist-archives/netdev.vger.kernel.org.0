Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72EE15425C8
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245638AbiFHBUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 21:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1586177AbiFGXuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 19:50:51 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7932E43B4;
        Tue,  7 Jun 2022 15:06:28 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id m20so37807645ejj.10;
        Tue, 07 Jun 2022 15:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ALd0eOORSOPkFVDrzHX6x7yxY/dHxk/oAxZcRLZpKk8=;
        b=Ju0rSQOF4ohU1iMi2o5c94qKHMnjUgxcFGRMOI/OIBoiHhfHMwSiUkh7r+fPpagtFq
         /3QWMmCORHVnxrVWROQOfvOuEpJHi9I1whS1eolI/rQr9vEAbKfsazjkfaBci94ts62/
         NFZArgHXsDQEgCJ9vfl0dqAqt5mWIlt3qVxmHA840maUWKJmnfoiUa9XCxI2kW+25se/
         RIajjfSZkUs4GlB3VD3fPxK733ckd6IyGUt1SOBVDkqABgt3PtNAcQ2A3zTxCbugXkfZ
         Ki8LZ2cD8iNnGey0em0VqQYggZwSbpht3fpvDZPsb1V/doO3pOGck9G7ChImMXDb3zZG
         A1Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ALd0eOORSOPkFVDrzHX6x7yxY/dHxk/oAxZcRLZpKk8=;
        b=502yb6/YGobL6mFMzzHxHigMjvqi6c6nGwdyCGt4MSgpqrEIaI2Tf1dn49gcWQCxaq
         x5u70fKRxKqv8OVnre8Agtf34+gwKI6+6aHxTBgffMV9P0jqlcoQuBxsXB6uA8NuWiE5
         6AsWNqZhHdxu4TY8/6ReT0o1rIdlj96EnekNoSd8+KAJKOTS6eT/ei2I/njLj+60FWhV
         ibAnBUxwCSk9746bXmAHXvYnMTTrMII9UfnUc3EO1PMjekToQhiCzDANmvhGTxLFVUS0
         04i471PvD3GSu5gzAAROuw3VTtlWnPxudBNIMlMfW2MY9VP4QnLAA2sv62kjMno1lxVU
         cdFg==
X-Gm-Message-State: AOAM5321qodYzYN3VpmF6w5RWK6SOckgNl5tdBCDQWQYfjEAxPYUrwhw
        7QR5Y/DjlSSemONUCCwPSmhozB7P9obgseOtvG0=
X-Google-Smtp-Source: ABdhPJxXaHUQ1t3Fs2bSMI3+q6sxcHm8rkhZ9MBNJzCeoX+bDvFVR+JvWTugFFPoWKkVMocln9rP5ok83qFIjfh1Fus=
X-Received: by 2002:a17:907:72cf:b0:6ff:4607:1bf with SMTP id
 du15-20020a17090772cf00b006ff460701bfmr30230387ejc.649.1654639586442; Tue, 07
 Jun 2022 15:06:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220530135457.1104091-1-s.hauer@pengutronix.de> <20220530135457.1104091-6-s.hauer@pengutronix.de>
In-Reply-To: <20220530135457.1104091-6-s.hauer@pengutronix.de>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Wed, 8 Jun 2022 00:06:15 +0200
Message-ID: <CAFBinCDgErZzFs5NiDT0JAOhziz5WLiy0+yxF9Z-kXPxD1j8Dw@mail.gmail.com>
Subject: Re: [PATCH v2 05/10] rtw88: iterate over vif/sta list non-atomically
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     linux-wireless@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sascha,

thanks for this patch!

On Mon, May 30, 2022 at 3:55 PM Sascha Hauer <s.hauer@pengutronix.de> wrote:
[...]
>  drivers/net/wireless/realtek/rtw88/phy.c  |   6 +-
>  drivers/net/wireless/realtek/rtw88/ps.c   |   2 +-
>  drivers/net/wireless/realtek/rtw88/util.c | 103 ++++++++++++++++++++++
>  drivers/net/wireless/realtek/rtw88/util.h |  12 ++-
>  4 files changed, 116 insertions(+), 7 deletions(-)
I compared the changes from this patch with my earlier work. I would
like to highlight a few functions to understand if they were left out
on purpose or by accident.

__fw_recovery_work() in main.c (unfortunately I am not sure how to
trigger/test this "firmware recovery" logic):
- this is already called with &rtwdev->mutex held
- it uses rtw_iterate_keys_rcu() (which internally uses rtw_write32
from rtw_sec_clear_cam). feel free to either add [0] to your series or
even squash it into an existing patch
- it uses rtw_iterate_stas_atomic() (which internally uses
rtw_fw_send_h2c_command from rtw_fw_media_status_report)
- it uses rtw_iterate_vifs_atomic() (which internally can read/write
registers from rtw_chip_config_bfee)
- in my previous series I simply replaced the
rtw_iterate_stas_atomic() and rtw_iterate_vifs_atomic() calls with the
non-atomic variants (for the rtw_iterate_keys_rcu() call I did some
extra cleanup, see [0])

rtw_wow_fw_media_status() in wow.c (unfortunately I am also not sure
how to test WoWLAN):
- I am not sure if &rtwdev->mutex is held when this function is called
- it uses rtw_iterate_stas_atomic() (which internally uses
rtw_fw_send_h2c_command from rtw_fw_media_status_report)
- in my previous series I simply replaced rtw_iterate_stas_atomic()
with it's non-atomic variant

Additionally I rebased my SDIO work on top of your USB series.
This makes SDIO support a lot easier - so thank you for your work!
I found that three of my previous patches (in addition to [0] which I
already mentioned earlier) are still needed to get rid of some
warnings when using the SDIO interface (the same warnings may or may
not be there with the USB interface - it just depends on whether your
AP makes rtw88 hit that specific code-path):
- [1]: rtw88: Configure the registers from rtw_bf_assoc() outside the RCU lock
- [2]: rtw88: Move rtw_chip_cfg_csi_rate() out of rtw_vif_watch_dog_iter()
- [3]: rtw88: Move rtw_update_sta_info() out of rtw_ra_mask_info_update_iter()

These three patches are freshly rebased to apply on top of your series.
If you (or Ping-Ke) think those are needed for USB support then please
feel free to include them in your series, squash them into one of your
patches or just ask me to send them as an individual series)

I am running out of time for today. I'll be able to continue on this
later this week/during the weekend.


Best regards,
Martin


[0] https://lore.kernel.org/all/20220108005533.947787-6-martin.blumenstingl@googlemail.com/
[1] https://github.com/xdarklight/linux/commit/420bb40511151fbc9f5447aced4fde3a7bb0566b.patch
[2] https://github.com/xdarklight/linux/commit/cc08cc8fb697157b99304ad3ec89b1cca0900697.patch
[3] https://github.com/xdarklight/linux/commit/5db636e3035a425e104fba7983301b0085366268.patch
