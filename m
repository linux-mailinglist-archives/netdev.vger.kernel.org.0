Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2A7316B6A4
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 01:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728541AbgBYAZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 19:25:05 -0500
Received: from gateway22.websitewelcome.com ([192.185.47.179]:41259 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728087AbgBYAZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 19:25:01 -0500
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id 64B1A5EBE
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 18:25:00 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 6O20jJJqSSl8q6O20jyMEP; Mon, 24 Feb 2020 18:25:00 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=StD8K7B/IbLHb+7gq2AVQ24d9PrxX4zRAlmjceGLxBI=; b=cef/4pH9Y7gkNa2Rujz7TwrUuz
        ao2dsiqnIm0nORidRrr4/fvQ8RILopsIHSo7ARSdrOk05VwGXag8B6MtXnfeaaYqLBgD6djtps/0c
        A/LJQv9eO0E6TXTo9JCPFPyzXu4ZHczCKsIh7pgRpnmHMn53qfYJ7iSXtaJc6mW/ZZpbR0d2El6sF
        VstH3V3fOY61qg7nprMZvqzVNVkf54FB4jQZYVNSEBvw342NRGtX9uLSCu1HA2sG4g8FXvnwh4W0D
        c4yBXY3CfKPmfJs0m5q+yJFguVmCdxz2EBJ8WcXBlHT3q57lZlQjW8quMCujZpGm5iRTuUpVJJU08
        llHgKSIw==;
Received: from [201.166.191.153] (port=54744 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j6O1x-002VtX-VX; Mon, 24 Feb 2020 18:24:58 -0600
Date:   Mon, 24 Feb 2020 18:27:46 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] wireless: realtek: Replace zero-length array with
 flexible-array member
Message-ID: <20200225002746.GA26789@embeddedor>
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
X-Source-IP: 201.166.191.153
X-Source-L: No
X-Exim-ID: 1j6O1x-002VtX-VX
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.166.191.153]:54744
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 39
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 2 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h      | 6 +++---
 drivers/net/wireless/realtek/rtw88/fw.h          | 2 +-
 drivers/net/wireless/realtek/rtw88/main.h        | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 6598c8d786ea..440d164443bc 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -627,7 +627,7 @@ struct rtl8xxxu_firmware_header {
 	u32	reserved4;
 	u32	reserved5;
 
-	u8	data[0];
+	u8	data[];
 };
 
 /*
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 1cff9f07c9e9..13421cf2d201 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -1051,13 +1051,13 @@ struct rtl_hdr_3addr {
 	u8 addr2[ETH_ALEN];
 	u8 addr3[ETH_ALEN];
 	__le16 seq_ctl;
-	u8 payload[0];
+	u8 payload[];
 } __packed;
 
 struct rtl_info_element {
 	u8 id;
 	u8 len;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 struct rtl_probe_rsp {
@@ -1068,7 +1068,7 @@ struct rtl_probe_rsp {
 	/*SSID, supported rates, FH params, DS params,
 	 * CF params, IBSS params, TIM (if beacon), RSN
 	 */
-	struct rtl_info_element info_element[0];
+	struct rtl_info_element info_element[];
 } __packed;
 
 /*LED related.*/
diff --git a/drivers/net/wireless/realtek/rtw88/fw.h b/drivers/net/wireless/realtek/rtw88/fw.h
index ccd27bd45775..414827800a5f 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.h
+++ b/drivers/net/wireless/realtek/rtw88/fw.h
@@ -36,7 +36,7 @@ enum rtw_c2h_cmd_id_ext {
 struct rtw_c2h_cmd {
 	u8 id;
 	u8 seq;
-	u8 payload[0];
+	u8 payload[];
 } __packed;
 
 enum rtw_rsvd_packet_type {
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index c074cef22120..46c0ebceb177 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -1641,7 +1641,7 @@ struct rtw_dev {
 	struct rtw_wow_param wow;
 
 	/* hci related data, must be last */
-	u8 priv[0] __aligned(sizeof(void *));
+	u8 priv[] __aligned(sizeof(void *));
 };
 
 #include "hci.h"
-- 
2.25.0

