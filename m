Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB1A612B059
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 02:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbfL0BmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 20:42:19 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51541 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbfL0BmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 20:42:19 -0500
Received: by mail-wm1-f65.google.com with SMTP id d73so7033619wmd.1;
        Thu, 26 Dec 2019 17:42:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8MQc30Bhq49NzYQbOHqWb3EmitJUm6bcNdJntGPrKl8=;
        b=p5EJraHyc0vAewa5US/8Q5nMVa6A2amUuOx82AC982ocNBuG1VMrHHQCR/KIyulUVU
         v0iYvMtFqWoUbmPFXQeRIBnITRcwHLtlmDv0ttgoLa+eogOLRzEfBHZl1mEIQb7PW0RW
         lLzlfcJSd3V7PWQLuMfnjjexCiZTUhcnKqk+nCqMmF6bT7G8Y9oxdFspV+Z4Eki2wK16
         WgMf8O8yk10tCz63B3NJrMtAguVrcB/GnRnN5CpXSul4XzTo8p+0eN5M7uRyODc//iZE
         E/JfkqUcvQ/6l9Zn9Fhz5SMFmlsly5cTMf9TXxnX6CcUz9WHZcfB2V/EWDBh32rcswJv
         O3SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8MQc30Bhq49NzYQbOHqWb3EmitJUm6bcNdJntGPrKl8=;
        b=SU1Gq5GRrXyBamqIroYicFvk0gkEWjSaroE1bXlLYJO2Dx0Fk0j/SA4O7xInn7YMAs
         Btq57669kAFguWqwK+/4lA/628MLXkLYTiEu8LE2zvSFZlr9AnhSwSUOmhzHGUg0XQ/a
         43YnP/QE2lMekxUdq4y1S3a1i/KzmkpuSDXWPgFO47fKbC8ig9UzlALNlCCr2E5t7xlv
         U2mWpq+d716tQIluMFDZQ1ak5DUTLaRm2J7CDL5pTPemVk/4J4YteuFrI2aqNmRw4bI1
         nUu44ZH/ohcI8y51lWG54ydGDD8+CzGbLlXAwCnBKCptU72N26AHLNXC0tvllh8gb7SC
         xEWQ==
X-Gm-Message-State: APjAAAXceLB0CchBkryMw0K9GDIMBYU5VF++Qz0micGSDswdjAbGl+dj
        NhN7Ml0fGXaYwmBGWvtD2DI=
X-Google-Smtp-Source: APXvYqxW6zmFNp7xmKlSRdXhZAip9MG8tb3paeQcTwFde6U5eWuP0L5Nsynwg91JkW47jUHZNPNq9Q==
X-Received: by 2002:a05:600c:d7:: with SMTP id u23mr15578058wmm.145.1577410937024;
        Thu, 26 Dec 2019 17:42:17 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id q11sm32622130wrp.24.2019.12.26.17.42.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 17:42:16 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 0/2] Improvements to the DSA deferred xmit
Date:   Fri, 27 Dec 2019 03:42:06 +0200
Message-Id: <20191227014208.7189-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DSA deferred xmit mechanism is currently used by a single driver
(sja1105) because the transmission of some operations requires SPI
access in the fastpath.

This 2-patch series makes this mechanism better for everybody:

- For those who don't use it, thanks to one less assignment in the
  hotpath
- For those who do, by making its scheduling more amenable and moving it
  outside the generic workqueue (since it still deals with packet
  hotpath, after all)

Vladimir Oltean (2):
  net: dsa: Remove deferred_xmit from dsa_skb_cb
  net: dsa: Create a kernel thread for each port's deferred xmit work

 include/net/dsa.h |  4 ++--
 net/dsa/slave.c   | 53 ++++++++++++++++++++++++++++++++++-------------
 2 files changed, 41 insertions(+), 16 deletions(-)

-- 
2.17.1

