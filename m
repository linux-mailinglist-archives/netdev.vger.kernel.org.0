Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5DE14E9D04
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 19:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239218AbiC1RHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 13:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244260AbiC1RHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 13:07:05 -0400
X-Greylist: delayed 1384 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 28 Mar 2022 10:05:24 PDT
Received: from gateway23.websitewelcome.com (gateway23.websitewelcome.com [192.185.50.161])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B3362110
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 10:05:24 -0700 (PDT)
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 7D637D8DF
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 11:42:20 -0500 (CDT)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id YsRgnl3SBHnotYsRgnfnLz; Mon, 28 Mar 2022 11:42:20 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LGWDosA7uj0DRDvMTXB/qfLIc/X00g79gqGwaihOl7s=; b=lBeLwz5KX2ZXRumnweriMl2NJE
        qNqw1idR51FQaNMHbVoWmL9nYldXoKdTaqheVgfbA3+mMgPfqj0z1mHKs306Ix2klc5npNyNzJohI
        fukpzzGLATBKFs9VGGJFsWoWJMyAqbzkqinFoiwGjrX5lGP0GK3rD+Umdhk1Ls+EhyANtDHdel9tZ
        Cu179zwU/AYWCquCMNF6fKcY+zBf9nuV8bWnme4YjRWOh1SBxoTAMZj/1MO6l0EjMqlfFu1Sp35ky
        YfAEpu5sRLUiR0oMntGL84ISLTN31HLzbX8N9ne43zDPFiii/G9MI8K9qemmg+yAsuSSHqa0AJwx/
        Jto+MDPw==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:54534)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nYsRf-001lqf-M4; Mon, 28 Mar 2022 16:42:19 +0000
Message-ID: <a5e03322-4471-7877-3f71-15683c83c7b3@roeck-us.net>
Date:   Mon, 28 Mar 2022 09:42:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v1 1/2] hwmon: introduce hwmon_sanitize_name()
Content-Language: en-US
To:     Tom Rix <trix@redhat.com>, Michael Walle <michael@walle.cc>,
        Xu Yilun <yilun.xu@intel.com>,
        Jean Delvare <jdelvare@suse.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220328115226.3042322-1-michael@walle.cc>
 <20220328115226.3042322-2-michael@walle.cc>
 <a1f71681-0eb0-c67f-53e0-dfce9d2fdea9@redhat.com>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <a1f71681-0eb0-c67f-53e0-dfce9d2fdea9@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nYsRf-001lqf-M4
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net [108.223.40.66]:54534
X-Source-Auth: linux@roeck-us.net
X-Email-Count: 34
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/28/22 05:25, Tom Rix wrote:
> 
> On 3/28/22 4:52 AM, Michael Walle wrote:
>> More and more drivers will check for bad characters in the hwmon name
>> and all are using the same code snippet. Consolidate that code by adding
>> a new hwmon_sanitize_name() function.
>>
>> Signed-off-by: Michael Walle <michael@walle.cc>
>> ---
>>   drivers/hwmon/intel-m10-bmc-hwmon.c |  5 +----
>>   include/linux/hwmon.h               | 16 ++++++++++++++++
>>   2 files changed, 17 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/hwmon/intel-m10-bmc-hwmon.c b/drivers/hwmon/intel-m10-bmc-hwmon.c
>> index 7a08e4c44a4b..e6e55fc30153 100644
>> --- a/drivers/hwmon/intel-m10-bmc-hwmon.c
>> +++ b/drivers/hwmon/intel-m10-bmc-hwmon.c
>> @@ -515,7 +515,6 @@ static int m10bmc_hwmon_probe(struct platform_device *pdev)
>>       struct intel_m10bmc *m10bmc = dev_get_drvdata(pdev->dev.parent);
>>       struct device *hwmon_dev, *dev = &pdev->dev;
>>       struct m10bmc_hwmon *hw;
>> -    int i;
>>       hw = devm_kzalloc(dev, sizeof(*hw), GFP_KERNEL);
>>       if (!hw)
>> @@ -532,9 +531,7 @@ static int m10bmc_hwmon_probe(struct platform_device *pdev)
>>       if (!hw->hw_name)
>>           return -ENOMEM;
>> -    for (i = 0; hw->hw_name[i]; i++)
>> -        if (hwmon_is_bad_char(hw->hw_name[i]))
>> -            hw->hw_name[i] = '_';
>> +    hwmon_sanitize_name(hw->hw_name);
>>       hwmon_dev = devm_hwmon_device_register_with_info(dev, hw->hw_name,
>>                                hw, &hw->chip, NULL);
>> diff --git a/include/linux/hwmon.h b/include/linux/hwmon.h
>> index eba380b76d15..210b8c0b2827 100644
>> --- a/include/linux/hwmon.h
>> +++ b/include/linux/hwmon.h
>> @@ -484,4 +484,20 @@ static inline bool hwmon_is_bad_char(const char ch)
>>       }
>>   }
> 
> hwmon_is_bad_char is now only used by hwmon_sanitize_name.
> 
> as patch 3, consolidate into only hwmon_sanitize_name.
> 

That would make the code look messy.

The function isn't execution-time critical, and neither is hwmon_sanitize_name().
I would suggest to implement hwmon_sanitize_name() in the hwmon core.
The existing static inline can then be removed from the include file
after all callers have been converted.

Thanks,
Guenter
