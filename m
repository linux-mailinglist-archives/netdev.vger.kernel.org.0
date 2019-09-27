Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49DDCC0CD0
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 22:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfI0Urf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 16:47:35 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42958 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbfI0Urf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 16:47:35 -0400
Received: by mail-pg1-f193.google.com with SMTP id z12so4068102pgp.9;
        Fri, 27 Sep 2019 13:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bzYSSPrgLAC4YfKvOYdW8JV9P97aaiQ4S1KEYZ0vYTQ=;
        b=UuD1GphT5DoxXuKlWeBSG54du7TXGyNIeEUMIePFxzgEIkFr2ZWqssI95w2VXDN221
         J5feVuwTpfDOnSNEFHt1mMjKL8Bqk4Dus52w9JF/Gr9ROjlz95Qk57bfY3R4pLmKZje+
         J1YArd90GlQSypsRsYaXu+3ga5DW1vajaeuZx8Ee60JvUxxphHKE/ghf1M2ybddCRizU
         xvU56hF0HcNeVLwF3wS4jPqE2rDLd+8yoI0P23DEURKoOKmtiKgoXFpXltRmIU8j62ua
         ufxkmjFI8LVBNvJSZXalgp+d2/nfHjvOXvKH8BoPXVXPCIKD74PCX3dlev5AN2B3MBAR
         eegQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bzYSSPrgLAC4YfKvOYdW8JV9P97aaiQ4S1KEYZ0vYTQ=;
        b=lF7TcOX6rOrbCyT5pTe3PbatQLbWCeV7raxtpGtR/AQS/+YPO3WCFzsrKEFVxvJnqL
         9kfsbAjNjAHlkmjvy2/+yumFosa10OSM6a4r/EtVDvjRWiw1Wdje8KZZkS3anrLH4+Tq
         9CMU9cX4FLltPOBldy1Gr66kVWSCJZz3ivuzVzNK1YgtT5qeIBxBRlaZ+zQ+Z1SwCLZw
         yuHAPAxPMnlMPVzSXEYzFNHF/qOZ++iPI0nPPPJZWFlsWvPZwgLjKrFEpD3MxXt800qi
         TicSh7f7G/354eiVr7jvnrrbebB+CHUqTIYZQ3AHCZRDF0JjfimHnyC9J14OtqWOgKkp
         ntRQ==
X-Gm-Message-State: APjAAAXYTgf3d6WPqiNIt56Vyyp0iABm4YQJmJHKghimkBmezaAfj21c
        Dx3tP1RzMuWPUjazHgP27oQ=
X-Google-Smtp-Source: APXvYqy1C1JP1b3d0GSZuPk0C4n/gYXS1ppofxspzJZADstlQttHJW26kqX6aSA8QGbj0VSrVAuChA==
X-Received: by 2002:a17:90a:bb97:: with SMTP id v23mr11812267pjr.84.1569617254604;
        Fri, 27 Sep 2019 13:47:34 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id g5sm6181080pgd.82.2019.09.27.13.47.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Sep 2019 13:47:33 -0700 (PDT)
Subject: Re: [PATCH bpf] bpf: Fix a race in reuseport_array_free()
To:     Martin Lau <kafai@fb.com>, Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>
References: <20190927165221.2391541-1-kafai@fb.com>
 <04f683c6-ac49-05fb-6ec9-9f0d698657a2@gmail.com>
 <20190927181729.7ep3pp2hiy6l5ixk@kafai-mbp.dhcp.thefacebook.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <fc762c01-94da-7f72-4fc0-9b76d6bbe3dd@gmail.com>
Date:   Fri, 27 Sep 2019 13:47:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190927181729.7ep3pp2hiy6l5ixk@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/27/19 11:17 AM, Martin Lau wrote:
> On Fri, Sep 27, 2019 at 10:24:49AM -0700, Eric Dumazet wrote:
>>
>>
>> On 9/27/19 9:52 AM, Martin KaFai Lau wrote:
>>> In reuseport_array_free(), the rcu_read_lock() cannot ensure sk is still
>>> valid.  It is because bpf_sk_reuseport_detach() can be called from
>>> __sk_destruct() which is invoked through call_rcu(..., __sk_destruct).
>>
>> We could question why reuseport_detach_sock(sk) is called from __sk_destruct()
>> (after the rcu grace period) instead of sk_destruct() ?
> Agree.  It is another way to fix it.
> 
> In this patch, I chose to avoid the need to single out a special treatment for
> reuseport_detach_sock() in sk_destruct().
> 
> I am happy either way.  What do you think?

It seems that since we call reuseport_detach_sock() after the rcu grace period,
another cpu could catch the sk pointer in reuse->socks[] array and use
it right before our cpu frees the socket.

RCU rules are not properly applied here I think.

The rules for deletion are :

1) unpublish object from various lists/arrays/hashes.
2) rcu_grace_period
3) free the object.

If we fix the unpublish (we need to anyway to make the data path safe),
then your patch is not needed ?

What about (totally untested, might be horribly wrong)

diff --git a/net/core/sock.c b/net/core/sock.c
index 07863edbe6fc4842e47ebebf00bc21bc406d9264..d31a4b094797f73ef89110c954aa0a164879362d 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1700,8 +1700,6 @@ static void __sk_destruct(struct rcu_head *head)
                sk_filter_uncharge(sk, filter);
                RCU_INIT_POINTER(sk->sk_filter, NULL);
        }
-       if (rcu_access_pointer(sk->sk_reuseport_cb))
-               reuseport_detach_sock(sk);
 
        sock_disable_timestamp(sk, SK_FLAGS_TIMESTAMP);
 
@@ -1728,7 +1726,13 @@ static void __sk_destruct(struct rcu_head *head)
 
 void sk_destruct(struct sock *sk)
 {
-       if (sock_flag(sk, SOCK_RCU_FREE))
+       bool use_call_rcu = sock_flag(sk, SOCK_RCU_FREE);
+
+       if (rcu_access_pointer(sk->sk_reuseport_cb)) {
+               reuseport_detach_sock(sk);
+               use_call_rcu = true;
+       }
+       if (use_call_rcu)
                call_rcu(&sk->sk_rcu, __sk_destruct);
        else
                __sk_destruct(&sk->sk_rcu);
