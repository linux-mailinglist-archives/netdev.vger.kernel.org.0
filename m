Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72F69E716B
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 13:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389097AbfJ1Mfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 08:35:31 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43491 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389093AbfJ1Mfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 08:35:31 -0400
Received: by mail-lj1-f193.google.com with SMTP id s4so10259033ljj.10
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 05:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=zLkZX9qx2P17GLcgAe1vG+UBGpFHGA4/zPraTmeHYSw=;
        b=OFvPBp7Vg2UpIkRgRb9jVTXaGST/waO25X9tSbEVJPQLCIqBH5+Rb4EETySADEp7fF
         4GbAto0zybKkk7b7Az1MaG9bcHbGg87hs0HFY2mP/smZ+sS7G3VOkr6vB94dNubJxOlZ
         a7z65QjlacTFzC0Edys5wYDix05YMZcNNnJWE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=zLkZX9qx2P17GLcgAe1vG+UBGpFHGA4/zPraTmeHYSw=;
        b=tpGvz2/PXm5rcE9OeiwA4P4+TetIt6DW75gBJunfAD4dfQrCZR+6Jp612GtnF44Srp
         CyDqAXXG/qK5mVrKSxI5vVDfdOeEKm9MZHxXxyMfpe0X3LtnbZHKeEiyAa99W2BDqL3O
         O5ytSqHpiDqydL5RQ4WE5lJtjvjndDTheAO3jxRIc48YL0wkEoyIFDHc9uGjo6sQOzg9
         fmrVi7JUs4Kf2Ryzu+Zwgblz03DVflQeCrRVixjo4gFA1gz8e6YrrTiAOxvIfee3Aaoj
         Q05fNSaoCNTq37Awik9/1nkHm6YhtTArvUbktvOD5LTT364I2MK7q3Id/BKxmAYOavre
         9G5w==
X-Gm-Message-State: APjAAAXJ1ugx/tABrVw/zb2YDs23lLhjVfsIarC37BnU+s45EwsfzTBY
        IQCMKQf8HpA18Q90bQQT0uPbbg==
X-Google-Smtp-Source: APXvYqyfuZlbbVwVQRNPAso+bzp3wV280wNV8pAxeraP4ab/uNAnjm1F8C/akXd8Oi/1QynzhImTqw==
X-Received: by 2002:a2e:9149:: with SMTP id q9mr12137846ljg.49.1572266127720;
        Mon, 28 Oct 2019 05:35:27 -0700 (PDT)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id t6sm6216464ljd.102.2019.10.28.05.35.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 05:35:26 -0700 (PDT)
References: <20191022113730.29303-1-jakub@cloudflare.com> <20191028055247.bh5bctgxfvmr3zjh@kafai-mbp.dhcp.thefacebook.com>
User-agent: mu4e 1.1.0; emacs 26.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Martin Lau <kafai@fb.com>
Cc:     "bpf\@vger.kernel.org" <bpf@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team\@cloudflare.com" <kernel-team@cloudflare.com>
Subject: Re: [RFC bpf-next 0/5] Extend SOCKMAP to store listening sockets
In-reply-to: <20191028055247.bh5bctgxfvmr3zjh@kafai-mbp.dhcp.thefacebook.com>
Date:   Mon, 28 Oct 2019 13:35:26 +0100
Message-ID: <875zk9oxo1.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 28, 2019 at 06:52 AM CET, Martin Lau wrote:
> On Tue, Oct 22, 2019 at 01:37:25PM +0200, Jakub Sitnicki wrote:
>> This patch set is a follow up on a suggestion from LPC '19 discussions to
>> make SOCKMAP (or a new map type derived from it) a generic type for storing
>> established as well as listening sockets.
>>
>> We found ourselves in need of a map type that keeps references to listening
>> sockets when working on making the socket lookup programmable, aka BPF
>> inet_lookup [1].  Initially we repurposed REUSEPORT_SOCKARRAY but found it
>> problematic to extend due to being tightly coupled with reuseport
>> logic (see slides [2]).
>> So we've turned our attention to SOCKMAP instead.
>>
>> As it turns out the changes needed to make SOCKMAP suitable for storing
>> listening sockets are self-contained and have use outside of programming
>> the socket lookup. Hence this patch set.
>>
>> With these patches SOCKMAP can be used in SK_REUSEPORT BPF programs as a
>> drop-in replacement for REUSEPORT_SOCKARRAY for TCP. This can hopefully
>> lead to code consolidation between the two map types in the future.
> What is the plan for UDP support in sockmap?

It's on our road-map because without SOCKMAP support for UDP we won't be
able to move away from TPROXY [1] and custom SO_BINDTOPREFIX extension
[2] for steering new UDP flows to receiving sockets. Also we would like
to look into using SOCKMAP for connected UDP socket splicing in the
future [3].

I was planning to split work as follows:

1. SOCKMAP support for listening sockets (this series)
2. programmable socket lookup for TCP (cut-down version of [4])
3. SOCKMAP support for UDP (work not started)
4. programmable socket lookup for UDP (rest of [4])

I'm open to suggestions on how to organize it.

>> Having said that, the main intention here is to lay groundwork for using
>> SOCKMAP in the next iteration of programmable socket lookup patches.
> What may be the minimal to get only lookup work for UDP sockmap?
> .close() and .unhash()?

John would know better. I haven't tried doing it yet.

From just reading the code - override the two proto ops you mentioned,
close and unhash, and adapt the socket checks in SOCKMAP.

-Jakub

[1] https://blog.cloudflare.com/how-we-built-spectrum/
[2] https://lore.kernel.org/netdev/1458699966-3752-1-git-send-email-gilberto.bertin@gmail.com/
[3] https://lore.kernel.org/bpf/20190828072250.29828-1-jakub@cloudflare.com/
[4] https://blog.cloudflare.com/sockmap-tcp-splicing-of-the-future/
