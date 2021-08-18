Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E621D3F09E6
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 19:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbhHRRHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 13:07:22 -0400
Received: from forward104o.mail.yandex.net ([37.140.190.179]:35941 "EHLO
        forward104o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229784AbhHRRHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 13:07:20 -0400
X-Greylist: delayed 458 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Aug 2021 13:07:20 EDT
Received: from forward103q.mail.yandex.net (forward103q.mail.yandex.net [IPv6:2a02:6b8:c0e:50:0:640:b21c:d009])
        by forward104o.mail.yandex.net (Yandex) with ESMTP id AC27A9426AB
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 19:59:05 +0300 (MSK)
Received: from vla1-2a93b1d0b0e8.qloud-c.yandex.net (vla1-2a93b1d0b0e8.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:1e22:0:640:2a93:b1d0])
        by forward103q.mail.yandex.net (Yandex) with ESMTP id A87EE61E0002
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 19:59:05 +0300 (MSK)
Received: from vla1-62318bfe5573.qloud-c.yandex.net (vla1-62318bfe5573.qloud-c.yandex.net [2a02:6b8:c0d:3819:0:640:6231:8bfe])
        by vla1-2a93b1d0b0e8.qloud-c.yandex.net (mxback/Yandex) with ESMTP id FySNkkO1iU-x5ICPm4W;
        Wed, 18 Aug 2021 19:59:05 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1629305945;
        bh=OrkV/VcnYgYW1VakrYQXTRkz3HnWhDU7ypOtKyhWNZA=;
        h=Message-ID:Subject:To:From:Date:Reply-To;
        b=cTxTizQKUTkLoBgz+2+vGko43VkNEQJQDadRdCvyb0ScgjxyqbqPz3N295cUTB7r9
         BLxPr//nurN6sGS4KkaN8SaF42I6bsajyV0hmAtooSSSHJelGvbALopD7VAJhPvwSF
         sNXMm2q42WfxN1Ck5NPSf4pmE/pmCFwGO96QbMFk=
Authentication-Results: vla1-2a93b1d0b0e8.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by vla1-62318bfe5573.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id qTtwT76aXx-x52OCFOd;
        Wed, 18 Aug 2021 19:59:05 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Date:   Wed, 18 Aug 2021 19:59:19 +0300
From:   Oleg <lego12239@yandex.ru>
To:     netdev@vger.kernel.org
Subject: ipv6 ::1 and lo dev
Message-ID: <20210818165919.GA24787@legohost>
Reply-To: Oleg <lego12239@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  Hello.

I try to replace ::1/128 ipv6 address on lo dev with ::1/112 to
access more than 1 address(like with ipv4 127.0.0.1/8). But i get
worked only address which is set on the dev. For example:

~# ip a show dev lo
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 brd 127.255.255.255 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
~# ping -c1 -w1 127.0.0.2
PING 127.0.0.2 (127.0.0.2) 56(84) bytes of data.
64 bytes from 127.0.0.2: icmp_seq=1 ttl=64 time=0.095 ms

--- 127.0.0.2 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.095/0.095/0.095/0.000 ms

~# ping -c1 -w1 ::2
PING ::2(::2) 56 data bytes

--- ::2 ping statistics ---
1 packets transmitted, 0 received, 100% packet loss, time 0ms

Replace ::1/128 with ::1/112 and try again:

~# ip -6 a flush dev lo
~# ip -6 a add dev lo local ::1/112 scope host
~# ip a show dev lo
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 brd 127.255.255.255 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/112 scope host 
       valid_lft forever preferred_lft forever
~# ping -c1 -w1 ::2
PING ::2(::2) 56 data bytes

--- ::2 ping statistics ---
1 packets transmitted, 0 received, 100% packet loss, time 0ms

So, this don't work. How can i get the same behaviour for ipv6
loopback addresses as with ipv4?

Thanks!

-- 
Олег Неманов (Oleg Nemanov)
