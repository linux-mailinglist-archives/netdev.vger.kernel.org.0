Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6D9269389
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 19:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgINRfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 13:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbgINR03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 13:26:29 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28CBC06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 10:26:28 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id p187so451365ybg.14
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 10:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=N7ud6SVmQsyeAo1FFabO4II1hmbm33EQsopeZ69GJts=;
        b=u6zTyYRqKGoaz6mBSCvkfnvI+0iG3USvJ/2orh5uqMIK9Ty23zTEg4Eepbmhfy+oN3
         FIX918dyhMIQ524UpViV99xoLz5XC4LAEd8Pp6G7tHYfvfUT3wwSq+QXs82NCCSsijY+
         xzptmcUEoU/vYjWdEVLadLcfbHNKDuKGy8A/oV0oqx1jqhXNpQOp4pfYLbk6NX6eJ4pl
         GpVPeyNbZD5iV3SWzvmGW1SGehwbLZ4YzI1T3rd4yW43lYmRPAgvWvSJ9/r/XjNrMonL
         XhkDelr4x+dLtgDew1ddbiGP2/+kPBDHoKg/uwW/6tN39AGzZbyC/+MTs1ZiAXeLw9jn
         LtnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=N7ud6SVmQsyeAo1FFabO4II1hmbm33EQsopeZ69GJts=;
        b=TVpN1H7yfgmpSvQonMPimnVwARYZD95Voi56COk3Rp5ftqiOnMpA4ahgEGpeAyNOr3
         bQfa3Vm2KUbNRrlSBgscADwQugw8N027EGiSuYHlFoKCX1UYKodX+fXFZaJuiCmrnFJ2
         DqoWu7yBUbHOoKHrnyW7jJWu4YnpeqA2qWKoOPDzkRLxlplg8IGFeF5C+G8539gL00Nu
         UHVW6s+t+pUN0lPVc4/Vdd5XSIuPEOKz7rr2IK08yLLUXsUsqldUXEW4S30iSpxxWIJv
         0OoQ1BEpg+0WJAu6F6V57SrVOqArqeOpkNuVBn+A5Y8LXklzypHsl7njgfWcpcinUuOv
         l/Hg==
X-Gm-Message-State: AOAM5332tbdp5HnxzbaG9fe/gAE5rqIUwlaf3RPi/rmElHb0rBWUj+VW
        FTh6Lt+zLEF4Bh8h6B4RwhrCh580zig=
X-Google-Smtp-Source: ABdhPJyV8DDlE5ivVzjfIvgNKZ18IxkPOYGk0n9VAYweLKxZKilu6XpGHOJ9AdlIsYjx1HOSSJOt34Egi+U=
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a25:ae9e:: with SMTP id b30mr7629296ybj.281.1600104388111;
 Mon, 14 Sep 2020 10:26:28 -0700 (PDT)
Date:   Mon, 14 Sep 2020 10:24:52 -0700
In-Reply-To: <20200914172453.1833883-1-weiwan@google.com>
Message-Id: <20200914172453.1833883-6-weiwan@google.com>
Mime-Version: 1.0
References: <20200914172453.1833883-1-weiwan@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [RFC PATCH net-next 5/6] net: process RPS/RFS work in kthread context
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>, Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

This patch adds the missing part to handle RFS/RPS in the napi thread
handler and makes sure RPS/RFS works properly when using kthread to do
napi poll.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Wei Wang <weiwan@google.com>
---
 net/core/dev.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index be676c21bdc4..ab8af727058b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6820,6 +6820,7 @@ static int napi_thread_wait(struct napi_struct *napi)
 static int napi_threaded_poll(void *data)
 {
 	struct napi_struct *napi = data;
+	struct softnet_data *sd;
 	void *have;
 
 	while (!napi_thread_wait(napi)) {
@@ -6835,6 +6836,12 @@ static int napi_threaded_poll(void *data)
 			__kfree_skb_flush();
 			local_bh_enable();
 
+			sd = this_cpu_ptr(&softnet_data);
+			if (sd_has_rps_ipi_waiting(sd)) {
+				local_irq_disable();
+				net_rps_action_and_irq_enable(sd);
+			}
+
 			if (!repoll)
 				break;
 
-- 
2.28.0.618.gf4bc123cb7-goog

