Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6FA4C6E59
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 14:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235873AbiB1NiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 08:38:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235794AbiB1Nht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 08:37:49 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9366C7B57A;
        Mon, 28 Feb 2022 05:37:10 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id j7so21389365lfu.6;
        Mon, 28 Feb 2022 05:37:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=fCS8NJ1f4o3pcOzQ2HFVShBXhNj/eZkbyzRnMyoDoqM=;
        b=iQuNR3RTtSq4bagn13GPmxueF5CMO2/LAduE5LAjkj7bMEhGCrfeoQo8Xydc0cPJsr
         TL/nDl0eIb5cpSBsuWgBN4Aobnt6tNTKvsAyyG77OOmMXwwdOtPgPEHm+MJt1czGsWFW
         rG/5S3k9KKST1UBfMDCtNn0nbQXVJb8owaunrEt/M8v9r0SnIT0UygB354Fq740Ko6Hc
         IuutkNM1pkvl8H1XQyaquq93wOSO28j+TV2ba33Ej8qDtOaQKgPjvXgxD+/I9JMkDZl8
         6BCYGmmXjrKGM74CB5E5TPbpKK4oP5vu8DMRY9CD5HYZAE6dmtgQ2EWsNQKTiGR1bH5o
         lFFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=fCS8NJ1f4o3pcOzQ2HFVShBXhNj/eZkbyzRnMyoDoqM=;
        b=cvWPA/hlfB0gi+KSF/5qV+nc8aO77A0tudiZLoBAdJvvJVnYTbjpwHHyQFEUFIjGHX
         +l+16ZcfGwwvpiSDT6YUVU5JvgoPV6MM8TEKzqIV0Ol/YH8HL5IMgttGfTN0InrAZQIa
         7nlcP7pINKAkgJT20vDsxGdAnKDrq/Y+b112Vegz8E9xJI3BJaNxWgGBufSwq+u3ylhN
         kwPM+ATkN9YNb/2dLqtjrsAVIPFaWbi8a/h8TnXtkYE8oIuKaK2UCh140tVF0HMFbxfN
         KdVtA8R6PxhPOir3FDuXHietZx58MRIZO32zIgaHD+U9KJ9NsTuaIkFWdqIs2YNNCsYB
         ZKwQ==
X-Gm-Message-State: AOAM532VmvkfQ7raCMZcuaiVdBAZtNlFgxWxjwco++8nO9zYy9sODPVf
        VF3izc7XQMbv9qSurxDTcgs=
X-Google-Smtp-Source: ABdhPJxAnD2C4QWM4ryQtpQGbdXIhF5shie2JCY2jCGcsrF4nLTuFBYHAam/0oiMfJXaJRiOWmmx8g==
X-Received: by 2002:a05:6512:22cb:b0:42e:f15f:7282 with SMTP id g11-20020a05651222cb00b0042ef15f7282mr12911915lfu.530.1646055428992;
        Mon, 28 Feb 2022 05:37:08 -0800 (PST)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id i16-20020a2e5410000000b0024647722a4asm1326640ljb.29.2022.02.28.05.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 05:37:08 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH iproute2-next V2 2/4] ip: iplink_bridge_slave: add locked port flag support
Date:   Mon, 28 Feb 2022 14:36:48 +0100
Message-Id: <20220228133650.31358-3-schultz.hans+netdev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220228133650.31358-1-schultz.hans+netdev@gmail.com>
References: <20220228133650.31358-1-schultz.hans+netdev@gmail.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syntax: ip link set dev DEV type bridge_slave locked {on | off}

Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
---
 ip/iplink_bridge_slave.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/ip/iplink_bridge_slave.c b/ip/iplink_bridge_slave.c
index 71787586..da14a95e 100644
--- a/ip/iplink_bridge_slave.c
+++ b/ip/iplink_bridge_slave.c
@@ -42,6 +42,7 @@ static void print_explain(FILE *f)
 		"			[ neigh_suppress {on | off} ]\n"
 		"			[ vlan_tunnel {on | off} ]\n"
 		"			[ isolated {on | off} ]\n"
+		"			[ locked {on | off} ]\n"
 		"			[ backup_port DEVICE ] [ nobackup_port ]\n"
 	);
 }
@@ -278,6 +279,10 @@ static void bridge_slave_print_opt(struct link_util *lu, FILE *f,
 		print_on_off(PRINT_ANY, "isolated", "isolated %s ",
 			     rta_getattr_u8(tb[IFLA_BRPORT_ISOLATED]));
 
+	if (tb[IFLA_BRPORT_LOCKED])
+		print_on_off(PRINT_ANY, "locked", "locked %s ",
+			     rta_getattr_u8(tb[IFLA_BRPORT_LOCKED]));
+
 	if (tb[IFLA_BRPORT_BACKUP_PORT]) {
 		int backup_p = rta_getattr_u32(tb[IFLA_BRPORT_BACKUP_PORT]);
 
@@ -393,6 +398,10 @@ static int bridge_slave_parse_opt(struct link_util *lu, int argc, char **argv,
 			NEXT_ARG();
 			bridge_slave_parse_on_off("isolated", *argv, n,
 						  IFLA_BRPORT_ISOLATED);
+		} else if (matches(*argv, "locked") == 0) {
+			NEXT_ARG();
+			bridge_slave_parse_on_off("locked", *argv, n,
+						  IFLA_BRPORT_LOCKED);
 		} else if (matches(*argv, "backup_port") == 0) {
 			int ifindex;
 
-- 
2.30.2

