Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB5EBF08DD
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 23:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729989AbfKEWBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 17:01:52 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34284 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729747AbfKEWBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 17:01:52 -0500
Received: by mail-wm1-f68.google.com with SMTP id v3so872855wmh.1
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 14:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=JbQ63CIlCilorne9jZqX8W8ZpYdUcgK6VSrsVwc+1vE=;
        b=t4gOold5ZLhPHa8jtY9egZFUrf+A/g340ugjI6oISMY5WBcujJr1W5BBHfKGekboJq
         dJCIMcNi+jg5JMCbgH/AAe6cDK004SFOSd+P0ox8DMzubgxUtl78Ri8qbyF9XBykVHwU
         2IArhFYx6PFq7ZEWsm9gRU+QMpC7ZFxTXGlK/n8XW4aOo4HcGf3jbdOKUMxDyt+zg0JV
         m0cM/D0ZKD81PCx7T9BRo1GKBsld4cR7eYjTh1Fj3ak6+xMGxDyTb7HHYT9DuV8cNktB
         caLZ31xX/1tjmgv1gmPev5PXxqtnk4yZYm+jNgOC6RCaSsqCVtZKR+NJg43jVVMeZWZQ
         +vog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JbQ63CIlCilorne9jZqX8W8ZpYdUcgK6VSrsVwc+1vE=;
        b=G75heILQqWsjYX1isK3oNsfabpffYYXsHDQxEjfXY35KIgf29XW7R68uUyudeM0gOF
         nn6hroQ/eQ5X6+ypMcd1ksLHlC1uvhjG9grP1yp1LJXw4Cw0tYCUVnhEvn0QQlElWwPW
         TLnnnddzyxBO0M85ZkX+zD5tJh+dSl0gojFejp79ip8M4bYv0Z4INxYjhTOQ7myfvjyM
         GcNyYqN3NkCjZHMApH66ARUJmNIjsvRpbbmw2mWycwvXCGB44pnCTyBlc+dCUARRHeSJ
         jOeaWI+/cCgMyV6DvPYKZgpiYvPbugnZBCZN9/wiAdjZ8wrTDI2ysK3FrK0kcBJTrkqE
         ohGw==
X-Gm-Message-State: APjAAAUMLUJzKYM37AjHOfYIqXu5Ch2u8KifHj5z+fgu7+MMmDY/mEwt
        idb3mCnSotYAHuFOGbjwylI=
X-Google-Smtp-Source: APXvYqwxHFhWlEwpTeWe/qqr16vUxU0DWoeUfW0U280zbx1E9xxSqAH+uqHu9n8zlOWbWqxpoM65Ew==
X-Received: by 2002:a1c:a9cb:: with SMTP id s194mr1082698wme.92.1572991310118;
        Tue, 05 Nov 2019 14:01:50 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id f143sm924527wme.40.2019.11.05.14.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 14:01:49 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next] net: mscc: ocelot: fix __ocelot_rmw_ix prototype
Date:   Wed,  6 Nov 2019 00:01:40 +0200
Message-Id: <20191105220140.15093-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "read-modify-write register index" function is declared with a
confusing prototype: the "mask" and "reg" arguments are swapped.

Fortunately, this does not affect callers so far. Both arguments are
u32, and the wrapper macros (ocelot_rmw_ix etc) have the arguments in
the correct order (the one from ocelot_io.c).

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/ethernet/mscc/ocelot.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 8dbe84add3cf..ea1ff68f0ce4 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -525,7 +525,7 @@ void __ocelot_write_ix(struct ocelot *ocelot, u32 val, u32 reg, u32 offset);
 #define ocelot_write_rix(ocelot, val, reg, ri) __ocelot_write_ix(ocelot, val, reg, reg##_RSZ * (ri))
 #define ocelot_write(ocelot, val, reg) __ocelot_write_ix(ocelot, val, reg, 0)
 
-void __ocelot_rmw_ix(struct ocelot *ocelot, u32 val, u32 reg, u32 mask,
+void __ocelot_rmw_ix(struct ocelot *ocelot, u32 val, u32 mask, u32 reg,
 		     u32 offset);
 #define ocelot_rmw_ix(ocelot, val, m, reg, gi, ri) __ocelot_rmw_ix(ocelot, val, m, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
 #define ocelot_rmw_gix(ocelot, val, m, reg, gi) __ocelot_rmw_ix(ocelot, val, m, reg, reg##_GSZ * (gi))
-- 
2.17.1

