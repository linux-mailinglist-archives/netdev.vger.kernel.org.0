Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07DEF6DF641
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 14:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbjDLM4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 08:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231782AbjDLMyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 08:54:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D99C83DF;
        Wed, 12 Apr 2023 05:54:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65CFC62A83;
        Wed, 12 Apr 2023 12:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811C9C4339B;
        Wed, 12 Apr 2023 12:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681303969;
        bh=KqiFgwTO3r1Wlix+jWVSPiLu5zTr8hWhvqhJcS0xuuM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=o0TtL8BXTV3zJ8AUcBYTFqIPf7VGjraRARSJLvU/ryUGByvx8TsJN7lpWK7RI1Mcg
         KLpWRl8PFzJ3Sexk8rQ4/FK6bCW41Y+xurWiO5rXE/ur7kX4e419WcPJjmi5qchV1M
         PjRs+PCZqj6GtPgENJ4V+t4ae7NCKAJo4zCV4hgPRYw2+8U+ea0PX0KtOaoYucRr1/
         scwmHY3D2vhTkDAQfd3Gq2j8dqVkpxKR3g8l4emSKcQYpC6QbGviGZZIk0QjCZIou8
         4ZidJuoSeb7u0AVtgj/TUNvQAZF2O77Or6gtNhityGGv/nzQ4k4i71ju7PSbOT8oOI
         dukdZhKCnAVhA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v5 1/9] wifi: rtw88: Clear RTW_FLAG_POWERON early in
 rtw_mac_power_switch()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230405200729.632435-2-martin.blumenstingl@googlemail.com>
References: <20230405200729.632435-2-martin.blumenstingl@googlemail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Chris Morgan <macromorgan@hotmail.com>,
        Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168130396220.26381.3962423931177985292.kvalo@kernel.org>
Date:   Wed, 12 Apr 2023 12:52:46 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin Blumenstingl <martin.blumenstingl@googlemail.com> wrote:

> The SDIO HCI implementation needs to know when the MAC is powered on.
> This is needed because 32-bit register access has to be split into 4x
> 8-bit register access when the MAC is not fully powered on or while
> powering off. When the MAC is powered on 32-bit register access can be
> used to reduce the number of transfers but splitting into 4x 8-bit
> register access still works in that case.
> 
> During the power on sequence is how RTW_FLAG_POWERON is only set when
> the power on sequence has completed successfully. During power off
> however RTW_FLAG_POWERON is set. This means that the upcoming SDIO HCI
> implementation does not know that it has to use 4x 8-bit register
> accessors. Clear the RTW_FLAG_POWERON flag early when powering off the
> MAC so the whole power off sequence is processed with RTW_FLAG_POWERON
> unset. This will make it possible to use the RTW_FLAG_POWERON flag in
> the upcoming SDIO HCI implementation.
> 
> Note that a failure in rtw_pwr_seq_parser() while applying
> chip->pwr_off_seq can theoretically result in the RTW_FLAG_POWERON
> flag being cleared while the chip is still powered on. However,
> depending on when the failure occurs in the power off sequence the
> chip may be on or off. Even the original approach of clearing
> RTW_FLAG_POWERON only when the power off sequence has been applied
> successfully could end up in some corner case where the chip is
> powered off but RTW_FLAG_POWERON was not cleared.
> 
> Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

9 patches applied to wireless-next.git, thanks.

6a92566088b1 wifi: rtw88: Clear RTW_FLAG_POWERON early in rtw_mac_power_switch()
65371a3f14e7 wifi: rtw88: sdio: Add HCI implementation for SDIO based chipsets
b722e5b130bc wifi: rtw88: mac: Support SDIO specific bits in the power on sequence
a5d25f9ff918 wifi: rtw88: main: Add the {cpwm,rpwm}_addr for SDIO based chipsets
02461d9368c5 wifi: rtw88: main: Reserve 8 bytes of extra TX headroom for SDIO cards
7d6d2dd326a8 mmc: sdio: add Realtek SDIO vendor ID and various wifi device IDs
095e62dd7427 wifi: rtw88: Add support for the SDIO based RTL8822BS chipset
6fdacb78f799 wifi: rtw88: Add support for the SDIO based RTL8822CS chipset
b2a777d68434 wifi: rtw88: Add support for the SDIO based RTL8821CS chipset

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230405200729.632435-2-martin.blumenstingl@googlemail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

