Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7348F664DCC
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 22:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbjAJVAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 16:00:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbjAJVAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 16:00:39 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F9559537
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 13:00:37 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id p17-20020a9d6951000000b00678306ceb94so7721695oto.5
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 13:00:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=STsnT1B00VmWJjDQhg2Th+ftvCRI0cTMfz7XzYq2Sko=;
        b=fcqZZQOHzf2GyHlgEB5t4Kp2+A1NQvOFawiz2hY3miP5z/G2IRo1FvU+xXtzJxa/ep
         OTWq74zk+8R7xabv0rIXMmC+HZTrTqgoNNpDWtEwar+kYSF+zirSyAPAbaKoYn4LTc8N
         EhYdNyyS7/60g/kiHWu2LbHOdG2oN74cBjqRJ9L1CpeyLO1SC+Jb+Jc/JribY+C38Emf
         sQxRzBFd4DTmfYOtTT3F85ejWnWuE6YpZxGIl9HeTN7Zb0kkOhQhATVhd2yJq3QDe704
         RP9VGxFzGtbAYokjRoFnLpFkH5Ogh7fXLvOMY/jpFT2eTI1S2Kd+GH43p8p+LC6zCs/V
         8OmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=STsnT1B00VmWJjDQhg2Th+ftvCRI0cTMfz7XzYq2Sko=;
        b=B+kW9svnp53nHp7aQYo8hrB8ZDKXplwuUxZlxs/ySWdyZ2SPVXhCGNI02McYHQSPnx
         wi2oFjAHB3x5pYX1Vg44OuP16shLPBwgwqYGFDW+323eAWzWQr2BGdUMwynJCB5572eW
         264AO4h3SZGsnZvkgIhd3vAaqlOLyK4SXB75NgK0a3j+/9jihBjubytXzlhzgIfo3V+O
         0kA+DxfUXPxqzxcgDmEi2xpLLdB/7P8ftzfhwmZCmkRmIVl7v3UvnkXVwVM7nEXQPuX9
         z4fLSlvw64VQWn2wK7YlUyv+/dJ3Bm8XQdNFFznuPGSQ9woPq9f/fbAPBz6DYy7wWIfl
         cvVQ==
X-Gm-Message-State: AFqh2komHAe+v8LZWj53uPSqMZf7CbExB3M0SUgfjvmZavA+iUKR3m/D
        xWrZrtBjW7s8FAIoVLpVMo9J2hVsnMs=
X-Google-Smtp-Source: AMrXdXvzN31TUbJjgXN5KUcLHs40GYsUOPZZ24yO2/eV6T1WNrngZ5haXHiGPjyFNIZip6wjQPH2eA==
X-Received: by 2002:a9d:7408:0:b0:676:1802:661f with SMTP id n8-20020a9d7408000000b006761802661fmr32050112otk.25.1673384436730;
        Tue, 10 Jan 2023 13:00:36 -0800 (PST)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:f305:c94a:147a:7bd2])
        by smtp.gmail.com with ESMTPSA id b10-20020a056830104a00b0066e93d2b858sm6518854otp.55.2023.01.10.13.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 13:00:36 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     saeed@kernel.org, gnault@redhat.com,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch net v2 0/2] l2tp: fix race conditions in l2tp_tunnel_register()
Date:   Tue, 10 Jan 2023 13:00:28 -0800
Message-Id: <20230110210030.593083-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

This patchset contains two patches, the first one is a preparation for
the second one which is the actual fix. Please find more details in
each patch description.

I have ran the l2tp test (https://github.com/katalix/l2tp-ktest),
all test cases are passed.

---
v2: move IDR allocation to l2tp_tunnel_register()

Cong Wang (2):
  l2tp: convert l2tp_tunnel_list to idr
  l2tp: close all race conditions in l2tp_tunnel_register()

 net/l2tp/l2tp_core.c | 105 +++++++++++++++++++++----------------------
 1 file changed, 52 insertions(+), 53 deletions(-)

-- 
2.34.1

