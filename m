Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2425366AD4A
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 19:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbjANSgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 13:36:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbjANSgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 13:36:01 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C876C2683
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 10:35:57 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id j34-20020a05600c1c2200b003da1b054057so5151409wms.5
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 10:35:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7swTTODSHlYSLX2GAmbKfQRHYdse8pkHcdxtmKU5cYQ=;
        b=AdJ6P+g8tkLBY6++qVkG6kibKDRA0qe+JDeeLfDX/OzuvFwHCJSrhdU+H7DOY/WmC0
         wi9+ztuc+D7dNrjxCaof0y7ZYp02ffYfAknqdhHTXsSDAQv6pen2Oq+5JgdLMJyTGDfv
         B6DUoINkQXVGVlgqbWmUB02+M308Wfh9gk42S0/QxkUpOFZ8uocI2gFOiC6ShcDNWS8D
         7Lw1UVC8Bmyy9AwstFWoIcUOHNERmLGZgxeKKzIkiKn44F/1rKTZut+gR+90ee3b7NQ9
         jCYNenEDDKrtuK0RDAPs6OF78ta5mCJctqItJpxR0J2jgzemIU3DwAeJfK/YMBews3rE
         OpTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7swTTODSHlYSLX2GAmbKfQRHYdse8pkHcdxtmKU5cYQ=;
        b=0/ldatuqCEdzaIMl+BECMaQQKxSbdWuXz7ePQIbQbgsLMjR654WucFOLqDriSG4WHo
         vMFvabCAv9oq3owYmjJz9HaXhe6pe1TCl30MH5YdpgWERmIGB7cNeiPoTIFOMFAqDEl+
         Oq5nsvDpiqOw7/Tj6MoXbyI9HvXCKR7VYljJVtmzZjyWpFUPG3qiXGudV0kzIBIdBQT3
         hEtUj+2KNenQolYL8VDtQ2sk2RWE0MzGM3BQDVsA1zb+jyTDM0bisCdgHd47OQ0km1i2
         dd8rRYX+JoblSEXSAgaP4NcUqxKOdY+0FCOiTE3ThogV3SS86gUOfMSiu4dP+OGFu8rE
         LCvg==
X-Gm-Message-State: AFqh2kop0jmKI//vM82dojjj+zkBLqO6V3Euct9E/ArlE+sTwTfG8rlx
        UgBbSl++Q11pS2qfrOBoh8sXPHTWQHI=
X-Google-Smtp-Source: AMrXdXuGuqtOtJ11UetKKP03qJ8fwCEOriQx9fBwo1hXUq6Osc/S+8KdNU8P/ftX/c/LFjqEPyKRlA==
X-Received: by 2002:a05:600c:4e51:b0:3cf:7b8b:6521 with SMTP id e17-20020a05600c4e5100b003cf7b8b6521mr61677375wmq.32.1673721356206;
        Sat, 14 Jan 2023 10:35:56 -0800 (PST)
Received: from bulach.nilcons.com ([2001:1620:5344::4])
        by smtp.gmail.com with ESMTPSA id ay13-20020a05600c1e0d00b003d34faca949sm28631574wmb.39.2023.01.14.10.35.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jan 2023 10:35:55 -0800 (PST)
From:   Gergely Risko <gergely.risko@gmail.com>
X-Google-Original-From: Gergely Risko <errge@nilcons.com>
To:     netdev@vger.kernel.org
Cc:     Gergely Risko <gergely.risko@gmail.com>
Subject: [PATCH net-next] ipv6: fix reachability confirmation with proxy_ndp
Date:   Sat, 14 Jan 2023 19:35:52 +0100
Message-Id: <20230114183552.3262509-1-errge@nilcons.com>
X-Mailer: git-send-email 2.39.0
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

From: Gergely Risko <gergely.risko@gmail.com>

When proxying IPv6 NDP requests, the adverts to the initial multicast
solicits are correct and working.  On the other hand, when a
reachability confirmation is requested (on unicast), no reply is sent.

This causes the neighbor entry expiring on the sending host, which is
mostly a non-issue, as a new multicast request is sent.  There are
routers, where the multicast requests are intentionally delayed, and in
these environments the current implementation causes periodic packet
loss for the proxied endpoints.

The root causes is the erroneous decrease of the hop limit, as this
is checked in ndisc.c and no answer is generated when it's 254 instead
of the correct 255.

Signed-off-by: Gergely Risko <gergely.risko@gmail.com>
---
 net/ipv6/ip6_output.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 60fd91bb5171..c314fdde0097 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -547,7 +547,20 @@ int ip6_forward(struct sk_buff *skb)
 	    pneigh_lookup(&nd_tbl, net, &hdr->daddr, skb->dev, 0)) {
 		int proxied = ip6_forward_proxy_check(skb);
 		if (proxied > 0) {
-			hdr->hop_limit--;
+			/* It's tempting to decrease the hop limit
+			 * here by 1, as we do at the end of the
+			 * function too.
+			 *
+			 * But that would be incorrect, as proxying is
+			 * not forwarding.  The ip6_input function
+			 * will handle this packet locally, and it
+			 * depends on the hop limit being unchanged.
+			 *
+			 * One example is the NDP hop limit, that
+			 * always has to stay 255, but other would be
+			 * similar checks around RA packets, where the
+			 * user can even change the desired limit.
+			 */
 			return ip6_input(skb);
 		} else if (proxied < 0) {
 			__IP6_INC_STATS(net, idev, IPSTATS_MIB_INDISCARDS);
-- 
2.39.0

