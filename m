Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F36015F62C
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 19:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387401AbgBNSxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 13:53:39 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36218 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728859AbgBNSxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 13:53:38 -0500
Received: by mail-pg1-f193.google.com with SMTP id d9so5400897pgu.3
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 10:53:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YFlrJHaqVayeVyENg3WpM+zty9btr9v4Lyo7MJDfBPw=;
        b=Gc4mMDPmorWN9VsxeEgoBOQ9SgCnwRSvJ+HLPzvbBmyw1XjKRcjw4335y8Tu1x/4qh
         vf78Yp2zGNfPMOfS5nhOl2+6PXdzvEA0bzFY+skgvYvJS6pvrEV+ekKwgbS5ot5z43jB
         STtEv1bOgtIqENxUhV/Bxl6BeW8TG62OPIQoT8YLCNJVHkgzgB95MPOk+lNVxv5ELRip
         4B7IBAlr/SxpTMsxlU8wOVL2uFmHpaKbh6Z+Bv9De40Iki9pEioEAMc8elxVsGG1orjZ
         glsgEsBeebLQ7hCZ/os8vM5TybeukTWUph0/yXAAFRZg06/AnxUxbW+L2IlwzL6NuC+q
         6Z/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YFlrJHaqVayeVyENg3WpM+zty9btr9v4Lyo7MJDfBPw=;
        b=d0fW5SZt6wQ1eh2eWp00G0IOgwQD1NFpsvtpsRAvG2LxOSQihhKvDlj/21j7pgC6/u
         DQz5WppCI8kWES8rivuwfkwuQP4Y36GgwRVbnVBSk/wWBOGYsahZJ34Q0EdJvmZmLmpF
         PEETKHC3mi/CttNVrOu+/V2iKWzio5jnV1ZfWpfsoZAteymHF3I8KFFurdESD0uFQpNM
         T5yAK7Bq7wRwewcbObSv1UotLbwNjBkvXAS177RHEBy39dlC1cNtpyeKWnnG+qbVeXhw
         BVWjPmdwg1t8vas1AboD0eh0zGqkHZr2lY44CHorq5sdDJsJ5J9qCfdm0He6SReo366t
         KoYQ==
X-Gm-Message-State: APjAAAX8j8aMdTotlSh6wdJUyTDRebFZXQKTzrdfYU98TaKwd4sFLniD
        YgU6gJPBheoXIXGygsV4YoA=
X-Google-Smtp-Source: APXvYqyGipnm9v99Wmub6c/0/cuG6ex7Ko/wYnvYLzHs+m4NH3inISPa0RTroRCylLG/ie4ie2YOXw==
X-Received: by 2002:a62:878a:: with SMTP id i132mr4950972pfe.8.1581706418167;
        Fri, 14 Feb 2020 10:53:38 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id i64sm7996084pgc.51.2020.02.14.10.53.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 10:53:37 -0800 (PST)
Subject: Re: [PATCH v2 net 3/3] wireguard: send: account for mtu=0 devices
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <20200214173407.52521-1-Jason@zx2c4.com>
 <20200214173407.52521-4-Jason@zx2c4.com>
 <135ffa7a-f06a-80e3-4412-17457b202c77@gmail.com>
 <CAHmME9pjLfscZ-b0YFsOoKMcENRh4Ld1rfiTTzzHmt+OxOzdjA@mail.gmail.com>
 <e20d0c52-cb83-224d-7507-b53c5c4a5b69@gmail.com>
 <CAHmME9oXfDCGmsCJJEuaPmgj7_U4yfrBoqi0wRZrOD9SdWny_w@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <ec52e8cb-5649-9167-bb14-7e9775c6a8be@gmail.com>
Date:   Fri, 14 Feb 2020 10:53:27 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAHmME9oXfDCGmsCJJEuaPmgj7_U4yfrBoqi0wRZrOD9SdWny_w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/14/20 10:37 AM, Jason A. Donenfeld wrote:
> On 2/14/20, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>>
>> On 2/14/20 10:15 AM, Jason A. Donenfeld wrote:
>>> On Fri, Feb 14, 2020 at 6:56 PM Eric Dumazet <eric.dumazet@gmail.com>
>>> wrote:
>>>> Oh dear, can you describe what do you expect of a wireguard device with
>>>> mtu == 0 or mtu == 1
>>>>
>>>> Why simply not allowing silly configurations, instead of convoluted tests
>>>> in fast path ?
>>>>
>>>> We are speaking of tunnels adding quite a lot of headers, so we better
>>>> not try to make them
>>>> work on networks with tiny mtu. Just say no to syzbot.
>>>
>>> The idea was that wireguard might still be useful for the persistent
>>> keepalive stuff. This branch becomes very cold very fast, so I don't
>>> think it makes a difference performance wise, but if you feel strongly
>>> about it, I can get rid of it and set a non-zero min_mtu that's the
>>> smallest thing wireguard's xmit semantics will accept. It sounds like
>>> you'd prefer that?
>>>
>> Well, if you believe that wireguard in persistent keepalive
>> has some value on its own, I guess that we will have to support this mode.
> 
> Alright.
> 
>>
>> Some legacy devices can have arbitrary mtu, and this has caused headaches.
>> I was hoping that for brand new devices, we could have saner limits.
>>
>> About setting max_mtu to ~MAX_INT, does it mean wireguard will attempt
>> to send UDP datagrams bigger than 64K ? Where is the segmentation done ?
> 
> The before passings off to the udp tunnel api, we indicate that we
> support ip segmentation, and then it gets handled and fragmented
> deeper down. Check out socket.c. 

Okay. Speaking of socket.c, I found this wg_socket_reinit() snippet :

synchronize_rcu();
synchronize_net();

Which makes little sense. Please add a comment explaining why these two
calls are needed.

