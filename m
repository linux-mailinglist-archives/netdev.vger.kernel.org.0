Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9743063F
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 03:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfEaBeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 21:34:09 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:42166 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726372AbfEaBeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 21:34:09 -0400
Received: by mail-pf1-f176.google.com with SMTP id r22so5082847pfh.9;
        Thu, 30 May 2019 18:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=2jdf5gdvxJLWEpe95q9RP+J/f86gwawcG2y3UhyKy6E=;
        b=XLjkQvW0rZGGaLjNWYrBaqOhwdd5xcDVuOM5WTenLbFPCJ/u1AI7nQ3xv7snlko0d0
         x4meUwwpYJ/X+RJXokG+kVasmIKNVUOyevN6M17efAgdRMlWcVgLN9broGf+Yh29wkYM
         bfssnC8Mt1OuoO8n95wII6hN2RDZopq5u/sVjcg3bXuh07+MKIKHAAvjHzvqC189sqo3
         HrYA/fu30QVkbkD+/f8wJixIEEx2HvfMmh/bePi3BJP4ufiTZPbxqEeGs1wyv+OVqXek
         qw6dwmuohi7SQ4KLI/vMIxqx9QcnmtY8ERHp1tL7dnpOJ4q1oqaLXGETJ+zYwgabOw+1
         0EhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=2jdf5gdvxJLWEpe95q9RP+J/f86gwawcG2y3UhyKy6E=;
        b=jAZu7qMH/ZcL2E8nW9fmQnyBPsaVb8W0li1ZEm91dKLi8WbImxyqLCeYuwDL7EWVYx
         Gu6KEhLcKk4vJ0qG3DAPqNcpxkcgP0BI67MEDP12lzICInF41U16rdXq9OMddiyzQTVf
         He1WJlhAFhoIudk9KcSz1CA4ZwRxwr5CluHZOLLmF/eZk0E2WzrU+pTG7+4VELO3Hh8n
         1TShM6hVx/2cFddCfAMVD+gWkOsuZnnCWfZVf1UY5t5Gpc/xYNX3YOV+af+EG7GUdLOl
         CQLJynGOnZRY4txIPy+mfrWL5QHazg9AbX2w0V2mv1GO1mlwZIPJce4iNybqbkbc4nnS
         8ASQ==
X-Gm-Message-State: APjAAAWzL0RRx8kNYxFkFBsL2UjNRDUhWIze9WHxAg81uNlhTLClezco
        +WAyDRDl+sufvpgkJjWYiWFEzyTC
X-Google-Smtp-Source: APXvYqyOv3x917STsD/cuAg6EAbZ0cle8xAZwN7YMSgJs7VhnIxUQfx5mvD1pbRCzy97ZwqA50uC2Q==
X-Received: by 2002:a63:5b18:: with SMTP id p24mr6319144pgb.452.1559266448663;
        Thu, 30 May 2019 18:34:08 -0700 (PDT)
Received: from zhanggen-UX430UQ ([66.42.35.75])
        by smtp.gmail.com with ESMTPSA id a64sm3156160pgc.53.2019.05.30.18.33.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 18:34:07 -0700 (PDT)
Date:   Fri, 31 May 2019 09:33:50 +0800
From:   Gen Zhang <blackgod016574@gmail.com>
To:     paul@paul-moore.com, sds@tycho.nsa.gov, eparis@parisplace.org
Cc:     selinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, omosnace@redhat.com
Subject: [PATCH v2] hooks: fix a missing-check bug in
 selinux_sb_eat_lsm_opts()
Message-ID: <20190531013350.GA4642@zhanggen-UX430UQ>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In selinux_sb_eat_lsm_opts(), 'arg' is allocated by kmemdup_nul(). It
returns NULL when fails. So 'arg' should be checked.

Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
Fixes: 99dbbb593fe6 ("selinux: rewrite selinux_sb_eat_lsm_opts()")
---
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 3ec702c..5a9e959 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2635,6 +2635,8 @@ static int selinux_sb_eat_lsm_opts(char *options, void **mnt_opts)
 						*q++ = c;
 				}
 				arg = kmemdup_nul(arg, q - arg, GFP_KERNEL);
+				if (!arg)
+					return -ENOMEM;
 			}
 			rc = selinux_add_opt(token, arg, mnt_opts);
 			if (unlikely(rc)) {
