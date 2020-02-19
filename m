Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1601B1651CB
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 22:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbgBSVka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 16:40:30 -0500
Received: from mail-vk1-f201.google.com ([209.85.221.201]:42881 "EHLO
        mail-vk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727277AbgBSVka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 16:40:30 -0500
Received: by mail-vk1-f201.google.com with SMTP id i1so521559vkn.9
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 13:40:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=IWorHT+RbYCp+X2EYh29qWi7j3yfSjHRDqA3zJbIl0g=;
        b=kOM4sznaDhCK0uW7TbvidCjL6zr7MehwrBH4V9wWqZx8xutDYcsNQEJTOcELTO5hLx
         S/j2SbJaY5Uf6lbZ3T2atZ0EpAz5ay/ALwGqL/eZQIlLhZw8AYnA3MQ1J8t/5cRD3s0P
         xin2kSGVCzyjm5WfP/L/bb3rBNvFgdhV0BirDUSZQ+EFVGIC4k9dI/peA+9AENIGgnGJ
         Vq1XzRf475/vVM2Z6VwkqqFRIz4GkUziPHMpmN8QeuaKk6XcDZCV4ADt3HmCK2KdVUNR
         gtpUTU3S2+b9r1y4IEO71a6HI6+cxNbgG56r1w3q9newiwGbCNCaNyWtgED9dwKUJJs7
         ME1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=IWorHT+RbYCp+X2EYh29qWi7j3yfSjHRDqA3zJbIl0g=;
        b=LwsoBY+rGCajV0JZVM2VD+sCWkbKN/dutXu8sqCQ8kufiXbrjg+b91lyItL7dsAusy
         sX0XrMxiBKgusZSINiTMQMuvON9/f9Ei7b/+Bw6u9EOzZElg+bxnetYzcK6G8vf9bdR2
         qTUvoVEsEq98KVIAtHLC1oNN/dnSkOE3f/A92jUGlMhjn3xE/ScE4q3mVrioicWVpvrI
         QfT10xK5nEl0BFqVu5sa6+garLKbzj5Nv2dQoAuvlOgjjPz4tA8/dr9E7ZBBHOHDxwm8
         xNkB6fiUlFQf8UEbANj9Qbnduj1pVB2bum/zSTLat6PM3PJabqxydY1ZDBh4jhhlOeUn
         duXw==
X-Gm-Message-State: APjAAAXXxhYzJ7UK++kN783ZvEnNW7n737BtO4OGme8L0warcVHxEy/B
        mdvARnDlxP4tvp3jv15nDqse0NXI
X-Google-Smtp-Source: APXvYqzrLJWVAExg4+vtxs4xIK8C1KopaghL3PH8CenYcmsRQWHfDAang269rHO2sK86ArQtR/hz9W+W
X-Received: by 2002:a67:f155:: with SMTP id t21mr15366793vsm.80.1582148428975;
 Wed, 19 Feb 2020 13:40:28 -0800 (PST)
Date:   Wed, 19 Feb 2020 13:40:06 -0800
Message-Id: <20200219214006.175275-1-rkir@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [PATCH v2] net: disable BRIDGE_NETFILTER by default
From:   rkir@google.com
To:     davem@davemloft.net, kuba@kernel.org
Cc:     rammuthiah@google.com, adelva@google.com, lfy@google.com,
        netdev@vger.kernel.org, Roman Kiryanov <rkir@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roman Kiryanov <rkir@google.com>

The description says 'If unsure, say N.' but
the module is built as M by default (once
the dependencies are satisfied).

When the module is selected (Y or M), it enables
NETFILTER_FAMILY_BRIDGE and SKB_EXTENSIONS
which alter kernel internal structures.

We (Android Studio Emulator) currently do not
use this module and think this it is more consistent
to have it disabled by default as opposite to
disabling it explicitly to prevent enabling
NETFILTER_FAMILY_BRIDGE and SKB_EXTENSIONS.

Signed-off-by: Roman Kiryanov <rkir@google.com>
---
Changes in v2:
 - added cc:netdev@vger.kernel.org

 net/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/Kconfig b/net/Kconfig
index b0937a700f01..2eeb0e55f7c9 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -189,7 +189,6 @@ config BRIDGE_NETFILTER
 	depends on NETFILTER_ADVANCED
 	select NETFILTER_FAMILY_BRIDGE
 	select SKB_EXTENSIONS
-	default m
 	---help---
 	  Enabling this option will let arptables resp. iptables see bridged
 	  ARP resp. IP traffic. If you want a bridging firewall, you probably
-- 
2.25.0.265.gbab2e86ba0-goog

