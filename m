Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9494B1547BC
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 16:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbgBFPTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 10:19:01 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:33929 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727309AbgBFPS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 10:18:59 -0500
Received: by mail-yw1-f65.google.com with SMTP id b186so5257839ywc.1
        for <netdev@vger.kernel.org>; Thu, 06 Feb 2020 07:18:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TSwk4IaDhOhQXtmoQApXp+74uAkqXEfJhsHvhCiqDAo=;
        b=mlit3AzwxAhFubp68BG/MUoGctFnaFsrd8YF6mmm0HS5m5UssFF/ADOmu8p5rDWnm4
         tfUCOVp24AlzZ1yV9Hdp2DbMHLKZdKazm/UwvpcIc3dIfVSB6yr9Wx8msvfpQ9rd1eDR
         ZLt8nbblKQtwS2FHNagladyiPkuUF/InCvDQsUqmyBhfO/wrT1DqQUJ0IQwVRDMYVDmM
         AbXe5SgBzHJUtRjVg461+hzyuneNZnRuB8H5QDERV13Da/6u0FrpkzkXBEhg4t34OhnC
         vDFewyNlWW4iS3zJ3WJMVHlijvJY4nDsC6lHyEM1tae3kgCcANcfW9+3RsQO8/PrJD+w
         SpMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TSwk4IaDhOhQXtmoQApXp+74uAkqXEfJhsHvhCiqDAo=;
        b=YSrbLDMnr8ISwTPh3dR1O7PRyV+F9O2r86tGEKxeGzNAUvGX2icbni1qeleZxAInKk
         RxmUTOsqLMuqf/i9T8jusR2S00oKIOwjMb4gqogjBqsyXsRV0ObORFMMC7P8qyDSnVx7
         XnwE5/puGR3F62jC0LmrvsECr0Gjs1SNeO6bv2a2OuY0aJST8ANZ3PrdVlqdtJ+wHuIr
         ssvCPEfRIVDVvYrxE9gFuZzZsB62B931cxJFuwDl+KPsFcDtAX3dnph7eXe8yDT4swFF
         E7vHm4wonSBJUfnbIttfYQJ6pSAnRpGsfNXEdekWou31EsNtnSpc87XK4UEsdtRYxKu0
         GaJg==
X-Gm-Message-State: APjAAAWcgTCcdjkPYsuB9PZxjcbRXEb0/T1xxiEIc9+v6xEPvC0ke/j6
        5k6tZ5v6WU9ODaS1U4lbtUXKpLBKGe+QmTdwOnK7Wg==
X-Google-Smtp-Source: APXvYqwzT5tu09jrV2vAO+iJqrg6jtizcRaxPaetiuXo1gTRr7hORP/j92voheml5hY30dBvEQJm2Ho5gCirRduJia8=
X-Received: by 2002:a81:7cd7:: with SMTP id x206mr3526094ywc.466.1581002338112;
 Thu, 06 Feb 2020 07:18:58 -0800 (PST)
MIME-Version: 1.0
References: <20200205165544.242623-1-edumazet@google.com> <20200206.141300.1752448469848126511.davem@davemloft.net>
In-Reply-To: <20200206.141300.1752448469848126511.davem@davemloft.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 6 Feb 2020 07:18:46 -0800
Message-ID: <CANn89iLR8jR4L3ANiSBxuLoLFuUA5+SbJ06L3cW5-99i9=_yZQ@mail.gmail.com>
Subject: Re: [PATCH net] ipv6/addrconf: fix potential NULL deref in inet6_set_link_af()
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>, maximmi@mellanox.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 6, 2020 at 5:13 AM David Miller <davem@davemloft.net> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
> Date: Wed,  5 Feb 2020 08:55:44 -0800
>
> > __in6_dev_get(dev) called from inet6_set_link_af() can return NULL.
> >
> > The needed check has been recently removed, let's add it back.
>
> I am having trouble understanding this one.
>
> When we have a do_setlink operation the flow is that we first validate
> the AFs and then invoke setlink operations after that validation.
>
> do_setlink() {
>  ..
>         err = validate_linkmsg(dev, tb);
>         if (err < 0)
>                 return err;
>  ..
>         if (tb[IFLA_AF_SPEC]) {
>  ...
>                         err = af_ops->set_link_af(dev, af);
>                         if (err < 0) {
>                                 rcu_read_unlock();
>                                 goto errout;
>                         }
>
> By definition, we only get to ->set_link_af() if there is an
> IFLA_AF_SPEC nested attribute and if we look at the validation
> performed by validate_linkmsg() it goes:
>
>         if (tb[IFLA_AF_SPEC]) {
>  ...
>                         if (af_ops->validate_link_af) {
>                                 err = af_ops->validate_link_af(dev, af);
>  ...
>
> And validate_link_af in net/ipv6/addrconf.c clearly does the
> following:
>
> static int inet6_validate_link_af(const struct net_device *dev,
>                                   const struct nlattr *nla)
>  ...
>         if (dev) {
>                 idev = __in6_dev_get(dev);
>                 if (!idev)
>                         return -EAFNOSUPPORT;
>         }
>  ...
>
> It checks the idev and makes sure it is not-NULL.
>
> I therefore cannot find a path by which we arrive at inet6_set_link_af
> with a NULL idev.  The above validation code should trap it.
>
> Please explain.
>

I can give a repro if that helps.

(I have to run, I might have more time later)

// autogenerated by syzkaller (https://github.com/google/syzkaller)

#define _GNU_SOURCE

#include <endian.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <unistd.h>

#define BITMASK(bf_off, bf_len) (((1ull << (bf_len)) - 1) << (bf_off))
#define STORE_BY_BITMASK(type, htobe, addr, val, bf_off, bf_len)               \
  *(type*)(addr) =                                                             \
      htobe((htobe(*(type*)(addr)) & ~BITMASK((bf_off), (bf_len))) |           \
            (((type)(val) << (bf_off)) & BITMASK((bf_off), (bf_len))))

uint64_t r[1] = {0xffffffffffffffff};

int main(void)
{
  syscall(__NR_mmap, 0x20000000ul, 0x1000000ul, 3ul, 0x32ul, -1, 0);
  intptr_t res = 0;
  res = syscall(__NR_socket, 0x10ul, 3ul, 0ul);
  if (res != -1)
    r[0] = res;
  *(uint64_t*)0x20000080 = 0;
  *(uint32_t*)0x20000088 = 0;
  *(uint64_t*)0x20000090 = 0x20000200;
  *(uint64_t*)0x20000200 = 0x20000000;
  *(uint32_t*)0x20000000 = 0x40;
  *(uint16_t*)0x20000004 = 0x10;
  *(uint16_t*)0x20000006 = 0x801;
  *(uint32_t*)0x20000008 = 0;
  *(uint32_t*)0x2000000c = 0;
  *(uint8_t*)0x20000010 = 0;
  *(uint8_t*)0x20000011 = 0;
  *(uint16_t*)0x20000012 = 0;
  *(uint32_t*)0x20000014 = 0;
  *(uint32_t*)0x20000018 = 0;
  *(uint32_t*)0x2000001c = 0;
  *(uint16_t*)0x20000020 = 0x10;
  STORE_BY_BITMASK(uint16_t, , 0x20000022, 0x1a, 0, 14);
  STORE_BY_BITMASK(uint16_t, , 0x20000023, 0, 6, 1);
  STORE_BY_BITMASK(uint16_t, , 0x20000023, 1, 7, 1);
  *(uint16_t*)0x20000024 = 0xc;
  STORE_BY_BITMASK(uint16_t, , 0x20000026, 0xa, 0, 14);
  STORE_BY_BITMASK(uint16_t, , 0x20000027, 0, 6, 1);
  STORE_BY_BITMASK(uint16_t, , 0x20000027, 1, 7, 1);
  *(uint16_t*)0x20000028 = 5;
  *(uint16_t*)0x2000002a = 8;
  *(uint8_t*)0x2000002c = 0;
  *(uint16_t*)0x20000030 = 8;
  *(uint16_t*)0x20000032 = 0x1b;
  *(uint32_t*)0x20000034 = 0;
  *(uint16_t*)0x20000038 = 8;
  *(uint16_t*)0x2000003a = 4;
  *(uint32_t*)0x2000003c = 0x3ff;
  *(uint64_t*)0x20000208 = 0x40;
  *(uint64_t*)0x20000098 = 1;
  *(uint64_t*)0x200000a0 = 0;
  *(uint64_t*)0x200000a8 = 0;
  *(uint32_t*)0x200000b0 = 0x54;
  syscall(__NR_sendmsg, r[0], 0x20000080ul, 0ul);
  return 0;
}
