Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1AA6D1193
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 23:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbjC3V5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 17:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbjC3V5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 17:57:07 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B25F772;
        Thu, 30 Mar 2023 14:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1680213406; i=w_armin@gmx.de;
        bh=ic4HTDK6Iq7x8nk9DY+eRr5Awk+6mr0CRuqgp5VhbNo=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=NC7q6t1NytDZ4r2LfYrF/5cs2/qtg/10P/yNJG2/ponjVp2nwCQn/rVGITR7EoGBC
         0sjSC4lbtSJsNxJ22TIcDD7l+bkKsIOy4sRu9Bz6zw8p1FWeCE6bzNsxq5WZ3K6V0P
         geVb0FXQHIjjNutCfEC8lNSUmmQfdOU9UT8El084BmTklPASjmi+RJ1QLeFpele39r
         XgRO2i625tGTvQIe03CeAIJMXgpYjYxfIIvJFbJM58ZaSrgUc1D3vIddVsH3hHekBe
         TFEtsCEuQ037c6lqncfeRrmvDuBn1b0aSX8RJk5zZUxWXP49/lYjZb5hhw6joapXXV
         UEiQfvlL2PEjw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from esprimo-mx.users.agdsn.de ([141.30.226.129]) by mail.gmx.net
 (mrgmx104 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1MORAU-1q4e0W31EE-00Py3d; Thu, 30 Mar 2023 23:56:46 +0200
From:   Armin Wolf <W_Armin@gmx.de>
To:     stf_xl@wp.pl, helmut.schaa@googlemail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: rt2x00: Fix memory leak when handling surveys
Date:   Thu, 30 Mar 2023 23:56:37 +0200
Message-Id: <20230330215637.4332-1-W_Armin@gmx.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Sd3Km1kcwGR3YWvYoH7Brf3Mf42OOCdPaMAyUIuegDPaOkEgHLZ
 3ATsYBXV+20fb9FAygSTBM2ZZRb08WOmo/IorU9TiyLLfwrv+6662Ti0Wkc/XCQVz2Dqv8J
 SSEO9AeT9i+CEmYTI8TrCKQAorad5JaEWc4GCvjMXA7xoEHPHujUH0M3phNK1ekE18l/61d
 4vWflekAZlGGBeK1Rhvrg==
UI-OutboundReport: notjunk:1;M01:P0:C1Ld/vHPjbI=;HN0OG48kUP6d7QDjBqPSV51t7Eu
 QuZSTC0i6slz1ZjJFe+gO1ebjuaIYCkc7Voq8GQewUJlnd84OhhkObDMtzfDASoy7SmARA1fu
 BsFVdzqBNRAdIX8qQIrtR7Qp86gKW/QAhxR5mgtGmxRMuxoTbRQyCGQUG4pg95JOsjcj3l0zU
 tdlYJCHZ5wepy4X8PRVD073krk9HJ8ntifuAGitOX9IsUogAZZC2lu0Yq2z9dXHq6/homuRZb
 qccBMy07bTcFYs6gCQIJfAPoLALVHPQ2iNqeVydKIFo9/vO9PNnegyEou4fZJS7E7eU6AFG95
 GadbvgmcQoSdVAU7Nwj5ZC+xevT/tlIVIUSAbuB6iitajDoXbCVkk653x40B6v6KIr4yYvR8c
 gHg0OXr9xVUgYcQqR3umcZNoYszFZseYTHEQZ7+OnwT8C7pvgAg3s+h1X2HbJpugR9HNxut/k
 mCC72u8pJLjyOY1HSEQjBTK9Xswo9pQsZAV8m0huxMXXEx9WGvq+yRWoPaVqAIzs8lHyr3bJE
 PO8f97Ps2UxNG4Hs5cbTXfVbtDo9kkL9N23use5+wXd/PavBtSvxS98w78zFRrgqAnZ82U5xg
 1uLJaOtICZ5Tyj912xZn00KHM+hzQcfNI6w+yfkdOyjyAgOCAKBafSsyjlgbLsWIvMjjzyeN0
 JW6dNikojG1jaZ+lP90IDk1+en2cBK6tl1nFXob6mrEulvT+VUc8BtmzDjevzO22/cuW3l1BC
 CnErVBEq+5T/Of8WnCSyYDx+MmbRTacHlKMjc2nSrLMfNncmev4HInCm8AH6qzwedaXnqSu5y
 RgDhSDS4N+3Yy47pqCuhZu2CkH2nZWNhdOwHd8UJyzjAKKUVkl6nK0t8E9ZMt2OF+0YL/EE/G
 j3ghcBgMa80a/q2ex/OG9zpHRsRX1OoozF48ZS3ulOluKKBPfHRQRI5CdH7CHmklVakh3BISI
 5MPFgo6fuGqLS6bSY+Ovx8XQvus=
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When removing a rt2x00 device, its associated channel surveys
are not freed, causing a memory leak observable with kmemleak:

unreferenced object 0xffff9620f0881a00 (size 512):
  comm "systemd-udevd", pid 2290, jiffies 4294906974 (age 33.768s)
  hex dump (first 32 bytes):
    70 44 12 00 00 00 00 00 92 8a 00 00 00 00 00 00  pD..............
    00 00 00 00 00 00 00 00 ab 87 01 00 00 00 00 00  ................
  backtrace:
    [<ffffffffb0ed858b>] __kmalloc+0x4b/0x130
    [<ffffffffc1b0f29b>] rt2800_probe_hw+0xc2b/0x1380 [rt2800lib]
    [<ffffffffc1a9496e>] rt2800usb_probe_hw+0xe/0x60 [rt2800usb]
    [<ffffffffc1ae491a>] rt2x00lib_probe_dev+0x21a/0x7d0 [rt2x00lib]
    [<ffffffffc1b3b83e>] rt2x00usb_probe+0x1be/0x980 [rt2x00usb]
    [<ffffffffc05981e2>] usb_probe_interface+0xe2/0x310 [usbcore]
    [<ffffffffb13be2d5>] really_probe+0x1a5/0x410
    [<ffffffffb13be5c8>] __driver_probe_device+0x78/0x180
    [<ffffffffb13be6fe>] driver_probe_device+0x1e/0x90
    [<ffffffffb13be972>] __driver_attach+0xd2/0x1c0
    [<ffffffffb13bbc57>] bus_for_each_dev+0x77/0xd0
    [<ffffffffb13bd2a2>] bus_add_driver+0x112/0x210
    [<ffffffffb13bfc6c>] driver_register+0x5c/0x120
    [<ffffffffc0596ae8>] usb_register_driver+0x88/0x150 [usbcore]
    [<ffffffffb0c011c4>] do_one_initcall+0x44/0x220
    [<ffffffffb0d6134c>] do_init_module+0x4c/0x220

Fix this by freeing the channel surveys on device removal.

Tested with a RT3070 based USB wireless adapter.

Fixes: 5447626910f5 ("rt2x00: save survey for every channel visited")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
=2D--
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/=
wireless/ralink/rt2x00/rt2x00dev.c
index 3a035afcf7f9..9a9cfd0ce402 100644
=2D-- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -1091,6 +1091,7 @@ static void rt2x00lib_remove_hw(struct rt2x00_dev *r=
t2x00dev)
 	}

 	kfree(rt2x00dev->spec.channels_info);
+	kfree(rt2x00dev->chan_survey);
 }

 static const struct ieee80211_tpt_blink rt2x00_tpt_blink[] =3D {
=2D-
2.30.2

