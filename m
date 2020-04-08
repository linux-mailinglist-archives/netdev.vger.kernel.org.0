Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA351A2A5F
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 22:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730461AbgDHU1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 16:27:51 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:51355 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729333AbgDHU1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 16:27:50 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1Mrh9Y-1izGjr3MlI-00nlSz; Wed, 08 Apr 2020 22:27:19 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     linux-kernel@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [RFC 1/6] thunder: select PTP driver if possible
Date:   Wed,  8 Apr 2020 22:27:06 +0200
Message-Id: <20200408202711.1198966-2-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200408202711.1198966-1-arnd@arndb.de>
References: <20200408202711.1198966-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:mGlRd5xXvrWXjH5ARNufEZPCVL9cYj10ODbmPSRMgDrYtv3nXEc
 pnVt/hadqMl2XTMQZrC9iv1lQ3+3zV9clZ0cy+FrVsKbQDG5ydckomDupqtfWBpYAA5SL2b
 ejhseEmA9tAmYQ19vMw/qvPk1gTfisBagmO/idcL225eXQYT8xGDe7hLh2vIjswDKD8Vli+
 7ocNzTVy5ThHS8QujPL2Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:/nLZWXqnSdw=:phuLH7tle7YBo97T3huV5A
 vSH8xCo4twHU84eg4LvK4HOn2oFolsTYGZa7ROooND9YGt7MB5zz2Q8z9RTJodxFRn/XG9dOf
 NscqFwaOXSxVAUJsjy/uEB0hicWqQu8xEcUY+9DCLcd8q7SVpN/QIRF6ttpBP19m/PmXqyv1o
 /sw4SUqnEvUrNysy3IynuagA8enqZQ1TDbfjul2uZllbFNGXrRzMj3CA9CsLyU7yGTRu05J/h
 Xum24X+4IC4lg1k5fwt0nNHZ1IKTMePnwwC5oWsroAHgDqQDlNpK7uHI8IWHuuxRiqXQDJC5i
 z+Z6KtPdmG128SbnEbblbnbblKt+K9bXMhgogAp0DoMYf8J/qcCV3kf09stxpSqfuIGfPnjyU
 KOent5VLIkZCNlKvyHrEm+gyhPn2rQHBajpCCWXPu37pQX+vpEgCL7PneJc4fdlmbxS1iA1Cy
 RF+ad2EDQAkocPHNvigKWAAehlA9QRjVxipXwW31RnOhLwdgeuqgRecV/i/ggUl8gDViV1ymW
 lHuzosDGj+TVv+RYSfvxecxkdvTRsk1Bj817pcCuGTmzbESstAikpZM73nb9YhpZOjLZYC2NG
 twpAchLKYWWJ1aB4o/VhaSgn5omEitydCCPi4cdiCHgcn4MtniRDa6IFziUZiE93xzVPu7WHD
 0EAtotW2BYHlSqsrQ9Yf+alqoXxf6PIWGHmGtlAAR43obUqNNiyRgVuuICZH38wVqqc0NVZi7
 Rt1447uuSlKrrXx37E8+y7pfa28xD2eKt4O+BQMIHXWuBsFpiN6qOo0tMvcHmxjEFEKuijvCA
 BTb984lp4wcmvcR8Z0xnpylpFzuR7vyIDT9/98rJdVPKhEXJdw=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'imply' selection means the driver can still be a loadable
module even if the main driver is built-in, leading to a link
error:

aarch64-linux-ld: drivers/net/ethernet/cavium/thunder/nicvf_main.o: in function `nicvf_remove':
nicvf_main.c:(.text+0x25c): undefined reference to `cavium_ptp_put'
aarch64-linux-ld: drivers/net/ethernet/cavium/thunder/nicvf_main.o: in function `nicvf_probe':
nicvf_main.c:(.text+0x3080): undefined reference to `cavium_ptp_get'

Use a 'select' statement instead.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/cavium/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/Kconfig b/drivers/net/ethernet/cavium/Kconfig
index 6a700d34019e..52806ef20d2d 100644
--- a/drivers/net/ethernet/cavium/Kconfig
+++ b/drivers/net/ethernet/cavium/Kconfig
@@ -27,7 +27,7 @@ config THUNDER_NIC_PF
 
 config THUNDER_NIC_VF
 	tristate "Thunder Virtual function driver"
-	imply CAVIUM_PTP
+	select CAVIUM_PTP if POSIX_TIMERS
 	depends on 64BIT && PCI
 	---help---
 	  This driver supports Thunder's NIC virtual function
-- 
2.26.0

