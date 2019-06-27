Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B748358D52
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 23:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfF0VrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 17:47:05 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40616 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfF0VrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 17:47:04 -0400
Received: by mail-wm1-f67.google.com with SMTP id v19so7036584wmj.5
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 14:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=/R0TUo9QcJ1kqXfBMmYmy70AoR3WBIqh+6DSJVygrmg=;
        b=C+zkyaQijV4O2BWcajf289BbtEgyWccq2Zsilqi1rQp7jtDXVNnfc2RnTLyxHu5znS
         kbnB1sLdmqPqSrne4tBbAuM7MM5DCEnz8vZEC+FVBK9zNuIKu6Ut435vnBvnCBUs5poy
         UZ/3CjCPrnxHaiOqLPOmWd6tgzKKhHRTugX+CwZLCOZJxyPxMrKKzPEftYS56yOiy9kM
         VpMOtuptADmJH+tNxh6Aj7KKeLMsRboZYqKR2x45jcSNicNkHXo90ZnO0uktvt9lb0EF
         ifD84SzeZHNyhwLgmsQjEiKEHH/GsdVp+3log4kncWfsTvM4YcwIVglqwiYfGwlRJtXg
         ry+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/R0TUo9QcJ1kqXfBMmYmy70AoR3WBIqh+6DSJVygrmg=;
        b=M+ZrrAUcXDTz5WqzbQHbR/yVt+SEUvI29ANeKOPJLXfu2sm//7IRZs9WZuaCNe+9n4
         mg9EVevbISW/khrwwrhdjuO05GvYVfrVuHTreDG+WtFloMn9F4MFm+iz5PvsrCyfM0cH
         nkK39radVN5NUdq5nL8S/0LWx7apV8ZE/dQ5xDx3jD1o8R28xnF5bW8PnbbYkIejz6C0
         wt12Z5OhLsoyOlD4pEWz2f5HASqtjB2+CsGnKnmZNF1OoYv5NI3xshU8mxq66uqylyPk
         4k0fLD4XQ9dFqkDy4h0rn3CqBt2cvSszqMecGnbIYbIjKx8Nlezs2lrjjv7i7myJnOmH
         HfUg==
X-Gm-Message-State: APjAAAUxLLoQ5vRHtUOvzsHf1/Zp/7RcAkiTHDLmEkrjVQxLL+YbvOby
        d0deTTo5mojfcZUW+2AaKuE=
X-Google-Smtp-Source: APXvYqy8NiSxaP0VLk8MsYaHwTruauC6lK5WHaUjKIAthwR0mRq3xOVhe1onB9puxmM20d/0ecKHUQ==
X-Received: by 2002:a1c:7310:: with SMTP id d16mr4416906wmb.107.1561672022115;
        Thu, 27 Jun 2019 14:47:02 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id v18sm286923wrs.80.2019.06.27.14.47.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 14:47:01 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     linux@armlinux.org.uk, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 0/3] Better PHYLINK compliance for SJA1105 DSA
Date:   Fri, 28 Jun 2019 00:46:34 +0300
Message-Id: <20190627214637.22366-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After discussing with Russell King, it appears this driver is making a
few confusions and not performing some checks for consistent operation.

Changes in v2:
- Removed redundant print in the phylink_validate callback (in 2/3).

Vladimir Oltean (3):
  net: dsa: sja1105: Don't check state->link in phylink_mac_config
  net: dsa: sja1105: Check for PHY mode mismatches with what PHYLINK
    reports
  net: dsa: sja1105: Mark in-band AN modes not supported for PHYLINK

 drivers/net/dsa/sja1105/sja1105_main.c | 56 +++++++++++++++++++++++++-
 1 file changed, 54 insertions(+), 2 deletions(-)

-- 
2.17.1

