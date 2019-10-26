Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31404E58A9
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 06:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbfJZExn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 00:53:43 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:38930 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbfJZExn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 00:53:43 -0400
Received: by mail-io1-f65.google.com with SMTP id y12so4772118ioa.6;
        Fri, 25 Oct 2019 21:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=n5KOO+EL9idVh7eyuzBzaVpIbSCn7fi8k+LC/dyPmw8=;
        b=b/oBhuEAmsY3AqcO56IWg+K8q729Tc8YT6BE5eNQFsO3Tx3Mu8pHNxHzqbScBO5LE+
         l51O8sFk9LVlfBixV+IoVPi57hf75it9yJuzkN82gsybEdJ9rSDkNTR4Y7ZPvzl0cNdV
         GGx0g6nvVDZv6+CxJfL0qf3orghLr2t8UgUoVtvcBfkdoPrhi9lYcpltxdR1npdwfKSX
         4QftMuf9pSEd6tu8OSV2ar+GrNdXpV5uWwrH/84+/cpTdbjUhyWPx6PPNJ3jRMZKkB3t
         aP/tbIt7d2X/skXNO7ja/iCTPIYZbP0z/bW9JjKCnFUdaC0MjnC69x1zWGaqMJ+quIIF
         LCaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=n5KOO+EL9idVh7eyuzBzaVpIbSCn7fi8k+LC/dyPmw8=;
        b=XfOxSuPB5SbZ9oXBrCJperRDo7j18XdhGKH92KDdp8kyh98yDpDYX4T2p3fXKxEHIx
         0fyD/1Ecek4xwlPYHmjSMql8Z4ewiAU2sEu7Fbo/3fy3OfQ7mMcr+WPqWTU2vXsNpb6n
         x5v8XBX8KwOQY04AVoGO0r3im4NtR84T/ovZS4ptXg8PyCyjnKwB77W666p5OWaaEHrk
         Z4SFWhDoD5TUaGXxuvtUhUDBeY+8qAYO1d5/QdWknUm8sZoiSYpoErDMQkN+lQixb/Il
         30stdluhpS254FGU7OuHx0UJIZTkPmdG+Cg/AjoXCzbGRLDDK8r+o/eo4Zk7fobZaYYS
         AwrA==
X-Gm-Message-State: APjAAAXU6zGWpofVoCO5Tq6NyMCOqI7cMsmIcpbm8/rfdTCgVuW+MuNv
        Yo5qVwAwaySy1vSvOeIedoM=
X-Google-Smtp-Source: APXvYqxbYsEPm6cmhXvXRUmf3fxFguZxkLImH2y5WHFZSCTYcL9nTtAJBYjfLk0NZmYl+h1w41C4uA==
X-Received: by 2002:a02:6a05:: with SMTP id l5mr7692929jac.64.1572065621997;
        Fri, 25 Oct 2019 21:53:41 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id y26sm465429ion.1.2019.10.25.21.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 21:53:41 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        linux-wimax@intel.com, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wimax: i2400: Fix memory leak in i2400m_op_rfkill_sw_toggle
Date:   Fri, 25 Oct 2019 23:53:30 -0500
Message-Id: <20191026045331.1097-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the implementation of i2400m_op_rfkill_sw_toggle() the allocated
buffer for cmd should be released before returning. The
documentation for i2400m_msg_to_dev() says when it returns the buffer
can be reused. Meaning cmd should be released in either case. Move
kfree(cmd) before return to be reached by all execution paths.

Fixes: 2507e6ab7a9a ("wimax: i2400: fix memory leak")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/net/wimax/i2400m/op-rfkill.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wimax/i2400m/op-rfkill.c b/drivers/net/wimax/i2400m/op-rfkill.c
index 8efb493ceec2..5c79f052cad2 100644
--- a/drivers/net/wimax/i2400m/op-rfkill.c
+++ b/drivers/net/wimax/i2400m/op-rfkill.c
@@ -127,12 +127,12 @@ int i2400m_op_rfkill_sw_toggle(struct wimax_dev *wimax_dev,
 			"%d\n", result);
 	result = 0;
 error_cmd:
-	kfree(cmd);
 	kfree_skb(ack_skb);
 error_msg_to_dev:
 error_alloc:
 	d_fnend(4, dev, "(wimax_dev %p state %d) = %d\n",
 		wimax_dev, state, result);
+	kfree(cmd);
 	return result;
 }
 
-- 
2.17.1

