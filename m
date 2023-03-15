Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB36A6BA728
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 06:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbjCOFdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 01:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbjCOFdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 01:33:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8102D2411F;
        Tue, 14 Mar 2023 22:33:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 149B261AA3;
        Wed, 15 Mar 2023 05:33:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21124C433D2;
        Wed, 15 Mar 2023 05:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678858385;
        bh=JDBgkW5qQtTPm1yWAp51l+ZgG0AKs3eXBoW5HnCX/MA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=kbwOpU7JF4hU5h6xcfj11Qgfvtpqh5mMi0uUMmOwi5tvKTgG5FeQrIbm3ZObMJxOi
         Pd2OV69aatTDB3f705BKz/UIy6hUMExg9s86PkTCcSSvedmKica8rkCf5WBZ4tTbUI
         04OSFs0GXPMawq6acf4ZOGnSk2edfAM2m2YfJPuRDfaWSn+aiWfrPmvYeFVnygwxkh
         Fm8ASG9bTzGUiGqnDrCFHYTTyvaNl4fA/j57alcPP9QxEwPXj9p/obP3lGfpvLBmxD
         qtwCkSPnTIIN5ZyOHbjrPmc4NdUgLmKTP9oek3xHkwWId/JdNWaPYqzbu2RvfDGsZ2
         Dqe2eGY1KWRjQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        linux-gpio@vger.kernel.org, linux-omap@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Felipe Balbi <balbi@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        Russell King <linux@armlinux.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] p54spi: convert to devicetree
References: <20230314163201.955689-1-arnd@kernel.org>
        <e8dc9acb-6f85-e0a9-a145-d101ca6da201@gmail.com>
Date:   Wed, 15 Mar 2023 07:32:57 +0200
In-Reply-To: <e8dc9acb-6f85-e0a9-a145-d101ca6da201@gmail.com> (Christian
        Lamparter's message of "Tue, 14 Mar 2023 21:18:55 +0100")
Message-ID: <87jzziwpdi.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Lamparter <chunkeey@gmail.com> writes:

> Hi,
>
> On 3/14/23 17:30, Arnd Bergmann wrote:
>> The Prism54 SPI driver hardcodes GPIO numbers and expects users to
>> pass them as module parameters, apparently a relic from its life as a
>> staging driver. This works because there is only one user, the Nokia
>> N8x0 tablet.
>>
>> Convert this to the gpio descriptor interface and move the gpio
>> line information into devicetree to improve this and simplify the
>> code at the same time.
>
> Yes, this is definitely the right idea/way. From what I remember, Kalle
> Valo was partially involved in p54spi/stlc45xx. The details are very fuzzy.
> So,  I could be totally wrong. From what I remember Kalle was working
> for Nokia (or as a contractor for Nokia?) at the time.

I wrote stlc45xx driver as part of my thesis when working for Nokia and
I think then someone wrote p54spi after that. Oh man, this was a long
time ago so hard to remember :)

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
