Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBAF167A06
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 10:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgBUJ4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 04:56:53 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39190 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727966AbgBUJ4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 04:56:51 -0500
Received: by mail-wr1-f65.google.com with SMTP id y11so1265691wrt.6
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 01:56:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k0mUGq6HQocyrxKZXlqAJLiJT3nbl1r2iJVRHT1NBsU=;
        b=TzR5DR06Asf973j5uVSAJf1Puhglc0r2y1VojB9xzOOKQn5MiowvUY9edwpeWn1H+h
         xByVhiPcF2kfdWlMert5B4M6SQed+fgmIYuhqThDLxdh98oqd4m9DNKr3l/D5cX34bRM
         X1Zb7lrtlUBZLOqXr1yPgOr2nEDxzuTitEeJazzpjLNLgSIBNzMClWKopD4y5PCKkUX4
         96MWpmpft60zDnArOKepPC+afjFBkVLtrEXMWobBowYwHIzaphtoyU8bPvmih7lQe8Ly
         /YxT+I49CpwjAo81HjQ/bPoFNGGdY+D6C6cpZlHZPdBqnDSYOyhooGFKaaCQutFJtq1P
         8cxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k0mUGq6HQocyrxKZXlqAJLiJT3nbl1r2iJVRHT1NBsU=;
        b=kD/MxsZLSX2RB2WQGlHELdr8vq3H1CJqBF241zt5dvnX8I3yTRyY208+hT2ph/KPg6
         17I8sWFQpRBOzRiJ7eBg2wyGBY6Q7PClN6vB56rjPVuk0uzV7jZFYoFx40QYq4VkfIT1
         raeSewCyLRmFNbt2agmBmlMIQFKtCecCnQOjzmn4ocRXDmfBTys4hQqWbs39t+JMIPiw
         Z1dZtJOvvMY83m1j1QM+rQULxc4OTqpojBBA5QBcrShLKlN9vSgw6y/LPnh2+XRwGLKL
         GNrGb20zx0oa7af6CiVTgKFa1YgQUT18BOmher3OTqvSRkcjCFYur8vRXtRXXfYUlC0F
         vwig==
X-Gm-Message-State: APjAAAWAYSwZ+mUjPkoCYVWOuJvKn3AivpVbKb9dn2332mCV85C2KKbi
        mrEZ1hMLhSH9itYISlAoUrrI16qCeqE=
X-Google-Smtp-Source: APXvYqw8G+Yqup80Eb6OPcGYFI/m6u6/JKKtGYPmhoxGbygJn+Qq3KfHs7goPsNBz5srvTb908UObw==
X-Received: by 2002:adf:f581:: with SMTP id f1mr48144452wro.264.1582279008278;
        Fri, 21 Feb 2020 01:56:48 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id e1sm3203568wrt.84.2020.02.21.01.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 01:56:47 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org, mlxsw@mellanox.com
Subject: [patch net-next 03/10] flow_offload: Introduce offload of HW stats type
Date:   Fri, 21 Feb 2020 10:56:36 +0100
Message-Id: <20200221095643.6642-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200221095643.6642-1-jiri@resnulli.us>
References: <20200221095643.6642-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Initially, pass "ANY" (struct is zeroed) to the drivers as that is the
current implicit value coming down to flow_offload.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/flow_offload.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index c6f7bd22db60..34e1e7832cc3 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -350,10 +350,15 @@ enum flow_cls_command {
 	FLOW_CLS_TMPLT_DESTROY,
 };
 
+enum flow_cls_hw_stats_type {
+	FLOW_CLS_HW_STATS_TYPE_ANY,
+};
+
 struct flow_cls_common_offload {
 	u32 chain_index;
 	__be16 protocol;
 	u32 prio;
+	enum flow_cls_hw_stats_type hw_stats_type;
 	struct netlink_ext_ack *extack;
 };
 
-- 
2.21.1

