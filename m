Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA573F1605
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 11:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237325AbhHSJSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 05:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237216AbhHSJRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 05:17:39 -0400
Received: from forward100j.mail.yandex.net (forward100j.mail.yandex.net [IPv6:2a02:6b8:0:801:2::100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1984C061575
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 02:17:00 -0700 (PDT)
Received: from myt5-89d0765c5c65.qloud-c.yandex.net (myt5-89d0765c5c65.qloud-c.yandex.net [IPv6:2a02:6b8:c12:3e1f:0:640:89d0:765c])
        by forward100j.mail.yandex.net (Yandex) with ESMTP id 4E0A764F27C3;
        Thu, 19 Aug 2021 12:16:53 +0300 (MSK)
Received: from myt5-ca5ec8faf378.qloud-c.yandex.net (myt5-ca5ec8faf378.qloud-c.yandex.net [2a02:6b8:c12:2514:0:640:ca5e:c8fa])
        by myt5-89d0765c5c65.qloud-c.yandex.net (mxback/Yandex) with ESMTP id GsaM8CAsl0-GrH4BahK;
        Thu, 19 Aug 2021 12:16:53 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1629364613;
        bh=ZIsZMznqwCvXQEq2mpEZROyvikPAJ2XM6Q/UOyAX/Rs=;
        h=In-Reply-To:Reply-To:Message-ID:Subject:To:From:References:Date:
         Cc;
        b=YDiDU2rR3sRNgWZC/6cl/idtE4HSXiIycMgHp/WlPN7UYrtl59c+SozjYkHGpXzT5
         lzYbfTzxnZ2Hxpp229lvRi8TQwjC3FQbGuod3iKAeBXRwtvo+W2sbq4ieIWExq1tf4
         EFKT4N/iuTvjGY8A+ZvawCCvFLoMtPUY+6YaPZlY=
Authentication-Results: myt5-89d0765c5c65.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by myt5-ca5ec8faf378.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id BPHASKTnwu-GqiSXReW;
        Thu, 19 Aug 2021 12:16:52 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Date:   Thu, 19 Aug 2021 12:16:52 +0300
From:   Oleg <lego12239@yandex.ru>
To:     Thorsten Glaser <t.glaser@tarent.de>
Cc:     netdev@vger.kernel.org
Subject: Re: ipv6 ::1 and lo dev
Message-ID: <20210819091652.GA22188@legohost>
Reply-To: Oleg <lego12239@yandex.ru>
References: <20210818165919.GA24787@legohost>
 <fb3e3ad3-7bc3-9420-d3f6-e9bae91f4cd@tarent.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fb3e3ad3-7bc3-9420-d3f6-e9bae91f4cd@tarent.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 07:47:37PM +0200, Thorsten Glaser wrote:
> On Wed, 18 Aug 2021, Oleg wrote:
> 
> > I try to replace ::1/128 ipv6 address on lo dev with ::1/112 to
> > access more than 1 address(like with ipv4 127.0.0.1/8). But i get
> 
> AIUI this is not possible in IPv6, only :: and ::1 are reserved,
> the rest of ::/96 is IPv4-compatible IPv6 addresses.

This is a big mistake of standards and, i think, we shouldn't conform to
standards in this area. Because standards conflicts with real life practice
(and needs) here.

I think, we can safely use ::/104 as analog of 127.0.0.1/8, because, AFAIK,
0.0.0.0/8 isn't used now in practice and thus there are no problems with
ipv4-mapped ipv6 addresses.

In any case, we should allow users to get an expected behaviour for lo dev
address - as with 127.0.0.1/8. I.e. when i remove ::1/128 and set ::1/104
i expect that ping ::2, ::3 and etc will work(may be only if some parameter for
"ip a add" is specified).

Unfortunately i can't suggest any patch, because my kernel programming level
is about 0 :-). May be anybody can do it?

> I never understood why you’d want more than one address for loopback
> anyway (in my experience, the more addresses a host has, the more
> confused it’ll get about which ones to use for what).

Besides already mentioned cases i say you about my 2 cases:

1. We have a service which serve many tunnels to different machines
  (think of it as many ssh -R X:127.0.0.N:Y to our service servers). Each
  machine is mapped to address:port(thus it constant between sessions).
  And we use many addresses from 127.0.0.1/8 :-).
2. We have many qemu VMs on several hardware hosts. We assign an address
  to every VM from 127.0.0.1/8 for comfort use of telnet/vnc. E.g. we
  have in /etc/hosts something like this(where third column is for
  host machine index and fourth column is for VM index):

  ...
  127.0.1.2       www1.vm
  127.0.1.3       www2.vm
  127.0.1.4       www3.vm
  127.0.1.5       dns1.vm
  127.0.1.5       dns2.vm
  127.0.1.6       mail1.vm
  ...

  and run qemu with:

  -serial telnet:dns1.vm:23,server,nowait -vnc dns1.vm:0

  This /etc/hosts syncronized between hardware hosts and if one if it fail
  we can migrate all VMs from it to another one and their addresses aren't
  intermixed.

-- 
Олег Неманов (Oleg Nemanov)
