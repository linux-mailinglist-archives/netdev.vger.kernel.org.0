Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 978414DA55A
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 23:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349124AbiCOW2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 18:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234619AbiCOW2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 18:28:18 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB4F5C66C
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 15:27:03 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id s25so840406lji.5
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 15:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=1eFaiU5+NXOZ2eF/q2c9hS91JEU83jBZdMPIUzAUG/M=;
        b=W9eHnbhnxZGkzFj4ctqYZx2unDRv0f6pILZnVE29yrAktO5wfV20/6Q5AYy2opt8kW
         mEsUioTGfGdUFxKKKJLC1YaxkOCTeW2Z1Sx0akQKquuDbdLVis6ZPKyWY5GwYnpzo4xP
         Jur81GGN4sb0B+FWmLvdm0DkYueYkSa2YrKABgXs+59DS3pNashgTBY1HOaB13LLpgow
         Ofn21eFrtSHyBy/7w3XlI0057PBHN1Rv0myExHyAZlaWtktSbhS3OFHBvG20IDG2LW6c
         jBVSKdDoRX5hO9X9MM+7RyHzzIgxbE7dObi9QuznBILzRbBqUSR80QmgHH1DaLxJG3n6
         PThA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=1eFaiU5+NXOZ2eF/q2c9hS91JEU83jBZdMPIUzAUG/M=;
        b=6goGuVS5IbyFhDsr+TEemJ025edINTus1i3E/yxGonGhl5uSs4nzyOPzADtzzjSWWW
         RRhk8phEpRWpTGnFwcMPLL+Q57+u0N5I2dwQBrcRGjku8Lmcb2nojX+2zIlslH2eXhAm
         uIuXD5x49vfGs3RRZNvg6wj+wqqNPH7ron0Jz3iUHSoVlTyMTkFKSD7IEIC+XDlIEs0K
         WVvcmBWt1Jn7pD/QVi79+VOH7qPzig8BlYj/ktjW8ljSOTzNsRSe+1ZP08lZLL2Io+eh
         xzYFxvmIKG0bX40P35QK8vwhk+ZIe1z3ONwmTcmw8d40+syGk0TUZPJRmq8tnjkQw6gD
         0y9g==
X-Gm-Message-State: AOAM530q7gO5mBE0yRY3LXCjiQPY7l5dgiW+wTjWIaCKEhWg9eZCPiC/
        S6JZGJMe/Lyni384M1I05v5vtg==
X-Google-Smtp-Source: ABdhPJyqfX4MOlHUD1u/2Ymk1nux/6ggwGs0+zmsR8ejZc2pNkrCvxg3TIt1AV07eugD8SX7TSBlKg==
X-Received: by 2002:a05:651c:160b:b0:247:f955:1b18 with SMTP id f11-20020a05651c160b00b00247f9551b18mr18676245ljq.427.1647383222035;
        Tue, 15 Mar 2022 15:27:02 -0700 (PDT)
Received: from wkz-x280 (h-212-85-90-115.A259.priv.bahnhof.se. [212.85.90.115])
        by smtp.gmail.com with ESMTPSA id h1-20020a056512054100b0044847b32426sm19185lfl.156.2022.03.15.15.27.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 15:27:01 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH v4 net-next 09/15] net: dsa: Never offload FDB entries
 on standalone ports
In-Reply-To: <20220315163349.k2rmfdzrd3jvzbor@skbuf>
References: <20220315002543.190587-1-tobias@waldekranz.com>
 <20220315002543.190587-10-tobias@waldekranz.com>
 <20220315163349.k2rmfdzrd3jvzbor@skbuf>
Date:   Tue, 15 Mar 2022 23:26:59 +0100
Message-ID: <87ee32lumk.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 18:33, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Tue, Mar 15, 2022 at 01:25:37AM +0100, Tobias Waldekranz wrote:
>> If a port joins a bridge that it can't offload, it will fallback to
>> standalone mode and software bridging. In this case, we never want to
>> offload any FDB entries to hardware either.
>> 
>> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>> ---
>
> When you resend, please send this patch separately, unless something
> breaks really ugly with your MST series in place.

Sure. I found this while testing the software fallback. It prevents a
segfault in dsa_port_bridge_host_fdb_add, which (rightly, I think)
assumes that dp->bridge is valid. I feel like this should have a Fixes:
tag, but I'm not sure which commit to blame. Any suggestions?

>>  net/dsa/slave.c | 3 +++
>>  1 file changed, 3 insertions(+)
>> 
>> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
>> index a61a7c54af20..647adee97f7f 100644
>> --- a/net/dsa/slave.c
>> +++ b/net/dsa/slave.c
>> @@ -2624,6 +2624,9 @@ static int dsa_slave_fdb_event(struct net_device *dev,
>>  	if (ctx && ctx != dp)
>>  		return 0;
>>  
>> +	if (!dp->bridge)
>> +		return 0;
>> +
>>  	if (switchdev_fdb_is_dynamically_learned(fdb_info)) {
>>  		if (dsa_port_offloads_bridge_port(dp, orig_dev))
>>  			return 0;
>> -- 
>> 2.25.1
>> 
