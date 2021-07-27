Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5533D78AD
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 16:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236815AbhG0OnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 10:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232432AbhG0OnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 10:43:13 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7D6C061757
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 07:43:13 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id v71-20020a252f4a0000b029055b51419c7dso18636108ybv.23
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 07:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=akmn1moatSSWXnKPjJGq9XvkfJYWhkAxIYPXL8q8Zg8=;
        b=UyCfFQygH491bdBZeAFUhr2B+ChTGYZTgAuQR3oCa4aqw3ECope84WDhrqnnX4yiyz
         iBr7f0coKd3vl/8YhgdkZgqW4WMUAq6K4fariGrGGOfJK2c1JQuBPOeIFq7q2yTiAbf1
         NDNCf73DNT5nyJD0WZ8chKybzGpMIX7a9czqudqm2toMXRj9dfyPp7rCWh/qaRQqTIaS
         IMp2Pt1eudt6S+S1+mZXBavW5kvE7EWJNJHcahQ9rPfr7d0nls0rHTLcTOqjt3EQPHVB
         MOtj8MM2A7VW/XF3mNmSzxRrdz0oRd1HTVQyrmltS9+M8QU9HpJKv+TOg5EQhgD42jU1
         qpvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=akmn1moatSSWXnKPjJGq9XvkfJYWhkAxIYPXL8q8Zg8=;
        b=XeCjiGeL3XVlRcaoZRz2L0L3XXr/yQINBHCcA56GZdej+xEkcZmQoc1HuPdlc6yHxX
         3fUVw6FeC2H6io6voUKtkipGQxu+E15pcTZ7b3DqXYf/99dDoFZrWbaqS/zsP8McQSFh
         VcWJdf4bKwJRRZIKc2Ge31GrAp9KBqGG/nZBkVecfal9HhIcPBJEybBnlYH34kXVhZAC
         rZWGBYNcSmyGlcIg7FrFjmV5oEGvlFkP4KXC0cks5EXfnmgOTq+ytXCqPuq8svKZC/As
         30Og3yJ1m7fp3N6HnLykh6xZa0eAG512sOeEUpUyPASNqKkM5bBNDCYLsFqRwoCP23NB
         bUuA==
X-Gm-Message-State: AOAM531KvMJKXS2ACVJ46rTiGBUfxA/7JKTlUccnX4JUW0Nq91Y64jPH
        dFdMBw7ScmJdF47GhEJ35VXPCb+sKkYyXfU=
X-Google-Smtp-Source: ABdhPJw3tXhltPij11hN6WyxN5q7SLqmZUOfeVMbihGMfdJG6ZFkjUyXs14Gn0xiByYuwgMxt+/7ZOMaE6j9N+U=
X-Received: from soy.nyc.corp.google.com ([2620:0:1003:312:17c3:cd0f:c07d:756a])
 (user=ncardwell job=sendgmr) by 2002:a25:8b0e:: with SMTP id
 i14mr30233316ybl.178.1627396991361; Tue, 27 Jul 2021 07:43:11 -0700 (PDT)
Date:   Tue, 27 Jul 2021 10:42:56 -0400
Message-Id: <20210727144258.946533-1-ncardwell@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH net-next 0/2] more accurate DSACK processing for RACK-TLP
From:   Neal Cardwell <ncardwell@google.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series includes two minor improvements to tighten up the accuracy of
the processing of incoming DSACK information, so that RACK-TLP behavior is
faster and more precise: first, to ensure we detect packet loss in some extra
corner cases; and second, to avoid growing the RACK reordering window (and
delaying fast recovery) in cases where it seems clear we don't need to.

Neal Cardwell (1):
  tcp: more accurately check DSACKs to grow RACK reordering window

Yuchung Cheng (1):
  tcp: more accurately detect spurious TLP probes

 net/ipv4/tcp_input.c    | 14 ++++++++++++--
 net/ipv4/tcp_recovery.c |  3 ++-
 2 files changed, 14 insertions(+), 3 deletions(-)

-- 
2.32.0.432.gabb21c7263-goog

