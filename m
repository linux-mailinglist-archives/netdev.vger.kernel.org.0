Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16AFB91861
	for <lists+netdev@lfdr.de>; Sun, 18 Aug 2019 19:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbfHRRgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 13:36:17 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41930 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbfHRRgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 13:36:16 -0400
Received: by mail-qk1-f195.google.com with SMTP id g17so8761689qkk.8
        for <netdev@vger.kernel.org>; Sun, 18 Aug 2019 10:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Jwo9xr/L4P4TrEBSBhfkVcUkd1Ohf7qoqxu7/5pkUVk=;
        b=fT33w+wuVt5i89cQXAZwXi3pim7X5i1+oTqLhC3rZ6UiOG432DanQDUlt6HyqDeOic
         Qf+fiUa8x0kjpybPG/ex4GhLcCGSlUxAFyT677oQa3os2R/xbWHz5sM7HFdXsgi9lPb1
         /V2UJOcQWTOyt7M0GriGRUd2QIoXjFRROqRDRdyQUvlTPn3S1YHz7Y+rLciAIwIW+Lui
         RMFJmY3djJKAK5jyl9AuO7IPQOMCNciUKGjcfRxmjrNpY6DMeAgb49T2Px2C6w8i8oZa
         9fKwvXlue4VCtDPoR/eWTPZQRfUOoNSg299n8wPl/xmmjYGVNZdrTgf6oMe6tOJ7bhOR
         6nYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Jwo9xr/L4P4TrEBSBhfkVcUkd1Ohf7qoqxu7/5pkUVk=;
        b=sSnOZJ4rlG9x8vz9vaBNq1+yrn9IwoRUFYZ8YDPASTpufonCm+d1AKlBlRgzqc9uqn
         +DGMylF4mW5vsvMRPL7eRlgWR9Jlc+3qeuShTTOR2F5ioKG9iEhhC7hIAmzOrszSlXXX
         kgiRi+MROsh5zzSyiTfnPAJYYHanQg+cI2HEpAgTfhNfW4QVjUxB5/eq3yE9LwuyCAsH
         ChwFaVyl3IuYBFjXAncIccpp6+yH9ZgjukgHY9cEgKtQPQRcNu2UR3nNvwpxur6FbYtm
         xQfJE3jopkrFnGlK1zgLKyhOSxu9aUZnUpdxlLQY9Z2772uZnNMJyfb22J+077zjHRqi
         3Fvw==
X-Gm-Message-State: APjAAAU/IEVVYy51lhpZGZftzUKr1iaorTLGn8v4I9vV/O0WXF4+YeqP
        u1rzEKFVQSZtJDCZoQcxg1cmFDay
X-Google-Smtp-Source: APXvYqx7tytdERb2iK8EP36eYmZt6CUgXvj+S8lHHMyn/B6DmvA3HhfPL2GytVF5lim9WPAHPIpmxw==
X-Received: by 2002:a37:4fcf:: with SMTP id d198mr17652334qkb.394.1566149775379;
        Sun, 18 Aug 2019 10:36:15 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id i12sm5470057qki.122.2019.08.18.10.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Aug 2019 10:36:14 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     marek.behun@nic.cz, davem@davemloft.net, f.fainelli@gmail.com,
        andrew@lunn.ch, Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 3/6] net: dsa: enable and disable all ports
Date:   Sun, 18 Aug 2019 13:35:45 -0400
Message-Id: <20190818173548.19631-4-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190818173548.19631-1-vivien.didelot@gmail.com>
References: <20190818173548.19631-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Call the .port_enable and .port_disable functions for all ports,
not only the user ports, so that drivers may optimize the power
consumption of all ports after a successful setup.

Unused ports are now disabled on setup. CPU and DSA ports are now
enabled on setup and disabled on teardown. User ports were already
enabled at slave creation and disabled at slave destruction.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 net/dsa/dsa2.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 405552ac4c08..8c4eccb0cfe6 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -264,6 +264,7 @@ static int dsa_port_setup(struct dsa_port *dp)
 
 	switch (dp->type) {
 	case DSA_PORT_TYPE_UNUSED:
+		dsa_port_disable(dp);
 		break;
 	case DSA_PORT_TYPE_CPU:
 		memset(dlp, 0, sizeof(*dlp));
@@ -274,6 +275,10 @@ static int dsa_port_setup(struct dsa_port *dp)
 			return err;
 
 		err = dsa_port_link_register_of(dp);
+		if (err)
+			return err;
+
+		err = dsa_port_enable(dp, NULL);
 		if (err)
 			return err;
 		break;
@@ -286,6 +291,10 @@ static int dsa_port_setup(struct dsa_port *dp)
 			return err;
 
 		err = dsa_port_link_register_of(dp);
+		if (err)
+			return err;
+
+		err = dsa_port_enable(dp, NULL);
 		if (err)
 			return err;
 		break;
@@ -317,11 +326,13 @@ static void dsa_port_teardown(struct dsa_port *dp)
 	case DSA_PORT_TYPE_UNUSED:
 		break;
 	case DSA_PORT_TYPE_CPU:
+		dsa_port_disable(dp);
 		dsa_tag_driver_put(dp->tag_ops);
 		devlink_port_unregister(dlp);
 		dsa_port_link_unregister_of(dp);
 		break;
 	case DSA_PORT_TYPE_DSA:
+		dsa_port_disable(dp);
 		devlink_port_unregister(dlp);
 		dsa_port_link_unregister_of(dp);
 		break;
-- 
2.22.0

