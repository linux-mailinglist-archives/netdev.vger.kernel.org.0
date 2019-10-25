Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7AAFE4788
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 11:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438752AbfJYJlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 05:41:40 -0400
Received: from mail-lj1-f177.google.com ([209.85.208.177]:46682 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436710AbfJYJlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 05:41:40 -0400
Received: by mail-lj1-f177.google.com with SMTP id k20so676980ljk.13
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 02:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=6NfBzBODp+mvvMTG0sObTS1pzfB38qWD7gIfxONgitA=;
        b=yQ7gCExzdPxwkXltZC+lHDsW6hVL1LMHb6vnSzWaWs/NgO0fEFdjqjCX1kB4yKn8dy
         Ql1/h7AuQjOhw8NI9R3ewTyQf6nZOzPCYpSxA6ih9daDMEJWImQI2cdgWxkQhgNd7FR/
         lWM81f0OuRQ34vZCSCF3J0MrI6QeYREW0ELsM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=6NfBzBODp+mvvMTG0sObTS1pzfB38qWD7gIfxONgitA=;
        b=qXaSe3Oh+JaNXe3iqwCKvmHrgIZnskB36XJo17i/qlAbZBFApxhOsrszu4L69eHnDB
         6hcXQBQwhHaotvXIaExaz86Pk4AJrjG6sdkfZYc3J5Y15z1L+0I2J6jq6C6wUv8++z38
         5kGDz0pU+J5A1klhT2Cbk02eMrbfYJ6WnhYteNEVzmkZFW/Uhr+xqRMjEzfywEoARH1B
         54W+8lcKas9uHHw/VYeBFIEyNpfPuuCIvN1OvOhWEOKc4+acSnITBU0xc4mDvri5FOFG
         9Fecm/TXQJsPnJFuQQa9xPC+J72ce9E4i1yWA/MaFIAI0dkm7RQxt8Y5oqJzrxi75bqN
         +P7g==
X-Gm-Message-State: APjAAAXe7wIPnd62gZD+jZX7bmtUPUq+DGtnu+vw89329ydEJ7Ezq8qX
        KBQ8JFdWvX4UdUReZbXFM1S+DQ==
X-Google-Smtp-Source: APXvYqx42XUvXibIk8HAf3vkyMQNpwJARHxfEFCRIFuJYZ1UWBzpHnKMXcXkJFvvx1OnXzCbwb/fIw==
X-Received: by 2002:a2e:87ca:: with SMTP id v10mr1709790ljj.43.1571996498157;
        Fri, 25 Oct 2019 02:41:38 -0700 (PDT)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id y8sm555637ljh.21.2019.10.25.02.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 02:41:37 -0700 (PDT)
References: <20191022113730.29303-1-jakub@cloudflare.com> <20191022113730.29303-3-jakub@cloudflare.com> <5db1da20174b1_5c282ada047205c046@john-XPS-13-9370.notmuch>
User-agent: mu4e 1.1.0; emacs 26.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        netdev@vger.kernel.org, kernel-team@cloudflare.com
Subject: Re: [RFC bpf-next 2/5] bpf, sockmap: Allow inserting listening TCP sockets into SOCKMAP
In-reply-to: <5db1da20174b1_5c282ada047205c046@john-XPS-13-9370.notmuch>
Date:   Fri, 25 Oct 2019 11:41:36 +0200
Message-ID: <87k18tcgbz.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 07:06 PM CEST, John Fastabend wrote:
> Jakub Sitnicki wrote:
>> In order for SOCKMAP type to become a generic collection for storing socket
>> references we need to loosen the checks in update callback.
>>
>> Currently SOCKMAP requires the TCP socket to be in established state, which
>> prevents us from using it to keep references to listening sockets.
>>
>> Change the update pre-checks so that it is sufficient for socket to be in a
>> hash table, i.e. have a local address/port, to be inserted.
>>
>> Return -EINVAL if the condition is not met to be consistent with
>> REUSEPORT_SOCKARRY map type.
>>
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> ---
>
> We need to also have some tests then to verify redirecting to this listen socket
> does the correct thing. Once its in the map we can redirect (ingress or egress)
> to it and need to be sure the semantics are sane.

You're right. The redirect BPF helpers that operate on SOCMAP might be
relying on an assumption that sockets are in established state. I need
look into that.

Thanks,
Jakub

