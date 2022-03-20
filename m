Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B96EB4E1D8D
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 20:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343578AbiCTTQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 15:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233934AbiCTTQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 15:16:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378D2D3AF3;
        Sun, 20 Mar 2022 12:15:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA9176121F;
        Sun, 20 Mar 2022 19:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B809C340EE;
        Sun, 20 Mar 2022 19:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647803730;
        bh=5yU1VY41IGpB26hHV6JgEd0Xh2QyTxC+F9+H8KW7OsY=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=u6DkRcZ8fJI95fjed2Wb/xkpzXzZXcJ6T3ppsjhbWJDs/X0De6DQQV0uBOX70SJ0b
         dyoqIOrG4iWEmaAWpKtc074CZ9O75ITf6vKKl8xXsQvnS25JBT1yZu/aWUDETL0WZc
         XI3PM30mymypLSbkJk01Trr0zgX3Gx9UVHj9N8zz1fcw/DP+KEoIdq/L6bOgqQlTo1
         qQ9JKFz3HR7YVj1YF8X0j6OUy6qHNCF+cBLr5Gfa8j2O+gmaw5Mdr1gAeCBu46xJ2P
         Lj6GhXUkh3W7AT/ZWYXQs6IbQcQ8SWslHxcwvXOhTOebOkj2z7HHlTLozoNS2CRvgb
         +qJt+V9uiNOLg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Cc:     Edmond Gagnon <egagnon@squareup.com>,
        Benjamin Li <benl@squareup.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] wcn36xx: Implement tx_rate reporting
In-Reply-To: <cda7eaa6-fb99-0d32-24fb-758b9363ee6d@linaro.org> (Bryan
        O'Donoghue's message of "Sun, 20 Mar 2022 18:03:10 +0000")
References: <20220318195804.4169686-1-egagnon@squareup.com>
        <20220318195804.4169686-3-egagnon@squareup.com>
        <c8f31312-5356-704e-1f55-89c9f5888238@linaro.org>
        <cda7eaa6-fb99-0d32-24fb-758b9363ee6d@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Sun, 20 Mar 2022 21:15:25 +0200
Message-ID: <87pmmgo2pe.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bryan O'Donoghue <bryan.odonoghue@linaro.org> writes:

> On 20/03/2022 13:21, Bryan O'Donoghue wrote:
>> On 18/03/2022 19:58, Edmond Gagnon wrote:
>>> +=C2=A0=C2=A0=C2=A0 INIT_DELAYED_WORK(&wcn->get_stats_work, wcn36xx_get=
_stats_work);
>>
>> Instead of forking a worker and polling we could add the relevant
>> SMD command to
>>
>> static int wcn36xx_smd_tx_compl_ind(struct wcn36xx *wcn, void *buf,
>> size_t len)
>> {
>>  =C2=A0=C2=A0=C2=A0 wcn36xx_smd_get_stats(wcn, 0xSomeMask);
>> }
>>
>> That way we only ever ask for and report a new TX data rate when we
>> know a TX event - and hence a potential TX data-rate update - has
>> taken place.
>>
>> ---
>> bod
>>
>
> Thinking a bit more
>
> - Do the SMD get_stats in the tx completion
>   This might be a problem initiating another SMD transaction inside
>   of an SMD callback. But is the most straight forward way to
>   get the data while avoiding alot of needless polling.
>
> - Schedule your worker from the TX completion
>   Again you should only care about gathering the data when you know
>   something has happened which necessitates gathering that data
>   like TX completion
>
> - Schedule your worker from the RX indication routine
>   Seems not as logical as the first two but it might be easier
>   to schedule the worker in the RX data handler
>
> Either way, I do think you should only gather this data on an event,
> not as a continuous poll.

I agree, a continuous poll is not a good idea as it affects power
consumption. What about struct ieee80211_ops::sta_statistics? AFAIK
that's called only when user space is requestings stats so the overhead
should be minimal.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
