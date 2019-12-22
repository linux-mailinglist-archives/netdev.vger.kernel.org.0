Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59B3E128D97
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 12:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfLVL1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Dec 2019 06:27:16 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33689 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfLVL1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Dec 2019 06:27:16 -0500
Received: by mail-pg1-f196.google.com with SMTP id 6so7354675pgk.0
        for <netdev@vger.kernel.org>; Sun, 22 Dec 2019 03:27:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=IIvb4W0obp4Y7npw3Koz3GDFrCfHN29DckGJQTarTzE=;
        b=YNC215pEdLjLSCA/qjotF4JkNOckIRx0jFc4MJ4QrSC5bF8JloDE3KmnHZgDyYNXZJ
         MnOWDPXDoArjhiaSjpoCrXpj/7laVfEOkDS7/eGziGsepsI7L0Yn1hsROwSNtqkZ/0DW
         C4VStEfFqZ5Yeo4Vc16NbXDQuv+5BuB9aDWSZtBxnW17UdlvIDAwxwWOpUNMnoB65xJc
         8fWbMcT+u6O0ikm+0p5aWEJNSftoozbSU+C9bzYho6ZwYCKbIoJxs4HvIvDl4Wp5brDM
         dEyLN4V9o4ixHqnosV4Fy0uu0LzWDUqjnefixTGx7QtKQIqjexXt0O/UKgEZXqks/Ejc
         FfSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=IIvb4W0obp4Y7npw3Koz3GDFrCfHN29DckGJQTarTzE=;
        b=KDavf/OL48r8VtwrKgv5FXApEmMYmtgrWxO0OVFx5jmx06y0LIfl6HJvTpQ6fNyqeW
         +0YciT42RMGiLwcfcjCVgX2tWlyj4xQMCqOfeODPV/eiKiYc5OgBBc1o7QygHnQS536C
         LK58We5fCEyZnSpLnxScOG3d30lzAe+FRneiQ4khGq0gss2rkm3NWDyXdY4Ft3IOnevT
         40hqkYvDfUs8mNkxMc/CwhzjxdyVEOhzM3WWsUDEdYcfFD44nZqM+fLd4tzTMJoQ0TC5
         ir8Ut20fDAKKzCWmeT8prmvHJCD4HDTgbAg+CbePBJNi0kFHEwVq639zWSogDwyU2L59
         7ZBA==
X-Gm-Message-State: APjAAAWbudDXM607/a8lowsDrNj4YfUdS8lIackCeC4rcKwByw0iWkOf
        VWazxSMiVYvQkjzTRVLtUP0=
X-Google-Smtp-Source: APXvYqybT6W1jI0SU/zRiBaIcSBU1cJcrE94LuSdAW+LHVsOzIlVyINjwjqyoHFtdmi9fca6etw9IA==
X-Received: by 2002:a62:7883:: with SMTP id t125mr27735886pfc.141.1577014035229;
        Sun, 22 Dec 2019 03:27:15 -0800 (PST)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id s21sm15363581pji.25.2019.12.22.03.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Dec 2019 03:27:14 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 6/6] hsr: reset network header when supervision frame is created
Date:   Sun, 22 Dec 2019 11:27:08 +0000
Message-Id: <20191222112708.3427-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The supervision frame is L2 frame.
When supervision frame is created, hsr module doesn't set network header.
If tap routine is enabled, dev_queue_xmit_nit() is called and it checks
network_header. If network_header pointer wasn't set(or invalid),
it resets network_header and warns.
In order to avoid unnecessary warning message, resetting network_header
is needed.

Test commands:
    ip netns add nst
    ip link add veth0 type veth peer name veth1
    ip link add veth2 type veth peer name veth3
    ip link set veth1 netns nst
    ip link set veth3 netns nst
    ip link set veth0 up
    ip link set veth2 up
    ip link add hsr0 type hsr slave1 veth0 slave2 veth2
    ip a a 192.168.100.1/24 dev hsr0
    ip link set hsr0 up
    ip netns exec nst ip link set veth1 up
    ip netns exec nst ip link set veth3 up
    ip netns exec nst ip link add hsr1 type hsr slave1 veth1 slave2 veth3
    ip netns exec nst ip a a 192.168.100.2/24 dev hsr1
    ip netns exec nst ip link set hsr1 up
    tcpdump -nei veth0

Splat looks like:
[  175.852292][    C3] protocol 88fb is buggy, dev veth0

Fixes: f421436a591d ("net/hsr: Add support for the High-availability Seamless Redundancy protocol (HSRv0)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/hsr/hsr_device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 62c03f0d0079..c7bd6c49fadf 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -272,6 +272,8 @@ static void send_hsr_supervision_frame(struct hsr_port *master,
 			    skb->dev->dev_addr, skb->len) <= 0)
 		goto out;
 	skb_reset_mac_header(skb);
+	skb_reset_network_header(skb);
+	skb_reset_transport_header(skb);
 
 	if (hsr_ver > 0) {
 		hsr_tag = skb_put(skb, sizeof(struct hsr_tag));
-- 
2.17.1

