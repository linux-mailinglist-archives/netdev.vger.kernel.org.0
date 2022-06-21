Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 978C4552C01
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 09:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347200AbiFUH3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 03:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347520AbiFUH2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 03:28:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F09423BD9;
        Tue, 21 Jun 2022 00:28:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 369AB61377;
        Tue, 21 Jun 2022 07:28:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9537C3411D;
        Tue, 21 Jun 2022 07:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655796498;
        bh=Syta5Z85Gz/VJ18PoP33wJ3ShJaizNkbKNlaAurnU2c=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=n0jdNJ7j+kIeupqvaKE82aMEckkudYupVu6e931OlprcKHlA//jMbrVejBxkNdymx
         nhBevP863cKDLM5tpjb0xqK0mlWx35abBvRslKPDfzwfGQ2tPHYF/dRXWqKO2xW/m8
         NF2893+59BaRwNPwIdz+WwAnkQvXmVq0q9ldyk2kwADA9RgR6B1yw3bxYZJd4TbV/M
         KvNwTxqyJL5FlBIz+E2qNEczniu2P4oXcm2xdWnGnRtuafQpGEXzlzX1jhE4p4EzRr
         3bXFkJn1OXnbT0XSVeMXhxTe9x02Bq2THHGDH5qwG6VJW73qw4CWsQtKpexe4WCYHU
         lCeL+WM/y/dkw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Baligh Gasmi <gasmibal@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 2/3] mac80211: add periodic monitor for channel busy time
References: <20220601112903.2346319-1-gasmibal@gmail.com>
        <20220601112903.2346319-3-gasmibal@gmail.com>
Date:   Tue, 21 Jun 2022 10:28:11 +0300
In-Reply-To: <20220601112903.2346319-3-gasmibal@gmail.com> (Baligh Gasmi's
        message of "Wed, 1 Jun 2022 13:29:02 +0200")
Message-ID: <87r13ipjas.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Baligh Gasmi <gasmibal@gmail.com> writes:

> Add a worker scheduled periodicaly to calculate the busy time average of
> the current channel.
>
> This will be used in the estimation for expected throughput.
>
> Signed-off-by: Baligh Gasmi <gasmibal@gmail.com>

[...]

> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -1970,6 +1970,64 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
>  	mutex_unlock(&local->iflist_mtx);
>  }
>  
> +#define DEFAULT_MONITOR_INTERVAL_MS 1000

I'm worried that polling every second affects power consumption.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
