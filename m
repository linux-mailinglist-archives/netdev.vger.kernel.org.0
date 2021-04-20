Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC2E365F0C
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 20:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233497AbhDTSMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 14:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232648AbhDTSMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 14:12:24 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E12C06174A
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 11:11:52 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id x7so38592000wrw.10
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 11:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hQWhZtT22zqU5R3lo1xjNZxW6vcxZimRrtATo/q41NI=;
        b=pIyVaaJUQ4x5lSujaqfXT3PmyA+uCv08tNwiQ4f1ezSEgV1Pp6rYaVM/8B7t56qQyl
         oe34ptP+U/mfn9DbEwy1XXue7VVIP5urlym81/lm5K0yldIbOBni2oEGlv9066fikiUt
         LbYvBKCdH4q/9YsOL2zFzQRRevdPAbiNPenKROkFgGmXxNq7Xvq5cXG28/zARNvigeFq
         9AWEL1wMUEp9DGrxPLa7Z5hKTtWPa+Rv3SZEpm0VR62J+ndyixYlx9VC7M28Qi2ydtRj
         lurxZGpx1KextcJMCYUwqrSuPLOdH+rGATg7sFNzaHvBTf/gtlQr0/qSecX7cIiMV68+
         zA1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hQWhZtT22zqU5R3lo1xjNZxW6vcxZimRrtATo/q41NI=;
        b=o6QVQIvtiPm/4qBzL3cYBd3+8x9Nv1GMBi7O38oDpGHN/7vWCe9T3Imd/Nw2D+Hu8l
         is3JpQw9JjIUR3N5cT7OmZN9gYTNIZnaZtvlC/wgWR3oWUktJorrojAPtxDBgvSzQsCw
         Y2FWE3nrKsKH8yPsmn4/njP423BswIEi8LHUWTzO6+c2Zpc0zQ6CH3+TV6UFxvmJ4M7A
         xLt1iZrWPaaRHQCI74aqxQCc4Pbu/yw4z2uJm8gY4xYTFrtNleAIksH/gJwEqaj643JF
         nRGMxauuaE0rDoSmqflu3ExPth4bkCilQ605v3Hx2hP323C9pwPiBxDbUWRbwBhRSsno
         zZGw==
X-Gm-Message-State: AOAM532uCZxg6GZAUL+FKXIvdHUvZufLODMJRjuX3Y1iUq7xOkw1Q8WC
        vALfdT1+MHV7VNSJXcCvCZ6JA92cAWA=
X-Google-Smtp-Source: ABdhPJxJyQ+reuUJ+i9f1VohSZJ1ZM9glsEVAqxWes1u2s+E8litN06maC28OoT1Cp2GExACCDn0Ag==
X-Received: by 2002:adf:e58f:: with SMTP id l15mr21709376wrm.175.1618942311555;
        Tue, 20 Apr 2021 11:11:51 -0700 (PDT)
Received: from [192.168.156.98] (64.104.23.93.rev.sfr.net. [93.23.104.64])
        by smtp.gmail.com with ESMTPSA id i12sm26829354wrm.77.2021.04.20.11.11.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 11:11:51 -0700 (PDT)
Subject: Re: [PATCH net-next] virtio-net: fix use-after-free in page_to_skb()
To:     Guenter Roeck <linux@roeck-us.net>,
        Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
References: <20210420094341.3259328-1-eric.dumazet@gmail.com>
 <c5a8aeaf-0f41-9274-b9c5-ec385b34180a@roeck-us.net>
 <CANn89iKMbUtDhU+B5dFJDABUSJJ3rnN0PWO0TDY=mRYEbNpHZw@mail.gmail.com>
 <20210420154240.GA115350@roeck-us.net>
 <CANn89iKqx69Xe9x3BzDrybqwgAfiASXZ8nOC7KN8dmADonOBxw@mail.gmail.com>
 <335cc59c-47c4-2781-7146-6c671c2ee62c@roeck-us.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7f2caba4-cdc1-c45b-6b41-18c9de703349@gmail.com>
Date:   Tue, 20 Apr 2021 20:11:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <335cc59c-47c4-2781-7146-6c671c2ee62c@roeck-us.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/20/21 7:51 PM, Guenter Roeck wrote:

> 
> sh does indeed fail, with the same symptoms as before, but so far I was not
> able to track it down to a specific commit. The alpha failure is different,
> though. It is a NULL pointer access.
> 
> Anyway, testing ...
> 
> The patch below does indeed fix the problem I am seeing on sh.
> 
> ... and it does fix the alpha problem as well. Neat, though I don't really understand
> what a NULL pointer access and an unaligned access have to do with each other.
> 
> Great catch, thanks!
> 
> Guenter
> 

Note that build_skb(), without an additional skb_reserve(skb, NET_IP_ALIGN)
can not possibly work on arches that care about alignments.

That is because we can not both align skb->data and skb_shinfo(skb)

So unless we change build_skb() to make sure to align skb_shinfo(),
a fix could be simply :

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 8cd76037c72481200ea3e8429e9fdfec005dad85..9cbe9c1737649450e451e3c65f59f794d1bf34b0 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -415,7 +415,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 
        shinfo_size = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 
-       if (len > GOOD_COPY_LEN && tailroom >= shinfo_size) {
+       if (!_NET_IP_ALIGN && len > GOOD_COPY_LEN && tailroom >= shinfo_size) {
                skb = build_skb(p, truesize);
                if (unlikely(!skb))
                        return NULL;

