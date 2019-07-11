Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5D66527D
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 09:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728155AbfGKH2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 03:28:39 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43158 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727973AbfGKH2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 03:28:39 -0400
Received: by mail-wr1-f67.google.com with SMTP id p13so5035379wru.10
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 00:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=VoJJZNl/tbt7W9g/vNLmqj0PskRRbgIQirJss1uLpiM=;
        b=gKuSg9fIy9gsaA1a4MupWiQYuuwJcG4AtPmr8qQ5vyk8Qq1kuJTFcdn4a+DhGdnH3r
         kTGGyy8Ql+biWvuReuf79g0tqng5Zs3BJb0l1Svtr7x3M3WAcrk3axtrRcQ8c6Bq27UB
         meR1faX71iPdueoti1kAykR+/ogqVCrAfrhajavaZVxd1jwOL/55XN7vrIeM54sDu4V5
         p3nD1mLF9TiXHe9S6YqPI0IHqONxTNGpFtNeXkbKxovxZgNgdkHx/shLFrIVkDHgHydD
         681inGISpmqsrstTBOYSZdTq2JJoyOlPRCzvlLqjCV/5xUa8RY07zMkccF7XBDmyt0Dz
         s28Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=VoJJZNl/tbt7W9g/vNLmqj0PskRRbgIQirJss1uLpiM=;
        b=nB7resKLgitux9bXfN5xTFU8ZiZTng3U6BNcyehyt4KVw1bGWL08wJ1P8FUCT0STnL
         6gNWTtJpLrrQMBZaKHhQdbI6wjEvi6XIRLT2SUqi8gBElfRFTGjnV+a4a+fUoR6nRKY1
         HhQumwCe416O9Pjj13FQDyiZz0WFxawHE1IazYssa4gyXlM6AN1DdqKN3pLfHBheNyMP
         b6j5fco5WSBgojJZ1djedvlS5+LBhd1fkjnGUGKUTbBQn25vTL4h50cwcJa1gRFqZ6aZ
         MaLoAB6Tc0HyBu7VCWGzGrk76AUslUgMGHHn1F7DratgP+Xjsqbg0jrjPIqwWnsUE7Z5
         wQYA==
X-Gm-Message-State: APjAAAWyD39ky0/iNzyoY/C2Q3VvTpo9EtnrMtfSE23sfOta/bLcqtBm
        5HyaYlPNtTKfQXkzP+K6gmM=
X-Google-Smtp-Source: APXvYqyxOPwrwxGNpj4Q+6drT+YxT8qQ3Zx2EnRYTWLzRVio4h86FLWxftCaHvurMEPWwMjVaOt/7g==
X-Received: by 2002:a5d:6583:: with SMTP id q3mr3201488wru.184.1562830117402;
        Thu, 11 Jul 2019 00:28:37 -0700 (PDT)
Received: from ?IPv6:2a01:cb18:8368:6800:3855:b39f:bc19:764f? ([2a01:cb18:8368:6800:3855:b39f:bc19:764f])
        by smtp.gmail.com with ESMTPSA id o7sm4312453wmf.43.2019.07.11.00.28.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 00:28:36 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH net 2/4] tcp: tcp_fragment() should apply sane memory
 limits
From:   Christoph Paasch <christoph.paasch@gmail.com>
In-Reply-To: <b1dfd327-a784-6609-3c83-dab42c3c7eda@gmail.com>
Date:   Thu, 11 Jul 2019 09:28:31 +0200
Cc:     "Prout, Andrew - LLSC - MITLL" <aprout@ll.mit.edu>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Looney <jtl@netflix.com>,
        Neal Cardwell <ncardwell@google.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        Yuchung Cheng <ycheng@google.com>,
        Bruce Curtis <brucec@netflix.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dustin Marquess <dmarquess@apple.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <B600B3AB-559E-44C1-869C-7309DB28850E@gmail.com>
References: <20190617170354.37770-1-edumazet@google.com>
 <20190617170354.37770-3-edumazet@google.com>
 <CALMXkpYVRxgeqarp4gnmX7GqYh1sWOAt6UaRFqYBOaaNFfZ5sw@mail.gmail.com>
 <03cbcfdf-58a4-dbca-45b1-8b17f229fa1d@gmail.com>
 <CALMXkpZ4isoXpFp_5=nVUcWrt5TofYVhpdAjv7LkCH7RFW1tYw@mail.gmail.com>
 <63cd99ed3d0c440185ebec3ad12327fc@ll.mit.edu>
 <96791fd5-8d36-2e00-3fef-60b23bea05e5@gmail.com>
 <e471350b70e244daa10043f06fbb3ebe@ll.mit.edu>
 <b1dfd327-a784-6609-3c83-dab42c3c7eda@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 10, 2019, at 9:26 PM, Eric Dumazet <eric.dumazet@gmail.com> =
wrote:
>=20
>=20
>=20
> On 7/10/19 8:53 PM, Prout, Andrew - LLSC - MITLL wrote:
>>=20
>> Our initial rollout was v4.14.130, but I reproduced it with v4.14.132 =
as well, reliably for the samba test and once (not reliably) with =
synthetic test I was trying. A patched v4.14.132 with this patch =
partially reverted (just the four lines from tcp_fragment deleted) =
passed the samba test.
>>=20
>> The synthetic test was a pair of simple send/recv test programs under =
the following conditions:
>> -The send socket was non-blocking
>> -SO_SNDBUF set to 128KiB
>> -The receiver NIC was being flooded with traffic from multiple hosts =
(to induce packet loss/retransmits)
>> -Load was on both systems: a while(1) program spinning on each CPU =
core
>> -The receiver was on an older unaffected kernel
>>=20
>=20
> SO_SNDBUF to 128KB does not permit to recover from heavy losses,
> since skbs needs to be allocated for retransmits.

Would it make sense to always allow the alloc in tcp_fragment when =
coming from __tcp_retransmit_skb() through the retransmit-timer ?

AFAICS, the crasher was when an attacker sends "fake" SACK-blocks. Thus, =
we would still be protected from too much fragmentation, but at least =
would always allow the retransmission to go out.


Christoph

>=20
> The bug we fixed allowed remote attackers to crash all linux hosts,
>=20
> I am afraid we have to enforce the real SO_SNDBUF limit, finally.
>=20
> Even a cushion of 128KB per socket is dangerous, for servers with =
millions of TCP sockets.
>=20
> You will either have to set SO_SNDBUF to higher values, or let =
autotuning in place.
> Or revert the patches and allow attackers hit you badly.
>=20

