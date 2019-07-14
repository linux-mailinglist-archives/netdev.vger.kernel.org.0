Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6061C67EC1
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 13:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728302AbfGNLHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jul 2019 07:07:33 -0400
Received: from devnull.tasossah.com ([107.6.175.157]:41876 "EHLO
        devnull.tasossah.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728147AbfGNLHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jul 2019 07:07:33 -0400
X-Greylist: delayed 2100 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Jul 2019 07:07:32 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=devnull.tasossah.com; s=vps;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:Message-ID:Cc:To:Subject:From; bh=PK+4A6Djlm0HBD+oHjsKF9x5XtC7nuP1nhljNjNNhD4=;
        b=sgqBjlGjHCRgMihFqvIT4YOeheSv3Pgrkl1fpgiIalzVVhurAj7NhEIgXPylLkhwxe8Iw+hp+cFCHhrpfr1gxWTEdIvqbBeJEg4jVN0ilX6pR8VOo89mfQSIu0IeE2cZrd15s4edXl+IPbMN4gK6QZhBWS/X739yXSax3NNY7DI=;
Received: from 194.219.107.0.dsl.dyn.forthnet.gr ([194.219.107.0] helo=[192.168.1.3])
        by devnull.tasossah.com with esmtpsa (TLS1.2:RSA_AES_128_CBC_SHA1:128)
        (Exim 4.82)
        (envelope-from <tasos@tasossah.com>)
        id 1hmbmw-0000NR-5J; Sun, 14 Jul 2019 13:31:26 +0300
From:   Tasos Sahanidis <tasos@tasossah.com>
Subject: [PATCH] sky2: Disable MSI on P5W DH Deluxe
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        stephen@networkplumber.org, mlindner@marvell.com,
        tasos@tasossah.com
Message-ID: <14c872c3-09ac-7f51-dc3d-e68319459fcf@tasossah.com>
Date:   Sun, 14 Jul 2019 13:31:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The onboard sky2 NICs send IRQs after S3, resulting in ethernet not
working after resume.
Maskable MSI and MSI-X are also not supported, so fall back to INTx.

Signed-off-by: Tasos Sahanidis <tasos@tasossah.com>
---
 drivers/net/ethernet/marvell/sky2.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index fe518c854..f518312ff 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4917,6 +4917,13 @@ static const struct dmi_system_id msi_blacklist[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "P-79"),
 		},
 	},
+	{
+		.ident = "ASUS P5W DH Deluxe",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTEK COMPUTER INC"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "P5W DH Deluxe"),
+		},
+	},
 	{}
 };
 
-- 
2.17.1
