Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2D437004D
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 20:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbhD3SRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 14:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbhD3SRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 14:17:03 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C3EFC06174A;
        Fri, 30 Apr 2021 11:16:15 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so2203340pjv.1;
        Fri, 30 Apr 2021 11:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=xAwWOFvCJDNzLLNmsTsVCzG3dAntmC4sJfm+8QnG4Zw=;
        b=bS0BXeREqBIKP/WueVHeu5WrNRpVdeZq3Ol11TJyx1fDFBgaSyo2oIFtSGNvD9UY0m
         WPOAbAC06yodC/ujnR6tWg3ziG3gATmuL2MdfPXNh2Oq2Av412ZXGK6E4owTkayj9H/Z
         Eedw+rtha8D/nAqSwxPUQg+VnfN6VEDGS10hMcR6KFHiGhp66VVmLi/DorCAHIlktkMX
         MjwaPReawVmaQohWnWiARsoR7dYycuITm0pRgZKWPOr0VTP6PnwYL4zPTZ6PuhIOyj2G
         gJCxyKzwQjlihwN88dotbFN35mBhzR+cqI8VIIR/SRXH1js7idjR11lLhzlQ6s/UAfUk
         CkIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=xAwWOFvCJDNzLLNmsTsVCzG3dAntmC4sJfm+8QnG4Zw=;
        b=d9e3g1coqfJDgJBmFkzIv88zqX0EW8ZeWCVu1RtdHX71DZyCTL01eLdY6h9L5nvPlc
         yXVo7RM8Itn/Mo8qpZHEkqyu8aj7MfzI8Z6ada6M+ly5rNaePdSHCsmS/ynJxbbyCosH
         T/n5rTo6W0kJlOe0x38uf1RfgXnKE+Caqcp9ArvoyHAZPe/AeedJpH3TK0/iy4KJijGd
         vb8sDAl1wRdpqaAQ08Ls6r7jI8qSzlrd/NsJp9PUdXNq6PF8kxSoSIJsRfUES+6ggDTv
         Hed+4+UzN7LNyEZ1GKRQxqSTJvsV+HH7mMwyUaH+KtGPUdlEueZLUPIcf7yQ1xrTsd/y
         +zWA==
X-Gm-Message-State: AOAM533wlOLu3W58un5gn1JcUd3Ce/bqmyRzjhy1vF4L+JVUeGuyEZrV
        BUK2t7jto6ND7AY9N26Koe0gkPqpt5II1ANL
X-Google-Smtp-Source: ABdhPJyiaORFJGsqWgpt4JhffQ7TsPQpmN/4toMNYAhcsOR/eXyIu4eluR67TQo/BUSvQ6bAPvs27A==
X-Received: by 2002:a17:90a:384b:: with SMTP id l11mr6495188pjf.222.1619806574471;
        Fri, 30 Apr 2021 11:16:14 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b6sm2731130pfb.27.2021.04.30.11.16.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Apr 2021 11:16:14 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        jere.leppanen@nokia.com,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>
Subject: [PATCH net 1/3] sctp: do asoc update earlier in sctp_sf_do_dupcook_a
Date:   Sat,  1 May 2021 02:15:55 +0800
Message-Id: <ab7a35c9888202a34079baaa835294422bc3b5b3.1619806333.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1619806333.git.lucien.xin@gmail.com>
References: <cover.1619806333.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1619806333.git.lucien.xin@gmail.com>
References: <cover.1619806333.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's a panic that occurs in a few of envs, the call trace is as below:

  [] general protection fault, ... 0x29acd70f1000a: 0000 [#1] SMP PTI
  [] RIP: 0010:sctp_ulpevent_notify_peer_addr_change+0x4b/0x1fa [sctp]
  []  sctp_assoc_control_transport+0x1b9/0x210 [sctp]
  []  sctp_do_8_2_transport_strike.isra.16+0x15c/0x220 [sctp]
  []  sctp_cmd_interpreter.isra.21+0x1231/0x1a10 [sctp]
  []  sctp_do_sm+0xc3/0x2a0 [sctp]
  []  sctp_generate_timeout_event+0x81/0xf0 [sctp]

This is caused by a transport use-after-free issue. When processing a
duplicate COOKIE-ECHO chunk in sctp_sf_do_dupcook_a(), both COOKIE-ACK
and SHUTDOWN chunks are allocated with the transort from the new asoc.
However, later in the sideeffect machine, the old asoc is used to send
them out and old asoc's shutdown_last_sent_to is set to the transport
that SHUTDOWN chunk attached to in sctp_cmd_setup_t2(), which actually
belongs to the new asoc. After the new_asoc is freed and the old asoc
T2 timeout, the old asoc's shutdown_last_sent_to that is already freed
would be accessed in sctp_sf_t2_timer_expire().

Thanks Alexander and Jere for helping dig into this issue.

To fix it, this patch is to do the asoc update first, then allocate
the COOKIE-ACK and SHUTDOWN chunks with the 'updated' old asoc. This
would make more sense, as a chunk from an asoc shouldn't be sent out
with another asoc. We had fixed quite a few issues caused by this.

Fixes: 145cb2f7177d ("sctp: Fix bundling of SHUTDOWN with COOKIE-ACK")
Reported-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Reported-by: syzbot+bbe538efd1046586f587@syzkaller.appspotmail.com
Reported-by: Michal Tesar <mtesar@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_statefuns.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 7632714..30cb946 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1852,20 +1852,35 @@ static enum sctp_disposition sctp_sf_do_dupcook_a(
 			SCTP_TO(SCTP_EVENT_TIMEOUT_T4_RTO));
 	sctp_add_cmd_sf(commands, SCTP_CMD_PURGE_ASCONF_QUEUE, SCTP_NULL());
 
-	repl = sctp_make_cookie_ack(new_asoc, chunk);
+	/* Update the content of current association. */
+	if (sctp_assoc_update((struct sctp_association *)asoc, new_asoc)) {
+		struct sctp_chunk *abort;
+
+		abort = sctp_make_abort(asoc, NULL, sizeof(struct sctp_errhdr));
+		if (abort) {
+			sctp_init_cause(abort, SCTP_ERROR_RSRC_LOW, 0);
+			sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(abort));
+		}
+		sctp_add_cmd_sf(commands, SCTP_CMD_SET_SK_ERR, SCTP_ERROR(ECONNABORTED));
+		sctp_add_cmd_sf(commands, SCTP_CMD_ASSOC_FAILED,
+				SCTP_PERR(SCTP_ERROR_RSRC_LOW));
+		SCTP_INC_STATS(net, SCTP_MIB_ABORTEDS);
+		SCTP_DEC_STATS(net, SCTP_MIB_CURRESTAB);
+		goto nomem;
+	}
+
+	repl = sctp_make_cookie_ack(asoc, chunk);
 	if (!repl)
 		goto nomem;
 
 	/* Report association restart to upper layer. */
 	ev = sctp_ulpevent_make_assoc_change(asoc, 0, SCTP_RESTART, 0,
-					     new_asoc->c.sinit_num_ostreams,
-					     new_asoc->c.sinit_max_instreams,
+					     asoc->c.sinit_num_ostreams,
+					     asoc->c.sinit_max_instreams,
 					     NULL, GFP_ATOMIC);
 	if (!ev)
 		goto nomem_ev;
 
-	/* Update the content of current association. */
-	sctp_add_cmd_sf(commands, SCTP_CMD_UPDATE_ASSOC, SCTP_ASOC(new_asoc));
 	sctp_add_cmd_sf(commands, SCTP_CMD_EVENT_ULP, SCTP_ULPEVENT(ev));
 	if ((sctp_state(asoc, SHUTDOWN_PENDING) ||
 	     sctp_state(asoc, SHUTDOWN_SENT)) &&
-- 
2.1.0

