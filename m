Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E588935002F
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 14:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235477AbhCaM0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 08:26:37 -0400
Received: from mail-40131.protonmail.ch ([185.70.40.131]:35988 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235427AbhCaM01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 08:26:27 -0400
Date:   Wed, 31 Mar 2021 12:26:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1617193578; bh=IJiIJLP9J3EbXGDv7FrrNHW4zk0L7+DgfXGI5q66nWw=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=ltGS1PR9i6yTJZSOPnOwObymChUFQ7ZmS3sE1OIB0ZrMOKq+vd6Qcn1do+C/ln7XK
         VQDnu0bEqCI09K7hbmIQ450xokR5AYaun2ha7kCX4NCMz3GKc6+VsQzUM/hrgnTUwT
         FugM39lzgFdOVrFCoK/vPT6ZbDanEesBwOC0la8YqnWulyTRO9o1WTCeTPvpeU/nRj
         hSRvA8eIfGr+r82OsEfiR/HDEjTfZNO2930uf7yFYA3baQ4kHNjvta7dQsw8/1qNcP
         jnS/ioUlSyjYpHM6XB96VM/4Zi8x2IO/tFwLxvqH8bPkeFOfLwT3s2xRUFPoRNb9hV
         Zemyw5xn8fS1Q==
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        =?utf-8?Q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v2 bpf-next 0/2] xsk: introduce generic almost-zerocopy xmit
Message-ID: <20210331122602.6000-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series is based on the exceptional generic zerocopy xmit logics
initially introduced by Xuan Zhuo. It extends it the way that it
could cover all the sane drivers, not only the ones that are capable
of xmitting skbs with no linear space.

The first patch is a random while-we-are-here improvement over
full-copy path, and the second is the main course. See the individual
commit messages for the details.

The original (full-zerocopy) path is still here and still generally
faster, but for now it seems like virtio_net will remain the only
user of it, at least for a considerable period of time.

From v1 [0]:
 - don't add a whole SMP_CACHE_BYTES because of only two bytes
   (NET_IP_ALIGN);
 - switch to zerocopy if the frame is 129 bytes or longer, not 128.
   128 still fit to kmalloc-512, while a zerocopy skb is always
   kmalloc-1024 -> can potentially be slower on this frame size.

[0] https://lore.kernel.org/netdev/20210330231528.546284-1-alobakin@pm.me

Alexander Lobakin (2):
  xsk: speed-up generic full-copy xmit
  xsk: introduce generic almost-zerocopy xmit

 net/xdp/xsk.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

--
Well, this is untested. I currently don't have an access to my setup
and is bound by moving to another country, but as I don't know for
sure at the moment when I'll get back to work on the kernel next time,
I found it worthy to publish this now -- if any further changes will
be required when I already will be out-of-sight, maybe someone could
carry on to make a another revision and so on (I'm still here for any
questions, comments, reviews and improvements till the end of this
week).
But this *should* work with all the sane drivers. If a particular
one won't handle this, it's likely ill. Any tests are highly
appreciated. Thanks!
--
2.31.1


