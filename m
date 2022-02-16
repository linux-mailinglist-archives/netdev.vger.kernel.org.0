Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0C934B8B70
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 15:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235041AbiBPOci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 09:32:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235032AbiBPOch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 09:32:37 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B6B9E57A
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 06:32:24 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id m185so2426691iof.10
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 06:32:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NE7EY8xDj/IqqOA16SqMQVmbg8CT9KQUqq/vPjFlZhI=;
        b=I/j6kvCD8Y0jU5HzdduK6zPqGJBLpG2zrXvbLUcD3UZxNBcIQId25DctMd8SoQ42Vm
         o2otTRInzpGJc+V+B8dHDfk28fmn5DzuUTXtp6oy7v5DmIwhxYQ1HavOOu3fp6N6NP4e
         quS8iebcC0vkB1q4pAvovLeLidzDnLB3bldNY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NE7EY8xDj/IqqOA16SqMQVmbg8CT9KQUqq/vPjFlZhI=;
        b=pibOemxEr49nNXukBe1YrdsFC0b1j3+kEhD0PFrTgxTE7gP0lDKlIkRfP/VyImQZzS
         RUchrCJ75FLvyQLiOZfKjho0jNtZZihdKnx3fxF9yo+1IlIg7FlxeLABCZs2Qu16sIyd
         b845/UaYv/PTMYi2qyk5tWLfFLBOkUWptoGjX5Zb4PG6IvEFCPfJx0fNM+zkhAChHq2n
         KsZD+XWldxPUyJgQt7QhMcWGWudVCdtg6/w7WQtIAye2GA4afn5moOmmU3OLNWPfX2Hn
         NNo+MXDp4e2UBeELB6I46WNjd8I0vDaCN8QhsXS17NjcOYtbPoVrQ+jbSirTrFb0ZAu9
         EzjA==
X-Gm-Message-State: AOAM533vaf41nw6z4ZZlffldhF7xWfzXApmkiuVoq5q4oRtvtlJB+dtV
        qPE1c366te+VzKRdk23ZgsNJ7g==
X-Google-Smtp-Source: ABdhPJxwl2buTtN73WTffUyIG4lljbaAylrEept42cxMmXsmI3BXhYgn0ZWT3qL5pWwvaSpqxNoxIg==
X-Received: by 2002:a02:7742:0:b0:311:626c:d554 with SMTP id g63-20020a027742000000b00311626cd554mr1853496jac.134.1645021943659;
        Wed, 16 Feb 2022 06:32:23 -0800 (PST)
Received: from localhost ([2605:a601:ac0f:820:35a8:1556:a044:f8bb])
        by smtp.gmail.com with ESMTPSA id q9sm8926475ilo.56.2022.02.16.06.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 06:32:23 -0800 (PST)
From:   Seth Forshee <sforshee@digitalocean.com>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] vsock: remove vsock from connected table when connect is interrupted by a signal
Date:   Wed, 16 Feb 2022 08:32:22 -0600
Message-Id: <20220216143222.1614690-1-sforshee@digitalocean.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vsock_connect() expects that the socket could already be in the
TCP_ESTABLISHED state when the connecting task wakes up with a signal
pending. If this happens the socket will be in the connected table, and
it is not removed when the socket state is reset. In this situation it's
common for the process to retry connect(), and if the connection is
successful the socket will be added to the connected table a second
time, corrupting the list.

Prevent this by calling vsock_remove_connected() if a signal is received
while waiting for a connection. This is harmless if the socket is not in
the connected table, and if it is in the table then removing it will
prevent list corruption from a double add.

Signed-off-by: Seth Forshee <sforshee@digitalocean.com>
---
 net/vmw_vsock/af_vsock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 3235261f138d..38baeb189d4e 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1401,6 +1401,7 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
 			sk->sk_state = sk->sk_state == TCP_ESTABLISHED ? TCP_CLOSING : TCP_CLOSE;
 			sock->state = SS_UNCONNECTED;
 			vsock_transport_cancel_pkt(vsk);
+			vsock_remove_connected(vsk);
 			goto out_wait;
 		} else if (timeout == 0) {
 			err = -ETIMEDOUT;
-- 
2.32.0

