Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71E939EBB0
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 16:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729471AbfH0O6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 10:58:17 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38984 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728612AbfH0O6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 10:58:16 -0400
Received: by mail-pg1-f195.google.com with SMTP id u17so12828483pgi.6
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 07:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=E0qCpQfY1FVyhXwa2Y8auM4RmfQ56/MuTUJRW4vnxNw=;
        b=DZ86Rsk24Zpx6xkZwf17oZMozqYGqVr49proiwVFp458MqXs5wBclkx3TzkZCOkbnE
         mlLzvE8f8mmCduYtpG7HPPnBi4KhZcjBlbZHLu9B6kjD3dXP3+gCSb5EJna5c0Q67P/V
         Tsb6kFlodixcRpT83x12WS2bPU6cQUBtcuYHx3qbSB79oPbROEqhjpuH6QevUEdq5Ex9
         cJNThpV0RjSd3Q+EyX7j3T9czz+ISbB9qCH7lJFd81MsEOB7nZlQq8BV5aoG9luceVwJ
         3yFSdMt3mN6EMSq84+cF1XPDlF44sF240Wo1/R2mCeTpYnsE1mVra1EasivLNdIj4kOZ
         GDBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=E0qCpQfY1FVyhXwa2Y8auM4RmfQ56/MuTUJRW4vnxNw=;
        b=Q4X/Q4/Sb4WG15SGPXL1trELbuvpXTfBFkv4AWWJzbJKvin62vv/qJ3Qu9F99bNmUH
         4HCe7vxNeDZktWrQDq5y5J+zMLIMbeYI2nrM/gbBy+jK9MtykCpp9EkeSFVbx/bt5Alv
         io34f5Gt0R7l6fzwbLdNpb8xP4Ya8NvjjqaKQekub81WeyOorrU8Gq6AexH0Za/TDc7k
         nhalq836vPfm083eT4x8NCGm7wC1SRxF7u/rfLg7sLNgdQUkT5pt9z+h9ULCtnZnDTAi
         40VYZj6u3bFFm+sCIS6eUcNQ6nai9Nn7chRonB4R6qARt9tLJcvL5XZFFi1kh5UBTKFG
         MrIA==
X-Gm-Message-State: APjAAAX8fJRM4IvN9yHY3JbvV+drIAGTorWN/QcYqGVdu851Bj9yO4v9
        6bpL8T1IX7eJHkLnQTYUqOy305Dv
X-Google-Smtp-Source: APXvYqztfI1HV++rXcqXt5qQEpBT8+C7C8+zbRC2UK+bybJef5dlhSTp4v62eeVmwM6hKuGn3bl1qA==
X-Received: by 2002:a62:33c3:: with SMTP id z186mr27504918pfz.212.1566917895194;
        Tue, 27 Aug 2019 07:58:15 -0700 (PDT)
Received: from gizo.domain (97-115-90-227.ptld.qwest.net. [97.115.90.227])
        by smtp.gmail.com with ESMTPSA id k64sm17502626pge.65.2019.08.27.07.58.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 07:58:14 -0700 (PDT)
From:   Greg Rose <gvrose8192@gmail.com>
To:     netdev@vger.kernel.org, pshelar@ovn.org
Cc:     joe@wand.net.nz, Justin Pettit <jpettit@ovn.org>
Subject: [PATCH V3 net 2/2] openvswitch: Clear the L4 portion of the key for "later" fragments.
Date:   Tue, 27 Aug 2019 07:58:10 -0700
Message-Id: <1566917890-22304-2-git-send-email-gvrose8192@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1566917890-22304-1-git-send-email-gvrose8192@gmail.com>
References: <1566917890-22304-1-git-send-email-gvrose8192@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Justin Pettit <jpettit@ovn.org>

Only the first fragment in a datagram contains the L4 headers.  When the
Open vSwitch module parses a packet, it always sets the IP protocol
field in the key, but can only set the L4 fields on the first fragment.
The original behavior would not clear the L4 portion of the key, so
garbage values would be sent in the key for "later" fragments.  This
patch clears the L4 fields in that circumstance to prevent sending those
garbage values as part of the upcall.

Signed-off-by: Justin Pettit <jpettit@ovn.org>
---
 net/openvswitch/flow.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index 005f762..9d81d2c 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -560,6 +560,7 @@ static int key_extract_l3l4(struct sk_buff *skb, struct sw_flow_key *key)
 		offset = nh->frag_off & htons(IP_OFFSET);
 		if (offset) {
 			key->ip.frag = OVS_FRAG_TYPE_LATER;
+			memset(&key->tp, 0, sizeof(key->tp));
 			return 0;
 		}
 		if (nh->frag_off & htons(IP_MF) ||
@@ -677,8 +678,10 @@ static int key_extract_l3l4(struct sk_buff *skb, struct sw_flow_key *key)
 			return error;
 		}
 
-		if (key->ip.frag == OVS_FRAG_TYPE_LATER)
+		if (key->ip.frag == OVS_FRAG_TYPE_LATER) {
+			memset(&key->tp, 0, sizeof(key->tp));
 			return 0;
+		}
 		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP)
 			key->ip.frag = OVS_FRAG_TYPE_FIRST;
 
-- 
1.8.3.1

