Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C67726BBB5
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 07:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgIPFHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 01:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgIPFHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 01:07:17 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF55C06174A;
        Tue, 15 Sep 2020 22:07:16 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id q12so524795plr.12;
        Tue, 15 Sep 2020 22:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qRRVZQATJVxdmxym9cYS4r8KR3RWYxM+eecLHTbYKPE=;
        b=aVC2T637dzhAw/XBS0mqij3Sm2gNdKH71qrUuBjRZC4Xc2udN+J6iTb+mtgJeGDfzX
         1iu9AFzMGkFfU0GRVYO5vVDboPQs8etP9zBvfmulOczq9JdFP0x9UKBnpzo8S0FCx/Vy
         TcfffegkK3cRDB+1LS7J0dl1/CADD3Zld/eWTsXXYrtuky2GwRm/5/8ZnJukNHSjr2zl
         AeeUPEGh5+QicmNMzFWuBL86RyUX0qDUb1WjlyqKIBfNjSYImx3Aixn1HMD0Y3BuI/Pb
         zkZQKpurvYn2vNPo4v8UfqjZrwKbm5kWHqgIIUEQvprgL+LaQSZMi3jMSAOb0BMDt2xL
         gwhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qRRVZQATJVxdmxym9cYS4r8KR3RWYxM+eecLHTbYKPE=;
        b=TNChEVhglcAhlVllH4slASOAEyrBypKKR/NLil9VcWXwKk9lgdbqKxNDKVzEzS7II8
         S1ifOu46mkBULId2Uj/0ll/QS+2uq28psOo7diA8wKrQphe/OcRsRIUtl9keXdya5Pd4
         KPxn+EG0j5AJ+lLixP5mk4WDaMeSZwtWJScJ9Qc81riMKr7XxJ+yB/+Hz5s3ilPov2fc
         64eO6+RDkMmHQpQ2tZQdXDU8+E5N5mzD/SPF/5h/q2DLCRdtXzh+dRnA4tbcbkR0jbkG
         cOzDfk50eQ1gdmyXcV1zove7y4+HPl0SNLtgnKaXH+ACeHMUp9nfD3k6U/8yN8jR/l6s
         1zJw==
X-Gm-Message-State: AOAM531rLiED2ktKJSu5ZkyleetBuyWQkrOOlqvi/4M/H1lx93KPoGT3
        ktj58wuafwG7MqmRtvDsfjcrsNnMbGZGx3TRk4Y=
X-Google-Smtp-Source: ABdhPJyJ+cNX0PC6p643Vv5Ufb4fI56gTf58TjK5qVI6yEX/Z6q7hcMqJYTTdXwOCzLJs8JTaoE69Q==
X-Received: by 2002:a17:902:b185:b029:d1:e5e7:bdd1 with SMTP id s5-20020a170902b185b02900d1e5e7bdd1mr4953338plr.49.1600232836024;
        Tue, 15 Sep 2020 22:07:16 -0700 (PDT)
Received: from localhost.localdomain ([49.207.198.18])
        by smtp.gmail.com with ESMTPSA id i20sm13108051pgk.77.2020.09.15.22.07.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 22:07:15 -0700 (PDT)
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com,
        Petko Manolov <petkan@nucleusys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [Linux-kernel-mentees][PATCH] rtl8150: set memory to all 0xFFs on failed register reads
Date:   Wed, 16 Sep 2020 10:35:40 +0530
Message-Id: <20200916050540.15290-1-anant.thazhemadam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

get_registers() copies whatever memory is written by the
usb_control_msg() call even if the underlying urb call ends up failing.

If get_registers() fails, or ends up reading 0 bytes, meaningless and 
junk register values would end up being copied over (and eventually read 
by the driver), and since most of the callers of get_registers() don't 
check the return values of get_registers() either, this would go unnoticed.

It might be a better idea to try and mirror the PCI master abort
termination and set memory to 0xFFs instead in such cases.

Fixes: https://syzkaller.appspot.com/bug?extid=abbc768b560c84d92fd3
Reported-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com
Tested-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
---
 drivers/net/usb/rtl8150.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index 733f120c852b..04fca7bfcbcb 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -162,8 +162,13 @@ static int get_registers(rtl8150_t * dev, u16 indx, u16 size, void *data)
 	ret = usb_control_msg(dev->udev, usb_rcvctrlpipe(dev->udev, 0),
 			      RTL8150_REQ_GET_REGS, RTL8150_REQT_READ,
 			      indx, 0, buf, size, 500);
-	if (ret > 0 && ret <= size)
+
+	if (ret < 0)
+		memset(data, 0xff, size);
+
+	else
 		memcpy(data, buf, ret);
+
 	kfree(buf);
 	return ret;
 }
@@ -276,7 +281,7 @@ static int write_mii_word(rtl8150_t * dev, u8 phy, __u8 indx, u16 reg)
 
 static inline void set_ethernet_addr(rtl8150_t * dev)
 {
-	u8 node_id[6];
+	u8 node_id[6] = {0};
 
 	get_registers(dev, IDR, sizeof(node_id), node_id);
 	memcpy(dev->netdev->dev_addr, node_id, sizeof(node_id));
-- 
2.25.1

