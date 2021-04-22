Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 343233681FE
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 15:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236618AbhDVN5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 09:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236570AbhDVN5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 09:57:24 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8158CC06174A
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 06:56:48 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id j5so43932440wrn.4
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 06:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=610Onpi5irXS0g4Z+ajtyAB4fG1jJoO8U7+UMTinTyE=;
        b=wIzkhXBrR+eDRhCsVgiBIc+iaaJr5vPkMcszyl471bmbuBfdy8zUjS6PycWvGLZ5ON
         uA5PYjOvgMSvqoQ+JTS7qpNmEzA16dT7WiM9AYXuvUhdRoBvwtl3RdsSUo/QEFxYhygX
         no9OidNv0lnKbt15BdPfvJoFw1EdqRVq1eEKA80pdwzshrGJYpQdmuqWLi/49DpgayXM
         LOzqj4hMFRN4k4rWyAn9QRL4CHb96U8qHXhrHMzGmSguQkMPQ24cX5Q//mkWrftD/xnc
         y5Vm35Jzn4/vNRHWAF1Mx9kr1knd3FL5iRMpTWLLnlavTOA8N0C6xyMIjdjuQh1MMaiT
         NI2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=610Onpi5irXS0g4Z+ajtyAB4fG1jJoO8U7+UMTinTyE=;
        b=Y0b3djpASFt3CZ7VXaqE7wG8p94XpsNJljf6Gd/rn2GVH8Zchyky5eTFWuLeh96ftp
         UYIB6FzzMyXfbtidimMfXiYw2rSQnJP8FxBSr5jZqbTlvYldPaicPYp4c1GM4VKSBdhx
         JBtkSPrt3VoGsEp1sjOPSQPw+I3aCjjIzhFx6bPUEFZ7W0tJBHuIDTLYQJiHwJGmH0So
         Iv24G+5xXVIoTkczWcOjx0eTSLAcnBaCjAbJ7mfj5GZazFSy3ZZjkBKMo2o/jZQ+DLKW
         B9tk5PCX5hPc/NQJsMBCACkrBum1cwVMe2mpph1WAxTHAxO+4DUtpef33lD7c+FTZK4k
         z0wQ==
X-Gm-Message-State: AOAM531Ipecivj1hOQtI/QIZfKEEMp3xjo8neF7JDur8Jm1SxnP35hXm
        He/hVXSJfoQ+QKAskwizGUfuFA==
X-Google-Smtp-Source: ABdhPJyoRZrif2NANeQYY3tbCj1Ob0aEcBSIRUICt//cm06mhUtPNMG8M8TolFS8mhmeyTuC5gOcbQ==
X-Received: by 2002:adf:dd08:: with SMTP id a8mr4329138wrm.252.1619099807175;
        Thu, 22 Apr 2021 06:56:47 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:d197:cfbe:5a91:301])
        by smtp.gmail.com with ESMTPSA id r2sm3530340wrt.79.2021.04.22.06.56.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Apr 2021 06:56:46 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net, leon@kernel.org
Cc:     netdev@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v2] net: wwan: core: Return poll error in case of port removal
Date:   Thu, 22 Apr 2021 16:06:01 +0200
Message-Id: <1619100361-1330-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ensure that the poll system call returns proper error flags when port
is removed (nullified port ops), allowing user side to properly fail,
without further read or write.

Fixes: 9a44c1cc6388 ("net: Add a WWAN subsystem")
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 v2: get rid of useless locking for accessing port->ops

 drivers/net/wwan/wwan_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 5be5e1e..cff04e5 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -508,6 +508,8 @@ static __poll_t wwan_port_fops_poll(struct file *filp, poll_table *wait)
 		mask |= EPOLLOUT | EPOLLWRNORM;
 	if (!is_read_blocked(port))
 		mask |= EPOLLIN | EPOLLRDNORM;
+	if (!port->ops)
+		mask |= EPOLLHUP | EPOLLERR;
 
 	return mask;
 }
-- 
2.7.4

