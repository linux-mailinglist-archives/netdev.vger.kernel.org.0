Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B162A9ABB
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 18:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgKFR1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 12:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbgKFR1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 12:27:07 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4536EC0613CF
        for <netdev@vger.kernel.org>; Fri,  6 Nov 2020 09:27:07 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id v5so2207148wmh.1
        for <netdev@vger.kernel.org>; Fri, 06 Nov 2020 09:27:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=yXm0xOR5OX89U7FdRHq+y/V+ys5qn2trNwjFl4kc4pg=;
        b=qi48DDrUGKKk4FN4+ns8paiZrgtdd8Tot2xquWY7sAJS9rvuXA1skHUX6NjUQ7RbGJ
         Nupv6jkEPoBHahsGboDe4sMUcJQqUikBHV2iYToi/Mr3sTqUxhZVjQn1+zIQgO9pAs7j
         WYN0IZwbQZ3J48AEJdUdt4X0RC3ZYz5jyGK7rud/2CjSSu+JJs+BjwAOKMi49pRWCpZ/
         zqCqVdwFVrPOkAU+iu/LXgeQc3xPPEqpw25K8VotSV2uZyYk+cgb2uQaxIWf8K4yEnNR
         1/YE5fb77kIujnmElhsWtM3YkLa6U23DkWZkV29BOznDuVJyjtf9F7N23OPG8r4RCnxJ
         EQww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yXm0xOR5OX89U7FdRHq+y/V+ys5qn2trNwjFl4kc4pg=;
        b=QybBt8koyr0AKUpGSUviK2PIWSwLW1scyqpGeGeW4UbTLZ0ygQWReNUEKWAGfE6p7a
         Ss1hsp8llMMq6LO3g3klTN2/wrzUpzQuhYLvt58CD1rZYlvOEnpnn77cuCCQtSRpQXS1
         jhVhob68tOqA/i7F3qwxmcLf49PG8i+l4dy6jnm4k9huYwZ4R+itBHF7f1Qr20hHYPqT
         w/2l/3Obea0xpg4ti2ifc2cy0ss4KU+CJGOKUrmx0iS1TTaqd3h2aJfy+pcldsnC858k
         ZdS4WdcCdw54JJSKjBPfingSZN5FQ2l7CXppKtWmC1/t7pWQ4uReIVWTVmyDbP+0Bgjr
         rccA==
X-Gm-Message-State: AOAM533ioEtFTGuYkmnyXu/gw81c3HYUNG6kFnCk0TA2oKdiHkqT5ys6
        AilK8Ht0sbrR5dPdfz2aPs+CMg==
X-Google-Smtp-Source: ABdhPJwc7+07pE0P7DZXQ9MGA3aPf+2c3WClaee/Uz24R2bdlpxVdnrjEra0qScYxpUMKdjzWRlSAA==
X-Received: by 2002:a05:600c:2949:: with SMTP id n9mr640578wmd.29.1604683625004;
        Fri, 06 Nov 2020 09:27:05 -0800 (PST)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id z191sm3183266wme.30.2020.11.06.09.27.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Nov 2020 09:27:04 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, manivannan.sadhasivam@linaro.org,
        cjhuang@codeaurora.org, netdev@vger.kernel.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH v2 0/5] net: qrtr: Add distant node support
Date:   Fri,  6 Nov 2020 18:33:25 +0100
Message-Id: <1604684010-24090-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QRTR protocol allows a node to communicate with an other non-immediate 
node via an intermdediate immediate node acting as a 'bridge':

node-0 <=> node-1 <=> node-2

This is currently not supported in this upstream version and this
series aim to fix that.

This series is V2 because changes 1, 2 and 3 have already been submitted
separately on LKML.

Changes in v2:
- Add reviewed-by tags from Bjorn and Mani
- Fixing checkpatch issue reported by Jakub

Loic Poulain (5):
  net: qrtr: Fix port ID for control messages
  net: qrtr: Allow forwarded services
  net: qrtr: Allow non-immediate node routing
  net: qrtr: Add GFP flags parameter to qrtr_alloc_ctrl_packet
  net: qrtr: Release distant nodes along the bridge node

 net/qrtr/ns.c   |  8 --------
 net/qrtr/qrtr.c | 51 ++++++++++++++++++++++++++++++++++++++-------------
 2 files changed, 38 insertions(+), 21 deletions(-)

-- 
2.7.4

