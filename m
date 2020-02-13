Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5FDB15BBD4
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 10:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729657AbgBMJlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 04:41:10 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35564 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729440AbgBMJlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 04:41:10 -0500
Received: by mail-pg1-f195.google.com with SMTP id l24so2801506pgk.2
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 01:41:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UYBSdJjiTWbz6KORGSQjVnxNpSi7DvOkju4PbIxBdq4=;
        b=iiFqNo8M546tDEOhb6dao57zGSYkeAS8RP+JhVjf7pDHIrWd2OxhmZn+bHYYIcdTZa
         eSyRJY0TM67HIZaQc2rxN4UihXP2fatFtOrKs3l68RYQt2mK1Kq+AE0gOC4eUsA42Wck
         nokXSI9SUZNajnCY7lpHP8Pa2C/k5h876rCxFM1MjJNfcxwEXivQbQLZxDvV2ChMEhav
         gE35wIWKRDG9jGrX2rzMHW8Md7hmO+TT6XUnqNzT96fiYyhSW8RYsbujRE/KmPzSVw+t
         XYXKAmigsEVqHswKcRaQMwcyY+Vefptu0AjVLzoXSD6orwX0b9trM1dyZmm3Hes4Lv7Y
         gj+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UYBSdJjiTWbz6KORGSQjVnxNpSi7DvOkju4PbIxBdq4=;
        b=nTqkbtOqUJj9t1T30/IfwknlkuXUkYRx0OhzYi4TmfZL0sa1aC4VP+a/mJFGwY6h3/
         PqCA/nzQiEExaNffreuUta9HMuXWQvm9+U8inSD+Rs+ou9ndkFRYrlhdofU1llq2nJmX
         BYEF83nPVQBBoSyBCLS9BJkvn25NDJAGf2CIQOwqUOvLImTO7t0FtA+qZlMfIPC0kU9+
         +W7eLg00CDyy7oRTrtQWWKkqPLsnmhaI9bGSG+NZqIbRjqDg6U/8uJaPrC2B6CrR37Mz
         1/O7ldIhzYcORvaMbJE4jVGHjRWR944IZsMrERGQiVquy17CmT7rWwllZNwDs+v0PO7c
         aelg==
X-Gm-Message-State: APjAAAV+SQJcuHfT3SBA5rfMBgohYloMnbQksWF7grUDNjPExbQW7QxT
        47KiWI4IUnXhJNT9Dfdc5dWwMZbkLzw=
X-Google-Smtp-Source: APXvYqzMYafe0rfCjiGCI/zZbZBksUgU6wAyUnynHP4PQe6NmFb4btS7E8VAbCytzEsJ3C3XyDGTJw==
X-Received: by 2002:a62:1409:: with SMTP id 9mr16694621pfu.2.1581586869230;
        Thu, 13 Feb 2020 01:41:09 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y18sm2399161pfe.19.2020.02.13.01.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 01:41:08 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] selftests: forwarding: vxlan_bridge_1d: fix tos value
Date:   Thu, 13 Feb 2020 17:40:54 +0800
Message-Id: <20200213094054.27993-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 71130f29979c ("vxlan: fix tos value before xmit") we start
strict vxlan xmit tos value by RT_TOS(), which limits the tos value less
than 0x1E. With current value 0x40 the test will failed with "v1: Expected
to capture 10 packets, got 0". So let's choose a smaller tos value for
testing.

Fixes: d417ecf533fe ("selftests: forwarding: vxlan_bridge_1d: Add a TOS test")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh b/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh
index bb10e33690b2..353613fc1947 100755
--- a/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh
+++ b/tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh
@@ -516,9 +516,9 @@ test_tos()
 	RET=0
 
 	tc filter add dev v1 egress pref 77 prot ip \
-		flower ip_tos 0x40 action pass
-	vxlan_ping_test $h1 192.0.2.3 "-Q 0x40" v1 egress 77 10
-	vxlan_ping_test $h1 192.0.2.3 "-Q 0x30" v1 egress 77 0
+		flower ip_tos 0x11 action pass
+	vxlan_ping_test $h1 192.0.2.3 "-Q 0x11" v1 egress 77 10
+	vxlan_ping_test $h1 192.0.2.3 "-Q 0x12" v1 egress 77 0
 	tc filter del dev v1 egress pref 77 prot ip
 
 	log_test "VXLAN: envelope TOS inheritance"
-- 
2.19.2

