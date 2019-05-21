Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEB624F7E
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 14:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbfEUM7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 08:59:52 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53328 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbfEUM7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 08:59:52 -0400
Received: by mail-wm1-f66.google.com with SMTP id 198so2900916wme.3
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 05:59:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PslXDngNuE7q+1VpAQcWwQGeQKB+6MQNfpmE6oTyQ18=;
        b=AjgoYxF0wMuZBdxlKZ2heDLdfTcONX/kpq891dsj19u8nEysnAUHIsr6SjGz2Vw0p4
         gD8o/SntcGx2ksece/Zc10Q3UJ6afsFIR132cQcnkTs/kG5CHK2ryfewEuIxFlzRRx7S
         LuNFmHRPQrUENXNxXnY9DXB0f2c8n2yate01V7Jk3r5nnUuil3Dut/27pySOw44fCng8
         +280Tve8VC9ookZAfRRUW0Ebinf/JGL1VBxPGrgq9qRFLIJD95APH6jsYpfTNSEZNEl7
         jdElg1zCgsYr4pgexlRrFcCi0+AQ1WX/qgbcArPw08DBmGaXbDBaaauVcAM41+8feOdi
         eVUQ==
X-Gm-Message-State: APjAAAXXZaiLCOGUrSKpD6QcvACiwKFDiuPvlfDlYQYEWJ7RvqXO+p6A
        vymHuNBqG95yd/AI95zqrWQz2Q==
X-Google-Smtp-Source: APXvYqyGxYyg/jCjvETi+ofHRYA9wzGOZ5QXiHA7FA79Lu5W/XWabxBCYKK5YDnKhHM28oDO6cRRcQ==
X-Received: by 2002:a1c:2109:: with SMTP id h9mr3377750wmh.68.1558443590427;
        Tue, 21 May 2019 05:59:50 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id i17sm22118765wrr.46.2019.05.21.05.59.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 21 May 2019 05:59:49 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jiri@resnulli.us
Subject: [PATCH net] net: sched: sch_ingress: do not report ingress filter info in egress path
Date:   Tue, 21 May 2019 14:59:29 +0200
Message-Id: <738244fd5863e6228275ee8f71e81d6baafca243.1558442828.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1558442828.git.lorenzo.bianconi@redhat.com>
References: <cover.1558442828.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently if we add a filter to the ingress qdisc (e.g matchall) the
filter data are reported even in the egress path. The issue can be
triggered with the following reproducer:

$tc qdisc add dev lo ingress
$tc filter add dev lo ingress matchall action ok
$tc filter show dev lo ingress
filter protocol all pref 49152 matchall chain 0
filter protocol all pref 49152 matchall chain 0 handle 0x1
  not_in_hw
	action order 1: gact action pass
		 random type none pass val 0
		 	 index 1 ref 1 bind 1

$tc filter show dev lo egress
filter protocol all pref 49152 matchall chain 0
filter protocol all pref 49152 matchall chain 0 handle 0x1
  not_in_hw
	action order 1: gact action pass
		 random type none pass val 0
		 	 index 1 ref 1 bind 1

Fix it reporting NULL for non-ingress filters in ingress_tcf_block
routine

Fixes: 6529eaba33f0 ("net: sched: introduce tcf block infrastructure")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 net/sched/sch_ingress.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
index 0bac926b46c7..1825347fed3a 100644
--- a/net/sched/sch_ingress.c
+++ b/net/sched/sch_ingress.c
@@ -31,7 +31,7 @@ static struct Qdisc *ingress_leaf(struct Qdisc *sch, unsigned long arg)
 
 static unsigned long ingress_find(struct Qdisc *sch, u32 classid)
 {
-	return TC_H_MIN(classid) + 1;
+	return TC_H_MIN(classid);
 }
 
 static unsigned long ingress_bind_filter(struct Qdisc *sch,
@@ -53,7 +53,12 @@ static struct tcf_block *ingress_tcf_block(struct Qdisc *sch, unsigned long cl,
 {
 	struct ingress_sched_data *q = qdisc_priv(sch);
 
-	return q->block;
+	switch (cl) {
+	case TC_H_MIN(TC_H_MIN_INGRESS):
+		return q->block;
+	default:
+		return NULL;
+	}
 }
 
 static void clsact_chain_head_change(struct tcf_proto *tp_head, void *priv)
-- 
2.20.1

