Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 844CE1A5EC5
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 15:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgDLNcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 09:32:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:60690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbgDLNcO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Apr 2020 09:32:14 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-203-53-74.hsd1.co.comcast.net [73.203.53.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D405320673;
        Sun, 12 Apr 2020 13:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586698335;
        bh=JA7VPU9jf4n2Bwa5p3gNG6ES6Ix1joKztihzudiR0qg=;
        h=From:To:Cc:Subject:Date:From;
        b=XF1NqN30of9Ro9crAXehwCEyTVIaGKVayHM5vy24q0HeFQlOK6FsYWWwnHdILSUwK
         d5VWUXOwG1ZzxvxWN+KUuiEt1bgN+GBQ44PaIKuqhDxP9G/8MRxS6yQq1n7aWj2M4W
         cz2lc+UN+HrpxnaAkucQvqimH9VMk4MoTYUN7nk4=
From:   David Ahern <dsahern@kernel.org>
To:     daniel@iogearbox.net, ast@kernel.org
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf] xdp: Reset prog in dev_change_xdp_fd when fd is negative
Date:   Sun, 12 Apr 2020 07:32:04 -0600
Message-Id: <20200412133204.43847-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

The commit mentioned in the Fixes tag reuses the local prog variable
when looking up an expected_fd. The variable is not reset when fd < 0
causing a detach with the expected_fd set to actually call
dev_xdp_install for the existing program. The end result is that the
detach does not happen.

Fixes: 92234c8f15c8 ("xdp: Support specifying expected existing program when attaching XDP")
Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Toke Høiland-Jørgensen <toke@redhat.com>
---
 net/core/dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index df8097b8e286..522288177bbd 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8667,8 +8667,8 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 	const struct net_device_ops *ops = dev->netdev_ops;
 	enum bpf_netdev_command query;
 	u32 prog_id, expected_id = 0;
-	struct bpf_prog *prog = NULL;
 	bpf_op_t bpf_op, bpf_chk;
+	struct bpf_prog *prog;
 	bool offload;
 	int err;
 
@@ -8734,6 +8734,7 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 	} else {
 		if (!prog_id)
 			return 0;
+		prog = NULL;
 	}
 
 	err = dev_xdp_install(dev, bpf_op, extack, flags, prog);
-- 
2.20.1

