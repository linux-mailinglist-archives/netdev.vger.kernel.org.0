Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E08C9C50C
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 19:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728623AbfHYRZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 13:25:56 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46100 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728467AbfHYRZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 13:25:56 -0400
Received: by mail-qk1-f196.google.com with SMTP id p13so12331384qkg.13
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 10:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2JOjdLiFFKqTlY3/I8UCZdsYuTUk1juaOz+ZIUz23c0=;
        b=Mdz0FCKCeICOM9h1ucfFynLEJMY7kbt+5R+L0XB8viFcgjSSqZlyMxADurNOVZZgND
         AfdDhvFg1aZbTrwfDEU7QjR5yMGH5XV6GZYUc13K9mqHHgvkAcx2vNJ8MyjUV7JiE2yC
         6qAd7IGPzsCveQrXRdvQV32JqC6mtF8Mm3c9hLWAj6ijYEtqfbCVhfqNT/EHWcOgV9Kt
         TO5MkZuBlZVwX+BnBxC61XPjrYmtxKDtXdtTHNu93lVygm85Nc09U/pvGv6VwHy5r2rF
         L0eW9xWsd/yY8HJj8zUz5p1hiUImstH7SDXs9vln2Jf7ZRgpZzfhTeQHqGhJtU6Y/vtS
         E5kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2JOjdLiFFKqTlY3/I8UCZdsYuTUk1juaOz+ZIUz23c0=;
        b=TVApaZhPtk0YNfMF8LZaoyX0QIobsuHdBNETZHPwIfyEa6A+F7uV0/2WgH8+qaYaEH
         sCBnmgEuPEQgfE1Hcm6/eEaM5vTSGeVz4nzFvsuayEM76xodJWUZJUn9nspYAE8otSyA
         aw84qPit3doVOjuMMlH1UyBpEYi2GutqhwKyOENgq9PFYV7L+crdSwuJKHD45CRO5u9v
         npaFdPK8gbQoOFf+U2XcsJPxrkU8P0HBGK8UpMF1qUNSy7M4Yq+GrFCEb40F0lOOw3XV
         aaZkYxFHuPntmuhyvpr3fq/8h3A94B2oB2JN9bQHBnFbWY+GDYfPRkBlrtjsdTOuvvUO
         6jzQ==
X-Gm-Message-State: APjAAAUOteZo6ud1Uxz0DYOkT5GNxuOJqEUnwH2XeQmDccTVp/LRpOCD
        vgCKlDdpxtfwioehELZwDkBCzKWs
X-Google-Smtp-Source: APXvYqyyAmXPgIGYPhvAxWyk37AcVMMG4OVKR0vrNkXfEDLJdLPqy51UvhaOTAWVUQ+CgOqAstqShA==
X-Received: by 2002:a37:444b:: with SMTP id r72mr12980339qka.361.1566753955043;
        Sun, 25 Aug 2019 10:25:55 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id p186sm5677290qkc.65.2019.08.25.10.25.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2019 10:25:54 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, f.fainelli@gmail.com, andrew@lunn.ch,
        olteanv@gmail.com, Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next v2 0/6] net: dsa: explicit programmation of VLAN on CPU ports
Date:   Sun, 25 Aug 2019 13:25:14 -0400
Message-Id: <20190825172520.22798-1-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a VLAN is programmed on a user port, every switch of the fabric also
program the CPU ports and the DSA links as part of the VLAN. To do that,
DSA makes use of bitmaps to prepare all members of a VLAN.

While this is expected for DSA links which are used as conduit between
interconnected switches, only the dedicated CPU port of the slave must be
programmed, not all CPU ports of the fabric. This may also cause problems in
other corners of DSA such as the tag_8021q.c driver, which needs to program
its ports manually, CPU port included.

We need the dsa_port_vlan_{add,del} functions and its dsa_port_vid_{add,del}
variants to simply trigger the VLAN programmation without any logic in them,
but they may currently skip the operation based on the bridge device state.

This patchset gets rid of the bitmap operations, and moves the bridge device
check as well as the explicit programmation of CPU ports where they belong,
in the slave code.

While at it, clear the VLAN flags before programming a CPU port, as it
doesn't make sense to forward the PVID flag for example for such ports.

Changes in v2: only clear the PVID flag.

Vivien Didelot (6):
  net: dsa: remove bitmap operations
  net: dsa: do not skip -EOPNOTSUPP in dsa_port_vid_add
  net: dsa: add slave VLAN helpers
  net: dsa: check bridge VLAN in slave operations
  net: dsa: program VLAN on CPU port from slave
  net: dsa: clear VLAN PVID flag for CPU port

 include/net/dsa.h |   3 --
 net/dsa/dsa2.c    |  14 -----
 net/dsa/port.c    |  14 ++---
 net/dsa/slave.c   |  79 +++++++++++++++++++++++----
 net/dsa/switch.c  | 135 +++++++++++++++++++++-------------------------
 5 files changed, 136 insertions(+), 109 deletions(-)

-- 
2.23.0

