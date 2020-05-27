Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172551E506C
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 23:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbgE0VZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 17:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgE0VZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 17:25:42 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81ECBC05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 14:25:42 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id m1so6161840pgk.1
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 14:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J2VOOXXZfYrf0j0BZGTqHjZXz3vmkYSxdF+W6kFIlUM=;
        b=Grsi+NfZcOSkP8amdHNoSH455H5jrFeMkEzJSH9cQZzoiNQjZvYu5qzjxSTGsQEVX3
         dc4cAIW+5ot8HvpiNadkZlE2n804EGyYvdSCs8EfVh5PC7erL5s35YOTdIcEWgbrOHzZ
         SvhCHvRZ3PCwmEWz0KxChxNTjKlL8l2F/CURI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J2VOOXXZfYrf0j0BZGTqHjZXz3vmkYSxdF+W6kFIlUM=;
        b=kx7sXARlYvTEG3bjk+AOrHPOOqOcj8Dw7o6qUjPS+vhTMkMgyLP6ukWsQhed0axjO7
         rI5jlyR18fjyoPffQGpepEsGD4+0wEkhO6Oubih/jYyXQ4GUj6G7Gw5RzcbIWvlIvocI
         sUtNaKN0y+2n7Kfvemr4q0aD2vzQ4bvnBRXDfi3kwmkYrfjwsaVpV5qZ/j3iaA/7lI7/
         McKqk/Bms/aeNlFzZnCHujC4bQSDDIdNXoMNv/7LtmSUMUER9yip5yt0i0txotUC5Y6m
         cRpXmUyjyGtz358Cq2eULmf3mGMKLufmSRqbhOUpWpWfT3mKeR/tVcJ3VERgO9kxR7vX
         tYjw==
X-Gm-Message-State: AOAM531njigqkEJjqx6/j7Q02Q8AjDhXsVTDK5iLc6BczcAFBizA2+uH
        60MJRxrEjg1i0R94dQGUkYhgsO6/neRbo5z8Ni3UBJlZVR003hlPUmdi7dNqzjE9mKG+6K85yIS
        5FN38Z78779Cfl5NguDSzsXbFgOI3izp09zMClhJcYhWxiI1GlX/wPJLVkn2RD/SH48koPzZH
X-Google-Smtp-Source: ABdhPJwDSug2TCiNT0AEu160YDkRY8FUOcXqWgrwkGwmLUZpEj3dht0HgFf12VGv6IszkOKoIcgmcQ==
X-Received: by 2002:aa7:8425:: with SMTP id q5mr5615357pfn.98.1590614741542;
        Wed, 27 May 2020 14:25:41 -0700 (PDT)
Received: from localhost.localdomain ([2600:8802:202:f600::ddf])
        by smtp.gmail.com with ESMTPSA id c4sm2770344pfb.130.2020.05.27.14.25.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 14:25:41 -0700 (PDT)
From:   Edwin Peer <edwin.peer@broadcom.com>
To:     netdev@vger.kernel.org
Cc:     Edwin Peer <edwin.peer@broadcom.com>, edumazet@google.com,
        linville@tuxdriver.com, shemminger@vyatta.com,
        mirq-linux@rere.qmqm.pl, jesse.brandeburg@intel.com,
        jchapman@katalix.com, david@weave.works, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, sridhar.samudrala@intel.com,
        jiri@mellanox.com, geoff@infradead.org, mokuno@sm.sony.co.jp,
        msink@permonline.ru, mporter@kernel.crashing.org,
        inaky.perez-gonzalez@intel.com, jwi@linux.ibm.com,
        kgraul@linux.ibm.com, ubraun@linux.ibm.com,
        grant.likely@secretlab.ca, hadi@cyberus.ca, dsahern@kernel.org,
        shrijeet@gmail.com, jon.mason@intel.com, dave.jiang@intel.com,
        saeedm@mellanox.com, hadarh@mellanox.com, ogerlitz@mellanox.com,
        allenbh@gmail.com, michael.chan@broadcom.com
Subject: [RFC PATCH net-next 01/11] net: geneve: enable vlan offloads
Date:   Wed, 27 May 2020 14:25:02 -0700
Message-Id: <20200527212512.17901-2-edwin.peer@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527212512.17901-1-edwin.peer@broadcom.com>
References: <20200527212512.17901-1-edwin.peer@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support offloads for nested VLANs in the same fashion as is done for
VXLAN interfaces. In particular, this allows software GSO and checksum
offload to function when VLANs are encapsulated inside Geneve tunnels.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
---
 drivers/net/geneve.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 6b461be1820b..8d790cf85b21 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1137,6 +1137,8 @@ static void geneve_setup(struct net_device *dev)
 	dev->features    |= NETIF_F_RXCSUM;
 	dev->features    |= NETIF_F_GSO_SOFTWARE;
 
+	dev->vlan_features = dev->features;
+
 	dev->hw_features |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
 	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
 
-- 
2.26.2

