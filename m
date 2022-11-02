Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83B6E615DFB
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 09:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbiKBIjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 04:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbiKBIiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 04:38:52 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D8927FC4
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 01:38:48 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id f16-20020a05600c491000b003cf66a2e7c0so751028wmp.5
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 01:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uu6NC65X6R/bkJ3lkOXNxspINfAgK75MiSlc/snFhzo=;
        b=efPkXF+7cKrFsrM7K4mFvLBJEt5erFS4nuvGEIIMurR/+bOqxia3tli57ByrD9Ktm6
         CeNojlcLzvMsLe0cvIHuF/pSgCXSURzSaC9dNwIHLFLhn92YCT5URV8XsISJJVyqZW6U
         ly81rWd26vLXj/G1LPueUYtrG51zHtISf5O9LXgrs6MNrrKqwqfkZ5+pxylWwKEjMTJR
         RijdOuY37CRjBuPAEbH4X/Bbr8yRG3e5kmBWNcsbedyhA4VjLt8aqWN5fMqlwsn7Izg1
         IjBrldYe9r63B+nd0N4aOuNdygs7Y5zZrAUq0YJ75qZy0PAJFh/8ea/GmJHIKjuGxVpD
         t1RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uu6NC65X6R/bkJ3lkOXNxspINfAgK75MiSlc/snFhzo=;
        b=yssnAI8QsUOxQiK1Rr+uUe6p2PBEKmwXoH2a5CzBQU6xSmYK+YYJgLXEPQlgJq/iGW
         Lx0AisW+t11gUdn7Q3i/LzX1Qv4j/ey9obsqBh9ok9xLXrjVdY63Hdy0sWbjB8x08QWY
         P3kRPynklNAc6yCsHln/V1aeEeZmq7ecqYWOPCdcur1mZzp1Q/hQrTsdalesUzzTc4L2
         koB2h8fEKvy63iIiwrJBxelVF0dCceENboC0LJsb2vG2lvEEv04xMKG6mOsAdjRX+z4+
         zkOOi0ONRJchkGCcWCgqkPXTHRPLMW405ooyr3T4ppOfg5hegeJJJRKLUOpJJHeQN3UQ
         rlQw==
X-Gm-Message-State: ACrzQf1AmmAPbj46d4izoTqk7hO/jkLW4aOzbvVufIWJlclRJthgjRx9
        JGPR+Ld09/Wan2tebFAU8HH09MPzVa0=
X-Google-Smtp-Source: AMsMyM5vQHYHIPp3Fga39Z5BaslWR8ocWNLMTVqZkoxI4j9Erkwj+isi7XAofGvUfkcqn+/ZRwQV5Q==
X-Received: by 2002:a05:600c:13c9:b0:3cf:5b8f:a7cf with SMTP id e9-20020a05600c13c900b003cf5b8fa7cfmr15116109wmg.153.1667378327137;
        Wed, 02 Nov 2022 01:38:47 -0700 (PDT)
Received: from lavr.home ([2a02:168:f656:0:fdf3:b91d:7efa:f364])
        by smtp.gmail.com with ESMTPSA id x10-20020a05600c420a00b003b4fe03c881sm1161006wmh.48.2022.11.02.01.38.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 01:38:46 -0700 (PDT)
From:   Anton Protopopov <a.s.protopopov@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Anton Protopopov <a.s.protopopov@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2] iplink: fix accepting non-canonical ifxxx names
Date:   Wed,  2 Nov 2022 09:38:11 +0100
Message-Id: <20221102083811.3906521-1-a.s.protopopov@gmail.com>
X-Mailer: git-send-email 2.34.1
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

The ip link command is supposed to support names like if<index>, but at the
moment it fails like this:

  # ip link show dev if2
  RTNETLINK answers: No such device
  Cannot send link get request: No such device

This happens because the name 'if2' is used as an attribute in a RTM_GETLINK
message. Fix this by converting a given device name to the canonical name.

Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
---
 ip/ip_common.h | 2 +-
 ip/ipaddress.c | 3 ++-
 ip/iplink.c    | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/ip/ip_common.h b/ip/ip_common.h
index c4cb1bcb..9ca4905b 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -94,7 +94,7 @@ int do_mptcp(int argc, char **argv);
 int do_ioam6(int argc, char **argv);
 int do_ipstats(int argc, char **argv);
 
-int iplink_get(char *name, __u32 filt_mask);
+int iplink_get(const char *name, __u32 filt_mask);
 int iplink_ifla_xstats(int argc, char **argv);
 
 int ip_link_list(req_filter_fn_t filter_fn, struct nlmsg_chain *linfo);
diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 456545bb..1896d018 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -2109,7 +2109,7 @@ static int ipaddr_list_flush_or_save(int argc, char **argv, int action)
 	struct nlmsg_chain linfo = { NULL, NULL};
 	struct nlmsg_chain _ainfo = { NULL, NULL}, *ainfo = &_ainfo;
 	struct nlmsg_list *l;
-	char *filter_dev = NULL;
+	const char *filter_dev = NULL;
 	int no_link = 0;
 
 	ipaddr_reset_filter(oneline, 0);
@@ -2207,6 +2207,7 @@ static int ipaddr_list_flush_or_save(int argc, char **argv, int action)
 			fprintf(stderr, "Device \"%s\" does not exist.\n", filter_dev);
 			return -1;
 		}
+		filter_dev = ll_index_to_name(filter.ifindex);
 	}
 
 	if (action == IPADD_FLUSH)
diff --git a/ip/iplink.c b/ip/iplink.c
index 92ce6c47..13ee5afe 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -1137,7 +1137,7 @@ static int iplink_modify(int cmd, unsigned int flags, int argc, char **argv)
 	return 0;
 }
 
-int iplink_get(char *name, __u32 filt_mask)
+int iplink_get(const char *name, __u32 filt_mask)
 {
 	struct iplink_req req = {
 		.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct ifinfomsg)),
-- 
2.34.1
