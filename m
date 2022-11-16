Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F24862BADE
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 12:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238718AbiKPLGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 06:06:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237845AbiKPLFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 06:05:42 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2213303EA
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 02:52:12 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id h12so21312524ljg.9
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 02:52:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Plqwnup+7oIelGEONlO5qvIt8Tuu+/wT1TXFJs1u9Nk=;
        b=edTfsxl8lhPrR/gzCTwcVjVGe7HY9DcTsgM5PzvXupDXWAahISUX/t7qj7j6wsvZAB
         xJOrpZ0YJ3ZWOTnpV8q6t+UhgJeXGOdxhB/O69iyc8wumAieFnlZDVEk/SYXg//QMYZ8
         Gc7lUQPoSqfuhGarWKYaGCE2rnkKC6QraGVDE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Plqwnup+7oIelGEONlO5qvIt8Tuu+/wT1TXFJs1u9Nk=;
        b=agiRrjqZHs9yHpcCmtK892uLs8K6fSUBX5i4yXlKDGOe6pT17mNFyUKbxWIMyZi7ic
         Qck/P24YwHxhT16hFOxBoeRbKA2p70WuQK4dxG4t19DE3POoe5A5/2f+Ih5BnqV+TcbU
         DlNmDxtGL7OazREfSrBxg7VPJMlZg9ktFdPURoZlK4sITdfK9HIyv8vUAHVukppXr6qz
         TRx3/nbUyBvqgrxzkdCrQ9rOlGcuuiRXFAaYrpM4mypZcMIYuIMsiULfOULRNoAL1B0C
         IlsYBmebq15NAo3TW44ak0GPvfe17e0aWAt4ULFfBRn9iu1x6nMwzP7zH2j+d10Kw7lR
         qKRA==
X-Gm-Message-State: ANoB5pmGlCuxfldZINwy/QeTe8hM2OR4pYaNhs6AL9Br32FZ5q5tdWKO
        bbt+HRd65QBRLZSsE4v3O3XE9g==
X-Google-Smtp-Source: AA0mqf7GqVixPSe1GHZcTqsttGWICrc1cPxMuhkyl4Mayvpq40evHv7BpGQP/tB/yoCrI99+z+LFhQ==
X-Received: by 2002:a2e:b007:0:b0:276:ff14:7a4d with SMTP id y7-20020a2eb007000000b00276ff147a4dmr7197293ljk.490.1668595931072;
        Wed, 16 Nov 2022 02:52:11 -0800 (PST)
Received: from localhost.localdomain ([87.54.42.112])
        by smtp.gmail.com with ESMTPSA id g42-20020a0565123baa00b004b094730074sm2547119lfv.267.2022.11.16.02.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 02:52:10 -0800 (PST)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/3] net: dsa: use NET_NAME_PREDICTABLE for user ports with name given in DT
Date:   Wed, 16 Nov 2022 11:52:03 +0100
Message-Id: <20221116105205.1127843-3-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221116105205.1127843-1-linux@rasmusvillemoes.dk>
References: <20221115074356.998747-1-linux@rasmusvillemoes.dk>
 <20221116105205.1127843-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a user port has a label in device tree, the corresponding
netdevice is, to quote include/uapi/linux/netdevice.h, "predictably
named by the kernel". This is also explicitly one of the intended use
cases for NET_NAME_PREDICTABLE, quoting 685343fc3ba6 ("net: add
name_assign_type netdev attribute"):

  NET_NAME_PREDICTABLE:
    The ifname has been assigned by the kernel in a predictable way
    [...] Examples include [...] and names deduced from hardware
    properties (including being given explicitly by the firmware).

Expose that information properly for the benefit of userspace tools
that make decisions based on the name_assign_type attribute,
e.g. a systemd-udev rule with "kernel" in NamePolicy.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 net/dsa/slave.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index d19e9a536b8f..dfefcc4a9ccf 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2385,7 +2385,7 @@ int dsa_slave_create(struct dsa_port *port)
 
 	if (port->name) {
 		name = port->name;
-		assign_type = NET_NAME_UNKNOWN;
+		assign_type = NET_NAME_PREDICTABLE;
 	} else {
 		name = "eth%d";
 		assign_type = NET_NAME_UNKNOWN;
-- 
2.37.2

