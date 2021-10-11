Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3822E4286F9
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 08:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234295AbhJKGrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 02:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbhJKGri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 02:47:38 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EFE7C061570;
        Sun, 10 Oct 2021 23:45:39 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id pf6-20020a17090b1d8600b0019fa884ab85so13989203pjb.5;
        Sun, 10 Oct 2021 23:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z8Zu9yAyyO2bTaOv8lpg2v+LXFs7I8Nz3uHcl5OufP4=;
        b=EOXtYcSC45TdU1OvJs49IrRMdt6dgSLYoz1x01tMtXEjHNmckRRy7QBXbZ8lYM0nhV
         EtLTMEoOS/uIrd3F9YhKW34+7FCdA1rGkz+bSLni22btJd3lTl+mXKL/dH5dxlKRd2yv
         6IEKHPTzdT+pb0vFDcnKwQd+aBMFQm1neIdNkKWPqDhNNU9PglHEzQwvWz/8FCO4llZ0
         tM9+dqBwVdqD8qj6eay5nadrhzj0L8lfptloeqbEjdCJ3px2r5Q3xG+5zbJWFoLPoXOw
         /OIOooTIgyis7ScyxMomecgP+VcD6lTZN/Ctx+SfG3HTOrXrkKVL9fPSVOLk9SecNHGs
         4jHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z8Zu9yAyyO2bTaOv8lpg2v+LXFs7I8Nz3uHcl5OufP4=;
        b=peY9PSZqVrehY/bNGVBfiEGoc/IGDpV0bOMKtgrqgDhyeXbCJ5rSDRvMyJccCVHOFM
         Xy+LnIr/NB2YsTkTVT7O3SnzJGsW5XI/vYRAY0wtTM8rCAqhUWgPYQuWh8dSBDtzI3dm
         9vH6lEgPq3SylukMmUdTDCDNepvXWX2mkGF9MrxaJB1IYmQjbixA5S7P8U+ygjiq13kb
         fRrFGwvdszhjvWZYJRwtuZu+g2tmha/vS7X/Hm8bzpMIoo2rEqjruSAk1v6Biz9GQsvp
         EcdGAt4OHT4HBVJoTh4NkoSjLYrzdv1NOcTogCNuRZ5BKBq2fRCzhY0FT88CCNDGBrbu
         6hIw==
X-Gm-Message-State: AOAM530j5yoG05/CQEiDFDc4The7ZlfFx692ciX/fC4+XkpIObzOm7ri
        xga3nBXn5mWHlPdyny0YZlp/JdVEjKursA==
X-Google-Smtp-Source: ABdhPJy/WYf2E+ei4xSNFrSM0hFYlIPFebU3HE7DU4fHc0l1z03kp9TImjp8EXu8rclzv2ONrfGTLg==
X-Received: by 2002:a17:90b:1646:: with SMTP id il6mr27447129pjb.129.1633934738644;
        Sun, 10 Oct 2021 23:45:38 -0700 (PDT)
Received: from localhost ([23.129.64.212])
        by smtp.gmail.com with ESMTPSA id q10sm7017806pgn.31.2021.10.10.23.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 23:45:38 -0700 (PDT)
From:   =?UTF-8?q?J=CE=B5an=20Sacren?= <sakiwit@gmail.com>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     jlayton@kernel.org, davem@davemloft.net, kuba@kernel.org,
        ceph-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next] net: ceph: fix ->monmap and err initialization
Date:   Mon, 11 Oct 2021 00:45:24 -0600
Message-Id: <20211011064524.20003-1-sakiwit@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jean Sacren <sakiwit@gmail.com>

Call to build_initial_monmap() is one stone two birds.  Explicitly it
initializes err variable. Implicitly it initializes ->monmap via call to
kzalloc().  We should only declare err and ->monmap is taken care of by
ceph_monc_init() prototype.

Signed-off-by: Jean Sacren <sakiwit@gmail.com>
---
 net/ceph/mon_client.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index 013cbdb6cfe2..6a6898ee4049 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -1153,12 +1153,11 @@ static int build_initial_monmap(struct ceph_mon_client *monc)
 
 int ceph_monc_init(struct ceph_mon_client *monc, struct ceph_client *cl)
 {
-	int err = 0;
+	int err;
 
 	dout("init\n");
 	memset(monc, 0, sizeof(*monc));
 	monc->client = cl;
-	monc->monmap = NULL;
 	mutex_init(&monc->mutex);
 
 	err = build_initial_monmap(monc);
