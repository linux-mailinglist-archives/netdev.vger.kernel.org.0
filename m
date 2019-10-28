Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8780CE7C5E
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 23:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728648AbfJ1Wcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 18:32:47 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36933 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfJ1Wcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 18:32:47 -0400
Received: by mail-wm1-f68.google.com with SMTP id q130so538435wme.2
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 15:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=30j0r90v+vdWIBwesrfx/8ZuqooghksbmUkzpHsmyDs=;
        b=YdpipMZvCuDzPgh/7AsHcnTaYOY/WmgFr9QGWcDMnbArHjM2hlRUHtpra35prbrAmm
         WR0eybPEsvqv2pVmTuqkvhg0dAV9h0KjLCe9+lRZqYcdyymvLQmK+ECTDp23vFZHBKTz
         Sti6+zYhTwiObT/YmxhF+jyHFEYy4MXfUSm9f1RFjsbET7qvXKi1Os/z4Ut9ukkuxQrJ
         RAS4ObxiaPcnk3jpLTEBMYH4cIaUBBwvdz8BWIhpsGpKg8is3jN+CWi8gYU0zgM+xtBr
         wmJCCKW9IkF+ckbFTLGq1qFjD3IQPPY6jhDfBpdH+Ar8UmnBRrbQthOsT/MATfNO74i3
         4xSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=30j0r90v+vdWIBwesrfx/8ZuqooghksbmUkzpHsmyDs=;
        b=eYvCpU+RD5+SHU//X8elRRF8SZFus5LZ1NwooIxnxRweOJyX7ZXytfOu71zepH/ISM
         +8UkESPaB+Uu6OldeJB2n11ooHQntAQe82TG7FzaxXB4whg+OhIkDlDS0y9lzZ8edadN
         LyNQ27raXvoGUHpS3WaYvoIiE+vHk/S5DrPx23jHfDu0sEr1qKBPNCzYxQB/ito7z5hK
         M5hWoVi6gbDHiI4HNFSxq9WqE9FPf2Vmi1VM4lzpmnOWlpXIHORJyQ6udZ0uFz65f0AS
         SDsCqTM9FjB9UCxfAMpcmSPGEoIsJ3uktPy0vaX5kyF3X1BxVXRR7kE6rS1CGI74LG00
         hiZA==
X-Gm-Message-State: APjAAAV4j3HpDVXZwJjV+pytLNfFKZj+c00JPDOxolibF0Rrxy/p6pF+
        pk7KeZrXUflTd9lKbVIQZAVbpxqi
X-Google-Smtp-Source: APXvYqz0MdT8pe4WeYB1o+B06KFfFJ9h3teVqsgIW4T0a502bFwMx3ntlx/lrldYlui5PPi1G/ZABg==
X-Received: by 2002:a1c:3843:: with SMTP id f64mr1210782wma.129.1572301965245;
        Mon, 28 Oct 2019 15:32:45 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s21sm17551607wrb.31.2019.10.28.15.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 15:32:44 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 0/2] net: dsa: Add ability to elect CPU port
Date:   Mon, 28 Oct 2019 15:32:34 -0700
Message-Id: <20191028223236.31642-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

This patch series solves a problem we have with Broadcom switches
whereby multiple CPU ports can be defined, and while they should all be
possible choices, it may not be desirable to use, say port 5 instead of
port 8 because port 8 is hard wired as the management port in the switch
logic, or because it simply offers more features.

Add an election callback into the driver to allow the selection of a
particular CPU port when multiple are defined.

Florian Fainelli (2):
  net: dsa: Add ability to elect CPU port
  net: dsa: b53: Add CPU port election callback

 drivers/net/dsa/b53/b53_common.c | 17 +++++++++++++++++
 drivers/net/dsa/b53/b53_priv.h   |  1 +
 drivers/net/dsa/bcm_sf2.c        |  1 +
 include/net/dsa.h                |  1 +
 net/dsa/dsa2.c                   | 19 +++++++++++++++----
 5 files changed, 35 insertions(+), 4 deletions(-)

-- 
2.17.1

