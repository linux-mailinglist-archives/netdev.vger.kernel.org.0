Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA000697834
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 09:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233868AbjBOIc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 03:32:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232690AbjBOIc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 03:32:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EDE8B754;
        Wed, 15 Feb 2023 00:32:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3977A61AA3;
        Wed, 15 Feb 2023 08:32:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC14C433A0;
        Wed, 15 Feb 2023 08:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676449944;
        bh=bQGGlEBmjVutpcorhXwJevwUvhUxa0JVamvnHYFk4h4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=VUu9VxAzpQMAXU8UHSXFXy7oThyhwACCr8VBEK+2UavJvHtSjnGOAF7lodzLaYeYy
         RxFxWbiNXd6j/YqHnUWyQSc4M/FZokn/lo4P8zPi5Bf9YdXkA7vRmcDle3s2chiMJs
         O92xp2p378jaFKUZJux5mvw7yaCtGMjSzgihNuFK9ajhhU/viQG0/gUk0wiMtVc2Qo
         kauqsrPYxhYkaGSNwDb9epgAmKiLW1buIdagoYL+zQnI+gW0jx+xbgd/XfUBwP2S5U
         rIqsgwAcoRQ+/r/ME4QXwIci8lUqJy2MKBJermOW9gTx2pz1/OcOwqI4ZQi4EOvsOY
         UTfSuUJlgtXww==
From:   Kalle Valo <kvalo@kernel.org>
To:     Marc Bornand <dev.mbornand@systemb.ch>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yohan Prod'homme <kernel@zoddo.fr>,
        stable@vger.kernel.org
Subject: Re: [PATCH v4] Set ssid when authenticating
References: <20230214132009.1011452-1-dev.mbornand@systemb.ch>
        <87ttzn4hki.fsf@kernel.org> <Y+yT2YUORRHY4bei@opmb2>
Date:   Wed, 15 Feb 2023 10:32:18 +0200
In-Reply-To: <Y+yT2YUORRHY4bei@opmb2> (Marc Bornand's message of "Wed, 15 Feb
        2023 08:12:17 +0000")
Message-ID: <87lekz49d9.fsf@kernel.org>
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

Marc Bornand <dev.mbornand@systemb.ch> writes:

> On Wed, Feb 15, 2023 at 07:35:09AM +0200, Kalle Valo wrote:
>> Marc Bornand <dev.mbornand@systemb.ch> writes:
>>
>> > changes since v3:
>> > - add missing NULL check
>> > - add missing break
>> >
>> > changes since v2:
>> > - The code was tottaly rewritten based on the disscution of the
>> >   v2 patch.
>> > - the ssid is set in __cfg80211_connect_result() and only if the ssid is
>> >   not already set.
>> > - Do not add an other ssid reset path since it is already done in
>> >   __cfg80211_disconnected()
>> >
>> > When a connexion was established without going through
>> > NL80211_CMD_CONNECT, the ssid was never set in the wireless_dev struct.
>> > Now we set it in __cfg80211_connect_result() when it is not already set.
>> >
>> > Reported-by: Yohan Prod'homme <kernel@zoddo.fr>
>> > Fixes: 7b0a0e3c3a88260b6fcb017e49f198463aa62ed1
>> > Cc: linux-wireless@vger.kernel.org
>> > Cc: stable@vger.kernel.org
>> > Link: https://bugzilla.kernel.org/show_bug.cgi?id=216711
>> > Signed-off-by: Marc Bornand <dev.mbornand@systemb.ch>
>> > ---
>> >  net/wireless/sme.c | 17 +++++++++++++++++
>> >  1 file changed, 17 insertions(+)
>>
>> The change log ("changes since v3" etc) should be after "---" line and
>
> Does it need another "---" after the change log?
> something like:
>
> "---"
> "changes since v3:"
> "(CHANGES)"
> "---"

No need to add a second "---" line.

>> the title should start with "wifi: cfg80211:". Please read the wiki link
>> below.
>
> Should i start with the version 1 with the new title?

If you reset the version number that might confuse the reviewers, so my
recommendation is to use v5 in the next version. That makes it more
obvious that there are earlier versions available.

> and since i am already changing the title, the following might better
> discribe the patch, or should i keep the old title after the ":" ?
>
> [PATCH wireless] wifi: cfg80211: Set SSID if it is not already set

Changing the title is fine.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
