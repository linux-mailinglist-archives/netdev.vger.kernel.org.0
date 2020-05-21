Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38AE71DD928
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 23:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730636AbgEUVLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 17:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730616AbgEUVLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 17:11:04 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83A3C08C5C1
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 14:11:03 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id e2so10496490eje.13
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 14:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mGbdBbKPkt+TWwR/Wiwv/J0av95DOAjSPkVX8TLkwrE=;
        b=UCc4UpSlotEsJ970oSQuDuFIMibtzsrnNh5A4CCYSe/eRiBP9Z2xPtqz87maHfqTdi
         9Se6oMXGNSCkqLw+KA/X1v6RBSepMs4Cuh4C+c/jDDRwspAKJnF+RrF0dtZobxiIt5tQ
         t2kKdJ97DlOxyhJ6E8bePNx+MHzwAJSh3X2U1rRz1rgbb6whfe37S/G1O+iLBHyMVyCT
         /RT0VKxWkYIX7pnpuUfsgLgeG9ypbomtsnk7+DLZzMJtmf9qCD+0e75kMFsEIhWmBthu
         DqkRlv3gfFRv5aRFrtRpuAtjGhF1QXbKTammIHpa18gJLXL9VmAysEpEh4lp+PQjfaEf
         /B9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mGbdBbKPkt+TWwR/Wiwv/J0av95DOAjSPkVX8TLkwrE=;
        b=SPK+klDNC4jHy1Leih4ZOqCHQgEmT0LzbMm4D7KKT9fk2rdOr2+7ynNE2nL5xF1F27
         Lo4Ar6uRZMtE92ShrkG9iuoUrtYEjgCmAoAWj0sFBydZJt7Dp38m5L8Gr6E3fArDuFSw
         7Nnp4zzmk6ZECaHGfQZz7Jy1kdnAG00/zPbH+AdppnqJt0ntAhRkCml08BHBDyPk2CQR
         WbyGKuykpHnTHyrvEBjRbu7IRDK+G7XDICTKVn+VGkC534nDBOMcHvXpVfdBxaxlUVWD
         twWvMIQs1IMxJcO16eeHUnxofMyNXX8cIww2vyMKIAzqLhgFhpU1YcRbLCVjyqPY8bWf
         o7Hw==
X-Gm-Message-State: AOAM530QZ1J6WKfc4sjuBCqRLwm2Nu5s/fh/nA9Gvz5mE+S1/7rccbIu
        ojCl7zIpYtRmuGxjRsIuDaM=
X-Google-Smtp-Source: ABdhPJyIP1pvkqlcYsHHQhHdpNyh9j6Z35wmH7WNEI8gku/i6m1aoJ6miFm80wQs5d49ZH2CaDQF/w==
X-Received: by 2002:a17:906:c838:: with SMTP id dd24mr5282027ejb.28.1590095462435;
        Thu, 21 May 2020 14:11:02 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id h8sm5797637edk.72.2020.05.21.14.11.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 14:11:02 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        ivecera@redhat.com, netdev@vger.kernel.org,
        horatiu.vultur@microchip.com, allan.nielsen@microchip.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: [PATCH RFC net-next 09/13] net: dsa: mroute: don't panic the kernel if called without the prepare phase
Date:   Fri, 22 May 2020 00:10:32 +0300
Message-Id: <20200521211036.668624-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200521211036.668624-1-olteanv@gmail.com>
References: <20200521211036.668624-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Currently, this function would check the port_egress_floods pointer only
in the preparation phase, the assumption being that the caller wouldn't
proceed to a second call since it returned -EOPNOTSUPP. If the function
were to be called a second time though, the port_egress_floods pointer
would not be checked and the driver would proceed to dereference it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/port.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index e23ece229c7e..c4032f79225a 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -324,8 +324,11 @@ int dsa_port_mrouter(struct dsa_port *dp, bool mrouter,
 	struct dsa_switch *ds = dp->ds;
 	int port = dp->index;
 
+	if (!ds->ops->port_egress_floods)
+		return -EOPNOTSUPP;
+
 	if (switchdev_trans_ph_prepare(trans))
-		return ds->ops->port_egress_floods ? 0 : -EOPNOTSUPP;
+		return 0;
 
 	return ds->ops->port_egress_floods(ds, port, true, mrouter);
 }
-- 
2.25.1

