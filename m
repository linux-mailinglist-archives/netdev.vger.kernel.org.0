Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5ADD1C59B4
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 16:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729643AbgEEOeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 10:34:11 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:46673 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbgEEOeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 10:34:11 -0400
Received: from localhost.localdomain ([149.172.19.189]) by
 mrelayeu.kundenserver.de (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1Mof1D-1ila9N3wWf-00p29q; Tue, 05 May 2020 16:33:41 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Dedy Lansky <dlansky@codeaurora.org>,
        Ahmad Masri <amasri@codeaurora.org>,
        Alexei Avshalom Lazar <ailizaro@codeaurora.org>,
        Tzahi Sabo <stzahi@codeaurora.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Lior David <liord@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wil6210: avoid gcc-10 zero-length-bounds warning
Date:   Tue,  5 May 2020 16:33:24 +0200
Message-Id: <20200505143332.1398524-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:zDD9bs6aW0JYGWHkwYbnevv//40lQsm3jQwPwrI1bBnlk/bFmpk
 kZ7UaQ0Fyi+SxjBcJf1zuSa0Sz3irK8/KXdIuShUrvRKkFNI9G4bvKnkf2cMEqIsjTTsWGc
 iK24LCQ46DyASUuYCv6y4tJNO6BTxcEh+qtZzobf576RokNG5ZI0uC1W75wjZTJqMq7GEme
 Uo4NzDp2i0EOhyU1cZHVg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:d7gL+ZdLOB4=:eXPbZb3icMUiHmpRvU3P0f
 M/j7WeQ1Fe2vADPBhdEhyXAjOsnX7OVDvoWLybK1PrWEsAkAstoJPvhZM+RCmdRV3lv/1EsT+
 44/Z+e+X+Da8UKYza5hXGqw/ZPGO7V4fLMakWwFuCbiXlkPQIDBT2/bqgXPimuR5d5fJC6mVP
 g9uQckF06ya8J9h4IvE9HKDN/kHNrf31RATZ5Y7xn51ELYjDvjxI6h2U/E8TcXTnS5LiUEb5/
 aDd+IdzrTqIrn0DfIhw7cYg5nsLHp/18eSWzLVcfB4Z0sD+LEOop8WnAN4zi5H/JVXQx6+lKE
 9LQjWTnPxM+y9bZz36gnKnp0LxyPTF+H3HqKdwPnRfgWCaSjRRso7GDZfIXUeLLWN5l2djs6N
 ifckdjTpXQZ/tb1vSjeb2a0yCZlx/Tft5hB1Xpg2EDf3QVwtoVA2Y4bzT8G77zMYQAXbpo6kd
 V69z9mJgSDwSAdjeIVlsDSWI0UY/auf0jLRrIU+xpqsddEtPGchSVvGKSnsf91tP8yfhxvW4h
 jhgfu1ZAXXwd7yXViQzRgS/tj5tnBv2jk6XdmuHJjV6oZf4nrci4d65prswmwZbqF9Ix0WJAe
 D09TT3ksA0HDEGb/+OmuUsWReSvYjFdpWQIjSY/ufPnu3YW4OvUkxo0e2CLLTuIO3Q8dCSxUg
 CgMkfvEUzgMq9hhFKob5FNd02ssBqNbOf2vUpf0u0HPPPxWzilNtRh6Jm2sWxld/uy+dQpi7i
 wW7YUvshuEd78jav7rBxdQ9+Pa6RmFVEY81D1Rt8ebKSWR4+xQNb8BPOOGdxzKr1u3mpIIHoa
 ukyeR0YuBwbIWhdNrvfxDYx86WvWYTBaH24UoFOhAqbFfP8UPQ=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

gcc-10 warns about accesses inside of a zero-length array:

drivers/net/wireless/ath/wil6210/cfg80211.c: In function 'wil_cfg80211_scan':
drivers/net/wireless/ath/wil6210/cfg80211.c:970:23: error: array subscript 255 is outside the bounds of an interior zero-length array 'struct <anonymous>[0]' [-Werror=zero-length-bounds]
  970 |   cmd.cmd.channel_list[cmd.cmd.num_channels++].channel = ch - 1;
      |   ~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~
In file included from drivers/net/wireless/ath/wil6210/wil6210.h:17,
                 from drivers/net/wireless/ath/wil6210/cfg80211.c:11:
drivers/net/wireless/ath/wil6210/wmi.h:477:4: note: while referencing 'channel_list'
  477 |  } channel_list[0];
      |    ^~~~~~~~~~~~

Turn this into a flexible array to avoid the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Gustavo has a patch to do it for all arrays in this file, and that
should get merged as well, but this simpler patch is sufficient
to shut up the warning.
---
 drivers/net/wireless/ath/wil6210/wmi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.h b/drivers/net/wireless/ath/wil6210/wmi.h
index e3558136e0c4..5bba45c1de48 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.h
+++ b/drivers/net/wireless/ath/wil6210/wmi.h
@@ -474,7 +474,7 @@ struct wmi_start_scan_cmd {
 	struct {
 		u8 channel;
 		u8 reserved;
-	} channel_list[0];
+	} channel_list[];
 } __packed;
 
 #define WMI_MAX_PNO_SSID_NUM	(16)
-- 
2.26.0

