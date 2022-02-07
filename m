Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB4DD4AC284
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 16:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442509AbiBGPF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 10:05:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382241AbiBGPDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 10:03:44 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB19C0401C1;
        Mon,  7 Feb 2022 07:03:43 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id g8so3543468pfq.9;
        Mon, 07 Feb 2022 07:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:cc:content-transfer-encoding;
        bh=mS7TncTDTAedIOa0shd+ZvGI84i/d6u1cvvXwuS06Vs=;
        b=Sl1aAWG5gg6a89W6+hFicuNJFDjzoyl7G87HBJQZ95+v0sgfh8ILxDj8Mkfxk19UBA
         OsxOlkJU/x19u70esZnffMoPwI+6XB1K2HlG2ODOWNWNwUPf2zW9lkswGQ4eK+2taYPX
         Tj8Yb+qq1qGXIWYbVdpf/fhONO0vBztvqWni62yPJX5QQq6mPu0eAia/6auVYyEVasiu
         yP0nrsrAqWFWJ8N0JVSqPOyExBnQJM/4Cm8I4qnBC6GJ/Rqf35gwTN0IQGkcU03ghFJK
         0aFoxMI7B+iVEMIOXRfpnWkIbvGRmEWmNzW3jPgeoNPkW2n9z6b7j/TNPUMOwhEAOIoM
         ZzaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:cc:content-transfer-encoding;
        bh=mS7TncTDTAedIOa0shd+ZvGI84i/d6u1cvvXwuS06Vs=;
        b=kNrOc3PjihaJeVgovzALeuAzfVq0Rn/UprBsBPbnxhq2hgwhJvUT77SNyELwY4IUjx
         9U+k1CsRrmYLXqa5OqmyweBcYN4mx8l8ABBCzxT2hQaL8+ZoOHj25OsxyvSs/Z/2Cw9b
         EQNU23fMT5c4p5GrMVoc5FNhK+r5XKqt9G/6EsM22M0i2F49zz92fHOOBQJCMIG6xjE7
         fDqktPZwsNYdXpGpbMKpYXIvlWT4OTMD6q2PfcxkOor7wCUnPWfkGRhigWNx0IAsN4S0
         5aFwQ4FDJnMwoXyKOQpt9L2iQ+kpQSnuSL1p6rRf3UeJT7GZTHBztDGua62F8ihZOZ8e
         Rdyg==
X-Gm-Message-State: AOAM532QZSB/NdJDJuuaV08DV06rfyxL2SjDWM5SNhliGKpv8xV4Xc5Y
        dw5QOqxvvDiRXF5CCIxMLi9RX5nl5XGeaQ==
X-Google-Smtp-Source: ABdhPJwJ843l2UFGHHTAgxbxW057CYEHotDhqvKJamSl4AwMke8vHlo7YUo3kOY8hVXvF82cWdkPKw==
X-Received: by 2002:a63:2c16:: with SMTP id s22mr9704833pgs.297.1644246223146;
        Mon, 07 Feb 2022 07:03:43 -0800 (PST)
Received: from [10.59.0.6] ([85.203.23.80])
        by smtp.gmail.com with ESMTPSA id w4sm8531262pgs.28.2022.02.07.07.03.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 07:03:42 -0800 (PST)
Message-ID: <49ce0d1f-c302-7fe5-805b-9f505240f683@gmail.com>
Date:   Mon, 7 Feb 2022 23:03:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Content-Language: en-US
To:     stas.yakovlev@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        kuba@kernel.org
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [BUG] ipw2100: possible deadlocks involving waiting and locking
 operations
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

My static analysis tool reports two possible deadlock in the ipw2100 
driver in Linux 5.16:

#BUG 1
ipw2100_wx_set_retry()
   mutex_lock(&priv->action_mutex); --> Line 7323 (Lock A)
   ipw2100_set_short_retry()
     ipw2100_hw_send_command()
       wait_event_interruptible_timeout(priv->wait_command_queue, ...) 
--> Line 793 (Wait X)

ipw_radio_kill_sw()
   mutex_lock(&priv->action_mutex); --> Line 4259 (Lock A)
   schedule_reset()
     wake_up_interruptible(&priv->wait_command_queue); --> Line 706 (Wake X)

#BUG 2
ipw2100_wx_set_scan()
   mutex_lock(&priv->action_mutex); --> Line 7393 (Lock A)
   ipw2100_start_scan()
     ipw2100_hw_send_command()
       wait_event_interruptible_timeout(priv->wait_command_queue, ...) 
--> Line 793 (Wait X)

ipw_radio_kill_sw()
   mutex_lock(&priv->action_mutex); --> Line 4259 (Lock A)
   schedule_reset()
     wake_up_interruptible(&priv->wait_command_queue); --> Line 706 (Wake X)

When ipw2100_wx_set_retry() or ipw2100_wx_set_scan() is executed, "Wait 
X" is performed by holding "Lock A". If ipw_radio_kill_sw() is executed 
at this time, "Wake X" cannot be performed to wake up "Wait X", because 
"Lock A" has been already hold, causing possible deadlocks.
I find that "Wait X" is performed with a timeout, to relieve the 
possible deadlocks; but I think this timeout can cause inefficient 
execution.

I am not quite sure whether these possible problems are real.
Any feedback would be appreciated, thanks :)


Best wishes,
Jia-Ju Bai
