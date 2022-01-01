Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC06A482880
	for <lists+netdev@lfdr.de>; Sat,  1 Jan 2022 21:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiAAUy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jan 2022 15:54:57 -0500
Received: from yourcmc.ru ([195.209.40.11]:48998 "EHLO yourcmc.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229961AbiAAUy5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Jan 2022 15:54:57 -0500
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Jan 2022 15:54:56 EST
Received: from yourcmc.ru (localhost [127.0.0.1])
        by yourcmc.ru (Postfix) with ESMTP id 653D7FE0665;
        Sat,  1 Jan 2022 23:49:49 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yourcmc.ru; s=mail;
        t=1641070189; bh=2Nfprnc7f+ZKYLqDeA5xY2Oop4HbdYK5OIQqMzpkSJg=;
        h=Date:From:Subject:To;
        b=ESOVMgGdW6o6RQ8nW4+69mzKNzb5QjpOK/KGMWjd6fB+kJrJbBxRUZQtwe3nkw7N5
         T8CU3JnAiV6mk3Uu3WvA3GJNKUyJW65h2bHZYVyRVUzYpJ7TWImKWDUiRWRg2Sh3D6
         tcJ2rD0jJ6JVh/cFb3YadIXERL5xrcg6MgfD9aVfkKpw0bq0NRUfMffk25AQzIKOmE
         1oTZOPgGYxKFx/cu/ddZkFHpFG1krjXcq5wTp3S2ID4pxvUjLMl5teDkmu2YH0W4SF
         AsAR9zVB2hAXrft6cGxawsgNzgumjIWjtwFxBu+eE1qNQsjE8VHhEkrqMSNkDf0EVH
         DoXt3g27qJukg==
Received: from rainloop.yourcmc.ru (yourcmc.ru [195.209.40.11])
        by yourcmc.ru (Postfix) with ESMTPSA id 515C4FE0660;
        Sat,  1 Jan 2022 23:49:49 +0300 (MSK)
MIME-Version: 1.0
Date:   Sat, 01 Jan 2022 20:49:49 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: RainLoop/1.14.0
From:   vitalif@yourcmc.ru
Message-ID: <ec7ee6bfa737e3f87774555feac13923@yourcmc.ru>
Subject: How to test TCP zero-copy receive with real NICs?
To:     edumazet@google.com, netdev@vger.kernel.org
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!=0A=0AHappy new year netdev mailing list :-)=0A=0AI have questions abo=
ut your Linux TCP zero-copy support which is described in these articles =
https://lwn.net/Articles/752046/ and presentation: https://legacy.netdevc=
onf.info/0x14/pub/slides/62/Implementing%20TCP%20RX%20zero%20copy.pdf=0A=
=0AFirst of all, how to test it with real NICs?=0A=0AThe presentation say=
s it requires "collaboration" from the NIC and it also mentions some NICs=
 you used at Google. Which are these NICs? Was the standard driver used o=
r did it require custom patches to the drivers?..=0A=0AI tried to test ze=
rocopy with Mellanox ConnectX-4 and also with Intel X520-DA2 (82599) and =
had no luck. I tried to find something like "header-data split" or "packe=
t split" in the drivers code, and as far as I understood the support for =
header-data split in ixgbe was there until 2012, but was removed in commi=
t f800326dca7bc158f4c886aa92f222de37993c80 ("ixgbe: Replace standard rece=
ive path with a page based receive"). For Mellanox (again, as I understan=
d) it's not present at all...=0A=0AThe second question is more about my a=
ttempts to test it on loopback - test tcp_mmap program (tools/testing/sel=
ftests/net/tcp_mmap.c from the kernel source) works fine on loopback, but=
 my examples with TCP_NODELAY enabled are very brittle and only manage to=
 sometimes use zero-copy successfully (i.e. get something non-zero from g=
etsockopt TCP_ZEROCOPY_RECEIVE) with tcp_rmem=3D16384 16384 16384 AND 4 k=
b packet size. And even in that case it only performs zerocopy on 30-50% =
of packets. But that's at least something... And if I try to send larger =
portions of data it breaks... And if I try to change buffers to default i=
t also breaks... And if I send 128 byte packets before 4096+ byte packets=
 it also breaks... I tried to dump traffic and everything looks good ther=
e, all packets are 40 bytes + payload(4096 or more), I set MSS manually t=
o 4096 and so on. Even tcp window sizes look good - if I shift them by ws=
cale they are always page-aligned.=0A=0Atcp_mmap, at the same time, works=
 fine and I don't see any serious difference between it and my test examp=
les except TCP_NODELAY.=0A=0ASo the second question is - how to make it s=
table with TCP_NODELAY, even on loopback?)=0A=0A-- =0AWith best regards,=
=0A  Vitaliy Filippov
