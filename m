Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE2B419A370
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 04:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731588AbgDACIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 22:08:04 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35694 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731550AbgDACIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 22:08:04 -0400
Received: by mail-qt1-f194.google.com with SMTP id e14so20429276qts.2
        for <netdev@vger.kernel.org>; Tue, 31 Mar 2020 19:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pGwmPBLtvKJpnJ7pW/ygYpFxkTUq8xisMQHGORzABHg=;
        b=NgFdbQR/wAsb4Rs1wKTcn4TFsRKoQhTHzdNrR1gv1EhDkrFGxpdlzPBDxiVoFNUNmk
         feacCc9voHYlTk2lv4HrVJJq4eOP94oWlFXu/Xczbc5Rx+PmS/jHOWhQ2tOe8WxvjS9r
         kLPmc2AJLM+L6tg52M5er4fqcPdcn0kGb+SMkfoG+SIhHvni56NZrbXZ39ZdFCm5i7Ws
         5kingIazwZDFhc06H26Y10UgJYO84MzhHnOrTv6lqTw2XbkaCqlavU5SrKyTHmJwhqgx
         VKTJvNmjqdj6TZAzVaLCLrc2w3LNDrpXZQi3tbt4axsKr5kkWpVBgHFrT9RHPr9kqqTM
         acmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pGwmPBLtvKJpnJ7pW/ygYpFxkTUq8xisMQHGORzABHg=;
        b=Z9TiwrOjRjtpksjVljzWq4K06vHQ+NeeTszA2KB+XmW+Z8NX63XbmAt5KnvEF2j3c1
         16sxL5/kTK/kvzbTQVKh1yTwIjVpkaOUfXN6Oim40NPc5Z4Reyj0UbxQyneM28jGpl5i
         jDPvA2tepQiLvViIGgw2YzMfQWG722M1FKiofvP0nH4IvvqJTp+CUZS8kvou1j8EgELz
         rRdSaHmYoPY9nPHLsJCT10zMCZ5ztuMNq8JKyQxLLIb5v8y8OuqJbvGell+ChjYC2J7M
         Q47782jZ3uuCoyUha7Yd/0jStCwLIdGk9+E0NAibe0ujFz+44XOyiTB0/Hf90Cjd9t6e
         6yxg==
X-Gm-Message-State: ANhLgQ3DcDmIQ3L0jXOruuFCiYrNhupoGsFWK+9N4YNiQYRrCb69CK1H
        clpv4MFxLjOgf++ddh6Fg36V9SV13rU=
X-Google-Smtp-Source: ADFU+vvjMDbDuq/8uzDSpbxNhc0pNJ9Oi6BwU/wStZI1/zSpIm8AYuSuwpXCtWnY9i6D8tfFHQVWEw==
X-Received: by 2002:ac8:2224:: with SMTP id o33mr8351251qto.263.1585706883132;
        Tue, 31 Mar 2020 19:08:03 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n67sm486517qte.79.2020.03.31.19.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 19:08:02 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, eric.dumazet@gmail.com,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net-next] neigh: support smaller retrans_time settting
Date:   Wed,  1 Apr 2020 10:07:49 +0800
Message-Id: <20200401020749.2608-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200331033356.29956-1-liuhangbin@gmail.com>
References: <20200331033356.29956-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, we limited the retrans_time to be greater than HZ/2. i.e.
setting retrans_time less than 500ms will not work. This makes the user
unable to achieve a more accurate control for bonding arp fast failover.

Update the sanity check to HZ/100, which is 10ms, to let users have more
ability on the retrans_time control.

v2: use HZ instead of hard code number

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/core/neighbour.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 5bf8d22a47ec..46a5611a9f3d 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1125,7 +1125,7 @@ int __neigh_event_send(struct neighbour *neigh, struct sk_buff *skb)
 			neigh->nud_state     = NUD_INCOMPLETE;
 			neigh->updated = now;
 			next = now + max(NEIGH_VAR(neigh->parms, RETRANS_TIME),
-					 HZ/2);
+					 HZ/100);
 			neigh_add_timer(neigh, next);
 			immediate_probe = true;
 		} else {
-- 
2.19.2

