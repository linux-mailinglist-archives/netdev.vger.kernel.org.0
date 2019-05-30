Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FABC2F83F
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 10:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbfE3IGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 04:06:16 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:32874 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfE3IGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 04:06:16 -0400
Received: by mail-pf1-f193.google.com with SMTP id z28so3470652pfk.0;
        Thu, 30 May 2019 01:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=dmxH8nCXC6gew7umBGLpr9b8q0p2yrRmO5r/LI2MlsI=;
        b=cH79pGEoPjeUd3cqBNWIUrNpLt+motW/jO41ztMuuj7NLJDf7oLvFWizrvo2R+Sn6D
         /sg3HuSYb69+snkJuZQhvZD59djGWBaTI9Sk3NmMOtZZKUgitunUvwkp9YNLeZAD4nbj
         OMm/oLy5DAmE3xOQbOmOTwS/HUZGEmG8mZvU4iEKmBs+JloEQRNU9YUPO900b9TEk1JQ
         FCJCdrl9fQncvMkV0EH9DXQN9/az/dHgNXxdddbD59tT47Km6LLKsXoctecwUpPJKls3
         Z/PIRyoogssp9c0PN+xrQEfz3lBZufIhtLGKzhfjZvgFEukEphGEX/pAuZkRKlXBusd/
         Bhug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=dmxH8nCXC6gew7umBGLpr9b8q0p2yrRmO5r/LI2MlsI=;
        b=OV1LhIpUvyga+IAMvhG56OxZAmTduJltt5rLebJp/MF1iyX7tCCxUlqhHwTPtqijqz
         3jQzt66Ac64KxyCLLaKeE0uLXQHWLRXiqoPZnproDF78vGqr2TpJenpP6z7iI0rINDrk
         auEPPNCrcEqn+J7+uhM2MRxli5CSMgjm+JTXON68O0vsyjWJH3RuS5GP/PMNiiRk7t8P
         BJ0a21ppHYnsaRButKhvVDfkATV/IL3nJPECoU/+Q5ZKGijbv7GpXYGh3Tc4tmrH0PV2
         Fl+uw/8ReITZBE7PzAtgz8IvdV4iUL8erNeRuHy8w/hnQs7H5Z2I2NGpmGGixwu9tm7n
         umJg==
X-Gm-Message-State: APjAAAVOFD/fT9hzSDQbr1eQDrSWMrPTkHPBqSlLXdc8aILDcL/syEnv
        EN7jCJ595DlwJHJebpuwI13lL4Iy1VI=
X-Google-Smtp-Source: APXvYqxTBwW62pEtoOAsKQv9PHm/YPadNbpvsPcnlwTRngWDOvtvN/tEj3XHn6yPiGkOah+WcYlabw==
X-Received: by 2002:a63:1622:: with SMTP id w34mr2579127pgl.45.1559203575735;
        Thu, 30 May 2019 01:06:15 -0700 (PDT)
Received: from zhanggen-UX430UQ ([66.42.35.75])
        by smtp.gmail.com with ESMTPSA id x16sm1928024pff.30.2019.05.30.01.06.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 01:06:15 -0700 (PDT)
Date:   Thu, 30 May 2019 16:06:02 +0800
From:   Gen Zhang <blackgod016574@gmail.com>
To:     paul@paul-moore.com, sds@tycho.nsa.gov, eparis@parisplace.org,
        ccross@android.com
Cc:     selinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] hooks: fix a missing-check bug in selinux_add_mnt_opt()
Message-ID: <20190530080602.GA3600@zhanggen-UX430UQ>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In selinux_add_mnt_opt(), 'val' is allcoted by kmemdup_nul(). It returns
NULL when fails. So 'val' should be checked.

Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
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
