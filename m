Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B78D794EA4
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 22:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbfHSUBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 16:01:13 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44709 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728193AbfHSUBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 16:01:12 -0400
Received: by mail-qt1-f194.google.com with SMTP id 44so3307360qtg.11
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 13:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M+q0jZNJZGTUNn1i9bwBovyagpPiC/k7ft3LTZCzQpY=;
        b=u5x51yAQ9rpUoz2ZpwMX0oKxd0TPJKwa9Wp6mK9bqn2ZRlz7r/1l6xG/rdwCUuK4JB
         DnAtpW4JzWUsaCRXiXCIEug/DMV3q7KRVephaaDh6pbp7IvQSyShBRAHPffpRsaMdxzH
         qgs7csdfXMtpWZWCLFCK/rXmGWLO7FlYRYPy4lmERpucuPhkyOU3MpTdf8VdkAqJr8lp
         tCdfKYdqFYYMhwl0RSBvA2/IgnPg3qusStG/TzkLJRHSq9GoN1tnthEzcBjXCaGeH/9f
         rQesfJAVg5b99JxGTQA4zZLUTfIPr4+EI/MAMyUnz/BNmaSzcvEBOsxxNn0I2gnWgqEh
         T7cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M+q0jZNJZGTUNn1i9bwBovyagpPiC/k7ft3LTZCzQpY=;
        b=EFlE+YaQVs161EgcMggkNPvRyldmY6WYbUwJOwvRFKISb3uamx2qPVut9Xx+x2id+D
         IaSTeaudBnqc43a8fEbqotwJClah6U3Jrachrf4W5pue4Z4j4KnUnDbiKphN8lY1k/q8
         yC7TQAKBFMFJTcT8871POZJApQ7JgQqAp/FJh9fCFLamEfe7k4KmKfdD3s+/zJcTL3dI
         PsEHj8EojAYA6XfcyRg6wjXrndj9hbsJMsBntZA+34BtNqVf1+VEeCQ9ZaQE2e4y8BRD
         qbng5uVgKsMVmdhSBR21EXYRfqoyFI+uEfAa4MLkmOu/L1sZBtaP5NbMkqyZ5iAF8HxY
         l9PA==
X-Gm-Message-State: APjAAAUz4u7LA5TQSL3PiU9/3EiNYB1KcY0a7YYDG3h15ZA2bxyAnFiD
        cZ1CohIQjtyyqKK/elZ7i8P08nIqVjo=
X-Google-Smtp-Source: APXvYqxL483L/bSNUXVPV02tXFIJYMRzIpqU7YHL+ilANYD1g/7jHSf2AK8gOBGbbnBKWBWdmNEknQ==
X-Received: by 2002:ac8:414b:: with SMTP id e11mr22283274qtm.174.1566244871021;
        Mon, 19 Aug 2019 13:01:11 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id y11sm1061523qki.94.2019.08.19.13.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 13:01:10 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     marek.behun@nic.cz, davem@davemloft.net, f.fainelli@gmail.com,
        andrew@lunn.ch, Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next v2 3/6] net: dsa: enable and disable all ports
Date:   Mon, 19 Aug 2019 16:00:50 -0400
Message-Id: <20190819200053.21637-4-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190819200053.21637-1-vivien.didelot@gmail.com>
References: <20190819200053.21637-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Call the .port_enable and .port_disable functions for all ports,
not only the user ports, so that drivers may optimize the power
consumption of all ports after a successful setup.

Unused ports are now disabled on setup. CPU and DSA ports are now
enabled on setup and disabled on teardown. User ports were already
enabled at slave creation and disabled at slave destruction.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/dsa2.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 405552ac4c08..8c4eccb0cfe6 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -264,6 +264,7 @@ static int dsa_port_setup(struct dsa_port *dp)
 
 	switch (dp->type) {
 	case DSA_PORT_TYPE_UNUSED:
+		dsa_port_disable(dp);
 		break;
 	case DSA_PORT_TYPE_CPU:
 		memset(dlp, 0, sizeof(*dlp));
@@ -274,6 +275,10 @@ static int dsa_port_setup(struct dsa_port *dp)
 			return err;
 
 		err = dsa_port_link_register_of(dp);
+		if (err)
+			return err;
+
+		err = dsa_port_enable(dp, NULL);
 		if (err)
 			return err;
 		break;
@@ -286,6 +291,10 @@ static int dsa_port_setup(struct dsa_port *dp)
 			return err;
 
 		err = dsa_port_link_register_of(dp);
+		if (err)
+			return err;
+
+		err = dsa_port_enable(dp, NULL);
 		if (err)
 			return err;
 		break;
@@ -317,11 +326,13 @@ static void dsa_port_teardown(struct dsa_port *dp)
 	case DSA_PORT_TYPE_UNUSED:
 		break;
 	case DSA_PORT_TYPE_CPU:
+		dsa_port_disable(dp);
 		dsa_tag_driver_put(dp->tag_ops);
 		devlink_port_unregister(dlp);
 		dsa_port_link_unregister_of(dp);
 		break;
 	case DSA_PORT_TYPE_DSA:
+		dsa_port_disable(dp);
 		devlink_port_unregister(dlp);
 		dsa_port_link_unregister_of(dp);
 		break;
-- 
2.22.0

