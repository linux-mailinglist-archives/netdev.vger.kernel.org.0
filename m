Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 376C48C600
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbfHNCMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:12:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727760AbfHNCMA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:12:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DB1420842;
        Wed, 14 Aug 2019 02:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748719;
        bh=LzR96rWoY7MYu8XFodcA+gwbxghs1JHcR9sMScmctoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JA6Oa0EbwAE9Ivy1U5txJjotK5mTKoh30iBP+ODiVrXsyi94SVVnwwfL/PdMwwiGp
         vS93fzIwoH3QnEoeL67QG7p74hi2kthNQbbFmM86mVGa2p+fiODiMltwFR4htuMxaZ
         si4vG3VsnFgVq5usHgyv4qzCMf0jysUvBwOUW7Xg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilya Maximets <i.maximets@samsung.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 036/123] libbpf: fix using uninitialized ioctl results
Date:   Tue, 13 Aug 2019 22:09:20 -0400
Message-Id: <20190814021047.14828-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilya Maximets <i.maximets@samsung.com>

[ Upstream commit decb705e01a5d325c9876b9674043cde4b54f0db ]

'channels.max_combined' initialized only on ioctl success and
errno is only valid on ioctl failure.

The code doesn't produce any runtime issues, but makes memory
sanitizers angry:

 Conditional jump or move depends on uninitialised value(s)
    at 0x55C056F: xsk_get_max_queues (xsk.c:336)
    by 0x55C05B2: xsk_create_bpf_maps (xsk.c:354)
    by 0x55C089F: xsk_setup_xdp_prog (xsk.c:447)
    by 0x55C0E57: xsk_socket__create (xsk.c:601)
  Uninitialised value was created by a stack allocation
    at 0x55C04CD: xsk_get_max_queues (xsk.c:318)

Additionally fixed warning on uninitialized bytes in ioctl arguments:

 Syscall param ioctl(SIOCETHTOOL) points to uninitialised byte(s)
    at 0x648D45B: ioctl (in /usr/lib64/libc-2.28.so)
    by 0x55C0546: xsk_get_max_queues (xsk.c:330)
    by 0x55C05B2: xsk_create_bpf_maps (xsk.c:354)
    by 0x55C089F: xsk_setup_xdp_prog (xsk.c:447)
    by 0x55C0E57: xsk_socket__create (xsk.c:601)
  Address 0x1ffefff378 is on thread 1's stack
  in frame #1, created by xsk_get_max_queues (xsk.c:318)
  Uninitialised value was created by a stack allocation
    at 0x55C04CD: xsk_get_max_queues (xsk.c:318)

CC: Magnus Karlsson <magnus.karlsson@intel.com>
Fixes: 1cad07884239 ("libbpf: add support for using AF_XDP sockets")
Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/xsk.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index ca272c5b67f47..8e03b65830da0 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -327,15 +327,14 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 
 static int xsk_get_max_queues(struct xsk_socket *xsk)
 {
-	struct ethtool_channels channels;
-	struct ifreq ifr;
+	struct ethtool_channels channels = { .cmd = ETHTOOL_GCHANNELS };
+	struct ifreq ifr = {};
 	int fd, err, ret;
 
 	fd = socket(AF_INET, SOCK_DGRAM, 0);
 	if (fd < 0)
 		return -errno;
 
-	channels.cmd = ETHTOOL_GCHANNELS;
 	ifr.ifr_data = (void *)&channels;
 	strncpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ - 1);
 	ifr.ifr_name[IFNAMSIZ - 1] = '\0';
@@ -345,7 +344,7 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
 		goto out;
 	}
 
-	if (channels.max_combined == 0 || errno == EOPNOTSUPP)
+	if (err || channels.max_combined == 0)
 		/* If the device says it has no channels, then all traffic
 		 * is sent to a single stream, so max queues = 1.
 		 */
-- 
2.20.1

