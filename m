Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEE645933A
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 17:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240218AbhKVQle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 11:41:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240038AbhKVQld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 11:41:33 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC627C061574
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 08:38:25 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id 8so16670033pfo.4
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 08:38:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=3T98/3whduiezAonMuPxJQbLzPy6xKkpapq3TTnGn3A=;
        b=DTqBN1DBvRcSPQY4uLvY4uTUvu28S0X3a0RZunwFl5MlX7cseoCA7weDmuwhy1XgNp
         vLUDwHMVXKz8JXjnV/RRqKyJB58qen9Vq2xs0J1sDgMg3xsqOBPMVMSHqoW4BC9SXf2w
         g0KXDmBvOvyKBrNp1BPfJhhc0Tio6RH1e7BOvXEBNgjSd1LfckCuC1KGKzqH2ez7RvKw
         STlaEnfykCrPIQzK8tN3gsBwppVDdnMbpDN+oEWoOFWQn/P6h1ajFLlNZQ6c4M0NCk4N
         BMRVfi8UXGxzvif4XfnpsyPP4i29L0uwcS+OQWl+e1QgisnpwYOi47kI0MtWq37pdFHE
         7P4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=3T98/3whduiezAonMuPxJQbLzPy6xKkpapq3TTnGn3A=;
        b=y4vkuYGhs23kWDUonpfYZF3NOf6zGu/pLboXaCT8i0ZSFkbu0ieoFZLn3j4NZaYxPr
         A46zL/eIOHzwFumo4AUDggBs8fyda7Or5EABuPC+PF2U/t/CTZTQrJI6E0C+gXlv0fPU
         8oVM3vzPjOg1MaymnRbBNieexaHNyxTFgn3Rt3N6GMRF4k7jxXLOVfEY05xklwkdPwuQ
         rxtnTFSw+t00P3v2Q2HtsUMjScMXzOVn+mirS66him7MxWv2rSDUw/LMVm6PXQZ9UvAf
         O/+xtVi5NsHPp1SEI7PFE1bp9JsVIH09otPsADLhG0Fk8juHGxg8k5V7tBzGRM5KqSqu
         gTgw==
X-Gm-Message-State: AOAM531twToPB2ti+zlTRXru9APXo6gkxeZf7UT/hV5J6C/S4hcgxJeZ
        NjL/9yr+q9VMh8n8M0nCw8U=
X-Google-Smtp-Source: ABdhPJyV/5UP+Sjzqpc7BJDMQgu9hM1YcX9NW0+NbLC4BW7DL6VNt2cC7gIA0iFiooTxc4fjLcIMpQ==
X-Received: by 2002:a63:f808:: with SMTP id n8mr15552616pgh.50.1637599105495;
        Mon, 22 Nov 2021 08:38:25 -0800 (PST)
Received: from gmail.com ([122.178.80.201])
        by smtp.gmail.com with ESMTPSA id p19sm10375718pfo.92.2021.11.22.08.38.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Nov 2021 08:38:25 -0800 (PST)
From:   Kumar Thangavel <kumarthangavel.hcl@gmail.com>
X-Google-Original-From: Kumar Thangavel <thangavel.k@hcl.com>
Date:   Mon, 22 Nov 2021 22:08:18 +0530
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     openbmc@lists.ozlabs.org, linux-aspeed@lists.ozlabs.org,
        netdev@vger.kernel.org, patrickw3@fb.com,
        Amithash Prasad <amithash@fb.com>, sdasari@fb.com,
        velumanit@hcl.com
Subject: [PATCH v8] net/ncsi : Add payload to be 32-bit aligned to fix
 dropped packets
Message-ID: <20211122163818.GA11306@gmail.com>
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

Fixes: fb4ee67529ff ("net/ncsi: Add NCSI OEM command support")
Signed-off-by: Kumar Thangavel <thangavel.k@hcl.com>
Acked-by: Samuel Mendoza-Jonas <sam@mendozajonas.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>

---
  v8:
   - Updated padding_bytes as static const int variable

  v7:
   - Updated padding_bytes as const static int variable

  v6:
   - Updated type of padding_bytes variable
   - Updated type of payload
   - Seperated variable declarations and code

  v5:
   - Added Fixes tag
   - Added const variable for padding_bytes

  v4:
   - Used existing macro for max function

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
 net/ncsi/ncsi-cmd.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/ncsi/ncsi-cmd.c b/net/ncsi/ncsi-cmd.c
index ba9ae482141b..dda8b76b7798 100644
--- a/net/ncsi/ncsi-cmd.c
+++ b/net/ncsi/ncsi-cmd.c
@@ -18,6 +18,8 @@
 #include "internal.h"
 #include "ncsi-pkt.h"
 
+static const int padding_bytes = 26;
+
 u32 ncsi_calculate_checksum(unsigned char *data, int len)
 {
 	u32 checksum = 0;
@@ -213,12 +215,17 @@ static int ncsi_cmd_handler_oem(struct sk_buff *skb,
 {
 	struct ncsi_cmd_oem_pkt *cmd;
 	unsigned int len;
+	int payload;
+	/* NC-SI spec DSP_0222_1.2.0, section 8.2.2.2
+	 * requires payload to be padded with 0 to
+	 * 32-bit boundary before the checksum field.
+	 * Ensure the padding bytes are accounted for in
+	 * skb allocation
+	 */
 
+	payload = ALIGN(nca->payload, 4);
 	len = sizeof(struct ncsi_cmd_pkt_hdr) + 4;
-	if (nca->payload < 26)
-		len += 26;
-	else
-		len += nca->payload;
+	len += max(payload, padding_bytes);
 
 	cmd = skb_put_zero(skb, len);
 	memcpy(&cmd->mfr_id, nca->data, nca->payload);
@@ -272,6 +279,7 @@ static struct ncsi_request *ncsi_alloc_command(struct ncsi_cmd_arg *nca)
 	struct net_device *dev = nd->dev;
 	int hlen = LL_RESERVED_SPACE(dev);
 	int tlen = dev->needed_tailroom;
+	int payload;
 	int len = hlen + tlen;
 	struct sk_buff *skb;
 	struct ncsi_request *nr;
@@ -281,14 +289,14 @@ static struct ncsi_request *ncsi_alloc_command(struct ncsi_cmd_arg *nca)
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
+	len += max(payload, padding_bytes);
 
 	/* Allocate skb */
 	skb = alloc_skb(len, GFP_ATOMIC);
-- 
2.17.1

