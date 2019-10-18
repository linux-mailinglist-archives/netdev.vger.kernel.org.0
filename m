Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C12DFDCACA
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 18:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394728AbfJRQRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 12:17:15 -0400
Received: from mail-lf1-f45.google.com ([209.85.167.45]:35875 "EHLO
        mail-lf1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727429AbfJRQRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 12:17:15 -0400
Received: by mail-lf1-f45.google.com with SMTP id u16so5158938lfq.3
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 09:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KIE4FFulbQH8HijkO8A+TSg7g677+NOAe1aOrGPT+CI=;
        b=M0Xjq3i21/aNQR1IDiBZLDq83N5lkflcxFJ30XqWLfB866OaAIRgasVJS2b3edRHPm
         kkhl++cff/WVRtjIDkHeVA5fIkMw3SqAoDTiduAvO+Z/ahhMIzuHqrxD6Pz8rweuFVqz
         yoDOs+5vRO7kQz6uMQIPevBnK1BpyE+sh4AtFXa253LYKyHM5RIp8yD+pPN5RLdUFF7k
         /qSh7qcCiUctXEAqT2jruI4gXYfyJViV3fiIVbdiJFaLsQNlzqMHUE6iRXKsNsQdfXoD
         BdraGJ9d2xysFBf7s1GcTbNcEqxTNPrk8iXOrrA1bZT4dk48CorYnQNo5WPmj+jcYJ2o
         HxaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KIE4FFulbQH8HijkO8A+TSg7g677+NOAe1aOrGPT+CI=;
        b=ixQuYmMVrOXhAW9nr4kHnjJurM3khN+ajHZU/7sD53R9Xcef/O/hyC1LXHOUCNt8xQ
         mVwUI2raYdLXWgA8nqREM7p5d9ssZljvyrw2JtaWvFAbPLN807hb8HgzRLDQU0l+lfD7
         XO8vmMIqjU7q49DR0Oy967rqDdF2EL1kQJCgyo+Wolwc+vQxpvep7OW321Hm9q14Tz2j
         koL3ZM2CT0Cb1I10T6CxdgwUlElg5cGzGJ7t6Vocab9XuQUCrJkqQbFAUePp7+SyEHy1
         u4MkRZfq7Vxv84PNZfhe3DHZa4NdGcFg77ACb2z/t5uUpQ/TH2o9MrKxFHMwJO6x9Rn/
         G3yQ==
X-Gm-Message-State: APjAAAUR1/0uSUfWvxPNO1nxb1GqGaz72X1C9Uhv7V4KHm8qfP9Qhobt
        R/jGvdZREJ7KU3VkCZ3KA+0hzg==
X-Google-Smtp-Source: APXvYqwwCzh6QPZn5naxY2AqCoqRkdhVu2MDysatslykFZ3Bd0Cob2xNSnaQcrHvPZfbJ+IZOdPzdw==
X-Received: by 2002:a19:f50c:: with SMTP id j12mr6814885lfb.101.1571415432817;
        Fri, 18 Oct 2019 09:17:12 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r75sm1086365lff.93.2019.10.18.09.17.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Oct 2019 09:17:12 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        stephen@networkplumber.org, xiyou.wangcong@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net v2 0/2] net: netem: fix further issues with packet corruption
Date:   Fri, 18 Oct 2019 09:16:56 -0700
Message-Id: <20191018161658.26481-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This set is fixing two more issues with the netem packet corruption.

First patch (which was previously posted) avoids NULL pointer dereference
if the first frame gets freed due to allocation or checksum failure.
v2 improves the clarity of the code a little as requested by Cong.

Second patch ensures we don't return SUCCESS if the frame was in fact
dropped. Thanks to this commit message for patch 1 no longer needs the
"this will still break with a single-frame failure" disclaimer.

Jakub Kicinski (2):
  net: netem: fix error path for corrupted GSO frames
  net: netem: correct the parent's backlog when corrupted packet was
    dropped

 net/sched/sch_netem.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

-- 
2.23.0

