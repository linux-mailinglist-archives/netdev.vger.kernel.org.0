Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC57AF05A2
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 20:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390845AbfKETII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 14:08:08 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45582 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390464AbfKETIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 14:08:07 -0500
Received: by mail-wr1-f68.google.com with SMTP id q13so22788285wrs.12;
        Tue, 05 Nov 2019 11:08:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=eN+/J2VAj/ZhdorkIr8IGfao0JUAyJYq/zIB7eFLIq0=;
        b=hiSxzYAAPCtMPuNdlS0BMaop4zXZX5nnHfYGnYDPs3l0nvK99+7Fy/eDEPDFqz1KtJ
         uExS0gD+mgp6cDQ9Qv9EL8Ym8N1PS9uAK+FUOZJSnH65ZjbkuNFWceflCNnBX2bOtPvq
         scfogegrnSUkcXuWElzMHGgMS1nJpt0R3AIOQXyixP+74qBQu+8Bgapld7ED5+DCk69c
         W7mywM5FFQRPbCJUJq3qBiLTI0Lilh/7hfbvTf65T5YWM90ZMwBIKNXzj7uOTtwxG9Bw
         XVDYFFHYMc8mJs+6ZplljGr2CBq7zDw2daDqL6PeDy3sZVsRUOLWbJsX2JnWl5WrqlvV
         KzXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=eN+/J2VAj/ZhdorkIr8IGfao0JUAyJYq/zIB7eFLIq0=;
        b=eG2z5MBSEQxljLDm7BVrnHpbiQxEEfcd/S6lq13BmPhztwdh2xBFqposOftA46XCdJ
         lXjfkGCwyGtuSgD8t1v/1Bmamb1UUYQHREJ3t1rHgMZLlmRUS4ONBMJc8efa8c8shIkD
         8h/i60lfc/VleFn204SFRjq+rYv5M6kCLV9doIyr9oaLbHOQC2q8jKeC8JQo+5oKjsp7
         21rmD8JBV0uie+wf3zmTbriesWpRw187AhAVlXux3ec556HJjYr6Pi8rJf8KXx9AyvxT
         l4uLjG9gIuvgD90hCaGNKKl6Zaq/TpvMwCHPsGT9G5vA1CWkz3bqmy84ndB2tTXf1aub
         H4uw==
X-Gm-Message-State: APjAAAUdFYOPAmKnY5jocCbGyRD2IJ7DnjMsaQWOGQTVx8Kxlbqghhjn
        orPZcY/+B66f4r0/sBEhejY=
X-Google-Smtp-Source: APXvYqyQy3T8IaTlUyU+zzDCnH8Zq4xbCS3rYX0/ZDSmGA7/CcbqcyIpkKZOiACR7iVHeU+J1jXxlQ==
X-Received: by 2002:a5d:6412:: with SMTP id z18mr19117976wru.30.1572980885712;
        Tue, 05 Nov 2019 11:08:05 -0800 (PST)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d11sm25974703wrf.80.2019.11.05.11.08.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 05 Nov 2019 11:08:04 -0800 (PST)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net 0/3] net: bcmgenet: restore internal EPHY support (part 2)
Date:   Tue,  5 Nov 2019 11:07:23 -0800
Message-Id: <1572980846-37707-1-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a follow up to my previous submission (see [1]).

The first commit provides what is intended to be a complete solution
for the issues that can result from insufficient clocking of the MAC
during reset of its state machines. It should be backported to the
stable releases.

It is intended to replace the partial solution of commit 1f515486275a 
("net: bcmgenet: soft reset 40nm EPHYs before MAC init") which is
reverted by the second commit of this series and should not be back-
ported as noted in [2].

The third commit corrects a timing hazard with a polled PHY that can
occur when the MAC resumes and also when a v3 internal EPHY is reset
by the change in commit 25382b991d25 ("net: bcmgenet: reset 40nm EPHY 
on energy detect"). It is expected that commit 25382b991d25 be back-
ported to stable first before backporting this commit.

[1] https://lkml.org/lkml/2019/10/16/1706
[2] https://lkml.org/lkml/2019/10/31/749

Doug Berger (3):
  net: bcmgenet: use RGMII loopback for MAC reset
  Revert "net: bcmgenet: soft reset 40nm EPHYs before MAC init"
  net: bcmgenet: reapply manual settings to the PHY

 drivers/net/ethernet/broadcom/genet/bcmgenet.c |  35 +++---
 drivers/net/ethernet/broadcom/genet/bcmgenet.h |   2 +-
 drivers/net/ethernet/broadcom/genet/bcmmii.c   | 145 ++++++++++++++++---------
 3 files changed, 110 insertions(+), 72 deletions(-)

-- 
2.7.4
