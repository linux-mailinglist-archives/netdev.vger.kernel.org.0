Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 444416057A
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 13:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbfGELnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 07:43:55 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44254 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728093AbfGELnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 07:43:55 -0400
Received: by mail-ed1-f68.google.com with SMTP id k8so7974823edr.11
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 04:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6oFL8GERdlcAKtO6YkFSZSINNeoUGRbh56lm7IAVzdE=;
        b=k1NT0I+gvAS21HJ6aTI3hpCVcRcX7x22XGTtHsLh26rPjMtiEvTF0t6TpkwZKry1Bh
         x0UcuFfmD7gtgRUPzJOFKraMnJezJrwJddynpsBQuw5RBvnwIe/+g97A8Zn1YIIkIHQr
         10kKv8wWZM86xr7NgG4QiGTFuEOUmfjvsGxk9iCEJoPjoWWc///8SYWL6Sojk6WwyCeC
         SVt1QhaZhkgQZB0xhfGQzsMbHoG/3CFiAOqqnzhcSGJXy4m3L7GNAmA10XQkA/XD0obU
         3I+KvFRuLtjjsMmHrAncMobTt1URLqxvxiL8HXAevl8sMWPxl2Q2PMO9fpikSS00Gjbl
         dcvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6oFL8GERdlcAKtO6YkFSZSINNeoUGRbh56lm7IAVzdE=;
        b=CkTC1khOWt51TsW6OrYQFTCQHnYZB/r9rBnzjeHH00C+23j2APD675Wt1rv9AvhaKa
         /PGHZWkxhBTuFUTitHXMz358SN1U+BO3xMjhMF/98ls6f4lOzA1ByGiDiSVBlAJjksg+
         3AycCIxGJWD3zp7yG3U2mSzaCut1RUtW3oHYIE2JoTx9WbEKBhjFXK9LRCdSBKls0msU
         nO2h7LaGA306KNyD/OHekvJqUo6RO7RoOsmUNkp/Z/lhyOwXAszKOc7QzU19uIIKAaE8
         TaAgKsaf49Tbx7w3cfMyewtDKDE4AsmpH6dk+98pvyamJKMj0DOcUf5xZuQve1EP/NlL
         kB4g==
X-Gm-Message-State: APjAAAVU27tlOvSZP6nZJ4QrUMM1iLXHVW+1uzwmHCq7dK0oHvkUgq23
        P+fgNlVlbvS6rH6ckxu2iy8=
X-Google-Smtp-Source: APXvYqx+NFN6B1EN8YKYc5NL/tgi36I/ztwKOE5uvR8+ib5TMRcJ4p/SS3lfdGDhzTQNQqph3X9Ueg==
X-Received: by 2002:a17:906:d7ab:: with SMTP id pk11mr3089188ejb.216.1562327033549;
        Fri, 05 Jul 2019 04:43:53 -0700 (PDT)
Received: from localhost.localdomain (D96447CA.static.ziggozakelijk.nl. [217.100.71.202])
        by smtp.gmail.com with ESMTPSA id j16sm577722ejq.66.2019.07.05.04.43.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 05 Jul 2019 04:43:53 -0700 (PDT)
From:   Frank de Brabander <debrabander@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Frank de Brabander <debrabander@gmail.com>
Subject: [PATCH] selftests: txring_overwrite: fix incorrect test of mmap() return value
Date:   Fri,  5 Jul 2019 13:43:14 +0200
Message-Id: <1562326994-4569-1-git-send-email-debrabander@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If mmap() fails it returns MAP_FAILED, which is defined as ((void *) -1).
The current if-statement incorrectly tests if *ring is NULL.

Signed-off-by: Frank de Brabander <debrabander@gmail.com>
---
 tools/testing/selftests/net/txring_overwrite.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/txring_overwrite.c b/tools/testing/selftests/net/txring_overwrite.c
index fd8b1c6..7d9ea03 100644
--- a/tools/testing/selftests/net/txring_overwrite.c
+++ b/tools/testing/selftests/net/txring_overwrite.c
@@ -113,7 +113,7 @@ static int setup_tx(char **ring)
 
 	*ring = mmap(0, req.tp_block_size * req.tp_block_nr,
 		     PROT_READ | PROT_WRITE, MAP_SHARED, fdt, 0);
-	if (!*ring)
+	if (*ring == MAP_FAILED)
 		error(1, errno, "mmap");
 
 	return fdt;
-- 
2.7.4

