Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33D23A3E4F
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 21:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbfH3TUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 15:20:19 -0400
Received: from gateway36.websitewelcome.com ([192.185.198.13]:24057 "EHLO
        gateway36.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727888AbfH3TUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 15:20:19 -0400
X-Greylist: delayed 1375 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Aug 2019 15:20:18 EDT
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway36.websitewelcome.com (Postfix) with ESMTP id 6F0C3400C5672
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 13:23:22 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 3m5Kinduw2qH73m5Kik43Y; Fri, 30 Aug 2019 13:57:22 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cPkR+sjQETckei88bj4J3c37q+XYl3hWNTjp7VyXbZ0=; b=oABKnLPqx/CkQNLn7fGJAdolHe
        EIcYU6kFVYE/porHtSK1snbeKvFjYfqU/ek5Gqkqsw++Ge8fOHMrzxmqyMU8xQjDApdRB3dKOfYUz
        I3TFUcU8m5vQAmF9cPvzATIXC8K1PaFhkJn3UrDuMn3UNGZG2c6AKxEBt4i2hfyON9FR9O0cfEh50
        CR4fqc5WVuurWn5GkYQjiRMqotoF2VbnLjcVRHxk7MFLsi70DakRzWtATYPcXE3boldfPxBr0ZgCv
        f67/hFI/y7MNIo6a3e18pk9gSCviRUM0S3Ma1M5BUAt/aB/0WO3sAh7fIID/vT3iIlQBxcPecAxKH
        qyWpbZRA==;
Received: from [189.152.216.116] (port=39024 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1i3m5J-002Gwo-7r; Fri, 30 Aug 2019 13:57:21 -0500
Date:   Fri, 30 Aug 2019 13:57:16 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] zd1211rw: zd_usb: Use struct_size() helper
Message-ID: <20190830185716.GA10044@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 189.152.216.116
X-Source-L: No
X-Exim-ID: 1i3m5J-002Gwo-7r
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.152.216.116]:39024
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 15
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One of the more common cases of allocation size calculations is finding
the size of a structure that has a zero-sized array at the end, along
with memory for some number of elements for that array. For example:

struct usb_int_regs {
	...
        struct reg_data regs[0];
} __packed;

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes.

So, replace the following function:

static int usb_int_regs_length(unsigned int count)
{
       return sizeof(struct usb_int_regs) + count * sizeof(struct reg_data);
}

with:

struct_size(regs, regs, count)

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
index 1965cd0fafc4..4e44ea8c652d 100644
--- a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
@@ -1597,11 +1597,6 @@ static int zd_ep_regs_out_msg(struct usb_device *udev, void *data, int len,
 	}
 }
 
-static int usb_int_regs_length(unsigned int count)
-{
-	return sizeof(struct usb_int_regs) + count * sizeof(struct reg_data);
-}
-
 static void prepare_read_regs_int(struct zd_usb *usb,
 				  struct usb_req_read_regs *req,
 				  unsigned int count)
@@ -1636,10 +1631,10 @@ static bool check_read_regs(struct zd_usb *usb, struct usb_req_read_regs *req,
 	/* The created block size seems to be larger than expected.
 	 * However results appear to be correct.
 	 */
-	if (rr->length < usb_int_regs_length(count)) {
+	if (rr->length < struct_size(regs, regs, count)) {
 		dev_dbg_f(zd_usb_dev(usb),
-			 "error: actual length %d less than expected %d\n",
-			 rr->length, usb_int_regs_length(count));
+			 "error: actual length %d less than expected %ld\n",
+			 rr->length, struct_size(regs, regs, count));
 		return false;
 	}
 
-- 
2.23.0

