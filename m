Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC2A2E3EF
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 19:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbfE2Ry0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 13:54:26 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45041 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbfE2Ry0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 13:54:26 -0400
Received: by mail-wr1-f65.google.com with SMTP id w13so2385146wru.11
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 10:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d9omZqxvYZccBG8+J+KgseNWCG3BJ1gx+XKJcewaAwM=;
        b=dsTu43qiFeJjrx15hXeFkxoTzs+Ro4nrBrOLUfRpklc2FynPwz5kv/uN9w4xkdhe14
         VtPuEyJOtcSwJjC0rBnGIieJ1yUT5AW53DBPZw0b/h5+RiLQ1JeRe7gkTeLzkKu1+/G5
         R1Vv6z7mjsBUuv4hNEEXlljyXYkrdEDiNWpro=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d9omZqxvYZccBG8+J+KgseNWCG3BJ1gx+XKJcewaAwM=;
        b=r4mnn/Z9XXC51MKzJgrtGSJwHcFJd6uTeNmQKEOn0tIRphxFjkzpuooMmtYXf7PFr0
         VQNje3Exgnt7kNZ/woMP3ZgP9analf+F9DnRcClLqXRiyF5Z5glPH9ALYYFwcMxOB169
         6NSEgApPWaj/GJJ6u05x1fHs5GdrdC6g5Z2AjaqguVtTprcYiuO2IeQkgkqWxbyb2nGC
         Ty11X+eAju8zJ6zgmb9kKvHksJVNbmxHcIlp5B7OXYLx70e6JYql+8k1r+fWppqbSXNL
         HWw8ZsaqPLhD3HI3AucBPhwVdP05LkauGBdavAGVl8QHO05oYRszpt6CuPV8UBRiO9QE
         hvkg==
X-Gm-Message-State: APjAAAXpUDiBuxynbILEWdtwj/aHw1W5Y1hbGiWT1kKt9bm/b8NK4Wy4
        NnTBkO05GDPlvPhTL03ZlSpacxxxBKc/hA==
X-Google-Smtp-Source: APXvYqx6KLj+zbGmP97yvyRogoWbF2Oog9ah4ImyqMqXDz2YRUKItIToUTm4vlW5o97lgJ2YPjlgpQ==
X-Received: by 2002:a5d:4104:: with SMTP id l4mr5843593wrp.302.1559152464098;
        Wed, 29 May 2019 10:54:24 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x21sm8789791wmi.1.2019.05.29.10.54.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 May 2019 10:54:23 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, stephen@networkplumber.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH iproute2] bridge: mdb: restore text output format
Date:   Wed, 29 May 2019 20:52:42 +0300
Message-Id: <20190529175242.20919-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While I fixed the mdb json output, I did overlook the text output.
This patch returns the original text output format:
 dev <bridge> port <port> grp <mcast group> <temp|permanent> <flags> <timer>
Example (old format, restored by this patch):
 dev br0 port eth8 grp 239.1.1.11 temp

Example (changed format after the commit below):
 23: br0  eth8  239.1.1.11  temp

We had some reports of failing scripts which were parsing the output.
Also the old format matches the bridge mdb command syntax which makes
it easier to build commands out of the output.

Fixes: c7c1a1ef51ae ("bridge: colorize output and use JSON print library")
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
I know text output isn't considered API, but there are scripts out there
which rely on the format or at least on the old strings/values to be
present.

 bridge/mdb.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/bridge/mdb.c b/bridge/mdb.c
index 59aa17643517..eadc6212af70 100644
--- a/bridge/mdb.c
+++ b/bridge/mdb.c
@@ -132,21 +132,21 @@ static void print_mdb_entry(FILE *f, int ifindex, const struct br_mdb_entry *e,
 
 	open_json_object(NULL);
 
-	print_int(PRINT_ANY, "index", "%u: ", ifindex);
-	print_color_string(PRINT_ANY, COLOR_IFNAME, "dev", "%s ", dev);
-	print_string(PRINT_ANY, "port", " %s ",
+	print_int(PRINT_JSON, "index", NULL, ifindex);
+	print_color_string(PRINT_ANY, COLOR_IFNAME, "dev", "dev %s", dev);
+	print_string(PRINT_ANY, "port", " port %s",
 		     ll_index_to_name(e->ifindex));
 
 	print_color_string(PRINT_ANY, ifa_family_color(af),
-			    "grp", " %s ",
+			    "grp", " grp %s",
 			    inet_ntop(af, src, abuf, sizeof(abuf)));
 
-	print_string(PRINT_ANY, "state", " %s ",
+	print_string(PRINT_ANY, "state", " %s",
 			   (e->state & MDB_PERMANENT) ? "permanent" : "temp");
 
 	open_json_array(PRINT_JSON, "flags");
 	if (e->flags & MDB_FLAGS_OFFLOAD)
-		print_string(PRINT_ANY, NULL, "%s ", "offload");
+		print_string(PRINT_ANY, NULL, " %s", "offload");
 	close_json_array(PRINT_JSON, NULL);
 
 	if (e->vid)
-- 
2.20.1

