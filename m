Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CAB516A8E6
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 15:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbgBXO5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 09:57:12 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37297 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727181AbgBXO5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 09:57:11 -0500
Received: by mail-qt1-f193.google.com with SMTP id w47so6722294qtk.4
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 06:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=VVERRfYtSjvyIV2vT8DMK2ZgRMv8heRQn/wc4uqb8z0=;
        b=W6nYaaGy3xzNASGWIv1IazuEn+a9gnp1z2V7oaE7sZ/imvTeuRBWbFlvK6EZN1krH7
         +hCLAgUinR/9zhk7cy4nnyDpS9kzgA+7WFEU6WnMJmW8WJGrW38rZxNQC/nRCm3DPRdN
         l5D6dWSuFOPrwlw/RJMshEDm+lGgjF9QK0LeYe6zFW72CaZ5xYzr+R/2JTSDXlHnfvOz
         dA76WBHtC79HSAm4TWoST6IIHqKp1azNv1PHM3NymUrUXvLFWnD1ybFmRmxdzhm7JPGd
         fyVa75OIne5n+eN5erWaAGJttDZnD6psJ+CgDrLgpkk6pmEvG8UxdKDG2g0nqhstwdRc
         k1nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=VVERRfYtSjvyIV2vT8DMK2ZgRMv8heRQn/wc4uqb8z0=;
        b=mcAZgTBvzFiRZXmARus4jj+WVAD3phn2q0quYuMCoIkyEhRAl6BQELeGLtTUfhX1Ck
         wVZ2FRqObePlahxWDlUQ7Yt0yVdatU6VOD/yowz25jn/8dgZGON0iNrfDXoZj9h3mfoA
         d0OivKgiKXKgN5B/wWre9AmfdqNT41lHKqFn1Q01qdd22AzJySisEjHjHcGeJ8v3Q/iP
         eK/MvHPTUS7pD5fM2x+/UVVaFW/nI/HPR1IiMFw6twWHZwckXEoEyxY5a6jVydnrD0Hg
         rcPslBqyz1bWzRC1yLa/asZY33jodCI8/lfI0ZW5SYAMGI4lVghzK24PXv6XK6xJ5VjL
         iMfg==
X-Gm-Message-State: APjAAAUtFvfYxa4AVKBUmrFBj+F8YgEnG4vSYj83o/aMQ7089u7KRhzx
        wh476+gJxqIlrQgIs5cvCm96Fvh4
X-Google-Smtp-Source: APXvYqzm7P4z05oW0TVw8fCUS31I4qh19LACzgnGvAfyQdTtTKJsPxMM6Y/nR9d4l2TNDAyfxSe9+w==
X-Received: by 2002:aed:3203:: with SMTP id y3mr49612714qtd.23.1582556230415;
        Mon, 24 Feb 2020 06:57:10 -0800 (PST)
Received: from bootp-73-131-246.rhts.eng.pek2.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w207sm455511qkb.26.2020.02.24.06.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 06:57:09 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     stephen@networkplumber.org, steffen.klassert@secunet.com,
        sd@queasysnail.net
Subject: [PATCH iproute2] xfrm: not try to delete ipcomp states when using deleteall
Date:   Mon, 24 Feb 2020 09:57:01 -0500
Message-Id: <6d87af76cc3c311647c961e2f94e026bb15869d8.1582556221.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In kernel space, ipcomp(sub) states used by main states are not
allowed to be deleted by users, they would be freed only when
all main states are destroyed and no one uses them.

In user space, ip xfrm sta deleteall doesn't filter these ipcomp
states out, and it causes errors:

  # ip xfrm state add src 192.168.0.1 dst 192.168.0.2 spi 0x1000 \
      proto comp comp deflate mode tunnel sel src 192.168.0.1 dst \
      192.168.0.2 proto gre
  # ip xfrm sta deleteall
  Failed to send delete-all request
  : Operation not permitted

This patch is to fix it by filtering ipcomp states with a check
xsinfo->id.proto == IPPROTO_IPIP.

Fixes: c7699875bee0 ("Import patch ipxfrm-20040707_2.diff")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 ip/xfrm_state.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/ip/xfrm_state.c b/ip/xfrm_state.c
index f2727070..428a5837 100644
--- a/ip/xfrm_state.c
+++ b/ip/xfrm_state.c
@@ -1131,6 +1131,9 @@ static int xfrm_state_keep(struct nlmsghdr *n, void *arg)
 	if (!xfrm_state_filter_match(xsinfo))
 		return 0;
 
+	if (xsinfo->id.proto == IPPROTO_IPIP)
+		return 0;
+
 	if (xb->offset > xb->size) {
 		fprintf(stderr, "State buffer overflow\n");
 		return -1;
-- 
2.18.1

