Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B50E64770A
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 23:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbfFPVqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 17:46:05 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34228 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727196AbfFPVqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 17:46:05 -0400
Received: by mail-pl1-f196.google.com with SMTP id i2so3246351plt.1
        for <netdev@vger.kernel.org>; Sun, 16 Jun 2019 14:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mforney-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xuAup/1EhpOiwpfbawpm+C9Lyo833NNXTLyopgJkzUI=;
        b=Gimq4tYGJEFY43ucirVG5kgKLCCO/PsmiHnAuJiHkddLbiMVsGzmhNuQChDFh/dzkU
         p8DDCf2BSEGcQhMOigZTQssVHvQ2skiT74XTh+zPVst8+3AtFacno9wMTSYqvqKEigd8
         kM/CdLUqAqDXvwUG3uuP9hiqZrSSc+zz/b/rJJxulAQikmkevUStgkREiD9u1IBm5YZi
         VVyb17wXYadinD8fc5LTWvy9ZGIaXIsyVBnmkT3Ohe/eCa0afz/V1QEU7agrOiisYvvy
         HpF6ptfa7jGvynF2ICXsAv2g9+btw47jBKe4DaLZGafsqQj5QYSWHpK7rU7/YJJ0scXl
         dMag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xuAup/1EhpOiwpfbawpm+C9Lyo833NNXTLyopgJkzUI=;
        b=myXSJ5v2whXRaMqDX9SvXAh5YjaqdMcH1ZCQZdobFqGduU3PmRpStHGCjv5eqJQNX0
         LzMGsXoqWdOxIkB6cUZ9PFSlPo2uPSnDdeEhfkiOM3tjlAA7obiH5ePnbB1Tll/MrB6W
         zBQi/u9/RpkD0uBL90QZ8yd88+DZ9EYgv41xZOVG/Tz8+Fv5V9D8ecGGj0fpqO+jdacu
         PL/I0MA8qjh9cL2rBJLc6a9oY9btGQdWTb/YBJnAmrE87kb5rPCbBA/7Aq3XuYwJewZa
         48/5EbJK4tQHZD81S2WXB50pzhoMdBUocuSVh4GBso6T6UA3xcZMkUwz9IGpmWWc9JWR
         MbyQ==
X-Gm-Message-State: APjAAAXewf0HnwGtkARDOA5Q+uGYCl8OrFYObOR76dfvn5M8ngez88sI
        UQuEwxcuw1AvIziY+wEUPBIG0rvuV9GHFw==
X-Google-Smtp-Source: APXvYqy3rzJNMcZ3kYMBnVkt6E4OflfVi701j0AWvt8NVZM4Y34AnrVH+hHdrFD9IDtVDtz/+PjCOg==
X-Received: by 2002:a17:902:3103:: with SMTP id w3mr103215680plb.329.1560721564001;
        Sun, 16 Jun 2019 14:46:04 -0700 (PDT)
Received: from localhost ([2601:647:5180:35d7::cf52])
        by smtp.gmail.com with ESMTPSA id v126sm10748428pfb.81.2019.06.16.14.46.03
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 16 Jun 2019 14:46:03 -0700 (PDT)
From:   Michael Forney <mforney@mforney.org>
To:     netdev@vger.kernel.org
Subject: [PATCH] ipmroute: Prevent overlapping storage of `filter` global
Date:   Sun, 16 Jun 2019 14:46:02 -0700
Message-Id: <20190616214602.20546-1-mforney@mforney.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This variable has the same name as `struct xfrm_filter filter` in
ip/ipxfrm.c, but overrides that definition since `struct rtfilter`
is larger.

This is visible when built with -Wl,--warn-common in LDFLAGS:

	/usr/bin/ld: ipxfrm.o: warning: common of `filter' overridden by larger common from ipmroute.o

Signed-off-by: Michael Forney <mforney@mforney.org>
---
I'm not sure if this causes any problems in practice, but it seems
unintended.

 ip/ipmroute.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ip/ipmroute.c b/ip/ipmroute.c
index 8b3c4c25..656ea0dc 100644
--- a/ip/ipmroute.c
+++ b/ip/ipmroute.c
@@ -46,7 +46,7 @@ static void usage(void)
 	exit(-1);
 }
 
-struct rtfilter {
+static struct rtfilter {
 	int tb;
 	int af;
 	int iif;
-- 
2.20.1

