Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0D3216E9
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 12:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbfEQK3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 06:29:37 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:34283 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728175AbfEQK3h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 May 2019 06:29:37 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 May 2019 06:29:36 EDT
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id edadfe51
        for <netdev@vger.kernel.org>;
        Fri, 17 May 2019 09:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type:content-transfer-encoding; s=mail; bh=LO/Pc2YlzUjx
        ORNu3Qful5q5PJc=; b=GKyPZxiZ6d7hynfwDAcRPecJXhhAyBohiMU5dbDXJxM/
        dWBZTzbda84DmRVcnLPhSRqJireZ7fyoshtXe8Lg+NTYVvQZS2yA+nUw6hAEYMAm
        aRLeZCwROTv6p6L2Z/6DKzJ7LO9iZFvPdTzhTSWtcGWFscCzs4/mdDhoVSlS532Q
        j1NLkFLN0fU2PZLFlfvtjLJH/AeAoS6KGIwrtlwIaDbcTHiXukAt4F6NBWajHLHi
        VeyolSGlqshngMqwOBbKSMqJm9IpOpN+LH0SQSywKmPV7dhd9TkANxB/jhDu+8CR
        iyg6GxLxUjjSTdt4TtSj8PP44ohlJcweQKfXIXdVkg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 5e4007f1 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Fri, 17 May 2019 09:54:00 +0000 (UTC)
Received: by mail-oi1-f176.google.com with SMTP id v2so4776970oie.6
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 03:22:54 -0700 (PDT)
X-Gm-Message-State: APjAAAUMM0Npj35nLJBFPkeMkk9hQfnvLLcURc6DNTXUDAiT5AalbNcc
        W15TeISQr9+XXxcFUcIiePioWsLJSFrPtat7G80=
X-Google-Smtp-Source: APXvYqzf37ZML+UahnVil98yIx5zGCJnOq9a3piL4mjmj+QQoZq5KghIxg0538aTdiHx3nGpQn1HZGcdHJ7O7kwGV3A=
X-Received: by 2002:a05:6808:219:: with SMTP id l25mr7869105oie.66.1558088572350;
 Fri, 17 May 2019 03:22:52 -0700 (PDT)
MIME-Version: 1.0
References: <LaeckvP--3-1@tutanota.com>
In-Reply-To: <LaeckvP--3-1@tutanota.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 17 May 2019 12:22:41 +0200
X-Gmail-Original-Message-ID: <CAHmME9pwgfN5J=k-2-H0cLWrHSMO2+LHk=Lnfe7qcsewue2Kxw@mail.gmail.com>
Message-ID: <CAHmME9pwgfN5J=k-2-H0cLWrHSMO2+LHk=Lnfe7qcsewue2Kxw@mail.gmail.com>
Subject: 5.1 `ip route get addr/cidr` regression
To:     emersonbernier@tutanota.com, Netdev <netdev@vger.kernel.org>,
        dsahern@gmail.com, Stephen Hemminger <stephen@networkplumber.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        David Miller <davem@davemloft.net>
Cc:     piraty1@inbox.ru
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm back now and catching up with a lot of things. A few people have
mentioned to me that wg-quick(8), a bash script that makes a bunch of
iproute2 invocations, appears to be broken on 5.1. I've distilled the
behavior change down to the following.

Behavior on 5.0:

+ ip link add wg0 type dummy
+ ip address add 192.168.50.2/24 dev wg0
+ ip link set mtu 1420 up dev wg0
+ ip route get 192.168.50.0/24
broadcast 192.168.50.0 dev wg0 src 192.168.50.2 uid 0
   cache <local,brd>

Behavior on 5.1:

+ ip link add wg0 type dummy
+ ip address add 192.168.50.2/24 dev wg0
+ ip link set mtu 1420 up dev wg0
+ ip route get 192.168.50.0/24
RTNETLINK answers: Invalid argument

Upon investigating, I'm not sure that `ip route get` was ever suitable
for getting details on a particular route. So I'll adjust the
wg-quick(8) code accordingly. But FYI, this is unexpected userspace
breakage.

Jason

On Sat, Mar 23, 2019 at 2:00 PM <emersonbernier@tutanota.com> wrote:
>
> After upgrading iproute2 from 4.20 to 5.0 the following error occurs:
>
> $ ip route show table default
> Error: ipv4: FIB table does not exist.
> Dump terminated
>
> The command works for all tables other than 'default' one. It seems relat=
ed to this commit[1]
>
> I also saw "Error: ipv4: MR table does not exist." message in logs relate=
d to this commit[2] but don't know exact command to reproduce it. I've seen=
 some fixups[3] for mentioned commits and wonder it they weren't complete.
>
> I reproduced it on Linux 4.20.17 and 5.0.3.
>
> [1] https://github.com/torvalds/linux/commit/18a8021a7be3207686851208f91a=
2f105b2d4703#diff-04a14e4f51765994f87e7e5e7681d0e1R861 <https://github.com/=
torvalds/linux/commit/18a8021a7be3207686851208f91a2f105b2d4703#diff-04a14e4=
f51765994f87e7e5e7681d0e1R861>
>
> [2] https://github.com/torvalds/linux/commit/cb167893f41e21e6bd283d78e534=
89289dc0592d#diff-9900db808ce5e5dd24a7341cd8ed1609R2545 <https://github.com=
/torvalds/linux/commit/cb167893f41e21e6bd283d78e53489289dc0592d#diff-9900db=
808ce5e5dd24a7341cd8ed1609R2545>
>
> [3] https://github.com/torvalds/linux/commit/73155879b3c1ac3ace35208a54a3=
a160ec520bef
