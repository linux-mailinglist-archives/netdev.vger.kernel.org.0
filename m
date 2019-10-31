Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5CFEA921
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 03:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbfJaCKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 22:10:02 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:35666 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfJaCJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 22:09:40 -0400
Received: by mail-qt1-f196.google.com with SMTP id l3so6401998qtp.2;
        Wed, 30 Oct 2019 19:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4W9AYepQ0ExS+WuRGCTZkKX0WkDwZNV6f0NYXF3lfA4=;
        b=fTQUL8ldDYy7/7DQ++EenWXXcrkdo5WX2iU9NoTtViX2SucT8vFejJgUfNU1FMwwsG
         /mDOHWrDjT0A+8JDiBFF5ZI+lYM2C4/wEnnCglf5QJ4zsZieX563yQoRhwI6dgFh0MMe
         iEdY40hjBRqp4nYIhXucD7c3F9Sk/irtXR31Vxe9d9Qatw5pl8OgN6+9lbfcGbCiKGuC
         UNSgHMfUqGNp/HCX59yQ4lf6mjFHmblH5OKpHLWGHpBfm9ceI1JAhi23tvyXepu5E0ga
         1osorECsVm9f28AHzI2Ygmbdvyis63xqoD3vn+/QfArpdrRyFSONRT2JhIFIC0Mg3qnP
         d6kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4W9AYepQ0ExS+WuRGCTZkKX0WkDwZNV6f0NYXF3lfA4=;
        b=A+J8lebXLYUZzFreMADousS1fKiFdgdNKliYdlEeMv7wgZNJCv7n9ZrKtWBHVc/hDk
         JsFJcQV9uKJasJKLVxAlzgbg18FTE3NlSVMQkcualOvboJEswdBVAW/U+SzSkhRNAFAu
         lew59UywrkI89HMZOUxxOz3yYjD8XnDfYK9Q210BXW1AShjHphz5A0XfDZFDkc0TGIde
         ejs2jBoXvTsGXCJP32b67ye4xPkzzBEUvmOV4xRklezoN5QVPY5cVp3Az5FRaiJtHHCk
         bU9rXFsk+VItbUZ3Bm5EoxV8YPFHguINaqFRRH27/8CGq8+F0trLpw3OLf6bN6UtQHhb
         UrBQ==
X-Gm-Message-State: APjAAAXWPuhMRpu+lfItCcWEGV3UrevER7Ud9WfM5ooU7SUD/ySv//6E
        wxWGfteOBrO3puJZrY1KIMPpzxiJ
X-Google-Smtp-Source: APXvYqytX7IghU4vGYSNDLF/MA1ob/pVQx9txxsXnMuhjNULWbFtekuOgyjBYB5ziOHqrzu1ElBoIQ==
X-Received: by 2002:a0c:e8c5:: with SMTP id m5mr2374888qvo.183.1572487779276;
        Wed, 30 Oct 2019 19:09:39 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id f21sm1040966qte.36.2019.10.30.19.09.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2019 19:09:38 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 4/7] net: dsa: remove the dst->ds array
Date:   Wed, 30 Oct 2019 22:09:16 -0400
Message-Id: <20191031020919.139872-5-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191031020919.139872-1-vivien.didelot@gmail.com>
References: <20191031020919.139872-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the DSA ports are listed in the switch fabric, there is
no need to store the dsa_switch structures from the drivers in the
fabric anymore. So get rid of the dst->ds static array.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 include/net/dsa.h | 5 -----
 net/dsa/dsa2.c    | 7 -------
 2 files changed, 12 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index b46222adb5c2..e4c697b95c70 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -125,11 +125,6 @@ struct dsa_switch_tree {
 
 	/* List of DSA links composing the routing table */
 	struct list_head rtable;
-
-	/*
-	 * Data for the individual switch chips.
-	 */
-	struct dsa_switch	*ds[DSA_MAX_SWITCHES];
 };
 
 /* TC matchall action types, only mirroring for now */
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index a887231fff13..92e71b12b729 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -578,25 +578,18 @@ static void dsa_tree_remove_switch(struct dsa_switch_tree *dst,
 {
 	dsa_tree_teardown(dst);
 
-	dst->ds[index] = NULL;
 	dsa_tree_put(dst);
 }
 
 static int dsa_tree_add_switch(struct dsa_switch_tree *dst,
 			       struct dsa_switch *ds)
 {
-	unsigned int index = ds->index;
 	int err;
 
-	if (dst->ds[index])
-		return -EBUSY;
-
 	dsa_tree_get(dst);
-	dst->ds[index] = ds;
 
 	err = dsa_tree_setup(dst);
 	if (err) {
-		dst->ds[index] = NULL;
 		dsa_tree_put(dst);
 	}
 
-- 
2.23.0

