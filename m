Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D784B1667BF
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 20:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728966AbgBTT6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 14:58:15 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:37491 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728556AbgBTT6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 14:58:15 -0500
Received: by mail-yw1-f68.google.com with SMTP id l5so2445333ywd.4
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 11:58:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YhcFtXeUNiTHeNdlpcQNyHl33qj7IG6RR8ro5SC0LO0=;
        b=NFxKn7PKQuMqzvM1xjyRD3/EGZ1n0JVL1VyMkouw/nG4tJffmccX3AhFKJiiZ7HoUU
         ZhqyUTTgBkfA5IDp85FdzpukCog2NPsoenEvPR6PbDgbKxqJvfklu4qfpjDYp85bLv6I
         rniZlwELMj+hMLoI4vsoBGkMp2Lcay2GJskXcYR39G0OiXXQrdR5aowYuoy+5J/UgyvJ
         SIR3y//h1tC51lh/Be66gU7jeUid5d1E24ymo2MuRAr7IFaH4aKXoRZJg1DWP0yEjnQU
         wbEdt7QWEIMKrKQADXb6m5avhIs9JXaqMfHXvIE4GdZH/baZOYmXWEzGdiO50c/7AE9d
         N2UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YhcFtXeUNiTHeNdlpcQNyHl33qj7IG6RR8ro5SC0LO0=;
        b=bV5NCgvxXv5OtqgZSdoHJm10buwwmvHs2XHiCYeGh9dc+E4ZhFQevJHvgPHmtNTshT
         KhT7PDKMlm0PZizkuLL2clZdqiKukQ8IlFfUDlIIqjf9NjZN9thUk9cEdhNOyVYAxBOh
         /CO7LJUQP33oUtBCnEaCfyNOsUnVaIlZsK1NPw42ROtgV0u+JOxZo96dd16VinVri2EJ
         nEmlqkxRzDX0rV+9CLaPtnH6YNRfv559W7ElxLeUBPyD+5y5oOBdNpdB9q4rv9SYywBG
         s3PmsgSywrACoKP6odiHJfO8zE9fZm9MP+vVobJbEbGpDGttr/DcOkIM8dI5NqM1ZmB3
         SQhg==
X-Gm-Message-State: APjAAAXiVd7S64XMkPlHnfe9MeagLkGeMY4w8v81p8+G2MUqCShHF05A
        vW+zB/3UQSxbPnSVu/88W0J7kVY0GSMYKyauM87Phg==
X-Google-Smtp-Source: APXvYqywnzWyxn5PZXDHgjfmbSukWQmn7TaqpTAHCgvUNuMuNbR0kM1OcAD+er72WRtA6U4b8/N+smK8PNU1t24ukWg=
X-Received: by 2002:a81:b38a:: with SMTP id r132mr28133313ywh.114.1582228693256;
 Thu, 20 Feb 2020 11:58:13 -0800 (PST)
MIME-Version: 1.0
References: <20200220152020.13056-1-kuniyu@amazon.co.jp>
In-Reply-To: <20200220152020.13056-1-kuniyu@amazon.co.jp>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 20 Feb 2020 11:58:00 -0800
Message-ID: <CANn89iK2LHmjHsQw4yYFy-WoKT6YnpRPOKJkEXzJuTEaG+ayNw@mail.gmail.com>
Subject: Re: [PATCH net-next 0/3] Improve bind(addr, 0) behaviour.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        kuni1840@gmail.com, netdev <netdev@vger.kernel.org>,
        osa-contribution-log@amazon.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 7:20 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>
> Currently we fail to bind sockets to ephemeral ports when all of the ports
> are exhausted even if all sockets have SO_REUSEADDR enabled. In this case,
> we still have a chance to connect to the different remote hosts.
>
> The second and third patches fix the behaviour to fully utilize all space
> of the local (addr, port) tuples.
>
> Kuniyuki Iwashima (3):
>   tcp: Remove unnecessary conditions in inet_csk_bind_conflict().
>   tcp: bind(addr, 0) remove the SO_REUSEADDR restriction when ephemeral
>     ports are exhausted.
>   tcp: Prevent port hijacking when ports are exhausted
>
>  net/ipv4/inet_connection_sock.c | 36 ++++++++++++++++++++++-----------
>  1 file changed, 24 insertions(+), 12 deletions(-)

I am travelling at the moment, so I can not really look at these
patches with enough time.

I would appreciate it if you provide tests to demonstrate your patches are safe.

Thanks.
