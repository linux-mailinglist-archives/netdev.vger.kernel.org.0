Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE70C1D5B96
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 23:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbgEOV3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 17:29:46 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42173 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727904AbgEOV3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 17:29:05 -0400
Received: by mail-pf1-f196.google.com with SMTP id y18so1595189pfl.9;
        Fri, 15 May 2020 14:29:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qxlVajjfNXCuVHnmE5Xgl/OMrJvTtdBFsSisnAsjai4=;
        b=cjNh+5CWfFuHJmEkhtQZTa8V2Er32bR+QtLu4ooAgibXEBJ5yuZtVzohKHLeNYSCbw
         0PrTOvVCRuw47szXz+aWI/f4+GMaYgGCyjiL6gsfgzG/DoH5IoH9NM9Sb0+aIVmTLUtP
         9w6H82f40HsQ0Ia8QXSOd0rYiR83Qgy6kTU1OEz6bPz+Faqv1hVU80CjGR7zFw6CdBnn
         TnQsxOt7+ZdVzqbF//bGArm5msWhmmYTCa7H/UXfF4C9b+zFNb4WJbv7Ph4jG85L1KjO
         pYPDr6DMkhiizXqYr2trL3sJ2VzcuMIzonCmNCNjPQSDTQ6mA1mc4N7a+Rp4DuuVrRlF
         Mbag==
X-Gm-Message-State: AOAM532knxrDHsbGmcGFNDomaa7TlvU9rDxHe9P2WR+I1Ea3ELWVA8vi
        WMKC1ypzdFpmPa4L/OY5zJs=
X-Google-Smtp-Source: ABdhPJxQ0KFVYL9S7FuI8AkItqLd45YmQBv/URE7CupJdOWl8x9JUhRFuhp/9RSwH2FI5AIrP9WBbw==
X-Received: by 2002:a65:560f:: with SMTP id l15mr2568395pgs.439.1589578143709;
        Fri, 15 May 2020 14:29:03 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id cc8sm2217831pjb.11.2020.05.15.14.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 14:28:55 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 19BE342341; Fri, 15 May 2020 21:28:50 +0000 (UTC)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     jeyu@kernel.org
Cc:     akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com, tiwai@suse.de,
        schlad@suse.de, andriy.shevchenko@linux.intel.com,
        keescook@chromium.org, daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
        linux-wimax@intel.com,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Subject: [PATCH v2 11/15] wimax/i2400m: use new module_firmware_crashed()
Date:   Fri, 15 May 2020 21:28:42 +0000
Message-Id: <20200515212846.1347-12-mcgrof@kernel.org>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20200515212846.1347-1-mcgrof@kernel.org>
References: <20200515212846.1347-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes use of the new module_firmware_crashed() to help
annotate when firmware for device drivers crash. When firmware
crashes devices can sometimes become unresponsive, and recovery
sometimes requires a driver unload / reload and in the worst cases
a reboot.

Using a taint flag allows us to annotate when this happens clearly.

Cc: linux-wimax@intel.com
Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/net/wimax/i2400m/rx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wimax/i2400m/rx.c b/drivers/net/wimax/i2400m/rx.c
index c9fb619a9e01..307a62ca183f 100644
--- a/drivers/net/wimax/i2400m/rx.c
+++ b/drivers/net/wimax/i2400m/rx.c
@@ -712,6 +712,7 @@ void __i2400m_roq_queue(struct i2400m *i2400m, struct i2400m_roq *roq,
 	dev_err(dev, "SW BUG? failed to insert packet\n");
 	dev_err(dev, "ERX: roq %p [ws %u] skb %p nsn %d sn %u\n",
 		roq, roq->ws, skb, nsn, roq_data->sn);
+	module_firmware_crashed();
 	skb_queue_walk(&roq->queue, skb_itr) {
 		roq_data_itr = (struct i2400m_roq_data *) &skb_itr->cb;
 		nsn_itr = __i2400m_roq_nsn(roq, roq_data_itr->sn);
-- 
2.26.2

