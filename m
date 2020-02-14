Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 709DD15F4A1
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 19:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403930AbgBNSWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 13:22:37 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43037 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389732AbgBNSWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 13:22:08 -0500
Received: by mail-pg1-f195.google.com with SMTP id u12so4992051pgb.10
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 10:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pKiBW8YRBhHE8nd6rzlyd1Qf1Xuq+wHP7PyG8rBbqu4=;
        b=F5lULw1qhirk0oXC3EpTx9DHjqsEVE7CN6AQIpWqV6fO9ghcDaxpsW/JDkIEC5FBNi
         OIHbrTNjZbuV8Sj21JULaVsnGr62IoWcdrF49OZmgM/AYPnFyLmfr/HKuaNlWOfJmzr1
         dFmEJWVh5mcXEGVahEyoA0TaGo+5rMoS0ctM6Ebuekz0ukKAT0ZmWjYHS2v9QurXyOUg
         dR8V4k0QZulmkNXDDkM1fwowOF5j2Ys/VUg7h3+94sARXVE5uvyNqQVayBeewOCN5QKH
         3jr7rtPgejCiIiCZNskd/k9m38bu51eHFLX+f5ygqNX8UGVoQ0CFK7jH2nYAmkP5u06Z
         8q1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pKiBW8YRBhHE8nd6rzlyd1Qf1Xuq+wHP7PyG8rBbqu4=;
        b=i2vVPJkS+8RO4uqhdPdM5p9RBTGE/EzQLV9RmwNWUKf05yCIk/IF1FN33MLIhDWoV0
         /b2QtfnTJxXo0k3cMP0liP2lZRXQr3vJMgbs8dZdCtoPq76qveIDneg5EIIVV8SN9OXP
         GpDcyCDvwk4olCqgw3R99KVZ6D0kORP2vrWyHoKS1tZs98vKhTtv04fslnBAjzt8+mr+
         DwuNYzD5tX+vbcYyff0f50CMPC/KeA1gxlqoO6LP6fCdKGOJKDFRCnSQwj8l2cyd5wyq
         VofNBAjn/i4PTJqZJelZT4gmU7LrICDx5s71mL/o6/8XyhwaRTMCAbZslIUuXTTMKtOq
         rV7A==
X-Gm-Message-State: APjAAAUVgDebXydhgQXLH/rRUfcFp60f8YRZj5Ilz5t43z5OT6sI393y
        /316qSQgAV315QDn5c4aaLo=
X-Google-Smtp-Source: APXvYqwVxT090XKiUpZf9wdK3gdfNJ4J97p/94kxMOlfGbA6w9/wLL7jsXDm6yumQf/aukBvw4zS0Q==
X-Received: by 2002:a65:68d8:: with SMTP id k24mr5044814pgt.208.1581704527923;
        Fri, 14 Feb 2020 10:22:07 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id b12sm8044486pfr.26.2020.02.14.10.22.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 10:22:07 -0800 (PST)
Subject: Re: [PATCH v2 net 3/3] wireguard: send: account for mtu=0 devices
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <20200214173407.52521-1-Jason@zx2c4.com>
 <20200214173407.52521-4-Jason@zx2c4.com>
 <135ffa7a-f06a-80e3-4412-17457b202c77@gmail.com>
 <CAHmME9pjLfscZ-b0YFsOoKMcENRh4Ld1rfiTTzzHmt+OxOzdjA@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e20d0c52-cb83-224d-7507-b53c5c4a5b69@gmail.com>
Date:   Fri, 14 Feb 2020 10:22:02 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAHmME9pjLfscZ-b0YFsOoKMcENRh4Ld1rfiTTzzHmt+OxOzdjA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/14/20 10:15 AM, Jason A. Donenfeld wrote:
> On Fri, Feb 14, 2020 at 6:56 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> Oh dear, can you describe what do you expect of a wireguard device with mtu == 0 or mtu == 1
>>
>> Why simply not allowing silly configurations, instead of convoluted tests in fast path ?
>>
>> We are speaking of tunnels adding quite a lot of headers, so we better not try to make them
>> work on networks with tiny mtu. Just say no to syzbot.
> 
> The idea was that wireguard might still be useful for the persistent
> keepalive stuff. This branch becomes very cold very fast, so I don't
> think it makes a difference performance wise, but if you feel strongly
> about it, I can get rid of it and set a non-zero min_mtu that's the
> smallest thing wireguard's xmit semantics will accept. It sounds like
> you'd prefer that?
> 
Well, if you believe that wireguard in persistent keepalive
has some value on its own, I guess that we will have to support this mode.

Some legacy devices can have arbitrary mtu, and this has caused headaches.
I was hoping that for brand new devices, we could have saner limits.

About setting max_mtu to ~MAX_INT, does it mean wireguard will attempt
to send UDP datagrams bigger than 64K ? Where is the segmentation done ?
