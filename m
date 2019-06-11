Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E55004171A
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 23:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407701AbfFKVsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 17:48:11 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:47017 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407700AbfFKVsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 17:48:11 -0400
Received: by mail-qt1-f195.google.com with SMTP id h21so16420583qtn.13;
        Tue, 11 Jun 2019 14:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MCUxZBwXukN132TnqZmMCNqv44FmiO2Qpout6SxwNOk=;
        b=U2t4J6JufLPs9LVQEuwGoIlft6Vut7WVTUtKXOa8XJY+r1QFdmI0+nJgzFB+1wyjKh
         FMjaww5fpbkwLLDGEgKc4a/Fl0qhuZykErQ7aS5PJMHKkb8Y1Baf1ziVwUgiNG9SfxWi
         KZkJAiiFX9t9hR48Ma1rOrXUm2jbLmrvB54B/FuUAIres2ehrkBe2YR4reZiFjLhzsl6
         W0rnBYqhA06eRixvTcFyKz8KdwWRcUKWIpSZTJDhr2Rr9rMOwekUr4qiWQlL002I2ohH
         urqBKcblPu74HjYd3SS8xEDiHTW1fpJAqLCeqVbU/BwKIsfsxZspgdIhme06UaE9kOPO
         5fJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MCUxZBwXukN132TnqZmMCNqv44FmiO2Qpout6SxwNOk=;
        b=WUFBCWBJwUCxGpXND9lD9yeVo3m6+pkse8KlVUEpKL0CXzJ6GVEB0MYgdmh82d74hq
         osLwQ7g5EnMDPbOkteeUjHBCgZsWjvdN7W8lwMSi5ti0jWiKfTokNPAt4di/Q2xLCWSe
         6sS6vxheq6+MzQxsu56g4kn6PdqedJEiOeu376w+/r5jWgruETNBMiBrlvYHVEgGeH7g
         pOrzHNL/HaG8elc2s8wwab9DgoaADvyyFqogMuFcBQjvCik74rRPOR54eY7JvWctJ5Gq
         6/UuI0Fu5alJkKJWYdY889AOszUi61mVxWNI+6XNURQ4n/DNBb26SQrNWOyWA2wiNDDR
         08UQ==
X-Gm-Message-State: APjAAAUwkHtRMqbOXgaLF2C4VEphmMQfYGOb2QZAoTaKWZF5E0QeBf6Y
        VDvznGUPr6hJlE0cYQoddQxtJNB3ly0=
X-Google-Smtp-Source: APXvYqyfvR3qwy2LUpLrVFiimG3IolAimo2/QWdlN6oInYZgQEWvFcI6wyMUURihw8/hLQkYaXvvLw==
X-Received: by 2002:ac8:17c1:: with SMTP id r1mr65120547qtk.41.1560289689721;
        Tue, 11 Jun 2019 14:48:09 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id l6sm1438451qkc.89.2019.06.11.14.48.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 14:48:08 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, f.fainelli@gmail.com,
        andrew@lunn.ch
Subject: [PATCH net-next 0/4] net: dsa: use switchdev attr and obj handlers
Date:   Tue, 11 Jun 2019 17:47:43 -0400
Message-Id: <20190611214747.22285-1-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series reduces boilerplate in the handling of switchdev attribute and
object operations by using the switchdev_handle_* helpers, which check the
targeted devices and recurse into their lower devices.

This also brings back the ability to inspect operations targeting the bridge
device itself (where .orig_dev is the bridge device and .dev is the slave),
even though that is of no use yet and skipped by this series.

Vivien Didelot (4):
  net: dsa: do not check orig_dev in vlan del
  net: dsa: make cpu_dp non const
  net: dsa: make dsa_slave_dev_check use const
  net: dsa: use switchdev handle helpers

 include/net/dsa.h |  2 +-
 net/dsa/port.c    |  9 ------
 net/dsa/slave.c   | 81 ++++++++++++++++++++---------------------------
 3 files changed, 36 insertions(+), 56 deletions(-)

-- 
2.21.0

