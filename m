Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939B03D4F30
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 19:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhGYRC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 13:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhGYRCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 13:02:25 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82DD7C061757;
        Sun, 25 Jul 2021 10:42:55 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id n12so4643127wrr.2;
        Sun, 25 Jul 2021 10:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6kbXY8dhOgUZMFwIN+vzOz5FwLPrrPOk7zXWY48ZgLI=;
        b=fr9+XXSoMbtCCN0pl25z5VYNRbUBVPnoPGBJXVbIEo0s9/iW3Axvx/eqQhmcYnnv4U
         FMudzk+JzW9sN9rhmxZL2ajeCgCcQK2dysd5IVXDlcdCtxft8SfzffpJs1d93A4cVcGx
         tGB69ii8ypocN2+MzObiteolZgv5rWyfDmeKzJVyPcPx6Eo8aaSUBejSTT+AgbqizT9+
         pXRJoRKMubV9eQQ10nVTodndD4dOazsXQ8T+/k/cdsbOJa7h8Jth3gkhWAoFTt0SiMQl
         LJCrab6RMPR/vrD1Ro+rXaUaPTEaWhOYALTK+Gjro/P6r5v73ABLD4ajvqx58kZ/MW/X
         L/JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6kbXY8dhOgUZMFwIN+vzOz5FwLPrrPOk7zXWY48ZgLI=;
        b=g39k8s7c2pOSIoJBEmfEFVbchnJFBWnoQR+Ad7PEn6owSOGo3Hte+DFE4Y2UcwYsKz
         Q9u3NOd1/tNlSPPx/gxUCaT+fij0WHrfbquwTDeqs6r+UtiYWAQCGfYGkuvLhkBvWsh/
         iBfu6g7F/tX6FNvQNUPwfPSlQqOi3grroRMdkGxI+T/YarxWxlliDUtq2UB0I0dibLJu
         MspkNWXQ5Uf4xEsqMn6o9R7NssR1CXC4rzPDP2XwsRIY1rNS2mK2vBPcMasuck7x9MJF
         Wrnp1Zb0FXQLEz5Eh3FYE35gJHMsWKc3QYorNd0fV6FAUhTIvevhnBUhZwuebe/FnhQW
         tbAw==
X-Gm-Message-State: AOAM531ASSa1NIP6CYq7gnw0GkeaGDBGG+ki/V2z+B+hNMrCRBDghL+O
        G++4T2Vaa+l20kJA0WICy5uGVOXHcys=
X-Google-Smtp-Source: ABdhPJyWhGGfJrcTJbueAXuqfn8R14Us+h19xTw2b8MvjolnbvLYZ6ubGfsVvWEuqT+WeNbYnQsqyw==
X-Received: by 2002:a5d:4e08:: with SMTP id p8mr15404792wrt.425.1627234973833;
        Sun, 25 Jul 2021 10:42:53 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id o6sm39255590wry.91.2021.07.25.10.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 10:42:53 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCHv2 net 0/2] sctp: improve the pmtu probe in Search Complete state
Date:   Sun, 25 Jul 2021 13:42:49 -0400
Message-Id: <cover.1627234857.git.lucien.xin@gmail.com>
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

v1->v2:
  - see Patch 2/2.

Xin Long (2):
  sctp: improve the code for pmtu probe send and recv update
  sctp: send pmtu probe only if packet loss in Search Complete state

 include/net/sctp/structs.h |  5 +++--
 net/sctp/sm_statefuns.c    | 15 ++++++-------
 net/sctp/transport.c       | 45 +++++++++++++++++++++++---------------
 3 files changed, 37 insertions(+), 28 deletions(-)

-- 
2.27.0

