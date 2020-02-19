Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA2E61647B2
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 16:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgBSPCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 10:02:33 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:41620 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbgBSPCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 10:02:32 -0500
Received: by mail-lj1-f194.google.com with SMTP id h23so691872ljc.8;
        Wed, 19 Feb 2020 07:02:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jI8b92MXgk0efhak9gk6FrgPJCPT1ISTWrmOifLTsoU=;
        b=Kr4uhcHMWJ8Uzx91/pGTmRC+NMYgl0iwH+UcWMlpZRrSPIFUHcdEt8iyXsiwNzgtbj
         Ll8ehpL+88BYPc2RzEvrxQjK7jtS/KAud3YBv7S+CE1BglxJwRa54gnqqMgaUcKvisW1
         zHBSCfc0DWwnq9o1LQM/kxT4aRYK2Vfy9LR+euFwQXZ/HAFzgtF9fGqUe9dvOUxUSykh
         PdtUDakmFzKmZZsbgIGTBp5PrLW5g3bdLvAtHsQ4OyvVUlnT/3OJzKGxM/jPhP2qstDb
         jPMyZJnLqzzK+HW7uLxLWw0YsZxnxc9NUWHEb/cJT0TmIXrGmp8bibYSq9suMRmseWmZ
         A7nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jI8b92MXgk0efhak9gk6FrgPJCPT1ISTWrmOifLTsoU=;
        b=Er2cPS5ETpJdRQm2Vh5Q9wBc1wwSIJItpOlNsjYM+qC5uTddPvjlU0e3oPO2bVqguO
         jfOxVAQxq65PLjYZQGgDOTOzoh53T9kHZROfgPexWfdczDJQars2d1SeJoefuwGhRkLX
         DfEgYvKHzMTwMKBxhp0bVrvI/tP/USc+vH6klMT5pKpL6VgkSZxit1ov58mDaV/AEi8f
         vC7uWiH2btfo+Z2YgX4h8C6ERRMYFgGd2RBfT9oWV9EOnHdiyAWa8v+BvlFsVnI7nHPH
         WzAQQ9FxRkfGNCItjAvFAbRFfG802GMH/YqMsR3QSGN+s1wRTDfb7YkyxAR84dd60svE
         b0XA==
X-Gm-Message-State: APjAAAWm/s6Qb4wRA7oak4w++JpkT6FmNTd6SXBZiMPZiTOHZDGcHAvx
        DAMDvhnxtfIHzUe70/RAl+M=
X-Google-Smtp-Source: APXvYqxx5v5g8sUuYN9vbyRJSlE7QZVKB3360ZXmfF6Oc0N7a7eAUxjubXZsj4q9V+iquV3uw21rgw==
X-Received: by 2002:a2e:7812:: with SMTP id t18mr16855004ljc.289.1582124550514;
        Wed, 19 Feb 2020 07:02:30 -0800 (PST)
Received: from localhost.localdomain (79-139-233-37.dynamic.spd-mgts.ru. [79.139.233.37])
        by smtp.gmail.com with ESMTPSA id v5sm1345848ljk.67.2020.02.19.07.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 07:02:27 -0800 (PST)
From:   Dmitry Osipenko <digetx@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Heidelberg <david@ixit.cz>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1] nfc: pn544: Fix occasional HW initialization failure
Date:   Wed, 19 Feb 2020 18:01:22 +0300
Message-Id: <20200219150122.31524-1-digetx@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PN544 driver checks the "enable" polarity during of driver's probe and
it's doing that by turning ON and OFF NFC with different polarities until
enabling succeeds. It takes some time for the hardware to power-down, and
thus, to deassert the IRQ that is raised by turning ON the hardware.
Since the delay after last power-down of the polarity-checking process is
missed in the code, the interrupt may trigger immediately after installing
the IRQ handler (right after the checking is done), which results in IRQ
handler trying to touch the disabled HW and ends with marking NFC as
'DEAD' during of the driver's probe:

  pn544_hci_i2c 1-002a: NFC: nfc_en polarity : active high
  pn544_hci_i2c 1-002a: NFC: invalid len byte
  shdlc: llc_shdlc_recv_frame: NULL Frame -> link is dead

This patch fixes the occasional NFC initialization failure on Nexus 7
device.

Cc: <stable@vger.kernel.org>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---
 drivers/nfc/pn544/i2c.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
index 720c89d6066e..4ac8cb262559 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -225,6 +225,7 @@ static void pn544_hci_i2c_platform_init(struct pn544_i2c_phy *phy)
 
 out:
 	gpiod_set_value_cansleep(phy->gpiod_en, !phy->en_polarity);
+	usleep_range(10000, 15000);
 }
 
 static void pn544_hci_i2c_enable_mode(struct pn544_i2c_phy *phy, int run_mode)
-- 
2.24.0

