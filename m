Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3185D3D1351
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 18:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbhGUP1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 11:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbhGUP1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 11:27:52 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16EDC061575;
        Wed, 21 Jul 2021 09:08:27 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id 23so2620728qke.0;
        Wed, 21 Jul 2021 09:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xG+kNA6UEvo3za/AEwF4as+4avCgx8xzRTF6tSllmoI=;
        b=atx9+w4VrsIHvRwLyc2ZErEku2aOFfZvcrLxZsy/KvKdVlUuyLYOkImhMUOvmeVcFC
         Uzd94Qgn1YrJTyAAxLIeaevNvE2AZJLp+egEAkdg9ZmvrvYQObmz8tcFnyK5KVCrjbVT
         2fjpt2oiiSAO7dloEomTdoyjE8CO2h8deV5vWs2Du1Hhk3qEuizypn420jlAPQqODP+M
         yVxji3QA3pNsNP7Mcjdct00sAlABZdP42/n/EPrh26FVBz+W6fy58K1Jh6p2I1ixl+bG
         /ZDyFf9uTImCv5F3N5EWsxw7e9AKjmmJCMmmnW8OI/u7ona7aBtz7YfGoUPz83m9jAd/
         yphg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xG+kNA6UEvo3za/AEwF4as+4avCgx8xzRTF6tSllmoI=;
        b=QnDVKu/6iWgidLW5RpKyg4DPqprW50BU8O0kBoarMd6z8BZP/QvnceHEo4UZFZjaR3
         4tYqmdzzT4zHNH5z8StMkZX0VjG/GTvRJ/ZD8HxqZsXSSz3Ii6kK0atPDKGVXj3/v7MW
         420rR7uwmx3/6jqs4bwCopFVUb9neGepAEtKDwEkTKWJTyXt+EwXo5Gve00EZUcWlWgS
         u5G024TCafry/CvjLIAz0m7DHGd2jeygn26SNtWeC2qx4iw5Zqz4yZdpIXHuwJmoE46Y
         YIMdwYoIkySusQKtPhW8gTFD8ZQ9/srSnWHAgqN0j5u7Qsxnay8CCbWuIygKPG6V46bh
         WAAw==
X-Gm-Message-State: AOAM530rAC7g7mSxlc1IuW9jbURUVPejmLFpabWIXrFxxF87/DymDvz4
        1uIfyPwHxCCehL2I0/rx+lhITGD3n090sw==
X-Google-Smtp-Source: ABdhPJw2WL9f/uU+TgPtY/MjXJuHHkPu5t3x2Zll+pRrWtbEbTPIWR0gCnnyIacDOnAGYcM80ggJ3A==
X-Received: by 2002:a05:620a:20d3:: with SMTP id f19mr36295421qka.304.1626883706767;
        Wed, 21 Jul 2021 09:08:26 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id z6sm11239511qke.24.2021.07.21.09.08.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 09:08:26 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jacek Szafraniec <jacek.szafraniec@nokia.com>
Subject: [PATCH net] sctp: do not update transport pathmtu if SPP_PMTUD_ENABLE is not set
Date:   Wed, 21 Jul 2021 12:08:25 -0400
Message-Id: <a0a956bbb2142d8de933d20a7a01e8ce66d048c0.1626883705.git.lucien.xin@gmail.com>
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

Fixes: 69fec325a643 ('Revert "sctp: remove sctp_transport_pmtu_check"')
Reported-by: Jacek Szafraniec <jacek.szafraniec@nokia.com>
Tested-by: Jacek Szafraniec <jacek.szafraniec@nokia.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/output.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index 9032ce60d50e..8d5708dd2a1f 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -104,8 +104,8 @@ void sctp_packet_config(struct sctp_packet *packet, __u32 vtag,
 		if (asoc->param_flags & SPP_PMTUD_ENABLE)
 			sctp_assoc_sync_pmtu(asoc);
 	} else if (!sctp_transport_pl_enabled(tp) &&
-		   !sctp_transport_pmtu_check(tp)) {
-		if (asoc->param_flags & SPP_PMTUD_ENABLE)
+		   asoc->param_flags & SPP_PMTUD_ENABLE)
+		if (!sctp_transport_pmtu_check(tp))
 			sctp_assoc_sync_pmtu(asoc);
 	}
 
-- 
2.27.0

