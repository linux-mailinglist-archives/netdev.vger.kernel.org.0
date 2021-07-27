Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF383D7B7A
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 18:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbhG0Q7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 12:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbhG0Q7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 12:59:33 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48135C061757;
        Tue, 27 Jul 2021 09:59:33 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id y34so22850353lfa.8;
        Tue, 27 Jul 2021 09:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vTeh6VbbYsj9f6GlVnyKqvFD7Pi3rNV+8FVn0kIFR3w=;
        b=DlS3YxRq//bglw78WkwV9CcJ13gEuBon+seDIVZSy1C0V2Hiv4C2fOZ/s0zV0ajyC8
         JGNKgqWYLCvZX+Hsu4cQXq12eDVH7oF//OeWRZL6SsKYCmpazJtyD+Qcru+LCa9PLzvU
         EseHtN5IWjS0GFwdBehmF9lMntPr3p/vjlWVOEMDyEanJVXy6PdifzgNYcl8Zg5NdY5G
         LSr7SDEHM9VxKNvqTo0vR9SxU4hpsPjH7Os971PYJWog4lwNZnmMPkKhhs2IOOhZdEx9
         ulPohixnitgElBB+TIamkLCeBqiUEqUzBO4nS575bzrrM2YcL9VHMyYgCTVlqRKdAvRx
         jgRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vTeh6VbbYsj9f6GlVnyKqvFD7Pi3rNV+8FVn0kIFR3w=;
        b=B+utq6n4RCIl/ScoRfZ30JJ154iv1r1SHEUF+54NjcuYe3eiEs8YVaJ0Y8GcsLxT77
         WNpipSSWMNko4XpI6Q+LXE4yLjsmwwdQ9XAijH805Wp+b61v99b+dRQRfkQdV+FLlUKQ
         R6k10t8xUCVaH3x6rFHZ77we1q+QnhCU1vygsYGG09MFM1yfwKAfMXx39NPQ6Y3qfP4B
         DiQ0tO3g1Odd9knRtidIjOZ4vaf13WZozJ17AceWsufbRbae/O+gKypVrGJRQIXE1+nm
         Cesoh5C+O1iPzbkFotDLdT4aMld/JwEbVE3+8CdpRWbpCAYskwh2Q+0peSAoKXXT3Q0Y
         zGhQ==
X-Gm-Message-State: AOAM533EgXRJSAoreytQIA05JYtdDj+PBiUHZBB893kVVTpDhFCCgD2y
        8p8A8QnS+VpQnv6H7fzZ0Jc=
X-Google-Smtp-Source: ABdhPJzhkDj65DkkzEu+b8QLoNX1qD3itoTbSLfhcqZyRhlnA6fZYTXjXwSjVlK9daILqKljBzvENg==
X-Received: by 2002:a05:6512:1cf:: with SMTP id f15mr17236538lfp.261.1627405171629;
        Tue, 27 Jul 2021 09:59:31 -0700 (PDT)
Received: from localhost.localdomain ([94.103.227.213])
        by smtp.gmail.com with ESMTPSA id r200sm340941lff.208.2021.07.27.09.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 09:59:31 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, mailhol.vincent@wanadoo.fr,
        socketcan@hartkopp.net, b.krumboeck@gmail.com,
        haas@ems-wuensche.com, Stefan.Maetje@esd.eu
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH v2 0/3] can: fix same memory leaks in can drivers
Date:   Tue, 27 Jul 2021 19:59:12 +0300
Message-Id: <cover.1627404470.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1627311383.git.paskripkin@gmail.com>
References: <cover.1627311383.git.paskripkin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Marc and can drivers maintainers/reviewers!

A long time ago syzbot reported memory leak in mcba_usb can driver[1]. It was
using strange pattern for allocating coherent buffers, which was leading to
memory leaks. I fixed this wrong pattern in mcba_usb driver and yesterday I got
a report, that mcba_usb stopped working since my commit. I came up with quick fix
and all started working well.

There are at least 3 more drivers with this pattern, I decided to fix leaks
in them too, since code is actually the same (I guess, driver authors just copy pasted
code parts). Each of following patches is combination of 91c02557174b
("can: mcba_usb: fix memory leak in mcba_usb") and my yesterday fix [2].


Dear maintainers/reviewers, if You have one of these hardware pieces, please, test
these patches and report any errors you will find.

[1] https://syzkaller.appspot.com/bug?id=c94c1c23e829d5ac97995d51219f0c5a0cd1fa54
[2] https://lore.kernel.org/netdev/20210725103630.23864-1-paskripkin@gmail.com/


v1 -> v2
  Fixed compilation error in 3rd patch
  Fixed cover letter


With regards,
Pavel Skripkin

Pavel Skripkin (3):
  can: usb_8dev: fix memory leak
  can: ems_usb: fix memory leak
  can: esd_usb2: fix memory leak

 drivers/net/can/usb/ems_usb.c  | 14 +++++++++++++-
 drivers/net/can/usb/esd_usb2.c | 16 +++++++++++++++-
 drivers/net/can/usb/usb_8dev.c | 15 +++++++++++++--
 3 files changed, 41 insertions(+), 4 deletions(-)

-- 
2.32.0

