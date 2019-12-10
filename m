Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7E3F1186CC
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 12:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbfLJLop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 06:44:45 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41939 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727018AbfLJLop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 06:44:45 -0500
Received: by mail-lj1-f196.google.com with SMTP id h23so19485254ljc.8;
        Tue, 10 Dec 2019 03:44:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sUHnZpA/wNmoInYgusvk70ynWZByhnZO00JpHi1dxX0=;
        b=a1Lxgj/Hd9z+Y+l6L96g027WUIu0stJmBbbdQFlbjaaslpHWagTdw4NfXFid23saX1
         Okhtj6LV5hzEdjR7s4ViiLBcaUQgRNVbewX2OBTGJc7pbGRJ3xlnXk+mruCronBqW8NX
         YdCuOlc5S8+Z41HbIs2PG0bGMZUi7CxiZYchDO/Osg4WvQyRzt5WX0U8/lnyEFXi6LM8
         cTLiSdq82hekRfnu1LOEN8AfmBTgDNtH9j9nMF+b1zCFgRTA9zGIfZsQgaYGejKhCn5i
         bBVYfYwD2gMTobHWCEQly8z1EFBZLy4GU3Qoo8AyelaKXgQS7KGlZDnLUOki5WryE3WS
         xJzQ==
X-Gm-Message-State: APjAAAUKsZOy1B0jqPwP51qB6bwIwxUHaiM6urw7DPw0qWO9hlpl7Iaq
        8vP4gC8G3azYnZiJhvlaRhHBVYyT
X-Google-Smtp-Source: APXvYqz/qd4zR0TA6WGZrUyUNn0MN3E258bJN3+Vu1vmpFMckaJz8h0H66PIEDZPKd2zv2YAtUzT6A==
X-Received: by 2002:a05:651c:152:: with SMTP id c18mr19992369ljd.146.1575978282744;
        Tue, 10 Dec 2019 03:44:42 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id y14sm1638043ljk.46.2019.12.10.03.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 03:44:42 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iedwa-0001HY-89; Tue, 10 Dec 2019 12:44:44 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Arend van Spriel <arend@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 0/7] wireless: fix USB altsetting bugs
Date:   Tue, 10 Dec 2019 12:44:19 +0100
Message-Id: <20191210114426.4713-1-johan@kernel.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We had quite a few drivers using the first alternate setting instead of
the current one when doing descriptor sanity checks. This is mostly an
issue on kernels with panic_on_warn set due to a WARN() in
usb_submit_urb(), but since we've started backporting such fixes (e.g.
as reported by syzbot), I've marked these for stable as well.

Johan


Johan Hovold (7):
  ath9k: fix storage endpoint lookup
  at76c50x-usb: fix endpoint debug message
  brcmfmac: fix interface sanity check
  orinoco_usb: fix interface sanity check
  rtl8xxxu: fix interface sanity check
  rsi_91x_usb: fix interface sanity check
  zd1211rw: fix storage endpoint lookup

 drivers/net/wireless/ath/ath9k/hif_usb.c               | 2 +-
 drivers/net/wireless/atmel/at76c50x-usb.c              | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 4 ++--
 drivers/net/wireless/intersil/orinoco/orinoco_usb.c    | 4 ++--
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  | 2 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c                 | 2 +-
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c           | 2 +-
 7 files changed, 9 insertions(+), 9 deletions(-)

-- 
2.24.0

