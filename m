Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8AC6460E0
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 16:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbfFNOeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 10:34:10 -0400
Received: from mail-ed1-f48.google.com ([209.85.208.48]:36050 "EHLO
        mail-ed1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728208AbfFNOeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 10:34:10 -0400
Received: by mail-ed1-f48.google.com with SMTP id k21so3841137edq.3
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 07:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=F5uoCLl+kutJ88IJ0fDqbErIfNVWLByRHTp9VJP6FDM=;
        b=dnDKw/vbHoewc8jjnnxZtYwk/0uJBqmvZ6l88c5mm7yKwRdSDiTRlknOOx3RzzGj1n
         9c1r21ddOKfQo8iHbmlX3uuWHr90Y7mkzrMpLu9GCmERFggdSrF7frtCFvqN+jze+Iae
         rUVO4g6xZDQbm72O9Egaqo9XoRXp1N28n54eMFoqN2Ra1DtsG/LgOoZjsBq1djP9jg8A
         OIuUeW8KcI87+31JbBVrMHosFTlg2EAeebtPNHHLXmuM+/IQUJ/3cLO187PF6l+1fDe9
         1f+37Des+GBIkZBQm6N/jgG2not7oTzDuSvgFdOzYVCLxKHnVvEAo13Ob1bIbjLH4TKB
         lDZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=F5uoCLl+kutJ88IJ0fDqbErIfNVWLByRHTp9VJP6FDM=;
        b=bHwDuohR+abTp5FOehDagrPJ1EC3KvoZW3e8pDuWWEp8M/CUsa8AFCrbSmjSwI+tlX
         6wD0Y4A+NOju7jx4tORdG75u6ZfgphlNjWDyrXqJCWxLFjD6Qxw/udMovvBUdsDLNNUg
         3Kh045pqYSFrOi14obCguXMyIN9BVZ62mFhT7aU6AnSKTP5jat1hFTQ4VN2DUA+G/x4C
         rXSYujaFougGxzzpqENaXibvK+EHUjUgjmCWdS/EVRONPLd0FlI/yINoKGnJc5FurCk0
         FE2EKOCmhPPgVhvRTz+Qe+q4ey1xkyGy3agE+qJ3Ji9os60RmajbXF06Bgd8u+S7Pkyh
         KpRA==
X-Gm-Message-State: APjAAAXkla478d89zOg8go5NGyNDnFAPqME16B3QPQgV0Bgz6cQg36Fi
        cxKjoVhg76OH1BIEggQ1SJfxKNeId5s=
X-Google-Smtp-Source: APXvYqzTcL0zgBNscG9tel0IK5u6yQ/UoRBW14QfJ8VkiA5CwnwVmkHxKDewZCz8vnHX6ANZ0xOLQA==
X-Received: by 2002:a17:906:7848:: with SMTP id p8mr8160262ejm.83.1560522847942;
        Fri, 14 Jun 2019 07:34:07 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id r11sm350971ejr.57.2019.06.14.07.34.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 14 Jun 2019 07:34:07 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, fw@strlen.de, jhs@mojatatu.com,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [RFC net-next 0/2] Track recursive calls in TC act_mirred
Date:   Fri, 14 Jun 2019 15:33:49 +0100
Message-Id: <1560522831-23952-1-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches aim to prevent act_mirred causing stack overflow events from
recursively calling packet xmit or receive functions. Such events can
occur with poor TC configuration that causes packets to travel in loops
within the system.

Florian Westphal advises that a recursion crash and packets looping are
separate issues and should be treated as such. David Miller futher points
out that pcpu counters cannot track the precise skb context required to
detect loops. Hence these patches are not aimed at detecting packet loops,
rather, preventing stack flows arising from such loops.

John Hurley (2):
  net: sched: refactor reinsert action
  net: sched: protect against stack overflow in TC act_mirred

 include/net/pkt_cls.h     |  2 +-
 include/net/sch_generic.h |  2 +-
 net/core/dev.c            |  4 +---
 net/sched/act_mirred.c    | 17 ++++++++++++++++-
 4 files changed, 19 insertions(+), 6 deletions(-)

-- 
2.7.4

