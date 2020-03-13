Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF74184573
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 12:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgCMLDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 07:03:41 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:35782 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbgCMLDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 07:03:41 -0400
Received: by mail-ot1-f67.google.com with SMTP id k26so9665662otr.2
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 04:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P1J3zQtyM8ZuzD0RXk1OAoOwjOfilKeAQsgTok7/sH8=;
        b=ynMKNJNHiAPET+F0bqhByFlrpx9k59VQi4n6aOf7fPc1FUKJiQVDxr/+sSz0opaIC5
         zjglT/t3ambf/ru1n4FCu6/iQwBztatiQj6LixrivxJhnWH/VVxjE9sCWX94h9il8GiJ
         CHdOeFl0gC+714vfWdvsKu3h0O1J5mlpw/MOQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P1J3zQtyM8ZuzD0RXk1OAoOwjOfilKeAQsgTok7/sH8=;
        b=YhR3PTSxYJgG5Ctu2sIb/Ndx2/yYGMaZfmfvMw7gGMtV6NJU5QE54DAQm6sUGXMCKc
         tOOEv+JG01Qo/6kHR5ElU20rbU0buc5IbB0gRcZ+0V2lXqvfSdshGPRFJmqeN1w/Mg0R
         LWXe3kc6XI9GalTBeErUIvfdmJT6MAeBKc6h+HeG95pHDD/2w9XM3+kBYUq/sinAu2mj
         4wbmH0dzx6D20e7l/mURljGbwUVCg4T5DQEgc0C7rAPKWc3aeQgJt3D067mMR29rCLTa
         Q/BcXqFHgfqUe60vjfQe1pMEdPN+3YN/tA0wZW2e4+C44qUYu71pLEyW64HKzsKWOqQ9
         WEAw==
X-Gm-Message-State: ANhLgQ0SELQHqcsREyvD3F9+XRaCIYn0J24Sqk6lY23h7pTnS/HpVkdc
        wQyYQeVmSGdM2h9qoYv1hMJnJ/99LBnk4qIKWqbNNA==
X-Google-Smtp-Source: ADFU+vtHYLjMqgS/LYEKUe6BDFXT1dPa+LK0zjmtRo78EeJY+uNKGtMyss2ExI7N60MqW6CJx9PSsa67V+E35Z+sPI4=
X-Received: by 2002:a9d:10d:: with SMTP id 13mr10921021otu.334.1584097419903;
 Fri, 13 Mar 2020 04:03:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200310174711.7490-1-lmb@cloudflare.com> <20200312015822.bhu6ptkx5jpabkr6@ast-mbp.dhcp.thefacebook.com>
 <CACAyw9-Ui5FECjAaehP8raRjcRJVx2nQAj5=XPu=zXME2acMhg@mail.gmail.com>
 <20200312175828.xenznhgituyi25kj@ast-mbp> <5e6a8e48240a9_6a322aac933b85c029@john-XPS-13-9370.notmuch>
In-Reply-To: <5e6a8e48240a9_6a322aac933b85c029@john-XPS-13-9370.notmuch>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Fri, 13 Mar 2020 11:03:26 +0000
Message-ID: <CACAyw989zaAe2UDHcOPODbSo=WDPpQzD6kX1h5z_4xBfKP+oQg@mail.gmail.com>
Subject: Re: [PATCH 0/5] Return fds from privileged sockhash/sockmap lookup
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Mar 2020 at 19:32, John Fastabend <john.fastabend@gmail.com> wrote:
>
> The restriction that the maps can not grow/shrink is perhaps limiting a
> bit. I can see how resizing might be useful. In my original load balancer
> case a single application owned all the socks so there was no need to
> ever pull them back out of the map. We "knew" where they were. I think
> resize ops could be added without to much redesign. Or a CREATE flag could
> be used to add it as a new entry if needed. At some point I guess someone
> will request it as a feature for Cilium for example. OTOH I'm not sure
> off-hand how to use a dynamically sized table for load balancing. I
> should know the size because I want to say something about the hash
> distribution and if the size is changing do I still know this? I really
> haven't considered it much.

I agree, magically changing the size of a sockmap isn't useful. We don't
want to do load-balancing, but still need stable indices into the map:

- derive some sort of ID from the skb
- look up the ID in the sockmap
- return the socket as the result of the program

If the ID changes we need to coordinate this with the eBPF, or at least
update some other map in a race-free way.

[...]

>
> Rather than expose the fd's to user space would a map copy api be
> useful? I could imagine some useful cases where copy might be used
>
>  map_copy(map *A, map *B, map_key *key)
>
> would need to sort out what to do with key/value size changes. But
> I can imagine for upgrades this might be useful.

I guess that would be a way to approach it. I'd probably find a primitive
to copy a whole map atomically more useful, but haven't really thought
about it much.

>
> Another option I've been considering the need for a garbage collection
> thread trigger at regular intervals. This BPF program could do the
> copy from map to map in kernel space never exposing fds out of kernel

So, have a dummy prog that has both maps, and copies from old to new.
Invoke that from user space via BPF_PROG_TEST_RUN?

I guess that would work, but falls back to being "protected" by
CAP_SYS_ADMIN. It's just more cumbersome than doing it in user space!

Lorenz

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
