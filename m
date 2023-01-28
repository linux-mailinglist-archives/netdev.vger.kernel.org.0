Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F03067F82A
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 14:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234256AbjA1Njx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 08:39:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233810AbjA1Njr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 08:39:47 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F353B0F7;
        Sat, 28 Jan 2023 05:39:46 -0800 (PST)
Received: from [192.168.2.51] (p4fe71212.dip0.t-ipconnect.de [79.231.18.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id B2869C02F8;
        Sat, 28 Jan 2023 14:39:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1674913184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2lHzHdq2L6BaFtLptilqoATr9v7yxnvCm9Ng6OEjiDE=;
        b=dfwmY04X1490RrJhpw5/Scm8eWUJ7yD4wICWcY2JtOdE2c0rIKa9EsYHDRuhX6ALb6oIBh
        cLFt+LvXT4HSNxndcArUZpOlX9UWioAzFIpmxvmluFs2dsz5ksfvVdWkVytODir4yMyCan
        Rl2CcOuYPgnSMrNsQ1aifixeTI59KtaTeM4Pc5kHkKLz4Z2qAfUafeGZo+7Vbhur97JpeW
        8eEer/z5gZMuoIcE5Eo8WJwAcEiLrrjWd2ZdmZo/9bFAFw0EdfzurIRJ/mgEKYHNolv2OL
        6CMERGwk5qT8hgkfTuJeBZVb9VwbMBFdsexnAK/tbq+RePbdWYS9spQVHITOnA==
Message-ID: <ee95c924-40fe-44c1-3a6a-d002aead3965@datenfreihafen.org>
Date:   Sat, 28 Jan 2023 14:39:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] [v2] at86rf230: convert to gpio descriptors
Content-Language: en-US
To:     Arnd Bergmann <arnd@kernel.org>,
        Alexander Aring <alex.aring@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org
References: <20230126162323.2986682-1-arnd@kernel.org>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20230126162323.2986682-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Arnd.

On 26.01.23 17:22, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> There are no remaining in-tree users of the platform_data,
> so this driver can be converted to using the simpler gpiod
> interfaces.
> 
> Any out-of-tree users that rely on the platform data can
> provide the data using the device_property and gpio_lookup
> interfaces instead.
> 
> Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   drivers/net/ieee802154/at86rf230.c | 82 +++++++++---------------------
>   include/linux/spi/at86rf230.h      | 20 --------
>   2 files changed, 25 insertions(+), 77 deletions(-)
>   delete mode 100644 include/linux/spi/at86rf230.h
> 

This patch has been applied to the wpan-next tree and will be
part of the next pull request to net-next. Thanks!

regards
Stefan Schmidt
