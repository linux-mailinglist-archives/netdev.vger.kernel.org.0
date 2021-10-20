Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4C9434A62
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 13:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhJTLpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 07:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbhJTLpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 07:45:13 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229EAC061746;
        Wed, 20 Oct 2021 04:42:59 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id g39so14156488wmp.3;
        Wed, 20 Oct 2021 04:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IXvZic7J5UVbC5NJ3J815qijKl0xuXYlhVBJSyylDdQ=;
        b=MZ+QuCcPRCK43VlV3cNS0QsSG2dkXBZO4Zbs+dvESJMJPD7rXQQVKvEVhBAVKuO+Sp
         NTKouYtroven11ysf+njosRWyasHD/CV2vXip0OzCTyfCvB5vtScHjW/uEP2BNywvg/B
         FS2fTStfXqzykGtLP/vQwyMArVjDgVrCpMX73IWkSlDrGFua+tEbedxrmnn40+qAvAHu
         ysk+wpFeNb5OybeTsX7S26QXQYR0CaetyzNhty+APVJduKwCnMyZW3a9U2ESKNH2SHm5
         LopJThaeyvKWccNNq6NPoGqVb0P3QQenmN7svtAlVpNL0k8W6ILDjXsbWouyG6WFfefv
         gM1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IXvZic7J5UVbC5NJ3J815qijKl0xuXYlhVBJSyylDdQ=;
        b=U/5huPDcXvhG+F50XdaY7wKBGsRjHTA6hQW54RQRlJKbq2ex4RW1gEYq/A2oSSDr09
         W/rPhoUhupDqWr/iwv8b93wnDEOr2dF0ih/w6MevjT7rtRhOobgECtXHgSm+ex38SaOK
         dg0pA+jBOVZtsPKs5QzQQ4EQEZ29wSlQbqWjX8OFdFSFtAXF6sBINTKGBYJtIGt3Bnek
         X4Lj3ZUfiKvqjtSUorYVZrT4U4SoNPPndC4INSnevwiHXWOfIZWAc4Y+1XuZqpaYb1Dl
         Lq/6J/k1zlTXMomdMWFS0bvU/fOpQLec++y0VPx2Rvl6uYTBRaKfNSkASecQetOT3vTT
         VPYQ==
X-Gm-Message-State: AOAM530gjMk2ox9T17ZrRIbwPr9fHNIBMQ+gmCSJEYnoKNFeWa7Nd2C9
        BbDahychMKA93E+JintDipxJ9ZZRnKvQAA==
X-Google-Smtp-Source: ABdhPJx5WnQoT9hj5Gx/8wzVmUiaEQ0UPftmgRh0OeJPF8HbcT05TMPBTFMV1lcrdTKoE4hvZAt/qg==
X-Received: by 2002:a1c:5417:: with SMTP id i23mr12877043wmb.17.1634730177630;
        Wed, 20 Oct 2021 04:42:57 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id 186sm4988989wmc.20.2021.10.20.04.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 04:42:57 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        michael.tuexen@lurchi.franken.de
Subject: [PATCH net 5/7] sctp: add vtag check in sctp_sf_violation
Date:   Wed, 20 Oct 2021 07:42:45 -0400
Message-Id: <5be6dfdbfa3b618e169c5d03e2b1109310ac5938.1634730082.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1634730082.git.lucien.xin@gmail.com>
References: <cover.1634730082.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sctp_sf_violation() is called when processing HEARTBEAT_ACK chunk
in cookie_wait state, and some other places are also using it.

The vtag in the chunk's sctphdr should be verified, otherwise, as
later in chunk length check, it may send abort with the existent
asoc's vtag, which can be exploited by one to cook a malicious
chunk to terminate a SCTP asoc.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_statefuns.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 96a069d725e9..36328ab88bdd 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -4669,6 +4669,9 @@ enum sctp_disposition sctp_sf_violation(struct net *net,
 {
 	struct sctp_chunk *chunk = arg;
 
+	if (!sctp_vtag_verify(chunk, asoc))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	/* Make sure that the chunk has a valid length. */
 	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_chunkhdr)))
 		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
-- 
2.27.0

