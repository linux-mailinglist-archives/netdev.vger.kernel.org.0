Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA43466C64E
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 17:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232873AbjAPQSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 11:18:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbjAPQRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 11:17:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 839C92F780;
        Mon, 16 Jan 2023 08:09:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 221A661049;
        Mon, 16 Jan 2023 16:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 422D5C433EF;
        Mon, 16 Jan 2023 16:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673885394;
        bh=dH7lITLlk10HZ7ydsnC9KY3bJd+hlALCCaDraiWcJ+E=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=WYtPeXlFvfFX00XNhpkT336OailQFQ4zPyAqQh0aH6nh6VaTSTNwr6uWxAdPeMnma
         M7l6+84LfpcvLWp6IsDtiLtaOM9UtOeGKvT+GbxAQ47D2zXBHkZz86o05hmt5mmmN0
         E9JbmJuVSIegCdrgFgcirw42pxnhNmjmZ+53Nnsue5dTp9F+z7gFBI/nrBEp7AQhgO
         U5cA4HMVUOk8mNE6xqO1ZD06Q8q7rOHBUNTeiW2+3fQozfKrFiKoiuayUwBfum9GtD
         HbAhw/Dql8GZMWYZXKxkh8EltkW0bjuBL1aclwIMIribmrZG64fRzQElYJJ5sAK9ZX
         zuLGloNKRg8/Q==
Message-ID: <987fc487-539a-6159-ffbc-9fe1c87a06b9@kernel.org>
Date:   Mon, 16 Jan 2023 18:09:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v2 3/3] net: ethernet: ti: am65-cpts: adjust pps
 following ptp changes
Content-Language: en-US
To:     Siddharth Vadapalli <s-vadapalli@ti.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski@linaro.org,
        krzysztof.kozlowski+dt@linaro.org, vigneshr@ti.com, nsekhar@ti.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srk@ti.com
References: <20230116085534.440820-1-s-vadapalli@ti.com>
 <20230116085534.440820-4-s-vadapalli@ti.com>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <20230116085534.440820-4-s-vadapalli@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 16/01/2023 10:55, Siddharth Vadapalli wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> When CPTS clock is sync/adjusted by running linuxptp (ptp4l) it will cause
> PPS jitter as Genf running PPS is not adjusted.
> 
> The same PPM adjustment has to be applied to GenF as to PHC clock to
> correct PPS length and keep them in sync.
> 
> Testing:
>  Master:
>   ptp4l -P -2 -H -i eth0 -l 6 -m -q -p /dev/ptp1 -f ptp.cfg &
>   testptp -d /dev/ptp1 -P 1
>   ppstest /dev/pps0
> 
>  Slave:
>   linuxptp/ptp4l -P -2 -H -i eth0 -l 6 -m -q -p /dev/ptp1 -f ptp1.cfg -s &
>     <port 1: UNCALIBRATED to SLAVE on MASTER_CLOCK_SELECTED;>
>   testptp -d /dev/ptp1 -P 1
>   ppstest /dev/pps0
> 
> Master log:
> source 0 - assert 620.000000689, sequence: 530
> source 0 - assert 621.000000689, sequence: 531
> source 0 - assert 622.000000689, sequence: 532
> source 0 - assert 623.000000689, sequence: 533
> source 0 - assert 624.000000689, sequence: 534
> source 0 - assert 625.000000689, sequence: 535
> source 0 - assert 626.000000689, sequence: 536
> source 0 - assert 627.000000689, sequence: 537
> source 0 - assert 628.000000689, sequence: 538
> source 0 - assert 629.000000689, sequence: 539
> source 0 - assert 630.000000689, sequence: 540
> source 0 - assert 631.000000689, sequence: 541
> source 0 - assert 632.000000689, sequence: 542
> source 0 - assert 633.000000689, sequence: 543
> source 0 - assert 634.000000689, sequence: 544
> source 0 - assert 635.000000689, sequence: 545
> 
> Slave log:
> source 0 - assert 620.000000706, sequence: 252
> source 0 - assert 621.000000709, sequence: 253
> source 0 - assert 622.000000707, sequence: 254
> source 0 - assert 623.000000707, sequence: 255
> source 0 - assert 624.000000706, sequence: 256
> source 0 - assert 625.000000705, sequence: 257
> source 0 - assert 626.000000709, sequence: 258
> source 0 - assert 627.000000709, sequence: 259
> source 0 - assert 628.000000707, sequence: 260
> source 0 - assert 629.000000706, sequence: 261
> source 0 - assert 630.000000710, sequence: 262
> source 0 - assert 631.000000708, sequence: 263
> source 0 - assert 632.000000705, sequence: 264
> source 0 - assert 633.000000710, sequence: 265
> source 0 - assert 634.000000708, sequence: 266
> source 0 - assert 635.000000707, sequence: 267
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> ---
>  drivers/net/ethernet/ti/am65-cpts.c | 59 ++++++++++++++++++++++++-----
>  1 file changed, 49 insertions(+), 10 deletions(-)

Reviewed-by: Roger Quadros <rogerq@kernel.org>

