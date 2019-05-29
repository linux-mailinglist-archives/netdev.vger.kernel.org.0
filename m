Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2D732DA89
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 12:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbfE2KZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 06:25:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40602 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbfE2KZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 06:25:45 -0400
Received: from 1.general.smb.uk.vpn ([10.172.193.28] helo=canonical.com)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <stefan.bader@canonical.com>)
        id 1hVvmB-0003iZ-1C; Wed, 29 May 2019 10:25:43 +0000
From:   Stefan Bader <stefan.bader@canonical.com>
To:     stable <stable@vger.kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Sasha Levin <sashal@kernel.org>,
        Peter Oskolkov <posk@google.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Andy Whitcroft <andy.whitcroft@canonical.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 0/4] ipv6: frags: fixups for linux-4.4.y
Date:   Wed, 29 May 2019 12:25:38 +0200
Message-Id: <20190529102542.17742-1-stefan.bader@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While this backport proposal is based on the 4.4.y stable tree, it
might also apply in some form to any stable tree which backported

 05c0b86b96: "ipv6: frags: rewrite ip6_expire_frag_queue()"

While this made ip6_expire_frag_queue() similar to ip_exire(),
it did not follow the additional changes to ip_expire() which
were also backported:

 fa0f527358: "ip: use rb trees for IP frag queue."

 a4fd284a1f: "ip: process in-order fragments efficiently"

The former of the two not only adds handling for rb trees, but
also modifies ip_expire() to take the first skb off the queue
before using it for the sending the icmp message. This also got
rid of the need to protect the skb by incrementing its reference
count (which is the reason for the crash in ip6_expire_frag_queue()).

My first approach was do those changes in ip6_expire_frag_queue(),
but only the former of the two can be done without problems. The
latter uses code which is only locally defined in ipv4/ip_fragment.c.

This was changed upstream in 5.1 when moving code around to be shared

  c23f35d19d: "net: IP defrag: encapsulate rbtree defrag code into
               callable functions"

And while backporting that I found the two other changes which sounded
like one might want them backported, too. Maybe even more since the
second (ip: fail fast on IP defrag errors) is already partially
included in the backport of "net: ipv4: do not handle duplicate
fragments as overlapping".

Though I do realize that "net: IP defrag: encapsulate rbtree
defrag code into callable functions" is rather large and for
that reason maybe not qualifying as a stable backport.
So I would like to ask what the net-developers think about
this.

Thanks,
Stefan



0001: v4.20: ipv4: ipv6: netfilter: Adjust the frag mem limit when
             truesize changes
0002: v4.20: ip: fail fast on IP defrag errors
0003: v5.1 : net: IP defrag: encapsulate rbtree defrag code into
             callable functions
0004: n/a  : ipv6: frags: Use inet_frag_pull_head() in
             ip6_expire_frag_queue()

Jiri Wiesner (1):
  ipv4: ipv6: netfilter: Adjust the frag mem limit when truesize changes

Peter Oskolkov (2):
  ip: fail fast on IP defrag errors
  net: IP defrag: encapsulate rbtree defrag code into callable functions

Stefan Bader (1):
  ipv6: frags: Use inet_frag_pull_head() in ip6_expire_frag_queue()

 include/net/inet_frag.h                 |  16 +-
 net/ipv4/inet_fragment.c                | 293 +++++++++++++++++++++++
 net/ipv4/ip_fragment.c                  | 294 +++---------------------
 net/ipv6/netfilter/nf_conntrack_reasm.c |   8 +-
 net/ipv6/reassembly.c                   |  20 +-
 5 files changed, 359 insertions(+), 272 deletions(-)

-- 
2.17.1

