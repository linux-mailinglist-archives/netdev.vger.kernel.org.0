Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A848B6BBDE1
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 21:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbjCOUWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 16:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbjCOUWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 16:22:11 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5E299244;
        Wed, 15 Mar 2023 13:22:10 -0700 (PDT)
Received: from fpc.intra.ispras.ru (unknown [10.10.165.16])
        by mail.ispras.ru (Postfix) with ESMTPSA id 8835944C100E;
        Wed, 15 Mar 2023 20:22:08 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 8835944C100E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1678911728;
        bh=wGDoI1NTP9M1pEBv53/ObQ/haH6qkFw0UZeHgeusapg=;
        h=From:To:Cc:Subject:Date:From;
        b=AyKkW9nvByAUPEzKNQn6gJAeWdU4/H8HtfalWLHUlv+aV5EVvdhNIz/ygrXHWNa+l
         7bjFIFPa3NS28wG5ogvBsFwyppnhIqamvcvRO/hfBBtrv815f8zygq06F5b30zj+Bl
         4hRiRTINzMuBrqu6PfnrcjqZDQrV0b+gmBfGoB3s=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Sujith <Sujith.Manoharan@atheros.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: [PATCH 0/3] wifi: ath9k: deal with uninit memory
Date:   Wed, 15 Mar 2023 23:21:09 +0300
Message-Id: <20230315202112.163012-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzkaller reports two cases ([1] and [2]) of uninitialized memory referencing in ath9k
wmi functions. The following patch series is intended to fix them and related issues.

[1] https://syzkaller.appspot.com/bug?id=51d401326d8ee41859d68997acdd6f3b1b39f186
[2] https://syzkaller.appspot.com/bug?id=fc54e8d79f5d5082c7867259d71b4e6618b69d25
