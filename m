Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 547B53A3062
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 18:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbhFJQVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 12:21:42 -0400
Received: from sender4-of-o53.zoho.com ([136.143.188.53]:21380 "EHLO
        sender4-of-o53.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbhFJQVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 12:21:41 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1623341975; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=coZG9heMNMaVtmLhvzg39WQj9ttAHjAVR4Xin5Tl++EWjGNVjHgc6AeSB+Vk1smMrxq5KpkFXzOKp/Em7YDDMc7mglty70BFURFtxlQWlsY76wyMP4j8MIrciVkVy1rLqIKLkYN6XoE+Uy4x149sALB9uRbG6WeWyKlkGoX7PGA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1623341975; h=Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=HAKm0vB87VfcW2UTN+pnBdBfKxvZ/KF9QbxznGuDeHk=; 
        b=YJNMlInwHU9N8ys4lH9xuXLkGPlV7lqA1FhRB9HDJBeHmR0q5UAa3qNV2UFdpX6iRTxkIjBK8L03kVnbvAVWFmSpUATF6aBnkmZRnzAXkpYa8rHD97MT6ukk/A2cwsdA1R7LV1xqatg+e3xEju/BvEnGC3EfsreBzO20gs5PC5k=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=anirudhrb.com;
        spf=pass  smtp.mailfrom=mail@anirudhrb.com;
        dmarc=pass header.from=<mail@anirudhrb.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1623341975;
        s=zoho; d=anirudhrb.com; i=mail@anirudhrb.com;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Transfer-Encoding;
        bh=HAKm0vB87VfcW2UTN+pnBdBfKxvZ/KF9QbxznGuDeHk=;
        b=BA8qi6XYZGlPo9t9larjyIpSYdNf/1i1q1n064Y/76Q8WS1IPvtnMV7JBTz+EN4v
        REcxm2tTb2BXvkiP5tjgYm7OLxbD25WFMjFMhXjhdPzAkmaUJDiVVT7zJM9vrB9LeP6
        Da7A1TLPNKuLHyOjwsiIHR1WweIArmmdFx8Eys3k=
Received: from localhost.localdomain (106.51.105.43 [106.51.105.43]) by mx.zohomail.com
        with SMTPS id 1623341973610765.8442819280449; Thu, 10 Jun 2021 09:19:33 -0700 (PDT)
From:   Anirudh Rayabharam <mail@anirudhrb.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        syzbot+b2645b5bf1512b81fa22@syzkaller.appspotmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mac80211_hwsim: correctly handle zero length frames
Date:   Thu, 10 Jun 2021 21:49:16 +0530
Message-Id: <20210610161916.9307-1-mail@anirudhrb.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot, using KMSAN, has reported an uninit-value access in
hwsim_cloned_frame_received_nl(). This is happening because frame_data_len
is 0. The code doesn't detect this case and blindly tries to read the
frame's header.

Fix this by bailing out in case frame_data_len is 0.

Reported-by: syzbot+b2645b5bf1512b81fa22@syzkaller.appspotmail.com
Tested-by: syzbot+b2645b5bf1512b81fa22@syzkaller.appspotmail.com
Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 51ce767eaf88..ccfe40313109 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3649,7 +3649,7 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 	if (skb == NULL)
 		goto err;
 
-	if (frame_data_len > IEEE80211_MAX_DATA_LEN)
+	if (frame_data_len == 0 || frame_data_len > IEEE80211_MAX_DATA_LEN)
 		goto err;
 
 	/* Copy the data */
-- 
2.26.2

