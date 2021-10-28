Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F74043DDE2
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 11:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbhJ1JjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 05:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbhJ1JjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 05:39:16 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E847C061570;
        Thu, 28 Oct 2021 02:36:49 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id w1so3283016edd.0;
        Thu, 28 Oct 2021 02:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x1A5pRhcW9q68s/vm/42s6cTh/b679cMZFrfrXosCU0=;
        b=MTbvp3SgoJR8NWLaSSNBIc+rqyFSbL+lM4sfem9P6p9GsJi645BZ1qEIeU56oMrMSF
         d+P95lu7vu99b2ArifPG1Xfwl8OrXsZsqDbCXR4BDRHH+kXnoX00YahpLNUMPZfYfJMT
         je+UwQ8PYB8O1qj7u9B1+8EEAfhOnNz6t56I/AIg1Fv4IfcsjQWl+c1HONOJXlinq3l+
         xVTq8ehdoXkiItPKPUC8Xj4O8FlrTDuR6dMmQsEWbXPAKIDPBA2dFf7JbvtEqN8crnG4
         qYE+fjoQcah2rSpG455qwg4NU+tVcNS1/yVAJ81xJx7eA3BLdXrReEVyHNk7tq312eIp
         LkHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x1A5pRhcW9q68s/vm/42s6cTh/b679cMZFrfrXosCU0=;
        b=4nOgtTEzpo0jkzzwDlCAIMonhdSzQYwu86fP80fEuW2kAH9WZ4aLKe4AgqNFLiEntW
         9jz/ePF0H94xIaZ/Y96phBMewoW0qu2g52gPeyAmOj26DxThUGS2IckpU7mdS2l7qlNO
         pMve3dWkQ+ydy9rdVyPSKjNfoRoMTRyI87yw/3klOg2y7kDQ+A48reegwPna+etdyGvz
         U4B4rtxkga6pfuE6hsHs+qIS73Mbh1WEGTn+wqPDbU3VoT0Ohb8aJn0v76Hvkwn/QC97
         QPyuQlpOAdsRfIwp517o81WQYmaEpeTBaDd5srMv/KbENfvqYxC1lh+1jGxKbSE1rJc4
         J4FQ==
X-Gm-Message-State: AOAM533F9ZqxLLFmOPlyTPkZoxLcDj9nFN/HjDFseFNz6hiN0p9r6srg
        8DloymoK/5MTbXZnEEcAPhfkKJ0F7eOUwg==
X-Google-Smtp-Source: ABdhPJw8SEOrKiHHto3u3POc4uUiI6XuO5Xpxg19nDSG+Oby2bTFmS9imZREs7jOM3X/VA5bsxDHcQ==
X-Received: by 2002:a17:906:c28d:: with SMTP id r13mr4066609ejz.102.1635413806866;
        Thu, 28 Oct 2021 02:36:46 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id s12sm1379865edc.48.2021.10.28.02.36.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 02:36:46 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net 3/4] sctp: subtract sctphdr len in sctp_transport_pl_hlen
Date:   Thu, 28 Oct 2021 05:36:03 -0400
Message-Id: <5f9e29853938b5ad1cdb5e1a1de14ebcd04b58d8.1635413715.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1635413715.git.lucien.xin@gmail.com>
References: <cover.1635413715.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sctp_transport_pl_hlen() is called to calculate the outer header length
for PL. However, as the Figure in rfc8899#section-4.4:

   Any additional
     headers         .--- MPS -----.
            |        |             |
            v        v             v
     +------------------------------+
     | IP | ** | PL | protocol data |
     +------------------------------+

                <----- PLPMTU ----->
     <---------- PMTU -------------->

Outer header are IP + Any additional headers, which doesn't include
Packetization Layer itself header, namely sctphdr, whereas sctphdr
is counted by __sctp_mtu_payload().

The incorrect calculation caused the link pathmtu to be set larger
than expected by t->pl.pmtu + sctp_transport_pl_hlen(). This patch
is to fix it by subtracting sctphdr len in sctp_transport_pl_hlen().

Fixes: d9e2e410ae30 ("sctp: add the constants/variables and states and some APIs for transport")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/sctp.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index bc00410223b0..189fdb9db162 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -626,7 +626,8 @@ static inline __u32 sctp_min_frag_point(struct sctp_sock *sp, __u16 datasize)
 
 static inline int sctp_transport_pl_hlen(struct sctp_transport *t)
 {
-	return __sctp_mtu_payload(sctp_sk(t->asoc->base.sk), t, 0, 0);
+	return __sctp_mtu_payload(sctp_sk(t->asoc->base.sk), t, 0, 0) -
+	       sizeof(struct sctphdr);
 }
 
 static inline void sctp_transport_pl_reset(struct sctp_transport *t)
-- 
2.27.0

