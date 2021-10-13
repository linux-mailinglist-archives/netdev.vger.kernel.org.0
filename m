Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD1F42CAEE
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 22:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbhJMU35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 16:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbhJMU35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 16:29:57 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2DEAC061570;
        Wed, 13 Oct 2021 13:27:53 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id e7so7029719ual.11;
        Wed, 13 Oct 2021 13:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q47BvSJtkRI/JggIs8wb9lC6FIacendAi7fQN+euAl8=;
        b=RYpaBgQRBhyRDk46fNW1HgiqJe8r+zZFcT854hi7zxv13gve4CUH08sOCTplvlWTs8
         t6nWeGbDs9GZXLzBBxuyq6iPeKUun1Ra0KpA51Za/uV8QDdLfpAEaOFbV5UMH0ErUrXk
         1nyyy8gOMrcbW55wB+yV9WpKeTS3tjg6pbUkV+HZ5DY4J1D8KApiGOXTBk3h0C18J0sd
         PAw4qKof/HVks3uFZk+hZRVM6bKO52bA920coI9gt6Vv+TfMmnNXIBPE4tZqCYEZO1/s
         iiL+5wY9J8uDMnunl00NyANqO9ebKRw8MNX1YvwuS8N4MfFUXAbrwlCpSIWQeGG37Rxx
         vwDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q47BvSJtkRI/JggIs8wb9lC6FIacendAi7fQN+euAl8=;
        b=oe/DWW4o9gAEez5QPbsKvCZ4pjXhlgt/renY3eMByLGXkMv6F3r3e9xGa9yexOuGUz
         hOEABu5p8W+bSnJSEJFyn/NXJdIkdo+nEkGZqtj+E0Cwkbx3XpBNZeRrDtmASES4i4Pr
         PMPo9JDxaf1j6eypQ5t7/Hmq3kwMwLCWF4ZJNw5TQwAJR6CDUnN5dWFfWAacSt3/h7QF
         ptr1WsKCPho2uNjIDSDYJ3rKlLswLPyrrguTh7sf9diF8UbhmZmg5XenOMpnTucYhhX3
         i1F7Ctc6Cd9NBEaxh+8dElpJJntvwsWUOuir/lGMyy8Rh5XEoXsVm1WvvBQkBbB6ZpuN
         Ac2g==
X-Gm-Message-State: AOAM531JSGLvp4mqNzF+drvnANQoRaMa1OkjCOGpNL5nuygxN12jaHKF
        +vN5eP7KTisrlv1Sj+fEWgYZC9X1Y50=
X-Google-Smtp-Source: ABdhPJzjOkBp3rCuqBYH7jT5Y9X98aRXO0XVZmzMA9aNco9Amre3PTrCoOYVZdqMwDAsvlHHpjVsOQ==
X-Received: by 2002:a67:e28a:: with SMTP id g10mr1771403vsf.5.1634156872562;
        Wed, 13 Oct 2021 13:27:52 -0700 (PDT)
Received: from t14s.localdomain ([2001:1284:f013:bd65:5bf1:4dff:e077:f96c])
        by smtp.gmail.com with ESMTPSA id t76sm439691vkt.0.2021.10.13.13.27.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 13:27:51 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 0BBA888713; Wed, 13 Oct 2021 17:27:50 -0300 (-03)
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     netdev@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>,
        Xin Long <lucien.xin@gmail.com>
Subject: [PATCH net] sctp: account stream padding length for reconf chunk
Date:   Wed, 13 Oct 2021 17:27:29 -0300
Message-Id: <b97c1f8b0c7ff79ac4ed206fc2c49d3612e0850c.1634156849.git.mleitner@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eiichi Tsukata <eiichi.tsukata@nutanix.com>

sctp_make_strreset_req() makes repeated calls to sctp_addto_chunk()
which will automatically account for padding on each call. inreq and
outreq are already 4 bytes aligned, but the payload is not and doing
SCTP_PAD4(a + b) (which _sctp_make_chunk() did implicitly here) is
different from SCTP_PAD4(a) + SCTP_PAD4(b) and not enough. It led to
possible attempt to use more buffer than it was allocated and triggered
a BUG_ON.

Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-sctp@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>
Fixes: cc16f00f6529 ("sctp: add support for generating stream reconf ssn reset request chunk")
Reported-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Marcelo Ricardo Leitner <mleitner@redhat.com>
---
 net/sctp/sm_make_chunk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index b8fa8f1a7277..c7503fd64915 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3697,7 +3697,7 @@ struct sctp_chunk *sctp_make_strreset_req(
 	outlen = (sizeof(outreq) + stream_len) * out;
 	inlen = (sizeof(inreq) + stream_len) * in;
 
-	retval = sctp_make_reconf(asoc, outlen + inlen);
+	retval = sctp_make_reconf(asoc, SCTP_PAD4(outlen) + SCTP_PAD4(inlen));
 	if (!retval)
 		return NULL;
 
-- 
2.31.1

