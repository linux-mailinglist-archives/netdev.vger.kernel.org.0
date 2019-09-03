Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8DEA6041
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 06:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfICEbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 00:31:47 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35591 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfICEbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 00:31:46 -0400
Received: by mail-wr1-f66.google.com with SMTP id g7so15867741wrx.2
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 21:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SlxdFZreg6ZSFm9H24vZrCDxZAhvL4kMZ84lzCWlexA=;
        b=nmOK+fVqeCwzcMapUQ0/OdsWb8uuZ8n+Gg+sqpxDzgB2wVQhzeSHcdvRMna8hMZKE0
         jptDHARG4YApGqGZL+zGuRicVGNbVYOZf4y7D6HySV4/fEvBncRB9mmBnlS9vp2qrSJR
         hV+qyV71uOtNOAV/3K/+ZYWXGNuYjjUFLd8ux4Nf+Ka2uH0OYD9rfuXmukTqEowL9jYG
         Rz5ro9t29eHJH69JDuxfNEmzdA6BtZYGqBHOiapTAadja4auoAKdB0NshR60XUJpE1GE
         VtNV7TBBliR365T7FJSuG8xG8Y9as/2rt/B4CqYBkEXpAjRi19Op6kZIRvalrTmTZ3+r
         MBDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SlxdFZreg6ZSFm9H24vZrCDxZAhvL4kMZ84lzCWlexA=;
        b=WVOfHX2TroVQ2xcFRrIBWzL3h64A6WBfmeUDDtEKIiA3lZ5Y9u2IQDAZ+MKeCyPtAT
         z1gclFv+P9jK+YJprKgfxFhrOa4bk8TkZstAgbQFdH9mW+37BdZBVfL9GaK/pSrOYWk7
         bUXKNDDTPeoJLhArrs5XAyCn7PZdNMhQMyk0uKAPYCImTRGbkizF99OkVjPqFSmDIroc
         0v3ETxfyUEbhGgbHXRIR4y6Uj6ZQVGh0eORz1wm+8xRHWjuEkbD77yuIW7mS7MXMCcnn
         Lop2Kd1/Q4uCznKb4AXY3Uf5ZjWw8fGRkJNNYFeBVhs4Wgsu21T3TbGLbfyx10aFwTMp
         N/ow==
X-Gm-Message-State: APjAAAXrGuDpJNnvZDpBub0kC+j4BMcosoWcqRW/PFLmY944d3GtUSxy
        MQh5frryDlUfG5xSUFAl8qJb3Q==
X-Google-Smtp-Source: APXvYqwXrPDLK4uyj/tAX3a/oafIaAi8S0q6zoC7KaSEZMaHxMecGbw/Vvph8wlpc9+Q62beu2kPjg==
X-Received: by 2002:adf:ecc7:: with SMTP id s7mr41839908wro.215.1567485104887;
        Mon, 02 Sep 2019 21:31:44 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id e13sm21024465wmh.44.2019.09.02.21.31.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Sep 2019 21:31:44 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Hurley <john.hurley@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 5/5] net/tls: dedup the record cleanup
Date:   Mon,  2 Sep 2019 21:31:06 -0700
Message-Id: <20190903043106.27570-6-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190903043106.27570-1-jakub.kicinski@netronome.com>
References: <20190903043106.27570-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If retransmit record hint fall into the cleanup window we will
free it by just walking the list. No need to duplicate the code.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 net/tls/tls_device.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 9e1bec1a0a28..41c106e45f01 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -159,12 +159,8 @@ static void tls_icsk_clean_acked(struct sock *sk, u32 acked_seq)
 
 	spin_lock_irqsave(&ctx->lock, flags);
 	info = ctx->retransmit_hint;
-	if (info && !before(acked_seq, info->end_seq)) {
+	if (info && !before(acked_seq, info->end_seq))
 		ctx->retransmit_hint = NULL;
-		list_del(&info->list);
-		destroy_record(info);
-		deleted_records++;
-	}
 
 	list_for_each_entry_safe(info, temp, &ctx->records_list, list) {
 		if (before(acked_seq, info->end_seq))
-- 
2.21.0

