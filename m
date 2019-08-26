Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8222C9D7BA
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 22:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732028AbfHZUqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 16:46:09 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40177 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727014AbfHZUqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 16:46:08 -0400
Received: by mail-pf1-f196.google.com with SMTP id w16so12555532pfn.7
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 13:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=11wDToOU7MvDuXiVGC6+Fr53SEi9f5OYWrOREbkWLj4=;
        b=vCm8Cvwy4Iz1062BQV8IPJvr0zdO45ql+FgUXiiHA+p3w4hfeWUrDC63EzMO9LcGOt
         trueAD5Kk25xA4VpdX8Ydn+/+3/OMRNlIOZxLAxUh19tKXx/IedDhWUFnsWAt7zqko7A
         UN67upEZjyqTmmXpUZUSchF6K/7im/G1Yr6O8JFcmy7pgHjv+kdioZ4h9wss93I7Vjzc
         nXJWYH4kIJRLPo6zuKfAM1+gPFhHTRXxkGvAl/pr+zvmfUPE6yQtozteXFKBiQjKb0BP
         MK1ikB2SuqknMBqBEqY5Q/6cshhmZznr0KKagk4CmlHnwzLu+S17eH8o1PGuvOCyGEE4
         ukrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=11wDToOU7MvDuXiVGC6+Fr53SEi9f5OYWrOREbkWLj4=;
        b=I/tDVzoSDWpX1dLDWV3+beo1quXZeQGKYqIEi7xILb9PUizcwho/IkDVxLfhUCycr2
         7j5s3mxyJOYGWUD1GosC/GQXck/UgeAyY/AENLc/g9YBAY5yWCiollQJAJSN8R4Mv4SY
         67/NyLIVvvSl1OYwT1+fM9oFTfTpSn87Byjc5Jyx+VseInzVnkoa7GW1OeMDG0pYHeWV
         IoTcl8knmGwK76MHU0XV4Gy4/mpeKy2iCvaR3F8N97ZtzTxG9URUxvQW1pklpTuIEayz
         XpOOuUfzFLuY7mraLBOMglUn3/8BKbPFZCPvDVr9a5hhbK4hAmLC6/mPDYoCUAlFOokD
         iYKA==
X-Gm-Message-State: APjAAAWH6fw+fBu7gFZyM4E16e47z0JObQ9bP4aE5WeBGcd5k2wsumn4
        dmZn7N8msmetIYLSLq8BQTNCPQ0S
X-Google-Smtp-Source: APXvYqxIYtAkXLhuV/gmQpenh+DNFiL3t9kGLyk9Gi/m+yFAfkNLZ6FE4MQiYlLUD44zj/6EYVGjAw==
X-Received: by 2002:a65:6401:: with SMTP id a1mr18131228pgv.42.1566852367078;
        Mon, 26 Aug 2019 13:46:07 -0700 (PDT)
Received: from gizo.domain (97-115-90-227.ptld.qwest.net. [97.115.90.227])
        by smtp.gmail.com with ESMTPSA id ev3sm941223pjb.3.2019.08.26.13.46.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 13:46:06 -0700 (PDT)
From:   Greg Rose <gvrose8192@gmail.com>
To:     netdev@vger.kernel.org, pshelar@ovn.org
Cc:     joe@wand.net.nz, Justin Pettit <jpettit@ovn.org>
Subject: [PATCH V2 net 2/2] openvswitch: Clear the L4 portion of the key for "later" fragments.
Date:   Mon, 26 Aug 2019 13:45:59 -0700
Message-Id: <1566852359-8028-2-git-send-email-gvrose8192@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1566852359-8028-1-git-send-email-gvrose8192@gmail.com>
References: <1566852359-8028-1-git-send-email-gvrose8192@gmail.com>
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
index ea12ee6..22fd55f 100644
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

