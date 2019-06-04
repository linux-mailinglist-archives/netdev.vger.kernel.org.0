Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A128346BC
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 14:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727676AbfFDMai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 08:30:38 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44339 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbfFDMag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 08:30:36 -0400
Received: by mail-pf1-f194.google.com with SMTP id t16so3779705pfe.11;
        Tue, 04 Jun 2019 05:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6HDzC7R+RL6DjYFySUs1ztmYGpeRF4flURMQGfgz8ek=;
        b=WoQIZydCeh0fjhw/TBqjgdAJFJ96KSB7ecnpoTGfCGUFFp6p0gFO/2EHv5Y2kolD+Q
         lDco3Su5Wue2nWstBr/2r+eJW3tn1R1JY2QGvq8qExTzsZIFPhYSkrILFlr5Hd/0PXUx
         8KfrWiaa+Zlr6zYs3Am+KCtcQknBt6bFUGhFfwri77WfemH+ofLLqRet2GVUpgCl+Sv1
         BCAe+LRvB7hEOVK1UdZ0NufKGKr/V9m88LANh+GaRsVU88aYtwpm8Qf+bAiyI3EfFq6i
         4IoBqjleCPWP5Uz7HwYsPwr8tU/Ny3j+Djv7Cd9OLJmSY/oARV6zsR0WmXbyP+4qpcrV
         6WIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6HDzC7R+RL6DjYFySUs1ztmYGpeRF4flURMQGfgz8ek=;
        b=KYbDH5YTCv50NCiGVkglKy98hnZCZ+iFe39bkL2jVmctlMA1MMa12QrXY3Lfaf/POZ
         g7Udv7ts3cW+MiI6aUl/ViSBw/dNoebd8j1V9cF1MrDIZwXUlihiFdLIg5yEPqXrhRke
         Pv57G9QW0edF5/+eiCxDLoVYhSfhIuv/9E0oe+rU2iWYuT6cy3Zei5AdBuAi72xdfP7z
         fd7pXPIu2L8GJCmdYll5cF2fdCAdOmS+7Y+OxfCOxAGXWP8Ul6VW2y3alOnnkq7PZKIG
         1RDw7nAjPRWNSPzSg9aFHtwxN9zxH9e78n1/4mCuIb5GNbwu/wjoEYzyyAHgeZCXeqYe
         wJZQ==
X-Gm-Message-State: APjAAAUq4GbTQrQUyiiJOhcnhrWK/JMEfukV8c1jyYHbZtv8VaMDOHjw
        Ga++/NQhoggqrLv/OygkdK0650gG0Y1wpQ==
X-Google-Smtp-Source: APXvYqzHSIHm/1koK1BcMvII16jWLBiHbG3UWezHUTm0cJw0OrhwD/SCv+JPrmVq8uQLxhzJgORt1w==
X-Received: by 2002:a17:90a:35c:: with SMTP id 28mr35237599pjf.110.1559651435842;
        Tue, 04 Jun 2019 05:30:35 -0700 (PDT)
Received: from xy-data.openstacklocal (ecs-159-138-22-150.compute.hwclouds-dns.com. [159.138.22.150])
        by smtp.gmail.com with ESMTPSA id f10sm23734078pgo.14.2019.06.04.05.30.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 04 Jun 2019 05:30:35 -0700 (PDT)
From:   Young Xiao <92siuyang@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Young Xiao <92siuyang@gmail.com>
Subject: [PATCH] net: compat: fix msg_controllen overflow in scm_detach_fds_compat()
Date:   Tue,  4 Jun 2019 20:31:45 +0800
Message-Id: <1559651505-18137-1-git-send-email-92siuyang@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a missing check between kmsg->msg_controllen and cmlen,
which can possibly lead to overflow.

This bug is similar to vulnerability that was fixed in commit 6900317f5eff
("net, scm: fix PaX detected msg_controllen overflow in scm_detach_fds").

Signed-off-by: Young Xiao <92siuyang@gmail.com>
---
 net/compat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/compat.c b/net/compat.c
index a031bd3..8e74dfb 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -301,6 +301,8 @@ void scm_detach_fds_compat(struct msghdr *kmsg, struct scm_cookie *scm)
 			err = put_user(cmlen, &cm->cmsg_len);
 		if (!err) {
 			cmlen = CMSG_COMPAT_SPACE(i * sizeof(int));
+			if (kmsg->msg_controllen < cmlen)
+				cmlen = kmsg->msg_controllen;
 			kmsg->msg_control += cmlen;
 			kmsg->msg_controllen -= cmlen;
 		}
-- 
2.7.4

