Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F23E7343290
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 13:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbhCUMmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 08:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhCUMmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 08:42:35 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9C2C061574;
        Sun, 21 Mar 2021 05:42:35 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id b184so9116551pfa.11;
        Sun, 21 Mar 2021 05:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6+9EdLUWs2qiFrnCgHd4gqbIvyqcvubo9L71yDSyVXs=;
        b=l8bI4vbR/6n8abAIky74DXynmcqKNYDcW3q9xq7/aweuwg0bsq+UUzTydDP84RqpbL
         ZXV1FEGwQIvXXrZ4W3t4skiLIRXt8dCXY3Sm2DT3HxHLw4Y+iZCmXwAjmJncPZLMpccs
         Ku5HFfv2BwYUhDWSbenE+ZmYKwCiF1V9ANePNcLUshmOECMDZGfFXLI1zeTnkn5d8bfO
         XN9qM7FYfLh0gxXa5NDGZPDjw4KXfIYujzCf+0QkaI1IS8+8spOqz/vb6NqESea73NB1
         cDdTmY5CcrHSFX/0LAy7yiDbP9V9nnctn/iW0+RXMfFwLO9pQu5vRWin5LP6DhKIu0Tf
         Lqig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6+9EdLUWs2qiFrnCgHd4gqbIvyqcvubo9L71yDSyVXs=;
        b=FQ83padn9vdpk7F4Rr4NRUxGjzbUilks+LG4eJm8/otSMuiRuds7/AuT4zxL+qF5f4
         LuOvKfKqEJOze+O1wTT3qMOl2S6pRwYtPxCbVrH/I+cerqBaZkAJnO/IjRaoRL7PG3af
         UV63FvLefPMnDYpwT58q0mdREo8y5ZRxmHqzXeG/yiJE+13AMcV/IdBI1HitCfjSUx1V
         njFPvBjxK+0zTSyOgvLySU7oKyHwxOZ1E9pFbgijACAtrdvFHBy5kvl8ts1nRSLiIe6c
         OUXDsy6e2jP0OiYQLqEJWStse3YHoJG6/57EoRmzcqPA2aiPeimJrSG+/eOfOTUlUfrG
         O+lg==
X-Gm-Message-State: AOAM532Q85wzoKZzgYkEMPjZXXID4frDVNtaSJ9Zppkw2s2B1BbyYpmS
        JdX+czeCfYgZ6V4j2HDLK34=
X-Google-Smtp-Source: ABdhPJyNIsz1RZubJqlF7sHkXq3gfdP266CXGdlkhDzBQbxoDAZhAKZ/o3BU5DpO5iFzHYC6xWAgdQ==
X-Received: by 2002:a63:d94d:: with SMTP id e13mr19212950pgj.160.1616330554574;
        Sun, 21 Mar 2021 05:42:34 -0700 (PDT)
Received: from localhost ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id z8sm10903949pjd.0.2021.03.21.05.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 05:42:33 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     andy.shevchenko@gmail.com, kuba@kernel.org, linux@roeck-us.net,
        David.Laight@aculab.com
Cc:     davem@davemloft.net, dong.menglong@zte.com.cn,
        viro@zeniv.linux.org.uk, herbert@gondor.apana.org.au,
        axboe@kernel.dk, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] net: socket: use BIT() for MSG_* and fix MSG_CMSG_COMPAT
Date:   Sun, 21 Mar 2021 20:39:27 +0800
Message-Id: <20210321123929.142838-1-dong.menglong@zte.com.cn>
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


Menglong Dong (2):
  net: socket: use BIT() for MSG_*
  net: socket: change MSG_CMSG_COMPAT to BIT(21)

 include/linux/socket.h | 72 ++++++++++++++++++++++--------------------
 1 file changed, 38 insertions(+), 34 deletions(-)

-- 
2.31.0

