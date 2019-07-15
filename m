Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93B6169A6E
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 20:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730438AbfGOSEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 14:04:36 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:54737 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729579AbfGOSEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 14:04:36 -0400
Received: by mail-wm1-f43.google.com with SMTP id p74so16085586wme.4
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 11:04:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SBbMCXUpPmTfVt8rUB8UQRv/cIS5kMaSpm/R3jHvK+Q=;
        b=FQrQf5nOUrVz8F4ebGosy6qfiLsYztnldG8G5o7NWZXAMn7M5OjqTJmu0TPniZIiZY
         NFzjvesMr9X+Jq/j197PEAMSTojl/tSObi7NKpz1QZGD05rRD7y9qKmd8Jndb0rXqeOE
         +D0DaiLY4YFnwp+qL9Ofsta/TAnM0BYTLbGnZKQkd9vq6CWhnK7173MBlicxiXmHHEVm
         tUQ9x92EgUY01ChrCCvEjmx7L80aSMkw8Uf5ohEaeBvmOcZc0na3QVyGPZTKGevHH1qJ
         Yh/SQo0Ttij7EZ7kRGmGjtdUboi68NEKLbF27B2/0zqRte0CEcwbdF/7148PaUATRRXl
         b5AQ==
X-Gm-Message-State: APjAAAW3unr0uWllFIkT462YtRaH6g9KlU4TX7acLp61GzYL4HcKXpSb
        gsAYD2QTTQ9ZVdmgVFzsAsi68CIJk3c=
X-Google-Smtp-Source: APXvYqz+2nS9qcw9d1VukBPAp7GVezGQGsSxpcQwgqSJNY3UpJ6raezp5Xh0fcnoeJvcwn/QpBlbyQ==
X-Received: by 2002:a7b:c247:: with SMTP id b7mr26785241wmj.13.1563213874307;
        Mon, 15 Jul 2019 11:04:34 -0700 (PDT)
Received: from raver.teknoraver.net (net-5-94-7-138.cust.vodafonedsl.it. [5.94.7.138])
        by smtp.gmail.com with ESMTPSA id h133sm18296852wme.28.2019.07.15.11.04.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 11:04:33 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>
Subject: [PATCH iproute2 v2] utils: don't match empty strings as prefixes
Date:   Mon, 15 Jul 2019 20:04:30 +0200
Message-Id: <20190715180430.19902-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

iproute has an utility function which checks if a string is a prefix for
another one, to allow use of abbreviated commands, e.g. 'addr' or 'a'
instead of 'address'.

This routine unfortunately considers an empty string as prefix
of any pattern, leading to undefined behaviour when an empty
argument is passed to ip:

    # ip ''
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
           valid_lft forever preferred_lft forever
        inet6 ::1/128 scope host
           valid_lft forever preferred_lft forever

    # tc ''
    qdisc noqueue 0: dev lo root refcnt 2

    # ip address add 192.0.2.0/24 '' 198.51.100.1 dev dummy0
    # ip addr show dev dummy0
    6: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 1000
        link/ether 02:9d:5e:e9:3f:c0 brd ff:ff:ff:ff:ff:ff
        inet 192.0.2.0/24 brd 198.51.100.1 scope global dummy0
           valid_lft forever preferred_lft forever

Rewrite matches() so it takes care of an empty input, and doesn't
scan the input strings three times: the actual implementation
does 2 strlen and a memcpy to accomplish the same task.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 include/utils.h |  2 +-
 lib/utils.c     | 15 ++++++++++-----
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index 1d9c1127..794d3605 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -198,7 +198,7 @@ int nodev(const char *dev);
 int check_ifname(const char *);
 int get_ifname(char *, const char *);
 const char *get_ifname_rta(int ifindex, const struct rtattr *rta);
-int matches(const char *arg, const char *pattern);
+bool matches(const char *prefix, const char *string);
 int inet_addr_match(const inet_prefix *a, const inet_prefix *b, int bits);
 int inet_addr_match_rta(const inet_prefix *m, const struct rtattr *rta);
 
diff --git a/lib/utils.c b/lib/utils.c
index 5da9a478..9ea21fa1 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -871,13 +871,18 @@ const char *get_ifname_rta(int ifindex, const struct rtattr *rta)
 	return name;
 }
 
-int matches(const char *cmd, const char *pattern)
+/* Returns false if 'prefix' is a not empty prefix of 'string'.
+ */
+bool matches(const char *prefix, const char *string)
 {
-	int len = strlen(cmd);
+	if (!*prefix)
+		return true;
+	while (*string && *prefix == *string) {
+		prefix++;
+		string++;
+	}
 
-	if (len > strlen(pattern))
-		return -1;
-	return memcmp(pattern, cmd, len);
+	return !!*prefix;
 }
 
 int inet_addr_match(const inet_prefix *a, const inet_prefix *b, int bits)
-- 
2.21.0

