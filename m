Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2987F716E9
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 13:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389291AbfGWLZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 07:25:42 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39656 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbfGWLZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 07:25:42 -0400
Received: by mail-wr1-f65.google.com with SMTP id x4so42729822wrt.6
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 04:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gKAcD0uZFJGzX5Kk50HgpDKksB9fFhMmZ/6Pi/L9r0w=;
        b=Mznj5u61Rem+fMWjwMaO4Z6ueKUVMu6nhnWw0tdiBhndKNV7mdyCYqMvFhMmnrZCkm
         Ubacgm/daADfq5w5fGh5BiraN/9FLpi/CaHPlN2eAFf37X1NVPTiloYIDIYMWg5sLttE
         sFOlN4LbJN2rpofEK6z10QIrmaotz+9jGcOQF2nr0vx8RPzdIQKirJSmbkFB5+PlmfH4
         muI7s46LNG7iR+dUbTHPcgCfQupYVdpuq1zlFro2qDdMYFNaSUorqcGRbaDuAfqfJON0
         uuWB8Eib6ojehNc/qL+BLyXjWqonpY0yfhMg6uTYnwKpR72nJ/Opt50/r8yD1vHmmXZc
         qW5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gKAcD0uZFJGzX5Kk50HgpDKksB9fFhMmZ/6Pi/L9r0w=;
        b=QBJl4Z0ehf10SR5n0EvTH0jE/zQQ6opuY+HVCgK32OCPV40TkJEnE/DfbAmuaDOWcn
         2dbZYWDPKVUXUTFV9g8v4ZHae5QHn3/ky9wqmrw+Lw69Lfz9imwGEMQk4yU+kFaD5qGl
         ZayiDREy6mKDNXv5DdF0FR6keMwcdRs9jiAE63k5nVFrmlFl7ppTa4pMstzd9aKnhgwb
         jDIY373u8B2Q6n5uaHypmAGD7DT7CbwSRrAVeeO8kpAbDT+Y9dHF3DQGfexxX5XsKT6l
         8FLrZrQU2s6uC8N9slLip07OY0edphpCdmfkymUD3oK4B8A5C2N3zui85NCIWFwEDbkz
         kNhA==
X-Gm-Message-State: APjAAAW38BRpxIBu0FNGh7ge8WSIpdYfzXFtzkf4slb3Zrwk70DsaUR9
        7NpRuOItOn/9wyuGpAv6IVGGW6jU
X-Google-Smtp-Source: APXvYqwjFa9qfs+b9/9CT3u8Tl5E/r2zIRO4tASF148FkC7f57FfMGVmUzom3nZsbf+RyCvjUVxj8w==
X-Received: by 2002:a5d:46cf:: with SMTP id g15mr83938134wrs.93.1563881140276;
        Tue, 23 Jul 2019 04:25:40 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id x20sm32272285wmc.1.2019.07.23.04.25.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 04:25:40 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     sthemmin@microsoft.com, dsahern@gmail.com, alexanderk@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch iproute2 1/2] tc: action: fix crash caused by incorrect *argv check
Date:   Tue, 23 Jul 2019 13:25:37 +0200
Message-Id: <20190723112538.10977-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

One cannot depend on *argv being null in case of no arg is left on the
command line. For example in batch mode, this is not always true. Check
argc instead to prevent crash.

Reported-by: Alex Kushnarov <alexanderk@mellanox.com>
Fixes: fd8b3d2c1b9b ("actions: Add support for user cookies")
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 tc/m_action.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tc/m_action.c b/tc/m_action.c
index ab6bc0ad28ff..0f9c3a27795d 100644
--- a/tc/m_action.c
+++ b/tc/m_action.c
@@ -222,7 +222,7 @@ done0:
 				goto bad_val;
 			}
 
-			if (*argv && strcmp(*argv, "cookie") == 0) {
+			if (argc && strcmp(*argv, "cookie") == 0) {
 				size_t slen;
 
 				NEXT_ARG();
-- 
2.21.0

