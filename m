Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9A0AD3F3
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 09:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732417AbfIIHdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 03:33:38 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34280 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbfIIHdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 03:33:38 -0400
Received: by mail-pf1-f193.google.com with SMTP id r12so8626619pfh.1;
        Mon, 09 Sep 2019 00:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ZMqNl2zF+gfPD/uFd1o9AZb2n3DBBvN6MxUSv304vLM=;
        b=rA7RvCX5uJfdiOk2lyyY/u0/xPIVaEWth+vY8AMas18zEXlAfvY5H/qM/mLDuzkum/
         HW7Q+HpsJoCEEgyQAhM4AtUhlmN1ou2S9kMM5uS4Qh0+lun8iZdFLCxN7badjIxMG0VW
         YaN0wI4yb6qmnkHOv61Hr7Ykn/WSbLzpVY8XPpXRNcpgwzMiAWJPDRyT6BnNqSBNiS5z
         S7ISuqtzNzxd+SOlSQ8YXN0Magp9HyObGKUe+vY5wPIX9hibIQm36WR3izAW96AeuZMh
         DepTJpvMsIAnr795QbhwMfwgpkQE97YETFLOWqwFa/EdVq6PQYOI9M3pzZe1HzPnxwLY
         ISdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ZMqNl2zF+gfPD/uFd1o9AZb2n3DBBvN6MxUSv304vLM=;
        b=VlOl/e9mMzxmFA3Q3gOFeQymmX/wuPRA2b79nxncQYqcnrW5eSbaXZdas1eLDtONIz
         Lr8FGxUtSdbjDQhmdArW9JIG1UiqSSzNdvQfI6U3sKug8KLt84avKM8OLLg7it34dayq
         NtQBEaAG9KSahrLjS5kkun51kBJO3/9JzdGmbh0PC6SdOhRjzDQzt+aPLROA5O9Npf6Y
         8vxBZ6aa1+FIYeDG8DYP8/tdxyz/rN9lT6Vsdr7MZPM3UkmDZWNy20bFK8pyOkigmRDH
         rkgCnzROiMP5Bo9tGPphCIi0EwDCcB0iSshQxHkN66IwkJD0POlNE9BTMqTpcPK5h3UY
         EbEw==
X-Gm-Message-State: APjAAAXdYiBRx94zPozp5Chf8hNfrBBU+UltL5SpnzDQLoM1LYobQ35H
        vtsq+soX67gaqPs7cZH0OsaoxHlGQGw=
X-Google-Smtp-Source: APXvYqxoQXEfsLqkVwODnGB8toR5dritL9dhn48aXN5vhb5rgxtPC6+ujlrjK0QD+u1CPSTPzap0Bw==
X-Received: by 2002:a63:2ec9:: with SMTP id u192mr19891995pgu.16.1568014416992;
        Mon, 09 Sep 2019 00:33:36 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a29sm24721403pfr.152.2019.09.09.00.33.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Sep 2019 00:33:36 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH net] sctp: fix the missing put_user when dumping transport thresholds
Date:   Mon,  9 Sep 2019 15:33:29 +0800
Message-Id: <3fa4f7700c93f06530c80bc666d1696cb7c077de.1568014409.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This issue causes SCTP_PEER_ADDR_THLDS sockopt not to be able to dump
a transport thresholds info.

Fix it by adding 'goto' put_user in sctp_getsockopt_paddr_thresholds.

Fixes: 8add543e369d ("sctp: add SCTP_FUTURE_ASSOC for SCTP_PEER_ADDR_THLDS sockopt")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 9d1f83b..ad87518 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -7173,7 +7173,7 @@ static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
 		val.spt_pathmaxrxt = trans->pathmaxrxt;
 		val.spt_pathpfthld = trans->pf_retrans;
 
-		return 0;
+		goto out;
 	}
 
 	asoc = sctp_id2assoc(sk, val.spt_assoc_id);
@@ -7191,6 +7191,7 @@ static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
 		val.spt_pathmaxrxt = sp->pathmaxrxt;
 	}
 
+out:
 	if (put_user(len, optlen) || copy_to_user(optval, &val, len))
 		return -EFAULT;
 
-- 
2.1.0

