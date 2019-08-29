Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32759A2150
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 18:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbfH2Quy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 12:50:54 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38855 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbfH2Qux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 12:50:53 -0400
Received: by mail-wm1-f67.google.com with SMTP id o184so4553699wme.3;
        Thu, 29 Aug 2019 09:50:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EAPNXwtNcvomkAv43HK7BcSQSi3ID9bH+hr63tWVdSI=;
        b=B5HGm8Y0d+BC3TOmZ23uuf+WqGqYOV7ombVlzG70cKlsV5JRtEvvNhzfPX4mECWFhx
         u5j/9cXAx5IqdKYxp7N//EOr02YdCxMO9TImOTBYGSfNXGWuDvoj6pJX11SgB//Tt5im
         yYal4ni8RQu92gT5EGlqUSz2C0ZgmGFTTf+a6stQq6hqSBqIOsB4/FaV7WQu1kPe6C3X
         +xLocX36sKRkLLs3x2PB2D+myD7iamK/wRKiMKBKp2+VCm7/qCDUbUDyTARThORMu67E
         QuOMPvFXZtlfAMMmQxgNFbLz16ewEqahiYYT8vzew1IHcjJ1Y165M5UTbENb5n3dJ24k
         kxqA==
X-Gm-Message-State: APjAAAX+kGHw6qYwNcIPCIAbgM17lyiHVPh/qD8mC15U8cFFX3Ij61QJ
        D4+f5ZSeYUoFEP3fmz575wgwXYvwuHo=
X-Google-Smtp-Source: APXvYqyG8Uv9qqAEzfuwRYVShx38vJV1pUSPq3W7ZBAlPx5+N1oEiU4zijmswr1WDwZJj2S7mhEW8w==
X-Received: by 2002:a1c:f704:: with SMTP id v4mr361727wmh.90.1567097450438;
        Thu, 29 Aug 2019 09:50:50 -0700 (PDT)
Received: from green.intra.ispras.ru (bran.ispras.ru. [83.149.199.196])
        by smtp.googlemail.com with ESMTPSA id o14sm8340770wrg.64.2019.08.29.09.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 09:50:49 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     linux-kernel@vger.kernel.org
Cc:     Denis Efremov <efremov@linux.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Anton Altaparmakov <anton@tuxera.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Boris Pismenny <borisp@mellanox.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        Juergen Gross <jgross@suse.com>,
        Leon Romanovsky <leon@kernel.org>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sean Paul <sean@poorly.run>, linux-arm-msm@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-ntfs-dev@lists.sourceforge.net, linux-rdma@vger.kernel.org,
        linux-wimax@intel.com, linux-xfs@vger.kernel.org,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH v3 01/11] checkpatch: check for nested (un)?likely() calls
Date:   Thu, 29 Aug 2019 19:50:15 +0300
Message-Id: <20190829165025.15750-1-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IS_ERR(), IS_ERR_OR_NULL(), IS_ERR_VALUE() and WARN*() already contain
unlikely() optimization internally. Thus, there is no point in calling
these functions and defines under likely()/unlikely().

This check is based on the coccinelle rule developed by Enrico Weigelt
https://lore.kernel.org/lkml/1559767582-11081-1-git-send-email-info@metux.net/

Signed-off-by: Denis Efremov <efremov@linux.com>
Cc: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 93a7edfe0f05..56969ce06df4 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -6480,6 +6480,12 @@ sub process {
 			     "Using $1 should generally have parentheses around the comparison\n" . $herecurr);
 		}
 
+# nested likely/unlikely calls
+		if ($line =~ /\b(?:(?:un)?likely)\s*\(\s*!?\s*(IS_ERR(?:_OR_NULL|_VALUE)?|WARN)/) {
+			WARN("LIKELY_MISUSE",
+			     "nested (un)?likely() calls, $1 already uses unlikely() internally\n" . $herecurr);
+		}
+
 # whine mightly about in_atomic
 		if ($line =~ /\bin_atomic\s*\(/) {
 			if ($realfile =~ m@^drivers/@) {
-- 
2.21.0

