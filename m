Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A553E4E44
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 23:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236391AbhHIVJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 17:09:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229516AbhHIVJG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 17:09:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C48B660C51;
        Mon,  9 Aug 2021 21:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628543325;
        bh=4X7GgQzil0XE9e0MOOkWsScaqNE/lfvOBMhpWRnWcfU=;
        h=Date:From:To:Cc:Subject:From;
        b=j0lzJPy28KURuQMgWdr+sn/DCeOLgIMndjvmqkHCUtc/IhjO56JIEwNFILKQTJcVg
         HLWYC/ZhoLxi6pZvu85QQ/qqsgzICff4AqDN6O62ABHxRQ0y7eQ9W80UUG3rKIyVHv
         M6MZzNuwryfW06yfp58yxhcXAL5DEp0wSH1tOrj/wkoWgKlAzfMg1CeOgHJR42clq0
         i24xi9lKw9fvMlzlLU0esbdCMEZOLzRn9UTPo+ZhZUmQRVzhhlOaOZmoq80qmSb2AK
         2ylRrtxQChcTF9LAPdwi/Mrm8tLCOobvgcjj29HUrJb3CUNTm4sR2F5OXz32xtS1Pk
         E78FS+j3/sHLA==
Date:   Mon, 9 Aug 2021 16:11:34 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] mwifiex: usb: Replace one-element array with
 flexible-array member
Message-ID: <20210809211134.GA22488@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a regular need in the kernel to provide a way to declare having
a dynamically sized set of trailing elements in a structure. Kernel code
should always use “flexible array members”[1] for these cases. The older
style of one-element or zero-length arrays should no longer be used[2].

This helps with the ongoing efforts to globally enable -Warray-bounds
and get us closer to being able to tighten the FORTIFY_SOURCE routines
on memcpy().

This issue was found with the help of Coccinelle and audited and fixed,
manually.

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.10/process/deprecated.html#zero-length-and-one-element-arrays

Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/KSPP/linux/issues/109
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/usb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/usb.h b/drivers/net/wireless/marvell/mwifiex/usb.h
index d822ec15b7e6..61a96b7fbf21 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.h
+++ b/drivers/net/wireless/marvell/mwifiex/usb.h
@@ -134,7 +134,7 @@ struct fw_sync_header {
 struct fw_data {
 	struct fw_header fw_hdr;
 	__le32 seq_num;
-	u8 data[1];
+	u8 data[];
 } __packed;
 
 #endif /*_MWIFIEX_USB_H */
-- 
2.27.0

