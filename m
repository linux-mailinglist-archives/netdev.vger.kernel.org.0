Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDA56C4089
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 21:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbfJAS6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 14:58:30 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33169 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbfJAS63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 14:58:29 -0400
Received: by mail-wm1-f65.google.com with SMTP id r17so3209432wme.0
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 11:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=H6/bUr0qhwABDMJlVrtBRjAVF59eUouZt1hrW+PW6sw=;
        b=GzYCXyL8opjcqdbj+oxTAraDJ7Y5ik2qdqQIRv9jvPmL/Q6LMUt77c+2+rx2+aFm6B
         hkkhSniHTzPmkOVXYT6hVeu6Tud46PRnnbREgX2fqltX8k9iUABCHLx3/YxxhDnx+/1N
         +BWuAImGUZWAax7pFQqtBvIqgpuGPkuNKabP/HSyZdiEQJ6vn+rsg339YVrd1m2LnWlt
         dMnoJooga03GDCzNHZQCiE/68gJWBVYkC2m9O+zLK6986/tPoLLMEvJnhyOuWSxxXVQu
         V1b2U/0/2KoPiKdEe4EhD4VKj/TSA5cDp9So9m+XFmqL+iTMi7jMIuphRfjyWJZEuohZ
         /dpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=H6/bUr0qhwABDMJlVrtBRjAVF59eUouZt1hrW+PW6sw=;
        b=k/1ivfLIcnjqxTmnCYy0zAuRjwwuqnQrhIElyESsZzxpAR6SxWtDW0cPTXvLRLpNKw
         Rpd3vbKtipjZV/CDqF5rIkIY0VT8G89YO+72jf3sIiWfFkI1Rv5fIFyngyz4daVqennE
         tMepdyonTmygD1i9OptJJ/hQyE1wt6LSm3I4eHgAC+Q3TqFPUtdaWeqww0tIogU6QKwC
         t9GnGXOZOB4nl1stecuQiBJfwPz79uwN0g7c7YfE2JIq18+S3VdepguLn+rzN/mf2LzO
         Iv2g89pzEcQv2ae68xx0hxv8Ee6fpEn5FLrsRHuw+rzROuqupMz0EpchTFAiAdDBNem/
         Rlcg==
X-Gm-Message-State: APjAAAX+Zz1XRAig78fBRWdVgKWAAGK7rpnHCGyRSqhkQRg7l3Xmx+Lm
        L4DjOJrbWu5CCKSpNU/TotU=
X-Google-Smtp-Source: APXvYqxfmliHCv3+FEszKYN5+yrNAQHCaldTLTnmzdzVoisqA567CtwKXnbjiV6IIJT4CP8fsD3ueQ==
X-Received: by 2002:a7b:cbd6:: with SMTP id n22mr5255930wmi.39.1569956307590;
        Tue, 01 Oct 2019 11:58:27 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id f143sm8066997wme.40.2019.10.01.11.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 11:58:27 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net 0/2] SJA1105 DSA locking fixes for PTP
Date:   Tue,  1 Oct 2019 21:58:17 +0300
Message-Id: <20191001185819.2539-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes the locking API usage problems spotted when compiling
the kernel with CONFIG_DEBUG_ATOMIC_SLEEP=y and CONFIG_DEBUG_SPINLOCK=y.

Vladimir Oltean (2):
  net: dsa: sja1105: Initialize the meta_lock
  net: dsa: sja1105: Fix sleeping while atomic in .port_hwtstamp_set

 drivers/net/dsa/sja1105/sja1105_main.c | 20 ++++++++++++--------
 include/linux/dsa/sja1105.h            |  4 +++-
 net/dsa/tag_sja1105.c                  | 12 +++++++++++-
 3 files changed, 26 insertions(+), 10 deletions(-)

-- 
2.17.1

