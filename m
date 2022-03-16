Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E96E4DB508
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 16:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351104AbiCPPir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 11:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242953AbiCPPio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 11:38:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220F46D1B6;
        Wed, 16 Mar 2022 08:37:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB6B3616E4;
        Wed, 16 Mar 2022 15:37:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0F9C340E9;
        Wed, 16 Mar 2022 15:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647445049;
        bh=68Zz2mmmOY9kRePELD6PjgSej7vxXzhD0fkCtGTg+DA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=vE7HdrWycRkrMGzV0PqWzHlM/0FKnZCzXjRK0AUECKi1xSoiRvIdEfmZcwiUS9KqD
         fUcYj5VQJVnxlz5eX1X8LsVilqyo31MUEkdK/OipBD9CLGyab6blQVfDmq5G5Y1E/Y
         hgq1bRjk3PQAoVaxD6YaTVonN0JyT6XEbYOA+jLL2aFib5x0nhzOYmpdq8XsuEeJyC
         c7BgtbdAbA6EVzBy+ebNofxYzxXLeCJ7t8MsYYCUa6H5FtW5ayQ38RiCAPG/oOlxQo
         Qc1QZ88fYZJqzknFwfShpY87H84869KjDeX/qi1ZWgTc/NJzZqVyHp7LAIjWJ5oiZs
         Pm4hKwr1/FkeA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Chris Chiu <chris.chiu@canonical.com>
Cc:     Jes.Sorensen@gmail.com, davem@davemloft.net, kuba@kernel.org,
        code@reto-schneider.ch, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] rtl8xxxu: fill up txrate info for gen1 chips
References: <20220307125852.13606-1-chris.chiu@canonical.com>
        <20220307125852.13606-3-chris.chiu@canonical.com>
Date:   Wed, 16 Mar 2022 17:37:23 +0200
In-Reply-To: <20220307125852.13606-3-chris.chiu@canonical.com> (Chris Chiu's
        message of "Mon, 7 Mar 2022 20:58:52 +0800")
Message-ID: <87o825x618.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chris Chiu <chris.chiu@canonical.com> writes:

> RTL8188CUS/RTL8192CU(gen1) don't support rate adatptive report hence
> no real txrate info can be retrieved. The vendor driver reports the
> highest rate in HT capabilities from the IEs to avoid empty txrate.
> This commit initiates the txrate information with the highest supported
> rate negotiated with AP. The gen2 chip keeps update the txrate from
> the rate adaptive reports, and gen1 chips at least have non-NULL txrate
> after associated.
>
> Signed-off-by: Chris Chiu <chris.chiu@canonical.com>
> ---
>  .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 59 +++++++++++++++++++
>  1 file changed, 59 insertions(+)
>
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> index d225a1257530..285acf303e3d 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> @@ -4473,6 +4473,35 @@ void rtl8xxxu_gen1_init_aggregation(struct rtl8xxxu_priv *priv)
>  	priv->rx_buf_aggregation = 1;
>  }
>  
> +static struct ieee80211_rate rtl8xxxu_legacy_ratetable[] = {
> +	{.bitrate = 10, .hw_value = 0x00,},
> +	{.bitrate = 20, .hw_value = 0x01,},
> +	{.bitrate = 55, .hw_value = 0x02,},
> +	{.bitrate = 110, .hw_value = 0x03,},
> +	{.bitrate = 60, .hw_value = 0x04,},
> +	{.bitrate = 90, .hw_value = 0x05,},
> +	{.bitrate = 120, .hw_value = 0x06,},
> +	{.bitrate = 180, .hw_value = 0x07,},
> +	{.bitrate = 240, .hw_value = 0x08,},
> +	{.bitrate = 360, .hw_value = 0x09,},
> +	{.bitrate = 480, .hw_value = 0x0a,},
> +	{.bitrate = 540, .hw_value = 0x0b,},
> +};

Should this be static const?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
