Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28FB719D9AD
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 17:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404057AbgDCPCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 11:02:42 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40510 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727431AbgDCPCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 11:02:42 -0400
Received: by mail-pf1-f195.google.com with SMTP id c20so3590921pfi.7;
        Fri, 03 Apr 2020 08:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=4YpqHPmNjdfxD+myCwE9+ZdlqOWWnIhvap42vDlW798=;
        b=sISnmSPcQUnG1+CR35He0jcyyZyBGwKTWKyDSFrNM/S9qy8OVb4+JYtyjMQOypvWyg
         iBKYArDegkYwzJT5pwI7R7ENEDzI6Eak6q8679Nls9+o0IPBrZ0GOTEHfRgYmm0kNV3p
         uDF9xsFaMrxD1RYpMKyeuznDuOFYE1Gu21HJimEeOH+AqvF1om619BPvgpaJICuuRVbI
         TSQKz8X8BP/uO7WJgXgDCiBmJTqDcme4Keq9uWUHUVocQcfImgXhfv9tRBPtF5fJZA3Q
         gF6SYKl7KyzssJimAiTdGUuShlg1k5QL7RZvxMsREKg6oAj6ZrEdgWw//yZcur9w+4Hp
         zf3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=4YpqHPmNjdfxD+myCwE9+ZdlqOWWnIhvap42vDlW798=;
        b=Tt0kcLgyuleEb/0lvtmBBb/YzI+WgjbvrSZFR5pO6xeYfmnktYqaBRiWuVRxOGRx5V
         /WEd9GF6xNPlmA7KbnxH8IhVASsyyaog0/kN55KKpS48CyIeSVvo1UTgaZndol1JsiVo
         fHUWR20mOwREDV0aEeNqHAo/d890VU1C+Pavm+Nd4Gru76M5O33Q2BJPBmRTpNOjrrvd
         C68cr/uUmX0El/mTacZ0bJ5kptV640OVCAcsjNRy5yX1H8E6HLI2XHXlF5HO4IRptpvd
         351uW+zKvCJ4KxDsTkk09L6bgIcs2gXLEsGR/HfA18AQld1haDaLqlN4BtSzrczTdN5t
         pDdg==
X-Gm-Message-State: AGi0PublQ0OalzLdnmpmDrnH3/IVLZlKFVatli/PYNKSN6SfDSv0y5/Q
        4qSFr0KX2hw78V9klhdY2UM=
X-Google-Smtp-Source: APiQypKOgoKXjp5DVMVFL0ACh1yz1W4cr8fCOv0VenqUDwxhDd+6Lh3NNbb28N+UoFqSOvYXcOX61A==
X-Received: by 2002:a63:ff4e:: with SMTP id s14mr8723561pgk.269.1585926159581;
        Fri, 03 Apr 2020 08:02:39 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id hg20sm5928383pjb.3.2020.04.03.08.02.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 Apr 2020 08:02:38 -0700 (PDT)
From:   Guenter Roeck <linux@roeck-us.net>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Sonny Sasaka <sonnysasaka@chromium.org>
Subject: [PATCH] Bluetooth: Simplify / fix return values from tk_request
Date:   Fri,  3 Apr 2020 08:02:36 -0700
Message-Id: <20200403150236.74232-1-linux@roeck-us.net>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some static checker run by 0day reports a variableScope warning.

net/bluetooth/smp.c:870:6: warning:
	The scope of the variable 'err' can be reduced. [variableScope]

There is no need for two separate variables holding return values.
Stick with the existing variable. While at it, don't pre-initialize
'ret' because it is set in each code path.

tk_request() is supposed to return a negative error code on errors,
not a bluetooth return code. The calling code converts the return
value to SMP_UNSPECIFIED if needed.

Fixes: 92516cd97fd4 ("Bluetooth: Always request for user confirmation for Just Works")
Cc: Sonny Sasaka <sonnysasaka@chromium.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 net/bluetooth/smp.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index d0b695ee49f6..30e8626dd553 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -854,8 +854,7 @@ static int tk_request(struct l2cap_conn *conn, u8 remote_oob, u8 auth,
 	struct l2cap_chan *chan = conn->smp;
 	struct smp_chan *smp = chan->data;
 	u32 passkey = 0;
-	int ret = 0;
-	int err;
+	int ret;
 
 	/* Initialize key for JUST WORKS */
 	memset(smp->tk, 0, sizeof(smp->tk));
@@ -887,12 +886,12 @@ static int tk_request(struct l2cap_conn *conn, u8 remote_oob, u8 auth,
 	/* If Just Works, Continue with Zero TK and ask user-space for
 	 * confirmation */
 	if (smp->method == JUST_WORKS) {
-		err = mgmt_user_confirm_request(hcon->hdev, &hcon->dst,
+		ret = mgmt_user_confirm_request(hcon->hdev, &hcon->dst,
 						hcon->type,
 						hcon->dst_type,
 						passkey, 1);
-		if (err)
-			return SMP_UNSPECIFIED;
+		if (ret)
+			return ret;
 		set_bit(SMP_FLAG_WAIT_USER, &smp->flags);
 		return 0;
 	}
-- 
2.17.1

