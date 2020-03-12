Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2241A182C29
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 10:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgCLJQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 05:16:46 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:42769 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbgCLJQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 05:16:46 -0400
Received: by mail-ot1-f65.google.com with SMTP id 66so5345157otd.9
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 02:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fAMw405Z2I4+Abs+opHY3r5ZOWNvTtzJUiJNOPxVtPI=;
        b=rHqoJ6QGCxOky7urAwPH4FGhioj5JIMXoSDlwY9zTBHLJ8aeYKHNXLS3tQbRIZPZZ8
         KdmtCY63VBupFWWNm3zICSVHObycPq57RQTrsoOvVqR9PCxcjtr3POPMK1oU/u4GstWJ
         z3mLNzdpYVJOI3ex4M4Vjj78XnewbiokIzf54=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fAMw405Z2I4+Abs+opHY3r5ZOWNvTtzJUiJNOPxVtPI=;
        b=dV4c9lMY9BTLYovkbsQ2/JaiSWz58qPPRnBscvQxAxWeOTd0B96U3Q9ZvTXyoL4bb9
         MbS2A3ACfcCP+h8vxlzclDG2xfR47jDuCbrGR/OlZuOrfNcTVdpX+chodZWfkdPAmCEI
         E8RD5QrNIGCn8xyxikvufknwcRR1EefCkD1vaN2KoCazYAmWBu8PiMwL+lTewTwS4k3V
         iuRoneHRKPX+x/wLXcSj5z4Zd6d+o2gxumMFyfPI651q2K0S98q/0nKHQMdKYkAuU88A
         LPPu4H9LLtYucJahItDy75tcXgKLu/ZQkiVyKGuF6ESvjlhUafBnbRtaN/rPdh4Djeg5
         TU3g==
X-Gm-Message-State: ANhLgQ1f7lEHSBYvcfSGOewo3hGRNf9mH6cRXjhBsDizY4GcojKFrngc
        K2P3pebCmyfCKbHDZap2qaCA0Ri1WXyVenWwXU6rcg==
X-Google-Smtp-Source: ADFU+vsdJMOalgUIpdt+aKol4bjP/txCqYfA3vDI7yyHw+g9tMIoPWM9O/s2/G+B+Anfuz52IPyABEZd1GZB0YAIuPg=
X-Received: by 2002:a9d:10d:: with SMTP id 13mr5781391otu.334.1584004605574;
 Thu, 12 Mar 2020 02:16:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200310174711.7490-1-lmb@cloudflare.com> <20200312015822.bhu6ptkx5jpabkr6@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200312015822.bhu6ptkx5jpabkr6@ast-mbp.dhcp.thefacebook.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Thu, 12 Mar 2020 09:16:34 +0000
Message-ID: <CACAyw9-Ui5FECjAaehP8raRjcRJVx2nQAj5=XPu=zXME2acMhg@mail.gmail.com>
Subject: Re: [PATCH 0/5] Return fds from privileged sockhash/sockmap lookup
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Mar 2020 at 01:58, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> we do store the socket FD into a sockmap, but returning new FD to that socket
> feels weird. The user space suppose to hold those sockets. If it was bpf prog
> that stored a socket then what does user space want to do with that foreign
> socket? It likely belongs to some other process. Stealing it from other process
> doesn't feel right.

For our BPF socket dispatch control plane this is true by design: all sockets
belong to another process. The privileged user space is the steward of these,
and needs to make sure traffic is steered to them. I agree that stealing them is
weird, but after all this is CAP_NET_ADMIN only. pidfd_getfd allows you to
really steal an fd from another process, so that cat is out of the bag ;)

Marek wrote a PoC control plane: https://github.com/majek/inet-tool
It is a CLI tool and not a service, so it can't hold on to any sockets.

You can argue that we should turn it into a service, but that leads to another
problem: there is no way of recovering these fds if the service crashes for
some reason. The only solution would be to restart all services, which in
our set up is the same as rebooting a machine really.

> Sounds like the use case is to take sockets one by one from one map, allocate
> another map and store them there? The whole process has plenty of races.

It doesn't have to race. Our user space can do the appropriate locking to ensure
that operations are atomic wrt. dispatching to sockets:

- lock
- read sockets from sockmap
- write sockets into new sockmap
- create new instance of BPF socket dispatch program
- attach BPF socket dispatch program
- remove old map
- unlock

> I think it's better to tackle the problem from resize perspective. imo making it
> something like sk_local_storage (which is already resizable pseudo map of
> sockets) is a better way forward.

Resizing is only one aspect. We may also need to shuffle services around,
think "defragmentation", and I think there will be other cases as we gain more
experience with the control plane. Being able to recover fds from the sockmap
will make it more resilient. Adding a special API for every one of these cases
seems cumbersome.

Lorenz

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
