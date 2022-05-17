Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82CB0529A60
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 09:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233036AbiEQHFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 03:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiEQHFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 03:05:39 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4691A20BC9
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 00:05:37 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d22so16550157plr.9
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 00:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=xk2haGfeJlJrqNIASodQPP1fcHowD0QD18K8G5RCmPk=;
        b=E+aU4Wm2wtOoKRnuQsINbVYjiUrw1zEm4SJPILBXNjAkOE/w3OfMBGPmCpdHlIh9EZ
         WoY6HFlCsrTorPrk3upXSYm0VOyRz68gcNsZwJgKegP9zQrz8kBjixhAlJU5dJRknnf8
         BXRHIbLwPc+/+QAxpYRGzdr15Z91OYQXwazoI0j+GOAJjzPlhkwNw5k5EojbsXtUQvYK
         Y8B1mJL4PkDbqhdZCAIUnseO1cS8boV0tIkiJNa1F1pAuQS7/peXoG1Os+AcTKdQBI1C
         mjdsKEJsFBcwFT+8VXSVuse85QjGZL7W9DgOA3WZAQJKJ8rr2IrRWX2PVMC6JLB1v5DI
         o35w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xk2haGfeJlJrqNIASodQPP1fcHowD0QD18K8G5RCmPk=;
        b=GwxC8MdohOG317I8CXasSWM8dpcM/feAm9UuATv1tinCvRfwtxOxXE290MZ+7NuH5q
         09Ox6Mfeh0/u8ITm5jVVS+J2HVDo7LiLmZ7zWpt7hIzLVVxcGawB24vOr2oSvfifWVbP
         dWUNE4eQSXOm/mp54FXAjBw7DndKbV5ZcN+CAcgp/5jcnPEYB9kjS2IC3t4CuYqcxFf+
         jv/6NGkCRAEY8vuKapeLOB8dDpKve5QhRCe0oJJpWS1RronEh0GrEn02sxbcKyZhKtUb
         sADpY6LiyU0fGgaKXpvIcH2bS87vAv0K0kNuuJ3rlcb19+1Txz0hBosnih0wLq0d9Gfp
         PVWw==
X-Gm-Message-State: AOAM532zIthRh45d/MmyG3io5Jkgy80pOBxz2sCMaX/gQcpHu/4zIww3
        zO/Fb5eTxbbMZg0HWpnrqSc=
X-Google-Smtp-Source: ABdhPJzuk9L26kMZ/YUHOqqDrvb9Nyw7rF+84+h3XJj0vM6ikRXXF9DUNM26L2H9bvN1W9shFm5x4Q==
X-Received: by 2002:a17:902:e74a:b0:15e:9811:11da with SMTP id p10-20020a170902e74a00b0015e981111damr20375141plf.130.1652771136747;
        Tue, 17 May 2022 00:05:36 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id y23-20020a17090264d700b001619b38701bsm1680886pli.72.2022.05.17.00.05.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 00:05:35 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 0/2] amt: fix several bugs in gateway mode
Date:   Tue, 17 May 2022 07:05:25 +0000
Message-Id: <20220517070527.10591-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset fixes bugs in amt module.

First patch fixes amt gateway mode's status stuck.
amt gateway and relay established so these two mode manage status.
But gateway stuck to change its own status if a relay doesn't send
responses.

Second patch fixes a memory leak.
an amt gateway skips some handling of advertisement message.
So, a memory leak would occur.

v2:
 - Separate patch
 - Add patch cover-letter

Taehee Yoo (2):
  amt: fix gateway mode stuck
  amt: do not skip remaining handling of advertisement message

 drivers/net/amt.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

-- 
2.17.1

