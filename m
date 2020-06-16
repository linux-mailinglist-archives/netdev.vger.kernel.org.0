Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7BE81FC281
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 01:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgFPX7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 19:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgFPX7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 19:59:20 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E1CC061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 16:59:19 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id mb16so308164ejb.4
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 16:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+JDBYKlRdb+CcegLXXw7ZVujq8B8UOK5Eie5u0o0THA=;
        b=FAzm2QNDPMKUYVS+fvF5eIYnIDYwPiDbJN/+foKe21LrWXyn6NfBOPEZcwQQH6ww/2
         xze0mtlFh9e7+vY2k8pgwhrH8lgpg6Tdwa3H+vuhTT9/aw0u/pVZkaP3EFn9dzZutm+L
         f+FUtmqBv8ysWXFg2mUHXsfoOwww+3Rgb+ql9Cz8/wTS10rfefTodhw1VmKgn66Frbsh
         7nuLq3BfQgtQuf9qgJg/Tc5wigmHPgOR2Eea44I9VgCAiyEmK8xE06EfnoA464Sdqs8l
         bzbm6B2YyjQ+ONznjnRaSIY6jLUs5Konyqwo4cUch2MKZoX5FuZGuHDrubWojtii4E2r
         srBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+JDBYKlRdb+CcegLXXw7ZVujq8B8UOK5Eie5u0o0THA=;
        b=YCufiOUhunADRsRrSNAljInrw7HZk8kDlDc1sQjcU66hcAXIQGb1K5aRQlmpupNBsk
         oi0qzdUc1p1omb5I7FFvjLnMcnXWuY9LoaeGYN3Pg+NAttBPSqB4R4M7C56nfT3wbEIE
         VDj7b9u2lNOksOLBeHYLLAcTDICNF5nl+8VVI260JnfPVjnlym+132r6eKA1M9fEoA3M
         Jtwk4tnicHKRSzXZRfzOUNcVXJj0WjQ5g+NRsKoZWiyG3BPKX7/9pT1H65reQWgfh2j7
         KzAKZs7yY1YUDOQsNEUuq0+yrnPjaKGba9wWyxi/MbNMkuZtuKpRhIdSA6u7XZccfkyp
         fTcQ==
X-Gm-Message-State: AOAM533zKKfPxZNObrujV7HM8QdChPZgLmg3oz8bGW2eaLhZCLw+5LcV
        BEf2ECqrCzvgtwGOxROKMCfuK0Eb
X-Google-Smtp-Source: ABdhPJyDE2xaMJN9p3pcOEym9xHuFZJxSWkiPZyDBbLBQMtstAKyG6xi9uMSak6+TQTSZe+uj4zVIw==
X-Received: by 2002:a17:906:76c4:: with SMTP id q4mr5334387ejn.371.1592351958068;
        Tue, 16 Jun 2020 16:59:18 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id o24sm11814123ejb.72.2020.06.16.16.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 16:59:17 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: [PATCH net 0/3] Fix VLAN checks for SJA1105 DSA tc-flower filters
Date:   Wed, 17 Jun 2020 02:58:40 +0300
Message-Id: <20200616235843.756413-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This fixes a ridiculous situation where the driver, in VLAN-unaware
mode, would refuse accepting any tc filter:

tc filter replace dev sw1p3 ingress flower skip_sw \
	dst_mac 42:be:24:9b:76:20 \
	action gate (...)
Error: sja1105: Can only gate based on {DMAC, VID, PCP}.

tc filter replace dev sw1p3 ingress protocol 802.1Q flower skip_sw \
	vlan_id 1 vlan_prio 0 dst_mac 42:be:24:9b:76:20 \
	action gate (...)
Error: sja1105: Can only gate based on DMAC.

So, without changing the VLAN awareness state, it says it doesn't want
VLAN-aware rules, and it doesn't want VLAN-unaware rules either. One
would say it's in Schrodinger's state...

Now, the situation has been made worse by commit 7f14937facdc ("net:
dsa: sja1105: keep the VLAN awareness state in a driver variable"),
which made VLAN awareness a ternary attribute, but after inspecting the
code from before that patch with a truth table, it looks like the
logical bug was there even before.

While attempting to fix this, I also noticed some leftover debugging
code in one of the places that needed to be fixed. It would have
appeared in the context of patch 3/3 anyway, so I decided to create a
patch that removes it.

Vladimir Oltean (3):
  net: dsa: sja1105: remove debugging code in sja1105_vl_gate
  net: dsa: sja1105: fix checks for VLAN state in redirect action
  net: dsa: sja1105: fix checks for VLAN state in gate action

 drivers/net/dsa/sja1105/sja1105_vl.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

-- 
2.25.1

