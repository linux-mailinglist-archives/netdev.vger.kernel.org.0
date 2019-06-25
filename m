Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD4EA55C6C
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 01:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfFYXkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 19:40:10 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50477 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbfFYXkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 19:40:09 -0400
Received: by mail-wm1-f68.google.com with SMTP id c66so229990wmf.0
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 16:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YMRZubyH5/FPTMGb6iGV7eVDOr2xZhM8WFwrPMXRQ8M=;
        b=Xv61a6ZF8KllxDlcK2mzqVSU+Ekxg1HoHEbcJtQTQSxE0+OIUHyRsI7K2U9WsLbbcl
         j0Y/jNrP19qidyW3i51zTjiYBAp+15UBqbzSZrOf4NQMrAmZG/azwXmxC/M0VsoLmGxT
         U4Mq78qdd30C4qMoRPLLHmYGy4J/j5RzmiuYgayLu3Lb5IlaRgUpUU3/yHKol166l4TN
         L+59LlHzxTeaOICXz5fddanzDVNyTfg6HYfzg4lPZUMnhgUE0IN9leK+ODwq7BPlktdK
         bGJ6VMpXsw4N0oJmDTf0F7843JgCnSlfGRUctLIgT+hqozkEyvTbXLwsbh3v8zaQVGCe
         2/zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YMRZubyH5/FPTMGb6iGV7eVDOr2xZhM8WFwrPMXRQ8M=;
        b=OMYUMbIQ6ufMAJk/D/QUbNmXijFW7ctfatXzGsMjWZ6XOXj3oM70v7XVi3+W9PDuHi
         Wf7M11Y5tardkI2bsMSyM0329PQYIS1JHN9jfDZQp+AK1HBKaFiabcgcq4RqSUXzt8YL
         w0PHnox/PWeN8knU7HLdr/baOWNoylN6EiW2hFBmL43nK93BybO2qnOTppe4zsgBdSeY
         UDkjR3Tsnd4Ookbv6Jfo3GkZUoGDd3fTQA7v5UTrkpg5He/DYwtf+P0MDJu6MHpf6VaV
         6oV32uvmLS72Af1k5qE1j4h2hqbAVR788Hbry+2r7zmrhUPMS85gglgoQBUWEFYeoPMt
         urBA==
X-Gm-Message-State: APjAAAVy+1fvY+Durr1z3pNXs0+9CjXjz8K764VPhNzfE9bUHHP3Ltnk
        xq5LBN6XG8TFOKzqQz63LNU=
X-Google-Smtp-Source: APXvYqyduoiaX2OeSXRZ8Rdm7mblFZhy7qDB6WuW/WedDl+YAp9NJosyL6Jwzm47zLelOiTf0S2j9Q==
X-Received: by 2002:a7b:ca44:: with SMTP id m4mr202330wml.160.1561506007540;
        Tue, 25 Jun 2019 16:40:07 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id p3sm10810949wrd.47.2019.06.25.16.40.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 16:40:07 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 04/10] net: dsa: sja1105: Actually implement the P/Q/R/S FDB bits
Date:   Wed, 26 Jun 2019 02:39:36 +0300
Message-Id: <20190625233942.1946-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190625233942.1946-1-olteanv@gmail.com>
References: <20190625233942.1946-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 1da73821343c ("net: dsa: sja1105: Add FDB operations for
P/Q/R/S series"), these bits were set in the static config, but
apparently they did not do anything.  The reason is that the packing
accessors for them were part of a patch I forgot to send.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_static_config.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.c b/drivers/net/dsa/sja1105/sja1105_static_config.c
index 242f001c59fe..a1e9656c881c 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.c
@@ -232,9 +232,14 @@ sja1105pqrs_l2_lookup_params_entry_packing(void *buf, void *entry_ptr,
 	struct sja1105_l2_lookup_params_entry *entry = entry_ptr;
 
 	sja1105_packing(buf, &entry->maxage,         57,  43, size, op);
+	sja1105_packing(buf, &entry->start_dynspc,   42,  33, size, op);
+	sja1105_packing(buf, &entry->drpnolearn,     32,  28, size, op);
 	sja1105_packing(buf, &entry->shared_learn,   27,  27, size, op);
 	sja1105_packing(buf, &entry->no_enf_hostprt, 26,  26, size, op);
 	sja1105_packing(buf, &entry->no_mgmt_learn,  25,  25, size, op);
+	sja1105_packing(buf, &entry->use_static,     24,  24, size, op);
+	sja1105_packing(buf, &entry->owr_dyn,        23,  23, size, op);
+	sja1105_packing(buf, &entry->learn_once,     22,  22, size, op);
 	return size;
 }
 
-- 
2.17.1

