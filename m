Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3B00AB50E
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 11:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390528AbfIFJmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 05:42:31 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38704 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbfIFJma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 05:42:30 -0400
Received: by mail-wr1-f67.google.com with SMTP id l11so5848929wrx.5;
        Fri, 06 Sep 2019 02:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e+p/Fgr/GXLmLHbY0GjO0NrxJFHRdePsa+v/Y507qV0=;
        b=BQR0YtcKr81f23A2TRofkeO+pilpMRa/WwJo+iMMPEFktSHuU3eZltDR3ZtFAmiEQv
         aL6InOfGpTaD3qqglpafBNaV3S6RUB5RvIR5NrRV1N3swfF5Bho4LxSPmNYOhIg6N6uf
         lufqkPDGZN9fbACimgzY2pK4ZiB7+ypfz73iyclMdBL1EsWchWvPetbeI6t4Cxd2kzb1
         rcqdPb5rVQ7lW7MuI55PxVwUpf2g9GqJrF31ky8Oi5Pvkq0WYd72xAZDoYG42N5VDRHX
         25hudCi3qjv29TQQ+Neuz8QNO7Q0tSVanIlnJuRseRVZDXWh2WqzZiDNe82qXyxFBc+V
         52Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e+p/Fgr/GXLmLHbY0GjO0NrxJFHRdePsa+v/Y507qV0=;
        b=XWkFiDWDdXXFHEuMw62Dt1P3wJAOierbK3xGcpBBffw+qLlliZfILvEuvyRlWxEe94
         mfYsEkKGIbjCXu19cZZbDM1DADRYmENjVhgJCEHzEtDP6XlmWGQU4h0zDsQrHiQK9M4l
         Fr6K61zO05gKwPerkdUvghqUO9rKX/SefhJEpDYOFevM4hZI46FkoJRmDImAwcFqvH8n
         xEt7KFaf9I/EtF64dHdMuagfRDXT2haZ3BVdDb4ciR72YH2QmWoEiX6/5dN2u7qBQO2U
         i5sL74Joa0iJ94WzkFtNe1xnsLP1yicj6LqEc5PTq4oqxlvHCaZyG+xyouw+OVclLSFE
         5yPQ==
X-Gm-Message-State: APjAAAWj6+JprC6RPdvV30JzdBse7OCYWI8vRGP140sQy4b96T4guYd7
        nomk5DV/mL01+PW7faKwqHWWlyKxE9E=
X-Google-Smtp-Source: APXvYqzTjRbgJMRGA8JJZnny0Jlqiu+5lr1jbgXZYOMZkq3DLBUhYyRSOJ1o0ZFu+FE9I1VVVZCChg==
X-Received: by 2002:adf:f44e:: with SMTP id f14mr6041932wrp.290.1567762948379;
        Fri, 06 Sep 2019 02:42:28 -0700 (PDT)
Received: from Akatsuki.lan (bzq-109-67-210-71.red.bezeqint.net. [109.67.210.71])
        by smtp.googlemail.com with ESMTPSA id u68sm7807741wmu.12.2019.09.06.02.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2019 02:42:27 -0700 (PDT)
From:   Dan Elkouby <streetwalkermc@gmail.com>
Cc:     Dan Elkouby <streetwalkermc@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Fabian Henneke <fabian.henneke@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Bluetooth: hidp: Fix error checks in hidp_get/set_raw_report
Date:   Fri,  6 Sep 2019 12:41:57 +0300
Message-Id: <20190906094158.8854-1-streetwalkermc@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 48d9cc9d85dd ("Bluetooth: hidp: Let hidp_send_message return
number of queued bytes") changed hidp_send_message to return non-zero
values on success, which some other bits did not expect. This caused
spurious errors to be propagated through the stack, breaking some (all?)
drivers, such as hid-sony for the Dualshock 4 in Bluetooth mode.

Signed-off-by: Dan Elkouby <streetwalkermc@gmail.com>
---
 net/bluetooth/hidp/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index 8d889969ae7e..bef84b95e2c4 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -267,7 +267,7 @@ static int hidp_get_raw_report(struct hid_device *hid,
 	set_bit(HIDP_WAITING_FOR_RETURN, &session->flags);
 	data[0] = report_number;
 	ret = hidp_send_ctrl_message(session, report_type, data, 1);
-	if (ret)
+	if (ret < 0)
 		goto err;
 
 	/* Wait for the return of the report. The returned report
@@ -343,7 +343,7 @@ static int hidp_set_raw_report(struct hid_device *hid, unsigned char reportnum,
 	data[0] = reportnum;
 	set_bit(HIDP_WAITING_FOR_SEND_ACK, &session->flags);
 	ret = hidp_send_ctrl_message(session, report_type, data, count);
-	if (ret)
+	if (ret < 0)
 		goto err;
 
 	/* Wait for the ACK from the device. */
-- 
2.23.0

