Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBBBB44BE1D
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 10:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbhKJJ51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 04:57:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbhKJJ51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 04:57:27 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01497C061764
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 01:54:40 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so1393890pja.1
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 01:54:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=tR1eQ0HFDW+gSGWX2relDJWUrab0SBpRydg9vDOUk14=;
        b=OI0Smq4lZWfqIcM3FNpOstehatVCjUPriINDymUV+ZssG2a1GsBt6jj8/pqcDpMPC2
         52wobv7wPIy3cCS/LeaQKbFaF31izmXgzBJ5Bsubl/NKQhjt8wUnzhYr81rMS33VnqUc
         NRrywTsOWbhCzKRXNba//9dK6Feg/iFztS3j+NSKaXPD0nYufZ2LKuTxdz5zsYCOIJdJ
         u22PCP6OMjMyYzCzlYQNfWXTaMCTrTytpVTiMqSHTytL4Qp5XxL3oEmnmxR7jrtYap8x
         J+YooDCjIyS5FOYBOzpQ/oqRS8bEwNzu0hXoVrqmCiXzwL0JQAvXYziYeYJmtXYIHjk2
         Du9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=tR1eQ0HFDW+gSGWX2relDJWUrab0SBpRydg9vDOUk14=;
        b=wBCNDb5I601DhGwhGtr5TTt709IVWDrtS34BGXd6UewQxrkGNnoHXnY0pKbmAXsMYl
         qqAfSIP1Pj8Grn3IjM4LBe1vzKrUzwD4ZWUmX0gRXkLHfTZn6bWq6sdg4+0cWHvwzXlG
         W8kl1gn/2TU2e8qkMtfS7z7SAYNjTwVTm6z1tzeOnHbiMU3VAyuOacNYCfGwQembGlb5
         ujH4oTV2v173Q/7Bvo/xgenBq8lo64j9dC9nu+O0aCEHspLaXESbULYS3aU/UEhJN0+y
         UpqmKEm3uLzuUh6ElScG0fgfMwRuJ+Krv7zaN9tkuQfAJ1jgrg1sVLZfY9ixI8/2jhDN
         Z5ew==
X-Gm-Message-State: AOAM532V8olTJ5wIQY2tVIMkhlvlGD3kU+FgT0hSQy5sZ0zFsrkOop79
        rRHHD58k0Rs5T3XJgDZqDYU=
X-Google-Smtp-Source: ABdhPJzWfr21w03ICiDUO5Y0+o6zZM1UMXHcxqk5ve27brAQbOY15zUDjW8yS2ToLYtllLuLJ1sUqA==
X-Received: by 2002:a17:90b:3e85:: with SMTP id rj5mr15205749pjb.172.1636538079538;
        Wed, 10 Nov 2021 01:54:39 -0800 (PST)
Received: from gmail.com ([122.178.80.201])
        by smtp.gmail.com with ESMTPSA id i6sm11408891pfu.173.2021.11.10.01.54.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Nov 2021 01:54:39 -0800 (PST)
From:   Kumar Thangavel <kumarthangavel.hcl@gmail.com>
X-Google-Original-From: Kumar Thangavel <thangavel.k@hcl.com>
Date:   Wed, 10 Nov 2021 15:24:32 +0530
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     openbmc@lists.ozlabs.org, linux-aspeed@lists.ozlabs.org,
        patrickw3@fb.com, Amithash Prasad <amithash@fb.com>,
        velumanit@hcl.com, sdasari@fb.com, netdev@vger.kernel.org
Subject: [PATCH v4] Add payload to be 32-bit aligned to fix dropped packets
Message-ID: <20211110095432.GA9571@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update NC-SI command handler (both standard and OEM) to take into
account of payload paddings in allocating skb (in case of payload
size is not 32-bit aligned).

The checksum field follows payload field, without taking payload
padding into account can cause checksum being truncated, leading to
dropped packets.

Signed-off-by: Kumar Thangavel <thangavel.k@hcl.com>
Acked-by: Samuel Mendoza-Jonas <sam@mendozajonas.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>

---
  v4:
   - Updated existing macro for max function

  v3:
   - Added Macro for MAX
   - Fixed the missed semicolon

  v2:
   - Added NC-SI spec version and section
   - Removed blank line
   - corrected spellings

  v1:
   - Initial draft

---
---
 net/ncsi/ncsi-cmd.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/ncsi/ncsi-cmd.c b/net/ncsi/ncsi-cmd.c
index ba9ae482141b..e44fe138c20f 100644
--- a/net/ncsi/ncsi-cmd.c
+++ b/net/ncsi/ncsi-cmd.c
@@ -213,12 +213,16 @@ static int ncsi_cmd_handler_oem(struct sk_buff *skb,
 {
 	struct ncsi_cmd_oem_pkt *cmd;
 	unsigned int len;
+	/* NC-SI spec DSP_0222_1.2.0, section 8.2.2.2
+	 * requires payload to be padded with 0 to
+	 * 32-bit boundary before the checksum field.
+	 * Ensure the padding bytes are accounted for in
+	 * skb allocation
+	 */
 
+	unsigned short payload = ALIGN(nca->payload, 4);
 	len = sizeof(struct ncsi_cmd_pkt_hdr) + 4;
-	if (nca->payload < 26)
-		len += 26;
-	else
-		len += nca->payload;
+	len += max(payload, 26);
 
 	cmd = skb_put_zero(skb, len);
 	memcpy(&cmd->mfr_id, nca->data, nca->payload);
@@ -272,6 +276,7 @@ static struct ncsi_request *ncsi_alloc_command(struct ncsi_cmd_arg *nca)
 	struct net_device *dev = nd->dev;
 	int hlen = LL_RESERVED_SPACE(dev);
 	int tlen = dev->needed_tailroom;
+	int payload;
 	int len = hlen + tlen;
 	struct sk_buff *skb;
 	struct ncsi_request *nr;
@@ -281,14 +286,14 @@ static struct ncsi_request *ncsi_alloc_command(struct ncsi_cmd_arg *nca)
 		return NULL;
 
 	/* NCSI command packet has 16-bytes header, payload, 4 bytes checksum.
+	 * Payload needs padding so that the checksum field following payload is
+	 * aligned to 32-bit boundary.
 	 * The packet needs padding if its payload is less than 26 bytes to
 	 * meet 64 bytes minimal ethernet frame length.
 	 */
 	len += sizeof(struct ncsi_cmd_pkt_hdr) + 4;
-	if (nca->payload < 26)
-		len += 26;
-	else
-		len += nca->payload;
+	payload = ALIGN(nca->payload, 4);
+	len += max(payload, 26);
 
 	/* Allocate skb */
 	skb = alloc_skb(len, GFP_ATOMIC);
-- 
2.17.1

