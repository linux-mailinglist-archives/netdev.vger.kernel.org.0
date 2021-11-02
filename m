Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2407442D75
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 13:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbhKBMFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 08:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbhKBMFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 08:05:35 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6559BC061714;
        Tue,  2 Nov 2021 05:03:00 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id n2so18598971qta.2;
        Tue, 02 Nov 2021 05:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T44CZRmnaWPBQSGS+Pwv2sHWRWGvq0ZanEywQcWcUM0=;
        b=at9TbhefYUpM4GGOGAyTWcijQCrS4lSzG2nN33x0Qn5FRggbmj/zrMy+Jl68K3YMTI
         ir6ZLzIlHqXFUqfEIomsHdxrwzZLw8q647V+aMUaIQV4Vl8JtE7SPCoBu3JruppfB3Zq
         S4AYUd55nIaBegaZJ2NsivfAjYXmzVm9X0LCER23gijGr+HkufRD5hQbvSvGFeX3RLOt
         D433oEqnAvio9OdaglFLibrCPZttVaikl1Dhlo329+jL4RupeOLUHLwHD8Qn3kQ3Fxpl
         jtN8gUQst9JaDDp052WUScMXt7v9liNrFaAmpPknbPhCxBIgIsLuhWVgs5zWZjDYWv+G
         MlFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T44CZRmnaWPBQSGS+Pwv2sHWRWGvq0ZanEywQcWcUM0=;
        b=TZhV/ncdsZ3+Cr3y6rf/rWniGmcdTvMbO9RIMVDrpXqfNNwf3YQ+qAjLhmX4tw/yOt
         B7NKNoPupSTtuplS/guuIp1h2dsMbmxPXD7l5pjJZf2hCfctuGS+xnqKtu2hjJ1KmjEm
         H1/gTWQLQwDca+jpgHR/vOM04yLzYv0IWDSjQdcn6UsUmz/jGbQz/bCWFmJ+nljYYDrs
         1EMtVwpPbISkqtWt0wumALTr7uNliHuXWC+UcriQES6Z/O4qlTEjfJE3Rrd1BHci69Ew
         0K/ZznPOROV5uC8elIDfmXhx4MuM2xUG33nlRACiIgbpXN1sVDQaIvcpO4Tra+D4BU1R
         YL3Q==
X-Gm-Message-State: AOAM532Sp5dO5y5bgbFMMuW/h7o5MYeDIUkcruInhlBqFzzYBHaRmq3A
        g5YzyOG1sfohax1lSrkbq/Q05zqn/SRbvcAC
X-Google-Smtp-Source: ABdhPJwqrls12Pwd0Cqxm8B2xKOByRaV2WV+gBcoUMsKVWZ4GAmy88q717EFGNMgE+Krq9HtxOZmyQ==
X-Received: by 2002:ac8:5916:: with SMTP id 22mr11478576qty.288.1635854579011;
        Tue, 02 Nov 2021 05:02:59 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id w9sm12498988qko.19.2021.11.02.05.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 05:02:58 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, selinux@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        James Morris <jmorris@namei.org>,
        Paul Moore <paul@paul-moore.com>,
        Richard Haines <richard_c_haines@btinternet.com>,
        Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCHv2 net 4/4] security: implement sctp_assoc_established hook in selinux
Date:   Tue,  2 Nov 2021 08:02:50 -0400
Message-Id: <cdca8eaca8a0ec5fe4aa58412a6096bb08c3c9bc.1635854268.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1635854268.git.lucien.xin@gmail.com>
References: <cover.1635854268.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Different from selinux_inet_conn_established(), it also gives the
secid to asoc->peer_secid in selinux_sctp_assoc_established(),
as one UDP-type socket may have more than one asocs.

Note that peer_secid in asoc will save the peer secid for this
asoc connection, and peer_sid in sksec will just keep the peer
secid for the latest connection. So the right use should be do
peeloff for UDP-type socket if there will be multiple asocs in
one socket, so that the peeloff socket has the right label for
its asoc.

v1->v2:
  - call selinux_inet_conn_established() to reduce some code
    duplication in selinux_sctp_assoc_established(), as Ondrej
    suggested.
  - when doing peeloff, it calls sock_create() where it actually
    gets secid for socket from socket_sockcreate_sid(). So reuse
    SECSID_WILD to ensure the peeloff socket keeps using that
    secid after calling selinux_sctp_sk_clone() for client side.

Fixes: 72e89f50084c ("security: Add support for SCTP security hooks")
Reported-by: Prashanth Prahlad <pprahlad@redhat.com>
Reviewed-by: Richard Haines <richard_c_haines@btinternet.com>
Tested-by: Richard Haines <richard_c_haines@btinternet.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 security/selinux/hooks.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index a9977a2ae8ac..341cd5dccbf5 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5519,7 +5519,8 @@ static void selinux_sctp_sk_clone(struct sctp_association *asoc, struct sock *sk
 	if (!selinux_policycap_extsockclass())
 		return selinux_sk_clone_security(sk, newsk);
 
-	newsksec->sid = asoc->secid;
+	if (asoc->secid != SECSID_WILD)
+		newsksec->sid = asoc->secid;
 	newsksec->peer_sid = asoc->peer_secid;
 	newsksec->sclass = sksec->sclass;
 	selinux_netlbl_sctp_sk_clone(sk, newsk);
@@ -5575,6 +5576,16 @@ static void selinux_inet_conn_established(struct sock *sk, struct sk_buff *skb)
 	selinux_skb_peerlbl_sid(skb, family, &sksec->peer_sid);
 }
 
+static void selinux_sctp_assoc_established(struct sctp_association *asoc,
+					   struct sk_buff *skb)
+{
+	struct sk_security_struct *sksec = asoc->base.sk->sk_security;
+
+	selinux_inet_conn_established(asoc->base.sk, skb);
+	asoc->peer_secid = sksec->peer_sid;
+	asoc->secid = SECSID_WILD;
+}
+
 static int selinux_secmark_relabel_packet(u32 sid)
 {
 	const struct task_security_struct *__tsec;
@@ -7290,6 +7301,7 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(sctp_assoc_request, selinux_sctp_assoc_request),
 	LSM_HOOK_INIT(sctp_sk_clone, selinux_sctp_sk_clone),
 	LSM_HOOK_INIT(sctp_bind_connect, selinux_sctp_bind_connect),
+	LSM_HOOK_INIT(sctp_assoc_established, selinux_sctp_assoc_established),
 	LSM_HOOK_INIT(inet_conn_request, selinux_inet_conn_request),
 	LSM_HOOK_INIT(inet_csk_clone, selinux_inet_csk_clone),
 	LSM_HOOK_INIT(inet_conn_established, selinux_inet_conn_established),
-- 
2.27.0

