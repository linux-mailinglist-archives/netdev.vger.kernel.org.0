Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8EB18696
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 10:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbfEIILj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 04:11:39 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33373 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbfEIILh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 04:11:37 -0400
Received: by mail-qk1-f195.google.com with SMTP id k189so946747qkc.0
        for <netdev@vger.kernel.org>; Thu, 09 May 2019 01:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MZ9j8DW6C0QPBPihBypnn3DlkomTOJO7L08Uqx5vJYU=;
        b=HHGeg5nTEZtwEihgdWHuHLbrIH9mh0jmv2zT7N0nIbOS1yqrPGZ2oFF/SS3Mfox+Ua
         kEE3TnCfDG6KOYuxxu41TjHEZcHan75RCtjB4NNkc5SbI/60fMcRJD8xAWPNyn0N7zRg
         bZrLmt53b43Ac/AXmG3idX2X83a6knJF3Y41TYfk7LqV+JHK7pHRPI/VKXw2hqmJtwaM
         7+5Pripdq3aP16Kxu8SYSw1phMZpr9uBzFEYRIN2vMB5Z00zQQ+Cb/I/SqhG/D/T3pFP
         ct9nyhk/MCwyWZttZ2Hv2IYBdLBJAfEfi2cljj2ixY4Rb27iULi317KtEKem1Hy3vzT2
         OU5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MZ9j8DW6C0QPBPihBypnn3DlkomTOJO7L08Uqx5vJYU=;
        b=OCFMA+pXemapTd1+Ae9J/IEuOA3nNPcPKabtoqPrk2w6frG0CfO6+ETK+C53A5DXYZ
         IGXm7Ax3S3z2S/T0KcAAqvg2BBrKQv4eInMMCPRVCzBr9qQ9kA9ogEJO8UEWD998DRPG
         tXZfJeeV4Hh32gvvvEzMb+Pt34XSaHHmvrRXxmIECGhmx+rFV0ae/7zUvG4p0SEfidkn
         AUU9l5NDGxMYd0exiKUtugh80F6OkqPExhNoc25sBipwabl7hy0Snt9/q/2S7/BpVUpJ
         Wyxl0NFtV0Q13IBIl2HwsO/J3WPD6RA6RJE5EQ91Sues2PqZ/YS687CDWlgHu0akesuK
         DapQ==
X-Gm-Message-State: APjAAAUoQZ/bT2zW7CEkvuh34muIWRfQtrfcInoT5A5lk/cv46ltr1ya
        bfFRwKdiPZK8MJRMOKjnLrfccK2jH2JaTCbxF5l1+Q==
X-Google-Smtp-Source: APXvYqxWvqXBsvrh/XSSgmp5AEHQq9IidEJZXlP3PpzWVoV6Col2TMUYGWzcFEYtr9kCGTdGZaUw1Q7Ip/ofVuVlSz8=
X-Received: by 2002:ae9:dcc3:: with SMTP id q186mr2136160qkf.114.1557389496781;
 Thu, 09 May 2019 01:11:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190503072146.49999-1-chiu@endlessm.com> <20190503072146.49999-2-chiu@endlessm.com>
In-Reply-To: <20190503072146.49999-2-chiu@endlessm.com>
From:   Daniel Drake <drake@endlessm.com>
Date:   Thu, 9 May 2019 16:11:25 +0800
Message-ID: <CAD8Lp45WmPz2c+OnszFyaRL=veF0avEffwv3muwXNoeLcE0fhw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] rtl8xxxu: Add rate adaptive related data
To:     Chris Chiu <chiu@endlessm.com>
Cc:     jes.sorensen@gmail.com, Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chris,

Thanks for this! Some suggestions below, although let me know if any
don't make sense.

On Fri, May 3, 2019 at 3:22 PM Chris Chiu <chiu@endlessm.com> wrote:
>
> Add wireless mode, signal strength level, and rate table index
> to tell the firmware that we need to adjust the tx rate bitmap
> accordingly.
> ---
>  .../net/wireless/realtek/rtl8xxxu/rtl8xxxu.h  | 45 +++++++++++++++++++
>  .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 45 ++++++++++++++++++-
>  2 files changed, 89 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> index 8828baf26e7b..771f58aa7cae 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> @@ -1195,6 +1195,50 @@ struct rtl8723bu_c2h {
>
>  struct rtl8xxxu_fileops;
>
> +/*mlme related.*/
> +enum wireless_mode {
> +       WIRELESS_MODE_UNKNOWN = 0,
> +       //Sub-Element

Run these patches through checkpatch.pl, it'll have some suggestions
to bring the coding style in line, for example not using // style
comments.

> +       WIRELESS_MODE_B = BIT(0), // tx: cck only , rx: cck only, hw: cck
> +       WIRELESS_MODE_G = BIT(1), // tx: ofdm only, rx: ofdm & cck, hw: cck & ofdm
> +       WIRELESS_MODE_A = BIT(2), // tx: ofdm only, rx: ofdm only, hw: ofdm only
> +       WIRELESS_MODE_N_24G = BIT(3), // tx: MCS only, rx: MCS & cck, hw: MCS & cck
> +       WIRELESS_MODE_N_5G = BIT(4), // tx: MCS only, rx: MCS & ofdm, hw: ofdm only
> +       WIRELESS_AUTO = BIT(5),
> +       WIRELESS_MODE_AC = BIT(6),
> +       WIRELESS_MODE_MAX = (WIRELESS_MODE_B|WIRELESS_MODE_G|WIRELESS_MODE_A|WIRELESS_MODE_N_24G|WIRELESS_MODE_N_5G|WIRELESS_MODE_AC),
> +};
> +
> +/* from rtlwifi/wifi.h */
> +enum ratr_table_mode_new {
> +        RATEID_IDX_BGN_40M_2SS = 0,
> +        RATEID_IDX_BGN_40M_1SS = 1,
> +        RATEID_IDX_BGN_20M_2SS_BN = 2,
> +        RATEID_IDX_BGN_20M_1SS_BN = 3,
> +        RATEID_IDX_GN_N2SS = 4,
> +        RATEID_IDX_GN_N1SS = 5,
> +        RATEID_IDX_BG = 6,
> +        RATEID_IDX_G = 7,
> +        RATEID_IDX_B = 8,
> +        RATEID_IDX_VHT_2SS = 9,
> +        RATEID_IDX_VHT_1SS = 10,
> +        RATEID_IDX_MIX1 = 11,
> +        RATEID_IDX_MIX2 = 12,
> +        RATEID_IDX_VHT_3SS = 13,
> +        RATEID_IDX_BGN_3SS = 14,
> +};
> +
> +#define RTL8XXXU_RATR_STA_INIT 0
> +#define RTL8XXXU_RATR_STA_HIGH 1
> +#define RTL8XXXU_RATR_STA_MID  2
> +#define RTL8XXXU_RATR_STA_LOW  3
> +
> +struct rtl8xxxu_rate_adaptive {
> +       u16 wireless_mode;
> +       u8 ratr_index;
> +       u8 rssi_level;          /* INIT, HIGH, MIDDLE, LOW */
> +} __packed;

It would be better/cleaner to avoid storing data in per-device
structures if at all possible.

For wireless_mode, I think you should just call
rtl8xxxu_wireless_mode() every time from rtl8723b_refresh_rate_mask().
The work done there is simple (i.e. it's not expensive to call) and
then we avoid having to store data (which might become stale etc).

For ratr_index, I believe you can just make it a parameter passed to
rtl8xxxu_gen2_update_rate_mask which is the only consumer of this
variable. The two callsites (rtl8xxxu_bss_info_changed and
rtl8723b_refresh_rate_mask) already know which value they want to be
used.

rssi_level is the one that you probably do want to store, since I see
the logic in patch 2 - if the rssi level hasn't changed then you don't
need to set the rate mask again, and that's a good idea since it
reduces bus traffic. You could move this into rtl8xxxu_priv rather
than having its own separate structure.

After making those changes it might even make sense to collapse this
all into a single patch; you can judge!
