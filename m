Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3B781BD200
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 04:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgD2CCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 22:02:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726158AbgD2CCD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 22:02:03 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FCA620731;
        Wed, 29 Apr 2020 02:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588125723;
        bh=SMBypzmv02e6MPV7lqILrm55/5w/njZJOnbDEzcUF2M=;
        h=From:To:Cc:Subject:Date:From;
        b=QY9jviVoAAcVhxzGI7WdGx+nw58UX2gpFtU3BwYxCWtl12Vnp54Sz1m7Q6T+HJ+cF
         a8VevPCq7kVAmfxodLhOi5OIjPur3JypAgtHpKumo3s8m7eyicaZyiZtskxYmecPAq
         OGgZUpsp4caMw5oSqeWTIEpg7zwxZvD8/UvfUlSk=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, jiri@resnulli.us,
        jacob.e.keller@intel.com, parav@mellanox.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] devlink: fix return value after hitting end in region read
Date:   Tue, 28 Apr 2020 19:01:58 -0700
Message-Id: <20200429020158.988886-1-kuba@kernel.org>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit d5b90e99e1d5 ("devlink: report 0 after hitting end in region read")
fixed region dump, but region read still returns a spurious error:

$ devlink region read netdevsim/netdevsim1/dummy snapshot 0 addr 0 len 128
0000000000000000 a6 f4 c4 1c 21 35 95 a6 9d 34 c3 5b 87 5b 35 79
0000000000000010 f3 a0 d7 ee 4f 2f 82 7f c6 dd c4 f6 a5 c3 1b ae
0000000000000020 a4 fd c8 62 07 59 48 03 70 3b c7 09 86 88 7f 68
0000000000000030 6f 45 5d 6d 7d 0e 16 38 a9 d0 7a 4b 1e 1e 2e a6
0000000000000040 e6 1d ae 06 d6 18 00 85 ca 62 e8 7e 11 7e f6 0f
0000000000000050 79 7e f7 0f f3 94 68 bd e6 40 22 85 b6 be 6f b1
0000000000000060 af db ef 5e 34 f0 98 4b 62 9a e3 1b 8b 93 fc 17
devlink answers: Invalid argument
0000000000000070 61 e8 11 11 66 10 a5 f7 b1 ea 8d 40 60 53 ed 12

This is a minimal fix, I'll follow up with a restructuring
so we don't have two checks for the same condition.

Fixes: fdd41ec21e15 ("devlink: Return right error code in case of errors for region read")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/devlink.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 80f97722f31f..1ec2e9fd8898 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4283,6 +4283,11 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 		end_offset = nla_get_u64(attrs[DEVLINK_ATTR_REGION_CHUNK_ADDR]);
 		end_offset += nla_get_u64(attrs[DEVLINK_ATTR_REGION_CHUNK_LEN]);
 		dump = false;
+
+		if (start_offset == end_offset) {
+			err = 0;
+			goto nla_put_failure;
+		}
 	}
 
 	err = devlink_nl_region_read_snapshot_fill(skb, devlink,
-- 
2.25.4

