Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41E3FDF73B
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 23:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730292AbfJUVEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 17:04:12 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52258 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728943AbfJUVEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 17:04:12 -0400
Received: by mail-wm1-f67.google.com with SMTP id r19so14896739wmh.2
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 14:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vz6SZ5qRWOCKtnWSGLZt4796vIT2RXcHgot7XATbvTg=;
        b=anT7O02BIlrKzusxPDGHTl7/ATJ95BVRJalOPofXt3l+WQ7vV+PijeHyfP+mFPeaYd
         Ey/9kGIOhT6x6OUTwMHFAkGYqceet2Bg1lViyWrLYO3yIccI1RXlgoGA9atE9SlFLs1e
         QIFbtIvHVv395xXE0uwFxN5WwtmCMVX70AfQ3dLUbRRHMGxRgLRIL+7DSWoyNmmDKkci
         SSiH10XMQcLP7yIig4DAFEIlsxISqRX5uMN0maRKfxXo7ADr2u0R3GB9noSOvDh3NlYK
         d+IsGyxgF78lxa0c6XjkDjbhkBcGsy7Vsk6k/OaVCdnwf9Idg8yFzniXVGmab9g06CxD
         e7hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vz6SZ5qRWOCKtnWSGLZt4796vIT2RXcHgot7XATbvTg=;
        b=SoEeJmBgpiig+TOkiH8aIn+EeiJMsFZwhJagfac6E9DivtWgjnm3rhhjhv7MWJqA+q
         bRiFIY9+C/rlU4t/SALgM2arMjXkaJGGiyIGXHn4JGRL/GnzISN5RmKq6GcptAXPs3UL
         HUlMP+JgWsr5xOWWThjECAWI9+wO4xBgIgZbydoKMS/08PCZcCpPzxPfGAysPSejzu/h
         g0MBUO/tpGer3SeIr0REdrZTXD0mnHEL8nL0KkLggZ/bCd64qVxjgJlQEn2S+r1ScNUZ
         O6WvvkIJogvs3Oh42cOJ9x2K2FLaCl9Zi5F0tl8pdjADDYBIsnl+Chg5IBTvJFBIiSbl
         Ilog==
X-Gm-Message-State: APjAAAXme53kZ5fhCQT2yPptt8ge0C3CDwOt2WI5ZTga9eZb/emdbbiK
        +9k5tus2goOHd38Z/Q0TS3fjf/Ox7AUG6A==
X-Google-Smtp-Source: APXvYqzHiFRMpG849iQt7hK9B/LKxI7t+zrbJDJdRjoJwiFXyzRLxd+D3svdAcRny7PaCNMRvL5ExA==
X-Received: by 2002:a7b:c631:: with SMTP id p17mr21123719wmk.5.1571691849979;
        Mon, 21 Oct 2019 14:04:09 -0700 (PDT)
Received: from i5wan.lan (214-247-144-85.ftth.glasoperator.nl. [85.144.247.214])
        by smtp.gmail.com with ESMTPSA id g5sm14309949wmg.12.2019.10.21.14.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 14:04:09 -0700 (PDT)
From:   Iwan R Timmer <irtimmer@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, Iwan R Timmer <irtimmer@gmail.com>
Subject: [PATCH net-next v2 0/2] net: dsa: mv88e6xxx: Add support for port mirroring
Date:   Mon, 21 Oct 2019 23:01:41 +0200
Message-Id: <20191021210143.119426-1-irtimmer@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch serie add support for port mirroring in the mv88e6xx switch driver.
The first patch changes the set_egress_port function to allow different egress
ports for egress and ingress traffic. The second patch adds the actual code for
port mirroring support.

Tested on a 88E6176 with:

tc qdisc add dev wan0 clsact
tc filter add dev wan0 ingress matchall skip_sw \
	action mirred egress mirror dev lan2
tc filter add dev wan0 egress matchall skip_sw \
        action mirred egress mirror dev lan3

Changes in v2

- Support mirroring egress and ingress traffic to different ports
- Check for invalid configurations when multiple ports are mirrored

Iwan R Timmer (2):
  net: dsa: mv88e6xxx: Split monitor port configuration
  net: dsa: mv88e6xxx: Add support for port mirroring

 drivers/net/dsa/mv88e6xxx/chip.c    | 79 ++++++++++++++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h    |  9 +++-
 drivers/net/dsa/mv88e6xxx/global1.c | 34 ++++++++-----
 drivers/net/dsa/mv88e6xxx/global1.h |  6 ++-
 drivers/net/dsa/mv88e6xxx/port.c    | 29 +++++++++++
 drivers/net/dsa/mv88e6xxx/port.h    |  2 +
 6 files changed, 142 insertions(+), 17 deletions(-)

-- 
2.23.0

