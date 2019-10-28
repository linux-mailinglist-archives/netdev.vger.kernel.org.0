Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEE7E778E
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 18:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731836AbfJ1RYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 13:24:42 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45762 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730402AbfJ1RYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 13:24:42 -0400
Received: by mail-pf1-f193.google.com with SMTP id c7so6151153pfo.12
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 10:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=zei+itK9l69qPYdDOUyL0hXlzNIrf8Um9vf7savw6V4=;
        b=t7Y4Vog/pNMataqZxWwJT9FT7uAbIUVK+nAfptFm3IO4rv0ewiwF3fXFx4uQvbYp1M
         EL/5VT35pPuXh4/9RixFUn4q7+WyzktngKpHejkVXUJHR8nqsusKu1ooekXI+nYoa6kg
         ocDlBxWaIuB44Ur79ASHY0sgfzCAPBPlrQiI0UJG61wgBojAuv4FtPB4brYHMP6axQXP
         400c2jmN66USsHCHt6KNXwi7AsQusLULU1noM+4lkRSVFWWUdGtkHdVXURue84T2Ztwv
         8M3jsBheqoGLhaZoI6ljvA5T1SQ8/ikohLqHlPJ82vHYMyldY/zM+3ExkVHuSVbQz1ei
         QDoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zei+itK9l69qPYdDOUyL0hXlzNIrf8Um9vf7savw6V4=;
        b=Uvz73RR5CqDNFCnOm8+V1+qKD7dtBPwgmIuROv9g49f7+AFomp7gelBwnAx//03heL
         WG6aotp2Fy9/au+2ExufcPrSfo7QCIclAe3ythS5Sa3I/hPsQdcfuSYaUbPxruVCIFIp
         KlsISnfMYGz330iTu7A9kOgg3FKbGSmc5CRhs15BH+lza0oQet9ZIjw6h+gWG2tI0j+q
         hghW6L5WJqNxdRdmXpypJezqKtlirFxyyrjgJIhA2M/cyVpeVeRM4A6ukshHUR2+el8Y
         WSwKY8dNQgRaflqQiGixpP4wf4kzieBYxTEd5aKM5qLtAngiHn+6HV9QSnYiU46GAdqq
         dPIw==
X-Gm-Message-State: APjAAAWhdwembjrzVsH+XqPMUX/4U6ZxqqKmGk//1Hzsy8HA2q3fqfi1
        8H70aRBIGmGqVICpjIH1U4Bjtr26
X-Google-Smtp-Source: APXvYqxEP2lDwqhnASv28JfFmrqjCBpUJUnGYAhP4j6XEqN4aS2E2YVCWdhnVVzob4sUXz+bA5H5sQ==
X-Received: by 2002:a63:c405:: with SMTP id h5mr21996468pgd.60.1572283481037;
        Mon, 28 Oct 2019 10:24:41 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q8sm11060377pgg.15.2019.10.28.10.24.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Oct 2019 10:24:40 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Thomas Graf <tgraf@suug.ch>
Subject: [PATCH net] vxlan: check tun_info options_len properly
Date:   Tue, 29 Oct 2019 01:24:32 +0800
Message-Id: <7cd6d34cc1a13810805b08da771848cfff315d5c.1572283472.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to improve the tun_info options_len by dropping
the skb when TUNNEL_VXLAN_OPT is set but options_len is less
than vxlan_metadata. This can void a potential out-of-bounds
access on ip_tun_info.

Fixes: ee122c79d422 ("vxlan: Flow based tunneling")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 drivers/net/vxlan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index fcf0282..ac5c597 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2487,9 +2487,11 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 		vni = tunnel_id_to_key32(info->key.tun_id);
 		ifindex = 0;
 		dst_cache = &info->dst_cache;
-		if (info->options_len &&
-		    info->key.tun_flags & TUNNEL_VXLAN_OPT)
+		if (info->key.tun_flags & TUNNEL_VXLAN_OPT) {
+			if (info->options_len < sizeof(*md))
+				goto drop;
 			md = ip_tunnel_info_opts(info);
+		}
 		ttl = info->key.ttl;
 		tos = info->key.tos;
 		label = info->key.label;
-- 
2.1.0

