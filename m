Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA014197FA7
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 17:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729283AbgC3Pb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 11:31:56 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:36956 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbgC3Pb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 11:31:56 -0400
Received: by mail-pj1-f66.google.com with SMTP id o12so7492201pjs.2
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 08:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=rHh3OcknGNEteHCIk+STUcpF/+h5o1zQsZ443VLC8I4=;
        b=VsbTeDyAyr32k//9TqgZOR9ZqEcVySLsckus573JeLBhnOvJM9rVCo/kXR1KrCuMak
         Wxn5qyfMIKSXHPRenmsBhSsJxKOjhrEyTIBrFGkK8JSasGf/jjSMOp6EAqA+0CmilEIW
         SND19N3vwGRTtD6HOD9N5t9dbeFt2g/pcKq1boITZ1Jwx32B2pCJXYbrahU245jUIr+L
         JnRm3G9fReQCgLmYuyEoRN83kBI4Vw23FcOl3h9WjB3Cv2T/2hgJ/7yU0S7xSDgEAe3C
         Y2CVmL+f1vxJ4+vF5APHu540RdTKfrG+DWh8tUH28fe2YPjN/I4bRcrNqGZYqQkq8Y2A
         +sgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rHh3OcknGNEteHCIk+STUcpF/+h5o1zQsZ443VLC8I4=;
        b=YFtv20cFYJBOwJC8sm0wnF235olE/4XE/iIMVeQGyR/1OCNweBekhEt2+Vvj+XEpoY
         D2TTx8Rl5VpdILmqIeVlpsES+giqJ1Yvc6ALYxKcTEauXpL6pvlAzH6pgLvMR3cXW22V
         jzikjEvF5I14EMYYA6SPF+QwN2mESaZS/7h1ebywi3JXbpCur6Y4SaBbaEfp88JXf14n
         A9IvXjGa/gR8SpOLqeqKp9h3dkFP3FrcSklwnsE2ahgilESg7v91ITDSBhlojz6deWHN
         PhGJxKFIIwgeYtelUQHRAyfSWUda7UYbDUDvJqHKq4lcNH9WW7XxeO63+nx7KAbexA4v
         Hqsg==
X-Gm-Message-State: ANhLgQ1hchwibZXI4IilZo8qW8vgzCDt0aPumzuMcvh0NP4BkakAvfBK
        5KHNsGDt+IgDUF5qoMVqZIXd6LhJ
X-Google-Smtp-Source: ADFU+vucs35LsqScRS5WVlk/adMXpO04YCh282HmjMihv1jxqRKKz3GcvmucS8dwuvzHHN6z7zv8ZQ==
X-Received: by 2002:a17:90a:37ea:: with SMTP id v97mr16952290pjb.26.1585582313643;
        Mon, 30 Mar 2020 08:31:53 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x188sm5640831pgb.76.2020.03.30.08.31.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Mar 2020 08:31:53 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net] udp: initialize is_flist with 0 in udp_gro_receive
Date:   Mon, 30 Mar 2020 23:31:45 +0800
Message-Id: <6014932c7cdef91c11cdb0dcf73dbf77b65f8638.1585582305.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Without NAPI_GRO_CB(skb)->is_flist initialized, when the dev doesn't
support NETIF_F_GRO_FRAGLIST, is_flist can still be set and fraglist
will be used in udp_gro_receive().

So fix it by initializing is_flist with 0 in udp_gro_receive.

Fixes: 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/udp_offload.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 1a98583..e67a66f 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -453,6 +453,7 @@ struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
 	unsigned int off = skb_gro_offset(skb);
 	int flush = 1;
 
+	NAPI_GRO_CB(skb)->is_flist = 0;
 	if (skb->dev->features & NETIF_F_GRO_FRAGLIST)
 		NAPI_GRO_CB(skb)->is_flist = sk ? !udp_sk(sk)->gro_enabled: 1;
 
-- 
2.1.0

