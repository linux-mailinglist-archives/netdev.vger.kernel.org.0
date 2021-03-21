Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4F03432C7
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 14:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhCUNoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 09:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhCUNoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 09:44:21 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2420FC061574;
        Sun, 21 Mar 2021 06:44:21 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ha17so7005907pjb.2;
        Sun, 21 Mar 2021 06:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kzUMaQj//ijD7ke16OhicLJLUKJN9vZihXxuPydTGfA=;
        b=nO9Le5oXmtJlvjCkUCo+RMAc5cvr37KE2eXWhsqT9ojRNHYll3nkPo5Y3bGK3zU5JI
         fpjGy4KedaQSE9arn/4iaer9NGmLslWkiI7V+6M9BCdPiRE9e9o+vwtoeS4QdfTWjD+q
         7BXkWNLZycy7Jr5QhjcYa1tJA1ItfxsPr8sGBvN61jQzlbuXJUnpTFVbEnceeOMAHFHt
         FfWPBwkycjQLTs8pzaxdEBTWDDcoK3yaah0txN8VcLjqyQzEhgYckf5ylw1Zx+GOWzcY
         53HnvvWMVmYNaJuyDNd1df/jMu1KMTGhgXB7LltyKzEvK9H2A8Pa8n7EsjG7JYb2BqFI
         Fq8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kzUMaQj//ijD7ke16OhicLJLUKJN9vZihXxuPydTGfA=;
        b=DHa2nPdezV2S7HJtR3+w3aZr2dafkgWWz5g3/n5ga3zGhzPUYKdm9rsHEiSZEH/EqJ
         aXwLLqh/wfVnnJbBYdqHCpkCSI0UJUHuETw3UMtmIGKyLRFJ88zRD3PJ7tpvkg2MtoP/
         AD2TN73QGFWUMoC6uDwN97OqI1ZNj8HnJknZfBG8LLHdKNUkTglj1ST24JkL+J2ae5Zm
         cOh1VJ/HqOg1TQ4Qoq4EYEHJceFROm9+6A0N12xqO2ZlKUGkSmcBs5pb0C2nmHg4UUjh
         NW6VmWXQC2Zjz8XUFtsQSm0JDmww7jhHMMUf0YQ814+RaUuWHBVrccSXFJFxldgxStNt
         BkEQ==
X-Gm-Message-State: AOAM533QDARPvD+0KMS0BHHPe/v8cZWE5rvC6c2rc5bGbHk+tWHbc8K6
        njWVOu5McgeT8jmcXcw0i1c=
X-Google-Smtp-Source: ABdhPJwIM9iPDlWfHvaM3fOD8B14B+UiGfECH6cfQCMTTXi9pETGjDfdg7PeOKIrlYXRT+vpAenXbA==
X-Received: by 2002:a17:902:e84a:b029:e6:d1ee:a1ed with SMTP id t10-20020a170902e84ab02900e6d1eea1edmr15376104plg.78.1616334260402;
        Sun, 21 Mar 2021 06:44:20 -0700 (PDT)
Received: from localhost ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id e190sm11134611pfh.115.2021.03.21.06.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 06:44:19 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     herbert@gondor.apana.org.au, andy.shevchenko@gmail.com,
        kuba@kernel.org, linux@roeck-us.net, David.Laight@aculab.com
Cc:     davem@davemloft.net, dong.menglong@zte.com.cn,
        viro@zeniv.linux.org.uk, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 0/2] net: socket: use BIT() for MSG_* and fix MSG_CMSG_COMPAT
Date:   Sun, 21 Mar 2021 21:43:55 +0800
Message-Id: <20210321134357.148323-1-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

In the first patch, I use BIT() for MSG_* to make the code tidier.

Directly use BIT() for MSG_* will be a bit problematic, because
'msg_flags' is defined as 'int' somewhere, and MSG_CMSG_COMPAT
will make it become negative, just like what Guenter Roeck
reported here:

https://lore.kernel.org/netdev/20210317013758.GA134033@roeck-us.net

So in the second patch, I change MSG_CMSG_COMPAT to BIT(21), as
David Laight suggested. MSG_CMSG_COMPAT is an internal value,
which is't used in userspace, so this change works.

In version 2, some comment is added in patch 2 to stop people
from using BIT(31) for MSG_* in the feature, as Herbert Xu
suggested.


Menglong Dong (2):
  net: socket: use BIT() for MSG_*
  net: socket: change MSG_CMSG_COMPAT to BIT(21)

 include/linux/socket.h | 75 +++++++++++++++++++++++-------------------
 1 file changed, 41 insertions(+), 34 deletions(-)

-- 
2.31.0

