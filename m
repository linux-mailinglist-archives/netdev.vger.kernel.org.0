Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F7A215A95
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 17:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729329AbgGFPWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 11:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729197AbgGFPWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 11:22:02 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 458A8C061755;
        Mon,  6 Jul 2020 08:22:02 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id k17so10031527lfg.3;
        Mon, 06 Jul 2020 08:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=S5CUOkRDhJwAr2zxz72FAOW43xS0ST/RXUJTVUNrdh0=;
        b=ubLHfw19cCc0ikpTT2Bgnh/Gsv5XvurCJqnTzKSP//7kEQ51oq92OnJ7kxCalVt261
         7NQFCRedv9W2T1/yOlchyKYErpgTHZtEbZIauK5VBc0DIiB0OJq8fyU7zHahqWc3jgIV
         llx8uFbCemqFNd4CvHI0a0r1mwDuyCV2DncETlFMTws3VrL6YKkagIiCXOqblFvcz5eR
         oIOCsdwUaJgJDAFdjOese2IRBJhUwOMNFiDA7bC2r1JD3f/Nh5MT+JnFDH/CsU+/12NF
         Xdg0P3/78Y8e0G/HNd/CB5ZD9/iWZmlErw7wZoB5KOK+uiEvrykiJbORUiWX9nFLVqFe
         DGIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=S5CUOkRDhJwAr2zxz72FAOW43xS0ST/RXUJTVUNrdh0=;
        b=Jt7DPSLucSed7BQpWVHofpmLRwSGsXJ8OW6oYxz8dz69/tgfT9ghqeRSxPr1G1aHPh
         fqhdPLwgzRnhQEQ88U30X7UkhABrm5H8HpG+Xo7cunnwdORuHVZ0w7bvt3I62jcnNu32
         Jo+pe5x1kxS5ID1K1Mb5ebHPI7Smr1s+Mrr6t0zNYkRLD5V/EwffXc0txQwgdYDeKtE8
         PToy4I93/L0+XprPsHpdd7Q6voilx179gWhculZZvtDHE7FA6YADxeXwlyHvHWKWOC3R
         bg4NeKWXul2sjqEuShysFVjGY2H0/jBz/ugkmT9ooHIXotlTG+DLnVctiJx1lir6nas7
         EbUQ==
X-Gm-Message-State: AOAM533iJzuFAFpoO1yVxQMvwqHfv1kDHwdWClapJgyYt2/dZIyGc1Ag
        Zlka669UxN4AfIF07aGY4e4=
X-Google-Smtp-Source: ABdhPJz0rrtwMMAFAMDudFLLe5daZEjzgNR3+krALxgMOUmvxT3r8IDeW/T5+bCbxu9Z/wupJBdCVg==
X-Received: by 2002:a19:ca11:: with SMTP id a17mr30204968lfg.120.1594048920696;
        Mon, 06 Jul 2020 08:22:00 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id m25sm2704463ljj.128.2020.07.06.08.21.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 08:21:59 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, andrew@lunn.ch
Subject: Re: [PATCH  1/5] net: fec: properly support external PTP PHY for
 hardware time stamping
References: <20200706142616.25192-1-sorganov@gmail.com>
        <20200706142616.25192-2-sorganov@gmail.com>
        <20200706150814.kba7dh2dsz4mpiuc@skbuf>
Date:   Mon, 06 Jul 2020 18:21:59 +0300
In-Reply-To: <20200706150814.kba7dh2dsz4mpiuc@skbuf> (Vladimir Oltean's
        message of "Mon, 6 Jul 2020 18:08:14 +0300")
Message-ID: <87zh8cu0rs.fsf@osv.gnss.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:

> Hi Sergey,
>
> On Mon, Jul 06, 2020 at 05:26:12PM +0300, Sergey Organov wrote:
>> When external PTP-aware PHY is in use, it's that PHY that is to time
>> stamp network packets, and it's that PHY where configuration requests
>> of time stamping features are to be routed.
>> 
>> To achieve these goals:
>> 
>> 1. Make sure we don't time stamp packets when external PTP PHY is in use
>> 
>> 2. Make sure we redirect ioctl() related to time stamping of Ethernet
>>    packets to connected PTP PHY rather than handle them ourselves

[...]

>> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
>> index 2d0d313..995ea2e 100644
>> --- a/drivers/net/ethernet/freescale/fec_main.c
>> +++ b/drivers/net/ethernet/freescale/fec_main.c
>> @@ -1298,7 +1298,11 @@ fec_enet_tx_queue(struct net_device *ndev, u16 queue_id)
>>  			ndev->stats.tx_bytes += skb->len;
>>  		}
>>  
>> +		/* It could be external PHY that had set SKBTX_IN_PROGRESS, so
>> +		 * we still need to check it's we who are to time stamp
>> +		 */
>>  		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS) &&
>> +		    unlikely(fep->hwts_tx_en) &&
>
> I think this could qualify as a pretty significant fix in its own right,
> that should go to stable trees. Right now, this patch appears pretty
> easy to overlook.
>
> Is this the same situation as what is being described here for the
> gianfar driver?
>
> https://patchwork.ozlabs.org/project/netdev/patch/20191227004435.21692-2-olteanv@gmail.com/

Yes, it sounds exactly like that!

However, I'd insist that the second part of the patch is as important.
Please refer to my original post for the description of nasty confusion
the second part of the patch fixes:

https://lore.kernel.org/netdev/87r1uqtybr.fsf@osv.gnss.ru/

Basically, you get PHY response when you ask for capabilities, but then
MAC executes ioctl() request for corresponding configuration!

[...]

Thanks,
-- Sergey
