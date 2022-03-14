Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC374D7D46
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 09:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237402AbiCNIIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 04:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237818AbiCNIH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 04:07:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D064642EFD;
        Mon, 14 Mar 2022 01:06:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08EC5611BB;
        Mon, 14 Mar 2022 08:06:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E261C340E9;
        Mon, 14 Mar 2022 08:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647245163;
        bh=aDCzH0XgltdH708d3jMGDbRqktMJc+h4QyzAAe7poOw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=gi61AJzCNX5aWvZ93JNV80yN7u387rN4Rl9LkUxStO7t50zMjk1x9Apqkith7DLV5
         5GODlLWXHTQ5E+wV6plFwh+2+sz1rTUaTj0XQIsARU9cSZvvXOW+pnPO3row3/3OCi
         4JeEw+vlpB00E/X+kxgmL9Ojk8qsFlq+oHIygujkalLOicmclzLo4R4gaZ/ReyUjP2
         h+bqbXBxkI2C3rj+2ljvq9n5H57EEdREK4SFuMoI+tMIAW/9jpwpHimXKeQ4nz4vGM
         p706Z+Y+NZ/W4WOuIk7Dcyyos4dX4wKey1JcElM2QhV0f5eTIvtDr7oWB/hBsZDan7
         nMVexWYTf2iZA==
From:   Kalle Valo <kvalo@kernel.org>
To:     cgel.zte@gmail.com
Cc:     toke@toke.dk, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>
Subject: Re: [PATCH V2] ath9k: Use platform_get_irq() to get the interrupt
References: <20220314062635.2113747-1-chi.minghao@zte.com.cn>
        <877d8xqc2i.fsf@kernel.org>
Date:   Mon, 14 Mar 2022 10:05:57 +0200
In-Reply-To: <877d8xqc2i.fsf@kernel.org> (Kalle Valo's message of "Mon, 14 Mar
        2022 08:32:05 +0200")
Message-ID: <8735jlq7q2.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kalle Valo <kvalo@kernel.org> writes:

> cgel.zte@gmail.com writes:
>
>> From: Minghao Chi <chi.minghao@zte.com.cn>
>>
>> It is not recommened to use platform_get_resource(pdev, IORESOURCE_IRQ)
>> for requesting IRQ's resources any more, as they can be not ready yet in
>> case of DT-booting.
>>
>> platform_get_irq() instead is a recommended way for getting IRQ even if
>> it was not retrieved earlier.
>>
>> It also makes code simpler because we're getting "int" value right away
>> and no conversion from resource to int is required.
>>
>> Reported-by: Zeal Robot <zealci@zte.com.cn>
>> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
>> ---
>> v1->v2:
>>   - Retain dev_err() call on failure
>>
>>  drivers/net/wireless/ath/ath9k/ahb.c | 8 +++-----
>>  1 file changed, 3 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
>> index cdefb8e2daf1..28c45002c115 100644
>> --- a/drivers/net/wireless/ath/ath9k/ahb.c
>> +++ b/drivers/net/wireless/ath/ath9k/ahb.c
>> @@ -98,14 +98,12 @@ static int ath_ahb_probe(struct platform_device *pdev)
>>  		return -ENOMEM;
>>  	}
>>  
>> -	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>> -	if (res == NULL) {
>> +	irq = platform_get_resource(pdev, 0);
>
> Is this really correct? Should it be platform_get_irq()?
>
> Do you compile test your patches? That's mandatory.

Also please fix your email setup, I get an error for this address:

<zealci@zte.com.cn>: host mxde.zte.com.cn[209.9.37.26] said: 550 5.1.1 User
    unknown id=622EE16E.000 (in reply to RCPT TO command)

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
