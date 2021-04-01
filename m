Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F3F350FAD
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 09:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233286AbhDAG7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 02:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232951AbhDAG72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 02:59:28 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25012C0613E6;
        Wed, 31 Mar 2021 23:59:28 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id h13so721619eds.5;
        Wed, 31 Mar 2021 23:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cMxe7I7l2vSX0n+XPp1Pbjsdyyq6ZSpuIHYWB6ESO5o=;
        b=kmR3ElAIn+fDgfAe3qxvOysNle3yOcD5Ty25mY4ft6p1NtFaB3epHPi8r4ZorAlT+a
         Mv5zpbmM3Kd0l+T96WVrRcoHU8ROwj/4ChMQ0u/ZawZQrNu82JqtwpzshZmlbtPfCWt/
         bzuVVW6H55UJTyCQvLTrJokjlVQiuRgTc+L4NRZRE2cykUcKwDrR01k+MFCN25JxPVzL
         vp/80IJFT2qL+ZkHk16pS0t1M50lWWMWE+zf/k8/FkBq92gcKEM2y9FiRA3E0vnheHmh
         CLJTdA+QY6FYi5J3FgLxgUyTZ6i7Yz2z+bEyuqUxhI8iCW4oI2UqyvHok74MI9NBIs+R
         ZrLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cMxe7I7l2vSX0n+XPp1Pbjsdyyq6ZSpuIHYWB6ESO5o=;
        b=F0X3IOC9mybaErmXML1ImJFXjvLebO0SfWkuQOC1pL+Ii6YEtb8MrendFMvBoejjYF
         TOutj2GJmpHyeLiz8Q8eMCufGX32jJb/Ac39VirbZk+To2YlPL3du3ztTa2Mr7u8jKmP
         bs8TXztAZFPF4lLli8gzRoa5UgI4Z5Tm6zvyuc4YrvsYOVesN+JWl+xkEQEsNDJH1g8e
         Pg0h3CrJJKw1eulIgzjgutJLVMfjg1KLxGIfRiNvle/2w+XQ2MHcX1r0fGlNI73NzYWj
         F+NPMAFQRevU9W2nQWIZh6T50tFAHmPZtQPPjVw8M/36MU0fk1+0Pc0ZRqX3A3xe0Hh0
         6HRA==
X-Gm-Message-State: AOAM532JE/HpjVgxO9LMSjHxNiLZC3LTDP4jRvQ0TG2u0pG1RgIad8nI
        nvusucJn7/+oKEa6LzbC8gBwdZjSVLRe9A==
X-Google-Smtp-Source: ABdhPJzSgdplA+nTMXP6cAfBlom2HWzng16tTcgQkgRD12d6aXUFDTl3x7FrdWW2eKt+XXBX2VQdPA==
X-Received: by 2002:a05:6402:2cd:: with SMTP id b13mr8277948edx.55.1617260366962;
        Wed, 31 Mar 2021 23:59:26 -0700 (PDT)
Received: from localhost.localdomain (ip-178-202-123-242.hsi09.unitymediagroup.de. [178.202.123.242])
        by smtp.googlemail.com with ESMTPSA id bm21sm2313817ejb.36.2021.03.31.23.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 23:59:26 -0700 (PDT)
From:   Norman Maurer <norman.maurer@googlemail.com>
X-Google-Original-From: Norman Maurer <norman_maurer@apple.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, dsahern@kernel.org
Cc:     pabeni@redhat.com, Norman Maurer <norman_maurer@apple.com>
Subject: [PATCH net] net: udp: Add support for getsockopt(..., ..., UDP_GRO, ..., ...);
Date:   Thu,  1 Apr 2021 08:59:17 +0200
Message-Id: <20210401065917.78025-1-norman_maurer@apple.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Norman Maurer <norman_maurer@apple.com>

Support for UDP_GRO was added in the past but the implementation for
getsockopt was missed which did lead to an error when we tried to
retrieve the setting for UDP_GRO. This patch adds the missing switch
case for UDP_GRO

Fixes: e20cf8d3f1f7 ("udp: implement GRO for plain UDP sockets.")
Signed-off-by: Norman Maurer <norman_maurer@apple.com>
---
 net/ipv4/udp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 4a0478b17243..99d743eb9dc4 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2754,6 +2754,10 @@ int udp_lib_getsockopt(struct sock *sk, int level, int optname,
 		val = up->gso_size;
 		break;
 
+	case UDP_GRO:
+		val = up->gro_enabled;
+		break;
+
 	/* The following two cannot be changed on UDP sockets, the return is
 	 * always 0 (which corresponds to the full checksum coverage of UDP). */
 	case UDPLITE_SEND_CSCOV:
-- 
2.30.2

