Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 482747F58A
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 12:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733053AbfHBKzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 06:55:07 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44789 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbfHBKzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 06:55:07 -0400
Received: by mail-pg1-f196.google.com with SMTP id i18so35890968pgl.11;
        Fri, 02 Aug 2019 03:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DIqOI2KhnovE2Wnn/sL/EUNF3A52jl9llVbTYD86JMc=;
        b=srMJDRVV8ygDsohT0GoVuEcKCpACjwtqHx6wxeRhf8dlMqfZgWenGwR3OhfdebtaPn
         7KxUDWtnLUEjat1S8i1wsaYqGkjsrj7IWyhKZIGULZ/jnwjvLkhBk26tdtqCyYyZa89y
         cWRKBS2/4Soe06tTBS0S93QKwqcgm4ECGKhzpNLxGGBnSyfwe4TOtp35XknKVbTjjVSI
         pmMurfmHTPw37WouScJHwO65WdJmWZ5Lr3Zi9f0eIU9L2SHkrSGRMVSVG3+WFcZHeP+U
         Q9TF4i/8l7KWsIoQLSolkikbA13CHToGCC9S6MNnN+0X0dYBBxzu6uPISFglsMMc2B4A
         /5ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DIqOI2KhnovE2Wnn/sL/EUNF3A52jl9llVbTYD86JMc=;
        b=oQm3yDGaCfnDNGZ93ItYTDfMeUorhCyAADkaFTFYD7xDhWpmiYMyDwWjN1oX3sKqcK
         RftIeUw6677P4/AZEKJcF8kNNPjUyVa0O9fR3Jf8G+f8Ed/huHg90hWKAbQoYAUXl9VV
         xf5Hcr7nbnEmdh1SI3PLce8+2BxlFdZdpEAT6RxFgRYYQNHwejmnu08sXdNuH1vfqBZz
         y820ViAJ50Z2PfP4LvtvETV43FHrJy0b1t5+kBGhCi84Xm/cpS5AIOCkdM8ZpxCOmgSN
         JR1zf4IlyLQyM5yLCYwZdH9WZRKxnET1k9zfGUc9xrUYc1v8qkGSuNaW5tODPJYGplhM
         NutQ==
X-Gm-Message-State: APjAAAVpsixkP4Y2i1QhxyiC6pOLArb6BzD2vaeXrPE7rV8SEH3J+6PN
        hAyY3ufagsbYoiTk9uzkgBc=
X-Google-Smtp-Source: APXvYqwMFjm28/XJVWXgLOL7J4uLlnk5tcztUOTOT97vTba5XRvZcyegYR38vqyrRvSWGSOFZ8sPeQ==
X-Received: by 2002:a63:b555:: with SMTP id u21mr125832838pgo.222.1564743306326;
        Fri, 02 Aug 2019 03:55:06 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id q69sm10647674pjb.0.2019.08.02.03.55.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 03:55:05 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH 1/2] ixgbe: Explicitly initialize reference count to 0
Date:   Fri,  2 Aug 2019 18:54:57 +0800
Message-Id: <20190802105457.16596-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver does not explicitly call atomic_set to initialize
refcount to 0.
Add the call so that it will be more straight forward to
convert refcount from atomic_t to refcount_t.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
index ccd852ad62a4..00710f43cfd2 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
@@ -773,6 +773,7 @@ int ixgbe_setup_fcoe_ddp_resources(struct ixgbe_adapter *adapter)
 
 	fcoe->extra_ddp_buffer = buffer;
 	fcoe->extra_ddp_buffer_dma = dma;
+	atomic_set(&fcoe->refcnt, 0);
 
 	/* allocate pci pool for each cpu */
 	for_each_possible_cpu(cpu) {
-- 
2.20.1

