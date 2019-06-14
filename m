Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A74F5460EC
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 16:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbfFNOen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 10:34:43 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44208 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728208AbfFNOen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 10:34:43 -0400
Received: by mail-pl1-f195.google.com with SMTP id t7so1091626plr.11;
        Fri, 14 Jun 2019 07:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hQ/2TCsgHd63qdgIeQy8ojRYEa5SdLlsBJg9pFxbgEs=;
        b=da6OKv1AnE6d1/z1ZGsq0j5uJ1whVPCoD3uYZVLLWfq9nZMg8Bt9jtBI6EREwpRdzq
         J4hhbpNC9nLg9fnKfGAYoNwTBxpOowltBZnDS6tyAsPOAwezJTi5TdhkXntxkA/mRLeq
         wE77tHiEGlS0c1mM3lVr1Wj4i5B8WPZQFaehdndEC2SW7iqcJEKrMwcukU+SPy7Cyv81
         tpDau0+IoHSfGyWZWC6DGUAc3/xseYVon1P67Mjgpx1OuqoyuDuKypEwmJC8XNpoSBoT
         tcWKjJCQXvNVHTTXkQcrOjI7sUsXUGTbtWB09xZmtZnrgtXAJ6Es0f36340+AaxWf2nt
         IEVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hQ/2TCsgHd63qdgIeQy8ojRYEa5SdLlsBJg9pFxbgEs=;
        b=nKUjYJIBLcNRlKSQ5Jq3aGcFvl1tueBRKA2M/I+Rgd/y1+IrYRuEZGED97CHIHDL3B
         J8+V8/FeB/T+vkg0a/MA27iDTDL3lVe7reW1GNAglwIISCKnqlElLtJAm974N6YekMqW
         hN03r2oFkN+416KslySNWCVznhzEtoldemo5SuMzobfMZV0BpbpfwhL6Bw3qbcw6r9Td
         4IWqt2pT0GiCoP+dypUNjmvcPlO6R1xhXiwLB1iAuGopYnL19hVe4iRPkAfKMH/ZDBrl
         YA3OprTCkWiK5qhqhjpmQ3IO+iElWqlcGIwFlcQ8B+00/1aaTkZnHIHfcYo/02e3fEpd
         bRRw==
X-Gm-Message-State: APjAAAVkT1q0E3Cp0Ci6bKi05SsJHts96nlBl/y52ost/EwkM7d4LiDp
        mZSA0OD+qQ+UxvAQ9dsfaMmSAz6j
X-Google-Smtp-Source: APXvYqzNduItYPKPOV2+opTZ/P0fS0QMPWDWCD9fy67Rk/gk9whLzREGuPsnI/NXjZ2Ja8qZwrUlvQ==
X-Received: by 2002:a17:902:a516:: with SMTP id s22mr54018004plq.178.1560522882345;
        Fri, 14 Jun 2019 07:34:42 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id e26sm3196627pfn.94.2019.06.14.07.34.40
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 07:34:41 -0700 (PDT)
Subject: Re: [PATCH net v2] tcp: avoid creating multiple req socks with the
 same tuples
To:     Eric Dumazet <edumazet@google.com>, maowenan <maowenan@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20190612035715.166676-1-maowenan@huawei.com>
 <CANn89iJH6ZBH774SNrd2sUd_A5OBniiUVX=HBq6H4PXEW4cjwQ@mail.gmail.com>
 <6de5d6d8-e481-8235-193e-b12e7f511030@huawei.com>
 <a674e90e-d06f-cb67-604f-30cb736d7c72@huawei.com>
 <6aa69ab5-ed81-6a7f-2b2b-214e44ff0ada@gmail.com>
 <52025f94-04d3-2a44-11cd-7aa66ebc7e27@huawei.com>
 <CANn89iKzfvZqZRo1pEwqW11DQk1YOPkoAR4tLbjRG9qbKOYEMw@mail.gmail.com>
 <7d0f5a21-717c-74ee-18ad-fc0432dfbe33@huawei.com>
 <CANn89iJW0DHBg=RKgdLq1r33THL15UO3c2n4MkR6DdD7-QwP1w@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <0202f817-bd59-918e-96d5-ddf692f5e140@gmail.com>
Date:   Fri, 14 Jun 2019 07:34:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CANn89iJW0DHBg=RKgdLq1r33THL15UO3c2n4MkR6DdD7-QwP1w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/14/19 7:25 AM, Eric Dumazet wrote:
> On Fri, Jun 14, 2019 at 7:04 AM maowenan <maowenan@huawei.com> wrote:
>> I agree that this is a special case.
>> I propose one point about the sequence of synack, if two synack with two different
>> sequence since the time elapse 64ns, this issue disappear.
>>
>> tcp_conn_request->tcp_v4_init_seq->secure_tcp_seq->seq_scale
>> static u32 seq_scale(u32 seq)
>> {
>>         /*
>>          *      As close as possible to RFC 793, which
>>          *      suggests using a 250 kHz clock.
>>          *      Further reading shows this assumes 2 Mb/s networks.
>>          *      For 10 Mb/s Ethernet, a 1 MHz clock is appropriate.
>>          *      For 10 Gb/s Ethernet, a 1 GHz clock should be ok, but
>>          *      we also need to limit the resolution so that the u32 seq
>>          *      overlaps less than one time per MSL (2 minutes).
>>          *      Choosing a clock of 64 ns period is OK. (period of 274 s)
>>          */
>>         return seq + (ktime_get_real_ns() >> 6);
>> }
>>
>> So if the long delay larger than 64ns, the seq is difference.
> 
> The core issue has nothing to do with syncookies.
> 
> Are you sure you really understand this stack ?
> 

Oh well, maybe I should not have answered before my breakfast/coffee.

What I meant to say is that we do not want to fix this problem by working around
the issue you noticed (which leads to RST packets)

