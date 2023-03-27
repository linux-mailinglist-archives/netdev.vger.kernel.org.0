Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C71926C9EEB
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 11:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbjC0JHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 05:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232957AbjC0JGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 05:06:15 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43DF4448B;
        Mon, 27 Mar 2023 02:05:44 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id y2so5104692pfw.9;
        Mon, 27 Mar 2023 02:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679907944; x=1682499944;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0pw+a378KlLp9ve/jIpsqEhAY2Xe1wbMC0MmJfbDCvI=;
        b=UOL/hENh4mDKszvdrPv3RDsriIckEpihtUrFCxzSNYXRlSskki1nMTauYqkg/aI0Vp
         /5/8GGVxnxxXj+dB08ZFUoEIFfHEjh6UEYFQNyeVTnexHHYlG48yPLiB9R/7iuBifpE6
         pQzk7qbyM9Jqy2rOog+haSJI6v5sD2ajHu53QTiOEJUSwBWfqKBkvB1eIcKKzfcSg3FT
         Bi541fFlT1Y5Snh7KxaQPR2rALzVu2jTPMxEPu5EvOeYVZ5ScPYPtE/BoA/pOa/mJe3O
         bVw6PIJkYoEXMJLv6FQrZ2LZz9P6ToInW6hyKp+P8xXbWuc1EcA2/0kSunORsL7qFf83
         3Yaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679907944; x=1682499944;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0pw+a378KlLp9ve/jIpsqEhAY2Xe1wbMC0MmJfbDCvI=;
        b=IoTpsCc/bwAcWF5tgVnQlYzm/4o2IWIFRXipmZ4vu2920Qqme1u9E1LGfFPYaYnmJ2
         x+AKlToXoe41a+kbc6uXlhCTBtDXkqvy+Tp1QcSYnbdLsTtJ6RNQ6kBHPd0O2umw2d1T
         C0tAlBmHLIuyR9B7fS2RNF9duzAgggBVr8/HreabNZkZDqzbv9dtx1dMenrtfGdT95z2
         wqR7bBqRqAT/WbYUrHK9E/iZpyOIotmFdg69KP4Uo/x4otRyc1sAklBNG2Uzw0kvTaI0
         eDGz0tyZm308L13X0lbjGbSMjTSQZGBt3eKbu+lggTcaI0PvxE0B+IQUisJSE/gK0RaU
         ZDow==
X-Gm-Message-State: AAQBX9ejaGeTjeKZJOpv5d44PiUOGhCahNp+Aru1rNVYrAOM/qcphm1/
        8ZShfHeQkEESMra2puMTrks=
X-Google-Smtp-Source: AKy350b8+nATt7p9D3LDQrEORBLlIZ1+tm5PrXNVjZU4yyLI6FVEpvQFnflzw8yg+4sZBGAqPghWKQ==
X-Received: by 2002:aa7:8b1a:0:b0:628:630:a374 with SMTP id f26-20020aa78b1a000000b006280630a374mr9865407pfd.2.1679907943617;
        Mon, 27 Mar 2023 02:05:43 -0700 (PDT)
Received: from [127.0.0.1] ([103.152.220.17])
        by smtp.gmail.com with ESMTPSA id e17-20020a62ee11000000b0062ce765b7afsm3713345pfi.162.2023.03.27.02.05.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 02:05:42 -0700 (PDT)
Message-ID: <f3eb7ec0-99b0-0ed3-0ffc-5ea20436bd08@gmail.com>
Date:   Mon, 27 Mar 2023 17:05:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2] net: tls: fix possible race condition between
 do_tls_getsockopt_conf() and do_tls_setsockopt_conf()
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     borisp@nvidia.com, john.fastabend@gmail.com, kuba@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        davejwatson@fb.com, aviadye@mellanox.com, ilyal@mellanox.com,
        fw@strlen.de, sd@queasysnail.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230228023344.9623-1-hbh25y@gmail.com>
 <fdfa0099-481c-48d6-8ab8-0c84b260e451@roeck-us.net>
Content-Language: en-US
From:   Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <fdfa0099-481c-48d6-8ab8-0c84b260e451@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/3/2023 22:12, Guenter Roeck wrote:
> Hi,
> 
> On Tue, Feb 28, 2023 at 10:33:44AM +0800, Hangyu Hua wrote:
>> ctx->crypto_send.info is not protected by lock_sock in
>> do_tls_getsockopt_conf(). A race condition between do_tls_getsockopt_conf()
>> and do_tls_setsockopt_conf() can cause a NULL point dereference or
>> use-after-free read when memcpy.
>>
>> Please check the following link for pre-information:
>>   https://lore.kernel.org/all/Y/ht6gQL+u6fj3dG@hog/
>>
>> Fixes: 3c4d7559159b ("tls: kernel TLS support")
>> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> 
> This patch has been applied to v6.1.y. Should it be applied to older kernel
> branches as well ? I know it doesn't apply cleanly, but the conflicts
> should be easy to resolve. I'll be happy to send backports to stable@ if
> needed.
> 
> Thanks,
> Guenter

Look like Meena Shanmugam is doing this. Please check this:

https://lore.kernel.org/all/20230323005440.518172-2-meenashanmugam@google.com/

Thanks for your attention.

Thanks,
Hangyu
