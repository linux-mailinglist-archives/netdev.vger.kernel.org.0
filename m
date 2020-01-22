Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46008144AB4
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 05:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgAVEHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 23:07:34 -0500
Received: from ozlabs.org ([203.11.71.1]:45803 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727141AbgAVEHd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 23:07:33 -0500
Received: by ozlabs.org (Postfix, from userid 1034)
        id 482X1G5HCbz9sRd; Wed, 22 Jan 2020 15:07:30 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1579666050;
        bh=iagcn4dvwH0XRZXprwATFUQJb7S42Syhw+4ZaH4ZbW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SnPSq9Yv4SxusxlR0Wyx4BPy/peuvB6oNW9q+mhTISFnQ+DGSPP6ei81tZ4jAi7Sc
         YHA3BqYtgXuK3HrBOur0WHM2Ig9QmxJgqmMGRhOtOFxf30dbBVPr0SBFs9Epz4Ciql
         8LzfecaMGBxo9W1ReH+VF6NZDS0YgR8JQ9cdB/wq61chMJhtWs4BX3RdXpny1RXIIg
         noTX9flkQ5d2eQyqhaA06sBGzCf+mLkjdh4fHbMLwIPa57QHYo17Sza4veBr+LDbdA
         74BffuJbuScuiMx6Wl+YO0cCRMFEhRNyZTotU/DPYEX7548ZRBqN40LRFnkljNGb7d
         zGTiNcwh2fvBQ==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        security@kernel.org, ivansprundel@ioactive.com
Subject: [PATCH 2/2] airo: Add missing CAP_NET_ADMIN check in AIROOLDIOCTL/SIOCDEVPRIVATE
Date:   Wed, 22 Jan 2020 15:07:28 +1100
Message-Id: <20200122040728.8437-2-mpe@ellerman.id.au>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200122040728.8437-1-mpe@ellerman.id.au>
References: <20200122040728.8437-1-mpe@ellerman.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver for Cisco Aironet 4500 and 4800 series cards (airo.c),
implements AIROOLDIOCTL/SIOCDEVPRIVATE in airo_ioctl().

The ioctl handler copies an aironet_ioctl struct from userspace, which
includes a command. Some of the commands are handled in readrids(),
where the user controlled command is converted into a driver-internal
value called "ridcode".

There are two command values, AIROGWEPKTMP and AIROGWEPKNV, which
correspond to ridcode values of RID_WEP_TEMP and RID_WEP_PERM
respectively. These commands both have checks that the user has
CAP_NET_ADMIN, with the comment that "Only super-user can read WEP
keys", otherwise they return -EPERM.

However there is another command value, AIRORRID, that lets the user
specify the ridcode value directly, with no other checks. This means
the user can bypass the CAP_NET_ADMIN check on AIROGWEPKTMP and
AIROGWEPKNV.

Fix it by moving the CAP_NET_ADMIN check out of the command handling
and instead do it later based on the ridcode. That way regardless of
whether the ridcode is set via AIROGWEPKTMP or AIROGWEPKNV, or passed
in using AIRORID, we always do the CAP_NET_ADMIN check.

Found by Ilja by code inspection, not tested as I don't have the
required hardware.

Reported-by: Ilja Van Sprundel <ivansprundel@ioactive.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 drivers/net/wireless/cisco/airo.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cisco/airo.c
index d69c2ee7e206..c4c8f1b62e1e 100644
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -7790,16 +7790,8 @@ static int readrids(struct net_device *dev, aironet_ioctl *comp) {
 	case AIROGVLIST:    ridcode = RID_APLIST;       break;
 	case AIROGDRVNAM:   ridcode = RID_DRVNAME;      break;
 	case AIROGEHTENC:   ridcode = RID_ETHERENCAP;   break;
-	case AIROGWEPKTMP:  ridcode = RID_WEP_TEMP;
-		/* Only super-user can read WEP keys */
-		if (!capable(CAP_NET_ADMIN))
-			return -EPERM;
-		break;
-	case AIROGWEPKNV:   ridcode = RID_WEP_PERM;
-		/* Only super-user can read WEP keys */
-		if (!capable(CAP_NET_ADMIN))
-			return -EPERM;
-		break;
+	case AIROGWEPKTMP:  ridcode = RID_WEP_TEMP;	break;
+	case AIROGWEPKNV:   ridcode = RID_WEP_PERM;	break;
 	case AIROGSTAT:     ridcode = RID_STATUS;       break;
 	case AIROGSTATSD32: ridcode = RID_STATSDELTA;   break;
 	case AIROGSTATSC32: ridcode = RID_STATS;        break;
@@ -7813,6 +7805,12 @@ static int readrids(struct net_device *dev, aironet_ioctl *comp) {
 		return -EINVAL;
 	}
 
+	if (ridcode == RID_WEP_TEMP || ridcode == RID_WEP_PERM) {
+		/* Only super-user can read WEP keys */
+		if (!capable(CAP_NET_ADMIN))
+			return -EPERM;
+	}
+
 	if ((iobuf = kzalloc(RIDSIZE, GFP_KERNEL)) == NULL)
 		return -ENOMEM;
 
-- 
2.21.1

