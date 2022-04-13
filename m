Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A00F74FF477
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 12:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbiDMKPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 06:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbiDMKPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 06:15:20 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB453F5A
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 03:12:58 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id p10so2567090lfa.12
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 03:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=OBygPYoH9eOHMctG/tJ0Rr+r+PpqAulwebHK5F77MXU=;
        b=Ia7psltFGoptmW0526Vz++uGR6At0o1ULKvloYNv+OCuVIgA/EqAswUtc6HVrkzoto
         u4MyQU8VdPeGSuNanN4LqjudjLvopRJDKYoUsB4FRKaieWrALMWzwgHBUCUAcw/l6VM2
         V7NdmLPTPmYI5HabCRYTbO3FSswzV4S/0NnJFsO4SHDE5yYahaoKhnucNKR7+cS77KcZ
         aHMq5rpL1AbjfSzfBYqpU9MKvnSc6xYYfb02bnc4zaeDYgTQidX3mQRDDBnx3RJV+BDw
         o2vrqFC2ChxQFR4ROWHFP7/KGwjNogCOG52GJosICA+X8mA6OtVl+Vk6PKRVrCpCXC5Q
         np+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=OBygPYoH9eOHMctG/tJ0Rr+r+PpqAulwebHK5F77MXU=;
        b=FZ6y6goad6BD94G5qaImGChN9LlnjarvfIqme3sPOnE8v8PL/l/2UIEpYGJk05FzrD
         Lvt8ZFo3BHjF8T7hcSHib4eDVHo/tlhJeSX0ixaKjpw9Lv3PWiJ1N/DF9uGSC9y4WN/v
         pSzE4hC8HIMrByu2spZimwZVVl4MjXPUOt7avHZ0a348U1O2WtzffPJFmQ9O5XqhpwZz
         ljNbHum4pEjTPOp3VLhDFVsAbkalB/NMnxeYU+E7Lb8GusWmyLuhDzECUiv1IkH9Ek1v
         vHFZkpK95HhMpHPgy6+WDc6oY4p4awu+uudJueaD3txVSnrdIMTRcxzHZehs9SzLsR2f
         y24w==
X-Gm-Message-State: AOAM530JDKdXszOUqzfU97cWxrc6A9+M/7ca9L/YjBUTp2qZwNwFgDjc
        p98w9QNwjQvwWeAqwRMFZt8=
X-Google-Smtp-Source: ABdhPJxIizJFt16LnUJZJu6mpqeIp5tAua7vVaHpQQ0gOxgGyhkfSEHMNr8+o3lc5QOf0N6Eru4yjg==
X-Received: by 2002:ac2:48b9:0:b0:46b:c3eb:a54b with SMTP id u25-20020ac248b9000000b0046bc3eba54bmr3370857lfg.507.1649844777204;
        Wed, 13 Apr 2022 03:12:57 -0700 (PDT)
Received: from wbg (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id f16-20020a2eb5b0000000b0024b62fa91b9sm943284ljn.99.2022.04.13.03.12.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 03:12:56 -0700 (PDT)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH RFC net-next 08/13] net: bridge: avoid classifying unknown multicast as mrouters_only
In-Reply-To: <586b97b3-0882-b42c-20f8-275a05b51beb@blackwall.org>
References: <20220411133837.318876-1-troglobit@gmail.com> <20220411133837.318876-9-troglobit@gmail.com> <ebd182a2-20bc-471c-e649-a2689ea5a5d1@blackwall.org> <87v8ve9ppr.fsf@gmail.com> <5d597756-2fe1-e7cc-9ef3-c0323e2274f2@blackwall.org> <87pmll9xj1.fsf@gmail.com> <96bb8ff0-26d8-e9d3-e7c8-78f2abd28126@blackwall.org> <586b97b3-0882-b42c-20f8-275a05b51beb@blackwall.org>
Date:   Wed, 13 Apr 2022 12:12:55 +0200
Message-ID: <87a6cp9tqw.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 13, 2022 at 12:00, Nikolay Aleksandrov <razor@blackwall.org> wrote:
> On 13/04/2022 11:55, Nikolay Aleksandrov wrote:
>> On 13/04/2022 11:51, Joachim Wiberg wrote:
>>> So, if I add a bridge flag, default off as you mentioned out earlier,
>>> which changes the default behavior of MCAST_FLOOD, then you'd be OK with
>>> that?  Something cheeky like this perhaps:
>>>     if (!ipv4_is_local_multicast(ip_hdr(skb)->daddr))
>>>        	BR_INPUT_SKB_CB(skb)->mrouters_only = !br_opt_get(br, BROPT_MCAST_FLOOD_RFC4541);
>> Exactly! And that is exactly what I had in mind when I wrote it. :)

Awesome, thank you! :)

> Just please use a different option name that better suggests what it does.

Heh, yeah spent a good while with my colleague (Tobias) thinking about
how to name this one.  I'll see what I can come up with, but whatever
shows up in the next patch iteration will be very open for discussion.

Cheers
 /Joachim
 
