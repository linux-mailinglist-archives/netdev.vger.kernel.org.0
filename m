Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 199F91250C9
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 19:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfLRSiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 13:38:51 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:44270 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbfLRSiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 13:38:51 -0500
Received: by mail-qk1-f196.google.com with SMTP id w127so2394480qkb.11
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 10:38:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5ikSA7rFPIJeDtutbKifiGd6Srvvi6Dl1l6d0/w6wx8=;
        b=u2XzHlH0bmH5KqoA0lVktdjkYPC+AS77pvvHCgrIwzLlT2/nD2z5eAMAUN+96OC5JU
         imY4GG6icK/jbi05O7ZzblUoEf61mTxGUAjWCcTmqTuYAHVGDRrRRtdTK6gUbuP7ZAs+
         T9w0cjHBMi9EYiatII2vUrTCv1ZkOZA1NOxXjDgwcUHZX50LwgaZN/kt01x4Wm3YgLay
         GcFIasNiyyh1IqA2vNeDu92NEeS5P/CCDOCa8nHQ8K4IP5rSs/ql8q+tmvzp8++2NzNs
         3RHmBkn3CASSGmBOlKvgkOjTu8c8N0L/GQpWEfcO5piIioVQbKhb+fn/UnZG++DwQZwr
         lmlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5ikSA7rFPIJeDtutbKifiGd6Srvvi6Dl1l6d0/w6wx8=;
        b=g44BSxyhcVfEw4jfKma2eeLqTqFkvoUOt+rGx+nR+JUws+ZfOcoKOR1qeMAt+64eI5
         9UhBPcVPR9gZgH9rCYIk4uuT8UlqEJOpyxeVBFXABilTmJXz1ccZy7IJ0emtAofyynf7
         YrqCCfWaPCXcDJIK8j0GVhHbxJ3b8kILiZstXmGq9We4pf6oM6hamr3kwIbyNJgkNCqb
         EgOPfLZbzbSehvLYBdUJjYjO0ulcVL0tb+Kp4ZUHXpvx+IfpQzjB5tAfJBZDZcromMeC
         9FmP3T5GQ0botEClbQETI6u+qFIjWSCAF2LhT81ON/CKqOFTK3ZbNCqQxNIQ07wKTdH0
         MRsQ==
X-Gm-Message-State: APjAAAXm7Bi1LW+I7MiAiBdumTCWJsGXC73xdPDjFtR24wBZL0RPNd6o
        kg6QseKr6tEre2Bl7CxB7F2gc+2I
X-Google-Smtp-Source: APXvYqyXcsrrxtrLSbK3RK5SVzClhtnDNPE95KXA5fqSH/Yqy5wA3pNY3xmUgvDULJKYykUs8/t40Q==
X-Received: by 2002:a37:b601:: with SMTP id g1mr1221805qkf.114.1576694330272;
        Wed, 18 Dec 2019 10:38:50 -0800 (PST)
Received: from ubuntu.default (201-42-108-210.dsl.telesp.net.br. [201.42.108.210])
        by smtp.gmail.com with ESMTPSA id s11sm890049qkg.99.2019.12.18.10.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 10:38:49 -0800 (PST)
From:   Julio Faracco <jcfaracco@gmail.com>
To:     netdev@vger.kernel.org
Cc:     jeffrey.t.kirsher@intel.com, davem@davemloft.net,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next 0/2] drivers: net: intel: update i40e and ice to use txqueue parameter from tx_timeout.
Date:   Wed, 18 Dec 2019 15:38:43 -0300
Message-Id: <20191218183845.20038-1-jcfaracco@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The scope of function .ndo_tx_timeout is passing the hung queue now
using a parameter called `txqueue`. Some drivers are still using a loop
structure to identify what is the stopped queue inside that function
above. This is a redundant code. So, this series removes some unnecessary
code to make advantage of that new parameter. We don't need rework now.
For further details see: commit 0290bd291cc0 ("netdev: pass the stuck
queue to the timeout handler").

Julio Faracco (2):
  drivers: net: i40e: Removing hung_queue variable to use txqueue
    function parameter
  drivers: net: ice: Removing hung_queue variable to use txqueue
    function parameter

 drivers/net/ethernet/intel/i40e/i40e_main.c | 41 ++++++---------------
 drivers/net/ethernet/intel/ice/ice_main.c   | 41 ++++++---------------
 2 files changed, 22 insertions(+), 60 deletions(-)

-- 
2.17.1

