Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0974567654F
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 09:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjAUIzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Jan 2023 03:55:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbjAUIza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Jan 2023 03:55:30 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD4965F00;
        Sat, 21 Jan 2023 00:55:29 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id g68so5776958pgc.11;
        Sat, 21 Jan 2023 00:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PrnGpbTnMcSAdRfQebkBMLK0G9v/WsMM46OOzL4dzDA=;
        b=SDgmsuHEoebuFkYmBvrFkLKy8cp1wMRSw6dwPIcLHUVNjujn6pQvfS04Kd66UAr6jg
         gQHORYgc8k4DFh4N1th30dsYb4lEeIXxHlYylXeF+eWgTRB/YGd/LxJpoWSQQ48ftFmL
         WTlEIypkkTJgri1WauSjeLaTDPWocpJuCA/8x2lZ/VrUV9ireiy2Jba9WmKZxGWT3tYV
         X//7ZskP9FB8Vg8q68Axf0WsNxQzFpc/5ZLcVbVF4PeO0pACd5KaM1kPK364Sfg9HT3n
         cehY8/32fDbNBVNwZhkW9AKZLGNMEHTLnnXnsocO13r5AWLSKm4wU4B3EYK4YHbnTLpy
         o3uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PrnGpbTnMcSAdRfQebkBMLK0G9v/WsMM46OOzL4dzDA=;
        b=FGCAq+A/9G2nsSQTcXfzastImQFkALWLunpvV0y3leeabIpughZdcf8JmrJbBGRobP
         2sk2dH7o8wDVTPMlJ6lQdxpPJE0dDs6vjlfYuIbQPEQIyINnd3K4SC+HdU7onkUyQ+xE
         Ycwxe5rmWrZhnvDi4o7ThY8r7ZRClXfladTwZdez7n1SB0vzaGl3Hb+i8AreuS26ddOp
         jr/H+0nbzEx4NkcHBSN/70nmpnD+Lenan+aVcvntsBiREIoFC8Mk8awJLqJsCeCQrFOk
         YzJPZiaetNvsfNmGuzo0HmWjDfRkWMgu9rjvx/pTumwmMDbMhCJopjSA9JxVuJOxjoJn
         GvzQ==
X-Gm-Message-State: AFqh2kqPA8tfogde2FLOv3B06GdRNYNz3dLYIigT/pHX2AneI6clV5ic
        juiE3JBR0t/8JE9eg6c/nok=
X-Google-Smtp-Source: AMrXdXtzJGv9kNgIMLdl5kpmHw6/WyaUEOpyP69CLf2iz6zCwj0mx2VTlDKl6zncSY40xuVA9FpLLg==
X-Received: by 2002:a62:148d:0:b0:58b:ca43:9c05 with SMTP id 135-20020a62148d000000b0058bca439c05mr16399291pfu.16.1674291328948;
        Sat, 21 Jan 2023 00:55:28 -0800 (PST)
Received: from KERNELXING-MB0.tencent.com ([114.253.32.172])
        by smtp.gmail.com with ESMTPSA id z4-20020aa79484000000b005823b7da05asm11927073pfk.122.2023.01.21.00.55.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Jan 2023 00:55:28 -0800 (PST)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.co
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        kerneljasonxing@gmail.com, Jason Xing <kernelxing@tencent.com>
Subject: [PATCH net] ixgbe: allow to increase MTU to some extent with XDP enalbed
Date:   Sat, 21 Jan 2023 16:55:21 +0800
Message-Id: <20230121085521.9566-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
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

From: Jason Xing <kernelxing@tencent.com>

I encountered one case where I cannot increase the MTU size with XDP
enabled if the server is equipped with IXGBE card, which happened on
thousands of servers. I noticed it was prohibited from 2017[1] and
added size checks[2] if allowed soon after the previous patch.

Interesting part goes like this:
1) Changing MTU directly from 1500 (default value) to 2000 doesn't
work because the driver finds out that 'new_frame_size >
ixgbe_rx_bufsz(ring)' in ixgbe_change_mtu() function.
2) However, if we change MTU to 1501 then change from 1501 to 2000, it
does work, because the driver sets __IXGBE_RX_3K_BUFFER when MTU size
is converted to 1501, which later size check policy allows.

The default MTU value for most servers is 1500 which cannot be adjusted
directly to the value larger than IXGBE_MAX_2K_FRAME_BUILD_SKB (1534 or
1536) if it loads XDP.

After I do a quick study on the manner of i40E driver allowing two kinds
of buffer size (one is 2048 while another is 3072) to support XDP mode in
i40e_max_xdp_frame_size(), I believe the default MTU size is possibly not
satisfied in XDP mode when IXGBE driver is in use, we sometimes need to
insert a new header, say, vxlan header. So setting the 3K-buffer flag
could solve the issue.

[1] commit 38b7e7f8ae82 ("ixgbe: Do not allow LRO or MTU change with XDP")
[2] commit fabf1bce103a ("ixgbe: Prevent unsupported configurations with
XDP")

Signed-off-by: Jason Xing <kernelxing@tencent.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index ab8370c413f3..dc016582f91e 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -4313,6 +4313,9 @@ static void ixgbe_set_rx_buffer_len(struct ixgbe_adapter *adapter)
 		if (IXGBE_2K_TOO_SMALL_WITH_PADDING ||
 		    (max_frame > (ETH_FRAME_LEN + ETH_FCS_LEN)))
 			set_bit(__IXGBE_RX_3K_BUFFER, &rx_ring->state);
+
+		if (ixgbe_enabled_xdp_adapter(adapter))
+			set_bit(__IXGBE_RX_3K_BUFFER, &rx_ring->state);
 #endif
 	}
 }
-- 
2.37.3

