Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7981FF084E
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 22:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729830AbfKEV2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 16:28:36 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36286 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729680AbfKEV2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 16:28:35 -0500
Received: by mail-lj1-f194.google.com with SMTP id k15so11476524lja.3
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 13:28:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yIqh6a7xIaLExQJiR9UPkRDgJK4SNtkNQeIXNiu65K0=;
        b=BjTLd9znH9Z/vmYcLw5yRFgn8xFoAZ85Uw1pcVMGDVozmvDUTBPEhi5QgueHsVmldo
         +EXRNJFi6pbTTiU5NIZ1A61E4aaylxuNprIJu9rJ6pIU0sr8NpZUmHZT9+DuU3G/5eR/
         fVDRI/AxHka39j3zv+JdEuuzhYasFpgwwXoCKC/JSQHKvB1O8gzJyOZTELSAom4do8kz
         rWz3Ql+CK7qOaKQ0dda1aSVyItVE49+dJyZJfEZ9qLGmoJkTu/crH9aHEzVI9PC3rIzq
         O7wWH+czkGq8cQBYlVM9OFuyajiWtsjL00d7ItAx0WXFFeWX9f4qPBYMY2JUSw4hDsCZ
         fl5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yIqh6a7xIaLExQJiR9UPkRDgJK4SNtkNQeIXNiu65K0=;
        b=CEKCWAZXp6LUCnyleAW5wPZYM+b65efUT/0CQo9+6+HTd+KS9ysX0xJZggUawGjAlY
         e1vhLWwOl3on4KSRzYGqYdJqVavkCh4GyM3T66/tluwNRSqO03omsf2jsXiRcxO1FZBS
         5tXynVDiHRXfGYCyu9WndwDW48zcp77nZKV7f9lso2eiG9ZyfZmG9fgpfQo9qvcpC26A
         bWtqLhchQ8N4bgDqxTh9z7mtxWlZ4aFfb4tOviqDbisC6CXGdvr0JTD76qrRupgVSRZe
         B/jo1GS/PIq6DK5zoKz7ilzOr8iyEX1KuyQRiH781HfFdxnw5wAiynj2HUCvzQukPowq
         6Ajg==
X-Gm-Message-State: APjAAAVsy5+2/rChinZTHX644JlWzV0lWvHNmgHx7IiO1IhCpdCgIcTe
        K88V0tH/GghjNNeSnMu1rd6JYQ==
X-Google-Smtp-Source: APXvYqyfmTPah88rQwXySxMg0P2SHeMUgdAwAYw9+BSdv1yvOb9+wMhpNqNc4SIH4zphKIgMF9T4Cg==
X-Received: by 2002:a2e:9a08:: with SMTP id o8mr6557692lji.214.1572989313681;
        Tue, 05 Nov 2019 13:28:33 -0800 (PST)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id v15sm12274074lfd.36.2019.11.05.13.28.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 13:28:32 -0800 (PST)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        jiri@resnulli.us, Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next] selftests: devlink: undo changes at the end of resource_test
Date:   Tue,  5 Nov 2019 13:28:17 -0800
Message-Id: <20191105212817.11158-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The netdevsim object is reused by all the tests, but the resource
tests puts it into a broken state (failed reload in a different
namespace). Make sure it's fixed up at the end of that test
otherwise subsequent tests fail.

Fixes: b74c37fd35a2 ("selftests: netdevsim: add tests for devlink reload with resources")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 tools/testing/selftests/drivers/net/netdevsim/devlink.sh | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index ee89cd2f5bee..753c5b6abe0a 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -279,6 +279,12 @@ resource_test()
 	devlink -N testns1 dev reload $DL_HANDLE netns testns2
 	check_fail $? "Unexpected successful reload from netns \"testns1\" into netns \"testns2\""
 
+	devlink -N testns2 resource set $DL_HANDLE path IPv4/fib size ' -1'
+	check_err $? "Failed to reset IPv4/fib resource size"
+
+	devlink -N testns2 dev reload $DL_HANDLE netns 1
+	check_err $? "Failed to reload devlink back"
+
 	ip netns del testns2
 	ip netns del testns1
 
-- 
2.23.0

