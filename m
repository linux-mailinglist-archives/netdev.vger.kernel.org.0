Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F172A2202
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 23:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727373AbgKAWIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 17:08:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbgKAWIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 17:08:49 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82964C0617A6
        for <netdev@vger.kernel.org>; Sun,  1 Nov 2020 14:08:49 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id k188so7661378qke.3
        for <netdev@vger.kernel.org>; Sun, 01 Nov 2020 14:08:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=NKp1/xBXDkl0efhdXNrgYc0O7jfhOuUU7342EXqTwg4=;
        b=FsnpzJJWXhtPreieRoDxDeeMlTQBlq/mJJqfi2mvOuie/Fj9mmqbbp644xxA+7EH/H
         nEu7H3reDXz2RiMRJHutBkb5adCfGBDTW5GaEN7o/p7bBO7cGBJuAeV84qQ1KVtorK1w
         ktmk3CF+IyQtw4aGPFzI05sRg6Qq3c0gZebh6hHfG2yrCDL5qvFxab8lSGvrHUaDLubp
         0rCHIFcEz14jVVG3XFWfzVgyNPUmnBA8T8owbq/DSh7c7hcyBL//HVd3ouaqFEz4HkmE
         CkWnjchPAcxUN9Vxrcs/yz+cutc2vQ9rMRoYZLJQ57+V2TLBVDU+tK9OaI9e0MLW9P+H
         rnSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc:content-transfer-encoding;
        bh=NKp1/xBXDkl0efhdXNrgYc0O7jfhOuUU7342EXqTwg4=;
        b=e0Ng/mxHh7NKK4nmhicVesxLHB0Cw/DNYsstAtYvTkRqDI0PVX5SdeHiLXExgJapVn
         uhIrHf7ksJqXuuIfq6BFyrXRKXW5hI9BWyHAHmPzud9fk+ItCnij+xqQ+KaQSwKC4AT6
         jFucHxtHBsz1KFokveCIrMc8KXSQBAJojR48rcfbZnE7O/PEqXr8hNL/22EF/AOeNIZS
         WUfe+PSRjPCeM2x2jS3lODrVKunvoZdksOBYUADlQNzBy00VdJGLLUV/D5R5QQNnjYhY
         RNmYIB7axlBntLVRVp8h2agfhvZAQT55c/VH7ObbZvJkD+AnOqhVwQtrcrhc4fhjHu9S
         mybA==
X-Gm-Message-State: AOAM530vuC7LykZaNZkSoCtiaWZRURedclxrK+NVLoxYdatmf797ppN6
        HvuP2ilxFHqRc7IjGPnwpY/ShUJowmM=
X-Google-Smtp-Source: ABdhPJxP49gIPiKCuz6nQCcKDAcO3PZrEReCiIRv/Hl/O9yFNY5Xy2r0lt3sA3tBRNUVU6I+TBC4G7b5tu4=
Sender: "adelva via sendgmr" <adelva@adelva.mtv.corp.google.com>
X-Received: from adelva.mtv.corp.google.com ([2620:15c:211:200:3e52:82ff:fe5f:1593])
 (user=adelva job=sendgmr) by 2002:a0c:eec4:: with SMTP id h4mr19229603qvs.52.1604268527352;
 Sun, 01 Nov 2020 14:08:47 -0800 (PST)
Date:   Sun,  1 Nov 2020 14:08:45 -0800
Message-Id: <20201101220845.2391858-1-adelva@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.1.341.ge80a0c044ae-goog
Subject: [PATCH] xfrm/compat: Remove use of kmalloc_track_caller
From:   Alistair Delva <adelva@google.com>
To:     Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        kernel-team@android.com,
        "=?UTF-8?q?Maciej=20=C5=BBenczykowski?=" <maze@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The __kmalloc_track_caller symbol is not exported if SLUB/SLOB are
enabled instead of SLAB, which breaks the build on such configs when
CONFIG_XFRM_USER_COMPAT=3Dm.

ERROR: "__kmalloc_track_caller" [net/xfrm/xfrm_compat.ko] undefined!

Other users of this symbol are 'bool' options, but changing this to
bool would require XFRM_USER to be built in as well, which doesn't
seem worth it. Go back to kmalloc().

Fixes: 96392ee5a13b9 ("xfrm/compat: Translate 32-bit user_policy from sockp=
tr")
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Maciej =C5=BBenczykowski <maze@google.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Alistair Delva <adelva@google.com>
---
 net/xfrm/xfrm_compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_compat.c b/net/xfrm/xfrm_compat.c
index e28f0c9ecd6a..c1dee0696dfb 100644
--- a/net/xfrm/xfrm_compat.c
+++ b/net/xfrm/xfrm_compat.c
@@ -585,7 +585,7 @@ static int xfrm_user_policy_compat(u8 **pdata32, int op=
tlen)
 	if (optlen < sizeof(*p))
 		return -EINVAL;
=20
-	data64 =3D kmalloc_track_caller(optlen + 4, GFP_USER | __GFP_NOWARN);
+	data64 =3D kmalloc(optlen + 4, GFP_USER | __GFP_NOWARN);
 	if (!data64)
 		return -ENOMEM;
=20
--=20
2.29.1.341.ge80a0c044ae-goog

