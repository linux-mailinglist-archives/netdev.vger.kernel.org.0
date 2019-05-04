Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD2A11398C
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 13:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727565AbfEDLrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 07:47:18 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:42405 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727548AbfEDLrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 07:47:15 -0400
Received: by mail-qk1-f195.google.com with SMTP id d4so2350274qkc.9
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 04:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rR4fEkvLCKjny5xen9D1wPt/w+e85S2BRXiAtcBWkCY=;
        b=W83e/KWHQnw1hFgxChijJUiCAwnaD2NK+4RGaiFupTTANu6gnA4Ps8ILxaKangDniH
         wpUxQkSuWLIR0Zx1B3Dch18sptR1gBQsrvDgOvV7VGNbDAnsgao0GpREe+r64AYs5Dwj
         YYZ/d+R9yhgTFKSjTbHNpSFcvRE6eXuz46XS5nSvdvJBGTv2FVobc615cRxhtGDCI+Ld
         /BQ648QKfAbM1oITXxcfPO+csifKzmIc6yjAPx2GzDDD2T0aqdxUcTsH5/augAbFYQEj
         2gc8DBb0n0XWN0Iv8rHs+MQo7Vr0ZpwwFYkxaAyftXWTOHzVg8TUkBrEaukzoC8s87du
         THww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rR4fEkvLCKjny5xen9D1wPt/w+e85S2BRXiAtcBWkCY=;
        b=VfDp5A62MqfCjCELFETAlCVEbNpYaPkrJ/PQCRvGNS127Al01ck9ln8/ZsbuJxyb3d
         oqP7Gb1Q9rWZ4HmbIXoauSYDyX3dGwh7hwEsbUdXHI5swfYDCaY79Oe1NiCUr3KbIkWc
         dSNMT+8kDW3nSFVeI2ELe9fgqzNk/W/c4JxjWCHxxjLmrhKOOeX7Nv84P0hSKf2LZ020
         P8LhbxeYqofbxgdm77vkEyhesPMXcFzh8wH+Qkplbnl68kykt+IpBKtJDME9uAneVzQB
         SPxe43dBnVzrMwjgG/pkZM1mzsF6E70I2FAbK1u4P6byIvvwV1DqkEdTEa61kcV+XBtW
         YxXg==
X-Gm-Message-State: APjAAAUvvYxli+D/qC5dDl+pP0Z9RQPW8Ro1+Zuk6GXAjwbK3HMgc08s
        FqNQA/CV9+PZjCZSQWMrTdRhWw==
X-Google-Smtp-Source: APXvYqw3+iWNV872YK6QE3+F1h3TvlNsHvMmQL4PLTwVLT4q4UobUUC/WVNiyTYvmVpX7y3II1uNhA==
X-Received: by 2002:a37:4c04:: with SMTP id z4mr12098551qka.312.1556970434498;
        Sat, 04 May 2019 04:47:14 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g19sm2847276qkk.17.2019.05.04.04.47.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 04:47:13 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        jiri@resnulli.us, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        gerlitz.or@gmail.com, simon.horman@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 07/13] net/sched: add police action to the hardware intermediate representation
Date:   Sat,  4 May 2019 04:46:22 -0700
Message-Id: <20190504114628.14755-8-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190504114628.14755-1-jakub.kicinski@netronome.com>
References: <20190504114628.14755-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>

Add police action to the hardware intermediate representation which
would subsequently allow it to be used by drivers for offload.

Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 include/net/flow_offload.h | 5 +++++
 net/sched/cls_api.c        | 6 ++++++
 2 files changed, 11 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 3bf67dd64be5..6200900434e1 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -119,6 +119,7 @@ enum flow_action_id {
 	FLOW_ACTION_WAKE,
 	FLOW_ACTION_QUEUE,
 	FLOW_ACTION_SAMPLE,
+	FLOW_ACTION_POLICE,
 };
 
 /* This is mirroring enum pedit_header_type definition for easy mapping between
@@ -164,6 +165,10 @@ struct flow_action_entry {
 			u32			trunc_size;
 			bool			truncate;
 		} sample;
+		struct {				/* FLOW_ACTION_POLICE */
+			s64			burst;
+			u64			rate_bytes_ps;
+		} police;
 	};
 };
 
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index f8ee2d78654a..d4699156974a 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -37,6 +37,7 @@
 #include <net/tc_act/tc_tunnel_key.h>
 #include <net/tc_act/tc_csum.h>
 #include <net/tc_act/tc_gact.h>
+#include <net/tc_act/tc_police.h>
 #include <net/tc_act/tc_sample.h>
 #include <net/tc_act/tc_skbedit.h>
 
@@ -3265,6 +3266,11 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 			entry->sample.trunc_size = tcf_sample_trunc_size(act);
 			entry->sample.truncate = tcf_sample_truncate(act);
 			entry->sample.rate = tcf_sample_rate(act);
+		} else if (is_tcf_police(act)) {
+			entry->id = FLOW_ACTION_POLICE;
+			entry->police.burst = tcf_police_tcfp_burst(act);
+			entry->police.rate_bytes_ps =
+				tcf_police_rate_bytes_ps(act);
 		} else {
 			goto err_out;
 		}
-- 
2.21.0

