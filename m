Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5010ED9631
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 18:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406047AbfJPQBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 12:01:04 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38257 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405922AbfJPQBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 12:01:04 -0400
Received: by mail-pg1-f193.google.com with SMTP id w3so7637861pgt.5
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 09:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wEBLDHxTnHQ/yX6EshaxklIy3lcb6EqE4ZMzaD3LweE=;
        b=MXIZmDbn2JtlnlR5Cw9+ob1Ogzn6+7iN3f/+zk8/t2AnkvSwJDVnL0mDmj87tD5COV
         1lJjdnPqBekCx/+5WsxliaJTOikbrNohauygw/+0IHsxsPOgLPtDTiiK+mz3VjnBm7hS
         HjQpghri+L61QFr6aBTL9Y0OOhHRTTMFa/v6XQRhzLCeY8W4yhtobBf+eyWSWqqc7Nfz
         J4D5FXw4w9MxdkZgeH+yV8SU/woaIJ+NwOTuvKk+kLE7Hyo3Sv3IXFHiWBFgGTOOJawa
         KzyBha6cp4g7HJEeF2zY2eD+NumOOXO9f/VPLj7BIBi+8+9Li8olb6SU47xE+vzdsfMF
         wn1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wEBLDHxTnHQ/yX6EshaxklIy3lcb6EqE4ZMzaD3LweE=;
        b=K/Q0y4ofz5RdAmj4h+Jyr7wCCe7YsJmfWA2m33o8dh220wVGIlR1GVh+EkZXKRPoaT
         8/VvoMpyQFtJmy7CdyBwXVIWxtOb420g0fX3iyXrpI501GOXCS/qDOvU4ZCVwL3ECWrn
         2ET14PXBv4jinrRCy8+6t4lZG+OL6NS2ZkgDP0ghgmmlT0YESb2yxVA4VqDI2SZnvihq
         oE97OrtdRsfmj3BLjIgooBF0yNQ2iHBmYe1Rq5FzXJaJXt+zsMVy84Zeg+7Jx46Tlo7+
         g718yOTInXm9rU0YO6ebi/BFX2EAQjnmdS0m0J300S8OBwvgin9VYzPlyJTArV+tCbmz
         Vw9A==
X-Gm-Message-State: APjAAAUGsQp9KeXkIwUUaeFB/VZT9rI+rdumF3IOdqIobpguV0O8fgTV
        Fyk5/5WKnbWXgivbn3A70TlMyw==
X-Google-Smtp-Source: APXvYqx2308pXawlvfXxlYpaQ8Aq88Plka7lHJc0BK1t4VRVm2r225tTCkiaW+l9l//WcGrQpMJlEw==
X-Received: by 2002:a63:6246:: with SMTP id w67mr19826651pgb.27.1571241663211;
        Wed, 16 Oct 2019 09:01:03 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id q76sm57042342pfc.86.2019.10.16.09.01.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 09:01:02 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        stephen@networkplumber.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        kbuild test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net] net: netem: fix error path for corrupted GSO frames
Date:   Wed, 16 Oct 2019 09:00:50 -0700
Message-Id: <20191016160050.27703-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To corrupt a GSO frame we first perform segmentation.  We then
proceed using the first segment instead of the full GSO skb and
requeue the rest of the segments as separate packets.

If there are any issues with processing the first segment we
still want to process the rest, therefore we jump to the
finish_segs label.

Commit 177b8007463c ("net: netem: fix backlog accounting for
corrupted GSO frames") started using the pointer to the first
segment in the "rest of segments processing", but as mentioned
above the first segment may had already been freed at this point.

Backlog corrections for parent qdiscs have to be adjusted.
Note that if segmentation ever produced a single-skb list
the backlog calculation will not take place (segs == NULL)
but that should hopefully never happen..

Fixes: 177b8007463c ("net: netem: fix backlog accounting for corrupted GSO frames")
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 net/sched/sch_netem.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 0e44039e729c..31a6afd035b2 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -509,6 +509,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		if (skb->ip_summed == CHECKSUM_PARTIAL &&
 		    skb_checksum_help(skb)) {
 			qdisc_drop(skb, sch, to_free);
+			skb = NULL;
 			goto finish_segs;
 		}
 
@@ -595,7 +596,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		unsigned int len, last_len;
 		int nb = 0;
 
-		len = skb->len;
+		len = skb ? skb->len : 0;
 
 		while (segs) {
 			skb2 = segs->next;
@@ -612,7 +613,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			}
 			segs = skb2;
 		}
-		qdisc_tree_reduce_backlog(sch, -nb, prev_len - len);
+		qdisc_tree_reduce_backlog(sch, !skb - nb, prev_len - len);
 	}
 	return NET_XMIT_SUCCESS;
 }
-- 
2.23.0

