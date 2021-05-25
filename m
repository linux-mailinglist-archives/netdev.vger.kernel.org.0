Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC56238F858
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 04:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbhEYCvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 22:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbhEYCvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 22:51:13 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA67C061574;
        Mon, 24 May 2021 19:49:44 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id v4so22183317qtp.1;
        Mon, 24 May 2021 19:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2qtQy/kNpaoEXZ266z5GW30433TABBm8NnJcGKp1Nbc=;
        b=XBDALySmTOrcyzBBXXEhFeWsiejRDZdGIJsG7BqgjkDqJkkqODwNbioSYe8C/MowFg
         hg7v6T2V/644/4uIOWoUQQ8+v9/iDcOKfSROcPuze/Ok/ziQHiMPqPmdmV0B9Z3+qgZM
         y1e2Vyv8JxiEi9Y8Okvd15UtclXF43QuXPLbsW9jkfhmSsaGzd7gLiIpLw4IuC8EpIHE
         KLWZNKk7r4yMnsvHaKyZ7QMUIhDCtDPOXXSOHaCBX7snV16hLLegGV3a5uaoayDaYV9z
         ALPGaDSg5fEuNR5XrtusTICa9ZRychSbAQ61mQt4yboTmJe+oJb86lk6gwAVYYTw/pjF
         L6SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2qtQy/kNpaoEXZ266z5GW30433TABBm8NnJcGKp1Nbc=;
        b=QDeR5Knmy9lKcqICLDIWiPcdX4DqxNEhHgmaQbR00fw/8P94q9FevyQNoXnH8i7KSZ
         n9Aqdq0ylDRRwntOd+lqmafWt1KmcSbesXBzF+tsXu3mNAGD/tnYx/Lx3RPlpsCO+TFG
         faNwQAFWZ+o2Wtpua+WZPW2G/5CYtCdt0txP6PbLOx0hYFZ1PoyEdLmIzUQJa4CCGJ6m
         xAvSgXOGMi6y2867QyMcljbAHVMBSQsMigPh+zzGnuQJmjajuV4mK1QIheNQF/0+0K3p
         f9VEW+wMzwPUBt3FL9G8dtn090fnXC8slpMCASWLcyRESxAGXzKh8N925xNgCpqppW52
         G/qQ==
X-Gm-Message-State: AOAM531TZRDZtwj8HT8oqubAOWb+ELnNIaPpjMRSQ4rmfrlST7XaUo/g
        iICdzMX7rZ4SG+ODPQEpDiPo1sF8VoimygmQ
X-Google-Smtp-Source: ABdhPJwfcer0eOF2NfDGv3U1UwT+vkiwn8yRuSnOpnB0KjMZwH2UoNsFTsLSsTNIo0ogC9T5ZH11uA==
X-Received: by 2002:a05:622a:1044:: with SMTP id f4mr30520217qte.181.1621910983019;
        Mon, 24 May 2021 19:49:43 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id e5sm11478246qtg.96.2021.05.24.19.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 19:49:42 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net] sctp: fix the proc_handler for sysctl encap_port
Date:   Mon, 24 May 2021 22:49:42 -0400
Message-Id: <deeba1bfa2edb3f83fd1b8ad3bf6b6f5bce264dd.1621910982.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

proc_dointvec() cannot do min and max check for setting a value
when extra1/extra2 is set, so change it to proc_dointvec_minmax()
for sysctl encap_port.

Fixes: e8a3001c2120 ("sctp: add encap_port for netns sock asoc and transport")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sysctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index e92df779af73..55871b277f47 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -307,7 +307,7 @@ static struct ctl_table sctp_net_table[] = {
 		.data		= &init_net.sctp.encap_port,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= &udp_port_max,
 	},
-- 
2.27.0

