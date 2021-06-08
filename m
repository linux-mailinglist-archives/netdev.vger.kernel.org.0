Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3987339F840
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 15:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbhFHOAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 10:00:35 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:55273 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233129AbhFHOAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 10:00:35 -0400
Received: by mail-wm1-f45.google.com with SMTP id o127so1895079wmo.4
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 06:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2VD6JQSId+NjhuSw/powVZDfWBuBnQRjpJ5ySxveaVY=;
        b=M2SULmpsQMlNcPc5y5q9boxImJYfdXoDY8sdDtj1MZbutQK7vn6hIaWibGZjyRLjBm
         809Yl8GrGJEVvlBv3gnUjlEyHYwXjb5o/K7CjsV4bnRl4Pksn3w15uOn1gRT5mzRm9Q2
         SbHRVYE35aGgdTnVcfIj7KS/UeCG7d9sHVt/mClTgnyTXY6JAXd+UOqtohCp8L+2xKIg
         204c5g2g19BnEgN3iaqAOeBAwwLxuax70FPd0COVXJZ9PMEQ3LmURJ1lKlo+lRhJN2Fh
         QHvdguRzu+xXQqj0Dz00LR6PgA7sNLSIRxcPYIk5BPpRV0Mw5U87qkmOCTGNOmn5cIuk
         8Bsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2VD6JQSId+NjhuSw/powVZDfWBuBnQRjpJ5ySxveaVY=;
        b=BRdLUQc/hkIAY7J0jJFcIJ/+NO1rARhxGaAlqS8jmom2YCDmiMDWB734XwKy9Ujjdn
         1mSZrIxJsXpcrdCOFHECsW8SfY+0f2tSozOnF8jb1RcL3Vvjy58QkphPKiyLpgVgsiQ5
         KB8zdsL1FIawn2zFoiJb9GXMkH0YTP1MpMvXolbx8aioPGdJY6m9bNiaXomrpwvEgHvM
         qMKAzXjoDlhzZ2AK4UIFjzvvRFXMKEGh1JF3hXdfYu06QiGoOMv/eN0X783w09SHue1A
         GNi5E3qoJR5vE5hxy77ScvYSg7D+b0GuYnoUdJf7kyikv1/hSYn3gEJcb88lWk1WwfK6
         bQtA==
X-Gm-Message-State: AOAM531jcU0h1scPkTPx8wTenBSBdfK+pwgM2k+kB+wTp1kTJNbrg3Qd
        Ypu/yVrLTQALmZ4SmfB45o3SJA==
X-Google-Smtp-Source: ABdhPJzifcPM1L2c1lMV4Uj5JFT/CENE6xe7ZO8QKnbz87qnjq2q/r5YZurykfVj4scSsXzBL52OZQ==
X-Received: by 2002:a1c:a917:: with SMTP id s23mr18037267wme.55.1623160645937;
        Tue, 08 Jun 2021 06:57:25 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:85ed:406e:1bc4:a268])
        by smtp.gmail.com with ESMTPSA id f14sm1956108wmq.10.2021.06.08.06.57.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jun 2021 06:57:25 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, johannes.berg@intel.com, leon@kernel.org,
        m.chetan.kumar@intel.com
Subject: [PATCH net-next 2/4] rtnetlink: add IFLA_PARENT_DEV_NAME
Date:   Tue,  8 Jun 2021 16:07:05 +0200
Message-Id: <1623161227-29930-2-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1623161227-29930-1-git-send-email-loic.poulain@linaro.org>
References: <1623161227-29930-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

In some cases, for example in the upcoming WWAN framework
changes, there's no natural "parent netdev", so sometimes
dummy netdevs are created or similar. IFLA_PARENT_DEV_NAME
is a new attribute intended to contain a device (sysfs,
struct device) name that can be used instead when creating
a new netdev, if the rtnetlink family implements it.

Suggested-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/uapi/linux/if_link.h | 6 ++++++
 net/core/rtnetlink.c         | 1 +
 2 files changed, 7 insertions(+)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index cd5b382..0ac1f6a 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -341,6 +341,12 @@ enum {
 	IFLA_ALT_IFNAME, /* Alternative ifname */
 	IFLA_PERM_ADDRESS,
 	IFLA_PROTO_DOWN_REASON,
+
+	/* device (sysfs) name as parent, used instead
+	 * of IFLA_LINK where there's no parent netdev
+	 */
+	IFLA_PARENT_DEV_NAME,
+
 	__IFLA_MAX
 };
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index c0c8dec..56ac16a 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1878,6 +1878,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_PERM_ADDRESS]	= { .type = NLA_REJECT },
 	[IFLA_PROTO_DOWN_REASON] = { .type = NLA_NESTED },
 	[IFLA_NEW_IFINDEX]	= NLA_POLICY_MIN(NLA_S32, 1),
+	[IFLA_PARENT_DEV_NAME]	= { .type = NLA_NUL_STRING },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
-- 
2.7.4

