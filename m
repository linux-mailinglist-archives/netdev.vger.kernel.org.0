Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D47A61082A7
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 10:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbfKXJnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 04:43:20 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:36972 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbfKXJnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 04:43:20 -0500
Received: by mail-pj1-f67.google.com with SMTP id bb19so1552983pjb.4;
        Sun, 24 Nov 2019 01:43:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cYCl6tCVXRhGzELJNREu4KHA8Cuxy8ZifAK3A3H2TqQ=;
        b=XQhrEfklswD/dw/KdVMegl8bW0SjyzX+fySRCa+n7O315I3Na7lkxPAcT0/VEHpxtJ
         7S/WXKvwQkvFqxiT1aeJkK+dW/rrKlPOpwhvn3huQ7lswM8jcFu80S/EL403dqQkxCjg
         m43i4Gh0TEaZ/zdBAr45GW8en4xxswxbi/BaWRceaBi3bMg9LXoEiPLAuz0BPzPT/dAs
         R+n0SFhnh7DMcGVJoA4alAiHookTHm0vLTec2C/caj5nU/+P5A1myleHHuJckiH36mMd
         X8fAwPEXZa1DNg/xyKMd0+v26TYVWX7lleoC520+ZHmWmm6FICX1eMvbX7I6GNI9lYMR
         0z4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cYCl6tCVXRhGzELJNREu4KHA8Cuxy8ZifAK3A3H2TqQ=;
        b=NuhT9Ivz3jJDcoZ17KLJTaFyQ3bnPZR4PmGhGTLj0ssAq6xB1Kq+CxBlS/fxwxMX1v
         xV07hPWgVr+X7aAr0WOsSnK0zUArDLszkRUaTgemfL8a4dIjEQR+9KsrYTENJswyBR2B
         xJD2Mtk6GM11ph2Tw6MuzMC00xcPpSi43WBwbvfKYO/+nTlMoebonKEv9kuL0NFcXd/u
         wpfBPj268t+4Ca0iHzxXADBwLVEtct0tdsJaWAVy+hULKfXsj1OdSMuPIoteJRgMpUz7
         sHJgVZdMbWY8rmZfcN1DcweRoh2qNtSHmAVm2Bxw6YK74G84Z+f0aSZhGGSycBW86b1L
         JWYQ==
X-Gm-Message-State: APjAAAXs2mXfuouonk2LIzMmOAZ9Pj0gG9VGuV3F0WEfwXD9ZwQIQtk1
        RXZGRvPHLT9vocDv2bM+L34=
X-Google-Smtp-Source: APXvYqyWFjRWaQ8Px/q90nV7G8rnmuF8zHbfQye+twExMG2QCGL8hKvlHs7yLoSiNccpcqEh/H1XgA==
X-Received: by 2002:a17:902:6802:: with SMTP id h2mr22565940plk.135.1574588598968;
        Sun, 24 Nov 2019 01:43:18 -0800 (PST)
Received: from debian.net.fpt ([2405:4800:58f7:550c:6dad:1b5f:afc6:7758])
        by smtp.gmail.com with ESMTPSA id c3sm4091213pfi.91.2019.11.24.01.43.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2019 01:43:18 -0800 (PST)
From:   Phong Tran <tranmanphong@gmail.com>
To:     davem@davemloft.net, keescook@chromium.org
Cc:     kvalo@codeaurora.org, saeedm@mellanox.com,
        jeffrey.t.kirsher@intel.com, luciano.coelho@intel.com,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Phong Tran <tranmanphong@gmail.com>
Subject: [PATCH 0/5] Fix -Wcast-function-type net drivers
Date:   Sun, 24 Nov 2019 16:43:01 +0700
Message-Id: <20191124094306.21297-1-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series is for fixing the compiler warning while enable
-Wcast-function-type.

Almost is incompatible callback prototype in using tasklet.
The void (*func)(unsigned long) instead of void (*func)(struct foo*).

Reported by: https://github.com/KSPP/linux/issues/20

Phong Tran (5):
  drivers: net: hso: Fix -Wcast-function-type
  drivers: net: usbnet: Fix -Wcast-function-type
  drivers: net: b43legacy: Fix -Wcast-function-type
  drivers: net: intel: Fix -Wcast-function-type
  drivers: net: realtek: Fix -Wcast-function-type

 drivers/net/usb/hso.c                          |  5 +++--
 drivers/net/usb/usbnet.c                       |  8 +++++++-
 drivers/net/wireless/broadcom/b43legacy/main.c |  5 +++--
 drivers/net/wireless/intel/ipw2x00/ipw2100.c   |  7 ++++---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c   |  5 +++--
 drivers/net/wireless/intel/iwlegacy/3945-mac.c |  5 +++--
 drivers/net/wireless/intel/iwlegacy/4965-mac.c |  5 +++--
 drivers/net/wireless/realtek/rtlwifi/pci.c     | 10 ++++++----
 8 files changed, 32 insertions(+), 18 deletions(-)

-- 
2.20.1

