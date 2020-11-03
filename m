Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9072A39A9
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 02:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbgKCB1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 20:27:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:32908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727626AbgKCBTQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 20:19:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDB6B223C7;
        Tue,  3 Nov 2020 01:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604366355;
        bh=y/gsWimhlOriT2iB0GGb7doP5K83/bg3yp/dF94Ay/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T6xz3Kg9ZeL/oDtkl9OBh6Snt8OpsoPC7zJgLKSNBD6XJmZC69qAD2rh1okZehN/t
         PNYZgTBpeCgfqhM7chWLVY0FRqEQQdgwHUzOvkbjNMzkiZ7R5Fj6rxsCnr1rlYBXiL
         K3btErPiYUHVF51WmK4zsdGQFeVhb+qD2lEEucms=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Vander Stoep <jeffv@google.com>,
        Roman Kiryanov <rkir@google.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 26/35] vsock: use ns_capable_noaudit() on socket create
Date:   Mon,  2 Nov 2020 20:18:31 -0500
Message-Id: <20201103011840.182814-26-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201103011840.182814-1-sashal@kernel.org>
References: <20201103011840.182814-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Vander Stoep <jeffv@google.com>

[ Upstream commit af545bb5ee53f5261db631db2ac4cde54038bdaf ]

During __vsock_create() CAP_NET_ADMIN is used to determine if the
vsock_sock->trusted should be set to true. This value is used later
for determing if a remote connection should be allowed to connect
to a restricted VM. Unfortunately, if the caller doesn't have
CAP_NET_ADMIN, an audit message such as an selinux denial is
generated even if the caller does not want a trusted socket.

Logging errors on success is confusing. To avoid this, switch the
capable(CAP_NET_ADMIN) check to the noaudit version.

Reported-by: Roman Kiryanov <rkir@google.com>
https://android-review.googlesource.com/c/device/generic/goldfish/+/1468545/
Signed-off-by: Jeff Vander Stoep <jeffv@google.com>
Reviewed-by: James Morris <jamorris@linux.microsoft.com>
Link: https://lore.kernel.org/r/20201023143757.377574-1-jeffv@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/af_vsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 9e93bc201cc07..b4d7b8aba0037 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -739,7 +739,7 @@ static struct sock *__vsock_create(struct net *net,
 		vsk->buffer_min_size = psk->buffer_min_size;
 		vsk->buffer_max_size = psk->buffer_max_size;
 	} else {
-		vsk->trusted = capable(CAP_NET_ADMIN);
+		vsk->trusted = ns_capable_noaudit(&init_user_ns, CAP_NET_ADMIN);
 		vsk->owner = get_current_cred();
 		vsk->connect_timeout = VSOCK_DEFAULT_CONNECT_TIMEOUT;
 		vsk->buffer_size = VSOCK_DEFAULT_BUFFER_SIZE;
-- 
2.27.0

