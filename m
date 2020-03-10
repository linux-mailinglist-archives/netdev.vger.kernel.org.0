Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDB9E180256
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 16:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgCJPtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 11:49:15 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43687 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbgCJPtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 11:49:15 -0400
Received: by mail-wr1-f68.google.com with SMTP id v9so16497038wrf.10
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 08:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rq2+GFB4jT3UkmG68+pzSF+40rGUMjKXFtdU6IBEeSk=;
        b=Apf9z3O48829usUePJjwD87jdcEBfVji6m58xVXhcPs4o/qjyS9xHR8ik4mRN+0hER
         JL24ThIG22Nwdq3gr6gN4UlCJA5pQUZ3SURoS4IUJRRqSKpna90weuyvuLhsD0zEgF4A
         vZ6wPzKuUYCzfMrd2abnsLneSSU/fxlVaZN/jAE5py9VOMWZqyczQUMCp/697vtNMqCz
         vhiLYV33MChsqS65zxKuUx10eA+nHeiWSerMzkoMcYYexu2S6hx2mtfXgAEbAPSpIWSb
         87LYDyPIFwUDzoQSzjLIrzlXdncmPWntrBNiXfHwxYbmB8EpOi/Op2oRyOG+EMazA1IV
         EjyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rq2+GFB4jT3UkmG68+pzSF+40rGUMjKXFtdU6IBEeSk=;
        b=ax5/rXHo68ICHpWiQSmmGUTOqYO2oicg+Qy9J2MjnkwU4KBmrOvCib1+QJHsC+Tx8r
         NYhYlxKQZGNkQF4k9HZQ6yZ27MNrC0RvAa87FDkOxXqgTCv+Zsvp252Phd5Dy9MRJ+EE
         hmFxi4cO+hAvYUf1O9w2xOXiKS9lNz7oKua7OkRwy6oNpcSxuBLbAdLZCrb8FxdTCxbM
         TTzLM+q1Z1d/5lvDCZbGntv5oqsRE2Kp0gs5rpDfeFlwRmSY7VHekSXY77E2W4XpdD1H
         bvITBmVwWvZo5YLpqK+WElAp9W4RWq453A7Y5tY7WpHMtbF3RFaCy/0kB4PmW1O/KfZ8
         L8mQ==
X-Gm-Message-State: ANhLgQ2JdTfOxwb+Szt7AZMbeHdjZUWNFhA226pAo/zdcjmkDtFBhvX4
        McKErx93+69MjG9SsPVVmXqly8o3l4U=
X-Google-Smtp-Source: ADFU+vt652CaM7CYEi92/WFFHLaZx4UhVBRNGO6fS3HOgoW9mKC6pTL0jXALBcpnytL7ZMEAEy5wcw==
X-Received: by 2002:a05:6000:1081:: with SMTP id y1mr27980012wrw.52.1583855352676;
        Tue, 10 Mar 2020 08:49:12 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id v20sm15290256wrv.17.2020.03.10.08.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 08:49:12 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        pablo@netfilter.org, ecree@solarflare.com
Subject: [patch net-next 1/3] flow_offload: fix allowed types check
Date:   Tue, 10 Mar 2020 16:49:07 +0100
Message-Id: <20200310154909.3970-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200310154909.3970-1-jiri@resnulli.us>
References: <20200310154909.3970-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the check to see if the passed allowed type bit is enabled.

Fixes: 319a1d19471e ("flow_offload: check for basic action hw stats type")
Signed-off-by: Jiri Pirko <jiri@resnulli.us>
---
 include/net/flow_offload.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 891e15055708..2fda4178ba35 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -306,7 +306,7 @@ flow_action_hw_stats_types_check(const struct flow_action *action,
 		NL_SET_ERR_MSG_MOD(extack, "Driver supports only default HW stats type \"any\"");
 		return false;
 	} else if (allowed_hw_stats_type != 0 &&
-		   action_entry->hw_stats_type != allowed_hw_stats_type) {
+		   !(action_entry->hw_stats_type & allowed_hw_stats_type)) {
 		NL_SET_ERR_MSG_MOD(extack, "Driver does not support selected HW stats type");
 		return false;
 	}
-- 
2.21.1

