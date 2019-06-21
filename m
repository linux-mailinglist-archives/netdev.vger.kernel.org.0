Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 808A44F034
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 22:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbfFUUzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 16:55:12 -0400
Received: from home.regit.org ([37.187.126.138]:38348 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbfFUUzM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jun 2019 16:55:12 -0400
X-Greylist: delayed 2500 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Jun 2019 16:55:12 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=regit.org};
         s=home; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:Cc:
        To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=C9uzwKrfHDr8Db0GIiZYGqrcD2DgBTe3zpleN7Nb+Jk=; b=Txk+ppO4h76i60ylzHCOIoMgD3
        qmZXxkufxllww+I47v/jHyffTfyvZAbZAQ0rOxTt4y56sMEFdBfINymv0tHgRjEAKZBYIPYrZqZYF
        Mw2uSvlr0hjG6JX8hLRQy2zlF;
Received: from [2a01:e34:ee97:b130:1a31:bfff:feb2:f9d5] (helo=localhost.localdomain)
        by home.regit.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <eric@regit.org>)
        id 1hePua-0001Q1-QM; Fri, 21 Jun 2019 22:13:31 +0200
From:   Eric Leblond <eric@regit.org>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Eric Leblond <eric@regit.org>
Subject: [PATCH] xsk: sample kernel code is now in libbpf
Date:   Fri, 21 Jun 2019 22:13:10 +0200
Message-Id: <20190621201310.12791-1-eric@regit.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.0 (-)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix documentation that mention xdpsock_kern.c which has been
replaced by code embedded in libbpf.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 Documentation/networking/af_xdp.rst | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/af_xdp.rst b/Documentation/networking/af_xdp.rst
index e14d7d40fc75..83dddc20f5d6 100644
--- a/Documentation/networking/af_xdp.rst
+++ b/Documentation/networking/af_xdp.rst
@@ -220,7 +220,21 @@ Usage
 In order to use AF_XDP sockets there are two parts needed. The
 user-space application and the XDP program. For a complete setup and
 usage example, please refer to the sample application. The user-space
-side is xdpsock_user.c and the XDP side xdpsock_kern.c.
+side is xdpsock_user.c and the XDP side is part of libbpf.
+
+The XDP code sample included in tools/lib/bpf/xsk.c is the following::
+
+   SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
+   {
+       int index = ctx->rx_queue_index;
+
+       // A set entry here means that the correspnding queue_id
+       // has an active AF_XDP socket bound to it.
+       if (bpf_map_lookup_elem(&xsks_map, &index))
+           return bpf_redirect_map(&xsks_map, index, 0);
+
+       return XDP_PASS;
+   }
 
 Naive ring dequeue and enqueue could look like this::
 
-- 
2.20.1

