Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54437209DEA
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 13:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404641AbgFYLzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 07:55:13 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38827 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404621AbgFYLzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 07:55:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593086111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=FrhYzHLW7BVQFkvK7yiMz5rnJnbaI4pxVM6OhAm1FIw=;
        b=bBF/5aUn09rERubYnv0kx2jRm4sCPYqSH6AsszuQ0VoZUI5eINgbo1blNVIyeIG1BILjno
        lWXrF99WE0gVduWXeLei9DFD23zOtDqeKQHrWT9ysQ2Wo29ZYuDL1qeVldlIaE8Wajqkp1
        razKo7Rc3pcS3nmqEVbS/n4HPchfb8o=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-ecymRw8oN9iYIShmXldmFg-1; Thu, 25 Jun 2020 07:55:09 -0400
X-MC-Unique: ecymRw8oN9iYIShmXldmFg-1
Received: by mail-wm1-f72.google.com with SMTP id b13so4652171wme.9
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 04:55:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=FrhYzHLW7BVQFkvK7yiMz5rnJnbaI4pxVM6OhAm1FIw=;
        b=aH6y8dAo8BnRO+f0iU577ak5jdPkRIe/J9hYPyQbOOyoi1581CfQpNZ3S69ndNUQrO
         QtSwx0C9Jy5HaH+eDxavXb9IUvMH0HEM/uDnMb7vWOa9JymiwLe/7ZxWQzxBUbROT3EE
         rXTdIG0W+8iUaXbryRzmn5cVg2KMWmc7Xt3YK5EGvbyCI/fA/YD3fT6CrZIgCW4C+JHy
         lOmFSLsvddNh83tS1sifgtlD+nZOsw240QDKQyup5E0cvEWQNsJERZjPAy2UUnO+lrgj
         ES/IsuvWyA559JFTeKKUA1+uB11FbcOoLW3Van1BeJlR3HwvDsDI0M2GLtwuz12XYhHp
         SsCA==
X-Gm-Message-State: AOAM531LBuAHEda5gBgOkM/XQdoIJOEnYahiq8XlYV8iSO/8auus0FKY
        RIj8QqeWSWvRSGc8VWNFvZkpyzaDoW4zED7rvhuSA+vxSs/G1/ChCVfbvvI0mL4lh43KUPBOczw
        9+uj9on1Sf9PgH8uO
X-Received: by 2002:a1c:a512:: with SMTP id o18mr2957477wme.101.1593086107906;
        Thu, 25 Jun 2020 04:55:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzghTwCojJWr3fMyWpX7kfDT3VpN5vDKr5bfXVlyuC67AIo1/1PaZuCytx1yQTaYI+YKNmIyA==
X-Received: by 2002:a1c:a512:: with SMTP id o18mr2957454wme.101.1593086107643;
        Thu, 25 Jun 2020 04:55:07 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id u65sm12700916wmg.5.2020.06.25.04.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 04:55:06 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DADD71814F9; Thu, 25 Jun 2020 13:55:02 +0200 (CEST)
Subject: [PATCH net-next 0/5] sched: A series of fixes and optimisations for
 sch_cake
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, cake@lists.bufferbloat.net
Date:   Thu, 25 Jun 2020 13:55:02 +0200
Message-ID: <159308610282.190211.9431406149182757758.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave

This series contains a number of fixes and optimisations for sch_cake that we've
accumulated in the out-of-tree version. See the individual patch descriptions
for more details.

The first three patches in the series are candidates for inclusion into stable.

-Toke

---

Ilya Ponetayev (2):
      sch_cake: fix IP protocol handling in the presence of VLAN tags
      sch_cake: don't try to reallocate or unshare skb unconditionally

Kevin Darbyshire-Bryant (1):
      sch_cake: add RFC 8622 LE PHB support to CAKE diffserv handling

Toke Høiland-Jørgensen (2):
      sch_cake: don't call diffserv parsing code when it is not needed
      sch_cake: fix a few style nits


 net/sched/sch_cake.c | 66 ++++++++++++++++++++++++++++++--------------
 1 file changed, 45 insertions(+), 21 deletions(-)

