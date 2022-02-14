Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 835B24B5579
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 16:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356054AbiBNP6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 10:58:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346744AbiBNP6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 10:58:16 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D9D488B4
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 07:58:08 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id y5so29957845pfe.4
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 07:58:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=DFe+XqkUxalv1mC4VY4GnC7BN2BWxF06VhcdUPwcbfQ=;
        b=YkFDzTAP0Gs326ovmUJjQU9A8GmUcNssStREC3AdIBzxH+Aw3/SsGUj3vLXysx0VzB
         hERkkOmTzh4WBGkzEXgyvE9Kd1S1eDaU72DW9TdH/UHAuIvoQC8ufhYqf65kYIc0fpLP
         our+gvTmCTQLDtW7ltMJGFp5CZSUhNPD/IqzBjloMir24Lcz7FYFtnNnRa+iTAxuC7Ad
         iSbRw/dSpcTuf87RkcVCXFJnxs5HNjw3Y/9JFbfQOY/8qS7RckDrLcWskkBiDb4M7IKR
         8R04bif2j2U687zdqTXRTGR0NaEPPK60D0lJr1L0sJN8NTvINRTPREXGMJoZN6E4QXRE
         QtsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DFe+XqkUxalv1mC4VY4GnC7BN2BWxF06VhcdUPwcbfQ=;
        b=8NFtTx6zwT4O96eP0ArnzDmdSXGYzOukkOweLqMsduf+/0MtqswzVQDnEUaLMsZgf6
         MH6b+xFHz0idWgeGnCgSUm4fKG0NMqyO4ULHO+jQN5NiubdI8g9NvytyGk2fHKNBgTi9
         FmF88VGuYxwDp08FLwSYSrF/jlDLyaX4mhF/Y0yk8aTrNFz4rlksaGGGZdHSw8eDk+xL
         eZpzSm4GdZRMsrZ/1+FoU/LynEVIvJ+LLACgSmRqgsplyfvlska2KSW/+XL7VnEdKahR
         cf4JxDzorGK51YANBST4EKtA2yBt+sO4ke2CbwDWsJBaUpI48ekNW5u4tFVyS7BU/DyA
         6lag==
X-Gm-Message-State: AOAM530T9+xo1J/OPz4gMGLipG4hIcZwm5b0CFCRH4KC+zNv2lSCSWux
        zhk6H0C3k1eEcQUG9R1+ATs=
X-Google-Smtp-Source: ABdhPJwCnFU8gvSZdvHgrjwkawDNO7yZoAEMbOI4WnE83Dru3vtiS0qqgO0xq/Wcw4mD2qtk1Yf1rA==
X-Received: by 2002:a63:130f:: with SMTP id i15mr320932pgl.562.1644854287633;
        Mon, 14 Feb 2022 07:58:07 -0800 (PST)
Received: from [192.168.99.7] (i220-99-138-239.s42.a013.ap.plala.or.jp. [220.99.138.239])
        by smtp.googlemail.com with ESMTPSA id o1sm31641pgv.47.2022.02.14.07.58.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 07:58:07 -0800 (PST)
Message-ID: <dd82fd29-f485-5b37-38d7-1ea71668436f@gmail.com>
Date:   Tue, 15 Feb 2022 00:58:04 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH net] veth: fix races around rq->rx_notify_masked
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        syzbot <syzkaller@googlegroups.com>
References: <20220208232822.3432213-1-eric.dumazet@gmail.com>
 <18d9bd16-a5f9-b4b3-d92c-4057240ad89f@gmail.com>
 <CANn89iLFhSr6PQwSTixVitgaRQi3=xtLm3dCUY2d5nOyxMDQng@mail.gmail.com>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
In-Reply-To: <CANn89iLFhSr6PQwSTixVitgaRQi3=xtLm3dCUY2d5nOyxMDQng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/02/11 1:57, Eric Dumazet wrote:
> On Wed, Feb 9, 2022 at 4:36 AM Toshiaki Makita
> <toshiaki.makita1@gmail.com> wrote:
>>
>> On 2022/02/09 8:28, Eric Dumazet wrote:
>>> From: Eric Dumazet <edumazet@google.com>
>>
>> Thank you for handling this case.
>>
>>> veth being NETIF_F_LLTX enabled, we need to be more careful
>>> whenever we read/write rq->rx_notify_masked.
>>>
>>> BUG: KCSAN: data-race in veth_xmit / veth_xmit
>>>
>>> w
>>> value changed: 0x00 -> 0x01
>>
>> I'm not familiar with KCSAN.
>> Does this mean rx_notify_masked value is changed while another CPU is reading it?
>>
> 
> Yes.
> 
>> If so, I'm not sure there is a problem with that.
> 
> This is a problem if not annotated properly.
> 
>> At least we could call napi_schedule() twice, but that just causes one extra napi
>> poll due to NAPIF_STATE_MISSED, and it happens very rarely?
> 
> The issue might be more problematic, a compiler might play bad games,
> look for load and store tearing.

Thank you.
I assume you mean problems like those listed in this page,
https://lwn.net/Articles/793253/
e.g. "invented stores", not exactly load/store tearing.
(since rx_notify_masked is 0/1 value and seems not able to be teared)

Now I understand that it's pretty hard to know what exact problem will happen as the 
behavior is undefined and depends heavily on compiler implementation.

Thank you for the fix again!

Toshiaki Makita
