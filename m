Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B921E6C2BA
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 23:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbfGQVmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 17:42:25 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37217 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727205AbfGQVmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 17:42:25 -0400
Received: by mail-pg1-f195.google.com with SMTP id i70so1040979pgd.4
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 14:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1Z+2ruFMzkI/j50o6IHuToonOxYGbJg8L9AL6dv/THo=;
        b=YcmxJc1s1hOEkVOCgjHFTyCMBF8aYVcS88Rdacb74hiV9MUk0L1nhvgosnt3k8ptEt
         dOv51G5+hpH5h7/l8fUFr2+YbIZ8Q04InJKnkvRHrN+Ya2EfpzjD+GdXGnwgqBnC9w0v
         a5vWA+wUAyGZRw33NYwzIzuPCYkokzS7tuSxHrEGOw+AH6ZtOgmuF80y3geVfya8ioYJ
         WmNpA9DR2kS9cz5F5vNoQThiwH1vbr6+pFnO6XHeNGsq539B8Mj+p9tQYDtSzr6CGRQD
         iPFGlcKmZiyfrVFPr3q/LBP4XP1+Mjz/iBb7143v5gnX0X5rXyKgxrDwd69hFknS7Z43
         vuhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1Z+2ruFMzkI/j50o6IHuToonOxYGbJg8L9AL6dv/THo=;
        b=BU8ZCgJUHESTrvgvQFRXqKVp0pwtfZY36gshRd7uJZUXfE2Wxq5t5WJmUL79PS8PCS
         8wtLjn2WH5bZdZabVlfbfABne8W/MKfdhXSdvLjZDrBdfZrOWJsNkMSrXQqpBrlrf3w2
         5QTGUJu+7NdRZQ7Z8CDu6O24qieKdgVVTV3Q+A1+uYY82Qu3rkmIDO0wvB4Di9aX+Sn4
         LmImxUakz9dZZKPzFzCiZva0jTUxdzpN4nkxcw3v8BR1oA9PMSXtRArspzoY+UJkHdyx
         U+zVH88g4uYyg9B2bWaUZetFzUvmUl53DkihByp+83IRwMwnrwAIEpbfXA5jMAa13lz7
         sp1Q==
X-Gm-Message-State: APjAAAXIkZx3zs4NsjTNpT32/nU2C36n0UlIyN1f7fsvjuq1bk1hUJ2p
        w4vkoty7ih+TiLET0KV0YpzWvSwlIwk=
X-Google-Smtp-Source: APXvYqzt33xjLv49OoYDGfRatZRVVpplVYrGwgTj/2jsurQkXLnoXX736PSOWTozAYpQ5schRRdSPQ==
X-Received: by 2002:a63:7358:: with SMTP id d24mr43551016pgn.224.1563399744047;
        Wed, 17 Jul 2019 14:42:24 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id 23sm27476615pfn.176.2019.07.17.14.42.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 17 Jul 2019 14:42:23 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, Cong Wang <xiyou.wangcong@gmail.com>
Subject: [Patch net v3 0/2] ipv4: relax source validation check for loopback packets
Date:   Wed, 17 Jul 2019 14:41:57 -0700
Message-Id: <20190717214159.25959-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset fixes a corner case when loopback packets get dropped
by rp_filter when we route them from veth to lo. Patch 1 is the fix
and patch 2 provides a simplified test case for this scenario.

Cong Wang (2):
  fib: relax source validation check for loopback packets
  selftests: add a test case for rp_filter

---
v3: use dummy1 instead of dummy0 in the test case
v2: remove a redundant if check and add a test case

 net/ipv4/fib_frontend.c                  |  5 ++++
 tools/testing/selftests/net/fib_tests.sh | 35 +++++++++++++++++++++++-
 2 files changed, 39 insertions(+), 1 deletion(-)

-- 
2.21.0

