Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAD106975DE
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 06:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbjBOFfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 00:35:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjBOFfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 00:35:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5CD2A9A5;
        Tue, 14 Feb 2023 21:35:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA4ACB82046;
        Wed, 15 Feb 2023 05:35:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93631C433D2;
        Wed, 15 Feb 2023 05:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676439317;
        bh=LANnG+PtQLcN/12XLL7GZBXeaLs0zbH80bLxomIclLs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=lR7QtoVO/ZyJ+Fj8sNHOAqdSggan9Qw8vQ8dKctyFX80q7Qxs/hT6Or1B25oELbeN
         AcMufULJhQ2z6CS1pZeb1dvzqquwBfr/Hrhq8ZiSxY0jSFYRHxhe6QXQMuoAonftHT
         eCfxLFlA4HO2KNu89u1gVj2zdScsJPO0qZ74KE5FPeVDdgJc+gnrN9FdlGQSBhyfyr
         1HRgl5eAhNKVa45mM9HtoGmaeIoD9Rf/g0tVDLKws780QmMmWvGyppv4te5nMKtlxb
         HMMUl0xR7O2HhKCDQl/RmkjK7n/lRNQjHrN4fFijzfG3thKbSsYipy8JEf0Db9syn0
         tSrrhQ43HM0Fw==
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
Date:   Wed, 15 Feb 2023 07:35:09 +0200
In-Reply-To: <20230214132009.1011452-1-dev.mbornand@systemb.ch> (Marc
        Bornand's message of "Tue, 14 Feb 2023 13:20:25 +0000")
Message-ID: <87ttzn4hki.fsf@kernel.org>
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

> changes since v3:
> - add missing NULL check
> - add missing break
>
> changes since v2:
> - The code was tottaly rewritten based on the disscution of the
>   v2 patch.
> - the ssid is set in __cfg80211_connect_result() and only if the ssid is
>   not already set.
> - Do not add an other ssid reset path since it is already done in
>   __cfg80211_disconnected()
>
> When a connexion was established without going through
> NL80211_CMD_CONNECT, the ssid was never set in the wireless_dev struct.
> Now we set it in __cfg80211_connect_result() when it is not already set.
>
> Reported-by: Yohan Prod'homme <kernel@zoddo.fr>
> Fixes: 7b0a0e3c3a88260b6fcb017e49f198463aa62ed1
> Cc: linux-wireless@vger.kernel.org
> Cc: stable@vger.kernel.org
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=216711
> Signed-off-by: Marc Bornand <dev.mbornand@systemb.ch>
> ---
>  net/wireless/sme.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)

The change log ("changes since v3" etc) should be after "---" line and
the title should start with "wifi: cfg80211:". Please read the wiki link
below.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
