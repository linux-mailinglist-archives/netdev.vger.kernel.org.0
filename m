Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 104A637BA12
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 12:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhELKKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 06:10:46 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:56748 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230202AbhELKKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 06:10:45 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14CA7ZIr022860;
        Wed, 12 May 2021 10:09:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=QW1x4QxGK5nRMXaK0W/Lvx3BuTPEH87h+54H2o/57LE=;
 b=M76TBpu1D/h1rUFzNi1xQa+Ap0cIFlTzWco9rJy3zLyX1D3VSzgKiXkSqrzwikq64Kxo
 puRCgHRycZmx6AIb3B7Slqm7EOrd1JzCgtYfXMXFUaRHlUiTGIsMmNQDEDMH8DMKPcEk
 7rp/zvmaXYDKfCurCOjXU2Jbq9dHaOeKxPMml/igstUOw8Cg4tCaETgWspoNfyfdaLgl
 OfS2UDYZqcyG+ocmybfbfLDJpPJ8fD8zmu5hIhxAaoNbdWCxII7wIwGdz1L717wcayd8
 d1Gfjz5/2ad/qiNiplqdzSAMVKoEdraOu+/JJloudHMX8Uf4yHYPuBRU4hkQ56xPrpgO jw== 
Received: from oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 38eyurrq3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 10:09:19 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14CA8Mm9044499;
        Wed, 12 May 2021 10:09:19 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 38djfb4869-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 10:09:19 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 14CA8h5T047328;
        Wed, 12 May 2021 10:09:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 38djfb485m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 10:09:18 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 14CA9DA1016666;
        Wed, 12 May 2021 10:09:13 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 May 2021 10:09:13 +0000
Date:   Wed, 12 May 2021 13:09:04 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Denis Joseph Barrow <D.Barow@option.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Oliver Neukum <oneukum@suse.com>,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>,
        Rustam Kovhaev <rkovhaev@gmail.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: hso: check for allocation failure in
 hso_create_bulk_serial_device()
Message-ID: <YJupQPb+Y4vw3rDk@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-GUID: 9dZJQH-_TDMe-8xqJ3D9TrxDWxV6AkZe
X-Proofpoint-ORIG-GUID: 9dZJQH-_TDMe-8xqJ3D9TrxDWxV6AkZe
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a couple checks for if these allocations fail.

Fixes: 542f54823614 ("tty: Modem functions for the HSO driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/usb/hso.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 3ef4b2841402..3b2a868d7a72 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2618,9 +2618,13 @@ static struct hso_device *hso_create_bulk_serial_device(
 		num_urbs = 2;
 		serial->tiocmget = kzalloc(sizeof(struct hso_tiocmget),
 					   GFP_KERNEL);
+		if (!serial->tiocmget)
+			goto exit;
 		serial->tiocmget->serial_state_notification
 			= kzalloc(sizeof(struct hso_serial_state_notification),
 					   GFP_KERNEL);
+		if (!serial->tiocmget->serial_state_notification)
+			goto exit;
 		/* it isn't going to break our heart if serial->tiocmget
 		 *  allocation fails don't bother checking this.
 		 */
-- 
2.30.2

