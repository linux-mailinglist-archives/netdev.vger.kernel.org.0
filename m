Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF3C9666F5F
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 11:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238527AbjALKR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 05:17:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239865AbjALKPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 05:15:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA78BF2;
        Thu, 12 Jan 2023 02:15:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D99AE61FCA;
        Thu, 12 Jan 2023 10:15:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DCBCC433EF;
        Thu, 12 Jan 2023 10:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673518551;
        bh=eZSAfDKuRBo0xGVikbboiQneetQV4uSvYjwwu4EYGa0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=WyHIKPds/xpQeQuBcbJcgTRVOWErVVr9bdlytmSVrh8GXxP84ll9AGmqGGdZ9hCR3
         nzkwBoAxRLsYKBhMa5rvZhg6LUbHNhDc1eDEkO7E8iOEVT4Sr421gJlWPvyR/9kChw
         /tQzlqY8OCLcJ9UL9sJfZryQbVNxD5Zc3dFv7aivqlGkfR6XBb2Jjm0HSksIXH4b5z
         Hs8FP8OeXz+pyzN2Q3i9WgfRHz0OKiwsk+WJgiWu/bIl3G8Y8lAv/t5k+93Nh+rl0H
         DIPCYmLJ1MwL+7au6LbsizTKzRQs47Oil/CbPkeNvIqvdljdK+4LKVt0ZDR615CWne
         v+GFMCyekccUg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Abhishek Kumar <kuabhs@chromium.org>
Cc:     Manikanta Pubbisetty <quic_mpubbise@quicinc.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] ath10k: snoc: enable threaded napi on WCN3990
References: <20221220075215.1.Ic12e347e0d61a618124b742614e82bbd5d770173@changeid>
        <56d4941a-ad35-37ca-48ca-5f1bf7a86d25@quicinc.com>
        <CACTWRwt7oQrCyHf=ZF6dW8TtRhOfa14XMZW39cYZWi4hhszcqg@mail.gmail.com>
Date:   Thu, 12 Jan 2023 12:15:42 +0200
In-Reply-To: <CACTWRwt7oQrCyHf=ZF6dW8TtRhOfa14XMZW39cYZWi4hhszcqg@mail.gmail.com>
        (Abhishek Kumar's message of "Wed, 28 Dec 2022 16:01:38 -0800")
Message-ID: <87tu0wcb3l.fsf@kernel.org>
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

Abhishek Kumar <kuabhs@chromium.org> writes:

>> > --- a/drivers/net/wireless/ath/ath10k/snoc.c
>> > +++ b/drivers/net/wireless/ath/ath10k/snoc.c
>> > @@ -927,6 +927,9 @@ static int ath10k_snoc_hif_start(struct ath10k *ar)
>> >
>> >       bitmap_clear(ar_snoc->pending_ce_irqs, 0, CE_COUNT_MAX);
>> >
>> > +     if (ar->hw_params.enable_threaded_napi)
>> > +             dev_set_threaded(&ar->napi_dev, true);
>> > +
>>
>> Since this is done in the API specific to WCN3990, we do not need
>> hw_param for this.
>
> Just so that I am clear, are you suggesting to enable this by default
> in snoc.c, similar to what you did in
>
> https://lore.kernel.org/all/20220905071805.31625-2-quic_mpubbise@quicinc.com/
>
> If my understanding is correct and there is no objection, I can remove
> hw_param and enable it by default on snoc.c . I used hw_param because,
> as I see it, threaded NAPI can have some adverse effect on the cache
> utilization and power.

WCN3990 is the only device using SNOC bus so the hw_param is not needed.
It's safe to call dev_set_threaded() in ath10k_snoc_hif_start()
unconditionally as it only affects WCN3990.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
