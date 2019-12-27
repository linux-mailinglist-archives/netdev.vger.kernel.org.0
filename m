Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38BAA12B4C7
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 14:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbfL0NLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 08:11:36 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41256 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfL0NLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 08:11:35 -0500
Received: by mail-pg1-f195.google.com with SMTP id x8so14433882pgk.8;
        Fri, 27 Dec 2019 05:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IX7kXlwKRYc8Z53ZAuzPPxbcKv6sYTixPprjeYYu2N0=;
        b=nUjmkBrfxdpy6+7XPQO0Z0ypI/FHGMyoTPotggVI7iNtcL+UUKtxDV7WHHBUzGYUhL
         m9CJF8xwQ1gMdxobpn3FOL679MWlsd9UmpdrgSnq/VlVhz704acs3JqnoPzZUJ74sHit
         hTZo/IlLSY/byG0Y0Zy8W/D8WpUzxz5NDgAflLGn6wBWvAY90FpH9ru9cnGAbwvr9LvX
         Oe22x5ECAsnwaNCWuaAmVra/9+R21+rja++DNHYzM9aUtdP6MEIClEmPqWdLaDFtAgCl
         Lgy4NCiDOqB9TRog0li7IemcLHVsYrMCRJPIdr4+RjtHGvXHbLJO2B261U66c8zCVLeI
         UGkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IX7kXlwKRYc8Z53ZAuzPPxbcKv6sYTixPprjeYYu2N0=;
        b=FasRvbJWMPrZeRFJH1dr2OcPINEfy8Anq+Q98hH09hopeMftNSP/7h9j9RyNmewdZG
         qdUj74jqBvXzAHc1IHYhQJujY4EBz06q/58a2RXKHAqSTQHY0fAK6tiM7iHnGtEmRZNd
         Gbpu8yFwiGZux1vwlHDVi2UfRFqtWSbYNP74V39VrIAM2Oi2FqwLf4HwmCvKmr5H0uY9
         61r7UcziUA9r9o5OyM3pIBeQWGvv4XbHc63NgjRKQDTvxbiM3g3eMvsQZkypCt3FqXQU
         Oymo0MvFROgyRgOj3gFkYei3o7AcumsBRQQ2gmYQeGLx0+jyL37OltP5PJER6psttezG
         VBbw==
X-Gm-Message-State: APjAAAUyuKeeYLZ2fxlVY/jinfR1HjVpJ/FFHjN3hzHdM7vAk5vnYGSe
        dALkT7DhOAU8EWU7QZeULjAYWuxKS1M=
X-Google-Smtp-Source: APXvYqzCQvcrvhgM3vgWEUXSyIC1U1Y4Xy1YE+sx16hWJPE/CK/7VGILYrPbQvCuCMGRom6WGd0N3g==
X-Received: by 2002:aa7:9567:: with SMTP id x7mr54624246pfq.133.1577452294814;
        Fri, 27 Dec 2019 05:11:34 -0800 (PST)
Received: from CV0038107N9.nsn-intra.net ([2408:8215:b21:57c1:d8e7:fc85:a755:1213])
        by smtp.gmail.com with ESMTPSA id u20sm36097566pgf.29.2019.12.27.05.11.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Dec 2019 05:11:34 -0800 (PST)
From:   Kevin Kou <qdkevin.kou@gmail.com>
To:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Cc:     nhorman@tuxdriver.com, marcelo.leitner@gmail.com,
        davem@davemloft.net, qdkevin.kou@gmail.com
Subject: [PATCH net-next] sctp: add enabled check for path tracepoint loop.
Date:   Fri, 27 Dec 2019 13:11:16 +0000
Message-Id: <20191227131116.375-1-qdkevin.kou@gmail.com>
X-Mailer: git-send-email 2.23.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sctp_outq_sack is the main function handles SACK, it is called very
frequently. As the commit "move trace_sctp_probe_path into sctp_outq_sack"
added below code to this function, sctp tracepoint is disabled most of time,
but the loop of transport list will be always called even though the
tracepoint is disabled, this is unnecessary.

+	/* SCTP path tracepoint for congestion control debugging. */
+	list_for_each_entry(transport, transport_list, transports) {
+		trace_sctp_probe_path(transport, asoc);
+	}

This patch is to add tracepoint enabled check at outside of the loop of
transport list, and avoid traversing the loop when trace is disabled,
it is a small optimization.

Signed-off-by: Kevin Kou <qdkevin.kou@gmail.com>
---
 net/sctp/outqueue.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index adceb22..83ddcfe 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -1240,8 +1240,9 @@ int sctp_outq_sack(struct sctp_outq *q, struct sctp_chunk *chunk)
 	transport_list = &asoc->peer.transport_addr_list;
 
 	/* SCTP path tracepoint for congestion control debugging. */
-	list_for_each_entry(transport, transport_list, transports) {
-		trace_sctp_probe_path(transport, asoc);
+	if (trace_sctp_probe_path_enabled()) {
+		list_for_each_entry(transport, transport_list, transports)
+			trace_sctp_probe_path(transport, asoc);
 	}
 
 	sack_ctsn = ntohl(sack->cum_tsn_ack);
-- 
1.8.3.1

