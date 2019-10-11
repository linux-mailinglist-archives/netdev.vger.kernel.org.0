Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 960E5D42FF
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 16:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbfJKOhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 10:37:04 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45817 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbfJKOhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 10:37:04 -0400
Received: by mail-qk1-f196.google.com with SMTP id z67so9029100qkb.12
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 07:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mbuki-mvuki-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DNwGknwORHGYaJLOlLqPir1koTV0itcdseUspcKaOEg=;
        b=ufdY09bts6KjXoDUkqFCrM5R8QXdYEuWIcHyHSxdmgAOh3L891ZfS20dUF2oS5AkFP
         rDvVlPBD9ucn1PYXY5W0Qm9zv7Wy8wSgNhprbajcUc2yIYTQPSEQYbqyVB4he2Wr+MYb
         gJhell5All+HJ4zAuhTnKWImgklKdi0CpImwx7kP3fvt8yvnRxuKPe1Gqov/tziNfARU
         v7zeYLeHIb9WGhsBjU10cnS8lA4NnjxKU7YZbtLq0gh8aXqyZ3cPVER2xn3JZO9+aCPY
         BT8umVygvTAKJRjpOgw+cQDenTtnG2/rFP7M9TQTeNOMERlrF/E0/pUHlD4/dEWeUtkd
         d/6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DNwGknwORHGYaJLOlLqPir1koTV0itcdseUspcKaOEg=;
        b=ssUXxlUWl9hOkz4lXmdAYyg1bLRdlYAh98LSqb8wXP7mqzwobhTe1a1Q/BL72IW6Y+
         YZ5xQZYWxmWJzbyIk8uj5u6Igvmslgcshoy3u7bv/f6sWnq6GMEC7Gp+H0UDCrJYtbHH
         vQQejSlRNcxbvUsC7njd+QCjnPZPsXxl0xM/D2QcahaKwTAnNQrkmBMrPxUPn2Racq9y
         b00zU+ssh3FVaXb9cgsB8sQ/qx1RSMHbqfCcZNHoJq4ZOaZ8Msypr2gZ6vLSdT/RAuVa
         y0JhVXT2ZDWBOEYlGvSQe/R7ilE+5yg98zjxL70PFQFekLGqVEwSL2UjUXeZB1x4z5fF
         Qk9A==
X-Gm-Message-State: APjAAAVLUImbb3yvw4dmK5py8KFJZ+r+RqHAjNeu3YRpiedUzZqCI++K
        gANuT4OKi2jquu3QT2L06Z6kfvFCIxeeLpxmm9/1K4IT1Yw=
X-Google-Smtp-Source: APXvYqzesCqs3NqsnG86khVrhUOz5Q4tsLzfn/STJfqIKbVrAQFQBpIwh8aT+bMlINVKpOhgBgoDFwtLz9tbJdqJDrw=
X-Received: by 2002:ae9:ee06:: with SMTP id i6mr15412092qkg.362.1570804623010;
 Fri, 11 Oct 2019 07:37:03 -0700 (PDT)
MIME-Version: 1.0
References: <CANSNSoV1M9stB7CnUcEhsz3FHi4NV_yrBtpYsZ205+rqnvMbvA@mail.gmail.com>
 <20191010083102.GA1336@splinter>
In-Reply-To: <20191010083102.GA1336@splinter>
From:   Jesse Hathaway <jesse@mbuki-mvuki.org>
Date:   Fri, 11 Oct 2019 09:36:51 -0500
Message-ID: <CANSNSoVM1Uo106xfJtGpTyXNed8kOL4JiXqf3A1eZHBa7z3=yg@mail.gmail.com>
Subject: Re: Race condition in route lookup
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 3:31 AM Ido Schimmel <idosch@idosch.org> wrote:
> I think it's working as expected. Here is my theory:
>
> If CPU0 is executing both the route get request and forwarding packets
> through the directly connected interface, then the following can happen:
>
> <CPU0, t0> - In process context, per-CPU dst entry cached in the nexthop
> is found. Not yet dumped to user space
>
> <Any CPU, t1> - Routes are added / removed, therefore invalidating the
> cache by bumping 'net->ipv4.rt_genid'
>
> <CPU0, t2> - In softirq, packet is forwarded through the nexthop. The
> cached dst entry is found to be invalid. Therefore, it is replaced by a
> newer dst entry. dst_dev_put() is called on old entry which assigns the
> blackhole netdev to 'dst->dev'. This netdev has an ifindex of 0 because
> it is not registered.
>
> <CPU0, t3> - After softirq finished executing, your route get request
> from t0 is resumed and the old dst entry is dumped to user space with
> ifindex of 0.
>
> I tested this on my system using your script to generate the route get
> requests. I pinned it to the same CPU forwarding packets through the
> nexthop. To constantly invalidate the cache I created another script
> that simply adds and removes IP addresses from an interface.
>
> If I stop the packet forwarding or the script that invalidates the
> cache, then I don't see any '*' answers to my route get requests.

Thanks for the reply and analysis Ido, I tested with an additional script which
adds and deletes a route in a loop, as you also saw this increased the
frequency of blackhole route replies from the first script.

Questions:

1. We saw this behavior occurring with TCP connections traversing our routers,
though I was able to reproduce it with only local route requests on our router.
Would you expect this same behavior for TCP traffic only in the kernel which
does not go to userspace?

2. These blackhole routes occur even though our main routing table is not
changing, however a separate route table managed by bird on the Linux router is
changing. Is this still expected behavior given that the ip-rules and main
route table used by these route requests are not changing?

3. We were previously rejecting these packets with an iptables rule which sent
an ICMP prohibited message to the sender, this caused TCP connections to break
with a EHOSTUNREACH, should we be silently dropping these packets instead?

4. If we should just be dropping these packets, why does the kernel not drop
them instead of letting them traverse the iptables rules?

> BTW, the blackhole netdev was added in 5.3. I assume (didn't test) that
> with older kernel versions you'll see 'lo' instead of '*'.

Yes indeed! Thanks for solving that mystery as well, our routers are running
5.1, but we upgraded to 5.4-rc2 to determine whether the issue was still
present in the latest kernel.
