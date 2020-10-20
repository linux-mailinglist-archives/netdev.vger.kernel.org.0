Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0AA2935A3
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 09:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404944AbgJTHT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 03:19:28 -0400
Received: from mx3.wp.pl ([212.77.101.9]:58934 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730758AbgJTHT1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 03:19:27 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Oct 2020 03:19:25 EDT
Received: (wp-smtpd smtp.wp.pl 23164 invoked from network); 20 Oct 2020 09:12:44 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1603177964; bh=bKNUhCp6Y3F9Grr1XEkYQ03EStU0/rfn+PwEs2KyPKA=;
          h=From:To:Cc:Subject;
          b=c+EQ7Y0LEOD6Pr/K1g9JrE43o4R2TECEMP0WOLIOL9WwxeQyHrTeUT8tKaMdlokqB
           O198Pebob99V7btr1P/FtqqI3RYIqXjGFb7i8ChjwBd2F/9HCHsYTPcVyKMvvKwEzn
           JNnbonHnv/mqMabP2lgVmuPjAuNZotNN/bTrn/Bs=
Received: from ip4-46-39-164-203.cust.nbox.cz (HELO localhost) (stf_xl@wp.pl@[46.39.164.203])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <markov.mikhail@itmh.ru>; 20 Oct 2020 09:12:44 +0200
Date:   Tue, 20 Oct 2020 09:12:43 +0200
From:   Stanislaw Gruszka <stf_xl@wp.pl>
To:     =?utf-8?B?0JzQsNGA0LrQvtCyINCc0LjRhdCw0LjQuyDQkNC70LXQutGB0LDQvdC00YA=?=
         =?utf-8?B?0L7QstC40Yc=?= <markov.mikhail@itmh.ru>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "\"David S. Miller\"" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "illumin@yandex.ru" <illumin@yandex.ru>
Subject: Re: [PATCH] rt2x00: save survey for every channel visited
Message-ID: <20201020071243.GA302394@wp.pl>
References: <1603134408870.78805@itmh.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1603134408870.78805@itmh.ru>
X-WP-MailID: 7f530163ad75dcce13db46f787cfd916
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000002 [YeH0]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 07:06:47PM +0000, Марков Михаил Александрович wrote:
> rt2800 only gives you survey for current channel.
<snip>
>      .watchdog        = rt2800_watchdog,
> +    .update_survey        = rt2800_update_survey,

Since this feature is rt2800 specific, I would do not add new generic
callback. It could be fully done in rt2800* code, i.e ...

> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> index 8c6d3099b19d..8eff57132154 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> @@ -1026,6 +1026,12 @@ static int rt2x00lib_probe_hw_modes(struct rt2x00_dev *rt2x00dev,
>      if (!rates)
>          goto exit_free_channels;
> 
> +    rt2x00dev->chan_survey =
> +        kcalloc(spec->num_channels, sizeof(struct rt2x00_chan_survey),
> +            GFP_KERNEL);
> +    if (!rt2x00dev->chan_survey)
> +        goto exit_free_rates;
... this could be placed in rt2800_probe_hw_mode() just after
channel info array allocation ... 

> @@ -316,6 +316,15 @@ int rt2x00mac_config(struct ieee80211_hw *hw, u32 changed)
>      if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
>          return 0;
> 
> +    /*
> +     * To provide correct survey data for survey-based ACS algorithm
> +     * we have to save survey data for current channel before switching.
> +     */
> +    if (rt2x00dev->ops->lib->update_survey &&
> +        (changed & IEEE80211_CONF_CHANGE_CHANNEL)) {
... and this in rt2800_config()

Thanks
Stanislaw
