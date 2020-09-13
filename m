Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36E34267F63
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 13:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725967AbgIMLwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 07:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgIMLwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 07:52:17 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31AF7C061573
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 04:52:17 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id mm21so4017432pjb.4
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 04:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=vwZq0flE89M7735GERvCPN1BUnu2imz6KgCe+OhLWpM=;
        b=hlTkW7rmTXiu6ihCF3GOTI1trEQq3bqzUFH040AsxndWd21VOEYriU79v1wA+xr8fX
         ZADezSTKoEK+24R5ClhDzkRT2UxJlpp//sMNtxMPNr5TVYkVkWt4xDiqhBlpDKQE3X1Q
         /6LTcKHlBeQqNTMriqLjAc+p0sNqRv+H2kb920TJ/4zIhSJVB3YwR/Jdyw0Nvkkm0XP2
         hFM2Vfq9GBqWuZl3DGwMPqtxO2i+lcwxJwEH10GZW0xd3+hPgkl4LpVOu6wUm5BnGfyK
         0CqCQiPpEwIjzs8bsb+XiQNzG8RtamjsUEIQFL4p7QywR784PBpD7zYq02rhDRx5WRxP
         k6YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=vwZq0flE89M7735GERvCPN1BUnu2imz6KgCe+OhLWpM=;
        b=H04fSD7QLCV7ndgB3+ZRbMR3bDW1OGp0bDiwBMRXoTesuy7X+fC3Frve3cO5JCnX0e
         KeUhf2Vyf1jQIYkLPg9jJYcCvDrh13/Rzc+xVJfe6MsC37iyZb03fofXTGfkpovEdF6x
         HIwTEf9+LxH2ishEi+Kk+CNTw5hxP5fJtbMfmKu2hEuYKAdEq9iVI/AXXyKZhNdRt7ml
         bq7livEEa9cH91WzAXs8wmEKg3wLJzjRMBlPMW4j7XdGlqu4pyfBynrp0GwNgIud3LaW
         pAhoKlFwx4nGnlrTtOQpN4vPGB+6edSUeBX3IlBRaxXb4+7HYpnTEMX6NgGgkdya95Am
         eyGg==
X-Gm-Message-State: AOAM530kyf5VZoNIaD22wOPkv069P4M3ESk3WZQOc08BwoFurDBLCP2H
        5LcdLPhB6zZPhLXUcGGhW0m/MN1u9b0=
X-Google-Smtp-Source: ABdhPJw/FlJYL6fV6ZdCSANq3ldK25KWc7m7ZS/mFvvpG1bbTMzMpNm8uzcqz0Kx9Kjvm0Pa5mTqcA==
X-Received: by 2002:a17:902:522:b029:d1:9bc8:15df with SMTP id 31-20020a1709020522b02900d19bc815dfmr10253190plf.25.1599997936470;
        Sun, 13 Sep 2020 04:52:16 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w206sm7600812pfc.1.2020.09.13.04.52.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 13 Sep 2020 04:52:15 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH net 2/2] lwtunnel: only keep the available bits when setting vxlan md->gbp
Date:   Sun, 13 Sep 2020 19:51:51 +0800
Message-Id: <1db5cfa6749c76f66c9bf2eeedff0e0fc84ce9d5.1599997873.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <6772f33cc49808af9be5c7109d9eed20d309e863.1599997873.git.lucien.xin@gmail.com>
References: <cover.1599997873.git.lucien.xin@gmail.com>
 <6772f33cc49808af9be5c7109d9eed20d309e863.1599997873.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1599997873.git.lucien.xin@gmail.com>
References: <cover.1599997873.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As we can see from vxlan_build/parse_gbp_hdr(), when processing metadata
on vxlan rx/tx path, only dont_learn/policy_applied/policy_id fields can
be set to or parse from the packet for vxlan gbp option.

So do the mask when set it in lwtunnel, as it does in act_tunnel_key and
cls_flower.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/ip_tunnel_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index 75c6013..b2ea1a8 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -554,6 +554,7 @@ static int ip_tun_parse_opts_vxlan(struct nlattr *attr,
 
 		attr = tb[LWTUNNEL_IP_OPT_VXLAN_GBP];
 		md->gbp = nla_get_u32(attr);
+		md->gbp &= VXLAN_GBP_MASK;
 		info->key.tun_flags |= TUNNEL_VXLAN_OPT;
 	}
 
-- 
2.1.0

