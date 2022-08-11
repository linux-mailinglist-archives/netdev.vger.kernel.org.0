Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA3FF590718
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 21:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235917AbiHKTqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 15:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbiHKTqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 15:46:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F534286CC;
        Thu, 11 Aug 2022 12:46:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE5E461227;
        Thu, 11 Aug 2022 19:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 964D5C433C1;
        Thu, 11 Aug 2022 19:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660247199;
        bh=YRkMMlNwzmEJEYtybHoLH5VDXMoCZrySBAWcK7AYlRI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fD87LsFkvPINJn8YnlIiDNG/PxAxlrZ63mXGJwBIvYKdlGXiWiAfBx7/Kq7/OqQ2Q
         dOfZLQjJt+0dpkIQlK1KZy6M4hcTduS5X9zvXv/72MvrlKlOn6DpfMqEYepCxy7epX
         4HuoeRUILihq7onsL+2tQ88ETmqchhxCPNZ+jqyeSjRTyk0mrbiH7iwm3zA/qMfDgX
         dwRPs9JUGSELyfd2+dKQGkXQwzx7QMxd8UNA5uF9p6rPcQ9vdWQRMMOQ/bpy21AKOJ
         jvU75o0k6yYmsXr+rveRyL8HseMj2NJJuaeaxX7BkdAc6aqRPvMWlGXo4e/O6rZ36b
         FWDmNXW+0Pkfw==
Date:   Thu, 11 Aug 2022 12:46:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-next@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org
Subject: Re: build failure of next-20220811 due to 332f1795ca20 ("Bluetooth:
 L2CAP: Fix l2cap_global_chan_by_psm regression")
Message-ID: <20220811124637.4cdb84f1@kernel.org>
In-Reply-To: <YvVQEDs75pxSgxjM@debian>
References: <YvVQEDs75pxSgxjM@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Aug 2022 19:53:04 +0100 Sudip Mukherjee (Codethink) wrote:
> Not sure if it has been reported, builds of csky and mips allmodconfig
> failed to build next-20220811 with gcc-12.

I can't repro with the cross compiler from kernel.org.
Can you test something like this?

diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetooth/bluetooth.h
index e72f3b247b5e..82bf8e01f7af 100644
--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -341,6 +341,11 @@ static inline bool bdaddr_type_is_le(u8 type)
 #define BDADDR_ANY  (&(bdaddr_t) {{0, 0, 0, 0, 0, 0}})
 #define BDADDR_NONE (&(bdaddr_t) {{0xff, 0xff, 0xff, 0xff, 0xff, 0xff}})
 
+static inline int ba_is_any(const bdaddr_t *ba)
+{
+	return memchr_inv(ba, sizeof(*ba), 0);
+}
+
 /* Copy, swap, convert BD Address */
 static inline int bacmp(const bdaddr_t *ba1, const bdaddr_t *ba2)
 {
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 77c0aac14539..a08ec272be4a 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -2001,8 +2001,8 @@ static struct l2cap_chan *l2cap_global_chan_by_psm(int state, __le16 psm,
 			}
 
 			/* Closest match */
-			src_any = !bacmp(&c->src, BDADDR_ANY);
-			dst_any = !bacmp(&c->dst, BDADDR_ANY);
+			src_any = !ba_is_any(&c->src);
+			dst_any = !ba_is_any(&c->dst);
 			if ((src_match && dst_any) || (src_any && dst_match) ||
 			    (src_any && dst_any))
 				c1 = c;
