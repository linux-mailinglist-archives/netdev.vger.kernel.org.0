Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E103CE79A
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 19:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350146AbhGSQ3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 12:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241470AbhGSQ1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 12:27:05 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD58C07882A;
        Mon, 19 Jul 2021 09:31:50 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id l6so10795188wmq.0;
        Mon, 19 Jul 2021 09:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hvVPJjlBWYw4kVSHvpSZZLNRhOEU+S0xEKG5MEzufL8=;
        b=BhWmKJjOT7/fxHQDBZz6EomALoJpz2KlmbywxK7xU8l+F0tTxszXo6nSeGawOzZyQ9
         fSIJll4DVLfYF6Q4KXIfalDsohlxQ7xrQtMQop6HIRtZYvrPdv7LxIgVVIXXzgPDoz8I
         7PwLpegveYV7QKnf1sHw0S7w0SpWOlv6NYiUU+PXoDJXEtZVSoCExF1PBXVWpwW82PNW
         CcZO1RGFuBZrMFBzwTqjrj5oydZrcmZ51pDJ9buK5LzI2rwiwDpAyPehbjaSxtaIrJFi
         uVUSDegRiFVKTrSjq2flKC3r0vrh9acfRaGsWA3gKlVb2V+UTJNOzpbnIwqqCOHHlgiq
         /A0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hvVPJjlBWYw4kVSHvpSZZLNRhOEU+S0xEKG5MEzufL8=;
        b=G505yT+Ery8VHH9YweM+Oe4Ed4DkpekqcHm5jIqg5Wnj0k2v2YrIyLICK898fcH2uB
         gqZzYHDzFnweJRMDIi3owNYoG1M2TZqDwgza3/wLCENJOsD7MOTTtebY92umpACGcp0K
         DV9oZ9SvyfhKlVWOPmwcdHqReAnWn94z2o1og3WRxlJS3X1Zv8H/zSLs9GgszIqqFQeZ
         lnNlpxYyKkfLzKj/ZISqZ9Y9EGJQtm3blMXpTyQNx62yZCJ3CI5goL6O0vvgjLbTaDrU
         A0K9hq0Z/8JP8e69oOWQEslFXOSC2wKQCXr99YxIhuJMWWpFzfvdC/dXt6TZ1t7qlkrC
         c9uw==
X-Gm-Message-State: AOAM530uFEREYZAzZBn5Ec576WyZJ9qMadpQBC2QBTnqQmDnrf4EiXkM
        MiYcG8IRm5R4SmRUcSwirDxiS/qwWyOUrg==
X-Google-Smtp-Source: ABdhPJwFpUHp7eqiFo7tdnAmsitGxxkf93HHf97AM2b3/wHUX0mvgsjGbb+oBigK/ACsTmNiIN3Ztw==
X-Received: by 2002:a1c:4c18:: with SMTP id z24mr33711432wmf.168.1626713605786;
        Mon, 19 Jul 2021 09:53:25 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id p11sm20562149wro.78.2021.07.19.09.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 09:53:25 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        timo.voelker@fh-muenster.de
Subject: [PATCH net 0/2] sctp: improve the pmtu probe in Search Complete state
Date:   Mon, 19 Jul 2021 12:53:21 -0400
Message-Id: <cover.1626713549.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Timo recently suggested to use the loss of (data) packets as
indication to send pmtu probe for Search Complete state, which
should also be implied by RFC8899. This patchset is to change
the current one that is doing probe with current pmtu all the
time.

Xin Long (2):
  sctp: improve the code for pmtu probe send and recv update
  sctp: send pmtu probe only if packet loss in Search Complete state

 include/net/sctp/structs.h |  5 +++--
 net/sctp/sm_statefuns.c    | 15 ++++++-------
 net/sctp/transport.c       | 45 +++++++++++++++++++++++---------------
 3 files changed, 37 insertions(+), 28 deletions(-)

-- 
2.27.0

