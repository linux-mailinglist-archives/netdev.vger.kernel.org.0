Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C64705FEC66
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 12:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiJNKPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 06:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiJNKPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 06:15:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED98A99D6;
        Fri, 14 Oct 2022 03:15:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 606DD61AC4;
        Fri, 14 Oct 2022 10:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E04CC433C1;
        Fri, 14 Oct 2022 10:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665742528;
        bh=a9urAeM6qo9g4VwJfLS+Bay5Jtu4BOaMES1yiMuCDEE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Ou2s55cgzvH/FPQFhGvnaUCmvL9KalwfkzMqcmXvSKCq4jjy0IOO1cokBJAm4IwsY
         MYaX9uCTlW8hS+TCQeYti1nlLWyoGbmeL+vbKlaoDtrThyi7PJxOOIKRgqAG8awhJe
         iC6s9xxYV7ElHM0mW+z3RArWM0RAd+deULC1CxAFhQ8CZoLWspDIK68j/D3yNX1Ry/
         JlPsGy7MyEvkYln0r9Bt1GdFhg31EiAIJXHkVO1aWQTw7uMBSvHF3DsnuUzi1LFin+
         AJ8uoXOx33JB3Vct5QOjiHRUsPC1Kb0PuhebPoJuB4W2+B2qotzzCdCmMCcKf52qvJ
         hf039hiEudERA==
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
        linux-wireless@vger.kernel.org (open list:INTEL WIRELESS WIFI LINK
        (iwlwifi)), netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
Subject: Re: [PATCH 1/2] thermal/drivers/iwlwifi: Use generic thermal_zone_get_trip() function
References: <20221014073253.3719911-1-daniel.lezcano@linaro.org>
Date:   Fri, 14 Oct 2022 13:15:19 +0300
In-Reply-To: <20221014073253.3719911-1-daniel.lezcano@linaro.org> (Daniel
        Lezcano's message of "Fri, 14 Oct 2022 09:32:50 +0200")
Message-ID: <87mt9yn22w.fsf@kernel.org>
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

Daniel Lezcano <daniel.lezcano@linaro.org> writes:

> The thermal framework gives the possibility to register the trip
> points with the thermal zone. When that is done, no get_trip_* ops are
> needed and they can be removed.
>
> The get_trip_temp, get_trip_hyst and get_trip_type are handled by the
> get_trip_point().
>
> The set_trip_temp() generic function does some checks which are no
> longer needed in the set_trip_point() ops.
>
> Convert ops content logic into generic trip points and register them
> with the thermal zone.
>
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> ---
>  drivers/net/wireless/intel/iwlwifi/mvm/mvm.h |  2 +-
>  drivers/net/wireless/intel/iwlwifi/mvm/tt.c  | 71 ++++----------------
>  2 files changed, 13 insertions(+), 60 deletions(-)

The subject should begin with "wifi: iwlwifi: ".

I don't see patch 2. Via which tree is the plan for this patch?

Gregory, please review this.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
