Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7316011F406
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 21:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfLNUk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 15:40:29 -0500
Received: from mail-ed1-f45.google.com ([209.85.208.45]:46936 "EHLO
        mail-ed1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbfLNUk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 15:40:29 -0500
Received: by mail-ed1-f45.google.com with SMTP id m8so1894426edi.13
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 12:40:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YC53N0b5p75wzufT2htE03AK96NU7OSrHK+pxH9cUUY=;
        b=O3sumWz7S69K157WwzM7sT5W67T+pneBoGN228Nz4mkYx+jWvQPQLPuODBLc4yjo40
         BRFo/pGpfnBviahJsX0AwXzZjdWnXovRChMmHLpNuh/eAG+w3IGZlFinGBFk3CHYYGTw
         fSSVizE0XT5oE2od0wJuGtNBZYuJ6Ck2/hFAxI6grwSSbUbo81QEUlH0C1KO7Q5/++U0
         1zdHhD4qPV98bCf2YUTYSwhhxW1WIWeZb0+zgRLklXgNdsYGV6839ZyaGXVTBsWumn+v
         +vb3L+749WmPMJ7uKX1G3n91VPaJC0U4Ds/tdckbHCgMpKZUrhuCBVgCnMX15bS0nbGv
         RpbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YC53N0b5p75wzufT2htE03AK96NU7OSrHK+pxH9cUUY=;
        b=EIPleIgRu+Nc4qB2+NzRtFS6nyNagleG14zf82rcq7Z2GPS4ZLk/KLPC90bEcbucxj
         Ih7wNHj7othKcDPZtGgKUm3SamDBkWRhIMCa0LFuo43r8QYH+mX99rcnPnGMgvyvmGhz
         5RCJoBRZu67Ymnj6ngGRsYpKvuy6MSwO2jElbTngbjBMdXsrXN7rnu4Hd8cH5f5ZcjMh
         ksjtt4bhFvglbvmXlW6pXRf4jNMzk3BsmqwlwSbF9tWhT6IeEwJcqkvUd84wnt8NJnF/
         AzZES3/5novh8B2b2NX3d81zqZkBYSdNEIcITOE5/6pd2hrz/P1sO7PItP3lpWi4Kt9D
         91aQ==
X-Gm-Message-State: APjAAAWmfBTn76ezMoJtOUgp8wFuLXdlDmSq7i7KuIWOeFIhKfMYZvOL
        IhrihcPMVyLg6CNUs6r0h1Tx3CN568EzuUhDe0sn5sir
X-Google-Smtp-Source: APXvYqz7vkTLWEpm/YW0vKfviEO+uacrn/n+eTjXEwioTN1oguJ0rr4ZAoIdQPJGHskLq6AeVv4TBN/Gce5y9LHNMf8=
X-Received: by 2002:a17:906:1e8b:: with SMTP id e11mr24472820ejj.305.1576356027522;
 Sat, 14 Dec 2019 12:40:27 -0800 (PST)
MIME-Version: 1.0
References: <5975583.vpC7qLWE0j@cg-notebook>
In-Reply-To: <5975583.vpC7qLWE0j@cg-notebook>
From:   Tom Herbert <tom@herbertland.com>
Date:   Sat, 14 Dec 2019 12:40:16 -0800
Message-ID: <CALx6S36PsbRW+Z0Eeh2Dtkb-hzXGekD-PLyML08g4xo5Vddvug@mail.gmail.com>
Subject: Re: IPv6 Destination Options question
To:     Christoph Grenz <christophg+lkml@grenz-bonn.de>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 14, 2019 at 8:19 AM Christoph Grenz
<christophg+lkml@grenz-bonn.de> wrote:
>
> Hello,
>
> I'm playing around with Mobile IPv6 and noticed a strange behaviour in the
> Linux network system when using IPv6 destination options:
>
> I'm able to send destination options on SOCK_DGRAM and SOCK_RAW sockets with
> sendmsg() and IPV6_DSTOPTS ancillary data. The sent packets also look correct
> in Wireshark.
>
> But I'm not able to receive packets with destination options on a socket with
> the IPV6_RECVDSTOPTS socket option enabled. Both a packet with a Home Address
> Option and a packet with an empty destination options header (only containing
> padding) won't be received on a socket for the payload protocol.

Christoph, Can you post your receive code?

Thanks

>
> Only a SOCK_RAW socket for IPPROTO_DSTOPTS receives the packet.
>
> I tested this on a vanilla 5.4.0 kernel and got the same behaviour. Activating
> dyndbg for everything in net/ipv6 didn't produce any relevant output in dmesg.
>
> Is this expected behaviour or a bug? Or do I maybe need some other socket
> option or a xfrm policy to receive packets with destination options?
>
> Best regards
> Christoph
>
