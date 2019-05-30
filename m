Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6C9E2F8D6
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 10:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbfE3IzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 04:55:15 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44648 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726653AbfE3IzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 04:55:13 -0400
Received: by mail-pl1-f194.google.com with SMTP id c5so2274871pll.11;
        Thu, 30 May 2019 01:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KvjM4bsTfrcq2cHYj0Oc8PDr1CJFW5mpcAz8/WiY3E0=;
        b=PJIRhFYa2F4McFzf+xGE3gUTho75opN9ktQ1NXCUdCcGydnK/sgVU70hxfve2x1Om4
         y7lXw5PIyHReB38bZ9+AUHhktIyjgnChQ1AXedGWj9Iwsd4CH+wIcTPLIovd3faUjsFP
         1/NFvpt8TeW6wPHTiPHSQftQHiNxAGSVvR0mn2DfIEfNNIc5LcWfkblavemxfWL+ETP+
         mT7HFpTnW3wrY5Re/8uPNraDblHqA3cuWX1OYHHYuH7ferAoRnqP7p3DhZjOVoy7eu3R
         qjwSINqsn2QOGRvm48tJuDzLp18JlNJja60GkZ5u3oe8eyI6/jP2dnLtGMuypw8YhldW
         ITMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KvjM4bsTfrcq2cHYj0Oc8PDr1CJFW5mpcAz8/WiY3E0=;
        b=mFuPBaZ8Bvl/S7hzfUnehpx6k667wUS6GWFsx4H5ouyUEB+lTEZYeL9+TCP1m7FO5g
         xRvdGsJepV1hhCs3dz/J3VRoEc4wDj2LpKbN075XbsQbUZ7ylHoGlbZ01ZwL7mPcwAnf
         CQJH4R1ExeFnZby+T7HWq075czI9ElY1xCcSzxa4qaAxmY2kvdC7lHpjz1bO75esSkl0
         eJA6WkwSb5HmsL+HZ8V4qWUuP3IeS7lFHM+LqzicwUMwlNArhi9RhNxnMsX9rEzEGwUu
         yUDvB/iEOBhUYG4TcHohiDyDz50SFT7I9P2ORC9IOZ5HQ76M8OTD8eoWfQ5G1K3c/qDm
         BnbQ==
X-Gm-Message-State: APjAAAWTk9j5tVC1j/ZMIV1UwjwhY0b7S3yyBFM/OppUzLevj0OzQYu2
        zZGmmmvjLZs4j5dd08sXy8M=
X-Google-Smtp-Source: APXvYqyXQwgtIekLk3xQBUwVq8/Hu5IaSkI+omKRnrbiDa6+jwZFpuFkY3MoIYdDQJrZpNi5kKmOkg==
X-Received: by 2002:a17:902:324:: with SMTP id 33mr2735283pld.284.1559206513206;
        Thu, 30 May 2019 01:55:13 -0700 (PDT)
Received: from zhanggen-UX430UQ ([66.42.35.75])
        by smtp.gmail.com with ESMTPSA id o15sm921189pfh.53.2019.05.30.01.54.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 01:55:12 -0700 (PDT)
Date:   Thu, 30 May 2019 16:54:38 +0800
From:   Gen Zhang <blackgod016574@gmail.com>
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, ccross@android.com,
        selinux@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: [PATCH v2] hooks: fix a missing-check bug in selinux_add_mnt_opt()
Message-ID: <20190530085438.GA2862@zhanggen-UX430UQ>
References: <20190530080602.GA3600@zhanggen-UX430UQ>
 <CAFqZXNtX1R1VDFxm7Jco3BZ=pVnNiHU3-C=d8MhCVV1XSUQ8bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFqZXNtX1R1VDFxm7Jco3BZ=pVnNiHU3-C=d8MhCVV1XSUQ8bw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In selinux_add_mnt_opt(), 'val' is allcoted by kmemdup_nul(). It returns
NULL when fails. So 'val' should be checked.

Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
Fixes: 757cbe597fe8 ("LSM: new method: ->sb_add_mnt_opt()")
---
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 3ec702c..4797c63 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1052,8 +1052,11 @@ static int selinux_add_mnt_opt(const char *option, const char *val, int len,
 	if (token == Opt_error)
 		return -EINVAL;
 
-	if (token != Opt_seclabel)
-		val = kmemdup_nul(val, len, GFP_KERNEL);
+	if (token != Opt_seclabel) {
+			val = kmemdup_nul(val, len, GFP_KERNEL);
+			if (!val)
+				return -ENOMEM;
+	}
 	rc = selinux_add_opt(token, val, mnt_opts);
 	if (unlikely(rc)) {
 		kfree(val);
