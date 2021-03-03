Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A3B32C44A
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389282AbhCDAMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:12:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25866 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229882AbhCCMcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 07:32:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614774633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=AXs5BWCOM7tJTqZoKR72X7B/yOW+vkvZvtXiJJo6gYo=;
        b=R4dZdyPa3jii6lC1hMybCFVXBVgkpxTXMxt0ly8nbvs7h10D9jdSaaiwqhqgA0lb6aY/vz
        IMlamKTDal7lU/CJStlhgh2yzAGs80pecRmh7HFPbd2V3ecZWxOta4mV4tuoqZ7MWVBWfD
        VWdtdFHqQvoVi4UcnO8/ARp7+fnC0HU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70--V-Ymb4tME-pjBiDNDCxPQ-1; Wed, 03 Mar 2021 07:30:32 -0500
X-MC-Unique: -V-Ymb4tME-pjBiDNDCxPQ-1
Received: by mail-ed1-f72.google.com with SMTP id cq11so5793051edb.14
        for <netdev@vger.kernel.org>; Wed, 03 Mar 2021 04:30:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AXs5BWCOM7tJTqZoKR72X7B/yOW+vkvZvtXiJJo6gYo=;
        b=OdmrgmwBcTnv7vQp5dDmBrPCX5LjbuZDNdhFADzoB9CGUOHb0ELeC15+ClYTM81R4N
         W8DrompjVmhu8pMkm+xNCnZsNVn86UJNljGtvlztcVlckgSzyTa/hENg3AxoEpXsr01c
         nxTdrzZBtpIFFtRZxFtZR+6MhuWLITu8sw7Tp1BSCOgLyn3W0ecwX1ewaa5hMGdDx9h6
         k3ADSBCHqUD/u2FsJ5vfgBNtBLLVjS73bts1AjE/V81tcwsoUnHlZFrgq82ozEi8DM3j
         xfEeTSIT0NhOuZZm9vpgWFl73jZbIDYFQmyvKCwTpFBWLhJNO4js2EZufWkr5rCtWcJ+
         SHzA==
X-Gm-Message-State: AOAM533FS8ueeeQEx54aypwcwhlA28dc4t8gHX4c+Eji/4NNbY0DmD34
        lrrO+n/BBSSfQhgdaJGVAZT9CuEyDhaB4oxqhLXPMOKaPydMs3BFqC8gxAM64COR98sCi9i0eCP
        7+Pytk2SZg+v4vGw/
X-Received: by 2002:a50:cdd1:: with SMTP id h17mr12012976edj.178.1614774630847;
        Wed, 03 Mar 2021 04:30:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxB26sbAfYexVPKjB50LwAcMNNI47mVChs8bfrTNJfSj27rMWVbsRtnPafnWn/6DQiEyTN+xg==
X-Received: by 2002:a50:cdd1:: with SMTP id h17mr12012959edj.178.1614774630658;
        Wed, 03 Mar 2021 04:30:30 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id r24sm14936583edw.11.2021.03.03.04.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 04:30:29 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 47FB81801A5; Wed,  3 Mar 2021 13:30:28 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH iproute2] q_cake: Fix incorrect printing of signed values in class statistics
Date:   Wed,  3 Mar 2021 13:30:18 +0100
Message-Id: <20210303123018.12800-1-toke@redhat.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The deficit returned from the kernel is signed, but was printed with a %u
specifier in the format string, leading to negative values to be printed as
high unsigned values instead. In addition, we passed a negative value to
sprint_time() even though that expects an unsigned value. Fix this by
changing the format specifier and reversing the sign of negative time
values.

Fixes: 714444c0cb26 ("Add support for CAKE qdisc")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tc/q_cake.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tc/q_cake.c b/tc/q_cake.c
index b7da731b5510..4ff6056a1ab0 100644
--- a/tc/q_cake.c
+++ b/tc/q_cake.c
@@ -675,7 +675,7 @@ static int cake_print_xstats(struct qdisc_util *qu, FILE *f,
 
 	/* class stats */
 	if (st[TCA_CAKE_STATS_DEFICIT])
-		print_int(PRINT_ANY, "deficit", "  deficit %u",
+		print_int(PRINT_ANY, "deficit", "  deficit %d",
 			  GET_STAT_S32(DEFICIT));
 	if (st[TCA_CAKE_STATS_COBALT_COUNT])
 		print_uint(PRINT_ANY, "count", " count %u",
@@ -688,7 +688,7 @@ static int cake_print_xstats(struct qdisc_util *qu, FILE *f,
 
 			if (drop_next < 0) {
 				print_string(PRINT_FP, NULL, " drop_next -%s",
-					sprint_time(drop_next, b1));
+					sprint_time(-drop_next, b1));
 			} else {
 				print_uint(PRINT_JSON, "drop_next", NULL,
 					drop_next);
-- 
2.30.1

