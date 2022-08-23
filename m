Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5654959D2FB
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 10:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241669AbiHWIDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 04:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241611AbiHWIDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 04:03:13 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF56566103;
        Tue, 23 Aug 2022 01:03:04 -0700 (PDT)
Received: from [192.168.2.51] (p4fe710fb.dip0.t-ipconnect.de [79.231.16.251])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 1A8D5C0147;
        Tue, 23 Aug 2022 10:03:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1661241781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+8Fm13M6bb9Zs5x+jl2TGTj24WEqkmrVC9YUrmCGNjg=;
        b=j4lytk4G4lljIXQiFLB2W2kRJ1+rWaibru3c/aD1CEKFJrHYS3kQSr54vs0jw0JVLUTGFU
        23YQbY2J5WX+BLTdA9fP9vL9J1q4qLnCwLntOf/nzwvwpd4gsJjkb1zFpJi1AWrN53Bb8X
        ybsKvw4vUxAODfpHjjqZ7AwC+0U9tHMKNrceLkkUdFNQ3x78mpX6xMkMi7HZJ8bFwJpxRv
        RDE7GOzTWyeQC3+R/KNpwbAiRasD+YpwT1CWhV0zI+YlCMAcvDmENq83Sxmiw0s4t3zBeg
        fFfBgw54NPtbWn+KTd0Uqq+h3tS8UMKRP2omuNs0j+yWTmxEB+Ypbl5zQiMaLA==
Message-ID: <4325be90-eeb3-2bdb-5ee5-7e567d633aa6@datenfreihafen.org>
Date:   Tue, 23 Aug 2022 10:03:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v0] ieee802154/adf7242: defer destroy_workqueue call
Content-Language: en-US
To:     Lin Ma <linma@zju.edu.cn>, michael.hennerich@analog.com,
        alex.aring@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220808034224.12642-1-linma@zju.edu.cn>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220808034224.12642-1-linma@zju.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 08.08.22 05:42, Lin Ma wrote:
> There is a possible race condition (use-after-free) like below
> 
>    (FREE)                     |  (USE)
>    adf7242_remove             |  adf7242_channel
>     cancel_delayed_work_sync  |
>      destroy_workqueue (1)    |   adf7242_cmd_rx
>                               |    mod_delayed_work (2)
>                               |
> 
> The root cause for this race is that the upper layer (ieee802154) is
> unaware of this detaching event and the function adf7242_channel can
> be called without any checks.
> 
> To fix this, we can add a flag write at the beginning of adf7242_remove
> and add flag check in adf7242_channel. Or we can just defer the
> destructive operation like other commit 3e0588c291d6 ("hamradio: defer
> ax25 kfree after unregister_netdev") which let the
> ieee802154_unregister_hw() to handle the synchronization. This patch
> takes the second option.
> 
> Fixes: 58e9683d1475 ("net: ieee802154: adf7242: Fix OCL calibration
> runs")
> Signed-off-by: Lin Ma <linma@zju.edu.cn>


This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
