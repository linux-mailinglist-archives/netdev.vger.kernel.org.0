Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA0E58EE3D
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 16:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732956AbfHOOci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 10:32:38 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:56017 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732940AbfHOOch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 10:32:37 -0400
Received: by mail-wm1-f68.google.com with SMTP id f72so1453776wmf.5
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 07:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aDNxpHGNjzIhRdFUHhWdbz14YhYFMSlgXH+UzQL/n/8=;
        b=w00eD6zuYRGH1jIiTVJEf9lLjIVZnhC0QawhAC32fxEEopDqbM7+pSk/U1hD8EBSZY
         /yxX56laY8Y0nO3tLEghixZcIXpdS5dvO1Z3f/OD02kX0sMLzg7Hi5obV7/aO0OSASB2
         74H0Jk8AAzzEU15yE5DzNS4DUzEcbQC4AWywvYV6r+mfcMBR3Sm1saJe4KsrF6Ax+i+A
         Lj36frIWgqgDwygDUu59dq/jgYRHPN0QxpLO8ED+hYdQUkbJyhGsyY2Y4MrbuXdAujnY
         9dExVa93uVTvqdbIzppTifEVJvdkm1zjhojjoyUlouF+EHQt8HQS9/ay5FIS9jzp2UEz
         HSiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aDNxpHGNjzIhRdFUHhWdbz14YhYFMSlgXH+UzQL/n/8=;
        b=l9i75l8DabbUIzHPFhImIJW7auxuD6HS6wQA5MDdrI9aklH+Q+NEMwIkHgAUu8cb1U
         tMIKi60wJOHiXOS8A3mCIgCNxUvcstr8S1BUyn1SG9yY07yvTVK4VwzGt6zo/usxFm/+
         zCaVAEVZfo5avaPKxoKeXZzpJldwWHWCLaySR7vkWifIF721KGDwxk5SzwTDsdgvFt6Y
         onkeOB7WXn/RJC4U5VIyLmDsTp7+VZo4wEf6Y5OcMjzh8hrnrwyI1CO3lJfbsgjpb/G0
         iGJmqO7N8aI2OfTc+QnzPRelUYY4oXNlDyIjLr9wZakOnD9Js0vQrusdUqkYEj3IuN1/
         /+kg==
X-Gm-Message-State: APjAAAXyGpvN1Euc6PRmFeIxR5rP7aXus2yQGaNrQJWa/GhXckvGjHoX
        Q2GThMWP12iqn8KLTtoHAQkGbA==
X-Google-Smtp-Source: APXvYqxUUBg66ASuGRViLj9+Zj2B2ANuj8oLlQrkJxxEmO5ygbikhXVzd8iDj+qx4LVlLJbmdKlm2A==
X-Received: by 2002:a1c:a686:: with SMTP id p128mr3228393wme.130.1565879555573;
        Thu, 15 Aug 2019 07:32:35 -0700 (PDT)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id a19sm8857463wra.2.2019.08.15.07.32.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 07:32:34 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH bpf 5/6] tools: bpftool: fix format string for p_err() in detect_common_prefix()
Date:   Thu, 15 Aug 2019 15:32:19 +0100
Message-Id: <20190815143220.4199-6-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815143220.4199-1-quentin.monnet@netronome.com>
References: <20190815143220.4199-1-quentin.monnet@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is one call to the p_err() function in detect_common_prefix()
where the message to print is passed directly as the first argument,
without using a format string. This is harmless, but may trigger
warnings if the "__printf()" attribute is used correctly for the p_err()
function. Let's fix it by using a "%s" format string.

Fixes: ba95c7452439 ("tools: bpftool: add "prog run" subcommand to test-run programs")
Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 tools/bpf/bpftool/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index e916ff25697f..93d008687020 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -139,7 +139,7 @@ int detect_common_prefix(const char *arg, ...)
 	strncat(msg, "'", sizeof(msg) - strlen(msg) - 1);
 
 	if (count >= 2) {
-		p_err(msg);
+		p_err("%s", msg);
 		return -1;
 	}
 
-- 
2.17.1

