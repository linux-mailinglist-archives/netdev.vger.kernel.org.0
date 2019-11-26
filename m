Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1419B10A726
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 00:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfKZXgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 18:36:36 -0500
Received: from mail-yw1-f74.google.com ([209.85.161.74]:43878 "EHLO
        mail-yw1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbfKZXgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 18:36:36 -0500
Received: by mail-yw1-f74.google.com with SMTP id u83so10008374ywa.10
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 15:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Zm9/jmWxyezRzr+0cjPMmBrtXsDQkZdqZAqanFNVBxQ=;
        b=g60NPDEmG7PO/E7ly7ls+MouEUigmY/9BRE+t4pYSYimBEzoq26jLMFgaUfWIEpw7e
         qLYigJ4cdlBx//QE5QlAEVuUWvJWOFmgVprbpSuKlJSNILen2ltX1B8mms5qFyNpPDuG
         4qGL45Coave6IOWPRCRjq7jrwWT7tIelo5RWEvOPwK9EGr9ymn6fjeycjgQdfWggBOw6
         bJ5XzrRTdaebevKzrv9RbXWeT0YqS3d0ucwVT/LYnPzJsiADVnzLJUGxSnLkrEQu+uxl
         pBdpJCmsRDwAYxEK0n59MXVrvOY9KdxlM0DgJd1Rc2KcbsUbV8h+fIQvrHtENFAgA9iq
         gLrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Zm9/jmWxyezRzr+0cjPMmBrtXsDQkZdqZAqanFNVBxQ=;
        b=kBz57R/lr3DHtNxjBBfPSfx9mYmlWEFh244zpdvhVifq632vIM6GFkn64yRWZ5bJr7
         bQITwmgzr+n1qsEYGctOTffi8DizZvs3ashIFoap+4el6zwAImhlqVybDMqTmRKtcPBM
         CIyNQaZi0RoKYqyDr3T4mcLK0LERtANjuBkJ/V0hOx3GkNHk++2dUC3vwYDMPoCbUy2+
         oTHKHgO3ps3/82hwrI92DFhKqh+Ucpr5rDGidozBFHdUvB99pBfqTSYDD4Pfaa1YAASM
         8bhiVIiSt+EUXmsAf+D2OGmSSO1c7hVHQJ+V0/NljpuDg42TF7Hsdy9Ph526fqNpeR+K
         77Tw==
X-Gm-Message-State: APjAAAXEBd5oqOQjW6BEjAr5ATTWeReKTiBKRxiq4F3742iU+rRWcG6j
        zuOob7PWFxHnzVrc7XsfLRhE8+bjnIwrqA1Qofrz9xgchT31ZCBwX/Ah9UaCI6atnoGZeo9V7FW
        sz8ajt0OKU5A65Okml149tmhD7/3N2VqVnOeCJS3tgY0QX4iPEvNuWbDdGuem0hk4N5A=
X-Google-Smtp-Source: APXvYqzuSBFLPa8x7WaNi+D7lGqdyXPkpIFV0MXY29mYNtA/KotvbaSetdUWr5PkfBowOYnH2jNR+3EJXmTBvw==
X-Received: by 2002:a0d:cb90:: with SMTP id n138mr939038ywd.245.1574811394927;
 Tue, 26 Nov 2019 15:36:34 -0800 (PST)
Date:   Tue, 26 Nov 2019 15:36:19 -0800
Message-Id: <20191126233619.235892-1-jeroendb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH net] gve: Fix the queue page list allocated pages count
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     Jeroen de Borst <jeroendb@google.com>,
        Catherine Sullivan <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In gve_alloc_queue_page_list(), when a page allocation fails,
qpl->num_entries will be wrong.  In this case priv->num_registered_pages
can underflow in gve_free_queue_page_list(), causing subsequent calls
to gve_alloc_queue_page_list() to fail.

Fixes: f5cedc84a30d ("gve: Add transmit and receive support")
Signed-off-by: Jeroen de Borst <jeroendb@google.com>
Reviewed-by: Catherine Sullivan <csully@google.com>
---
 drivers/net/ethernet/google/gve/gve_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index aca95f64bde8..9b7a8db9860f 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -544,7 +544,7 @@ static int gve_alloc_queue_page_list(struct gve_priv *priv, u32 id,
 	}
 
 	qpl->id = id;
-	qpl->num_entries = pages;
+	qpl->num_entries = 0;
 	qpl->pages = kvzalloc(pages * sizeof(*qpl->pages), GFP_KERNEL);
 	/* caller handles clean up */
 	if (!qpl->pages)
@@ -562,6 +562,7 @@ static int gve_alloc_queue_page_list(struct gve_priv *priv, u32 id,
 		/* caller handles clean up */
 		if (err)
 			return -ENOMEM;
+		qpl->num_entries++;
 	}
 	priv->num_registered_pages += pages;
 
-- 
2.24.0.432.g9d3f5f5b63-goog

