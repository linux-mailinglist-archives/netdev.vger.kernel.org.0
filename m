Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE6ED4ADD67
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 16:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381960AbiBHPsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 10:48:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382007AbiBHPsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 10:48:35 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50654C0612BC;
        Tue,  8 Feb 2022 07:48:31 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id j14so25095270lja.3;
        Tue, 08 Feb 2022 07:48:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=KxYSiqV12Dhm8YIIbxVVPZPZ8DeDZ9T4ZM/yFNlt0P4=;
        b=RCJH/+Jlb0WLMRrQOaeKkLw2zcgYhGFGq9EIE5cCcIrXrMKxY0eYUJydZobET1700n
         iOG+u9NHqzmAPh5tqUFIHuf5qBlqkQYWCsIU0LmPKZ6NZW05XvolNBchVjmMwmpJ34rV
         wdwdBwyiQ3TetWfh553Uj1uIMs2eVv8Vyn1DMzTO+S5FLW4PNHxvCqfTovmyxSl02VEy
         P9Ec+IOUIER0y6542iKSfRvbjyEs3rOQJpQqDJ8auotuYdI79eqMZrxDUUlXLl+RCG0l
         bzIPx3IJSNxUt+N5zYGmBgnbIAGPi5K8thj689pSZm2WW3t34iPIvuwGJYRcTcpgTW3t
         RVSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KxYSiqV12Dhm8YIIbxVVPZPZ8DeDZ9T4ZM/yFNlt0P4=;
        b=t8FDkNtA5Bhs3X4UfYOEEALPtfSLnyESVk7hlVK8/MhA/UkemDDaFpu3xpBWh+tbcM
         hn7Yckh6A8C/J/lIiB2ql15Hkj5tvwdih69vOoEWI1RV1LPuEfVBwYfrZCrqZq3xMiXe
         l1K+WDXS1s9PG65yq/ip/l8VP4Wp7J5sLscz7Xcu2iWJylLDVaTsIhZ04qD5PTpye+qB
         skW/01aemjtzH6v9NQrc00oulv6JOoaP+4srqFaNHy+DZ/hnTQf5Bg6jrWevscOQUuuK
         6RORWj4Ka8QbGZA/WbNbexY1FW5GJaSDMJbAan+QrLFfXNZEdQskDP3NHlIWGFOD/0I3
         Ajkw==
X-Gm-Message-State: AOAM5300dt8zDxoWD4aWkSv80kXqDst0qGb/YiC/o5SipktrH8X1qxXB
        5nRQEfNMsvncBeSp4BX0FrEEpNKI/Z7WCA==
X-Google-Smtp-Source: ABdhPJySi/pdYPq6mdP6NmTInKPyJ648iKNTgmsWmxL8LMLykGhXyqhkOIbLNTmw+0/eXkf1WgB04A==
X-Received: by 2002:a05:651c:3c7:: with SMTP id f7mr3269342ljp.62.1644335309629;
        Tue, 08 Feb 2022 07:48:29 -0800 (PST)
Received: from [192.168.1.11] ([94.103.224.201])
        by smtp.gmail.com with ESMTPSA id w6sm2025770ljm.109.2022.02.08.07.48.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Feb 2022 07:48:29 -0800 (PST)
Message-ID: <6f0615da-aa0b-df8e-589c-f5caf09d3449@gmail.com>
Date:   Tue, 8 Feb 2022 18:48:24 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 1/2] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        ath9k-devel@qca.qualcomm.com, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, linville@tuxdriver.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com,
        syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
References: <80962aae265995d1cdb724f5362c556d494c7566.1644265120.git.paskripkin@gmail.com>
 <87h799a007.fsf@toke.dk>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <87h799a007.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Toke,

On 2/8/22 17:47, Toke Høiland-Jørgensen wrote:
> Pavel Skripkin <paskripkin@gmail.com> writes:
> 
>> Syzbot reported use-after-free Read in ath9k_hif_usb_rx_cb(). The
>> problem was in incorrect htc_handle->drv_priv initialization.
>>
>> Probable call trace which can trigger use-after-free:
>>
>> ath9k_htc_probe_device()
>>   /* htc_handle->drv_priv = priv; */
>>   ath9k_htc_wait_for_target()      <--- Failed
>>   ieee80211_free_hw()		   <--- priv pointer is freed
>>
>> <IRQ>
>> ...
>> ath9k_hif_usb_rx_cb()
>>   ath9k_hif_usb_rx_stream()
>>    RX_STAT_INC()		<--- htc_handle->drv_priv access
>>
>> In order to not add fancy protection for drv_priv we can move
>> htc_handle->drv_priv initialization at the end of the
>> ath9k_htc_probe_device() and add helper macro to make
>> all *_STAT_* macros NULL save.
> 
> I'm not too familiar with how the initialisation flow of an ath9k_htc
> device works. Looking at htc_handle->drv_priv there seems to
> be three other functions apart from the stat counters that dereference
> it:
> 
> ath9k_htc_suspend()
> ath9k_htc_resume()
> ath9k_hif_usb_disconnect()
> 
> What guarantees that none of these will be called midway through
> ath9k_htc_probe_device() (which would lead to a NULL deref after this
> change)?
> 

IIUC, situation you are talking about may happen even without my change.
I was thinking, that ath9k_htc_probe_device() is the real ->probe() 
function, but things look a bit more tricky.


So, the ->probe() function may be completed before 
ath9k_htc_probe_device() is called, because it's called from fw loader 
callback function. If ->probe() is completed, than we can call 
->suspend(), ->resume() and others usb callbacks, right? And we can meet 
NULL defer even if we leave drv_priv = priv initialization on it's place.

Please, correct me if I am wrong somewhere :)




With regards,
Pavel Skripkin
