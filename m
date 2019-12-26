Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8719B12AE87
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 21:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbfLZUhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 15:37:14 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55600 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726653AbfLZUhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 15:37:14 -0500
Received: by mail-wm1-f68.google.com with SMTP id q9so5067662wmj.5;
        Thu, 26 Dec 2019 12:37:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=llajuKPgaOsGAZ6hxa/EUEXLbYSF0qHLJQBA9/H47cY=;
        b=oW/XveMrY7fe5BgQnxbWDFAdmRLzL34s6I+JDTYtT8TRs6ext70L0wuYi/+Vtfhd45
         p99aaZp8WvB3IUsF09jM6FRejA5aZqbmUQPfEqA7hfIs69wsamf2BZWiOhUni2C/SLVb
         DroTOrzmhzBXznCFPGZ903sH6HHNvidiSuV0NXecfwA70KkKc60JxEGg21o4y7U3iHoo
         Q7zDTePknya/1fOgs6TMIOf82MU5Auee5qqrrrzIIbavbMBQWbbu/WHTN85vtN9SJqdS
         hyeRaEbNItnY7nIsgz+Fl1sAAtKzv/lmtZz6u4WQyP2EbSuL3mBCs9H3gQ8KDvucVYf2
         wpCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=llajuKPgaOsGAZ6hxa/EUEXLbYSF0qHLJQBA9/H47cY=;
        b=GdqBoZAJy6Tn8JCrrA1rcYUraDH873+Om/rh0xAo60tGcTRr8+4cjGKWiwr7h9XCKc
         RjiIytU9BalRTwqAOMxbV8qIQe0DVpQyo6uNX6RS7c1Ze4rvZno8ZUaCh5+uSLtHJMAz
         2TU0+ZPscGPISqqFz6OJD+uRANlFW2pdH3At9LtNVv6ceHVlV6nfMExI27CH/3xCVCij
         M4ywKwDo/OTiMS/mtJRA/1sL86H/QxtLv+u9NDHlXQIX+bj8Z60f3F9UkHqV/zRH6sjx
         ZjQG6wxlLc7vlOvSdTvwqPolommh8Dl8dGo/I4OBoildN8e7ze7POTr08w0ZGfYNKe89
         +jxA==
X-Gm-Message-State: APjAAAXqfPG0I/tJcGzVceaiTALGCzZxb7+lPYlVmTH8Nc4Xcf50w4ln
        SRpdUUAOBOfKBKO+THJbWLw=
X-Google-Smtp-Source: APXvYqykOW8DBg++MEZzLBMV1jVOWJRZFOWwgqriD5aTx1V21CwR+2x7Bg2km6Aa9r9ts2qbHE2J7g==
X-Received: by 2002:a1c:28d4:: with SMTP id o203mr15485931wmo.123.1577392631651;
        Thu, 26 Dec 2019 12:37:11 -0800 (PST)
Received: from localhost.localdomain (p200300F1373A1900428D5CFFFEB99DB8.dip0.t-ipconnect.de. [2003:f1:373a:1900:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id q3sm32911665wrn.33.2019.12.26.12.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 12:37:10 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org, jianxin.pan@amlogic.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [RFC v1 0/2] dwmac-meson8b Ethernet RX delay configuration
Date:   Thu, 26 Dec 2019 21:36:53 +0100
Message-Id: <20191226203655.4046170-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Ethernet TX performance has been historically bad on Meson8b and
Meson8m2 SoCs because high packet loss was seen. I found out that this
was related (yet again) to the RGMII TX delay configuration.
In the process of discussing the big picture (and not just a single
patch) [0] with Andrew I discovered that the IP block behind the
dwmac-meson8b driver actually seems to support the configuration of the
RGMII RX delay (at least on the Meson8b SoC generation).

The goal of this series is to start the discussion around how to
implement the RGMII RX delay on this IP block. Additionally it seems
that the RX delay can also be applied for RMII PHYs?

@Jianxin: can you please add the Amlogic internal Ethernet team to this
discussion? My questions are documented in the patch description of
patch #2.

Dependencies: this series is based on my other series [1]
"net: stmmac: dwmac-meson8b: Fix the RGMII TX delay on Meson8b/8m2 SoCs"


@David: please do NOT merge this series yet, it's only meant for
discussion in it's current state!


[0] https://patchwork.kernel.org/patch/11309891/
[1] https://patchwork.kernel.org/patch/11310669/


Martin Blumenstingl (2):
  net: stmmac: dwmac-meson8b: use FIELD_PREP instead of open-coding it
  net: stmmac: dwmac-meson8b: add support for the RX delay configuration

 .../ethernet/stmicro/stmmac/dwmac-meson8b.c   | 60 ++++++++++---------
 1 file changed, 33 insertions(+), 27 deletions(-)

-- 
2.24.1

