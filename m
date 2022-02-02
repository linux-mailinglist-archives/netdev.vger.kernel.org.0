Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF4DC4A778E
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 19:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239663AbiBBSLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 13:11:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbiBBSLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 13:11:50 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43EBC061714
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 10:11:49 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id v13so155045wrv.10
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 10:11:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=zpdaFEsMrs+98j/JhqetE6Il01i4pl1N41p/1DrXz0k=;
        b=wddm63DJ58aBphhHeI31409Mihbhj+/TwQiyoQgdAe0p/HXE/UHAdswRHGBFIGepO0
         39b8Mcwl0BuLMA0UouvPc0wXFl/IYtFZ1bvYa3+Esc96g5Vhqs8IrkQIotMEdaJEHz8t
         O/ANdsZYVUFY2Q3EfFTlHmOfiL0TTO3rk6zZwrrl4ZBxw/7t3YwW4pNa+HVFIrRThuNp
         Rx5HhJL3nFQQP2FwIyz403QooDIl3gwtn7yycZ2krCcejHaQROy1a1pdFRqy5ibF4acO
         vHkjzmKjea/ptuLzB9pACwLnXanNz78uB29fwrAvsMlseVXNOz2KKbBcGmxQ66Z6urjN
         HSdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=zpdaFEsMrs+98j/JhqetE6Il01i4pl1N41p/1DrXz0k=;
        b=4qJBGzIasK58RL6uQ8VhEBU3ixyzqOqv8+xkxqaMkJ9jdJOYthJR5UC6zZRzPh7Yuw
         ewZGrIFw/1YLLFxrayV3JWqHGio+PXUgJ0jmMH9NcR1LitPeeiYheRQ0WXGBLcBrBOWP
         BamDjdsmtzaeXP/VU3Z4RXvbovU67umPpQv8jHEZqnWwgLetP8SMUZOuzp354bVnDO+p
         x7p5vyI17QJk7CB5L+3p4qorWtQ5EMGjEgByuExbGr9aHTd9uJrRP1ct9qXyVbPoMzPq
         poV8lD5kFSgBTgXLkqb1gq4WX78MW8d3scpYh+hmy2JC5+0VIL4SPoZmhu5gNQC1AkI7
         gK5g==
X-Gm-Message-State: AOAM530aIAgNn5T2CIe2+i5fwnuAondmYrwVSiOngCaxGhRRNubNpiVh
        +rZ2MyxOK/LnxX/A8MaXPhxyQE2XhOYO
X-Google-Smtp-Source: ABdhPJywkT7xo3CJIf5bONV8ZCUGmOSauJyLgl/8y4OW+EJfG/Z8bVhPYR1cGwdGRDaiwLdE2ovCag==
X-Received: by 2002:adf:ff83:: with SMTP id j3mr27072358wrr.10.1643825508246;
        Wed, 02 Feb 2022 10:11:48 -0800 (PST)
Received: from Mem (2a01cb088160fc00aceb97be319ea013.ipv6.abo.wanadoo.fr. [2a01:cb08:8160:fc00:aceb:97be:319e:a013])
        by smtp.gmail.com with ESMTPSA id r2sm9805260wmq.0.2022.02.02.10.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 10:11:47 -0800 (PST)
Date:   Wed, 2 Feb 2022 19:11:46 +0100
From:   Paul Chaignon <paul@isovalent.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Hangbin Liu <haliu@redhat.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2] lib/bpf: Fix log level in verbose mode with libbpf
Message-ID: <20220202181146.GA75915@Mem>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before commit c04e45d083e8 ("lib/bpf: fix verbose flag when using
libbpf"), the verifier logs were not displayed when the verbose flag was
passed. Commit c04e45d083e8 fixed that bug but enabled the incorrect log
level. This commit fixes it.

The kernel supports two log levels. With level 1, the verifier dumps
instructions along each visited path with the verifier state for some.
With level 2, only instructions for the last visited path are dumped but
each instruction is preceded by its verifier state.

Log level 1 probably makes the most sense for the verbose flag as it has
the most comprehensive information (full traversal of the program by the
verifier). It also matches the log level when not using libbpf.

Fixes: c04e45d083e8 ("lib/bpf: fix verbose flag when using libbpf")
Signed-off-by: Paul Chaignon <paul@isovalent.com>
---
 lib/bpf_libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/bpf_libbpf.c b/lib/bpf_libbpf.c
index 50ef16bd..bb6399bf 100644
--- a/lib/bpf_libbpf.c
+++ b/lib/bpf_libbpf.c
@@ -305,7 +305,7 @@ static int load_bpf_object(struct bpf_cfg_in *cfg)
 
 	attr.obj = obj;
 	if (cfg->verbose)
-		attr.log_level = 2;
+		attr.log_level = 1;
 
 	ret = bpf_object__load_xattr(&attr);
 	if (ret)
-- 
2.25.1

