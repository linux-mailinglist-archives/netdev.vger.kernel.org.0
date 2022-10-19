Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 050B9603985
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 08:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbiJSGEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 02:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiJSGE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 02:04:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3456CAE5C;
        Tue, 18 Oct 2022 23:04:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C50416177E;
        Wed, 19 Oct 2022 06:04:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9ABC433D6;
        Wed, 19 Oct 2022 06:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666159466;
        bh=GoNOcTQRihsxSULDlcIct8Lz22S4CPpgq7KawTBDN6A=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ZBt8FacKXn5rb4huB9HM70ploZTOfCUG5Qa1Vc5E3rJ8uTrM/i3faUw2emwM4cUfg
         EFhJ5N/uXl3iHgsKyEiCkBw+BJv0W2gef00+fLJFOXvzHdlZWRLmM7s0Kq3ezbqEJe
         76pURUV9D7j2F6HvL2ek3vtifUU97O0+XTX3yA2f1YDqhI3/gbXyOHB9TlYJQWhMcx
         Kkbu1eZ7hkhnH9nMnsCTd48dPc1035XA9ihE+A1FUguawgCnjfr/cQvV9Uq9/ehG9U
         RWXLfZbvkO2NQ6YZtUvjU8Tv9YL3vIwD2j6EaBYKzgwp5U2cO+zAaa58cz2GNOTQYD
         vcXvbnQL/fTVw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     rafael@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gregory Greenman <gregory.greenman@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        Nathan Errera <nathan.errera@intel.com>,
        "open list\:INTEL WIRELESS WIFI LINK \(iwlwifi\)" 
        <linux-wireless@vger.kernel.org>,
        "open list\:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/2] thermal/drivers/iwlwifi: Use generic thermal_zone_get_trip() function
References: <20221014073253.3719911-1-daniel.lezcano@linaro.org>
        <87mt9yn22w.fsf@kernel.org>
        <f327dfc4-cd67-930c-a011-8cc2c58d7668@linaro.org>
Date:   Wed, 19 Oct 2022 09:04:19 +0300
In-Reply-To: <f327dfc4-cd67-930c-a011-8cc2c58d7668@linaro.org> (Daniel
        Lezcano's message of "Fri, 14 Oct 2022 12:21:09 +0200")
Message-ID: <87y1tcl57g.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Lezcano <daniel.lezcano@linaro.org> writes:

> On 14/10/2022 12:15, Kalle Valo wrote:
>
>> Daniel Lezcano <daniel.lezcano@linaro.org> writes:
>>
>>> The thermal framework gives the possibility to register the trip
>>> points with the thermal zone. When that is done, no get_trip_* ops are
>>> needed and they can be removed.
>>>
>>> The get_trip_temp, get_trip_hyst and get_trip_type are handled by the
>>> get_trip_point().
>>>
>>> The set_trip_temp() generic function does some checks which are no
>>> longer needed in the set_trip_point() ops.
>>>
>>> Convert ops content logic into generic trip points and register them
>>> with the thermal zone.
>>>
>>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>>> ---
>>>   drivers/net/wireless/intel/iwlwifi/mvm/mvm.h |  2 +-
>>>   drivers/net/wireless/intel/iwlwifi/mvm/tt.c  | 71 ++++----------------
>>>   2 files changed, 13 insertions(+), 60 deletions(-)
>>
>> The subject should begin with "wifi: iwlwifi: ".
>>
>> I don't see patch 2. Via which tree is the plan for this patch?
>
> patch 2 are similar changes but related to the mellanox driver.
>
> This is the continuation of the trip point rework:
>
> https://lore.kernel.org/netdev/20221003092602.1323944-22-daniel.lezcano@linaro.org/t/
>
> This patch is planned to go through the thermal tree

Ok, feel free to take this via the thermal tree:

Acked-by: Kalle Valo <kvalo@kernel.org>

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
