Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 614983B0B0E
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 19:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbhFVRHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 13:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbhFVRHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 13:07:17 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D24C061574;
        Tue, 22 Jun 2021 10:05:00 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id i18so2654005lfl.8;
        Tue, 22 Jun 2021 10:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NBaVKh//UBK86ei/ihMVSpRaGro+bbIBNKf8M+UWoSU=;
        b=E2vb7roau0C7BTR7oK+h6mzoZj29nL9xbTfPuDXTHqXcx6YqCFiL5LPJ+fztcRznNS
         0Oqn/AZEyXS8YSCKtTy9pxGaJbTEg5Z/yF7rb3AApGr+IgnLL7KnAKjQORBk5j4VPGaJ
         HjZbe1gMhixpMuNFCEJCYeZI4hG71OVwBm33/lgdWcspE+JqMRSmKqG6lyAiJOa+a4Qm
         4g5OAMk1z6J6cNTGX+Nn1JpjO8jneTL9YeiZszWsHJKhpK7K14ha4gCkmNt9b4JnNCtC
         Nj+Ix0a6HX5RYeh9CFfFNOz1OaASLluFUQhQxAjUgvqScwTtOotAHHXJ+v/wthojMMmw
         C9Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NBaVKh//UBK86ei/ihMVSpRaGro+bbIBNKf8M+UWoSU=;
        b=fF75vlinH44iFJdkWKj34OObWQ2E48tqlnCCrNfwcSfaiS5w1wiEZ+YzAAJqZzz0mw
         UQdrcdwPcJERMY3x+6w0d34pRjrEq36LPbCTmW+fXjLen3C2sDpxJI7FKPtPA2dT8IxX
         PXEbhlVu15GveK8uZTpMlBU02Ns/eg0ZX7ja68yzQE93x6ptNjgmlRNG1sZROwdtCgzb
         lX4h6c9/oaM+gn1PUhj0D0+A5KX9t3R62o+8NERf5KG7p+b+3jpF0t5/qJ0ozoDK3laF
         XcxBdanOe3IvZjGGdojmir6AvJX2af/MXaC7bHJfk0clqawaLXDBiXYitfOLJ1gAaB41
         5njg==
X-Gm-Message-State: AOAM5312P5Hc4DPI9D2A5pLZeivWE8i3UMUX6ZddLtiQ0Pa2hZ6+1N9m
        rt+6MVwZz1+aH+Ua29fYLVQdvwsKjc8=
X-Google-Smtp-Source: ABdhPJySvrS5m3qwSF4dDWl41T7s3Pp8EG9q72romII/dp5ivI+YzoMtXH/sKuSd7bQ/9u19XzHZ7Q==
X-Received: by 2002:ac2:48ba:: with SMTP id u26mr99785lfg.77.1624381497964;
        Tue, 22 Jun 2021 10:04:57 -0700 (PDT)
Received: from [192.168.2.145] (94-29-29-31.dynamic.spd-mgts.ru. [94.29.29.31])
        by smtp.googlemail.com with ESMTPSA id f15sm1332280lfa.56.2021.06.22.10.04.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 10:04:57 -0700 (PDT)
Subject: Re: [BUG] brcmfmac locks up on resume from suspend
From:   Dmitry Osipenko <digetx@gmail.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <b853d145-0edf-db0a-ff42-065011f7a149@gmail.com>
Message-ID: <0a29dbcc-7ab6-bc5d-3d42-4e1a33c2f6ec@gmail.com>
Date:   Tue, 22 Jun 2021 20:04:56 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <b853d145-0edf-db0a-ff42-065011f7a149@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

18.06.2021 23:36, Dmitry Osipenko пишет:
> Hi,
> 
> I'm getting a hang on resume from suspend using today's next-20210618.
> It's tested on Tegra20 Acer A500 that has older BCM4329, but seems the
> problem is generic.
> 
> There is this line in pstore log:
> 
>   ieee80211 phy0: brcmf_netdev_start_xmit: xmit rejected state=0
> 
> Steps to reproduce:
> 
> 1. Boot system
> 2. Connect WiFi
> 3. Run "rtcwake -s10 -mmem"
> 
> What's interesting is that turning WiFi off/on before suspending makes
> resume to work and there are no suspicious messages in KMSG, all further
> resumes work too.
> 
> This change fixes the hang:
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> index db5f8535fdb5..06d16f7776c7 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> @@ -301,7 +301,6 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct
> sk_buff *skb,
>  	/* Can the device send data? */
>  	if (drvr->bus_if->state != BRCMF_BUS_UP) {
>  		bphy_err(drvr, "xmit rejected state=%d\n", drvr->bus_if->state);
> -		netif_stop_queue(ndev);
>  		dev_kfree_skb(skb);
>  		ret = -ENODEV;
>  		goto done;
> 8<---
> 
> Comments? Suggestions? Thanks in advance.
> 

Update:

After some more testing I found that the removal of netif_stop_queue() doesn't really help, apparently it was a coincidence.

I enabled CONFIG_BRCMDBG and added dump_stack() to the error condition of brcmf_netdev_start_xmit() and this is what it shows:

PM: suspend entry (s2idle)
Filesystems sync: 0.000 seconds
Freezing user space processes ... (elapsed 0.004 seconds) done.
OOM killer disabled.
Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
brcmfmac: brcmf_cfg80211_disconnect Enter. Reason code = 3
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmutil: Tx Frame:
00000000: 28 00 d7 ff d1 00 00 0c 00 00 00 00 34 00 00 00  (...........4...
00000010: 0c 00 00 00 02 00 ca 00 00 00 00 00 03 00 00 00  ................
00000020: 10 7b 44 3b 36 98 31 c2                          .{D;6.1.
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmfmac: brcmf_sdio_isr Enter
brcmutil: RxHdr:
00000000: 28 00 d7 ff b9 00 00 0c 00 d8 00 00              (...........
brcmutil: RxCtrl:
00000000: 28 00 d7 ff b9 00 00 0c 00 d8 00 00 34 00 00 00  (...........4...
00000010: 0c 00 00 00 00 00 ca 00 00 00 00 00 03 00 00 00  ................
00000020: 10 7b 44 3b 36 98 31 c2                          .{D;6.1.
brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 28 expected 28
brcmutil: RxHdr:
00000000: 5c 00 a3 ff ba 01 06 0e 00 d8 00 00              \...........
brcmfmac: brcmf_cfg80211_disconnect Exit
brcmfmac: brcmf_cfg80211_del_key Enter
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmutil: Rx Data:
00000000: 5c 00 a3 ff ba 01 06 0e 00 d8 00 00 00 00 20 00  \............. .
00000010: 00 00 e0 b9 a5 4d 8a 60 e2 b9 a5 4d 8a 60 88 6c  .....M.`...M.`.l
00000020: 80 01 00 68 00 00 10 18 00 01 00 02 00 00 00 00  ...h............
00000030: 00 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000040: 00 00 10 7b 44 3b 36 98 77 6c 30 00 00 00 00 00  ...{D;6.wl0.....
00000050: 00 00 00 00 00 00 00 00 00 00 00 00              ............
brcmfmac: brcmf_fws_hdrpull enter: ifidx 0, skblen 74, sig 0
brcmutil: Rx Data:
00000000: 5c 00 a3 ff bb 01 06 0e 00 d8 00 00 00 00 20 00  \............. .
00000010: 00 00 e0 b9 a5 4d 8a 60 e2 b9 a5 4d 8a 60 88 6c  .....M.`...M.`.l
00000020: 80 01 00 68 00 00 10 18 00 01 00 02 00 18 00 00  ...h............
00000030: 00 05 00 00 00 00 00 00 00 07 00 00 00 00 00 00  ................
00000040: 00 00 10 7b 44 3b 36 98 77 6c 30 00 00 00 00 00  ...{D;6.wl0.....
00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
brcmfmac: brcmf_fws_hdrpull enter: ifidx 0, skblen 78, sig 0
brcmutil: Rx Data:
00000000: 5c 00 a3 ff bc 01 06 0e 00 d8 00 00 00 00 20 00  \............. .
00000010: 00 00 e0 b9 a5 4d 8a 60 e2 b9 a5 4d 8a 60 88 6c  .....M.`...M.`.l
00000020: 80 01 00 68 00 00 10 18 00 01 00 02 00 18 00 00  ...h............
00000030: 00 05 00 00 00 00 00 00 00 07 00 00 00 00 00 00  ................
00000040: 00 00 10 7b 44 3b 36 98 77 6c 30 00 00 00 00 00  ...{D;6.wl0.....
00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
brcmfmac: brcmf_fws_hdrpull enter: ifidx 0, skblen 78, sig 0
brcmutil: Rx Data:
00000000: 5c 00 a3 ff bd 01 06 0e 00 d8 00 00 00 00 20 00  \............. .
00000010: 00 00 e0 b9 a5 4d 8a 60 e2 b9 a5 4d 8a 60 88 6c  .....M.`...M.`.l
00000020: 80 01 00 68 00 00 10 18 00 01 00 02 00 18 00 00  ...h............
00000030: 00 05 00 00 00 00 00 00 00 07 00 00 00 00 00 00  ................
00000040: 00 00 10 7b 44 3b 36 98 77 6c 30 00 00 00 00 00  ...{D;6.wl0.....
00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
brcmfmac: brcmf_fws_hdrpull enter: ifidx 0, skblen 78, sig 0
brcmutil: Rx Data:
00000000: 5c 00 a3 ff be 01 06 0e 00 d8 00 00 00 00 20 00  \............. .
00000010: 00 00 e0 b9 a5 4d 8a 60 e2 b9 a5 4d 8a 60 88 6c  .....M.`...M.`.l
00000020: 80 01 00 68 00 00 10 18 00 01 00 02 00 18 00 00  ...h............
00000030: 00 05 00 00 00 00 00 00 00 07 00 00 00 00 00 00  ................
00000040: 00 00 10 7b 44 3b 36 98 77 6c 30 00 00 00 00 00  ...{D;6.wl0.....
00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
brcmfmac: brcmf_fws_hdrpull enter: ifidx 0, skblen 78, sig 0
brcmutil: Rx Data:
00000000: 5c 00 a3 ff bf 01 06 0e 00 d8 00 00 00 00 20 00  \............. .
00000010: 00 00 e0 b9 a5 4d 8a 60 e2 b9 a5 4d 8a 60 88 6c  .....M.`...M.`.l
00000020: 80 01 00 68 00 00 10 18 00 01 00 02 00 18 00 00  ...h............
00000030: 00 05 00 00 00 00 00 00 00 07 00 00 00 00 00 00  ................
00000040: 00 00 10 7b 44 3b 36 98 77 6c 30 00 00 00 00 00  ...{D;6.wl0.....
00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
brcmfmac: brcmf_fws_hdrpull enter: ifidx 0, skblen 78, sig 0
brcmutil: Rx Data:
00000000: 5c 00 a3 ff c0 01 00 0e 00 d8 00 00 00 00 20 00  \............. .
00000010: 00 00 e0 b9 a5 4d 8a 60 e2 b9 a5 4d 8a 60 88 6c  .....M.`...M.`.l
00000020: 80 01 00 68 00 00 10 18 00 01 00 02 00 18 00 00  ...h............
00000030: 00 05 00 00 00 00 00 00 00 07 00 00 00 00 00 00  ................
00000040: 00 00 10 7b 44 3b 36 98 77 6c 30 00 00 00 00 00  ...{D;6.wl0.....
00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
brcmfmac: brcmf_fws_hdrpull enter: ifidx 0, skblen 78, sig 0
brcmutil: RxHdr:
00000000: 5c 00 a3 ff c1 01 00 0e 00 d8 00 00              \...........
brcmutil: Rx Data:
00000000: 5c 00 a3 ff c1 01 00 0e 00 d8 00 00 00 00 20 00  \............. .
00000010: 00 00 e0 b9 a5 4d 8a 60 e2 b9 a5 4d 8a 60 88 6c  .....M.`...M.`.l
00000020: 80 01 00 68 00 00 10 18 00 01 00 02 00 18 00 00  ...h............
00000030: 00 05 00 00 00 00 00 00 00 07 00 00 00 00 00 00  ................
00000040: 00 00 10 7b 44 3b 36 98 77 6c 30 00 00 00 00 00  ...{D;6.wl0.....
00000050: 00 00 00 00 00 00 00 00 00 00 00 00              ............
brcmfmac: brcmf_fws_hdrpull enter: ifidx 0, skblen 74, sig 0
brcmutil: RxHdr:
00000000: 00 00 00 00 00 00 00 00 00 00 00 00              ............
brcmfmac: brcmf_sdio_readframes processed 9 frames
brcmfmac: brcmf_sdio_isr Enter
brcmutil: Tx Frame:
00000000: c9 00 36 ff d2 00 00 0c 00 00 00 00 07 01 00 00  ..6.............
00000010: ad 00 00 00 02 00 cb 00 00 00 00 00 77 73 65 63  ............wsec
00000020: 5f 6b 65 79 00 00 00 00 00 00 00 00 00 00 00 00  _key............
[cut]
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmutil: RxHdr:
00000000: c9 00 36 ff c2 00 00 0c 00 d9 00 00              ..6.........
brcmutil: RxCtrl:
00000000: c9 00 36 ff c2 00 00 0c 00 d9 00 00 07 01 00 00  ..6.............
00000010: ad 00 00 00 00 00 cb 00 00 00 00 00 77 73 65 63  ............wsec
00000020: 5f 6b 65 79 00 00 00 00 00 00 00 00 00 00 00 00  _key............
[cut]
brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 189 expected 189
brcmfmac: brcmf_cfg80211_del_key Exit
brcmfmac: brcmf_cfg80211_del_key Enter
brcmfmac: brcmf_cfg80211_del_key Enter
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmutil: RxHdr:
00000000: 00 00 00 00 00 00 00 00 00 00 00 00              ............
brcmfmac: brcmf_sdio_readframes processed 1 frames
brcmutil: Tx Frame:
00000000: c9 00 36 ff d3 00 00 0c 00 00 00 00 07 01 00 00  ..6.............
00000010: ad 00 00 00 02 00 cc 00 00 00 00 00 77 73 65 63  ............wsec
00000020: 5f 6b 65 79 00 02 00 00 00 00 00 00 00 00 00 00  _key............
[cut]
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmutil: RxHdr:
00000000: c9 00 36 ff c3 00 00 0c 00 da 00 00              ..6.........
brcmutil: RxCtrl:
00000000: c9 00 36 ff c3 00 00 0c 00 da 00 00 07 01 00 00  ..6.............
00000010: ad 00 00 00 00 00 cc 00 00 00 00 00 77 73 65 63  ............wsec
00000020: 5f 6b 65 79 00 02 00 00 00 00 00 00 00 00 00 00  _key............
[cut]
brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 189 expected 189
brcmutil: RxHdr:
brcmfmac: brcmf_cfg80211_del_key Exit
00000000: 00 00 00 00 00 00 00 00 00 00 00 00              ............
brcmfmac: brcmf_cfg80211_del_key Enter
brcmfmac: brcmf_cfg80211_del_key Enter
brcmfmac: brcmf_sdio_readframes processed 1 frames
brcmfmac: brcmf_cfg80211_del_key Enter
brcmfmac: brcmf_cfg80211_suspend Enter
brcmfmac: brcmf_pno_stop_sched_scan reqid=0
brcmfmac: brcmf_link_down Enter
brcmfmac: brcmf_btcoex_set_mode DHCP session ends
brcmfmac: brcmf_link_down Exit
brcmfmac: brcmf_sdio_bus_watchdog Enter
brcmfmac: brcmf_sdio_bus_watchdog Enter
brcmfmac: brcmf_sdio_bus_txctl Enter
brcmutil: Tx Frame:
00000000: 24 00 db ff d4 00 00 0c 00 00 00 00 07 01 00 00  $...............
00000010: 08 00 00 00 02 00 cd 00 00 00 00 00 6d 70 63 00  ............mpc.
00000020: 01 00 00 00                                      ....
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdio_bus_rxctl Enter
brcmutil: RxHdr:
00000000: 24 00 db ff c4 00 00 0c 00 db 00 00              $...........
brcmutil: RxCtrl:
00000000: 24 00 db ff c4 00 00 0c 00 db 00 00 07 01 00 00  $...............
00000010: 08 00 00 00 00 00 cd 00 00 00 00 00 6d 70 63 00  ............mpc.
00000020: 01 00 00 00                                      ....
brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 24 expected 24
brcmfmac: brcmf_set_mpc MPC : 1
brcmfmac: brcmf_cfg80211_suspend Exit
brcmutil: RxHdr:
00000000: 00 00 00 00 00 00 00 00 00 00 00 00              ............
brcmfmac: brcmf_sdio_readframes processed 1 frames
brcmfmac: brcmf_sdiod_change_state 1 -> 0
brcmfmac: brcmf_bus_change_state 1 -> 0
brcmfmac: brcmf_netdev_start_xmit Enter, bsscfgidx=0
CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W         5.13.0-rc7-next-20210622-00178-g74f7ad03c152-dirty #8227
Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
[<c010ccf5>] (unwind_backtrace) from [<c0108fd5>] (show_stack+0x11/0x14)
[<c0108fd5>] (show_stack) from [<c0a6d327>] (dump_stack_lvl+0x7f/0x8c)
[<c0a6d327>] (dump_stack_lvl) from [<c065ce17>] (brcmf_netdev_start_xmit+0x1d7/0x254)
[<c065ce17>] (brcmf_netdev_start_xmit) from [<c0817e8b>] (dev_hard_start_xmit+0xbb/0x1ec)
[<c0817e8b>] (dev_hard_start_xmit) from [<c0849bef>] (sch_direct_xmit+0xab/0x1f0)
[<c0849bef>] (sch_direct_xmit) from [<c0849e33>] (__qdisc_run+0xff/0x4cc)
[<c0849e33>] (__qdisc_run) from [<c0818461>] (__dev_queue_xmit+0x419/0x690)
[<c0818461>] (__dev_queue_xmit) from [<c08973eb>] (ip_finish_output2+0x1c3/0x480)
[<c08973eb>] (ip_finish_output2) from [<c0898f39>] (__ip_queue_xmit+0xfd/0x2f8)
[<c0898f39>] (__ip_queue_xmit) from [<c08b0483>] (__tcp_transmit_skb+0x3f7/0x8ec)
[<c08b0483>] (__tcp_transmit_skb) from [<c08b13d5>] (tcp_xmit_probe_skb+0x9d/0xa8)
[<c08b13d5>] (tcp_xmit_probe_skb) from [<c08b3c87>] (tcp_keepalive_timer+0x10f/0x1f0)
[<c08b3c87>] (tcp_keepalive_timer) from [<c0185695>] (call_timer_fn+0x31/0x160)
[<c0185695>] (call_timer_fn) from [<c018593f>] (__run_timers.part.0+0x17b/0x228)
[<c018593f>] (__run_timers.part.0) from [<c0185a1b>] (run_timer_softirq+0x2f/0x50)
[<c0185a1b>] (run_timer_softirq) from [<c01013ab>] (__do_softirq+0xd3/0x2ec)
[<c01013ab>] (__do_softirq) from [<c01251d3>] (irq_exit+0xab/0xb8)
[<c01251d3>] (irq_exit) from [<c016e31d>] (handle_domain_irq+0x45/0x60)
[<c016e31d>] (handle_domain_irq) from [<c04c4a83>] (gic_handle_irq+0x6b/0x7c)
[<c04c4a83>] (gic_handle_irq) from [<c0100b65>] (__irq_svc+0x65/0xac)
Exception stack(0xc1201ed0 to 0xc1201f18)
1ec0:                                     00000000 00000000 2e4fd000 00000060
1ee0: 00000000 c13240a8 78813f98 ef6949f8 00000000 00000024 00000000 00000024
1f00: 02da3104 c1201f20 c074e015 c074e094 60010133 ffffffff
[<c0100b65>] (__irq_svc) from [<c074e094>] (cpuidle_enter_state+0x1ac/0x360)
[<c074e094>] (cpuidle_enter_state) from [<c074e297>] (cpuidle_enter+0x3b/0x3c)
[<c074e297>] (cpuidle_enter) from [<c014b6e1>] (do_idle+0x109/0x204)
[<c014b6e1>] (do_idle) from [<c014ba75>] (cpu_startup_entry+0x19/0x1c)
[<c014ba75>] (cpu_startup_entry) from [<c1101033>] (start_kernel+0x70b/0x734)
ieee80211 phy0: brcmf_netdev_start_xmit: xmit rejected state=0
brcmfmac: brcmf_cfg80211_resume Enter
brcmfmac: brcmf_sdio_isr Enter
brcmfmac: brcmf_sdiod_change_state 0 -> 1
brcmfmac: brcmf_bus_change_state 0 -> 1
brcmfmac: brcmf_sdio_bus_watchdog Enter
brcmfmac: brcmf_sdio_bus_watchdog Enter
OOM killer enabled.
Restarting tasks ... done.
brcmfmac: brcmf_cfg80211_dump_station Enter, idx 0
PM: suspend exit
