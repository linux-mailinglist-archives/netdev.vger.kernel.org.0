Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC1837A047
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 09:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbhEKHFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 03:05:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47400 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230375AbhEKHFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 03:05:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620716649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=M5SLMtOJ4pPAk2pyPXgLUn5MH1X0rZ/S6qlMjU3TY40=;
        b=Mp/2ulcUHh32EzBq6MJcQa3/VhqcD/yCzFVXwWEwuBqHBdrtgU2JB3kgoEsZBHx6p44q/V
        owtutSxLZ3OgFHFDDo2+h3lw6USU2b2peergzG0UtZceTkOrjhdyU34pWld1y+InvpXYcz
        UBDIhMlCQ68kRbIEzsU/txOshdZ+MfU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-P0i_Ied0NtyPIO4VyNkndg-1; Tue, 11 May 2021 03:04:05 -0400
X-MC-Unique: P0i_Ied0NtyPIO4VyNkndg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 086716D504;
        Tue, 11 May 2021 07:04:04 +0000 (UTC)
Received: from localhost.localdomain (ovpn-112-191.ams2.redhat.com [10.36.112.191])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E3DCD2E175;
        Tue, 11 May 2021 07:04:00 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] BRCM80211: improve readability on addresses copy
Date:   Tue, 11 May 2021 09:02:58 +0200
Message-Id: <20210511070257.7843-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A static analyzer identified as a potential bug the copy of
12 bytes from a 6 bytes array to a 6 bytes array. Both
arrays are 6 bytes addresses.

Although not being a real bug, it is not immediately clear
why is done this way: next 6 bytes address, contiguous to
the first one, must also be copied to next contiguous 6 bytes
address of the destination.

Copying each one separately will make both static analyzers
and reviewers happier.

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
index 763e0ec583d7..26de1bd7fee9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
@@ -6607,7 +6607,8 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 			rts->frame_control = cpu_to_le16(IEEE80211_FTYPE_CTL |
 							 IEEE80211_STYPE_RTS);
 
-			memcpy(&rts->ra, &h->addr1, 2 * ETH_ALEN);
+			memcpy(&rts->ra, &h->addr1, ETH_ALEN);
+			memcpy(&rts->ta, &h->addr2, ETH_ALEN);
 		}
 
 		/* mainrate
-- 
2.31.1

