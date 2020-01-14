Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5FAE13A265
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 08:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbgANH5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 02:57:52 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46006 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728734AbgANH5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 02:57:52 -0500
Received: by mail-pg1-f196.google.com with SMTP id b9so5994708pgk.12
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 23:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rz+1A6+K1PzsFBhkTCJB1epd9yg/lbQ9jkVOeEMF3bA=;
        b=WKA2xbKplXk9+U7EVxjiEyxOePWsDur8y5OxbhG24UzYTyjn21JVwDI7za+TbhHpCA
         9sTjB/ChIBgk58fBPHQlYPNcPR+57/DL+El+VZh7Pj9g1yfYeyOrjaSc33kprfivRP/5
         bHsILXH0OY36TRX1ksCc1uJCWmztzEcfsIReKXgXSsW416Fd8tMGT47A3lWRO3okLQCi
         32qQ5U9B65L6v5m99XvGZkayHtl1IjMWHHCCAj2TVbmY2hwDlDj4SXrO4eVDWixDYXCd
         Y5K9rtt7+4Es5tFomqL0ZOwfU8HvgvunKNKKs7z5uUrSA5XgyuCr/LdpjcQBjbDQzhZY
         3T+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rz+1A6+K1PzsFBhkTCJB1epd9yg/lbQ9jkVOeEMF3bA=;
        b=PPb0g1RWqKH3hVelmHi4piXabKCrCtOQ4mujlIV5aOWwtuZUz3WuHbmwTp4DjlQwtZ
         45iECBThgo30wwa3x+LMwg34LnP/UN228kX039WqlRGqknX1HAYh1reVPyrTk/p1IsW9
         PJFHlCDCftJevWINdeFzU9n5yHJqiOBPPUaL/A8APYAfyPtGfCiGiEbQ35+8YoWEzvpX
         kiwa3QOqeVNl+9TsjhOP6BC3Wl8ohqAtteGEN4Uxa31Ld+sZKqvobF5xEDwXU6tV2b/q
         JbR62r6XI2IBvzCQEA3lUTRMF2VaTF8wT+V2xUTQh5olOq5efkNrem+qMoJAZ7qqPHeN
         2wrQ==
X-Gm-Message-State: APjAAAXzA1pvfuXbvx3lNiDg2s29Shsp9qZHCQV4lPLxyyaalDpYW3y+
        rAXFvNVNtWQXNXQckgFN21lVsw==
X-Google-Smtp-Source: APXvYqz4KBxXvA7TWAR4lzvTyYHOkRgwFmEqymwdpHQNTuw/iJJ6d9qIPbQ4s+AGZcJ4Uv2xErwBaQ==
X-Received: by 2002:a62:87c5:: with SMTP id i188mr24018264pfe.52.1578988671689;
        Mon, 13 Jan 2020 23:57:51 -0800 (PST)
Received: from localhost.localdomain (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id q63sm17349352pfb.149.2020.01.13.23.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 23:57:51 -0800 (PST)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Arun Kumar Neelakantam <aneela@codeaurora.org>,
        Chris Lew <clew@codeaurora.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v4 0/5] QRTR flow control improvements
Date:   Mon, 13 Jan 2020 23:56:58 -0800
Message-Id: <20200114075703.2145718-1-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to prevent overconsumption of resources on the remote side QRTR
implements a flow control mechanism.

Move the handling of the incoming confirm_rx to the receiving process to
ensure incoming flow is controlled. Then implement outgoing flow
control, using the recommended algorithm of counting outstanding
non-confirmed messages and blocking when hitting a limit. The last three
patches refactors the node assignment and port lookup, in order to
remove the worker in the receive path.

Bjorn Andersson (5):
  net: qrtr: Move resume-tx transmission to recvmsg
  net: qrtr: Implement outgoing flow control
  net: qrtr: Migrate node lookup tree to spinlock
  net: qrtr: Make qrtr_port_lookup() use RCU
  net: qrtr: Remove receive worker

 net/qrtr/qrtr.c | 319 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 247 insertions(+), 72 deletions(-)

-- 
2.24.0

