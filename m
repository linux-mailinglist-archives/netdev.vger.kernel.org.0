Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3201C35F946
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 18:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351960AbhDNQwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 12:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237784AbhDNQwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 12:52:32 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7AFCC061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 09:52:10 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id o9-20020a1c41090000b029012c8dac9d47so3656611wma.1
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 09:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vpxEGo4it5d/Y7J9S3+pgBmU3IZbPtHu91dG5grVG6c=;
        b=QCUO4M7Q1tpkcB9S4CNppfYA8ezha/ijNyoiL50EgzJSYkeLPdE4Bqw0a0SBYAqi56
         pWmOug0hX17FZQKRcF/gWu+1F4ecfO2mp2VneUgMnkyzCAJ5F6Z1W2Rhz4nQRgBvQP63
         Xb+79ybzI/2ivEPa2xMqaDQm7XWZMyAm3a/B7ssCtjOSWqgzxXR1Ru3RQb4oPU/Yzi71
         iIR7cH50XE1O+mt1tf4GQjEz5MQDTT1oQYOW7ja7sCxhMzI+m/JArPVo3phWzUF8ueGh
         Gg1/fXY95dm0Z4aDcfjcTC8YBe4gw9G4qPJvFAgHQBp0toR8vl7qCJ45iLqnik2JhUUK
         AG+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vpxEGo4it5d/Y7J9S3+pgBmU3IZbPtHu91dG5grVG6c=;
        b=PHa75PbdLQwGhTJ8kTV1676CXwEqj1rwPmjIeRIiOVsl0gNuGKvUTE++KaKxGCtx1l
         aArF0y+bZNLC48WQ+yGWWItVNRd0pNVWLR14Req70VUuUom2PK+oMmEOH5oPgfjad4nH
         NVCpY+/8P8t1UECisFhLbvBPCc0tfANhpQniCoq/B6hsWNZEckWWNPVNaf8m4sPKYjEW
         PjHKUIYQCixIQMK/IzPHXwrLC1XWewhqbh49lDZlL9jRMT+1lssgeSW17syVVvIBYYG7
         nJfI9eyv2JbHPc9ym0FQXGu73Ty0ZQ5we3zbjTaXAwek33KetXS+kilabfF9GPN0T2rj
         gGAw==
X-Gm-Message-State: AOAM532LUG4C1CZGMaz5sRW3HVmhiGr3A2BUqK5Qjks8u1d3wsOFZh3p
        AkxejiGOAFBkgo7Xehm/QpY=
X-Google-Smtp-Source: ABdhPJwP0YyWacmxTy19zTNmbQBAypqajTKUz0005CSlCF7UnjNg3EGV95H/4rqQvaw21fRtT6KgaA==
X-Received: by 2002:a05:600c:35cd:: with SMTP id r13mr3950824wmq.186.1618419129731;
        Wed, 14 Apr 2021 09:52:09 -0700 (PDT)
Received: from [192.168.1.101] ([37.166.215.213])
        by smtp.gmail.com with ESMTPSA id o20sm488526wmq.29.2021.04.14.09.52.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Apr 2021 09:52:09 -0700 (PDT)
Subject: Re: A data race between fanout_demux_rollover() and __fanout_unlink()
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Xie He <xie.he.0141@gmail.com>
Cc:     "eyal.birger@gmail.com" <eyal.birger@gmail.com>,
        "yonatanlinik@gmail.com" <yonatanlinik@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Gong, Sishuai" <sishuai@purdue.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <4FE5BFAB-1988-4CA9-9B97-CEF73396B4EC@purdue.edu>
 <CAJht_EN-7OPijuS4kjqL71tfQHcg_aa9c9SZSQBmSvcNP5fFow@mail.gmail.com>
 <CA+FuTSdtdhJ+ZnGfmY3CxvPNGgPJdhV89bUfXVmkk4FszpUAVw@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <5958c722-7dcd-4342-291f-692a123ef931@gmail.com>
Date:   Wed, 14 Apr 2021 18:52:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSdtdhJ+ZnGfmY3CxvPNGgPJdhV89bUfXVmkk4FszpUAVw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/14/21 1:27 AM, Willem de Bruijn wrote:
> On Tue, Apr 13, 2021 at 6:55 PM Xie He <xie.he.0141@gmail.com> wrote:
>>
>> On Tue, Apr 13, 2021 at 1:51 PM Gong, Sishuai <sishuai@purdue.edu> wrote:
>>>
>>> Hi,
>>>
>>> We found a data race in linux-5.12-rc3 between af_packet.c functions fanout_demux_rollover() and __fanout_unlink() and we are able to reproduce it under x86.
>>>
>>> When the two functions are running together, __fanout_unlink() will grab a lock and modify some attribute of packet_fanout variable, but fanout_demux_rollover() may or may not see this update depending on different interleavings, as shown in below.
>>>
>>> Currently, we didn’t find any explicit errors due to this data race. But in fanout_demux_rollover(), we noticed that the data-racing variable is involved in the later operation, which might be a concern.
>>>
>>> ------------------------------------------
>>> Execution interleaving
>>>
>>> Thread 1                                                        Thread 2
>>>
>>> __fanout_unlink()                                               fanout_demux_rollover()
>>> spin_lock(&f->lock);
>>>                                                                         po = pkt_sk(f->arr[idx]);
>>>                                                                         // po is a out-of-date value
>>> f->arr[i] = f->arr[f->num_members - 1];
>>> spin_unlock(&f->lock);
>>>
>>>
>>>
>>> Thanks,
>>> Sishuai
>>
>> CC'ing more people.
> 
> __fanout_unlink removes a socket from the fanout group, but ensures
> that the socket is not destroyed until after no datapath can refer to
> it anymore, through a call to synchronize_net.
> 

Right, but there is a data race.

Compiler might implement 

f->arr[i] = f->arr[f->num_members - 1];

(And po = pkt_sk(f->arr[idx]);

Using one-byte-at-a-time load/stores, yes crazy, but oh well.

We should use READ_ONCE()/WRITE_ONCE() at very minimum,
and rcu_dereference()/rcu_assign_pointer() since we clearly rely on standard RCU rules.



