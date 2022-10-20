Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F30606B79
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 00:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiJTWpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 18:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbiJTWpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 18:45:20 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF5E43152
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 15:45:15 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-349423f04dbso7555557b3.13
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 15:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YPk2tCFY+ir7KenjsufIqg8FTNiKRgM37N/rIZeE0C4=;
        b=jhMlf3r3vyC8RN3W8CyrySeYFBYHVttZEyF5w07AcjDscrJjOtgLfpZHKGgmGKfL1P
         6IHOCUomBcqHuXNkKe0R9HcxBgr5S3XNjKlbBM+J1WbgepM4jl1r8zoJxyBNy88RlIql
         +rICvAvyPOYfqOA0lykkubDSIEgZsjZ7rq7fhOhtD2AxbkugYj6Egb+NjloqTPdCrZJk
         +CPRux9+Lpsc3cYanFSKwahOLPcSz9X94KZmd017i/xSanAek7/+KkddjbZzjphORmz5
         c0XktyJaQPQ9gQBq/i0eKQSN7F4c7cQH3sjcYNoyQSI7+7ecUgnigbU+z50RqqIdwJC/
         QKtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YPk2tCFY+ir7KenjsufIqg8FTNiKRgM37N/rIZeE0C4=;
        b=XLOPtsNtt1ACxksMb5OPa/VcqRR1OE+TCURc9AwMxVk5mWCZfhezKIuuiOMHOmDd90
         4rxy2V/jj/V7SlUdbneaicMISfPk2iV5BKwYWVaYFP50/sBegRpXWVUKEwHXTDrIdIXF
         bxWZq49FBngvDpQ1GYBGTWnGysdV0G+qe1dvVqVVSA01jhtIeupot4tUPSP5ohPsL5zv
         p+tYnRpl1d3tsypaIcuBrjUJDg1zTsOXw6YSJTb6VNpSCHbminX3D9Tzjd83JdIr9RSM
         8GswMTcU8k7N3KlE8krKj5amQrXEfwc602O2TXGpynaonX6XDRJESYoJYq2G6NMvbyQq
         f8bA==
X-Gm-Message-State: ACrzQf3ZuhJ62HPyaGy3WFC+UQvIot8ve25YG80/QOgBxbrdPL6oQ4fL
        67mKmIschwbQ7miiZYbMYdIgkUsqD99s0Q==
X-Google-Smtp-Source: AMsMyM6gu2nv3Bew55o/o+bet+dJ1nOBMeT2kZv8yGzqq1SGhsqNApDJpHtqZrZ0PfqP05H3OWFeMgRWcZV9SA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:4ccc:0:b0:360:811f:4b74 with SMTP id
 z195-20020a814ccc000000b00360811f4b74mr13606423ywa.398.1666305914517; Thu, 20
 Oct 2022 15:45:14 -0700 (PDT)
Date:   Thu, 20 Oct 2022 22:45:10 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
Message-ID: <20221020224512.3211657-1-edumazet@google.com>
Subject: [PATCH net 0/2] kcm: annotate data-races
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series address two different syzbot reports for KCM.

Eric Dumazet (2):
  kcm: annotate data-races around kcm->rx_psock
  kcm: annotate data-races around kcm->rx_wait

 net/kcm/kcmsock.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

-- 
2.38.0.135.g90850a2211-goog

