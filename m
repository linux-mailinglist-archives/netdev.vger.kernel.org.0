Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4571B6914D4
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 00:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjBIXok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 18:44:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbjBIXod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 18:44:33 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 591BC7EEC
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 15:44:28 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id v17so4131094qto.3
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 15:44:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z5V/oGwUe//IXlpNqz2ZWT8BOMBNKB+bpEDkXzJUPj0=;
        b=BNl6m5fHLUnyWOV3FMa/Lt5ldz36Z3N/yI2m0uip1zQ4LHoMsXFi4SMLiwF9uwTJC7
         AqdqE/hmUj71dXXSIHlDLP9NSCIknPhJl39netCXMEGdJUKDCk76miY20oP4MuQI41d1
         9yyA519aNe2nvGcuhgyPdK7Vp7WozCCEbhKgKWGyI3BDCrkwJ4B0SNXm1IAaVln8Lh8W
         bgyJ8a9LdzOfnwBnn5vGblB3dPBWvSvs45WdVeiF7oQ90odrM6McXQIFBJeEbN+Py8F6
         e9IsVvoSz+rk5aJK+9hOgggWJAjB0gvtpGUxU2PjLmGQg05PPScayP3dpGMvxiy3EJz7
         LBXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z5V/oGwUe//IXlpNqz2ZWT8BOMBNKB+bpEDkXzJUPj0=;
        b=4rwXjALziEaCk0ABFgg7L7mUGAzo+VEi32owfhbEwb7MXnycLe33QTDlMrUmKYAD+3
         xU/uUoDMliloDpxvUP0abWJsQa9kUb0rUMbz2W32qs1GjyHJii+Q6qXTmPMi9xLEaVXC
         KuBOecwDt7cN7ZouBlEERKCCyE0BlnP3tllhcJEkbr1gsFoV4Axxmx9bN/oZUbjbhPiu
         dkw2t8ZLv3AyLYUayG9LKO39HV1BeTk4bovLeRO6j2Z0HVZ3vn9MQhlsVdyxk9Vm6PT0
         YoH5Bv0fACZmmGPgg3wLFDizH0a8UtWQCtZObowft7smHfHWw8I4P65IO+Vu2l8c+pzz
         5+TA==
X-Gm-Message-State: AO0yUKWtxgVx5YuoHBncqD2TbwkRWcpsEtAR27qy/eI5pvjcM5VqYf3p
        Ha0tRxfce2Yoq4dXOdXiX2MOSjEsB7Nmuw==
X-Google-Smtp-Source: AK7set9QwdlrCANWmg5QV0XOSoy4oC/VoA33PviDYqrPG0TwZCmrFOXpKhCE1W79oKi/Pwc+y2PcNQ==
X-Received: by 2002:a05:622a:148c:b0:3b6:2f22:75bd with SMTP id t12-20020a05622a148c00b003b62f2275bdmr23255971qtx.28.1675986267322;
        Thu, 09 Feb 2023 15:44:27 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id y19-20020a05622a121300b003bb822b0f35sm2197808qtx.71.2023.02.09.15.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 15:44:27 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, stephen@networkplumber.org
Cc:     kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2-next 2/2] iplink: add gso and gro max_size attributes for ipv4
Date:   Thu,  9 Feb 2023 18:44:24 -0500
Message-Id: <7c18c39af9ade6c4a95afaa0ba23903496ec648c.1675985919.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1675985919.git.lucien.xin@gmail.com>
References: <cover.1675985919.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds two attributes gso/gro_ipv4_max_size in iplink for the
user space support of the BIG TCP for IPv4:

  https://lore.kernel.org/netdev/de811bf3-e2d8-f727-72bc-c8a754a9d929@tessares.net/T/

Note that after this kernel patchset, "gso/gro_max_size" are used for IPv6
packets while "gso/gro_ipv4_max_size" are for IPv4 patckets. To not break
these old applications using "gso/gro_ipv4_max_size" for IPv4 GSO packets,
the new size will also be set on "gso/gro_ipv4_max_size" in kernel when
"gso/gro_max_size" changes to a value <= 65536.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 ip/ipaddress.c        | 12 ++++++++++++
 ip/iplink.c           | 22 ++++++++++++++++++++--
 man/man8/ip-link.8.in | 30 +++++++++++++++++++++++++++---
 3 files changed, 59 insertions(+), 5 deletions(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index c7553bcd..9ba81438 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -1264,6 +1264,18 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
 				   "gro_max_size %u ",
 				   rta_getattr_u32(tb[IFLA_GRO_MAX_SIZE]));
 
+		if (tb[IFLA_GSO_IPV4_MAX_SIZE])
+			print_uint(PRINT_ANY,
+				   "gso_ipv4_max_size",
+				   "gso_ipv4_max_size %u ",
+				   rta_getattr_u32(tb[IFLA_GSO_IPV4_MAX_SIZE]));
+
+		if (tb[IFLA_GRO_IPV4_MAX_SIZE])
+			print_uint(PRINT_ANY,
+				   "gro_ipv4_max_size",
+				   "gro_ipv4_max_size %u ",
+				   rta_getattr_u32(tb[IFLA_GRO_IPV4_MAX_SIZE]));
+
 		if (tb[IFLA_PHYS_PORT_NAME])
 			print_string(PRINT_ANY,
 				     "phys_port_name",
diff --git a/ip/iplink.c b/ip/iplink.c
index 4ec9e370..a8da52f9 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -114,8 +114,8 @@ void iplink_usage(void)
 		"		[ addrgenmode { eui64 | none | stable_secret | random } ]\n"
 		"		[ protodown { on | off } ]\n"
 		"		[ protodown_reason PREASON { on | off } ]\n"
-		"		[ gso_max_size BYTES ] | [ gso_max_segs PACKETS ]\n"
-		"		[ gro_max_size BYTES ]\n"
+		"		[ gso_max_size BYTES ] [ gso_ipv4_max_size BYTES ] [ gso_max_segs PACKETS ]\n"
+		"		[ gro_max_size BYTES ] [ gro_ipv4_max_size BYTES ]\n"
 		"\n"
 		"	ip link show [ DEVICE | group GROUP ] [up] [master DEV] [vrf NAME] [type TYPE]\n"
 		"		[nomaster]\n"
@@ -948,6 +948,24 @@ int iplink_parse(int argc, char **argv, struct iplink_req *req, char **type)
 				       *argv);
 			addattr32(&req->n, sizeof(*req),
 				  IFLA_GRO_MAX_SIZE, max_size);
+		} else if (strcmp(*argv, "gso_ipv4_max_size") == 0) {
+			unsigned int max_size;
+
+			NEXT_ARG();
+			if (get_unsigned(&max_size, *argv, 0))
+				invarg("Invalid \"gso_ipv4_max_size\" value\n",
+				       *argv);
+			addattr32(&req->n, sizeof(*req),
+				  IFLA_GSO_IPV4_MAX_SIZE, max_size);
+		}  else if (strcmp(*argv, "gro_ipv4_max_size") == 0) {
+			unsigned int max_size;
+
+			NEXT_ARG();
+			if (get_unsigned(&max_size, *argv, 0))
+				invarg("Invalid \"gro_ipv4_max_size\" value\n",
+				       *argv);
+			addattr32(&req->n, sizeof(*req),
+				  IFLA_GRO_IPV4_MAX_SIZE, max_size);
 		} else if (strcmp(*argv, "parentdev") == 0) {
 			NEXT_ARG();
 			addattr_l(&req->n, sizeof(*req), IFLA_PARENT_DEV_NAME,
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index eeddf493..c8c65657 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -38,11 +38,16 @@ ip-link \- network device configuration
 .br
 .RB "[ " gso_max_size
 .IR BYTES " ]"
+.RB "[ " gso_ipv4_max_size
+.IR BYTES " ]"
 .RB "[ " gso_max_segs
 .IR SEGMENTS " ]"
 .br
 .RB "[ " gro_max_size
 .IR BYTES " ]"
+.RB "[ " gro_ipv4_max_size
+.IR BYTES " ]"
+.br
 .RB "[ " netns " {"
 .IR PID " | " NETNSNAME " } ]"
 .br
@@ -90,10 +95,15 @@ ip-link \- network device configuration
 .br
 .RB "[ " gso_max_size
 .IR BYTES " ]"
+.RB "[ " gso_ipv4_max_size
+.IR BYTES " ]"
 .RB "[ " gso_max_segs
 .IR SEGMENTS " ]"
+.br
 .RB "[ " gro_max_size
 .IR BYTES " ]"
+.RB "[ " gro_ipv4_max_size
+.IR BYTES " ]"
 .br
 .RB "[ " name
 .IR NEWNAME " ]"
@@ -423,7 +433,14 @@ specifies the number of receive queues for new device.
 .TP
 .BI gso_max_size " BYTES "
 specifies the recommended maximum size of a Generic Segment Offload
-packet the new device should accept.
+packet the new device should accept. This is also used to enable BIG
+TCP for IPv6 on this device when the size is greater than 65536.
+
+.TP
+.BI gso_ipv4_max_size " BYTES "
+specifies the recommended maximum size of a IPv4 Generic Segment Offload
+packet the new device should accept. This is especially used to enable
+BIG TCP for IPv4 on this device by setting to a size greater than 65536.
 
 .TP
 .BI gso_max_segs " SEGMENTS "
@@ -432,8 +449,15 @@ segments the new device should accept.
 
 .TP
 .BI gro_max_size " BYTES "
-specifies the maximum size of a packet built by GRO stack
-on this device.
+specifies the maximum size of a packet built by GRO stack on this
+device. This is also used for BIG TCP to allow the size of a
+merged IPv6 GSO packet on this device greater than 65536.
+
+.TP
+.BI gro_ipv4_max_size " BYTES "
+specifies the maximum size of a IPv4 packet built by GRO stack on this
+device. This is especially used for BIG TCP to allow the size of a
+merged IPv4 GSO packet on this device greater than 65536.
 
 .TP
 .BI index " IDX "
-- 
2.31.1

