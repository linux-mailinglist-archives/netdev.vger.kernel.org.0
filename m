Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D07296AA5
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 09:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S375956AbgJWHu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 03:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S375952AbgJWHu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 03:50:56 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73CC5C0613CE
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 00:50:56 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id n6so669188wrm.13
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 00:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=KiMeTNvuJWl2SezAC+PmIAPqAyoNbN6ufn4geAn7wIU=;
        b=mzTjJsg59fvwvjsKPdPbU4FwswB2et416YxnnCTAeThWcV0QEQ/x1GEM6EtvztmX6f
         qwXoAA5IallguDLmOACi3bL80UhRdIJQ3rbPSwvCmn3U5H7ZatijxBW/FW21fcLdO4Oy
         ulLjjvCcy+0VwGICRt2YJEjDSRLo+5Adm6HhvYpP9eb3kUIEUavuKff1CwU67dtaBPtH
         dQ2j1vWSIkIV0fSOvlmzphVtZ/u6+1kEBIsDG1P9iOKOHB1eJXAgGCGIQt/LAwJMngV2
         Xo8EN9D7useCWRLAKzLHniikB22CgwBQWqe6T5wfIls3xyAhrVqDD9flj/jQiFAwrJie
         amnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=KiMeTNvuJWl2SezAC+PmIAPqAyoNbN6ufn4geAn7wIU=;
        b=CeQ4x891tXQRG7YEhotSwYP+zvA7g+VRTvxdW5cdIOtaePKR/BDm39OHdfbT5/e2Pi
         gVqMHZ8CRmogfqgZuVpeFHnZr0ZSBsHUY8RD5zMHy22WAW4fLUgLw8zyhUWtKmPqC0Fm
         V8Oof3LD+zNlL8OSXxuzUU4bpIQf0X9bvKH+PuvhpgZg13ePJSpRtKYsYaUJIdXN7uxu
         L7uEa63jDSAORrJrWOEzuEflOVTVu0NqLKnF1uLdRSJq4Hi8wSLufZk579uJrP93kSQ3
         noN/l8ujxIP+GPJ5OaXTkL/oC09Xf572uJyhM0RQGqb4NBw6ij4VT7I1+tEtk/KSMaN+
         kAOw==
X-Gm-Message-State: AOAM532MwkelbnqjpvTss6KlfxUOVZcXv9ZwMQw2tu2VDZ3FidqmGDTF
        U222kEBeah31akvptlu1R4o=
X-Google-Smtp-Source: ABdhPJwbpU56hwwxySnGZy6ga7dCt4XEtWrU/x1AxEtT+lI4i00bETVnkPdMhp/y6mL3PIz2vQOlww==
X-Received: by 2002:adf:fe8b:: with SMTP id l11mr1226034wrr.9.1603439455197;
        Fri, 23 Oct 2020 00:50:55 -0700 (PDT)
Received: from [192.168.1.11] ([213.57.108.142])
        by smtp.gmail.com with ESMTPSA id 40sm1657185wrc.46.2020.10.23.00.50.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2020 00:50:54 -0700 (PDT)
Subject: Re: [PATCH net-next RFC v1 03/10] net: Introduce crc offload for tcp
 ddp ulp
To:     Sagi Grimberg <sagi@grimberg.me>,
        Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     Yoray Zack <yorayz@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>,
        Boris Pismenny <borisp@nvidia.com>
References: <20200930162010.21610-1-borisp@mellanox.com>
 <20200930162010.21610-4-borisp@mellanox.com>
 <904a5edf-3f50-5f6f-6bc6-3d1a1a664aa5@grimberg.me>
From:   Boris Pismenny <borispismenny@gmail.com>
Message-ID: <8d8a5e86-c734-7fa3-248b-b7c3c7a5699e@gmail.com>
Date:   Sun, 11 Oct 2020 17:58:00 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <904a5edf-3f50-5f6f-6bc6-3d1a1a664aa5@grimberg.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/10/2020 0:51, Sagi Grimberg wrote:
>> This commit itroduces support for CRC offload to direct data placement
>                introduces
>> ULP on the receive side. Both DDP and CRC share a common API to
>> initialize the offload for a TCP socket. But otherwise, both can
>> be executed independently.
>  From the API it not clear that the offload engine does crc32c, do you
> see this extended to other crc types in the future?

Yes, it is somewhat implicit, and it depends on the tcp ddp configuration. At the moment we only do nvme-tcp, and that has only CRC32C. If in the future, there would be other CRC variants, or data digest algorithms, then the code could be easily extended.

In general, any data digest over TCP can leverage this code and SKB member. Not only other CRC types can benefit from it, but even more complex data digest algorithms like SHA can use this. In essence this bit is similar to the TLS skb->decrypted bit. In TLS, skb->decrypted also indicates that the authentication has no error, exactly like ddp_crc indicates that there is no CRC32C error. The only reason we didn't use the same bit for both is that these two protocol offloads can be combined and that will benefit from two independent bits.

>
> Other than this the patch looks good to me,
> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>

