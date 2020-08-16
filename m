Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540EF245719
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 11:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729054AbgHPJcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 05:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgHPJcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 05:32:13 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9156C061786
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 02:32:12 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id u10so6045881plr.7
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 02:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6YIUHvdCuePmezsZ/M+kr5KBJxQIzparQxYUwNvyjsI=;
        b=c7t2dLMQ85deKkMwdIe1OfsuyJMreMatbLpue3gHsz0/ZQnTMSRa+oj73xFUsm3RLO
         R7On+E1lqy++aVXkGLWDSUXDEEp9cB/ponsG5lQbCbIl0dnnRUYXARl8wsoCUStBheoy
         Sd7HTbQOBSprU23hLq16G+w7jlRzQonJqocIi0QdzkjpPc8gydKhVkoEnkeY8oq2bNFb
         WV4H8rx+AIetDhAhZvvlVa2I2K7j7L4Q8MLFqRlDyBOnbrpEyuxdt8nZ8Qv7DCHvYmxr
         qNIlY3ERBMfwfG2qP6r5sM2/yWy3lydZu2s77yXzjmspOAKbXBEms2qAReZ6uHat8bLm
         V9Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6YIUHvdCuePmezsZ/M+kr5KBJxQIzparQxYUwNvyjsI=;
        b=S0j4PEn+2Rp6je4gz8ga69QoPeAV+nczY24+EjQJfsCtRkipN86L1oX9z+mf+HARoe
         EOSQVc4+xQFo4jm4xFw0ChXCbyD2P921JkaSp4d5NhyDlUQuSSzgiNIVytY1ko8ew170
         jSdrcVYnUp3s2G7w12wpxVoWfnTkjHpeMRfqN4Th0XunvHIokiXGvAMd5MKu1SSbQ0nF
         DJHRbOj/r/8iA2G4H8Z55btGfsJJqOlkQwN/A/q+bHNP+0I3VcxgBLn7AdcQSuV9QP6P
         wBmZqimDPh6Z5BFTJqf+bV15Ft+FRioQF7jYhL1ijyaeF+b8zw3mzqJqaOr6LIrkAAfR
         ipJw==
X-Gm-Message-State: AOAM532ZcyN1VqcFtfK2uQCwzlvtrV2yLckkHTmA0HLniZ5wMSvvNjfj
        DUwK8zRqQrSRiW4eyjLgZaHbdTFPvhl1wQ==
X-Google-Smtp-Source: ABdhPJz+gAu0iA5RMtNtDn2BLUxZhuIs/n2N8HQ0WUyb6SKC3dF+iu8SdkCR4R6r0p2TxQ8nYMBI8g==
X-Received: by 2002:a17:902:a50e:: with SMTP id s14mr7200964plq.164.1597570331287;
        Sun, 16 Aug 2020 02:32:11 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id jb1sm13578308pjb.9.2020.08.16.02.32.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Aug 2020 02:32:10 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH net] tipc: not enable tipc when ipv6 works as a module
Date:   Sun, 16 Aug 2020 17:32:03 +0800
Message-Id: <d20778039a791b9721bb449d493836edb742d1dc.1597570323.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using ipv6_dev_find() in one module, it requires ipv6 not to
work as a module. Otherwise, this error occurs in build:

  undefined reference to `ipv6_dev_find'.

So fix it by adding "depends on IPV6 || IPV6=n" to tipc/Kconfig,
as it does in sctp/Kconfig.

Fixes: 5a6f6f579178 ("tipc: set ub->ifindex for local ipv6 address")
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/tipc/Kconfig b/net/tipc/Kconfig
index 9dd7802..be1c400 100644
--- a/net/tipc/Kconfig
+++ b/net/tipc/Kconfig
@@ -6,6 +6,7 @@
 menuconfig TIPC
 	tristate "The TIPC Protocol"
 	depends on INET
+	depends on IPV6 || IPV6=n
 	help
 	  The Transparent Inter Process Communication (TIPC) protocol is
 	  specially designed for intra cluster communication. This protocol
-- 
2.1.0

