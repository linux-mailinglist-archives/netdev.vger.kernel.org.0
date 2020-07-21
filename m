Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 401542286F6
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730572AbgGUROq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:14:46 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:14780 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730510AbgGUROp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 13:14:45 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1595351684; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=wHZHpcJq6IQCRL0ELXQS25dwFzpXsMpPaN59eDhrOwE=; b=Gwye8wk0x5sURVZ6grSGM2O8brJ1Bd9bIg0990I6esY5OiyhDT9+C5E0xK5JJx0SgYvpdN6I
 IBvrvhcObv69LzeiLCeqoGet9cahhu4DJLSL2vAwePq5Dvy/REPMFpLdqygfDAByrgzNsOTX
 5YX2LzOoTBrYW8fcI8phh4yEQUs=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 5f172283ed710aec6255b505 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 21 Jul 2020 17:14:43
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2BCDCC433A1; Tue, 21 Jul 2020 17:14:43 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from pillair-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pillair)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8E2A5C433CB;
        Tue, 21 Jul 2020 17:14:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8E2A5C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvalo@codeaurora.org, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dianders@chromium.org, evgreen@chromium.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [RFC 0/7] Add support to process rx packets in thread
Date:   Tue, 21 Jul 2020 22:44:19 +0530
Message-Id: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NAPI gets scheduled on the CPU core which got the
interrupt. The linux scheduler cannot move it to a
different core, even if the CPU on which NAPI is running
is heavily loaded. This can lead to degraded wifi
performance when running traffic at peak data rates.

A thread on the other hand can be moved to different
CPU cores, if the one on which its running is heavily
loaded. During high incoming data traffic, this gives
better performance, since the thread can be moved to a
less loaded or sometimes even a more powerful CPU core
to account for the required CPU performance in order
to process the incoming packets.

This patch series adds the support to use a high priority
thread to process the incoming packets, as opposed to
everything being done in NAPI context.

The rx thread can be enabled by using a module parameter
when loading the ath10k_snoc module.

---
This patch series is dependent on the below patch series
https://patchwork.kernel.org/project/ath10k/list/?series=315759

Rakesh Pillai (7):
  mac80211: Add check for napi handle before WARN_ON
  ath10k: Add support to process rx packet in thread
  ath10k: Add module param to enable rx thread
  ath10k: Do not exhaust budget on process tx completion
  ath10k: Handle the rx packet processing in thread
  ath10k: Add deliver to stack from thread context
  ath10k: Handle rx thread suspend and resume

 drivers/net/wireless/ath/ath10k/core.c   |  64 +++++++++++++++++++
 drivers/net/wireless/ath/ath10k/core.h   |  33 ++++++++++
 drivers/net/wireless/ath/ath10k/htt.h    |   2 +
 drivers/net/wireless/ath/ath10k/htt_rx.c |  66 ++++++++++++++-----
 drivers/net/wireless/ath/ath10k/snoc.c   | 105 ++++++++++++++++++++++++++++++-
 net/mac80211/rx.c                        |   2 +-
 6 files changed, 253 insertions(+), 19 deletions(-)

-- 
2.7.4

