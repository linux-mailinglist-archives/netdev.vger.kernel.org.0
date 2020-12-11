Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0A12D7AD7
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 17:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394984AbgLKQXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 11:23:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395002AbgLKQXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 11:23:18 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F2CC0613D3
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 08:22:38 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id g1so9297974ilk.7
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 08:22:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fK9M2Wp5EPy/rZWDTuKilqNsl5tbRjp0r29Nw6g7JRw=;
        b=CN9emkY8Ndd7hrLtL7NEKu7+1jJhkdb8A0Uw2XbmScJ1J7nHzla641qKJ69HY3qfDE
         /0KnVMaEocK7P7qt+MP3PRhPvO4jK9IFwxRw0a/fZNhTLMhJKbwdKswOBC3uvvzwHNLi
         eNpFlrlYKqB38mehEEwf4RJnNFU51SbDpmXdZNE7D2B0hKLyNju/m/Sz0DBf2MW0vwu9
         obQx8KjCz9vbSQXGM6Yj6hSDppsaybWEd4f+g+tKrMU/33SW20pTRkmLUF+mhAF9I46+
         qFDn3jvTOtrBGJbP0d0tcHLLjzbvWJUb/QtuexMvMZ1ywYYu1i6GHxNcY5AoLViqKcuY
         bM4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fK9M2Wp5EPy/rZWDTuKilqNsl5tbRjp0r29Nw6g7JRw=;
        b=OQFDOV+nuSSXsdLyKvZS1rRieP3/JwL47Bcc0C7cCMj8iz8trBtM2lM7pRyZJ9nv3C
         bkbHVRyIEgqf1OSwwiq0wSCJ6GADWrbuqCP3sHgvPEjofsaB/jlAxteVrsRffsmUeliR
         RywV6+CbqpfZFqt+gx3FIH9ju2P2sbpF8TZ+KHvccabTFesh5fXMxAwfgZDqFurFS1TF
         NKSNsmtIh4GZ8OPTD3EmKP9NA2Fc3WtR+iAB8j71ywUXNTphxlK4jUI/V5t8AZYHY44D
         pzNBZ+lej+/fq3Q57PTMVX22PZMVKd2eRbqiUsiV0LdmGlLi0M9hSdWL4FZOAHwtmHoT
         SZJg==
X-Gm-Message-State: AOAM532ffquBCFOlIxgjQ3qUKS6bpVUqE8hsqYM4ZAec+417a3oqPG8f
        7PS2WkFK1y3uvE4OWbzy0sf8Og6VzinmbEPvJeAawQ==
X-Google-Smtp-Source: ABdhPJzM9oj13tHhiBRFaypX40f0NKLwAVrZAdjcvp5pGvd5dcdxGtiCDEbzo5nOhkwf3+C6kC6tJrmZYjdZGEvGVdU=
X-Received: by 2002:a92:da82:: with SMTP id u2mr16565037iln.137.1607703757692;
 Fri, 11 Dec 2020 08:22:37 -0800 (PST)
MIME-Version: 1.0
References: <160765171921.6905.7897898635812579754.stgit@localhost.localdomain>
 <CANn89iJ5HnJYv6eWb1jm6rK173DFkp2GRnfvi9vnYwXZPzE4LQ@mail.gmail.com> <CAKgT0Uf_q=FgMHd9_wq5Bx8rCC-kS0Qz563rE9dL2hpQ6Evppg@mail.gmail.com>
In-Reply-To: <CAKgT0Uf_q=FgMHd9_wq5Bx8rCC-kS0Qz563rE9dL2hpQ6Evppg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 11 Dec 2020 17:22:26 +0100
Message-ID: <CANn89iJUT6aWm75ZpU_Ggmuqbb+cbLSGj0Bxysu9_wXRgNS8MQ@mail.gmail.com>
Subject: Re: [net PATCH] tcp: Mark fastopen SYN packet as lost when receiving ICMP_TOOBIG/ICMP_FRAG_NEEDED
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Yuchung Cheng <ycheng@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        kernel-team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 5:03 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:

> That's fine. I can target this for net-next. I had just selected net
> since I had considered it a fix, but I suppose it could be considered
> a behavioral change.

We are very late in the 5.10 cycle, and we never handled ICMP in this
state, so net-next is definitely better.

Note that RFC 7413 states in 4.1.3 :

 The client MUST cache cookies from servers for later Fast Open
   connections.  For a multihomed client, the cookies are dependent on
   the client and server IP addresses.  Hence, the client should cache
   at most one (most recently received) cookie per client and server IP
   address pair.

   When caching cookies, we recommend that the client also cache the
   Maximum Segment Size (MSS) advertised by the server.  The client can
   cache the MSS advertised by the server in order to determine the
   maximum amount of data that the client can fit in the SYN packet in
   subsequent TFO connections.  Caching the server MSS is useful
   because, with Fast Open, a client sends data in the SYN packet before
   the server announces its MSS in the SYN-ACK packet.  If the client
   sends more data in the SYN packet than the server will accept, this
   will likely require the client to retransmit some or all of the data.
   Hence, caching the server MSS can enhance performance.

   Without a cached server MSS, the amount of data in the SYN packet is
   limited to the default MSS of 536 bytes for IPv4 [RFC1122] and 1220
   bytes for IPv6 [RFC2460].  Even if the client complies with this
   limit when sending the SYN, it is known that an IPv4 receiver
   advertising an MSS less than 536 bytes can receive a segment larger
   than it is expecting.

   If the cached MSS is larger than the typical size (1460 bytes for
   IPv4 or 1440 bytes for IPv6), then the excess data in the SYN packet
   may cause problems that offset the performance benefit of Fast Open.
   For example, the unusually large SYN may trigger IP fragmentation and
   may confuse firewalls or middleboxes, causing SYN retransmission and
   other side effects.  Therefore, the client MAY limit the cached MSS
   to 1460 bytes for IPv4 or 1440 for IPv6.


Relying on ICMP is fragile, since they can be filtered in some way.
