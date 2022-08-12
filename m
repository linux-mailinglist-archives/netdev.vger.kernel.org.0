Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 559B5590B9F
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 07:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237008AbiHLFyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 01:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiHLFyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 01:54:52 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A007A222D
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 22:54:51 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id z19so18813318plb.1
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 22:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=to:from:cc:content-transfer-encoding:mime-version:message-id:date
         :subject:from:to:cc;
        bh=HEmnO6gKg/Ny8un1UXhsJJIoNDtb7QUrGLbN/Rj+U2s=;
        b=S6h2JsqkYWxvS7jC1PPYrCoWtVa1c7jhqkVfdgVTRawsQeU2o7qd8syCitbKL3Igry
         a2vspnYwiX6atjvhYOj/vgZm9OOs8OD2WVJ/uQMFT1JSzXM/f6+wpg5tjONYx5mXVrYk
         QMx5u3F0tiwy+Pgj/g0dpXjvsnBKPsStW07oA+hI2mlUWmshJ9YYA8VYd58ZYpT9Sff+
         soe+nCeH5MvE3QIats2gqq3natPebdib/4PCZ+ZVA3LIKmcaYBq9+ZZ0aGOcCufe2Zbk
         1agEwVe66MkKDSIryjo+6X+jlL2BoyUqn4gP4pMrGcv3ahE2DIJVIeuNibm5w0pb9rjy
         ysqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:cc:content-transfer-encoding:mime-version:message-id:date
         :subject:x-gm-message-state:from:to:cc;
        bh=HEmnO6gKg/Ny8un1UXhsJJIoNDtb7QUrGLbN/Rj+U2s=;
        b=FLqUdrizL6yUxBELXSkAk2/ZDz5DOMfC3tQMoKD/8ctwYjwMsSaEOrfbEI6oHEVsu5
         dLGF4xZC0sYo/pSq+qu6lXBa20LUvvHjYcxhwz/3ZRB5bJkZ/2nUvltmeQpx4condc+T
         KyylZkVofW0RwNAB7Z0pRlBwvt3ovEw5+VqtOnePKn1vKPUAmfV9q7txSzGMw3bBogNP
         ueET2h2rg1A7MFngcEP9U/OXcPL19CO9JU+nklpwaSydoZmBO6RgPt4R6OZJ8igFN9WD
         6h4cemtMdH3GcvkVSaVVivA6p82Us4SDoTnsQ/7biQIDCtPW1BD3fnRhZMvAjmqx2aLg
         6WoQ==
X-Gm-Message-State: ACgBeo2jLkdN4Glii0Snr9NEd1fBDO3udza7c71Fv/y0ZMUH/bjeWyLi
        KKHCGtsSse9Skcpo/Fe0i7GVPg==
X-Google-Smtp-Source: AA6agR6wDPIXSDkF+CszeF/rMBh6TQvpmXARS1enqN+Ysw0cl5HOZUKV33pVKo+76S2g+k+swpD2Cg==
X-Received: by 2002:a17:902:b607:b0:170:c7fc:388a with SMTP id b7-20020a170902b60700b00170c7fc388amr2474205pls.29.1660283690611;
        Thu, 11 Aug 2022 22:54:50 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id z185-20020a6333c2000000b0041aeb36088asm659096pgz.16.2022.08.11.22.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 22:54:50 -0700 (PDT)
Subject: [PATCH] Bluetooth: L2CAP: Elide a string overflow warning
Date:   Thu, 11 Aug 2022 22:52:49 -0700
Message-Id: <20220812055249.8037-1-palmer@rivosinc.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc:     luiz.dentz@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@rivosinc.com,
        Palmer Dabbelt <palmer@rivosinc.com>
From:   Palmer Dabbelt <palmer@rivosinc.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Palmer Dabbelt <palmer@rivosinc.com>

Without this I get a string op warning related to copying from a
possibly NULL pointer.  I think the warning is spurious, but it's
tripping up allmodconfig.

In file included from /scratch/merges/ko-linux-next/linux/include/linux/string.h:253,
                 from /scratch/merges/ko-linux-next/linux/include/linux/bitmap.h:11,
                 from /scratch/merges/ko-linux-next/linux/include/linux/cpumask.h:12,
                 from /scratch/merges/ko-linux-next/linux/include/linux/mm_types_task.h:14,
                 from /scratch/merges/ko-linux-next/linux/include/linux/mm_types.h:5,
                 from /scratch/merges/ko-linux-next/linux/include/linux/buildid.h:5,
                 from /scratch/merges/ko-linux-next/linux/include/linux/module.h:14,
                 from /scratch/merges/ko-linux-next/linux/net/bluetooth/l2cap_core.c:31:
In function 'memcmp',
    inlined from 'bacmp' at /scratch/merges/ko-linux-next/linux/include/net/bluetooth/bluetooth.h:347:9,
    inlined from 'l2cap_global_chan_by_psm' at /scratch/merges/ko-linux-next/linux/net/bluetooth/l2cap_core.c:2003:15:
/scratch/merges/ko-linux-next/linux/include/linux/fortify-string.h:44:33: error: '__builtin_memcmp' specified bound 6 exceeds source size 0 [-Werror=stringop-overread]
   44 | #define __underlying_memcmp     __builtin_memcmp
      |                                 ^
/scratch/merges/ko-linux-next/linux/include/linux/fortify-string.h:420:16: note: in expansion of macro '__underlying_memcmp'
  420 |         return __underlying_memcmp(p, q, size);
      |                ^~~~~~~~~~~~~~~~~~~
In function 'memcmp',
    inlined from 'bacmp' at /scratch/merges/ko-linux-next/linux/include/net/bluetooth/bluetooth.h:347:9,
    inlined from 'l2cap_global_chan_by_psm' at /scratch/merges/ko-linux-next/linux/net/bluetooth/l2cap_core.c:2004:15:
/scratch/merges/ko-linux-next/linux/include/linux/fortify-string.h:44:33: error: '__builtin_memcmp' specified bound 6 exceeds source size 0 [-Werror=stringop-overread]
   44 | #define __underlying_memcmp     __builtin_memcmp
      |                                 ^
/scratch/merges/ko-linux-next/linux/include/linux/fortify-string.h:420:16: note: in expansion of macro '__underlying_memcmp'
  420 |         return __underlying_memcmp(p, q, size);
      |                ^~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors

Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
---
 net/bluetooth/l2cap_core.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index cbe0cae73434..be7f47e52119 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -2000,11 +2000,13 @@ static struct l2cap_chan *l2cap_global_chan_by_psm(int state, __le16 psm,
 			}
 
 			/* Closest match */
-			src_any = !bacmp(&c->src, BDADDR_ANY);
-			dst_any = !bacmp(&c->dst, BDADDR_ANY);
-			if ((src_match && dst_any) || (src_any && dst_match) ||
-			    (src_any && dst_any))
-				c1 = c;
+			if (c) {
+				src_any = !bacmp(&c->src, BDADDR_ANY);
+				dst_any = !bacmp(&c->dst, BDADDR_ANY);
+				if ((src_match && dst_any) || (src_any && dst_match) ||
+				    (src_any && dst_any))
+					c1 = c;
+			}
 		}
 	}
 
-- 
2.34.1

