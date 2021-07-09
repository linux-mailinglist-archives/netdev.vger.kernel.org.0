Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B44C53C1ECC
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 07:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhGIFUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 01:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhGIFUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 01:20:14 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BD03C061760
        for <netdev@vger.kernel.org>; Thu,  8 Jul 2021 22:17:30 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id 14so8238933qkh.0
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 22:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NB1v97X61LcR+bQP4YdVYSajidLRnhVKIwAUWS1fBmc=;
        b=f4kffD1+3VzHN1XyN69a6F/6ILDHjzVpohqXUjDLkHPoevjfHO58v8nQsYFv6ICqFg
         LFtA+VY5dUjgyn8lAU9qc2g61+9VY17y5+y9TOil89u5fukRKVWUCZ+JEh6AstM0l76h
         IJIy+1s6ew4xnb6N2y3l76s3thZ/NtiPZc8nw913H65PGR+oSj0JRzW9IuWGyVB6VFRn
         PaRtZOvFjvKiLGhJ5HxAw/a6A0ZYzxDScxssvSrAasJpIeYt9gayY8iyw3j+bUwcqUJS
         55ZSmPMy6MFDuTLWOYLNv7VCFlLB8cqtaz6sEXxXudCNNXXJAKu8MvmzEzV50mAJ9VAY
         XP6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NB1v97X61LcR+bQP4YdVYSajidLRnhVKIwAUWS1fBmc=;
        b=oHfjgTfLXDN99BLb71MC/g2BtX6zbNgEgydy2S62Sywp9nWrqkjtHYSaOJwbC/sZTL
         uz6o8B5jl/QYQq58g/oZ9U95D8jOIiqhWk4aJIJSUjO0AJrqjHcLFIhtQEdvE550OMRD
         Rqo5kMkZ6tCAO3r+3jqwftwldeR8s/xy3upRjSnBoPa21Us7csyBJfhZD/MSseohSlqx
         e3x/v0YeJP7CvWUwGKEUvcamds677WM0wHuFa5D+MsgJUHIcejVk8zuJCTDtV/vFDkM0
         uXyzoh8UeWPGP0tMeRiFAHdntPctl1SjLPmBwaK16lhAQUGick/xY9fxrdpiCjK3D8kc
         VFpg==
X-Gm-Message-State: AOAM5314gmcsoEEhJ4pf+fFSfvfHt7T3D2zUfnvpj/VFTsKAT73Sm5ES
        1MqhHaFjl+GkmKYLYJ+qlGeLf43Yg50=
X-Google-Smtp-Source: ABdhPJzZdVOYrqj8n3YP60I0SuOUaYyOE8NI7bh8XOOTHeTsZXWuAfJANboRsK5/Dgjdqbh6C+CWSg==
X-Received: by 2002:a37:c204:: with SMTP id i4mr17943541qkm.284.1625807849698;
        Thu, 08 Jul 2021 22:17:29 -0700 (PDT)
Received: from unknown.attlocal.net (76-217-55-94.lightspeed.sntcca.sbcglobal.net. [76.217.55.94])
        by smtp.gmail.com with ESMTPSA id y9sm2028246qkb.3.2021.07.08.22.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 22:17:29 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch net-next] net_sched: use %px to print skb address in trace_qdisc_dequeue()
Date:   Thu,  8 Jul 2021 22:17:09 -0700
Message-Id: <20210709051710.15831-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210709051710.15831-1-xiyou.wangcong@gmail.com>
References: <20210709051710.15831-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qitao Xu <qitao.xu@bytedance.com>

Print format of skbaddr is changed to %px from %p, because we want
to use skb address as a quick way to identify a packet.

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
---
 include/trace/events/qdisc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/qdisc.h b/include/trace/events/qdisc.h
index 330d32d84485..58209557cb3a 100644
--- a/include/trace/events/qdisc.h
+++ b/include/trace/events/qdisc.h
@@ -41,7 +41,7 @@ TRACE_EVENT(qdisc_dequeue,
 		__entry->txq_state	= txq->state;
 	),
 
-	TP_printk("dequeue ifindex=%d qdisc handle=0x%X parent=0x%X txq_state=0x%lX packets=%d skbaddr=%p",
+	TP_printk("dequeue ifindex=%d qdisc handle=0x%X parent=0x%X txq_state=0x%lX packets=%d skbaddr=%px",
 		  __entry->ifindex, __entry->handle, __entry->parent,
 		  __entry->txq_state, __entry->packets, __entry->skbaddr )
 );
-- 
2.27.0

