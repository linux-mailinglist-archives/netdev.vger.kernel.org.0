Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5783B21E192
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 22:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbgGMUlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 16:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgGMUlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 16:41:00 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85817C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 13:41:00 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id m9so6561081pfh.0
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 13:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VMfnNtLZskdCKqJCdG7DfgA/yN7X5Z0A/OIBzjkNtuE=;
        b=eIvnl7tbT2LcxRNUCsg929CZnaHFYzrbhfAwT9yc32hJwNwYr/+GobS6fN7JcjXLbW
         F9QH0SUvcfB454uv/opktfHgwhysYYm4IsdQWIp9F3eDUkIbJI0fXRPdgmOFlYX4T+hP
         oh1SqwGwl+lsturxeThLfEGQS9VAUNGlgtkztCSEerJz69+ETiVObfmjIJDNN+tJDcnj
         dYlZ6IJQ3zkBSYDX+Pg/A+Ic+QVFpiwXuXzRzUGZ9D7poxYVVH+QksExuZ5Ive+thL1D
         hjqYyU0FrePlfd+s9p+6KXO0ft3OGm5F82TUIukaAXwChE6bT9wown7zod/agTz7TEOV
         c4Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VMfnNtLZskdCKqJCdG7DfgA/yN7X5Z0A/OIBzjkNtuE=;
        b=N0USKehnT2X0J4w6TxRJThmzTRS5TCtb+xv2QESsuO8mMybpi1ED+pmkPeGQfx6Q67
         S3Hr+67jjHFmB2qCZ2c0Uu0eBgmGym+kbnNzniH1N2Cr0SWe0mvZogoU5F1M8xB9PL+G
         +BM4pJU3/1KFJ6buf0z7BzMbtZHN8vPYE0nKJiEY9rAH72/44M+Wst/pppFC3ymyQteu
         LKtBfCYqmTE+e2R+ogt7I3ow0yXQGJET3QJvzu4ZzTROSjV6PLyf2eDsYCPIJ8agYpv1
         Y3FFzdQE/XPM9iXvsVAMn3yEB8guj202YAHt4akRHC0AGynVmLwQWaC/w1TkWwJGLUyZ
         qLqA==
X-Gm-Message-State: AOAM530FvQ9Xlgivwo8kKLqIjqqJtCMeV/3kfCDSOU6lWOW36NjQ596Y
        8TsExfbmoPBPdQhiGNwjW1A=
X-Google-Smtp-Source: ABdhPJwMTEIpxv5B+MOW9XYWrsfY/U4YeGHK7ko83QKV2BD3npx1a1AfmkNlaGveyTBlxeyUNw/k/A==
X-Received: by 2002:a62:19c9:: with SMTP id 192mr1429325pfz.138.1594672860110;
        Mon, 13 Jul 2020 13:41:00 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id r2sm14713196pfh.106.2020.07.13.13.40.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2020 13:40:59 -0700 (PDT)
Subject: Re: [PATCH V2 net-next 1/7] net: ena: avoid unnecessary rearming of
 interrupt vector when busy-polling
To:     Shay Agroskin <shayagr@amazon.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     akiyano@amazon.com, davem@davemloft.net, netdev@vger.kernel.org,
        dwmw@amazon.com, zorik@amazon.com, matua@amazon.com,
        saeedb@amazon.com, msw@amazon.com, aliguori@amazon.com,
        nafea@amazon.com, gtzalik@amazon.com, netanel@amazon.com,
        alisaidi@amazon.com, benh@amazon.com, ndagan@amazon.com,
        sameehj@amazon.com
References: <1594593371-14045-1-git-send-email-akiyano@amazon.com>
 <1594593371-14045-2-git-send-email-akiyano@amazon.com>
 <3f3cc8e6-a5fd-44f7-7a86-8862e296c40c@gmail.com>
 <pj41zlk0z7rypx.fsf@ua97a68a4e7db56.ant.amazon.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <6be7744e-a54b-b668-f2a6-3d1dfdd63414@gmail.com>
Date:   Mon, 13 Jul 2020 13:40:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <pj41zlk0z7rypx.fsf@ua97a68a4e7db56.ant.amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/13/20 12:39 PM, Shay Agroskin wrote:
> 
> Eric Dumazet <eric.dumazet@gmail.com> writes:
> 

>>> +     WRITE_ONCE(ena_napi->interrupts_masked, true);
>>> +     smp_wmb(); /* write interrupts_masked before calling napi */
>>
>> It is not clear where is the paired smp_wmb()
>>
> Can you please explain what you mean ? The idea of adding the store barrier here is to ensure that the WRITE_ONCE(…) invocation is executed before
> invoking the napi soft irq. From what I gathered using this command would result in compiler barrier (which would prevent it from executing the bool store after napi scheduling) on x86
> and a memory barrier on ARM64 machines which have a weaker consistency model.

Every time you add a smp_wmb() somewhere, the question is raised where the opposite barrier (usually smp_rmb())
is used.

You should document this, pointing where is the opposite smp_rmb()

If you can not find it (READ_ONCE() has no implied smp_rmb()), then
something might be wrong in your patch.

