Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9BDA9FA17
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 07:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbfH1F5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 01:57:13 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:33559 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbfH1F5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 01:57:13 -0400
Received: by mail-ed1-f68.google.com with SMTP id s15so1628694edx.0
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 22:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OrxhOu1nWxI0faPCB+H7oArBSAeGruB3cm87QNbaLCY=;
        b=Z5t4YhKDMk431eMolzSpuzwoIQGSlFsI8PbeD1+GJ8twXhTZPoTT8AQ93K3m4iW/es
         7QIlerw4Mr9Zt1wmWfR9CkiDH+zg4PdjahRwaJgSUPXgsBxqUuYrZ5Egpcfocbawa3UV
         VrSwvRLcZBkWsaSZDQUTqso18NvUBDwzaejKTpUs6203OFRR8vSQ8xm25E2htj11GYbL
         SiCg7fFhii5QF4NLjjJ15SnTpKA6LNkzS1Jd4dNNj/Dd0xGdklSRM0kcd+qTlQft4vfW
         f0Lc2SfJELwN9I7w/+Y859CK05WHStiLZbrdUcCOTuq2miatbGpaEJoZtySq65RUOO/4
         NYQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OrxhOu1nWxI0faPCB+H7oArBSAeGruB3cm87QNbaLCY=;
        b=m8Xjce5Sa7cTXoy7HOrkJlOIz6NFWnUHMSoXUgAEs0Y2C3/s58ddRkp1smGHZHThEm
         Sm4fIbQLQ1cJTKrHKGcSj+pHBe2pCTaofJ+LFiut38GMajD5k7u6OxlXFq4ArNpvLmB1
         U+4rt01NUiAHxfa8swLYbc/9sEb1dvzF7DEBcsnez51/9yZ17/TeIPhoSr3poblU4Rro
         MYAwhtMuFVSWj0uiTbrrfP8E+vlL0qa3/b6XLRErSN1e+hogi4OWpBySxX7u8P+y2S/Z
         2Nq5DZHMvf24hd0FjZT6x2zvoyYHrsNuPSZXOR2YThtyZN/XoGZbVHlFbw7mClJvkfXy
         WRQA==
X-Gm-Message-State: APjAAAUAOfuVTIxZ80eQxi+rGrpfY11b9YwSwP2UZJKoQVvya6maiiXW
        hafZcXPxfZbuFEVy/9PDbgmqgQ==
X-Google-Smtp-Source: APXvYqw9mJRH2NjBcy5PDDAgxsvYbaA5ldLlD8LgIVZpribJyonJlHrEdMGC66zOFRY5U/w9TxJbZA==
X-Received: by 2002:a17:906:f211:: with SMTP id gt17mr1569816ejb.263.1566971831872;
        Tue, 27 Aug 2019 22:57:11 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z2sm222202ejn.18.2019.08.27.22.57.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 22:57:10 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net 0/2] nfp: flower: fix bugs in merge tunnel encap code
Date:   Tue, 27 Aug 2019 22:56:28 -0700
Message-Id: <20190828055630.17331-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John says:

There are few bugs in the merge encap code that have come to light with
recent driver changes. Effectively, flow bind callbacks were being
registered twice when using internal ports (new 'busy' code triggers
this). There was also an issue with neighbour notifier messages being
ignored for internal ports.

John Hurley (2):
  nfp: flower: prevent ingress block binds on internal ports
  nfp: flower: handle neighbour events on internal ports

 drivers/net/ethernet/netronome/nfp/flower/offload.c     | 7 ++++---
 drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c | 8 ++++----
 2 files changed, 8 insertions(+), 7 deletions(-)

-- 
2.21.0

