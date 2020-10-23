Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 423E7296E50
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 14:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S463577AbgJWMVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 08:21:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34680 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2508061AbgJWMVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 08:21:20 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kVw4I-00018V-5A; Fri, 23 Oct 2020 12:21:14 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] vsock: ratelimit unknown ioctl error message
Date:   Fri, 23 Oct 2020 13:21:13 +0100
Message-Id: <20201023122113.35517-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

When exercising the kernel with stress-ng with some ioctl tests the
"Unknown ioctl" error message is spamming the kernel log at a high
rate. Rate limit this message to reduce the noise.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/vmw_vsock/af_vsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 9e93bc201cc0..b8feb9223454 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -2072,7 +2072,7 @@ static long vsock_dev_do_ioctl(struct file *filp,
 		break;
 
 	default:
-		pr_err("Unknown ioctl %d\n", cmd);
+		pr_err_ratelimited("Unknown ioctl %d\n", cmd);
 		retval = -EINVAL;
 	}
 
-- 
2.27.0

