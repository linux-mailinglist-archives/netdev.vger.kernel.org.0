Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4223C3E51E4
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 06:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237312AbhHJESD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 00:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237226AbhHJER4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 00:17:56 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443B9C0617A1;
        Mon,  9 Aug 2021 21:17:24 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id l11so7605646plk.6;
        Mon, 09 Aug 2021 21:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SvgciiztrVef8p8zryOlzKMWIbOXm14bnkz3tLt2Ce0=;
        b=BUnnRx+X4v+1TL2k/V2JSTPEo9aZKCrlBiUXDBNMmj2qULjq+uWnxD26UxR3lMTexU
         Y1IbO4KeN1RWknPDtprm+kuFAkvtHuy+Rg2EZWtEeeX92R2IW8V/D6ihkMeZaKE4CqQM
         rm/pVNEGvdwzleQzKqxFhcO9U2aBMac2Ej6S7ejapBsZiG/BOsAKi5S+QIplBduWFvYO
         zTo++1I0l9Lcin+KeB25+mLD24fuiBwOk5k9G7jO9dRJ3Hy/R/9HfvPscihKBhpdAQy2
         6chz9ohNsU/noQUo4hIqjIgaynaQheYVolooSqy5Jsnifoced07RTeUbq4xcSgcwhXAn
         KeVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SvgciiztrVef8p8zryOlzKMWIbOXm14bnkz3tLt2Ce0=;
        b=gV5FvNTr+pg2aE1EccgbfgEciS2PS4oD8jiSYXf9n7QKLc60wjryTds+DEldxwdwml
         eNDDWkOUcB9X22o/lm/wl1EAa150ss1s0Rt1ofT6Voe/drXKDgNyHmbGU5X/yuXPDGRH
         gsSOKHIU2SNQrb3V66gfMGeD1k+KZINm9LA0KGmtYOAw7DTypIToFgHb6Fgv3n4/GOu1
         FCD4g7pBmcsOV7SSPQKuk46LgxtRx/wQoIArt5p+Y63V8LSvRrrF6Y97DAKxG/BDMnhT
         prhIDMHECW5/ulVMt7ETDXEWI9IC4CwcnSk+jcU4+JE1xF9tiQFbXLzhc+yELaruUROo
         ua7Q==
X-Gm-Message-State: AOAM530svx9+OEFBKiOR5stKtNXrgTJuiF+1wxDpPut8q690yqfZZWJd
        rNfRf0vR8BumUy1azWvLjhw=
X-Google-Smtp-Source: ABdhPJyST7kdXNemvcmeYieJUDOCfvnVJRXrwbmK/xqHiFmHBNjJ96w9TdavrCr2KZ6DrKZpwpEcxg==
X-Received: by 2002:a65:6910:: with SMTP id s16mr37421pgq.270.1628569043859;
        Mon, 09 Aug 2021 21:17:23 -0700 (PDT)
Received: from localhost.localdomain ([118.200.190.93])
        by smtp.gmail.com with ESMTPSA id b8sm20132478pjo.51.2021.08.09.21.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 21:17:23 -0700 (PDT)
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org, sudipm.mukherjee@gmail.com
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
        gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH v6 4/6] Bluetooth: serialize calls to sco_sock_{set,clear}_timer
Date:   Tue, 10 Aug 2021 12:14:08 +0800
Message-Id: <20210810041410.142035-5-desmondcheongzx@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210810041410.142035-1-desmondcheongzx@gmail.com>
References: <20210810041410.142035-1-desmondcheongzx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, calls to sco_sock_set_timer are made under the locked
socket, but this does not apply to all calls to sco_sock_clear_timer.

Both sco_sock_{set,clear}_timer should be serialized by lock_sock to
prevent unexpected concurrent clearing/setting of timers.

Additionally, since sco_pi(sk)->conn is only cleared under the locked
socket, this change allows us to avoid races between
sco_sock_clear_timer and the call to kfree(conn) in sco_conn_del.

Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
---
 net/bluetooth/sco.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 68b51e321e82..77490338f4fa 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -453,8 +453,8 @@ static void __sco_sock_close(struct sock *sk)
 /* Must be called on unlocked socket. */
 static void sco_sock_close(struct sock *sk)
 {
-	sco_sock_clear_timer(sk);
 	lock_sock(sk);
+	sco_sock_clear_timer(sk);
 	__sco_sock_close(sk);
 	release_sock(sk);
 	sco_sock_kill(sk);
@@ -1104,8 +1104,8 @@ static void sco_conn_ready(struct sco_conn *conn)
 	BT_DBG("conn %p", conn);
 
 	if (sk) {
-		sco_sock_clear_timer(sk);
 		lock_sock(sk);
+		sco_sock_clear_timer(sk);
 		sk->sk_state = BT_CONNECTED;
 		sk->sk_state_change(sk);
 		release_sock(sk);
-- 
2.25.1

