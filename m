Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 118855131FF
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 13:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345250AbiD1LDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345211AbiD1LCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:02:44 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 932D2A1443;
        Thu, 28 Apr 2022 03:58:55 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id n32-20020a05600c3ba000b00393ea7192faso2807202wms.2;
        Thu, 28 Apr 2022 03:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cvflK2CCSbF/DUYDBHiik6y6oV21pGZqGs4s1B4i5Ow=;
        b=drsNDLfumBEK+HP8JPoZTI+Vos8DRM+zum/hIAJU+xTnEyprNqQUc6GJ0BPdTjwgdY
         T6YaG98I1VgL2fV6Myh6lAPfhwhCSOmm8qMAe/gdmz4T3axEkC2QvugNG0GF6oN1k2ok
         5JMQNjziheNboaE+6fJmtSbGwKr7p9jUCALNFvL+9CXf8l1drgguJdB0ixGZRUGeJ3p9
         WNelOjD5+guWM2ASBmLY6ZErI0K8oMVseCGAOgyyRXRCSIYPNdKrkdVsxVULwITvka7w
         8h0MwQQLbRUPP9PdhLDgRu0fESwEDz9mUIFdZtdEofmWiNvWs7tYng9ZVbE0vs33i1sZ
         rl/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cvflK2CCSbF/DUYDBHiik6y6oV21pGZqGs4s1B4i5Ow=;
        b=P8+jf4OqKJ0aB3pc5mRbPzmwv8wj2o/8IdfmRecGr0xuKYv8AL6sUl1qakx1P1iQP4
         hW8gfRKRstsBpsjrxiQxnCREA1/v7MQGEX8l70WxQmv/nr//CBLAIIor/lPS4FA5ykD1
         vQoCrfYlAlWDR9fEj1sAYgj5glAer4lfrPZX7zeAmGT7ZF/cmxmhdv+JHAUrdwxx8yoQ
         YyaHmhJ5cdtnS6p7Q0c9Bk3Q73LzwEvkhZT35+/y2x0ZXVWNg4C8TKSFon6BkLoIe5AL
         6RgAnwasNrg/SQtj2ZIe8TbmXnYKbCdK6NQaI90JFxDJUiIfImQ2k5h+4D5NkYorWp5V
         JinA==
X-Gm-Message-State: AOAM533YASv8AGi6qKHkDtPLlWfe5AplDn9BFGJ1gcOtfDzpUMFLLMQt
        fkhCCtqun7Up9kJNorl55eR05dz+zrs=
X-Google-Smtp-Source: ABdhPJzVydLDIO3uQJRPu7P2r6AeMj8AqWb6ykChbvK8S65di/ILUXKm1lwedqLLjm/xC+I4IiiIKw==
X-Received: by 2002:a1c:ed01:0:b0:394:89d:6277 with SMTP id l1-20020a1ced01000000b00394089d6277mr5334946wmh.28.1651143533994;
        Thu, 28 Apr 2022 03:58:53 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-8.dab.02.net. [82.132.230.8])
        by smtp.gmail.com with ESMTPSA id p4-20020a1c5444000000b00391ca5976c8sm4628139wmi.0.2022.04.28.03.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 03:58:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 0/3] UDP sock_wfree optimisations
Date:   Thu, 28 Apr 2022 11:58:16 +0100
Message-Id: <cover.1650891417.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
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

The series is not UDP specific but that the main beneficiary. 2/3 saves one
atomic in sock_wfree() and on top 3/3 removes an extra barrier.
Tested with UDP over dummy netdev, 2038491 -> 2099071 req/s (or around +3%).

note: in regards to 1/3, there is a "Should agree with poll..." comment
that I don't completely get, and there is no git history to explain it.
Though I can't see how it could rely on having the second check without
racing with tasks woken by wake_up*().

The series was split from a larger patchset, see
https://lore.kernel.org/netdev/cover.1648981570.git.asml.silence@gmail.com/

Pavel Begunkov (3):
  sock: dedup sock_def_write_space wmem_alloc checks
  sock: optimise UDP sock_wfree() refcounting
  sock: optimise sock_def_write_space barriers

 net/core/sock.c | 43 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 40 insertions(+), 3 deletions(-)

-- 
2.36.0

