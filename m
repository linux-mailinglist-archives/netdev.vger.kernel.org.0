Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9B0272940
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 16:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbgIUO6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 10:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbgIUO6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 10:58:18 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F4BC061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 07:58:18 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id gx22so9129369ejb.5
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 07:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EJs4t9es9brS9byQpAuBOzkQpNdm2qyviSkYBbgWl2o=;
        b=hXJAM8yDP7Dqi6R8iCao9nXatIh73hpixHgJlbXkNZlClzJTMS5uTw+NawbDadhq8G
         Q7nPwwW61JWpKIg4KB0JYv8QIeoSyHzci2g8hhtueEJXuzenqzhz9/jR5VGJ0iCNBnbT
         k8GZ1qB8bF5tYoDz+2dJwcnL05FNjyuqk7ppr2JRjYrmNdME9L7DLmhZpYPHFUR4F1pL
         /0BM3hMQXDMP3Eb/9UnN3qA2LXhBxKJKYKayXb4D4u4JeFay1xDqDrYLV3hjV7oJhiol
         6AGDEIyoWV8GqwkFZSeLHfzHvo3lujgje3dRULBPFg61tX1o29cnVFj+9hxZ+g/7ZJ4/
         AeYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EJs4t9es9brS9byQpAuBOzkQpNdm2qyviSkYBbgWl2o=;
        b=cXHdlZimVOMIIIeC33riBA4+ORSIbK3RzObC2S2x6PTEFhzAtxsnKoSxo1WnYibGlD
         KUEr0UtBJfAlrkWWr32WsQoAhcTjZ7ISSbmm93hwvuK6MRBjG/lnpMkogYcQsiYWS06v
         p+YUGJAtN270vzca2zy7Et0I0nhQvjjalBy+gSUR6xv7urIkTahfJcw4bsACnnlud4/S
         H+JhDNkMFwn7SEXrssVmH7535ZwERJKTecQo+pyCPVdg50rz0qLajei9H4s+X72mVQ6T
         CMcGAOHzwJerAJ8Cz/UJbt/LgTr6M5TgSSqvr3lH5FUa7WBLJZqYzxEFHBcuGHoI/Zxs
         KORQ==
X-Gm-Message-State: AOAM533pzpV4yZ9PseePgkYnymeTdp7fnGnodQqas9QSpeSeIveo+P9C
        WJUVsWCL4hyNg5nvo8GMObGf6QyyRI2m0vLX
X-Google-Smtp-Source: ABdhPJyts2iTXX1HfbKhySlIf+CV1hK2t7cj5hn6jcA6d4Akk3B6Sur9AHgwQ3bMyn20MD/6Q6AqbQ==
X-Received: by 2002:a17:906:60d3:: with SMTP id f19mr52068017ejk.141.1600700297089;
        Mon, 21 Sep 2020 07:58:17 -0700 (PDT)
Received: from tsr-vdi-mbaerts.nix.tessares.net (static.23.216.130.94.clients.your-server.de. [94.130.216.23])
        by smtp.gmail.com with ESMTPSA id d13sm8746714edu.54.2020.09.21.07.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 07:58:16 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3] mptcp: Wake up MPTCP worker when DATA_FIN found on a TCP FIN packet
Date:   Mon, 21 Sep 2020 16:57:58 +0200
Message-Id: <20200921145759.1302197-1-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mat Martineau <mathew.j.martineau@linux.intel.com>

When receiving a DATA_FIN MPTCP option on a TCP FIN packet, the DATA_FIN
information would be stored but the MPTCP worker did not get
scheduled. In turn, the MPTCP socket state would remain in
TCP_ESTABLISHED and no blocked operations would be awakened.

TCP FIN packets are seen by the MPTCP socket when moving skbs out of the
subflow receive queues, so schedule the MPTCP worker when a skb with
DATA_FIN but no data payload is moved from a subflow queue. Other cases
(DATA_FIN on a bare TCP ACK or on a packet with data payload) are
already handled.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/84
Fixes: 43b54c6ee382 ("mptcp: Use full MPTCP-level disconnect state machine")
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---

Notes:
    This is a resend of v1 and v2 with the same code modification. The
    previous versions did not get delivered to vger.kernel.org but did go
    to other recipients. There is a known issue with the SMTP server on
    the Intel side. Sorry for the multiple versions.
    
    The only modifications compared to v1 and v2 are in the commit message:
    - Paolo's ACK is back: it was accidentaly dropped.
    - My SOB is at the end, being the new sender of this patch from Mat.

 net/mptcp/subflow.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 34d6230df017..31316cfeb4d0 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -733,7 +733,7 @@ static enum mapping_status get_mapping_status(struct sock *ssk,
 
 	if (mpext->data_fin == 1) {
 		if (data_len == 1) {
-			mptcp_update_rcv_data_fin(msk, mpext->data_seq);
+			bool updated = mptcp_update_rcv_data_fin(msk, mpext->data_seq);
 			pr_debug("DATA_FIN with no payload seq=%llu", mpext->data_seq);
 			if (subflow->map_valid) {
 				/* A DATA_FIN might arrive in a DSS
@@ -744,6 +744,9 @@ static enum mapping_status get_mapping_status(struct sock *ssk,
 				skb_ext_del(skb, SKB_EXT_MPTCP);
 				return MAPPING_OK;
 			} else {
+				if (updated && schedule_work(&msk->work))
+					sock_hold((struct sock *)msk);
+
 				return MAPPING_DATA_FIN;
 			}
 		} else {
-- 
2.27.0

