Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8292A0669
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 14:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgJ3N1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 09:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbgJ3N07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 09:26:59 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31725C0613D4
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 06:26:56 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id x7so6475125wrl.3
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 06:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=malat-biz.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wG2sI8EW6iI9IIulD8zNExRHnDRv1t9L6KpFgetl1O0=;
        b=It8HY9X7/21o8aISYouyA5HeQJR4CCaRRs3ChM8/RbuT86Cx9uowa8WNGRmEhBJpfU
         uV/tjlMepuV9TWvjZgT0SE/ExK0KLXrFQcGo++QJ1+5ItYLdB6GqdZ8aL3qg7ofLL46H
         M4QuaatKS9KZ2Au2x/jVA7IkcNBZ1cQ9suATXD3061TRSNrlM2+CrZUGOI4fpQ16A5py
         J1zWnauZrVz2F+Jfxcpa8xxFyX4RqITSMtXmD9UMVjFg8AwQs90tFR6pjgluERsE5SpH
         DmHHZALymZXhwfKJT0JOQsxV/F2Ujqe4kOHA4rBdoP2U4edrZ2kA0DTh8W6mRDW/RTOa
         eIgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wG2sI8EW6iI9IIulD8zNExRHnDRv1t9L6KpFgetl1O0=;
        b=he0kYVumGPIOEvYIWKsnK165+ywNHBoN32wzijgc6j0R88sa8X9nFkZOB+Pk0Y2jI/
         X8kJ/7V2zQjmROBACOlbkVHp4VuIF5p3KEabyxK+mVo9T3pIGirkkga5cEW6EmaBWZp5
         2byCwz0XVST3PqH4zmPT/ZMDvJJ0+ZyoQHZu5zw4kWZExg6XkmzEMZ7oZMZvXR+n9caJ
         7F0SAp8cU8EIFTOm4o66e18FJr4H40z4GLggBdoTCAZkyF1hlg3qRzrZ8BgdNQmkkWgJ
         fr2Mnw7TN9ZrtTtiCSXOyVnE9vlshtylrq1h+aPZT/NJ/wjhdYMgo1+9wAEwfboboKJj
         ePwA==
X-Gm-Message-State: AOAM530BJp6IjBaHfpjxCUaHiHL9mY9QwQZhBco95TvJkyARr4rwI4/2
        KVl//d7CLzMatT/TyyuphMONPA==
X-Google-Smtp-Source: ABdhPJz2Gsl2quuKCrrrlNHBxMbkJnTdMepfA15AuCCR6ljz17dnt7nM9KLlfdWe+bwLXN3Z0Scwpw==
X-Received: by 2002:adf:f9cf:: with SMTP id w15mr3237771wrr.185.1604064414963;
        Fri, 30 Oct 2020 06:26:54 -0700 (PDT)
Received: from ntb.petris.klfree.cz (snat2.klfree.cz. [81.201.48.25])
        by smtp.googlemail.com with ESMTPSA id z15sm10160401wrq.24.2020.10.30.06.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 06:26:54 -0700 (PDT)
From:   Petr Malat <oss@malat.biz>
To:     linux-sctp@vger.kernel.org
Cc:     Petr Malat <oss@malat.biz>, Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sctp: Fix COMM_LOST/CANT_STR_ASSOC err reporting on big-endian platforms
Date:   Fri, 30 Oct 2020 14:26:33 +0100
Message-Id: <20201030132633.7045-1-oss@malat.biz>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 978aa0474115 ("sctp: fix some type cast warnings introduced since
very beginning")' broke err reading from sctp_arg, because it reads the
value as 32-bit integer, although the value is stored as 16-bit integer.
Later this value is passed to the userspace in 16-bit variable, thus the
user always gets 0 on big-endian platforms. Fix it by reading the __u16
field of sctp_arg union, as reading err field would produce a sparse
warning.

Signed-off-by: Petr Malat <oss@malat.biz>
---
 net/sctp/sm_sideeffect.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index aa821e71f05e..813d30767204 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -1601,12 +1601,12 @@ static int sctp_cmd_interpreter(enum sctp_event_type event_type,
 			break;
 
 		case SCTP_CMD_INIT_FAILED:
-			sctp_cmd_init_failed(commands, asoc, cmd->obj.u32);
+			sctp_cmd_init_failed(commands, asoc, cmd->obj.u16);
 			break;
 
 		case SCTP_CMD_ASSOC_FAILED:
 			sctp_cmd_assoc_failed(commands, asoc, event_type,
-					      subtype, chunk, cmd->obj.u32);
+					      subtype, chunk, cmd->obj.u16);
 			break;
 
 		case SCTP_CMD_INIT_COUNTER_INC:
-- 
2.20.1

