Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19C81275009
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 06:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgIWElK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 00:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgIWElK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 00:41:10 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E42EC061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 21:41:10 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id f1so6155065plo.13
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 21:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o3L93kdyef2D+YSsF7K7mgBJhEirkZv97xi6h+iyNZU=;
        b=QO5g40pJ3Vk7oFzQrsecWlSk42jxybkshU+HMKWYOIMitMjqepoazFXq6C2cK1QqOE
         aePq0OGaA/HKFmC084kOvAW2SeTc7BPtbikhylbDNZwtY25sRATmMdcLVN6btx203NoE
         5Zf3JQ8rDR9nqhpm90bJ5K/Oum55CDvkVzknywg3ZoqhITKVb0GZIAvfg01dCmf9Pade
         /fmfuq5CcvJjSem+DUxwWnfUfTTAF3pSWW46i/Pf0Otn7UujQ2628A3IusbNVW8VgoKf
         ruL7+BXmudmfyH/soYAoaMz+8S7yQxzW7IEsLXWODfnkwjugn1cupFKty1m7WSW0exWc
         t5UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o3L93kdyef2D+YSsF7K7mgBJhEirkZv97xi6h+iyNZU=;
        b=VWGZwIPSlrYpwooe+qY4OhfRvR8dVZ1GjEoQWRX+9rMckg9YaTl6O40fzrgcVTT+W+
         YFCkqA49EEDrT/WtfOa0hxkTBp3TBKAu30pt4sq9QDdx+jdX0nrKsmCwi5s9/7B5eQxd
         aLo7b98oeL6e0LZJl37EI+UonY/acfZ3SevVNDVab3UixvCnjlk1VCMeaUbdOiaJK7wq
         SJ/lciLcZgS05KsA9Xv06zMKNinsNoBd56vM8OMWP7HRr/kq+ylPOD7shtgx2/CrJ/4j
         FT1YnfEJ/8R/Zym+4xGXkr1YTd7NT56DryCAjoxD6K4ZAlvoff/ChER6KhsRSoNoANye
         GPbQ==
X-Gm-Message-State: AOAM533E3JTovIaijFXyjWAScG+ndq8dQpFLCQsDaGcmeVNfaLKcs2jo
        DsBQs9x7EJa4VvRAwhb5O+Y=
X-Google-Smtp-Source: ABdhPJx7jCIuRMgaQV+XkL9znzI3RESXrdG/k7LkuHNdE+1jQiTRJ2065w9Hq9A+ZsoTScKGrSp12w==
X-Received: by 2002:a17:902:6bc1:b029:d0:cbe1:e73d with SMTP id m1-20020a1709026bc1b02900d0cbe1e73dmr8091931plt.24.1600836069727;
        Tue, 22 Sep 2020 21:41:09 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:a28c:fdff:fee1:f370])
        by smtp.gmail.com with ESMTPSA id 22sm16595024pfw.17.2020.09.22.21.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 21:41:08 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        Sunmeet Gill <sgill@quicinc.com>,
        Vinay Paradkar <vparadka@qti.qualcomm.com>,
        Tyler Wear <twear@quicinc.com>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH] net/ipv4: always honour route mtu during forwarding
Date:   Tue, 22 Sep 2020 21:40:59 -0700
Message-Id: <20200923044059.3442423-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

Documentation/networking/ip-sysctl.txt:46 says:
  ip_forward_use_pmtu - BOOLEAN
    By default we don't trust protocol path MTUs while forwarding
    because they could be easily forged and can lead to unwanted
    fragmentation by the router.
    You only need to enable this if you have user-space software
    which tries to discover path mtus by itself and depends on the
    kernel honoring this information. This is normally not the case.
    Default: 0 (disabled)
    Possible values:
    0 - disabled
    1 - enabled

Which makes it pretty clear that setting it to 1 is a potential
security/safety/DoS issue, and yet it is entirely reasonable to want
forwarded traffic to honour explicitly administrator configured
route mtus (instead of defaulting to device mtu).

Indeed, I can't think of a single reason why you wouldn't want to.
Since you configured a route mtu you probably know better...

It is pretty common to have a higher device mtu to allow receiving
large (jumbo) frames, while having some routes via that interface
(potentially including the default route to the internet) specify
a lower mtu.

Note that ipv6 forwarding uses device mtu unless the route is locked
(in which case it will use the route mtu).

This approach is not usable for IPv4 where an 'mtu lock' on a route
also has the side effect of disabling TCP path mtu discovery via
disabling the IPv4 DF (don't frag) bit on all outgoing frames.

I'm not aware of a way to lock a route from an IPv6 RA, so that also
potentially seems wrong.

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Cc: Eric Dumazet <maze@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Lorenzo Colitti <lorenzo@google.com>
Cc: Sunmeet Gill (Sunny) <sgill@quicinc.com>
Cc: Vinay Paradkar <vparadka@qti.qualcomm.com>
Cc: Tyler Wear <twear@quicinc.com>
Cc: David Ahern <dsahern@kernel.org>
---
 include/net/ip.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/net/ip.h b/include/net/ip.h
index b09c48d862cc..1262011d00b8 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -442,6 +442,10 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
 	    !forwarding)
 		return dst_mtu(dst);
 
+	/* 'forwarding = true' case should always honour route mtu */
+	unsigned int mtu = dst_metric_raw(dst, RTAX_MTU);
+	if (mtu) return mtu;
+
 	return min(READ_ONCE(dst->dev->mtu), IP_MAX_MTU);
 }
 
-- 
2.28.0.681.g6f77f65b4e-goog

