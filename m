Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97371318D8
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 03:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbfFABLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 21:11:30 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:38719 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726804AbfFABLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 21:11:30 -0400
Received: by mail-qk1-f201.google.com with SMTP id n190so9478632qkd.5
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 18:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=kMatYqsWfh/NDShd0i6o3IAyRx62oq7a69dO5OV+fXY=;
        b=thGc4UxPdcTYNlSjOxOix+Mw+qvA8Cjldh2lIu2TfLhmHuAkhsun9WYtp7h78fKnQZ
         1e2T4v1EeLstGSCSgpNGJjS5AFO7nCpTWAn65iTKXB69yrxi34E06Pz4UncYl01uz/20
         TIAxmwK6z4U6SqXh23MxLEzgXcckBejqncjlsjURrPzzLWrZxk8b1vA3ctpOLrmBR0cW
         bGGG4T42nGx1NkRHopguzcMC4MStdB0ayG9na945JrqwWBPgUmo/Y6vpuRv1O+XPWf5N
         exWPwBX1ndXFT/Pf3ICToNEMs0tpPhhnTtBAyu6Rq804V9Yhf0XyXybhS3SCeeUqp8Kx
         NQOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=kMatYqsWfh/NDShd0i6o3IAyRx62oq7a69dO5OV+fXY=;
        b=bJ/ZFMEqt8GtU0gJhL11dEKI/2ZZMyYROWn/wICr8SuvixOZPQF6AOo5iv9TcoM7oj
         nutd9TFw094aw1F7mrnbegmEPJ0ABnpZRWdzEBg4hn8Ihb84LYh7bmZP13hV6PO06oX4
         cs5CuXAry+Va5+Tsc+0v0Uk33/RqavoUaJtKe27rubPfyOXrCaL6kGUYXjG1F/mkBNlR
         bKOxSP+WSsgPoSBzFREtbMEJ+40fEt7C0jNx4mVIPXSiulKsJo2dNnz9SlxxaHSxycPO
         sCs+scr32jy1sOFjlLNjzS6JJKS5DJjQmoK/biI/30WgL5i+nQm9ALyz/fvcZX3NvgQI
         jqnw==
X-Gm-Message-State: APjAAAWHPaGCC8kSKkgkVnpZU2i571yfS8lhguZx2SgIPABiabTN8Uh5
        dJYXvp6o4FjjqqWw6K34CCkoF8iGwIzE1A==
X-Google-Smtp-Source: APXvYqwANn7Fy7BB4FjjdP5SjfMpzCjaWhI34IYfwDMAe3i0RG/7kU9WZ2ejeqYuAlvNl22nvTnyWA0M33Dbkw==
X-Received: by 2002:a0c:b5c5:: with SMTP id o5mr11880560qvf.6.1559351489621;
 Fri, 31 May 2019 18:11:29 -0700 (PDT)
Date:   Fri, 31 May 2019 18:11:25 -0700
Message-Id: <20190601011125.28388-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH net-next] ipv6: use this_cpu_read() in rt6_get_pcpu_route()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

this_cpu_read(*X) is faster than *this_cpu_ptr(X)

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/route.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index fada5a13bcb2a286bb20a350c1873b1b16dc866a..a72d01010cb6a734b2c4ee2dd865390d88e6a3b2 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1268,10 +1268,9 @@ static struct rt6_info *ip6_rt_pcpu_alloc(const struct fib6_result *res)
 /* It should be called with rcu_read_lock() acquired */
 static struct rt6_info *rt6_get_pcpu_route(const struct fib6_result *res)
 {
-	struct rt6_info *pcpu_rt, **p;
+	struct rt6_info *pcpu_rt;
 
-	p = this_cpu_ptr(res->nh->rt6i_pcpu);
-	pcpu_rt = *p;
+	pcpu_rt = this_cpu_read(*res->nh->rt6i_pcpu);
 
 	if (pcpu_rt)
 		ip6_hold_safe(NULL, &pcpu_rt);
-- 
2.22.0.rc1.257.g3120a18244-goog

