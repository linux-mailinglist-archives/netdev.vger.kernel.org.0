Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3E7E2C8D70
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 19:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388296AbgK3SyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 13:54:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388288AbgK3SyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 13:54:22 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96EAC061A48;
        Mon, 30 Nov 2020 10:53:41 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id t18so7007675plo.0;
        Mon, 30 Nov 2020 10:53:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ouf0WBHGZpA6/0T7zSjGFwwnqyhXPQ0sX/VyNuYesJo=;
        b=a6hzTvLqRYg7ldf1Khs4RKbCmBut9yjGjfHdb8GujHheQdE2i/oOou4SFRuLrBgg8U
         K5lLwMQHjHk2cZxK2OK+iUG4nInYmifQqneQ/pV5CDfnbZnL0yoCuIqQVBR71mySif90
         FnQG/An25tnFZ+lb8A6HjIehHhP0/uZNyCgWJvCJ/bU2FoRp6giMF9CKvWUMA77Xm/Cq
         91a1ISkixkoVOmG59WwjZJBEG+ojQRVIkswDuOQn1EyWS/A13uQM7V9VzO1Zfsld01iT
         d3vxg6D4FMVgJC9j6AWWtlolsaSGIQj/x4+4XRuyHJWI7pOpQKm1lbEMBbiRvhIVxJIG
         wfVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ouf0WBHGZpA6/0T7zSjGFwwnqyhXPQ0sX/VyNuYesJo=;
        b=nlhN6Wwp65H9nBXZ2O64Qvw+u3MmClwnBIRVdLCSCcVeKbYZ6zh2+XBvfqS2a+0kzY
         v5DY8xuvIwXvHoafinfeeRpkeeH2cWPhu1s32qdUivN/ExYdzvOc0gyjOkR8yPT0NvJ3
         vjvB21SlGdCdtswgdnXmHXqyDjnHmyEf2Aw3Ge60jrlTOq2sWtiwMZQRQV12rlo9qgS7
         oM4PAFGQFp4L7SduQisudsXhKqMbNM4fV4UpzApw2Y2ZP6K+IVfL2kll9PQHIaVFq13S
         vN7+xbehV+Sdg/Y7iZYLjhRhHnoEtgM19WOICBxL5kj6wO2wSOoBYkZOXRBo9GLr8peb
         pYGQ==
X-Gm-Message-State: AOAM531QktjrWUAJfObcX0Z2hkUSItJgVwOODX9hh+l9tInwIHSO+Skw
        AvTC6yNxDMSX64f6yhg9Ds2SxDpnBXkztm/vLAs=
X-Google-Smtp-Source: ABdhPJyttLGEJqv8v1u3Ouay0Po85DyvLAuxQfsGNmkUMiVn4Vsp3s/W3cvAdjIkAD/udEbZWdf4UQ==
X-Received: by 2002:a17:90a:6b4b:: with SMTP id x11mr229180pjl.3.1606762421076;
        Mon, 30 Nov 2020 10:53:41 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id i3sm12005978pgq.12.2020.11.30.10.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 10:53:39 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, jonathan.lemon@gmail.com, maximmi@nvidia.com
Subject: [PATCH bpf-next v4 10/10] samples/bpf: add option to set the busy-poll budget
Date:   Mon, 30 Nov 2020 19:52:05 +0100
Message-Id: <20201130185205.196029-11-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201130185205.196029-1-bjorn.topel@gmail.com>
References: <20201130185205.196029-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Support for the SO_BUSY_POLL_BUDGET setsockopt, via the batching
option ('b').

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 samples/bpf/xdpsock_user.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 4622a17fafe1..036bd019e400 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -1480,6 +1480,11 @@ static void apply_setsockopt(struct xsk_socket_info *xsk)
 	if (setsockopt(xsk_socket__fd(xsk->xsk), SOL_SOCKET, SO_BUSY_POLL,
 		       (void *)&sock_opt, sizeof(sock_opt)) < 0)
 		exit_with_error(errno);
+
+	sock_opt = opt_batch_size;
+	if (setsockopt(xsk_socket__fd(xsk->xsk), SOL_SOCKET, SO_BUSY_POLL_BUDGET,
+		       (void *)&sock_opt, sizeof(sock_opt)) < 0)
+		exit_with_error(errno);
 }
 
 int main(int argc, char **argv)
-- 
2.27.0

