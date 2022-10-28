Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B52611C91
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 23:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbiJ1Vne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 17:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbiJ1Vnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 17:43:31 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3257A24BA90
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 14:43:30 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id y13so5844074pfp.7
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 14:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Sx0EMO7RuJTo/3Ojp2nIxuOlr6+N1nhbsLyvkyaiQXQ=;
        b=tThyWqEH+OHSWnyvXVnGVb/RhwKNJAox7Ss2mhO1vSdRKT3Ewr1p0KrR11/iwka97g
         AiLMqsg0mEuabgBywD/d2wh1f9R0qRd3mQs0FqYWbOQY9HxaCHHZtrsbrUWRFZWsW64h
         iGs3V597/zcdRu068jxDXK40pzFV1K9lKSx2z6lPRCwVULPx0fPWJigIk5pAIeepHkmL
         OPAPPRTj2XsThLV1wZLIS9zkYy+/viHeG6K9gNO9wA1MlRI+cAicnc78S7aas1IF0Y1m
         K8suSyr7Ii3VHFQQm7xB0SdEO4hZWjpWXepl6iImu7sInL19Qus+calIQVHZ6MQHObJw
         lfbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Sx0EMO7RuJTo/3Ojp2nIxuOlr6+N1nhbsLyvkyaiQXQ=;
        b=cOWW9IijBnuUII2rpfbWUeqLGLQsoFGveOulPMsHRROf2WN8yv4KtMy7+qH+M3ApW/
         JG5XOqhEMAu93G/SMZBMnVMnVt2UXa3GO0bu0ZicDPVqgZibwCJisYlv1NkJeV78hhGq
         EM3mv8VmuPLh3o31UIHRi44wJlMgqFoKAjmdjYzKQcyWiCQPGyQ7+CWJSLqNYQT4dOAj
         PrJgpcsycuy2+tTbhbStgkTqjwyofmT8fVEU4CF7aenhHgQynhrBVFdeIrJ3jx7gSZi/
         n3I95/SGHu5QvAT8YEXQTO+Fm+h3h50/jX7iQFdyHCag8qEvukSpUhnk9ztW1oQ/Ko0I
         x/kQ==
X-Gm-Message-State: ACrzQf3F8R4LY0AKw9dKTDEKkUbsgG37A4qKBMpfopw5yk0dfIAXM046
        xiO4mJ2Tw9MnuQd0F2dROERzrcg4su3yOZ0m
X-Google-Smtp-Source: AMsMyM6eZYvWlRoybNy5poLFi35/6NQyTprjHoq3gnITzXCk+oEQrqkLFODtn8ojUQC64FZtdTxt8w==
X-Received: by 2002:a65:49c9:0:b0:462:9ce1:3f58 with SMTP id t9-20020a6549c9000000b004629ce13f58mr1389282pgs.200.1666993409506;
        Fri, 28 Oct 2022 14:43:29 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u6-20020a17090a1d4600b002130c269b6fsm2993855pju.1.2022.10.28.14.43.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 14:43:29 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCHSET RFC v2 0/5] Add support for epoll min_wait
Date:   Fri, 28 Oct 2022 15:43:20 -0600
Message-Id: <20221028214325.13496-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

tldr - we saw a 6-7% CPU reduction with this patch. See patch 4 for
full numbers.

This adds support for EPOLL_CTL_MIN_WAIT, which allows setting a minimum
time that epoll_wait() should wait for events on a given epoll context.
Some justification and numbers are in patch 5, patches 1-4 are really
just prep patches.

Sending this as an RFC to hash out the API, basically. This is
obviously a per-context type of operation in this patchset, which isn't
necessarily ideal for any use case. Questions to be debated:

1) Would we want this to be available through epoll_wait() directly?
   That would allow this to be done on a per-epoll_wait() basis, rather
   than be tied to the specific context.

2) If the answer to #1 is yes, would we still want EPOLL_CTL_MIN_WAIT?

I think there are pros and cons to both, and perhaps the answer to both
is "yes". There are some benefits to doing this at epoll setup time,
for example - it nicely isolates it to that part rather than needing
to be done dynamically everytime epoll_wait() is called. This also
helps the application code, as it can turn off any busy'ness tracking
based on if the setup accepted EPOLL_CTL_MIN_WAIT or not.

Anyway, tossing this out there as it yielded quite good results in
some initial testing, we're running more of it. Not a lot of changes
since v1, but it was posted in the middle of the merge window. Hoping
to get some more discussion this time around, or at least some...

Also available here:

https://git.kernel.dk/cgit/linux-block/log/?h=epoll-min_ts

Since v1:
- Split patch 4 a bit, to make the meat of the changes smaller
- Get rid of EPOLL_DEF_MIN_WAIT
- Rebase on current -git master

-- 
Jens Axboe


