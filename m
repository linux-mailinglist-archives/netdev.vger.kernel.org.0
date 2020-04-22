Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666DE1B3EB0
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 12:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731066AbgDVKa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 06:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730936AbgDVK2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 06:28:37 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4EAAC03C1AD
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 03:28:36 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id g74so1739460qke.13
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 03:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xr1VuRWexFKfZaAUV/+2KBKVKlnxK30XNcZOGdLsaAs=;
        b=saYLG70wzoX5/JG+Jy6RF/I7U0uJRBIREziPNcgyxxPfIETu2MYJoF4mQ5iKoabrFs
         bjlImwxh0170HopOS7Y0wdjghujcd0DqysU/PK3a8ueISG29/83NfNF69FM27VcAY8Z1
         h7G+AOdKzcF2WLeebzJiP9nf8ns7G79hJvDdzR3SfSY3hMWciXhlUmaK5cjo9TgKCtUb
         Bt6skC6eCTnloeGtSykz68ST5Xn6bMIfTdiFiT4P/l0q/6JkbX+XNEfoyZCC2q/OpT4n
         TrvcwIq2w0LoXTxIIS3e6QU3j4dJwFncg1+Q+oW3hSpVOjly2llER2OJwBXaz/YSbQS2
         O10A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xr1VuRWexFKfZaAUV/+2KBKVKlnxK30XNcZOGdLsaAs=;
        b=W/s5eKGoCOp/xTyKzcaJlqnbEnMOrsKns5h3mCEUvV5UsBRHHrT+8qk6gvaHPD1Jz9
         nvfxkAhtqFns4Vw+50LrQK3YjdZdbZ9oup8cArlC1rFvMr4vl7tgGbMJZVEXEf5PeV07
         rc42njzHwmSQDh4dFVwgQT6/1eqZjRgIXqA00uYE1/d+ARKhrgJQTbbVIml95yh9Ad17
         GlSjFio2Gh2uwTJO5UH4L/BCjtxsc/UYZLphH99RjpEjf4n1mVHOPdDfzwrqhKmsR+0X
         eZo2ODBz1aK44ufq2+1SL4TOia6n3YLTC1BNeLWTodqt2TY6JBuYmmN87Vz71SR68gNV
         RDEQ==
X-Gm-Message-State: AGi0PuZsNM8PyDGppz9R+EQhz3YRiNukg3wdZ6mcsKwpV9VT4OiOK5Ca
        VKQWuU9KOLqaTgKGPD3HrGr29A==
X-Google-Smtp-Source: APiQypJ10zY2TT04i4bA4sun4LJlfGVw72o/o+PLrmWwpJm9ItKAtsUeWLlnNtOGIgZopG8YmyQj2Q==
X-Received: by 2002:a37:4015:: with SMTP id n21mr23171912qka.76.1587551316053;
        Wed, 22 Apr 2020 03:28:36 -0700 (PDT)
Received: from localhost.localdomain (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.gmail.com with ESMTPSA id h3sm3531964qkf.15.2020.04.22.03.28.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Apr 2020 03:28:35 -0700 (PDT)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
X-Google-Original-From: Jamal Hadi Salim <jhs@emojatatu.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, aclaudi@redhat.com,
        daniel@iogearbox.net, asmadeus@codewreck.org,
        Jamal Hadi Salim <hadi@mojatatu.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH iproute2 v2 2/2] bpf: Fix mem leak and extraneous free() in error path
Date:   Wed, 22 Apr 2020 06:28:08 -0400
Message-Id: <20200422102808.9197-3-jhs@emojatatu.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200422102808.9197-1-jhs@emojatatu.com>
References: <20200422102808.9197-1-jhs@emojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jamal Hadi Salim <hadi@mojatatu.com>

Fixes: c0325b06382 ("bpf: replace snprintf with asprintf when dealing with long buffers")
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 lib/bpf.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/lib/bpf.c b/lib/bpf.c
index 656cad02..fdcede1c 100644
--- a/lib/bpf.c
+++ b/lib/bpf.c
@@ -1523,13 +1523,15 @@ static int bpf_make_custom_path(const struct bpf_elf_ctx *ctx,
 	ret = asprintf(&rem, "%s/", todo);
 	if (ret < 0) {
 		fprintf(stderr, "asprintf failed: %s\n", strerror(errno));
-		goto out;
+		return ret;
 	}
 
 	sub = strtok(rem, "/");
 	while (sub) {
-		if (strlen(tmp) + strlen(sub) + 2 > PATH_MAX)
-			return -EINVAL;
+		if (strlen(tmp) + strlen(sub) + 2 > PATH_MAX) {
+			ret = -EINVAL;
+			goto out;
+		}
 
 		strcat(tmp, sub);
 		strcat(tmp, "/");
-- 
2.20.1

