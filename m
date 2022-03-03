Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D05B64CBD37
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 12:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbiCCL6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 06:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbiCCL6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 06:58:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AE2EE125CB7
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 03:58:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646308684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hUhOKIvTxK5eTWi/ArM389md3TNN2li1qUSJAFCm2YI=;
        b=c0RFwmey+s0J04YO/ax8ctYJo6T7YdcZrBfnMBPm+7TkB84lGXBPAg6dsObkQAbeKOcgnp
        SSaVa9LCbAtUC+4m9No3gQsNSXe5uFsSGFX/XVYsbW1g53r1tGmux6r5U+vXwEbvEasVvY
        0vN0T9iSk9/Gpd5gRRBo1vK4A8/2R6U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-Qz1PwNtkMQKkBO8FeyLdjA-1; Thu, 03 Mar 2022 06:58:01 -0500
X-MC-Unique: Qz1PwNtkMQKkBO8FeyLdjA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6583E1091DA1;
        Thu,  3 Mar 2022 11:58:00 +0000 (UTC)
Received: from dcaratti.station (unknown [10.40.194.226])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4274F1F45E;
        Thu,  3 Mar 2022 11:57:53 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Thomas Higdon <tph@fb.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@kernel.org>
Cc:     Stefano Brivio <sbrivio@redhat.com>
Subject: [PATCH iproute2-next] ss: display advertised TCP receive window and out-of-order counter
Date:   Thu,  3 Mar 2022 12:57:35 +0100
Message-Id: <55dcdba34b9d9fbd2a95257de7916560e1a6b7b1.1646308584.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

these members of TCP_INFO have been included in v5.4.

tested with:
 # ss -nti

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 misc/ss.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/misc/ss.c b/misc/ss.c
index f7d369142d93..d77b7f10dc43 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -854,6 +854,8 @@ struct tcpstat {
 	unsigned int	    reord_seen;
 	double		    rcv_rtt;
 	double		    min_rtt;
+	unsigned int 	    rcv_ooopack;
+	unsigned int	    snd_wnd;
 	int		    rcv_space;
 	unsigned int        rcv_ssthresh;
 	unsigned long long  busy_time;
@@ -2654,6 +2656,10 @@ static void tcp_stats_print(struct tcpstat *s)
 		out(" notsent:%u", s->not_sent);
 	if (s->min_rtt)
 		out(" minrtt:%g", s->min_rtt);
+	if (s->rcv_ooopack)
+		out(" rcv_oopack:%u", s->rcv_ooopack);
+	if (s->snd_wnd)
+		out(" snd_wnd:%u", s->snd_wnd);
 }
 
 static void tcp_timer_print(struct tcpstat *s)
@@ -3088,6 +3094,8 @@ static void tcp_show_info(const struct nlmsghdr *nlh, struct inet_diag_msg *r,
 		s.reord_seen = info->tcpi_reord_seen;
 		s.bytes_sent = info->tcpi_bytes_sent;
 		s.bytes_retrans = info->tcpi_bytes_retrans;
+		s.rcv_ooopack = info->tcpi_rcv_ooopack;
+		s.snd_wnd = info->tcpi_snd_wnd;
 		tcp_stats_print(&s);
 		free(s.dctcp);
 		free(s.bbr_info);
-- 
2.35.1

