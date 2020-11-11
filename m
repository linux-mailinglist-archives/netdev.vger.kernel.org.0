Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3862AF1C2
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 14:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgKKNMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 08:12:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgKKNMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 08:12:39 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A206DC0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 05:12:38 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id y16so2036762ljk.1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 05:12:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:organization;
        bh=zXv7rygQRyAccp6y4zKGUt5FHkwVAMuBvku22YaRFOA=;
        b=GMJJe6okqikE9Sa3gsx3QyiZ4u5TkdhAzw9zi+qTYosQsoDoSCqt9IuDjgf62NLiaP
         v5fbQ6UWzJbwSP8xvfjiwpWf41C7d/5vLBkHeCgVz1o+2/PCDmtPi2T+eDfBaG8twS+D
         /dC7o7RyIrH6HE8ErcT9NaS9JJIkOk7GQuCCnHEyytv2DfiWPrN4hZ3dH8Y6Kq5szezF
         Y5qJ7Jh/2AIG/UhjNt5EWtKb4hZnJcsdyIQsEpincr+gldz7rcnAj3W1ggwZBpG+GD9+
         Y28b1m2QiUsfB5JevCJFcBbO7OmruVRWCv+sNbY2X7eoTBrQEZX6DDtfa0EAjVsf3qOy
         Ca9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:organization;
        bh=zXv7rygQRyAccp6y4zKGUt5FHkwVAMuBvku22YaRFOA=;
        b=HepBlGRTf9Bnt/nnKQuROjd+WdznLyelBXSIOS12wnWh1OZ+0h8qo5v1GE6qit5xIz
         GGHy2j9zKDVrV64NgIBQoDGLk/VpH09WAaqEhg75BXzhQA++9CvAHWuGguPMqxLon/W3
         E1nhPaUQhnt0wJ33tNhc/vsKuLl9/5BB/k7Vl9OaXbvrTFlom2gxFjF/QnjFex6F7Xwy
         p/9eijavq4VbE98ov31agwmLhb2jbEpbRlkh+shHrWPYm859P9H82Xgzrf46RHJy+RtU
         4ByFOoTcpQAKFEoOQkVxDzmyzJyRrD+acwkUzOUYADZYR9cxarUXo0Wyw+i8mrBQfwHF
         MQZQ==
X-Gm-Message-State: AOAM530ccdQ2d//Wm6LO8cXblZea1xQVepP0kvQ9anWpJtSJHkny/SFs
        56YSaX1vE5PLJwVBpYKTrlcIzQ==
X-Google-Smtp-Source: ABdhPJx2C6U5tfw+r+/eWXiDMoIVxiR4tX9Jx+miDNQXjl2HiiUMlormheoLbG3e0EnU8D02CB3qBQ==
X-Received: by 2002:a2e:8346:: with SMTP id l6mr9560698ljh.132.1605100357096;
        Wed, 11 Nov 2020 05:12:37 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id w22sm231108ljm.20.2020.11.11.05.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 05:12:36 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 0/2] net: dsa: tag_dsa: Unify regular and ethertype DSA taggers
Date:   Wed, 11 Nov 2020 14:11:51 +0100
Message-Id: <20201111131153.3816-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first commit does the heavy lifting of actually fusing tag_dsa.c
and tag_edsa.c. Second commit just follows up with some clean up of
existing comments.

v1 -> v2:
  - Fixed some grammar and whitespace errors.
  - Removed unnecessary default value in Kconfig.
  - Removed unnecessary #ifdef.
  - Split out comment fixes from functional changes.
  - Fully document enum dsa_code.

Tobias Waldekranz (2):
  net: dsa: tag_dsa: Unify regular and ethertype DSA taggers
  net: dsa: tag_dsa: Use a consistent comment style

 net/dsa/Kconfig    |   5 +
 net/dsa/Makefile   |   3 +-
 net/dsa/tag_dsa.c  | 315 ++++++++++++++++++++++++++++++++++++---------
 net/dsa/tag_edsa.c | 202 -----------------------------
 4 files changed, 257 insertions(+), 268 deletions(-)
 delete mode 100644 net/dsa/tag_edsa.c

-- 
2.17.1

