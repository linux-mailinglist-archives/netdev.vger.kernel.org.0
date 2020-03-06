Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E092B17BE68
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 14:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgCFN3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 08:29:02 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34211 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbgCFN3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 08:29:01 -0500
Received: by mail-wr1-f67.google.com with SMTP id z15so2387976wrl.1
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 05:29:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lycBKI84VMyP9zCQGJ187EcaOsc3LOmwAgIixJQgN6I=;
        b=erdj4lQJhMoQhMgxRbdnzTHBTRoyCAxUvl16bwOd+wpscUy6WzqDThFRHXm8vBtR8A
         jUt2xHLCoMp6kG33EoBKo0DnKB5Ry+Gq4/TDIvpKB8vzgkTVVk92gHJc4dyh47dLfN0P
         lWGPqEEy+a9zEiMFTLtL3z9noW8aNfBjQMkdyF45Ge08ny4EYa9ftGw41FR9yBGv5RZc
         Y0uMga6Ay2uzNWWAY+tQAAQLBCSuMr9GXbzdr2sS8zZl3kXRvGLWM9RGuIOi2ugRpaZX
         BIUAc1L57hv5frBpaH7BVBKrG0dn7bLR2jd3vNAgGTBBDWolH1u8cgGXPdURpN043VQG
         W4yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lycBKI84VMyP9zCQGJ187EcaOsc3LOmwAgIixJQgN6I=;
        b=hJoRGiI7VmJn2J7aqxPG6mXneLWqMLewrFVbLYQ64MdKAGcaCEUNkRpAN1oI4lGufx
         YaBgXfZcJ8oFNM+E4596j5zUb//fq92TakTVTzMT54hFGVQNbODNQr4ExLiiaCuivtQ/
         VN3n6R4FjfL3v6iHlNMwImL4pXlRh/8bTW9FlN9bk0Fzyuz1pNcTjhYLzTkECRyY3ocU
         kKUu0EgHitGONoHEia4nwHNcdKA6ru3rEKiVG3U6ooj8ZRWg8UV/hOuwYl+F1Vk/cdy8
         liBIe8XiPMBgrKmi+2SAzReoPUbkCePJ6sdJQRJQzriDw6VMs3OFmwCp9i+euqTeViHk
         3/UQ==
X-Gm-Message-State: ANhLgQ2yc1m1f0qlfnd5wU3Yb4Qo3ytl++Ukd0/R692h4Inur3vVWv9f
        W1/zqy+blsqjSednklMveNMnhQGf+N4=
X-Google-Smtp-Source: ADFU+vvDEnXdXf5M2H+LFBtfJyxCKsxAgV9UBz5H77SCbHZwkOvinpueEm046F4cGlEgzVY3sx7Pag==
X-Received: by 2002:a5d:6284:: with SMTP id k4mr4227971wru.398.1583501339505;
        Fri, 06 Mar 2020 05:28:59 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id f127sm14032809wma.4.2020.03.06.05.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 05:28:59 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: [patch net-next v3 01/10] flow_offload: Introduce offload of HW stats type
Date:   Fri,  6 Mar 2020 14:28:47 +0100
Message-Id: <20200306132856.6041-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200306132856.6041-1-jiri@resnulli.us>
References: <20200306132856.6041-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Initially, pass "ANY" (struct is zeroed) to the drivers as that is the
current implicit value coming down to flow_offload. Add a bool
indicating that entries have mixed HW stats type.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v2->v3:
- moved to bitfield
- removed "mixed" bool
v1->v2:
- moved to actions
- add mixed bool
---
 include/net/flow_offload.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index cd3510ac66b0..3afd270eb135 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -154,6 +154,8 @@ enum flow_action_mangle_base {
 	FLOW_ACT_MANGLE_HDR_TYPE_UDP,
 };
 
+#define FLOW_ACTION_HW_STATS_TYPE_ANY 0
+
 typedef void (*action_destr)(void *priv);
 
 struct flow_action_cookie {
@@ -168,6 +170,7 @@ void flow_action_cookie_destroy(struct flow_action_cookie *cookie);
 
 struct flow_action_entry {
 	enum flow_action_id		id;
+	u8 hw_stats_type;
 	action_destr			destructor;
 	void				*destructor_priv;
 	union {
-- 
2.21.1

