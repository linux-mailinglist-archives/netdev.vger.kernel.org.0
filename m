Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 156C46755D1
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 14:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjATNbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 08:31:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjATNbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 08:31:01 -0500
Received: from mail-vs1-xe49.google.com (mail-vs1-xe49.google.com [IPv6:2607:f8b0:4864:20::e49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752E3C3815
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 05:30:43 -0800 (PST)
Received: by mail-vs1-xe49.google.com with SMTP id h63-20020a676c42000000b003d2301bce83so1529181vsc.20
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 05:30:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OzP2QBIBhbyTemOYGxdzcOjrkjy8Uu2+IWa1zI3xHAk=;
        b=VNM/HxUo8kO12e/8+kVGFaXsiXQlZsTkYE5sNjU80EDgGTp/qixqcUA6gnjADQ9WAd
         +fY7q7wbW4jUPDPnOyXENME+mLrK9AXtm1yI0FXB0M7mHCSZjG6nL7pkY9G1EgD3fQIO
         VQa/QtyTg2NBDK7BWo0lmS7uqA3FlQ72VvQfvbBUNC93k9gU6sPelEJ1vRLDHQfOMN/B
         aXZ1CdpRLpsaL8McAZSLd/3XfdlakdI5MKF+r2u3Nl6uRI/uPGuWGwL8LpfXR7Ug+JJo
         Qbtb0u36IdbRVIx1amTWMJHBWa0yE/66x0p/MK2V+97NyLZifBUMvmPHU1q18UfXU2ii
         7OEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OzP2QBIBhbyTemOYGxdzcOjrkjy8Uu2+IWa1zI3xHAk=;
        b=M7Y/U+8QKw+op3Z2TXj8QFhEVEr3E90efLy7xUgH9QLVMtUFlBmZMTN4jI8JgnqKlS
         OktNLU8loYGxdJB7LPEUA9ZH5tzNm4bpDtt39kQLv+U8z6eO9E7wwpd66n3KYrM/6lA8
         u1+6HLnwc2afbV/HgZVRmzj4oUmkJ486skyXenxLUXau9SzZyCiB5pP6sP0bYESatEbn
         vceFGbc3ZPxbDiq/FhJZsnZ0U7BXqWvgCWhaAlHAY27kQTkpc29Mki5NW+EvU2GEe+yz
         afMk7HzQU/IJOvhXJHDGgfKoc+X7q/zYtjkrD8inNGhtkFGoegL2FpjFLxhbLCfUs5S5
         wDIA==
X-Gm-Message-State: AFqh2kpG8a+Egj9G+Qql3eEUvUGZQpdemLmD5S87gXEO42dIkmo9l0hB
        O4IGk4UAfDqff4fo3gxSEjP8TQwJARCheA==
X-Google-Smtp-Source: AMrXdXse6XHHuGjBstGcw1yQAP5vhF/5IkEWT1hlLfAKUjLNnbdqau/XrmpRMznC1g4tBy5nZmwRlLgWCUTvYg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:ab0:5bc1:0:b0:5cf:b0f9:56b4 with SMTP id
 z1-20020ab05bc1000000b005cfb0f956b4mr1824410uae.45.1674221442650; Fri, 20 Jan
 2023 05:30:42 -0800 (PST)
Date:   Fri, 20 Jan 2023 13:30:40 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.405.gd4c25cc71f-goog
Message-ID: <20230120133040.3623463-1-edumazet@google.com>
Subject: [PATCH net] ipv4: prevent potential spectre v1 gadget in ip_metrics_convert()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	if (!type)
		continue;
	if (type > RTAX_MAX)
		return -EINVAL;
	...
	metrics[type - 1] = val;

@type being used as an array index, we need to prevent
cpu speculation or risk leaking kernel memory content.

Fixes: 6cf9dfd3bd62 ("net: fib: move metrics parsing to a helper")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/metrics.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/metrics.c b/net/ipv4/metrics.c
index 7fcfdfd8f9def057cbe163b8b395cd2379d98152..0e3ee1532848c8f49e0a342b7c8ecc1c27684e67 100644
--- a/net/ipv4/metrics.c
+++ b/net/ipv4/metrics.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <linux/netlink.h>
+#include <linux/nospec.h>
 #include <linux/rtnetlink.h>
 #include <linux/types.h>
 #include <net/ip.h>
@@ -25,6 +26,7 @@ static int ip_metrics_convert(struct net *net, struct nlattr *fc_mx,
 			return -EINVAL;
 		}
 
+		type = array_index_nospec(type, RTAX_MAX + 1);
 		if (type == RTAX_CC_ALGO) {
 			char tmp[TCP_CA_NAME_MAX];
 
-- 
2.39.1.405.gd4c25cc71f-goog

