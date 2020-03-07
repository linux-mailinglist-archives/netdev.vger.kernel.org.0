Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B134C17CDD5
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 12:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgCGLk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 06:40:29 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36949 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbgCGLk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 06:40:27 -0500
Received: by mail-wr1-f65.google.com with SMTP id 6so5375422wre.4
        for <netdev@vger.kernel.org>; Sat, 07 Mar 2020 03:40:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tYDmebcFXDgyaGfDwBTZgKExPTtiUpULiECPHwTYhI0=;
        b=nqMV0Z4ofG9NMpcvu5mcfyMcW+P/xUn6LMTEr6lLXAjBVslLCJw8IrWmtgMLq9Ef4N
         MKapLeEPCyqBKhjHY7GrvMpUHFJLB4y5wriDCczKePVKjB9AZPAZmSWzkglUtyBK6IVl
         4GqABLqU0yuaWjq0/QqD1SfRgQGkmZKtrAB7Eb7y8gyhJ4MFUjtJm4wxSxneB0xiBZxS
         DiR0/kLf5DQbYKil8f1koCaKKKg6YhGWcA7Ulqoc+pHOL9StfaCDwrY7tT8bgAD2Pz6a
         urjLPtYNfvmVt6WjCrL+gtWxVI3KB0JAK2Y9cuKhmQVn8EfquNwa9Wm3sd5QelLJSXFb
         IXWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tYDmebcFXDgyaGfDwBTZgKExPTtiUpULiECPHwTYhI0=;
        b=hkTtW6bY26WUrCGIluClRDhHcFSFz5yUE30TJihv7D1Nf3tIzbP7gJual/iiORU5Vi
         2I5/d3UxzObsNttwVNL0TV6eFopk11aFpTQIj3IrzrnJ1IZyh5XChypuBMtV+TEkITci
         71Uj90YRN7C1gTu6ml+PDDLEMKu4ddW3zyg3u7l/ItuczRQxcpjSVmlNO1N23ct/z4Ta
         YquVuI4iFtkoWmfRRAsTmfzwGmmNEu+rquqJR2FLaaJ+NN8GDZ4hx0y8GC+gqkAIwLiT
         1IXun7mCX/gESFRuh2Gj0jVau3LqVpeY9AlBUjd4qfciZ1H3iarBf0PG4UEayfn48ysT
         p1qA==
X-Gm-Message-State: ANhLgQ2s+tRQi8Jv8n+YWoJlHf1lxVZ+uDmYhWO7RrD+KvLwrd9loM+r
        quwE4+07kVmuiIvMMdpi6LvREx+lNJk=
X-Google-Smtp-Source: ADFU+vsKXjXyOO8+MGSACrvflA3GFFdj7cs7tpi0HnBS3jinxnK8gYLYBW4xqmJi+uXYP7NcZcYaoA==
X-Received: by 2002:adf:b3d6:: with SMTP id x22mr9194174wrd.242.1583581225542;
        Sat, 07 Mar 2020 03:40:25 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id s14sm40461777wrv.44.2020.03.07.03.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2020 03:40:25 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: [patch net-next v4 01/10] flow_offload: Introduce offload of HW stats type
Date:   Sat,  7 Mar 2020 12:40:11 +0100
Message-Id: <20200307114020.8664-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200307114020.8664-1-jiri@resnulli.us>
References: <20200307114020.8664-1-jiri@resnulli.us>
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
v3->v4:
- fixed member alignment
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
index cd3510ac66b0..93d17f37e980 100644
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
+	u8				hw_stats_type;
 	action_destr			destructor;
 	void				*destructor_priv;
 	union {
-- 
2.21.1

