Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7299B3D2518
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 16:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbhGVNWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 09:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232177AbhGVNW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 09:22:29 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B07A1C061757
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 07:03:03 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id ee25so6945503edb.5
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 07:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JInVbMJ39rRbjSmp4L7SQNWHFz2ZWJnf919ts/n3e20=;
        b=TEfYm2zsec0xSajEc6hyXS2+DKfnF3FjGyPcOt2vhkHSZBEmGRRZ+cMJjbc8dPmWIP
         8gXYDEDlS0HrTw/jHDzS8f6VYY4uNfyQIRs9fZnuiG49+GfXQHG2W6rVmMveYc6UxPeB
         0GFDxBsPsk3sYQNmLDnOlMCzCcWT7krkMXko1r1rfoZSZO8jPD8/8edNkbR9nhS/h078
         4I8WW71NhKsLRqmsdrYsSh/yTbzu6pXIunABxuIC7q1+U2sfXlpuHo02vPh6sBZcv+Xn
         wSoIPGDOxa1MZ0HWcHYP7nUmsaS8hkj6sRTeWUNRIr+ygqpAUatV/Nue4LSlU484T4AQ
         7jLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JInVbMJ39rRbjSmp4L7SQNWHFz2ZWJnf919ts/n3e20=;
        b=P2moUQR2VGQK3bATaWMGzgk82mkgxfV2CDUHUk8JApeYxwLDe2FinS6Inzu/BvqEpE
         1RCWpka8DasCHqThwov3UwVNkynN7W3e1xJbglyWjmep2jx6rMC9Msh5Ls45WAz2RFmD
         7KshncTeouiyCwhjyw1AoTGmpdTCdqXe9MRBF2LUiBe4gsaGdBuBm5aNtUoKGcSKTePk
         muKh4KK7n+cPc3VkAZTOUen2p6tL6vr6qGS9vnKmOLWcab8+KQbM5v7kCBkUvYP57z9d
         BRPBhZjGLBOHZd7P3HOdB1nO/o/wXey4UgzJv+gL7ja3K1t5zaR0iNq25c4YSrjzxsfK
         644w==
X-Gm-Message-State: AOAM533ir9nAdFeXq7GaXsx50m1Kf9V2b9uNgHlA8q2f6pYZLcRjkygC
        aPhMHQqFMT+lGwAKGsYRXE4=
X-Google-Smtp-Source: ABdhPJzY/6unCfvzdaw4EnuqzLvgNJGgvHE9sBOh5pPBCKOjzCHjOCGuHQ+q5D/4sC1kvOLv4gJ/Fg==
X-Received: by 2002:a05:6402:615:: with SMTP id n21mr55763839edv.139.1626962582389;
        Thu, 22 Jul 2021 07:03:02 -0700 (PDT)
Received: from [132.68.43.152] ([132.68.43.152])
        by smtp.gmail.com with ESMTPSA id qp12sm9547732ejb.90.2021.07.22.07.02.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 07:03:01 -0700 (PDT)
Subject: Re: [PATCH v5 net-next 01/36] net: Introduce direct data placement
 tcp offload
To:     Eric Dumazet <edumazet@google.com>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, sagi@grimberg.me, axboe@fb.com,
        kbusch@kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        smalin@marvell.com, boris.pismenny@gmail.com,
        linux-nvme@lists.infradead.org, netdev <netdev@vger.kernel.org>,
        benishay@nvidia.com, ogerlitz@nvidia.com, yorayz@nvidia.com,
        Boris Pismenny <borisp@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
References: <20210722110325.371-1-borisp@nvidia.com>
 <20210722110325.371-2-borisp@nvidia.com>
 <CANn89iLP4yXDK9nOq6Lxs9NrfAOZ6RuX5B5SV0Japx50KvnEyQ@mail.gmail.com>
 <7fdb948a-6411-fce5-370f-90567d2fe985@gmail.com>
 <CANn89iLUDcL-F2RvaNz5+b8oQPnL1DnanHe0vvMb8QkM26whCQ@mail.gmail.com>
 <ba72f780-840e-de73-31b3-137908c52868@gmail.com>
 <CANn89i+kHx5zzKcPQZ406fw9DWchxXrNJQhqwGe2_=hvrxSwYw@mail.gmail.com>
From:   Boris Pismenny <borispismenny@gmail.com>
Message-ID: <f3f9c769-1dc1-397d-0d06-51120bbdbc8e@gmail.com>
Date:   Thu, 22 Jul 2021 17:02:58 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CANn89i+kHx5zzKcPQZ406fw9DWchxXrNJQhqwGe2_=hvrxSwYw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/07/2021 16:39, Eric Dumazet wrote:
> On Thu, Jul 22, 2021 at 3:33 PM Boris Pismenny <borispismenny@gmail.com> wrote:
> 
>> Sorry. My response above was about skb_condense which I've confused with
>> tcp_collapse.
>>
>> In tcp_collapse, we could allow the copy, but the problem is CRC, which
>> like TLS's skb->decrypted marks that the data passed the digest
>> validation in the NIC. If we allow collapsing SKBs with mixed marks, we
>> will need to force software copy+crc verification. As TCP collapse is
>> indeed rare and the offload is opportunistic in nature, we can make this
>> change and submit another version, but I'm confused; why was it OK for
>> TLS, while it is not OK for DDP+CRC?
>>
> 
> Ah.... I guess I was focused on the DDP part, while all your changes
> are really about the CRC part.
> 
> Perhaps having an accessor to express the CRC status (and not be
> confused by the DDP part)
>  could help the intent of the code.
> 

An accessor function sounds like a great idea for readability, thanks Eric!

We will re-spin the series and add it to v6.
