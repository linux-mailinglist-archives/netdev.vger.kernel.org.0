Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C02812F95
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 15:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbfECNuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 09:50:24 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:34588 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726989AbfECNuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 09:50:24 -0400
Received: by mail-yw1-f66.google.com with SMTP id u14so4343075ywe.1;
        Fri, 03 May 2019 06:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Cb3dOBONDPUiw5QKA/nv+e9o48H5wdiEyR1XR+NWF7Q=;
        b=Xn9UptjKN6pBBWC7044HXJYeH+C2WZcGF1mSgDlvKBW5w+G+XlFep2SXI7ZZibKG91
         7B3+1LZ7b2KLoHKcOwDFpalF/85Nhlb1kVS9Tt0iOtVqO+HAO1+FWs6iQJvgh6wbBMZo
         ei0p1BJw9jZ2MluLdFpnKQK2PpsG5J+yaixC7m5ez/SLeJQhXd3j5nNLMJp+CClRpqPM
         kJEwuR+3M2GGDCFGAfaAwqhaXamjCe1gkr9K1gLFpnJdXHZvCdZ0UEILIqk9L8rISQFa
         3J6glB8+gnyfOUUCf/MVHqLum936mJg1elH0dFq12PbEcmNQewWPXYW+ft8ImKdD4Rjh
         SlLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Cb3dOBONDPUiw5QKA/nv+e9o48H5wdiEyR1XR+NWF7Q=;
        b=ED32sENlKy1ZNw2XHA9xzfwnhL1L7bQN94CHYS2Z8bzYFvG6s3JxZ/GqPIrfE2YufV
         ACxJDUkFOCK22YZu4NomatIVIPUZKPfuhHsbeZeoVhxYvQiwPH7XVOFKrul2Z7/PeA2J
         A0AwihblLPDFtxeXAb/KdLuP0bU+tMstgGhDvzGDOc+Ccvw0kv3PW8GHUce6fBggTPqj
         sVLCzepI8wh26xyNp4vRuntkuK1q0AOdPwuHH4JXIcf3rZGaKxRBNgFdyC56bn4YYDdf
         i//YHTk4iRoXsZGgeZARIwUa4cje/MSzBBYsYKD0tGtsNpGderBQwLgsb+TRCrUpAi19
         ZIBg==
X-Gm-Message-State: APjAAAV3DOe7Wgto1BrMLhxoUzDrqamLUNG4Oiib/4Bm+VKqtxoFc47v
        kRuPwfxaHf0NxAquVAidHH8=
X-Google-Smtp-Source: APXvYqztBjyl2B8gSqLjvTLqMuZoGDHXZaPRTpwrYgZvWw8SHiE6wRo8h3GbEsGPlpgRypFtWy7syw==
X-Received: by 2002:a25:2f52:: with SMTP id v79mr7624158ybv.182.1556891423269;
        Fri, 03 May 2019 06:50:23 -0700 (PDT)
Received: from [172.20.0.54] (adsl-173-228-226-134.prtc.net. [173.228.226.134])
        by smtp.gmail.com with ESMTPSA id b69sm930316ywh.18.2019.05.03.06.50.21
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 06:50:22 -0700 (PDT)
Subject: Re: [PATCH v6 bpf-next 13/17] s390: bpf: eliminate zero extension
 code-gen
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Jiong Wang <jiong.wang@netronome.com>
Cc:     alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
References: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com>
 <1556880164-10689-14-git-send-email-jiong.wang@netronome.com>
 <20190503134118.GA5602@osiris>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c0d08132-c1ac-72a9-9ba3-376add0352c2@gmail.com>
Date:   Fri, 3 May 2019 09:50:21 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190503134118.GA5602@osiris>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/3/19 9:41 AM, Heiko Carstens wrote:
> On Fri, May 03, 2019 at 11:42:40AM +0100, Jiong Wang wrote:
>> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
>> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
>> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
>> ---
>>  arch/s390/net/bpf_jit_comp.c | 20 +++++++++++++++++---
>>  1 file changed, 17 insertions(+), 3 deletions(-)
> 
> When sending patches which affect s390, could you please add Martin
> and me on cc to _all_ patches? We now received only the cover-letter
> plus one patch. It's always hard in such cirumstances to figure out if
> the code is doing the right thing.
> 
>
One possible way is to use  --signed-off-by-cc option in git send-email

       --[no-]signed-off-by-cc
           If this is set, add emails found in Signed-off-by: or Cc: lines to the cc list.
           Default is the value of sendemail.signedoffbycc configuration value; if that is
           unspecified, default to --signed-off-by-cc.

