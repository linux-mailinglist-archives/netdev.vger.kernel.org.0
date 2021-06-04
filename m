Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5B939B00B
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 03:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhFDByv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 21:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFDByv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 21:54:51 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D08C06174A;
        Thu,  3 Jun 2021 18:52:52 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id z26so6315018pfj.5;
        Thu, 03 Jun 2021 18:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rWOwslvWBfTdFK9pe5secWd9IFRH1Q9FtXwAnGwKEVU=;
        b=sERKOkseJBRpIlw6qDLx8DFOEh7xSh2tdQM+Vo5MzEGDxDraN0bj2YqlkkP1jS7OGc
         kDOjIN6Qke/N9oLTDBHCS2++/qtDB5Ly1wGl/N8zSXaEOQZ/nb8HvSZA2TQl70aGeuCz
         SAS9Elr+OVzQ3bXqs4kerFIXfsHwOlo8wG0FP6Kx7GaRf2wP0T2BRV+ZbOvNyzI6XPH1
         tSpSD9pNSeCCdCvD3EI67q0WIOmN7H9Y43IyiAtDrczWQkisvZeswu/23IfxqlRzfoVw
         Ty5eyzuqWbZFkspyMyDnNsvuPhHV20oVKB9OSLCOusyLsShDCSvmuzPzHJknIh3kkRPv
         Fsjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rWOwslvWBfTdFK9pe5secWd9IFRH1Q9FtXwAnGwKEVU=;
        b=EX5ni06SfqkyoS5TnWC1Qw0MvrOca1n/Kh8pB3ik2aR84LaHr7d6DYuvl6ysePv6tt
         3gf11GOnss3rG2wn/Q2yjfXhYkdMBU9kZT2f+B61tUdafsDo2y1ByqyCqzrvYdpZVfAe
         NqjgRlx+QyEQ3bnCRLtAHMpQEixlpOevIsHHBitBmCaSwmzfCXSuQRPEjSi74RTcWoDt
         9cgQjihghbxva/4I9MbyqkoiAzY6K1i1VEv024Sfz9qZTS2OrEsmFDvFDDBMEkyXjguS
         DSz1W7RZA5wF+IvHOkoa0JhBUsKHzt8RgctzOvp2hY+y8jzigWn+Fl4+XfE/RrGgcQg/
         7cYw==
X-Gm-Message-State: AOAM533D3EQXHDpazgr31pSUbhvj/aLf8DbBUfeoJm5eDvpAT1zarrVh
        HLU001zvoRNLVcpgEmvvpG6z/Urkugt+2Q==
X-Google-Smtp-Source: ABdhPJybdLpn0UL/mudtnYCe9s2xDSm14wNZs+O3lI07HkGz4EpjbQPQRiVyfHDdEl8aThnW5TMLGQ==
X-Received: by 2002:a63:7945:: with SMTP id u66mr2352213pgc.200.1622771571862;
        Thu, 03 Jun 2021 18:52:51 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c45:b07d:e001:d01])
        by smtp.gmail.com with ESMTPSA id c130sm274502pfc.51.2021.06.03.18.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 18:52:51 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Dongseok Yi <dseok.yi@samsung.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH bpf-next 2/2] bpf: do not change gso_size during bpf_skb_change_proto()
Date:   Thu,  3 Jun 2021 18:52:38 -0700
Message-Id: <20210604015238.2422145-2-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
In-Reply-To: <20210604015238.2422145-1-zenczykowski@gmail.com>
References: <20210604015238.2422145-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This is technically a backwards incompatible change in behaviour,
but I'm going to argue that it is very unlikely to break things,
and likely to fix *far* more then it breaks.

In no particular order, various reasons follow:

(a) I've long had a bug assigned to myself to debug a super rare kernel
crash on Android Pixel phones which can (per stacktrace) be traced back
to bpf clat ipv6 to ipv4 protocol conversion causing some sort of ugly
failure much later on during transmit deep in the GSO engine, AFAICT
precisely because of this change to gso_size, though I've never been able
to manually reproduce it.
I believe it may be related to the particular network offload support
of attached usb ethernet dongle being used for tethering off of an
IPv6-only cellular connection.  The reason might be we end up with more
segments than max permitted, or with a gso packet with only one segment...
(either way we break some assumption and hit a BUG_ON)

(b) There is no check that the gso_size is > 20 when reducing it by 20,
so we might end up with a negative (or underflowing) gso_size or
a gso_size of 0.  This can't possibly be good.
Indeed this is probably somehow exploitable (or at least can result
in a kernel crash) by delivering crafted packets and perhaps triggering
an infinite loop or a divide by zero...
As a reminder: gso_size (mss) is related to mtu, but not directly
derived from it: gso_size/mss may be significantly smaller then
one would get by deriving from local mtu.  And on some nics (which
do loose mtu checking on receive, it may even potentially be larger,
for example my work pc with 1500 mtu can receive 1520 byte frames
[and sometimes does due to bugs in a vendor plat46 implementation]).
Indeed even just going from 21 to 1 is potentially problematic because
it increases the number of segments by a factor of 21 (think DoS,
or some other crash due to too many segments).

(c) It's always safe to not increase the gso_size, because it doesn't
result in the max packet size increasing.  So the skb_increase_gso_size()
call was always unnecessary for correctness (and outright undesirable, see
later).  As such the only part which is potentially dangerous (ie. could
cause backwards compatibility issues) is the removal of the
skb_decrease_gso_size() call.

(d) If the packets are ultimately destined to the local device, then
there is absolutely no benefit to playing around with gso_size.
It only matters if the packets will egress the device.  ie. we're
either forwarding, or transmitting from the device.

(e) This logic only triggers for packets which are GSO.  It does not
trigger for skbs which are not GSO.  It will not convert a non-GSO mtu
sized packet into a GSO packet (and you don't even know what the mtu is,
so you can't even fix it).  As such your transmit path must *already* be
able to handle an mtu 20 bytes larger then your receive path (for ipv4
to ipv6 translation) - and indeed 28 bytes larger due to ipv4 fragments.
Thus removing the skb_decrease_gso_size() call doesn't actually increase
the size of the packets your transmit side must be able to handle.
ie. to handle non-GSO max-mtu packets, the ipv4/ipv6 device/route mtus
must already be set correctly.  Since for example with an ipv4 egress mtu
of 1500, ipv4 to ipv6 translation will already build 1520 byte ipv6 frames,
so you need a 1520 byte device mtu.  This means if your ipv6 device's
egress mtu is 1280, your ipv4 route must be 1260 (and actually 1252,
because of the need to handle fragments).  This is to handle normal non-GSO
packets.  Thus the reduction is simply not needed for GSO packets,
because when they're correctly built, they will already be the right size.

(f) TSO/GSO should be able to exactly undo GRO: the number of packets
(TCP segments) should not be modified, so that TCP's mss counting works
correctly (this matters for congestion control).
If protocol conversion changes the gso_size, then the number of TCP segments
may increase or decrease.  Packet loss after protocol conversion can result
in partial loss of mss segments that the sender sent.  How's the sending
TCP stack going to react to receiving ACKs/SACKs in the middle of the
segments it sent?

(g) skb_{decrease,increase}_gso_size() are already no-ops for GSO_BY_FRAGS
case (besides triggering WARN_ON_ONCE). This means you already cannot
guarantee that gso_size (and thus resulting packet mtu) is changed.
ie. you must assume it won't be changed.

(h) changing gso_size is outright buggy for UDP GSO packets, where framing
matters (I believe that's also the case for SCTP, but it's already excluded
by [g]).  So the only remaining case is TCP, which also doesn't want it
(see [f]).

(i) see also the reasoning on the previous attempt at fixing this
(commit fa7b83bf3b156c767f3e4a25bbf3817b08f3ff8e) which shows
that the current behaviour causes TCP packet loss:

  In the forwarding path GRO -> BPF 6 to 4 -> GSO for TCP traffic, the
  coalesced packet payload can be > MSS, but < MSS + 20.

  bpf_skb_proto_6_to_4() will upgrade the MSS and it can be > the payload
  length. After then tcp_gso_segment checks for the payload length if it
  is <= MSS. The condition is causing the packet to be dropped.

  tcp_gso_segment():
    [...]
    mss = skb_shinfo(skb)->gso_size;
    if (unlikely(skb->len <= mss)) goto out;
    [...]

Thus changing the gso_size is simply a very bad idea.
Increasing is unnecessary and buggy, and decreasing can go negative.

Cc: Dongseok Yi <dseok.yi@samsung.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Willem de Bruijn <willemb@google.com>
Fixes: 6578171a7ff0 ("bpf: add bpf_skb_change_proto helper")
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 net/core/filter.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 04848de3e058..953b6c31b803 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3263,8 +3263,6 @@ static int bpf_skb_proto_4_to_6(struct sk_buff *skb)
 			shinfo->gso_type |=  SKB_GSO_TCPV6;
 		}
 
-		/* Due to IPv6 header, MSS needs to be downgraded. */
-		skb_decrease_gso_size(shinfo, len_diff);
 		/* Header must be checked, and gso_segs recomputed. */
 		shinfo->gso_type |= SKB_GSO_DODGY;
 		shinfo->gso_segs = 0;
@@ -3304,8 +3302,6 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
 			shinfo->gso_type |=  SKB_GSO_TCPV4;
 		}
 
-		/* Due to IPv4 header, MSS can be upgraded. */
-		skb_increase_gso_size(shinfo, len_diff);
 		/* Header must be checked, and gso_segs recomputed. */
 		shinfo->gso_type |= SKB_GSO_DODGY;
 		shinfo->gso_segs = 0;
-- 
2.32.0.rc1.229.g3e70b5a671-goog

