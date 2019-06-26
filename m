Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C34F5713E
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 21:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfFZTEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 15:04:07 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:45334 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbfFZTEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 15:04:07 -0400
Received: by mail-io1-f68.google.com with SMTP id e3so7385175ioc.12
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 12:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=//1CVgRKm65AhdpMNa3V8tChe63DkIiQZbc9VQZOP60=;
        b=l5MzgbGQhbV+T+5DA6vZ5UKjM3G73iUWsjARsHoFv0kTLhHnyef8JC5Fdr3s8jnciR
         du/8BXAHXRUfhfwAgZFFTkpzKqbmgxQRJnwVcUbRWexnePXTzmigHo0XOr1zDrLeFFeV
         EN8tL9nRbiwZ0gGeoVOFvWesQZ7U54z0zNnAv3U0ZU9fvBLtvDgk/RUbkmu/Fnxa5plp
         cVGq3sev/gd1K+MDRmjNX2esY9oa0oNfjlgz6ZFL1STUqBu5zPJenoCmVPLqoaVz+iXl
         kN3lRA0Pv9yf97ufury2JsNDcPXowVa2J/7LThrlEhhYXZCcGrQMVoVd1FMe5o0rOPS/
         sSsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=//1CVgRKm65AhdpMNa3V8tChe63DkIiQZbc9VQZOP60=;
        b=fkCl4Cqe+59NK+vCbRDwDrB9Y/7qDY7tRwvnjjTCsNpYkKrkC3QdYC45uArPkok/sc
         Hb+kBgR3yWSX0IXs4aNVY4F1Rnz8/K+w6u4l+HiVet/FYIEs27y5ri2JADyfW6j9VaU5
         T+jDr+GVgKlMPdWTIOILotBsiARS2ci0+CcPBhVxUOwSDXchMzDXwFOimIvuJmO4MjMH
         5wyZ/Mv74+BmeuxdtG/3laIJ6Zx313TGBctn+Wxy6rIvAoh1vxbMZgvnDefjuhnt8+it
         1fTcLu7ulJk9X41eD8+X/l/JkBV5bN+0gFvzU3NrKLjBXkfD5d+W0XLEaJ2ONTw9YtH4
         c0aQ==
X-Gm-Message-State: APjAAAWaq+EzgMhYSxwWkUjpQYK5a9qcC2PrnKuZ8HNpl3COYtz2i3EN
        +ppwzcrZsjXiL4Qwjtf+rQkwpfjBFb0=
X-Google-Smtp-Source: APXvYqyOLQT/lddowAjBJYt/5WFdvfh/Nxi58WI31yVJ2VyL4C13n8WOtVnTXfiWnOi4/HMI0dBfAQ==
X-Received: by 2002:a02:b914:: with SMTP id v20mr6606649jan.83.1561575846191;
        Wed, 26 Jun 2019 12:04:06 -0700 (PDT)
Received: from x220t.lan ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id k5sm18446041ioj.47.2019.06.26.12.04.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 12:04:05 -0700 (PDT)
From:   Alexander Aring <aring@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, kernel@mojatatu.com,
        Alexander Aring <aring@mojatatu.com>
Subject: [RFC iproute2 1/1] ip: netns: add mounted state file for each netns
Date:   Wed, 26 Jun 2019 15:03:43 -0400
Message-Id: <20190626190343.22031-2-aring@mojatatu.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190626190343.22031-1-aring@mojatatu.com>
References: <20190626190343.22031-1-aring@mojatatu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a state file for each generated namespace to ensure the
namespace is mounted. There exists no way to tell another programm that
the namespace is mounted when iproute is creating one. An example
application would be an inotify watcher to use the generated namespace
when it's discovers one. In this case we cannot use the generated
namespace file in /var/run/netns in the time when it's not mounted yet.
A primitiv approach is to generate another file after the mount
systemcall was done. In my case inotify waits until the mount statefile
is generated to be sure that iproute2 did a mount bind.

Signed-off-by: Alexander Aring <aring@mojatatu.com>
---
 ip/ipnetns.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/ip/ipnetns.c b/ip/ipnetns.c
index a883f210..339a9ffc 100644
--- a/ip/ipnetns.c
+++ b/ip/ipnetns.c
@@ -606,6 +606,13 @@ static int on_netns_del(char *nsname, void *arg)
 			netns_path, strerror(errno));
 		return -1;
 	}
+	snprintf(netns_path, sizeof(netns_path), "%s/%s.mounted",
+		 NETNS_RUN_DIR, nsname);
+	if (unlink(netns_path) < 0) {
+		fprintf(stderr, "Cannot remove namespace file \"%s\": %s\n",
+			netns_path, strerror(errno));
+		return -1;
+	}
 	return 0;
 }
 
@@ -758,6 +765,15 @@ static int netns_add(int argc, char **argv, bool create)
 	}
 	netns_restore();
 
+	snprintf(netns_path, sizeof(netns_path), "%s/%s.mounted", NETNS_RUN_DIR, name);
+	fd = open(netns_path, O_RDONLY|O_CREAT|O_EXCL, 0);
+	if (fd < 0) {
+		fprintf(stderr, "Cannot create namespace file \"%s\": %s\n",
+			netns_path, strerror(errno));
+		goto out_delete;
+	}
+	close(fd);
+
 	return 0;
 out_delete:
 	if (create) {
-- 
2.11.0

