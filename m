Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4967824B195
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 10:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgHTI4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 04:56:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57768 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726364AbgHTI4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 04:56:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597913765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CQGCDrZfL2MFa6vLcoQedHKYbNjnM4wEqVPlx7Nh45o=;
        b=Es9PTAMHUaaFCq/tGwUF9sCWVRBAxVrMwOd4jm96B287CLzJ12sg8suox9S5kMygcS5Ex+
        DtrF9Q8CQNgJAYLlVJKeBU5xTJz5W5QvVLleJehNktSs4RAHNlav7D1o79R3A5tFTGkxZX
        l8XCjChta02Is41DCvZ37/vPv2fanlQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-adU--VGQNZumtwxb7bGD7A-1; Thu, 20 Aug 2020 04:55:48 -0400
X-MC-Unique: adU--VGQNZumtwxb7bGD7A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5EBD800493;
        Thu, 20 Aug 2020 08:54:49 +0000 (UTC)
Received: from wolverine.usersys.redhat.com (unknown [10.35.206.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EBAB510013C2;
        Thu, 20 Aug 2020 08:54:44 +0000 (UTC)
From:   Gal Hammer <ghammer@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcel Apfelbaum <mapfelba@redhat.com>,
        Gal Hammer <ghammer@redhat.com>
Subject: [PATCH] igb: read PBA number from flash
Date:   Thu, 20 Aug 2020 11:54:40 +0300
Message-Id: <20200820085440.322198-1-ghammer@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixed flash presence check for 82576 controllers so the part
number string is read the displayed correctly.

Signed-off-by: Gal Hammer <ghammer@redhat.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 4f05f6efe6af..9b6992adccd4 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3389,7 +3389,9 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			  "Width x1" : "unknown"), netdev->dev_addr);
 	}
 
-	if ((hw->mac.type >= e1000_i210 ||
+	if ((hw->mac.type == e1000_82576 &&
+	     rd32(E1000_EECD) & E1000_EECD_PRES) ||
+	    (hw->mac.type >= e1000_i210 ||
 	     igb_get_flash_presence_i210(hw))) {
 		ret_val = igb_read_part_string(hw, part_str,
 					       E1000_PBANUM_LENGTH);
-- 
2.26.2

