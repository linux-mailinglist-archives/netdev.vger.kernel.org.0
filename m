Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D58B63FF446
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 21:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347422AbhIBTgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 15:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347424AbhIBTf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 15:35:59 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF90C061760
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 12:35:00 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id y144so3422529qkb.6
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 12:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xRwXRJgWD0QaKpAlW4aJsPrtNMyk9raZfHT3lINU6X8=;
        b=YCMcLEHQe/zLGwWxCudaNy77wW1EAGQAh+doyd2aUi6Oc29A1kTozJDTsvlhmT4vCB
         jWmJvN7TL9pPqSeUFh76G0s7NVXfuEr+fyOaw3mk2HfyjMX7rwcicW8+WwcL/6sX8gWn
         1L+lSIYEcE3kE5Sy4szpe8eNPI9B1x0TfOSakInKS1m7T7e57PsW1oEIz3Bc7Qh8VV7N
         q/xq2u1qhPCaHGbl43MXHrORUkHPlr80Vowe2Uwsmx0WmteE6HVQHi77lbGcm45aICPa
         B8MkJuUG+tf5Uf1lFqhTzbibAisYag6s+GP17ZlBRcegOhowwFQToBv/mVOIqsSqjmL3
         Zapw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xRwXRJgWD0QaKpAlW4aJsPrtNMyk9raZfHT3lINU6X8=;
        b=JTeiEMNTcmS8f0D8i1lJDgOoPHbkWF4UR4aI2Rk9dqk+4H/9k5cOuhhUk5xfYXjNgj
         qj7ilnTnr04xGULV5mu8L+n5vdVTXVLp3LbFIEgb79Grw5RyFFLWV+nPenbfRUE0UcrP
         pF+KqO6dWgKNsADJ67lW4rP0JzCRIu4mecaowQRvi990hqmNN3OOW0e+YS/qKZSLyT3j
         SVLlHONacP3J+2fFNwg/6m0fA0SOa4ZqeZLUFd61iohmAMjX/XoOyhDlM1XOdZqZV6xH
         HnqoZiAQSNH6cEDy0yHUiuMoiC+WiQ1suBDo7Mz2vdR86j/cdt86LZZte7ZOULZXbOXd
         kv/Q==
X-Gm-Message-State: AOAM530J1kyR6Vjnuh4qbZ64A1iJkYunga4a3ADfTgohjy/vqMDv0jby
        X1N31qL58r5lA8Tcd1tiIgkq8vg/Be5SJQ==
X-Google-Smtp-Source: ABdhPJzUODhO/cmhHE/fOnnMaRyf/bJyEBPWLIAX4e6oRQMUkn9BQgm+SdCKiltmi21wdOzvLXCW4A==
X-Received: by 2002:a37:624a:: with SMTP id w71mr4713008qkb.81.1630611299344;
        Thu, 02 Sep 2021 12:34:59 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:77a8:7a00:56f4:e83e])
        by smtp.gmail.com with ESMTPSA id w18sm1595877qto.91.2021.09.02.12.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 12:34:58 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@idosch.org,
        chouhan.shreyansh630@gmail.com,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net] ip_gre: validate csum_start only if CHECKSUM_PARTIAL
Date:   Thu,  2 Sep 2021 15:34:47 -0400
Message-Id: <20210902193447.94039-2-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
In-Reply-To: <20210902193447.94039-1-willemdebruijn.kernel@gmail.com>
References: <20210902193447.94039-1-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Only test integrity of csum_start if checksum offload is configured.

With checksum offload and GRE tunnel checksum, gre_build_header will
cheaply build the GRE checksum using local checksum offload. This
depends on inner packet csum offload, and thus that csum_start points
behind GRE. But validate this condition only with checksum offload.

Link: https://lore.kernel.org/netdev/YS+h%2FtqCJJiQei+W@shredder/
Fixes: 1d011c4803c7 ("ip_gre: add validation for csum_start")
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 net/ipv4/ip_gre.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 177d26d8fb9c..09311992a617 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -473,8 +473,11 @@ static void __gre_xmit(struct sk_buff *skb, struct net_device *dev,
 
 static int gre_handle_offloads(struct sk_buff *skb, bool csum)
 {
-	if (csum && skb_checksum_start(skb) < skb->data)
+	/* Local checksum offload requires csum offload of the inner packet */
+	if (csum && skb->ip_summed == CHECKSUM_PARTIAL &&
+	    skb_checksum_start(skb) < skb->data)
 		return -EINVAL;
+
 	return iptunnel_handle_offloads(skb, csum ? SKB_GSO_GRE_CSUM : SKB_GSO_GRE);
 }
 
-- 
2.33.0.153.gba50c8fa24-goog

