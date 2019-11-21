Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26A20105700
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 17:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfKUQZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 11:25:22 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:35957 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbfKUQZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 11:25:22 -0500
Received: by mail-io1-f66.google.com with SMTP id s3so4149897ioe.3
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 08:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=ggUwZvZMgqrYDRz356iDw8tIYSmoM3AzI7H9Gd+VI7s=;
        b=TqIVZNMLhqcZMeZxm4SO/ejc1mFI3fOvPBrOEKyVTTqj0gGAcZPBDLYFbYv7FJXs6Y
         Y862zgS+FVxL/7B5XOQCEEKJGRE31fpdI1Yc59FeRCIwuZPtEPeewtFaot9w02/kMuEl
         LEgqOIuSYFHI5iCXtMx+ROHY8s2P0DA8ZC9YmsIRhrpZ4doDVZYegAgeumABpSunI9UW
         sD0hOcl2+1HE++HeQoHWe1PnzbvrIlRWDTaFHcisRubowzBo3K3EqQ5lXaM6lw7jF/0I
         FIJDwLtmNZx7WaxX76ea7eTG0N9NMZtUVKXOyVJYhuij5tTOFKsPhckW7FET600WulNo
         AERg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=ggUwZvZMgqrYDRz356iDw8tIYSmoM3AzI7H9Gd+VI7s=;
        b=rHk5vYJ69yrVTHLLw3bxt5zjbEn30bVCsB7sCBFDJWuFOr6a8gD2HNwo8zCg9mvfY/
         LzV4gwhYYyf7SSPT2XNJt+z7vNAUP8ncD0TMrFVYyIxO1LWIbzWg6bLg3SK8Gi81nsf0
         U9lWa5KTy95JxBqCCuELrfZRU4/DNW269Yks3YfFowX9dTdPWcuiNKR4v3kNrokyMUb1
         J2M2UHGgC+4GxyuRVhFWw9FJ1oeuZq37LWD9ucI9wDQdw3V9bbttQyDx493jAKpC7gcS
         CdagTZ9ZV5t2ezHFTJXt23X0SVphjB2Dd9RxL6I2b5MYbamXZ/Wp0iQsI/rVKsv0Cj/S
         waCA==
X-Gm-Message-State: APjAAAXbDhumquDHcyeKKxxo427GRG9NQZJ3o1JX2d6AY9tmtjF2PM/I
        qSsKc1N4jz22Ow8B0ZBW8goMSGFk
X-Google-Smtp-Source: APXvYqydSYSPmQlB7PcMGwGuLDafR1kwmn6vkEP3MeUs9mRXPetGutU5oKmA8IstYqWh0L4+omh47g==
X-Received: by 2002:a6b:f60f:: with SMTP id n15mr8590546ioh.263.1574353520943;
        Thu, 21 Nov 2019 08:25:20 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id k19sm1075692ion.81.2019.11.21.08.25.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Nov 2019 08:25:20 -0800 (PST)
Subject: [net PATCH] bpf: skmsg, fix potential psock NULL pointer dereference
From:   John Fastabend <john.fastabend@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, john.fastabend@gmail.com,
        dan.carpenter@oracle.com, daniel@iogearbox.net
Date:   Thu, 21 Nov 2019 08:25:09 -0800
Message-ID: <157435350971.16582.7099707189039358561.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report from Dan Carpenter,

 net/core/skmsg.c:792 sk_psock_write_space()
 error: we previously assumed 'psock' could be null (see line 790)

 net/core/skmsg.c
   789 psock = sk_psock(sk);
   790 if (likely(psock && sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)))
 Check for NULL
   791 schedule_work(&psock->work);
   792 write_space = psock->saved_write_space;
                     ^^^^^^^^^^^^^^^^^^^^^^^^
   793          rcu_read_unlock();
   794          write_space(sk);

Ensure psock dereference on line 792 only occurs if psock is not null.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index ad31e4e..a469d21 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -793,15 +793,18 @@ static void sk_psock_strp_data_ready(struct sock *sk)
 static void sk_psock_write_space(struct sock *sk)
 {
 	struct sk_psock *psock;
-	void (*write_space)(struct sock *sk);
+	void (*write_space)(struct sock *sk) = NULL;
 
 	rcu_read_lock();
 	psock = sk_psock(sk);
-	if (likely(psock && sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)))
-		schedule_work(&psock->work);
-	write_space = psock->saved_write_space;
+	if (likely(psock)) {
+		if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED))
+			schedule_work(&psock->work);
+		write_space = psock->saved_write_space;
+	}
 	rcu_read_unlock();
-	write_space(sk);
+	if (write_space)
+		write_space(sk);
 }
 
 int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock)

