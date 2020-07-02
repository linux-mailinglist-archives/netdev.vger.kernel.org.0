Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA8E212AD4
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 19:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgGBRHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 13:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726733AbgGBRHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 13:07:46 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301FBC08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 10:07:46 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x8so10655805plm.10
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 10:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=xudTOGfqaytwUCeI8+OXhY7Hzr/K6bYLFY8bGmfL4qU=;
        b=EYyjMP6Dhec5/3e0haagE6DboQ0TM13yZpWz9rEvjAy1wnGxjyuEZ7G3nVrb+JV7tS
         qB/1Gy5JMy7Tz4sq7L7k7ggMAWWCiZjAmyPKTfvnZt75YLjMXlgynjFHthElntsJ+Hqg
         /4mphpKCFS+DFcNZy5U5ah2yBfBQiRTT8k83Ux0qm3VON+++E8pDvZnXtAdLxPKyvUe7
         MF3yDLn6xWFQ2aJ/4dO2aklF2h0bAn/Wesi6F707oJUndwxrjpp4T0B0yM97NuMcXc/e
         PGKMwnDqW20i01fV4zzZxMRzXC6R/EUPUHqt/N8HwqR/NwaRsxJOrEJPj5xSgE42Rlvt
         0lig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xudTOGfqaytwUCeI8+OXhY7Hzr/K6bYLFY8bGmfL4qU=;
        b=MmjPtGcwsWKpD/sJNOI4LuQKAYKqyuetCDE5htWN54v4oiUu/0mz3P+5kq/HOyj1Xy
         m+lS072HinKHBOHUQRRtXtYDgpRXrCARS976JEppbUvxgDNObxE++Yvb7ZTmoYC7r0tv
         xZBcvEvvXWT8NCbQPJ/Xi7CmmFmDxhSelBcBNkgNSJoyeJXHan64WZmngOk7t+CHs2Vt
         aI6PElNou4iiATmw5nfDvyssLeJoXeqHgawBRDUmxHcmBcaK0Vv2IRVz25Ne7/HeE35d
         nJqctHmdeB4EPeVgttAzfv7gnjDbqxVhmPQkrGTBho1CGH07rMNsN4zMDX6AcNesSnSY
         OE9g==
X-Gm-Message-State: AOAM530541272hcoOXBVxK+LYXRNQCWd44O+fbIUV11N7BcBm9NzdT0m
        Rcbk5gy+sRw0lhYOntYNjeo=
X-Google-Smtp-Source: ABdhPJwWxsazMiBHcOct8V82OUV9/LHqA6lgE1CapTVruevO9gCWuqJ/aaUEyu7ZZIZOpsIespTr4Q==
X-Received: by 2002:a17:902:b60e:: with SMTP id b14mr27507953pls.81.1593709665703;
        Thu, 02 Jul 2020 10:07:45 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id q13sm9815597pfk.8.2020.07.02.10.07.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 10:07:44 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, subashab@codeaurora.org,
        stranche@codeaurora.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 0/2] net: rmnet: fix interface leak for rmnet module
Date:   Thu,  2 Jul 2020 17:07:37 +0000
Message-Id: <20200702170737.10479-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two problems in rmnet module that they occur the leak of
a lower interface.
The symptom is the same, which is the leak of a lower interface.
But there are two different real problems.
This patchset is to fix these real problems.

1. Do not allow to have different two modes.
As a lower interface of rmnet, there are two modes that they are VND
and BRIDGE.
One interface can have only one mode.
But in the current rmnet, there is no code to prevent to have
two modes in one lower interface.
So, interface leak occurs.

2. Do not allow to add multiple bridge interfaces.
rmnet can have only two bridge interface.
If an additional bridge interface is tried to be attached,
rmnet should deny it.
But there is no code to do that.
So, interface leak occurs.

Taehee Yoo (2):
  net: rmnet: fix lower interface leak
  net: rmnet: do not allow to add multiple bridge interfaces

 .../net/ethernet/qualcomm/rmnet/rmnet_config.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

-- 
2.17.1

