Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B12FE39DB
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 19:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503723AbfJXRZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 13:25:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47029 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389384AbfJXRZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 13:25:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571937905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=IWzAZ9HNPk3l1a/8iI2n7kSXyM4kxMXTHno5ToPU7ww=;
        b=P2lxCg8P8lVSM6XdDJjKMvtHbvpeluZuToTMyjoyQNEdqFXw+EynQcvSGsxqBISqzrpf0O
        wwRDToxJzoQHb8mwAusJKcT+QLtVA8cbhLLQ1Z6s+08POaCofeJuC7inSHT78qfk5s94Lc
        6N711XdUzGk5z4vcK/U6Z/0WaDei9GE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-5E--r5mwNZCXMJoaqLqbxw-1; Thu, 24 Oct 2019 13:25:03 -0400
Received: by mail-wr1-f71.google.com with SMTP id c6so13236017wrp.3
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 10:25:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QceqmF4YKwwH8fTUkw/b9vvDDjaKb935kcJgs7A+w8g=;
        b=GXF2XWSH2nJhnq3vFVFXKgwe+QoHHFkjKriSLCGwXQe1vrEPjCHp0jpuWCv86EDP/K
         Z01EHC+QkFmem9UPj5UQnjhpnjrCFnx3wiEpqPfl0JbZEFduL5/6MQZ5oIlNQbEkb4YI
         ZmsNPQy1gNgqau8NEjL8+o8A8EEvYbt4oq1+Wo1/GxBqpXua3OxacbuwIqRUG8riVyyS
         jvbH4urGfe8BiB7j1KJejAA+2t3MH1yIBmABj9yR5Kaha9CZrW7QD1G7KeMolvfOzSnQ
         FVr2/cjmrsKqoFYSyRrtXE15GyD2pSI5GAMIoXJ3YxnWTorPgZgJoOaCGASVZ9ezJ35I
         Tesw==
X-Gm-Message-State: APjAAAXwWSrPPGvo2my836DouTVmU5penG5t5/mBq17vtB3tIuDcTtSf
        IH+F5fcbPDHsYQ4XxrgcdHvp4+3ejL04A3+KUqa0hMRKItso7/U9QM3IR+60bCFD4d39Xrmdkp1
        c0yuRjXs4wl1OeH6h
X-Received: by 2002:a5d:55c2:: with SMTP id i2mr4952665wrw.176.1571937901770;
        Thu, 24 Oct 2019 10:25:01 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz5Rez1khw9qnCHtTQbdfVkKcfFrfFNym8v2VuQ29stcdXlnuRhZ4LzEGVIEADkmeLYi+UUsA==
X-Received: by 2002:a5d:55c2:: with SMTP id i2mr4952649wrw.176.1571937901592;
        Thu, 24 Oct 2019 10:25:01 -0700 (PDT)
Received: from mcroce-redhat.mxp.redhat.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 200sm4253443wme.32.2019.10.24.10.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 10:25:01 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Stefan Chulski <stefanc@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 0/3] mvpp2 improvements in rx path
Date:   Thu, 24 Oct 2019 19:24:55 +0200
Message-Id: <20191024172458.7956-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
X-MC-Unique: 5E--r5mwNZCXMJoaqLqbxw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor some code in the RX path to allow prefetching some data from the
packet header. The first patch is only a refactor, the second one
reduces the data synced, while the third one adds the prefetch.

The packet rate improvement with the second patch is very small (1606 =3D> =
1620 kpps),
while the prefetch bumps it up by 14%: 1620 =3D> 1853 kpps.

Matteo Croce (3):
  mvpp2: refactor frame drop routine
  mvpp2: sync only by the frame size
  mvpp2: prefetch frame header

 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 27 ++++++++++++-------
 1 file changed, 17 insertions(+), 10 deletions(-)

--=20
2.21.0

