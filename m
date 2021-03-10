Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64CC73347E3
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233431AbhCJT12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:27:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbhCJT1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 14:27:00 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20F8C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 11:27:00 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id x29so12056255pgk.6
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 11:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=3tmk+YgvIyaJQP9a5sVKGWw7RDa+KZJJAi5fbTIqxtw=;
        b=cC9hZIfbuqpV/XPpPnp3MMCwkUB8JpvLoeKcPmOvJApDFNAL27gqARyyhjG1FkouR1
         YNqeK2u0C5XvxMAWNC9ToQ2osDsTygivUa1YwafoAP6re5IWfcIhaq9gKrxhM7ESUaYx
         dCJYQPCsdmICIvNMi8/DjmCWrxY0JNjmSP9zaBXFWxhFGKKFYEfZr3gBfDiyoNSNb43Y
         2inc0XY9nXCIxWNLvbYmyks2vteTQ81B5+ixVGG0EdafT5NHgL07Hl6o8jJPbhpFblKU
         lIJnzvyKgFK9Z+MKPjxzcp867ePGhXJeuZJ1UmUD7dwQ43jL/PDGHFJ0KtIJLByMv38g
         D+aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3tmk+YgvIyaJQP9a5sVKGWw7RDa+KZJJAi5fbTIqxtw=;
        b=tSP2ltQDIdy6hNCPIb6NqFuj90vqmvU0mjjjhD1OZonW/pnssCt0HpYGreNclcNJVA
         GsSq1o+82k3vVDZqowNN7jDr5z/W8RhvqISB0y9whendAyJj4CCOPsWl+gRi1z8OcALr
         fos9DlBW07WUTU6WxPqLdIThFWwpo2CxMbNF6Q9S3g2geqoWZhSHDZIZiELCphzYEATQ
         xcMyDRp9jmsSmQKY7wquwjJCZJq6DoQMpfE9dUPCmnELtoxVEJqd1Xh+mpwvWjx1l6dy
         X7G+NbNBToX7hHoMOWYSUShpbZzjQYbJr7njouY0CcfVFLm+F85C8DaAHdyAWgv8EvOf
         fXiA==
X-Gm-Message-State: AOAM533pVeUDEuQQe/Mx4Ce+6uEMf92CKEnaf/AnjNi5EadmuE8tCLl8
        exULMlDuIO5jvgM7t/p0DoZQ4Jh0zcQQLQ==
X-Google-Smtp-Source: ABdhPJxjmhFW7WRIKNyCPtmR++QmGDcPwIUFgTRbKt7/JhQGx4aUEv08kdCoVcNeUgnHjVgjwUUmsg==
X-Received: by 2002:a05:6a00:1507:b029:1e4:d81:5586 with SMTP id q7-20020a056a001507b02901e40d815586mr4244665pfu.53.1615404420170;
        Wed, 10 Mar 2021 11:27:00 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 12sm306393pgw.18.2021.03.10.11.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 11:26:59 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 0/6] ionic Rx updates
Date:   Wed, 10 Mar 2021 11:26:25 -0800
Message-Id: <20210310192631.20022-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ionic driver's Rx path is due for an overhaul in order to
better use memory buffers and to clean up the data structures.

The first two patches convert the driver to using page sharing
between buffers so as to lessen the  page alloc and free overhead.

The remaining patches clean up the structs and fastpath code for
better efficency.

Shannon Nelson (6):
  ionic: move rx_page_alloc and free
  ionic: implement Rx page reuse
  ionic: optimize fastpath struct usage
  ionic: simplify rx skb alloc
  ionic: rebuild debugfs on qcq swap
  ionic: simplify use of completion types

 .../net/ethernet/pensando/ionic/ionic_dev.c   |   4 +-
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  19 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   |   6 +-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  22 +-
 .../net/ethernet/pensando/ionic/ionic_main.c  |   4 +-
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 374 +++++++++---------
 6 files changed, 226 insertions(+), 203 deletions(-)

-- 
2.17.1

