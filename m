Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3547478949
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 12:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbfG2KLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 06:11:14 -0400
Received: from mail-pg1-f172.google.com ([209.85.215.172]:39841 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbfG2KLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 06:11:14 -0400
Received: by mail-pg1-f172.google.com with SMTP id u17so28007062pgi.6
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 03:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=hjnHrIoiyTd4+k+1YYZaghy8VywTzr16ySF99/m0V+8=;
        b=Ph2+NL7ySbyQQr9CdgiVB8B21oJZx2KSNjyy45TcbQaPtBHvAzvHGCrOszF9zCFXbm
         LKRhfQnGjGbn/235taubOzBabLeeiLmBvDp/Lg9EUE1Dgc3dZNFDKZiq4ERE2h095b2l
         2xMmKZPz+SR7frqOD+vcE7VXyX61p1OcExU8M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hjnHrIoiyTd4+k+1YYZaghy8VywTzr16ySF99/m0V+8=;
        b=tiLG5h5yIydR9M2qYlfehn3+FinK6v4yQst9STXJepRwM1Mb2/Cwh5X6aFXZmPRurK
         l8mR/hTKv+adevxlJb6tLnW+88C4zrQF9yTUvq4YZJViuYwsQwjQ1qOFtH1b9M0nLaaR
         fHHgy9qDooUMw5oqH7N6zd3dD7njwqPi3eyU3++u4DkYAyVlNnZRIxtabEudhN7c2kJh
         nsEgvWo4JqRIuBkXJn+4BQD06FoVSSpOC82Ve3F2Et5yMmpwgoADhv9pcUD56Xon0ZKw
         xwwzeGZuNyLV93IP9KMNX2fqhs0zYiwmbRxvJ8ZOHghmwt8jpowSgJYvfY23sDpuHOAL
         6JRg==
X-Gm-Message-State: APjAAAU2+wJ3Us6PpDBBivs/vgzazE3tg5fg6htzh0nNoV1OJmevUPEM
        p0hpq4hPe49FR2chYqcrkHaDbcYK9zs=
X-Google-Smtp-Source: APXvYqwnU9wFG2ng895FyyFNKNzfzNyjFjZECF9ISjEp90anAZpDNGENZpS8b9ykFjBZFPzJxbdx6g==
X-Received: by 2002:a17:90a:bb0c:: with SMTP id u12mr113041748pjr.132.1564395073494;
        Mon, 29 Jul 2019 03:11:13 -0700 (PDT)
Received: from localhost.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e124sm99045812pfh.181.2019.07.29.03.11.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 03:11:13 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 00/16] bnxt_en: Add TPA (GRO_HW and LRO) on 57500 chips.
Date:   Mon, 29 Jul 2019 06:10:17 -0400
Message-Id: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds TPA v2 support on the 57500 chips.  TPA v2 is
different from the legacy TPA scheme on older chips and requires major
refactoring and restructuring of the existing TPA logic.  The main
difference is that the new TPA v2 has on-the-fly aggregation buffer
completions before a TPA packet is completed.  The larger aggregation
ID space also requires a new ID mapping logic to make it more
memory efficient.

Michael Chan (16):
  bnxt_en: Update firmware interface spec. to 1.10.0.89.
  bnxt_en: Add TPA structure definitions for BCM57500 chips.
  bnxt_en: Refactor TPA logic.
  bnxt_en: Expand bnxt_tpa_info struct to support 57500 chips.
  bnxt_en: Handle standalone RX_AGG completions.
  bnxt_en: Refactor tunneled hardware GRO logic.
  bnxt_en: Set TPA GRO mode flags on 57500 chips properly.
  bnxt_en: Add fast path logic for TPA on 57500 chips.
  bnxt_en: Add TPA ID mapping logic for 57500 chips.
  bnxt_en: Add hardware GRO setup function for 57500 chips.
  bnxt_en: Refactor ethtool ring statistics logic.
  bnxt_en: Allocate the larger per-ring statistics block for 57500
    chips.
  bnxt_en: Support TPA counters on 57500 chips.
  bnxt_en: Refactor bnxt_init_one() and turn on TPA support on 57500
    chips.
  bnxt_en: Support all variants of the 5750X chip family.
  bnxt_en: Add PCI IDs for 57500 series NPAR devices.

 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 542 +++++++++++++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  95 +++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 156 +++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h     | 109 ++++-
 4 files changed, 666 insertions(+), 236 deletions(-)

-- 
2.5.1

