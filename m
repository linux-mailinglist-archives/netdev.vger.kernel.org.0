Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB04263CCC
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 22:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729759AbfGIUkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 16:40:55 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:36932 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728955AbfGIUkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 16:40:55 -0400
Received: by mail-wm1-f52.google.com with SMTP id f17so123286wme.2
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 13:40:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tgYDiYa1iHwsUkx7Cb70V+6OFnAyzBKXGNEbbq+IF0s=;
        b=VUFip7IDeZgswPuGxKB7SZpEmLjyJi9HxCyGTH2V+R0DGc2t1rrcFrmlhHybXGBJJu
         j77ooYpv0ePTbHGB6bE/NabSE0LfoKdyJSQdEZnwz3nqzN+cyYY5Rpa9K6XlXl9LU+qs
         +IOsmZOX3EaFeopoK/jeNaPKSCZVWS+mr5ob1YNs2F1gK7U53hqpC1KhL/MrBU3HjnEc
         0kFVWVTngutjn/g5qnNhhz7m9uKiKfdduhrF0YCOF04P8AgmrDSm9Xp1x4DDME5bSc+5
         bdmbyJnbcBbrLHQY1bMeZhGPUk08x1bFt2/9W82JmWhn0ff0UB0SuOhw0URxae3pl/iY
         H/yg==
X-Gm-Message-State: APjAAAW+pGUtL5kZBD63tG6p6eOC+a3SJ+uorukLQ8GDOMTymt0snxeR
        UkdII2a4dYL+BOY8g82thg8wllUWQ7Q=
X-Google-Smtp-Source: APXvYqz1hfiWWfAOd8XM5hA67Te4pogXX9TKf4A2PFl9BhBC99jbO0klRrFrvWHhJVFmQwEe+w15LA==
X-Received: by 2002:a7b:c144:: with SMTP id z4mr1452389wmi.50.1562704852819;
        Tue, 09 Jul 2019 13:40:52 -0700 (PDT)
Received: from raver.teknoraver.net (net-47-53-105-184.cust.vodafonedsl.it. [47.53.105.184])
        by smtp.gmail.com with ESMTPSA id l25sm66182wme.13.2019.07.09.13.40.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 13:40:52 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH iproute2] utils: don't match empty strings as prefixes
Date:   Tue,  9 Jul 2019 22:40:40 +0200
Message-Id: <20190709204040.17746-1-mcroce@redhat.com>
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
 lib/utils.c     | 14 +++++++++-----
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index 927fdc17..f4d12abb 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -198,7 +198,7 @@ int nodev(const char *dev);
 int check_ifname(const char *);
 int get_ifname(char *, const char *);
 const char *get_ifname_rta(int ifindex, const struct rtattr *rta);
-int matches(const char *arg, const char *pattern);
+int matches(const char *prefix, const char *string);
 int inet_addr_match(const inet_prefix *a, const inet_prefix *b, int bits);
 int inet_addr_match_rta(const inet_prefix *m, const struct rtattr *rta);
 
diff --git a/lib/utils.c b/lib/utils.c
index be0f11b0..73ce19bb 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -887,13 +887,17 @@ const char *get_ifname_rta(int ifindex, const struct rtattr *rta)
 	return name;
 }
 
-int matches(const char *cmd, const char *pattern)
+/* Check if 'prefix' is a non empty prefix of 'string' */
+int matches(const char *prefix, const char *string)
 {
-	int len = strlen(cmd);
+	if (!*prefix)
+		return 1;
+	while(*string && *prefix == *string) {
+		prefix++;
+		string++;
+	}
 
-	if (len > strlen(pattern))
-		return -1;
-	return memcmp(pattern, cmd, len);
+	return *prefix;
 }
 
 int inet_addr_match(const inet_prefix *a, const inet_prefix *b, int bits)
-- 
2.21.0

