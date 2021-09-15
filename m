Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4563940C16F
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 10:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237068AbhIOINm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 04:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237071AbhIOINT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 04:13:19 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC49C0613DE
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 01:11:54 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id h186-20020a3785c3000000b00425f37f792aso2477466qkd.22
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 01:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cajmSKnfvpV4C51UK3Pjlq0PRtDcgxs8IXvmV4F1Bco=;
        b=MIYh+lurVtarZ7crdmPcrieMH8EZz98B67CS2pRpH+bw+nIifY+/74UZXzCrFVmvG7
         5JNVXmSzUYMT6PjI6EPXSUDNQWJ0WtDfUXOTV574KiQakHURApKafcz71OkdVKsfbYES
         cGTYLboAdCqfpDw4psp0OfGRrZdivXKhQR05iQ0bEBla+cLfZ8Lun5wq2S79odkUsf82
         Ft1meJUUQbSwLBZsoe3vZdLzB1wwu6jtfH6CZvyWrohKZv3afrvUIe6eG7+LQQkv1p0C
         Rb466pXXNvNvL7w9bCjzEvxuIC/e+NPOqYO0ymBiCbYLNQvQXpENU1zwOp5sl88UQ6Cd
         5XtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cajmSKnfvpV4C51UK3Pjlq0PRtDcgxs8IXvmV4F1Bco=;
        b=WLsrq0oMQUr9ARlV8mYgqcL+IyJ7ZQuS7CmgmPlH8gS7hT72PUXk0k/4TahhbLtinJ
         y0KmQbx92Ibjngrd7O4w1Pbe04mJlcKRUbUvpNG0Nw6O0IQpcLvKXXU8bCXQY3M0yMcW
         IrBvbjrhgqmWXxPduffANpKEv0pcf3//iBY2bL3eml4i6c4Dl/nRXYSs56vPymiEVKab
         uQQIHcpOAWBIaXJzSZFWk05Jdpg+2M0YdoCA8++UMIYFZniDuBHp40ZTLbg4SUbK60kI
         mx+bYoe5s+ZJWTSRq1jtvbocZEpgYd9YgXGuMhjh4hFVXAq5mfoUS95Rwev4fSlB1fA6
         E22A==
X-Gm-Message-State: AOAM533y4M+0RfB2yo81q1LvPo9l+rAUcWsGSzqfKQOGoO2owOCtxf20
        6oG78x3hfaXInN5WI6wFw12PVfDwi/hyeV4=
X-Google-Smtp-Source: ABdhPJw1MLQHUnPoE+xMUea0zwhQNWiEbbrDkOr6kvJJOLYN+b9okqykFfE3JvdOltc9UL2WPu1eY+Y4pt4ZAjk=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:16d1:ab0e:fc4a:b9b1])
 (user=saravanak job=sendgmr) by 2002:a0c:ab01:: with SMTP id
 h1mr9553038qvb.0.1631693514157; Wed, 15 Sep 2021 01:11:54 -0700 (PDT)
Date:   Wed, 15 Sep 2021 01:11:36 -0700
In-Reply-To: <20210915081139.480263-1-saravanak@google.com>
Message-Id: <20210915081139.480263-5-saravanak@google.com>
Mime-Version: 1.0
References: <20210915081139.480263-1-saravanak@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v2 4/6] driver core: Add debug logs when fwnode links are added/deleted
From:   Saravana Kannan <saravanak@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Saravana Kannan <saravanak@google.com>
Cc:     John Stultz <john.stultz@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Vladimir Oltean <olteanv@gmail.com>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will help with debugging fw_devlink issues.

Signed-off-by: Saravana Kannan <saravanak@google.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/base/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 5e7faad4e083..f06e8e2dc69b 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -95,6 +95,8 @@ int fwnode_link_add(struct fwnode_handle *con, struct fwnode_handle *sup)
 
 	list_add(&link->s_hook, &sup->consumers);
 	list_add(&link->c_hook, &con->suppliers);
+	pr_debug("%pfwP Linked as a fwnode consumer to %pfwP\n",
+		 con, sup);
 out:
 	mutex_unlock(&fwnode_link_lock);
 
@@ -109,6 +111,8 @@ int fwnode_link_add(struct fwnode_handle *con, struct fwnode_handle *sup)
  */
 static void __fwnode_link_del(struct fwnode_link *link)
 {
+	pr_debug("%pfwP Dropping the fwnode link to %pfwP\n",
+		 link->consumer, link->supplier);
 	list_del(&link->s_hook);
 	list_del(&link->c_hook);
 	kfree(link);
-- 
2.33.0.309.g3052b89438-goog

