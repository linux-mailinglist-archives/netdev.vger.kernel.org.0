Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39FC07A8BC
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 14:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729651AbfG3Mim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 08:38:42 -0400
Received: from mail-pf1-f172.google.com ([209.85.210.172]:39015 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729579AbfG3Mim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 08:38:42 -0400
Received: by mail-pf1-f172.google.com with SMTP id f17so25792050pfn.6;
        Tue, 30 Jul 2019 05:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=jRxuOb7zwAcVT7wD6hp2DVBKlUFumFmll8rDZ2JODwk=;
        b=Asc5ALW02+hlWRXV6uGuJbLvcuuiyDkug/JYmxFHven+jd2TDy0ImkQDUDDOZJUcaD
         1P/aQw0T8UTgbPiH03qNIuXdsp/61wvBZCREbZHOPaQ4EsSMt+x0Bg9FHAeb4Pk9Zhg2
         Wv7oNekW89esdzYYpQu9W1RkijAgnPDcFN4gBmYKn0MhS7jEG3AtboVZwSENOFhfKV7W
         kmCikPLTSJIjYy5XPmTnnU8uvCc6+WatJAEOAMUQWcf6GwVCH5b5fIOjCgLmL+pRBzKb
         QGko5SAxGPD45e5SrtkMjdtS7t9S8wAEohFbdZV2FWhUj5PxpsHvWez0ocncbfzimGUQ
         TgCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=jRxuOb7zwAcVT7wD6hp2DVBKlUFumFmll8rDZ2JODwk=;
        b=OcG/jfVDGtg5L5lgRuhtgv2Hk+O6utDkuGXzDbB9WN4vyLXBgpE/XFn02y3aefGl+g
         vLg3CvTXZlrSw6xIL5bVX667oJyfw1QY6GRmTgfEbuMdWQtyfTaKof8pjPUJYlh5WLv6
         JWzQRj83IAMBd36Av0+nHQ777SK2X9haonkxThVKW81HYznfHblUol2l7uqJP5ZQPx2/
         V+mO9OAn+DeZ7fAD4sh9kniefoi57rI5u8Br8V6XYjJ5foYbpjTzH7vlKr2m+JdYYcu/
         trcAz/Qj2fWtjF2HXZHHKiODHaG4L8bxaCpk73+80amZnMP1/O9G5KYA8OBnNbh6MSA9
         3PVA==
X-Gm-Message-State: APjAAAUdtxSp/LVSkVwpEtKW53XugWQSxtCQ8/1AZI6wCnEkrf7nM3hF
        nas00KRmDEgJ7slOEpnPuJcSiGtE
X-Google-Smtp-Source: APXvYqzxxFW+ZYdJ7mA48OGCJNZYmIvetmniIep2m7QhSW5JdhB+N/GzKz9wIpXzat2PUKMKnAWIDA==
X-Received: by 2002:a63:d04e:: with SMTP id s14mr103738374pgi.189.1564490321079;
        Tue, 30 Jul 2019 05:38:41 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a128sm72701511pfb.185.2019.07.30.05.38.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 05:38:40 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCHv2 net-next 1/5] sctp: only copy the available addr data in sctp_transport_init
Date:   Tue, 30 Jul 2019 20:38:19 +0800
Message-Id: <bb6e9856c2db0f24b91fb326fbe3c9c013f2459b.1564490276.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1564490276.git.lucien.xin@gmail.com>
References: <cover.1564490276.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1564490276.git.lucien.xin@gmail.com>
References: <cover.1564490276.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'addr' passed to sctp_transport_init is not always a whole size
of union sctp_addr, like the path:

  sctp_sendmsg() ->
  sctp_sendmsg_new_asoc() ->
  sctp_assoc_add_peer() ->
  sctp_transport_new() -> sctp_transport_init()

In the next patches, we will also pass the address length of data
only to sctp_assoc_add_peer().

So sctp_transport_init() should copy the only available data from
addr to peer->ipaddr, instead of 'peer->ipaddr = *addr' which may
cause slab-out-of-bounds.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index e2f8e36..7235a60 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -43,8 +43,8 @@ static struct sctp_transport *sctp_transport_init(struct net *net,
 						  gfp_t gfp)
 {
 	/* Copy in the address.  */
-	peer->ipaddr = *addr;
 	peer->af_specific = sctp_get_af_specific(addr->sa.sa_family);
+	memcpy(&peer->ipaddr, addr, peer->af_specific->sockaddr_len);
 	memset(&peer->saddr, 0, sizeof(union sctp_addr));
 
 	peer->sack_generation = 0;
-- 
2.1.0

