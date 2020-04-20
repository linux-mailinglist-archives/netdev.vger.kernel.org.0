Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF211B19FE
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 01:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgDTXOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 19:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726006AbgDTXOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 19:14:36 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE08C061A0E;
        Mon, 20 Apr 2020 16:14:36 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id 7so492117pjo.0;
        Mon, 20 Apr 2020 16:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B9l1xnPXy+nd1araMR4jj9v6EoE/02twAyj3rEmsRf0=;
        b=Qo3nMwIZxwV+JnTDsHKZBw3VFZ/3gsqrTBlYyOAfD3qEdMSTuG6rQtDwQYaI9HRtZj
         R64vAkjVpc1IyWSorbWVlhn+tAybBjcBd1Kare60iou2FUphVgSHZtx7giBk0TkDn88y
         kOBV0eM++FFCQ9+r3o4TygDT7A5199KVWvIcPv23XR3hR+/ne8U38yrHlJNfaCKjlj6l
         kjKZQ2Evu5Vc/ITLiUw1r98hc1+7A+/KCOMdYWbrH3vjbqR9igxzM0B/qLyxbqQKVIkL
         IyCVXfcCrbdyLE3IqsmlKfzwH4qEEwDc9itUMJ6ji3cmUHDyGt7D8I25Upl4AV+fkPcg
         FQCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B9l1xnPXy+nd1araMR4jj9v6EoE/02twAyj3rEmsRf0=;
        b=Bh4d7JMLviPLjFtu8qst3Gs/wXXI/YUYolT+zwCr/nMduQ34oNloMuSteiPJU53GmS
         5wZrKczYtpAnuxsRdoJ5OEW32rTyIvG5RIw8OpgbRn0tQvUlviK6Yyu29o8WAqAXGKpp
         j5PQA6sE0Y7Z/7fRYOLffMznLbAXAGxdY0N5aDVwQyNsh2EY39z3Vm/0gp75kKAbrZYI
         mpLCmNpCC88JENASGrjzCvDr1HkL102hLNKi55gAE6RvitlbxsPDorWVCNJrrXyx8jcC
         nl2HJLa0N+eRVtGpspYgUadbD39UPpzPbBsXoiMtNKQ+2EfagmnLDdTluWhgB0K50d3g
         +2IQ==
X-Gm-Message-State: AGi0PuZ3CzDq/6bd3knj0kzAd/MYoDrdH9e3MWuENPvy/SUwM8fYZ5OA
        WJMKElPFfxqtONECJZxxHPM=
X-Google-Smtp-Source: APiQypLUPRcHtn/Lm52aNPg88MYdSfaiOnL4QrOEwPT2oGD3fw7/Dk49Ywi1vYd7mW38MbU2gyeVSQ==
X-Received: by 2002:a17:902:bf09:: with SMTP id bi9mr2729845plb.193.1587424475924;
        Mon, 20 Apr 2020 16:14:35 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id v26sm549726pfe.121.2020.04.20.16.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 16:14:35 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH] [RFC] net: bpf: make __bpf_skb_max_len(skb) an skb-independent constant
Date:   Mon, 20 Apr 2020 16:14:27 -0700
Message-Id: <20200420231427.63894-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This function is used from:
  bpf_skb_adjust_room
  __bpf_skb_change_tail
  __bpf_skb_change_head

but in the case of forwarding we're likely calling these functions
during receive processing on ingress and bpf_redirect()'ing at
a later point in time to egress on another interface, thus these
mtu checks are for the wrong device.

This is particularly problematic if we're receiving on an L3 1500 mtu
cellular interface, trying to add an L2 header and forwarding to
an L3 mtu 1500 mtu wifi/ethernet device.  The mtu check prevents
us from adding the ethernet header prior to forwarding the packet.
After the packet has already been redirected, we'd need to add
an additional 2nd ebpf program on the target device's egress tc hook,
but then we'd also see non-redirected traffic and have no easy
way to tell apart normal egress with ethernet header packets
from forwarded ethernet headerless packets.

Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 net/core/filter.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index ec567d1e6fb9..1e119a47f9fe 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3159,8 +3159,7 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
 
 static u32 __bpf_skb_max_len(const struct sk_buff *skb)
 {
-	return skb->dev ? skb->dev->mtu + skb->dev->hard_header_len :
-			  SKB_MAX_ALLOC;
+	return SKB_MAX_ALLOC;
 }
 
 BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
-- 
2.26.1.301.g55bc3eb7cb9-goog

