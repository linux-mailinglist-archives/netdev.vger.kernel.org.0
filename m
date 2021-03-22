Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D611344C05
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbhCVQo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:44:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230403AbhCVQox (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 12:44:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B3866157F;
        Mon, 22 Mar 2021 16:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616431493;
        bh=cgxEyWWxWMLS8CQf76WqHFO4Irvj44kjG2TqRGl58zo=;
        h=From:To:Cc:Subject:Date:From;
        b=sjqt6owPFwii84L04miltanmCepnNwV8IugPcOZx+HGkD7PdVgB+Hw82QIC8Ua4Dr
         4tP2fnl/yDW7bUgBvHkd3KRx+JcVGq01+t+5XChGJc70mDt/KG57lBjj4SFAJDSzEx
         PUeRh80/0l8/Qe5YCZB4SjX0AxmIMjUEZFugsQhl4Jpr17eo2xCu4CKumIEWng5hsT
         Igs01r432rd8lFRgo+GPHUjp2WaloOmD6zGUkId9B8X+cLyRanftTjXDGLd4LXTcOj
         d5uMS6NcVH2N0FXPQh8ru1hx+ydbuqWbr6K9h+uoCKnKvIuE+OUVT0jriN7KjI9aK/
         hHF+DpCxHWHVQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Karsten Keil <isdn@linux-pingi.de>
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] isdn: capi: fix mismatched prototypes
Date:   Mon, 22 Mar 2021 17:44:29 +0100
Message-Id: <20210322164447.876440-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

gcc-11 complains about a prototype declaration that is different
from the function definition:

drivers/isdn/capi/kcapi.c:724:44: error: argument 2 of type ‘u8 *’ {aka ‘unsigned char *’} declared as a pointer [-Werror=array-parameter=]
  724 | u16 capi20_get_manufacturer(u32 contr, u8 *buf)
      |                                        ~~~~^~~
In file included from drivers/isdn/capi/kcapi.c:13:
drivers/isdn/capi/kcapi.h:62:43: note: previously declared as an array ‘u8[64]’ {aka ‘unsigned char[64]’}
   62 | u16 capi20_get_manufacturer(u32 contr, u8 buf[CAPI_MANUFACTURER_LEN]);
      |                                        ~~~^~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/isdn/capi/kcapi.c:790:38: error: argument 2 of type ‘u8 *’ {aka ‘unsigned char *’} declared as a pointer [-Werror=array-parameter=]
  790 | u16 capi20_get_serial(u32 contr, u8 *serial)
      |                                  ~~~~^~~~~~
In file included from drivers/isdn/capi/kcapi.c:13:
drivers/isdn/capi/kcapi.h:64:37: note: previously declared as an array ‘u8[8]’ {aka ‘unsigned char[8]’}
   64 | u16 capi20_get_serial(u32 contr, u8 serial[CAPI_SERIAL_LEN]);
      |                                  ~~~^~~~~~~~~~~~~~~~~~~~~~~

Change the definition to make them match.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/isdn/capi/kcapi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/capi/kcapi.c b/drivers/isdn/capi/kcapi.c
index 7168778fbbe1..cb0afe897162 100644
--- a/drivers/isdn/capi/kcapi.c
+++ b/drivers/isdn/capi/kcapi.c
@@ -721,7 +721,7 @@ u16 capi20_put_message(struct capi20_appl *ap, struct sk_buff *skb)
  * Return value: CAPI result code
  */
 
-u16 capi20_get_manufacturer(u32 contr, u8 *buf)
+u16 capi20_get_manufacturer(u32 contr, u8 buf[CAPI_MANUFACTURER_LEN])
 {
 	struct capi_ctr *ctr;
 	u16 ret;
@@ -787,7 +787,7 @@ u16 capi20_get_version(u32 contr, struct capi_version *verp)
  * Return value: CAPI result code
  */
 
-u16 capi20_get_serial(u32 contr, u8 *serial)
+u16 capi20_get_serial(u32 contr, u8 serial[CAPI_SERIAL_LEN])
 {
 	struct capi_ctr *ctr;
 	u16 ret;
-- 
2.29.2

