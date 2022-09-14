Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 794A95B8E51
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 19:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiINRrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 13:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiINRrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 13:47:04 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF58058097
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 10:47:02 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id l14so36562266eja.7
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 10:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date;
        bh=SzS9NCa6R1Ummv0XEXp/1m3nw8Faa2aztCWWxRrwDJY=;
        b=N6TB7OqdkwY9fqtJAB0p8DsTiFZBdLycaEUOeqr3M4kDu0u75Qmvam4sZd4BS/09GH
         K1GJKKjPg1LYqagLYRNAo7AfnJpsBDk0kR68fQh6pcxdqCI9VfmUu+xhnKdxFm1/w/My
         4u1Ty1gCzd8Yl/HRzPOCgoARoqi7VJP9UF5PF1O7oOoF0qOrcIsFkqOuxD0pHiru+RCF
         EE/+rZka7LHa7G+sjzaHvIIlPX5mUzf6I8g3D4HK/vQ5AoSo8jTnjhZRk/nXKp9+kusJ
         CMKM9tx9UCfKb3jkFqHAjEhsbZDm9uYHdsqOksKBaPBU7w0D8GG0sFnF5J9Opf+9hgx2
         VMKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date;
        bh=SzS9NCa6R1Ummv0XEXp/1m3nw8Faa2aztCWWxRrwDJY=;
        b=FYxotYkkKK8BzbOabYZcC5cF2VAmzv092e829blkwxBksNOA2EsdR2vYW1DXPR+0mB
         TXt0fPWqZ2hYI6mVMawlEfNDPqGk6y8cq9t3M1vfIz1z5y4uuFlJIIlU8KdEkSHSMI35
         goMiR8Ht/iUeGh/s9lYmQZJ/E8kCg5pYkqDYRdMngG8sS9v0qPcyg0Qdisd/s9/DBatQ
         2DEMKoRrsGwkC7uLReHQmtLdCrYiY7a80jxhCSjO2xLixEJf/iherNu6vY7V+PioZZIR
         qQzTSi1WaavEo7MvgyVKk/xYNgdLFnatdpQpcK+lRXYNIn8V5HxvhgjAMDm+QGFiGv2H
         2vrA==
X-Gm-Message-State: ACgBeo07QJ1P4eERpFP8lkg0FnlSzFQtKapgWxPqjkJqCSVods/jIxhV
        bpz9Tm5cu6SLD3TdxkLXOG8=
X-Google-Smtp-Source: AA6agR6ykPhrN6l1ZN0thzzIsAQFholSzLu+6fzqk6obCiUdcrawESdBt55QRL1hsZGyf1zqY4P9Vg==
X-Received: by 2002:a17:907:2722:b0:77f:c136:62eb with SMTP id d2-20020a170907272200b0077fc13662ebmr7377662ejl.522.1663177621475;
        Wed, 14 Sep 2022 10:47:01 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id ec47-20020a0564020d6f00b0044f1fcf5ee0sm10116657edb.48.2022.09.14.10.47.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Sep 2022 10:47:00 -0700 (PDT)
Subject: Re: [PATCH net] sfc: fix TX channel offset when using legacy
 interrupts
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Tianhao Zhao <tizhao@redhat.com>
References: <20220914103648.16902-1-ihuguet@redhat.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <ff9c64bf-24f6-f3f7-0022-3eadd44fe96e@gmail.com>
Date:   Wed, 14 Sep 2022 18:47:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220914103648.16902-1-ihuguet@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/09/2022 11:36, Íñigo Huguet wrote:
> In legacy interrupt mode the tx_channel_offset was hardcoded to 1, but
> that's not correct if efx_sepparate_tx_channels is false. In that case,
> the offset is 0 because the tx queues are in the single existing channel
> at index 0, together with the rx queue.
> 
[...]
> 
> Fixes: c308dfd1b43e ("sfc: fix wrong tx channel offset with efx_separate_tx_channels")
> Reported-by: Tianhao Zhao <tizhao@redhat.com>
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>

Acked-by: Edward Cree <ecree.xilinx@gmail.com>
