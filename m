Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 290546DFB0F
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 18:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjDLQQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 12:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjDLQQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 12:16:34 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B80234EDD
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 09:16:14 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id q6so10025wrc.3
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 09:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681316173; x=1683908173;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Eo9lC0tY3WXDFfz7KLjzFx7IuKKz11h0tRgpIIkPG1M=;
        b=ZZvDY4BJfUJiWlzEFZ2iUtAOgh5hRRmpDZsPVVs2oktVSqRFf+mD8vkq8dVZFdupJd
         B32wTg8wz251g+AIxvI8jnWuh+I/h50fdaNFv7PgQi1mWpzgLWl/wtPTzbc80Ii8W5qb
         ILdbKvl9E4CHbcOXbH640yyzTqKESmKQ7Fr9Pc3kZzSZQ06S2xukrXbb+0cGLb/jly2I
         NzNLyp0M+VFIfNANTNMBNuKbKzzy+ao0nIOvIrkWb5xDjOvf4P45MOHKtIldnqqpsNCL
         6zHx9Xsp7bWfn9SFagigtAzeqMm0U9UjHuKOEggXg+ya0nkphzleKbcIdKEu85eiQ6Tw
         4VlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681316173; x=1683908173;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Eo9lC0tY3WXDFfz7KLjzFx7IuKKz11h0tRgpIIkPG1M=;
        b=7ZrEKuLEwUQY4VscVTupaIutcmTXGMC5+Ltoe6N/ytIQEPwM4zrXtAjDEk0biN3Cnr
         L9Da94w5yq88afpAGZyVwsIi+EQsF6xAa5AbgmMcGhUNdZcwrHjbWaq6ChLdVphwhOE9
         L6sjTwJPBG/t7Pg6syrv065VDubFZH9SNz2SGL7I9Q5bRXluGmm51k1wOKhhoqQw7Cos
         rLInlO0l7hMT3JQfqeCsnAJR4YRQyr7JjCAyB3r7PHF/b8WMiBv4cULKHuOWktXKXd5V
         lJGwk/Rgzd6e/aOz1BZjQ6x8rpZ0OJNEb7+/O6JB0oOk346fFap1Qm0gQP5zrRt/hh9B
         lEbA==
X-Gm-Message-State: AAQBX9drBKdr+mKHH1OqhE2hqQnEnvOYz2aFPpctTKL/7bom+Hstanf9
        Us7h6kIT1ADcg1pg+c5Y+xA=
X-Google-Smtp-Source: AKy350aW4zT0B8krZABGWUCrfWT9jEeUfZehI+E+xCEf5IfvhNpMetrhdoL5oDo5MWulGPzuF7Po2Q==
X-Received: by 2002:a5d:56d1:0:b0:2d2:3b59:cbd4 with SMTP id m17-20020a5d56d1000000b002d23b59cbd4mr5243736wrw.12.1681316173091;
        Wed, 12 Apr 2023 09:16:13 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id c14-20020a5d4cce000000b002f2782978d8sm7069335wrt.20.2023.04.12.09.16.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Apr 2023 09:16:12 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next 6/7] net: ethtool: add a mutex protecting
 RSS contexts
To:     Andrew Lunn <andrew@lunn.ch>, edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com, sudheer.mogilappagari@intel.com
References: <cover.1681236653.git.ecree.xilinx@gmail.com>
 <9e2bcb887b5cf9cbb8c0c4ba126115fe01a01f3f.1681236654.git.ecree.xilinx@gmail.com>
 <ea711ae7-c730-4347-a148-0602c69c9828@lunn.ch>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <69612358-2003-677a-80a2-5971dc026646@gmail.com>
Date:   Wed, 12 Apr 2023 17:16:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <ea711ae7-c730-4347-a148-0602c69c9828@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/04/2023 21:40, Andrew Lunn wrote:
> On Tue, Apr 11, 2023 at 07:26:14PM +0100, edward.cree@amd.com wrote:
>> While this is not needed to serialise the ethtool entry points (which
>>  are all under RTNL), drivers may have cause to asynchronously access
>>  dev->ethtool->rss_ctx; taking dev->ethtool->rss_lock allows them to
>>  do this safely without needing to take the RTNL.
> 
> What is actually wrong with taking RTNL? KISS is often best,
> especially for locks.

The examples I have of driver code that needs to access rss_ctx (in the
 sfc driver) are deep inside call chains where RTNL may or may not
 already be held.
1) filter insertion.  E.g. ethtool -U is already holding RTNL, but other
 sources of filters (e.g. aRFS) aren't, and thus taking it if necessary
 might mean passing a 'bool rtnl_locked' all the way down the chain.
2) device reset handling (we have to restore the RSS contexts in the
 hardware after a reset).  Again resets don't always happen under RTNL,
 and I don't fully understand the details (EFX_ASSERT_RESET_SERIALISED()).
So it makes life much simpler if we just have a finer-grained lock we can
 just take when we need to.
Also, RTNL is a very big hammer that serialises all kinds of operations
 across all the netdevs in the system, holding it for any length of time
 can cause annoying user-visible latency (e.g. iirc sshd accepting a new
 connection has to wait for it) so I prefer to avoid it if possible.  If
 anything we want to be breaking up this BKL[1], not making it bigger.

-ed

[1]: https://legacy.netdevconf.info/2.2/slides/westphal-rtnlmutex-talk.pdf
