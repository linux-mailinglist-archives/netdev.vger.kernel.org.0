Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 423802B145
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 11:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbfE0J1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 05:27:36 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:36228 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbfE0J1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 05:27:36 -0400
Received: by mail-lj1-f193.google.com with SMTP id z1so8610151ljb.3
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 02:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=cwWPzDEgZJUVL1oPbWThfft65Rbf8GdoOAZ8DEh/6/s=;
        b=RutcbYESzJUg3cQY1XLNamRCs7ibIaL38p+LI6gu9AxtrEovi2ilDB+/8u7O0Gz5dK
         aj6bAhAlR6b8vb9TskCEdft0dKB8IzwKyveMhad00bKBXba/JOGe81M3X2erVk6JhY2E
         5j41oNH4YmiL0PJlzWeUpFeBXcsW5JcSvijkM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=cwWPzDEgZJUVL1oPbWThfft65Rbf8GdoOAZ8DEh/6/s=;
        b=Rb3L6wzzu19IdsSUnx9by0TDH34YipC5bnt+utZz2LueWZGA5LAUGzgFZZN72nKnlC
         0pJQ8sts+L3QqOASU6CGK+7cXRO1yxPNYybeUZSS4jo7eny5Yndz2IOPPlB9G/Zad4uY
         A594Xyd6V//Go3EVBLSRLXFe7rQAry7JDliQ/QfEgr9KiusMz1d01HL8gHNheet6TQwl
         Jct9sIuyWb0vbuSAHJPH5UAYotQwg22nMo2W1ee+EAYvFEa9wfysDYNXtfevZQUIoAAI
         StUHkcmnHHFmiO0/Aw/hIvwLYUe+MqUsNQgUes3dvlZpLZonx3eAQ/e4h84VfXvXY1lC
         w+WA==
X-Gm-Message-State: APjAAAX5hQhSDwYz/bOSFzvEGzdHhJs4W5Y5jA/+NVjNvbIL0W8ih2PC
        ZjvSIjqKHDQIFRsAuzG6PxX5p+GIy0zTMA==
X-Google-Smtp-Source: APXvYqyfZuP3ef9c04mGXJeEI+O5/tDa6/2kbMcqo+BjzYpC6RMbn32ImBtRBNoidhi1UMblKUj34A==
X-Received: by 2002:a2e:8816:: with SMTP id x22mr31590312ljh.169.1558949254043;
        Mon, 27 May 2019 02:27:34 -0700 (PDT)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id y19sm2169718lfl.40.2019.05.27.02.27.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 27 May 2019 02:27:32 -0700 (PDT)
References: <20190211090949.18560-1-jakub@cloudflare.com> <5439765e-1288-c379-0ead-75597092a404@iogearbox.net> <871s423i6d.fsf@cloudflare.com> <5ce45a6fcd82d_48b72ac3337c45b85f@john-XPS-13-9360.notmuch> <87v9y2zqpz.fsf@cloudflare.com> <5ce6c32418618_64ba2ad730e1a5b44@john-XPS-13-9360.notmuch> <87r28oz398.fsf@cloudflare.com> <5ce81306aacbe_39402ae86c50a5bc2f@john-XPS-13-9360.notmuch>
User-agent: mu4e 1.1.0; emacs 26.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Marek Majkowski <marek@cloudflare.com>
Subject: Re: [PATCH net] sk_msg: Keep reference on socket file while psock lives
In-reply-to: <5ce81306aacbe_39402ae86c50a5bc2f@john-XPS-13-9360.notmuch>
Date:   Mon, 27 May 2019 11:27:31 +0200
Message-ID: <87k1ecz1q4.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 05:51 PM CEST, John Fastabend wrote:
> Jakub Sitnicki wrote:
>>
>> Now that those pesky crashes are gone, we plan to look into drops when
>> doing echo with sockmap. Marek tried running echo-sockmap [1] with
>> latest bpf-next (plus mentioned crash fixes) and reports that not all
>> data bounces back:
>>
>> $ yes| head -c $[1024*1024] | nc -q2 192.168.1.33 1234 |wc -c
>> 971832
>> $ yes| head -c $[1024*1024] | nc -q2 192.168.1.33 1234 |wc -c
>> 867352
>> $ yes| head -c $[1024*1024] | nc -q2 192.168.1.33 1234 |wc -c
>> 952648
>>
>> I'm tring to turn echo-sockmap into a selftest but as you can probably
>> guess over loopback all works fine.
>>
>
> Right, sockmap when used from recvmsg with redirect is lossy. This
> was a design choice I made that apparently caught a few people
> by surprise. The original rationale for this was when doing a
> multiplex operation, e.g. single ingress socket to many egress
> sockets blocking would cause head of line blocking on all
> sockets. To resolve this I simply dropped the packet and then allow
> the flow to continue. This pushes the logic up to the application
> to do retries, etc. when this happens. FWIW userspace proxies I
> tested also had similar points where they fell over and dropped
> packets. In hind sight though it probably would have made more
> sense to make this behavior opt-in vs the default. But, the
> use case I was solving at the time I wrote this could handle
> drops and was actually a NxM sockets with N ingress sockets and M
> egress sockets so head of line blocking was a real problem.
>
> Adding a flag to turn this into a blocking op has been on my
> todo list for awhile. Especially when sockmap is being used as
> a single ingress to single egress socket then blocking vs dropping
> makes much more sense.
>
> The place to look is in sk_psock_verdict_apply() in __SK_REDIRECT
> case there is a few checks and notice we can fallthrough to a
> kfree_skb(skb). This is most likely the drops you are hitting.
> Maybe annotate it with a dbg statement to check.
>
> To fix this we could have a flag to _not_ drop but enqueue the
> packet regardless of the test or hold it until space is
> available. I even think sk_psock_strp_read could push back
> on the stream parser which would eventually push back via TCP
> and get the behavior you want.
>
> Also, I have a couple items on my TODO list that I'll eventually
> get to. First we run without stream parsers in some Cilium
> use cases. I'll push some patches to allow this in the next
> months or so. This avoids the annoying stream parser prog that
> simply returns skb->len. This is mostly an optimizations. A
> larger change I want to make at some point is to remove the
> backlog workqueue altogether. Originally it was added for
> simplicity but actually causes some latency spikes when
> looking at 99+ percentiles. It really doesn't need to be
> there it was a hold over from some original architecture that
> got pushed upstream. If you have time and want to let me know
> if you would like to tackle removing it.

This is great stuff. Thanks for explaining the sockmap's design and
decisions behind it. The opt-in blocking mode idea is spot on.

I imagine we'll get back to sockmap once we have a replacement for
TPROXY figured out (unrelated to sockmap). Let's sync then.

-Jakub
