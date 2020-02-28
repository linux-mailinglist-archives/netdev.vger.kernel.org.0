Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1748173E66
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 18:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgB1RZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 12:25:11 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34756 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbgB1RZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 12:25:11 -0500
Received: by mail-wr1-f67.google.com with SMTP id z15so3895674wrl.1
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 09:25:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EMk/cd1nz9Rt7TXMuoeh8J5Bj6BfXwR7ZUMpDFN2jL0=;
        b=ihDuyXtxUN73j+b/Sx9mh9Uoa5Rfbd84P3gyMRzaNkIqpg1nMfDFKIxtJhoBz4e+Ks
         2ETCzQvl4PJ1Ud6IklTaFfMfgA8JI01LwXfTSEFfzd8fAyAkiSVPfnwIozZgRB6yHkeQ
         Kw6QCtj4d4igqNIFIApUJ8I3S2JCSUxLVl5Rkyo3MI+mDbqGTF6A/28fqxTYQxd9YlY3
         YiiSLgxErWD00LWsYELAe/PUo8bs7J8tLi67mgrAIL2gYTyKC77t08BptY5vB3nu/Lus
         RDF9Pgy3ayuY5r/24rz8OOK0eRWcjG7vlicNePiGKa2Rm8TOV0L85yUFMKJKHocerkAw
         EQfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EMk/cd1nz9Rt7TXMuoeh8J5Bj6BfXwR7ZUMpDFN2jL0=;
        b=IzguHuupvfK/3gXWAzt0vvdvKgPD4D/e9NEImg1HwMhquTpCPjkI17i38JYqc2D0JZ
         zc5ULrNpNdjitRCQCR8rQCbY72Px5qlSWcRLrzvTpABm1RxghYpnRXwI0oCbRyNvU0Xx
         YBuCijDOLhC4Xh6E/5njDJFkkJDrLBozQPaodUNf+gR/vwEn6+F5e2MYGHrDwE69Nbii
         Dcc9b9+slh7PArnPldXh8OKZvec+UddFuNQZVGVuOpE/EU1Td4xorH2ulTo4LA0vNK/P
         XbzO0BeD02MYJezWTAz1hWkYljmDlVGMILATPGMwOl9DaEfhxVtVR0dAYDrvhavpFO5T
         9UbQ==
X-Gm-Message-State: APjAAAW8gSAJgpfiaKI9o5+4JPtFeSGPaK+bhZNhhD+HCTOnHG+avL6T
        dHJor73hu05c/u3E2jCggk/Jw1L9pN8=
X-Google-Smtp-Source: APXvYqw2hnAXb3bn5Izh1g+ZLgoRPH53cAZtrZOy9pfoZGkeSK+s1gR3e/heb+/LgVKO3OBmFnatKA==
X-Received: by 2002:a5d:5446:: with SMTP id w6mr2066735wrv.355.1582910709299;
        Fri, 28 Feb 2020 09:25:09 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id b197sm3269616wmd.10.2020.02.28.09.25.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 09:25:08 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: [patch net-next v2 02/12] ocelot_flower: use flow_offload_has_one_action() helper
Date:   Fri, 28 Feb 2020 18:24:55 +0100
Message-Id: <20200228172505.14386-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200228172505.14386-1-jiri@resnulli.us>
References: <20200228172505.14386-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Instead of directly checking number of action entries, use
flow_offload_has_one_action() helper.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- new patch
---
 drivers/net/ethernet/mscc/ocelot_flower.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 3d65b99b9734..b85111dcc2be 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -19,7 +19,7 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
 	const struct flow_action_entry *a;
 	int i;
 
-	if (f->rule->action.num_entries != 1)
+	if (!flow_offload_has_one_action(&f->rule->action))
 		return -EOPNOTSUPP;
 
 	flow_action_for_each(i, a, &f->rule->action) {
-- 
2.21.1

