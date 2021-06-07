Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D234F39E94A
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 00:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbhFGWK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 18:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbhFGWK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 18:10:56 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD13FC061574;
        Mon,  7 Jun 2021 15:08:51 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 27so14933553pgy.3;
        Mon, 07 Jun 2021 15:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cQWq5cDP3SREVVhOXmeUcr+Mla/FLWvh/VEh7hiubGM=;
        b=Wh6UkYyBky9wH8nM3L/jqQyIdhqB03mu2SA9SOmAELPX7V3oPFb2g3F/iyIqpiFmGf
         yQeurbaUyTFqahkZcFN9UC77rv04TwGomLgzO2OO5zrmlOaDQ4Ru33NMYQ5CvV9g7o+u
         FX/vyyNO5tRedmmMqTtoPTh0iOy/Fh6TcyAPJdDLGJtqVztNO/N5CpZ41P1/0xNvq0sh
         8Ov48OeIk03nR5Tlje4n2h0tTAv4AldQXEEa8YmIrXe0IqJlVubqvBXkuTa9Nybc0tJ2
         +4yZ192yXjAXlKtPJcEozpHDvK4jjY+/gJRC6txm84c3wtGeiSzHUese3q6Sv2q+5TRv
         SxOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cQWq5cDP3SREVVhOXmeUcr+Mla/FLWvh/VEh7hiubGM=;
        b=bTqVBigCucm7IDgLA6nmZvBJYPW8xTaOK50mOPVezuweI9+2T+wWiibMdzPZQhIl+U
         RNaNk3spFx93rpoXbi9Hhxb+Bk1X48kLczz8rmgiCWAX6hY4zzDKSv70EfNMwf1Ow8pq
         FTb/ZuwFhWc26Nf7Kde35jr5nQsX0n94RdE8A/ewZO9cZVCysXOoRSFqtOJ9kC5OjYi7
         4zo4Qx8qe+d0LoKrsE+SgbnI44WBHyg22W38l1BDw/hhkigY7nxBQ+DkdPkoW87Xm+Rz
         ZvPnyoELmCA28B89OF85f3Og9hoRHVywgq8l3e5fv095ZmN1GRUZjrkDQFZWSqh3ZFu2
         I6/A==
X-Gm-Message-State: AOAM532jRhdkmFyq+7xYIXX7pr8bPho1DoUBCmRkxb0vfW5SqDUkQEpq
        OrXBVWk6oHVHbCGr0x561Z9YB7vlmZI=
X-Google-Smtp-Source: ABdhPJzG+CtMisXIGcaXiz8h8/eTr99y9olE7WkqBfXYPSQiCCoZINfnGslCojzvnYLpxkhPqbE/gw==
X-Received: by 2002:aa7:8543:0:b029:2e9:e077:21f6 with SMTP id y3-20020aa785430000b02902e9e07721f6mr18842338pfn.69.1623103730626;
        Mon, 07 Jun 2021 15:08:50 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h8sm9144845pfn.0.2021.06.07.15.08.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 15:08:50 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list),
        Matthew Hagan <mnhagan88@gmail.com>
Subject: [PATCH net-next 0/2] net: dsa: b53: Remove unconditional CPU VLAN tagging
Date:   Mon,  7 Jun 2021 15:08:41 -0700
Message-Id: <20210607220843.3799414-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series removes the unconditional egress tagging of VLANs
added to a b53 switch's CPU port. This had led to adding the
untag_bridge_pvid attribute in the DSA framework and is causing problems
with stacking of switches such as the configuration being used by
Matthew.

Since we use Broadcom tags for all of the supported switches nowadays
the original situation that led to doing this unconditional egress
tagging is no longer warranted.

Florian Fainelli (2):
  net: dsa: b53: Do not force tagging on CPU port VLANs
  net: dsa: Remove bridge PVID untagging

 drivers/net/dsa/b53/b53_common.c |  5 ++-
 include/net/dsa.h                |  8 -----
 net/dsa/dsa.c                    |  9 -----
 net/dsa/dsa_priv.h               | 59 --------------------------------
 4 files changed, 2 insertions(+), 79 deletions(-)

-- 
2.25.1

