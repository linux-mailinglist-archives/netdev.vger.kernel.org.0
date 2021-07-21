Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8A23D169C
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 20:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239429AbhGUSFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 14:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbhGUSFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 14:05:24 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A08C061575;
        Wed, 21 Jul 2021 11:46:00 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id k4-20020a17090a5144b02901731c776526so155218pjm.4;
        Wed, 21 Jul 2021 11:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UCmn/zTjqaJHJEOQhO1krx2JabX8XxHBsvR7Suz18sQ=;
        b=Q5EwVV1GxDqwhBXAgVoxMT5XTwkVX+UCa22MdX1q8BdPXBob9Y1iJHhjuk/cYwwmBq
         f6POV2Uou0+rnp/737lprC5Xn7dj+lWTZ8JNKgAn2P+2Au5HvX9EggMSOojwWxvVxIJp
         6se3dCze9mR73eatBzBe3GKB7vGcP5NlC96DSLwLqn6jp+jHVwGVfAOANMPZw3EpYjwc
         phF63H2dmAogFNP4D4mcBT7faEflJ34NCgRyj+rtg9dek+dQXcH75LIcUt5poodTvlCj
         0xysc3x3WWrfs8Y3h6FT7xcuGZ0GEzqyyd7rlIh+5bq5FhIgmsnhdsYL+HPa6ox/QbO7
         fJrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UCmn/zTjqaJHJEOQhO1krx2JabX8XxHBsvR7Suz18sQ=;
        b=pd8GldowUM7KpSOtsCWkPCvjzjIpkOvXv+P97kZi90hPif0a+fHpVozh2vrWxeFqK2
         IBLeJppq1T0X+pIym1PBCrxx8u4NrsUv7ifWkINhOgRbmn+IcdqaBM/lZQGayXvh9EUP
         9v9776oOM3UtplsLAqzRXeVimwdILRVr78PxP7xBIa1JpT7RxMtLmNCMdIpGXZQ+OigK
         CByJI3gGqKvlUy5YbBHRrZCHY+rd0aru2/tJO98SKy2YKoDiJOJ1wIQTeszu/J1MxQJG
         RV8pGDw3RlwHYUu5zfjRO01uVkBM2BXwHaiQCFAmg4QPcBH0OoDuKk78D7uz1Dh6Z2Fs
         l42Q==
X-Gm-Message-State: AOAM531238Mb65yuajMQ7EahX6m8c/G1XH+MMLmGnZRQ3zUfDJjzznrj
        qC9SRYp9e5DVrjYDHpxg5d5FwSHx1U83xA==
X-Google-Smtp-Source: ABdhPJz9MMDqrGPyLjuYqu5Ea9XGHE6RXsgm9z5JJrsk/ATX6bgmX8+kC8AuCvL3IJy873y2mQvy4w==
X-Received: by 2002:a63:5610:: with SMTP id k16mr37068273pgb.439.1626893159591;
        Wed, 21 Jul 2021 11:45:59 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id m21sm23297840pjz.36.2021.07.21.11.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 11:45:59 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jacek Szafraniec <jacek.szafraniec@nokia.com>
Subject: [PATCHv2 net] sctp: do not update transport pathmtu if SPP_PMTUD_ENABLE is not set
Date:   Wed, 21 Jul 2021 14:45:54 -0400
Message-Id: <46ea0cacefc4cebcb9e041edd201eece6d2e881d.1626893154.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, in sctp_packet_config(), sctp_transport_pmtu_check() is
called to update transport pathmtu with dst's mtu when dst's mtu
has been changed by non sctp stack like xfrm.

However, this should only happen when SPP_PMTUD_ENABLE is set, no
matter where dst's mtu changed. This patch is to fix by checking
SPP_PMTUD_ENABLE flag before calling sctp_transport_pmtu_check().

Thanks Jacek for reporting and looking into this issue.

v1->v2:
  - add the missing "{" to fix the build error.

Fixes: 69fec325a643 ('Revert "sctp: remove sctp_transport_pmtu_check"')
Reported-by: Jacek Szafraniec <jacek.szafraniec@nokia.com>
Tested-by: Jacek Szafraniec <jacek.szafraniec@nokia.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/output.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index 9032ce60d50e..4dfb5ea82b05 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -104,8 +104,8 @@ void sctp_packet_config(struct sctp_packet *packet, __u32 vtag,
 		if (asoc->param_flags & SPP_PMTUD_ENABLE)
 			sctp_assoc_sync_pmtu(asoc);
 	} else if (!sctp_transport_pl_enabled(tp) &&
-		   !sctp_transport_pmtu_check(tp)) {
-		if (asoc->param_flags & SPP_PMTUD_ENABLE)
+		   asoc->param_flags & SPP_PMTUD_ENABLE) {
+		if (!sctp_transport_pmtu_check(tp))
 			sctp_assoc_sync_pmtu(asoc);
 	}
 
-- 
2.27.0

