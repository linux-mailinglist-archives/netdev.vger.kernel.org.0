Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 233543753FD
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 14:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbhEFMo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 08:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbhEFMo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 08:44:57 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696C3C061574;
        Thu,  6 May 2021 05:43:59 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id n205so3317414wmf.1;
        Thu, 06 May 2021 05:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EEdHb06V70cSzKm6lwhxyR5vDfdofy5h1Bu7YADhYf4=;
        b=i0Olg8YBlnOG6Y43qWNKFw1ePIb0O3RDAMjluP8y5NVM+EfyXIgp/wkMvXicbShdIs
         3uKYJODdDSlcEV9660n+u9DTHDT1kkIoWoNqoPkKgHjCo2tC36+2ojLRD2S33OM79VtU
         IlTCGxdoJNAiTZlkIC02KGOcvbw2/6MUhM/MEj32k9shWVgYA9Hs5gprP0xBZ+Pqx/Lg
         ee/LvQSMIXqp6L0weGl4HrKPHo2+FTJMcoMdNLXmJGoO1SXz1qLxGFKJrCEl/dMhQ1/O
         cOntQihLKFu/wGjZtRw+9LFNjhwvhne5FoXKpTLutsUHyMbVljRV58nJE4lb81cHfjwk
         cKYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EEdHb06V70cSzKm6lwhxyR5vDfdofy5h1Bu7YADhYf4=;
        b=W2htRg80q9jav9UQhpNasYCA1cf3tEOqo1glt62Cgh/AVmJBvN48r0UwO9QlwiYXbn
         JdP3VXrY9sdYCRY1Sd6V+QTw6PALbbrFMPcBfCoTpFaTnjJTd4Cc+H14l7QpXfIZNwT4
         8jA8J1Ylk+TWv91NMX0EaczPvq6mkKYCmpTQx7KoPUw9MIAcGwgSC0UEDUQ8HWrxPdZl
         Q9sF5vcUl3hOsemrVC5M5u0hvcY8vDSrH9T0bjaPUasm3IaipXguiVeN9St6Yj8lcIUO
         SnBM/5iXnGqkO7GeTdt1gwpbk27Ca1XM47wg+87In+4lonFPttTuQud53RPpnT0Xq82A
         lqFw==
X-Gm-Message-State: AOAM533jOBvn8EPAbuz4LuUKVLMes5JFerGzKi4rTqbw4ZKz9wTWSfjp
        /ZOAwal+j4PazFjj41eVeEc=
X-Google-Smtp-Source: ABdhPJxhu+g0mR5Mi/kLwwnxSWO2Dr81C5OnBRe3MkzEM25AxT4j8Vfn1gLqFhKNXtuGVabzqDg0Pw==
X-Received: by 2002:a7b:c38d:: with SMTP id s13mr3839579wmj.115.1620305038166;
        Thu, 06 May 2021 05:43:58 -0700 (PDT)
Received: from localhost.localdomain (h-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id k11sm4430864wrm.62.2021.05.06.05.43.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 May 2021 05:43:57 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, maciej.fijalkowski@intel.com
Subject: [PATCH bpf] samples/bpf: consider frame size in tx_only of xdpsock sample
Date:   Thu,  6 May 2021 14:43:49 +0200
Message-Id: <20210506124349.6666-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Fix the tx_only micro-benchmark in xdpsock to take frame size into
consideration. It was hardcoded to the default value of frame_size
which is 4K. Changing this on the command line to 2K made half of the
packets illegal as they were outside the umem and were therefore
discarded by the kernel.

Fixes: 46738f73ea4f ("samples/bpf: add use of need_wakeup flag in xdpsock")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 samples/bpf/xdpsock_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index aa696854be78..53e300f860bb 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -1255,7 +1255,7 @@ static void tx_only(struct xsk_socket_info *xsk, u32 *frame_nb, int batch_size)
 	for (i = 0; i < batch_size; i++) {
 		struct xdp_desc *tx_desc = xsk_ring_prod__tx_desc(&xsk->tx,
 								  idx + i);
-		tx_desc->addr = (*frame_nb + i) << XSK_UMEM__DEFAULT_FRAME_SHIFT;
+		tx_desc->addr = (*frame_nb + i) * opt_xsk_frame_size;
 		tx_desc->len = PKT_SIZE;
 	}
 

base-commit: 9683e5775c75097c46bd24e65411b16ac6c6cbb3
-- 
2.29.0

