Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2860A267F61
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 13:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbgIMLw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 07:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbgIMLwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 07:52:01 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FEC4C061573
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 04:52:01 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id x18so3155351pll.6
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 04:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=vo05cM5GIcD4f9R7j3Azxfdeiw2MYdb3aZ80VMvJO+Q=;
        b=Pk1pfVPDEckGJjxYxgIWPCMYyrRfF2SPLNFEoLGbtvxkoYBdIuZjAcsnw0y7a3s1s4
         TkH8e/LKKzcY6fYmZhfoxBsOxrpo75vQ8KxoxwjiPlJQ+s3ESm9bTVUItyMOOg74tV0h
         b/2PN5cfBoxk+QRKGTP7/ZQ+bATczUrpKTZChfMeiER/SBAcp/e6gC+JSSrdXG53rljY
         0pLeLit5OEYC37ErNkQZVGI6ohDRrPCdJevnQPXyiLWY5O9gxxiC8nVT3y24TViUngGK
         zJuj0ujLKxdsLtXQwb7dUtE6alA6PWuNZ/ElgnqGRACbKVnM/q/ntnmUdGN4P+1OPlcu
         yuGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vo05cM5GIcD4f9R7j3Azxfdeiw2MYdb3aZ80VMvJO+Q=;
        b=EuBacZTch0pTwD7+n1hbFLb39hlkpvqNe5d5kp8IHrliX1bohyM/j73WxO9fNIpy0y
         CAqPgYdDFGngtqgY2FsvwCXRBptYDM7l3Ks67RAHu7ct0sBzO7bPKwPWOzyrGFeLDBHc
         AWoAb66amBLrElpi/tadbTTV48a9FZr1eaLUcVUZZqw8mcth1dpUogqLeRTR7CQPw6dA
         esKDmpxaNH0s53ZejjzBYyzwEwE8tC4Eu8ap3zDWSqUFOwaxxcXejrsm8GXlxNguyR0r
         kYyTphJO5aZSS3RLAc1dtzkMPsIKXhIFcLK118viB955LpssuMFK7vCYfVjS8UDKEI1E
         ccXg==
X-Gm-Message-State: AOAM531N6ykBGUPW0HI6UrQwzoSetaKh96VEHxVYpGDKmKiSJWQbmb0s
        FR0EB1Hutxm+bRyh8GEnkubnMjjEgt8=
X-Google-Smtp-Source: ABdhPJweZ3K69rjr6JPNOVd9GHOvuh/Ld8umSvY6CdEOEBK682fZg4bq+6nQeHtcZUYRfceVUkzO1w==
X-Received: by 2002:a17:90b:a44:: with SMTP id gw4mr9314397pjb.26.1599997919825;
        Sun, 13 Sep 2020 04:51:59 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y23sm7311382pfp.65.2020.09.13.04.51.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 13 Sep 2020 04:51:59 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH net 0/2] net: improve vxlan option process in net_sched and lwtunnel
Date:   Sun, 13 Sep 2020 19:51:49 +0800
Message-Id: <cover.1599997873.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to do some mask when setting vxlan option in net_sched
and lwtunnel, so that only available bits can be set on vxlan md gbp.

This would help when users don't know exactly vxlan's gbp bits, and
avoid some mismatch because of some unavailable bits set by users.

Xin Long (2):
  net: sched: only keep the available bits when setting vxlan md->gbp
  lwtunnel: only keep the available bits when setting vxlan md->gbp

 include/net/vxlan.h        | 3 +++
 net/ipv4/ip_tunnel_core.c  | 1 +
 net/sched/act_tunnel_key.c | 1 +
 net/sched/cls_flower.c     | 4 +++-
 4 files changed, 8 insertions(+), 1 deletion(-)

-- 
2.1.0

