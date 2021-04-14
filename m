Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6FEB35FA1A
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 19:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351203AbhDNRwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 13:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236918AbhDNRwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 13:52:38 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9892C061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 10:52:16 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id p19so11092511wmq.1
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 10:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vGmoghB+9yMteFgy2MCsH99naO8JhYjSFRs9gce09zw=;
        b=tcOB4ou9gOvvQYoG+sTsxsouq9VuTw6SJpyLwevB6fFKyR2eOgpoQY6YqUfuSQVmLj
         twFyisaUU0+UTasz5RGTE1/VNvfa3YgFq+FA4soextWK6uh8lNEZZziOmnyaC5xqJoch
         dN/OHpuKRwigxAKLRpZnQSXy8HwhsKGfnYLtaUMLUKCiZuyMas+eyZXlaKizDi8soGHZ
         U0lSmaLVRdVYtNsXeuCdd51i1oFxQ2ihfWjsaaBaL7KJD6CDsCqWSNYzF3rVNBWpQCHw
         +L9JvP2SeFHkK72H1LYyhg9gv/3HAKqbBt3HE2lrC+TQJd8QpmkCf0v+ZBFrINV5Mhp6
         SonA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vGmoghB+9yMteFgy2MCsH99naO8JhYjSFRs9gce09zw=;
        b=OM3Yj+U0vLJpqQoBqJ4XToO/EWQE6ujSwboF0vIzCsAFUbHmp5pdJ4VCw2AduQIDsP
         JwrgvAYgKvA3pA89eEiZemC8dM9+DgtmYTCWK8rhKMX6Zksh/LO+l0dUd3JhSCQs6blS
         Wl3J8PKntgvQYBRO7UHlZpWHxcI6YMgwzvJ6USvx+xu4QkK1Me7CIRF5f7VeDdFYw1Ps
         GS8e7mY/eXf5Umj0CTZL/uNWb/hnm/C7UP/lHNrEvXNwUS/7nxt9vRoMFQe1Js1WSzzg
         Okas8N/6l6/mETYgujVvg7oPEM+t1w5sr7vQ5MydonJpNzvoQ2UPjJH/w4iwRjC6j9KK
         3B/Q==
X-Gm-Message-State: AOAM532m1DKJGbkm1smE36UUs/FglRSmixSSBkwwZo35Kkf8oKZw1ElO
        JKABnonDOhW/onAF4tSTr91Nt49R8lk=
X-Google-Smtp-Source: ABdhPJwfbSROTkhUNcrgF6rL7dJIMNcCY1+mhSVMUX9ZRDBGlY/83GjVPSgrlcedsSlWNTN2XILLIg==
X-Received: by 2002:a1c:7215:: with SMTP id n21mr1862175wmc.61.1618422735443;
        Wed, 14 Apr 2021 10:52:15 -0700 (PDT)
Received: from [192.168.1.101] ([37.166.215.213])
        by smtp.gmail.com with ESMTPSA id 61sm140747wrm.52.2021.04.14.10.52.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Apr 2021 10:52:15 -0700 (PDT)
Subject: Re: A data race between fanout_demux_rollover() and __fanout_unlink()
From:   Eric Dumazet <eric.dumazet@gmail.com>
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
 <5958c722-7dcd-4342-291f-692a123ef931@gmail.com>
Message-ID: <abef5079-a604-8aa1-39ba-38ae115178e7@gmail.com>
Date:   Wed, 14 Apr 2021 19:52:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <5958c722-7dcd-4342-291f-692a123ef931@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/14/21 6:52 PM, Eric Dumazet wrote:
> 
> 
> On 4/14/21 1:27 AM, Willem de Bruijn wrote:
>> On Tue, Apr 13, 2021 at 6:55 PM Xie He <xie.he.0141@gmail.com> wrote:
>>>
>>> On Tue, Apr 13, 2021 at 1:51 PM Gong, Sishuai <sishuai@purdue.edu> wrote:
>>>>
>>>> Hi,
>>>>
>>>> We found a data race in linux-5.12-rc3 between af_packet.c functions fanout_demux_rollover() and __fanout_unlink() and we are able to reproduce it under x86.
>>>>
>>>> When the two functions are running together, __fanout_unlink() will grab a lock and modify some attribute of packet_fanout variable, but fanout_demux_rollover() may or may not see this update depending on different interleavings, as shown in below.
>>>>
>>>> Currently, we didn’t find any explicit errors due to this data race. But in fanout_demux_rollover(), we noticed that the data-racing variable is involved in the later operation, which might be a concern.
>>>>
>>>> ------------------------------------------
>>>> Execution interleaving
>>>>
>>>> Thread 1                                                        Thread 2
>>>>
>>>> __fanout_unlink()                                               fanout_demux_rollover()
>>>> spin_lock(&f->lock);
>>>>                                                                         po = pkt_sk(f->arr[idx]);
>>>>                                                                         // po is a out-of-date value
>>>> f->arr[i] = f->arr[f->num_members - 1];
>>>> spin_unlock(&f->lock);
>>>>
>>>>
>>>>
>>>> Thanks,
>>>> Sishuai
>>>
>>> CC'ing more people.
>>
>> __fanout_unlink removes a socket from the fanout group, but ensures
>> that the socket is not destroyed until after no datapath can refer to
>> it anymore, through a call to synchronize_net.
>>
> 
> Right, but there is a data race.
> 
> Compiler might implement 
> 
> f->arr[i] = f->arr[f->num_members - 1];
> 
> (And po = pkt_sk(f->arr[idx]);
> 
> Using one-byte-at-a-time load/stores, yes crazy, but oh well.
> 
> We should use READ_ONCE()/WRITE_ONCE() at very minimum,
> and rcu_dereference()/rcu_assign_pointer() since we clearly rely on standard RCU rules.
> 
> 
> 

I will test something like :

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 118d585337d72f10cd31ec5ca7c55b508fc18baf..ba96db1880eae89febf77ba6ff943b054cd268d7 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1359,7 +1359,7 @@ static unsigned int fanout_demux_rollover(struct packet_fanout *f,
        struct packet_sock *po, *po_next, *po_skip = NULL;
        unsigned int i, j, room = ROOM_NONE;
 
-       po = pkt_sk(f->arr[idx]);
+       po = pkt_sk(rcu_dereference(f->arr[idx]));
 
        if (try_self) {
                room = packet_rcv_has_room(po, skb);
@@ -1371,7 +1371,7 @@ static unsigned int fanout_demux_rollover(struct packet_fanout *f,
 
        i = j = min_t(int, po->rollover->sock, num - 1);
        do {
-               po_next = pkt_sk(f->arr[i]);
+               po_next = pkt_sk(rcu_dereference(f->arr[i]));
                if (po_next != po_skip && !READ_ONCE(po_next->pressure) &&
                    packet_rcv_has_room(po_next, skb) == ROOM_NORMAL) {
                        if (i != j)
@@ -1466,7 +1466,7 @@ static int packet_rcv_fanout(struct sk_buff *skb, struct net_device *dev,
        if (fanout_has_flag(f, PACKET_FANOUT_FLAG_ROLLOVER))
                idx = fanout_demux_rollover(f, skb, idx, true, num);
 
-       po = pkt_sk(f->arr[idx]);
+       po = pkt_sk(rcu_dereference(f->arr[idx]));
        return po->prot_hook.func(skb, dev, &po->prot_hook, orig_dev);
 }
 
@@ -1480,7 +1480,7 @@ static void __fanout_link(struct sock *sk, struct packet_sock *po)
        struct packet_fanout *f = po->fanout;
 
        spin_lock(&f->lock);
-       f->arr[f->num_members] = sk;
+       rcu_assign_pointer(f->arr[f->num_members], sk);
        smp_wmb();
        f->num_members++;
        if (f->num_members == 1)
@@ -1495,11 +1495,14 @@ static void __fanout_unlink(struct sock *sk, struct packet_sock *po)
 
        spin_lock(&f->lock);
        for (i = 0; i < f->num_members; i++) {
-               if (f->arr[i] == sk)
+               if (rcu_dereference_protected(f->arr[i],
+                                             lockdep_is_held(&f->lock)) == sk)
                        break;
        }
        BUG_ON(i >= f->num_members);
-       f->arr[i] = f->arr[f->num_members - 1];
+       rcu_assign_pointer(f->arr[i],
+                          rcu_dereference_protected(f->arr[f->num_members - 1],
+                                                    lockdep_is_held(&f->lock)));
        f->num_members--;
        if (f->num_members == 0)
                __dev_remove_pack(&f->prot_hook);
diff --git a/net/packet/internal.h b/net/packet/internal.h
index 5f61e59ebbffaa25a8fdfe31f79211fe6a755c51..48af35b1aed2565267c0288e013e23ff51f2fcac 100644
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -94,7 +94,7 @@ struct packet_fanout {
        spinlock_t              lock;
        refcount_t              sk_ref;
        struct packet_type      prot_hook ____cacheline_aligned_in_smp;
-       struct sock             *arr[];
+       struct sock     __rcu   *arr[];
 };
 
 struct packet_rollover {

