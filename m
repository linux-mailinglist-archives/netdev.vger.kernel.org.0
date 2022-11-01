Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5480D614BC6
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 14:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiKANaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 09:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbiKANaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 09:30:16 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C46211452
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 06:30:14 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5so8860849wmo.1
        for <netdev@vger.kernel.org>; Tue, 01 Nov 2022 06:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G7BWQuXp8nuoxObA0gk31F3zag3U+Di1ctzjJ7KybCc=;
        b=OHI+82QlIKQP4xVvY4wm94ZGUuDb0LcpbWEh5TOulSylyCT2RGpe5MT/KiCb8lYZ87
         yHlAr+BfCH/t6TNVEquXdRJ5zoiofPmvSmHOk9vi7tskpbs1zXTslbjg7MCVKA1aYarG
         pGucT9LMaqqUfBXp7zorTN44pvbk5itwviXXN9ax99md04HLv8TAmyFC7GfVL9K+Dr4n
         Ij5ftQJlSAWzrPi1Ukept8MB4OGKWFQXDesI+2i6l9GSDhUe7VRTMKWWn8ZMoAWzAVvp
         MNaHxq0oYKyu17mrMLOZ28zWU6oyFmc4cGl507bvuT1cLdTwhnB04rreadKde2t0rwJy
         bX7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G7BWQuXp8nuoxObA0gk31F3zag3U+Di1ctzjJ7KybCc=;
        b=PA+3M3F+QaXh5wC1T9XyZavp6ulgpOKzAr2MnJYEUogII8bd8FRAwHTUfEPq2hzodf
         6FsviT3EMaF7RJry6bUYm8ftLR2qtVmwKcKWm0rq0UuqLAGEy6XKFMzbt0jtDOdIryxJ
         UR/03ccXFcdi1AZnPqoGCNPEDhOlQui6tloT609oORyTOCoIEEkHFHYc+BN5vBg8G8JK
         syau0OcHY7+Ig2pv1XyjqjBVtTJMkFBxYP9ArHU5t1LNK5q2oPBjnLdL8jh7SnScE5Nt
         nWoSXmMqsS9otqaqkC7ZxEI1zumJ94jgNnBYANTfdydFDBEXMFgUsh8U9OshvqrzEt9K
         bwLA==
X-Gm-Message-State: ACrzQf0dZ2U3W0Tkl0q4zW5Ihv8ltiV+BkRSq1OzEYANBqma9SsopU+S
        8P5gPuu03W3BnSLtLMWpEKBkbs+QnGg=
X-Google-Smtp-Source: AMsMyM4+wWXntFEPLfBVXQAiinm7O2LP0WRSG8cAC6wHjGiVdVse+4QA09+4Mu6CHJfyBcJzm4XgOA==
X-Received: by 2002:a05:600c:ad0:b0:3cf:692a:7f66 with SMTP id c16-20020a05600c0ad000b003cf692a7f66mr10611845wmr.200.1667309412308;
        Tue, 01 Nov 2022 06:30:12 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id f7-20020adff987000000b00236722ebe66sm9892127wrr.75.2022.11.01.06.30.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Nov 2022 06:30:11 -0700 (PDT)
Subject: Re: [PATCH net-next 1/5] sfc: check recirc_id match caps before MAE
 offload
To:     Jakub Kicinski <kuba@kernel.org>, edward.cree@amd.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        habetsm.xilinx@gmail.com
References: <cover.1666603600.git.ecree.xilinx@gmail.com>
 <d3da32136ba31c553fa267381eb6a01903525814.1666603600.git.ecree.xilinx@gmail.com>
 <20221025194035.7eb96c0a@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <958764a5-8b2d-fe99-c59d-fbdddd53e0bc@gmail.com>
Date:   Tue, 1 Nov 2022 13:30:10 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20221025194035.7eb96c0a@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/10/2022 03:40, Jakub Kicinski wrote:
> On Mon, 24 Oct 2022 10:29:21 +0100 edward.cree@amd.com wrote:
>> From: Edward Cree <ecree.xilinx@gmail.com>
>>
>> Offloaded TC rules always match on recirc_id in the MAE, so we should
>>  check that the MAE reported support for this match before attempting
>>  to insert the rule.
>>
>> Fixes: d902e1a737d4 ("sfc: bare bones TC offload on EF100")
> 
> This commit made it to net, needs to go separately there.

Hmm I might just drop the fixes tag; the cited commit isn't really
 broken, just suboptimal.

> We still don't allow flow control to hide inside macros.
> 
> You add the checks next to each other (looking at the next patch) 
> so you can return rc from the macro and easily combine the checks
> into one large if statement. Result - close to ~1 line per check.

Ah yeah, I forgot statement-like macros can still return values.
Will fix, thanks.

-ed
