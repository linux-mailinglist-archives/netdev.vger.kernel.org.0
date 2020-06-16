Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13FFE1FAE14
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 12:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbgFPKgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 06:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgFPKgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 06:36:06 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA753C08C5C2;
        Tue, 16 Jun 2020 03:36:06 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x22so9301055pfn.3;
        Tue, 16 Jun 2020 03:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9wi7JLnMddsAQhY5BCSrGpQhhVfzGC1O5cJD8RPkiwk=;
        b=LvK5YwSRhQQpYToFhY6lMz2O9eDJQzQRFYp2b43ukWsglE6oe0rjqI7Vqr3LOOy/z6
         46QpbkfJCePN47x8Vf3EK83YmrAWYzNfQTanKd63U6VAudUBJP16n03ZdhlLm6qDhzEZ
         6qwS8ETowatXzxS9ueJIkut2JH0zFILRJMODc8HKFzjWM6UxGd1rEfDHkogd1YxJiyeE
         4WVbpnqKBuL15qM0ay1DFVYgAFl8qORPICvv8nl+iDHEAiXkDGW5OZIZEWvuqYqaTez4
         Mp83TDEBHmzCFtKukYKzK8ZF+3d2X8ShhNDRPlorcS8FmNObBcouk6uQTAOOg/gPEvR2
         8WvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9wi7JLnMddsAQhY5BCSrGpQhhVfzGC1O5cJD8RPkiwk=;
        b=Gx6g0yhSqZ4v+AtKx6NERgPHAcge3aROZSwNO4RVBPM69c3j9StW78NqKFlpcDRO0y
         gSC29lNjiYOtAdJ32zA6PZmcl1podoIbww35A+vNZVG7zAIEIoyvfWD7zXRpiDETI1jo
         tq2TzD2l5Aq0EX1wMXLwbbaQ9c0MUaNxf/z3quxGpKdOYJbAKXKd4WxE/5Rz+dT6r4NN
         acHXq5L0vPPL1GG3PNjq5ZlmcG31qqgac8h3o+7CKJbUKvGj08ulFgX1ViA4qxjI9723
         oEaSugcxFhfalG0FeawYh2XoOGcHbzDzq5t+85DZ9WndwVoDJ9Ff1bXDfn4lVhpfMKF5
         uGyw==
X-Gm-Message-State: AOAM530gI3Ikt+Cz2ukgcflC91lvNG+cqa2PIZr2seUxBuG6V/921d2S
        eHVAtCdv5MYcIPGQf4JmZrytRw68UyU=
X-Google-Smtp-Source: ABdhPJxjDZgC5vaNzAGoJpRrmqutTVModdfZJlaijnLrzSnJXQjuHJgJ7eTFN88qcoNJ/uhz+wbALg==
X-Received: by 2002:a63:4cc:: with SMTP id 195mr1586798pge.294.1592303765977;
        Tue, 16 Jun 2020 03:36:05 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a19sm16518883pfd.165.2020.06.16.03.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 03:36:05 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH bpf] xdp: handle frame_sz in xdp_convert_zc_to_xdp_frame()
Date:   Tue, 16 Jun 2020 18:35:18 +0800
Message-Id: <20200616103518.2963410-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 34cc0b338a61 we only handled the frame_sz in convert_to_xdp_frame().
This patch will also handle frame_sz in xdp_convert_zc_to_xdp_frame().

Fixes: 34cc0b338a61 ("xdp: Xdp_frame add member frame_sz and handle in convert_to_xdp_frame")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/core/xdp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index 90f44f382115..3c45f99e26d5 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -462,6 +462,7 @@ struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp)
 	xdpf->len = totsize - metasize;
 	xdpf->headroom = 0;
 	xdpf->metasize = metasize;
+	xdpf->frame_sz = PAGE_SIZE;
 	xdpf->mem.type = MEM_TYPE_PAGE_ORDER0;
 
 	xsk_buff_free(xdp);
-- 
2.25.4

