Return-Path: <netdev+bounces-2888-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EA7C17046D2
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 09:46:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A52B228153E
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 07:46:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C1AA1DDE0;
	Tue, 16 May 2023 07:46:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B141DDD5;
	Tue, 16 May 2023 07:46:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE33C433D2;
	Tue, 16 May 2023 07:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684223160;
	bh=DWVQGg8BOQg1TC5mQhyL5M5QVn3UeUKSLvymNtkvcT4=;
	h=From:To:Cc:Subject:Date:From;
	b=c4TkzfttZpQk0Ptc+5OqMy617FPzeTD+h9izO2F78CbvIexZDfGN86mXf7dEkoxa9
	 h+lGw7DZfar/rMhiBdMV4WCAtrfSzoEHviL4BQsivRZF2nzHS6ZauNO62pFMsNyyFL
	 AteyHMEc3rleqpNvRDnhzy77+P+WDF7n10KIosEBEWyuPIDs9/UsoqZh4aj3MMuZza
	 bJM3xkdKlERWL9lHGePfDyU0EOfg70bLlL5XYtvIJalyVwTF6WxBKZ/z8Zb6jT28xc
	 VAay31rGQE1qLGmb8S1LUUoYgAhMPhbg/2H3rsouC0ngqss5jB13ErcvDHW8pvuGMV
	 nc42AQEJ4z8Hg==
From: Arnd Bergmann <arnd@kernel.org>
To: Kalle Valo <kvalo@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>,
	linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH] wifi: b43: fix incorrect __packed annotation
Date: Tue, 16 May 2023 09:45:42 +0200
Message-Id: <20230516074554.1674536-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

clang warns about an unpacked structure inside of a packed one:

drivers/net/wireless/broadcom/b43/b43.h:654:4: error: field data within 'struct b43_iv' is less aligned than 'union (unnamed union at /home/arnd/arm-soc/drivers/net/wireless/broadcom/b43/b43.h:651:2)' and is usually due to 'struct b43_iv' being packed, which can lead to unaligned accesses [-Werror,-Wunaligned-access]

The problem here is that the anonymous union has the default alignment
from its members, apparently because the original author mixed up the
placement of the __packed attribute by placing it next to the struct
member rather than the union definition. As the struct itself is
also marked as __packed, there is no need to mark its members, so just
move the annotation to the inner type instead.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/broadcom/b43/b43.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43/b43.h b/drivers/net/wireless/broadcom/b43/b43.h
index 9fc7c088a539..67b4bac048e5 100644
--- a/drivers/net/wireless/broadcom/b43/b43.h
+++ b/drivers/net/wireless/broadcom/b43/b43.h
@@ -651,7 +651,7 @@ struct b43_iv {
 	union {
 		__be16 d16;
 		__be32 d32;
-	} data __packed;
+	} __packed data;
 } __packed;
 
 
-- 
2.39.2


