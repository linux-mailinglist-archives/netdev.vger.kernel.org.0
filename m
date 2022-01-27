Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2370A49EC41
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 21:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343651AbiA0UJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 15:09:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240073AbiA0UJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 15:09:42 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCCD6C06173B;
        Thu, 27 Jan 2022 12:09:42 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id f8so3243577pgf.8;
        Thu, 27 Jan 2022 12:09:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fT+b6INOFgJpXVBYjD5AMsoOSZs+vb7kY64VrdFYpaY=;
        b=TYtLS1/y6ThrmGYt1q1IzcYKPbR90vwqzWo+pM+CTK4Nlkk5Zb+znVPcMFtLvN9Svy
         7jp2M1VBbn+OvoCWCvDtVlAMqua2f6U7vQaxmoKol/Uyxsu1cp0r88GGF6/Mqgy5OxNY
         pop2BzP+THuOiqSr30uvlHShKmEaTh/iSxxa/vIck3XXMlxfnAHWV0G8dklk9Q2Jewx2
         6WXgRZloICnG2opaf1ZDuWuqmAyJiZnOx4MU3rjbvfR4rISCMCXqXhuJCeMyDr8tAKDy
         V6CZ3Dm+jxoJwoRi3iAn6fOWps12OZ3QNYRe6qDkynnImWbUyvmb2NhJJRNgOHWUZCgf
         Gblg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fT+b6INOFgJpXVBYjD5AMsoOSZs+vb7kY64VrdFYpaY=;
        b=2Gr/s7IpkX6FJ2oE2XvsltYLG7cvK89u2IKsG45z+ZqpTATFVb/8rKA0fzZqFkhQbh
         MfaqAXTF74XPIbkBjUFnUonKzOIUA55xA4XA1QY+SdQM7sFam/9+ESrDCsheqw+l0wye
         oDkbqDwqevtcAXJmFiMAJaYwIgHibLXde/d7TzDrBKQjwos4VwtJFdaNZBDsMvaS8yXL
         NZBB808nHb9upaLlH0UNWhM/m367PEn/RhlNn4tT2xoGCDzZufHqJrBsgxfwqnjQoJXV
         6zPggIKBeWIhjAXH4NB5vbwbXkxGzuCN7KCs14xTJbnxA3yQzbJ1ZgZqrfQyh52RgOkX
         FBbg==
X-Gm-Message-State: AOAM5310a0kLbqKjwqRRRhfZhl4kp+7b9PApiLZFrTJAW8grcJmN0wOV
        o06y+b2IW4EkKr04LxP3f9E=
X-Google-Smtp-Source: ABdhPJysb9sobuVpahnTZixlk0tt6y/UUUPKWfb7qZyU5UTWjtc1x1+4Ubet5CgeWKi1okgrhJ2C/g==
X-Received: by 2002:aa7:88c9:: with SMTP id k9mr4446913pff.58.1643314182421;
        Thu, 27 Jan 2022 12:09:42 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:ab5e:9016:8c9e:ba75])
        by smtp.gmail.com with ESMTPSA id y42sm5697892pfw.157.2022.01.27.12.09.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 12:09:42 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        linux-nfs <linux-nfs@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 0/3] SUNRPC: add some netns refcount trackers
Date:   Thu, 27 Jan 2022 12:09:34 -0800
Message-Id: <20220127200937.2157402-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Effort started in linux-5.17

Our goal is to replace get_net()/put_net() pairs with
get_net_track()/put_net_track() to get instant notifications
of imbalance bugs in the future.

Patches were split from a bigger series sent one month ago.

Eric Dumazet (3):
  SUNRPC: add netns refcount tracker to struct svc_xprt
  SUNRPC: add netns refcount tracker to struct gss_auth
  SUNRPC: add netns refcount tracker to struct rpc_xprt

 include/linux/sunrpc/svc_xprt.h |  1 +
 include/linux/sunrpc/xprt.h     |  1 +
 net/sunrpc/auth_gss/auth_gss.c  | 10 ++++++----
 net/sunrpc/svc_xprt.c           |  4 ++--
 net/sunrpc/xprt.c               |  4 ++--
 5 files changed, 12 insertions(+), 8 deletions(-)

-- 
2.35.0.rc0.227.g00780c9af4-goog

