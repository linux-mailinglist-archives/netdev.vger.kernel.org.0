Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839A14989D2
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344438AbiAXS6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 13:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344429AbiAXSyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 13:54:40 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29FAC061757
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:53:26 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id p37so16896637pfh.4
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:53:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=ZJHPo5gJ7qZ8/wdSfFFvfQyiss0RsnlA4amXHNWI0ag=;
        b=eSDS0F0VkkEGtOl5UVNvLOM07p2V4VBIottXgEHSAOUhOBkEvRVs5M+i5YC0t4zjXk
         UGOCznlYfZkrt7ppgiVyh3emaaSMFIQHSG0pP27Ealms/8sl70zLBhqu1xwO+5G7XjJJ
         4WeLMUJ1uunPEn0h+pjDB6tqSzA219XLXgXqtDxKymQDcXPneYZnSn/MnGOkTmSeQj+0
         XUy015ZlZ0JXjHYbsEkRVS4xP/IgTvyT+Mv3/PaHSFZrjeGAhjl3OzCTWBIVQF7Zcai9
         sae9MPkiSs2fIT/BAWZRaFnj5XPDbnNMst2fihN83b2S6/VrmkNQGAykL4eBMrJsSEmF
         zkMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ZJHPo5gJ7qZ8/wdSfFFvfQyiss0RsnlA4amXHNWI0ag=;
        b=261ccGD+gdnaKis643L75DhMv7m/Sd4OWiiCGFc42n9Wze9xtgnRnnO7zfGUNsC7aP
         OjnHFpaXS6yOOkqQldeme+C/9+ohmcjX6AaUkPLY7Xk7qV5SbK5EplBYBaH8d7Nu/jgg
         2UrtyvqDSPS579xTK6A+9+4jgt7/4ReYK8EbeRE4g7QSah3+QbZbVYORJd+PRtOWRGc7
         DUleObH94kR/CvVOluDP+Bv6LzvLErHJaMcieos5li3hhOvTxerkD9wqAQvSUIF+aSeg
         +ltv33Aq2yEXhL0dbOSG8Et/yjkFGWFeWO/iGgMelsd8EFpwNmAKsBlDDm+ltrPfFZEL
         EpiQ==
X-Gm-Message-State: AOAM533swkYCenx4lt2GE//YZK7jicTotf3lbojOzeq1oFLk9FqclzAP
        eks82je+aUSR9Sc667FPUcMwyKty5C0Jsg==
X-Google-Smtp-Source: ABdhPJzQ2aq6t5eyxCmJ1XDCPL5wRXIP7iiAdSWlrTtDajRyB3hNSvro7/s6WyZWXaTpYO5/1KfMuA==
X-Received: by 2002:aa7:918e:0:b0:4c6:8684:68e9 with SMTP id x14-20020aa7918e000000b004c6868468e9mr15176491pfa.37.1643050406466;
        Mon, 24 Jan 2022 10:53:26 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id cq14sm85177pjb.33.2022.01.24.10.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 10:53:26 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 00/16] ionic: updates for stable FW recovery
Date:   Mon, 24 Jan 2022 10:52:56 -0800
Message-Id: <20220124185312.72646-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent FW work has tightened up timings in its error recovery
handling and uncovered weaknesses in the driver's responses,
so this is a set of updates primarily for better handling of
the firmware's recovery mechanisms.

Brett Creeley (7):
  ionic: Don't send reset commands if FW isn't running
  ionic: Correctly print AQ errors if completions aren't received
  ionic: Allow flexibility for error reporting on dev commands
  ionic: Query FW when getting VF info via ndo_get_vf_config
  ionic: Prevent filter add/del err msgs when the device is not
    available
  ionic: Cleanups in the Tx hotpath code
  ionic: disable napi when ionic_lif_init() fails

Shannon Nelson (9):
  ionic: fix type complaint in ionic_dev_cmd_clean()
  ionic: start watchdog after all is setup
  ionic: separate function for watchdog init
  ionic: add FW_STOPPING state
  ionic: better handling of RESET event
  ionic: fix up printing of timeout error
  ionic: remove the dbid_inuse bitmap
  ionic: stretch heartbeat detection
  ionic: replace set_vf data with union

 drivers/net/ethernet/pensando/ionic/ionic.h   |   7 +-
 .../ethernet/pensando/ionic/ionic_bus_pci.c   |  17 +-
 .../net/ethernet/pensando/ionic/ionic_dev.c   | 162 ++++++++-------
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   6 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 189 +++++++++++++-----
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   2 +-
 .../net/ethernet/pensando/ionic/ionic_main.c  | 125 ++++++++----
 .../ethernet/pensando/ionic/ionic_rx_filter.c |  37 +++-
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  66 +++---
 9 files changed, 409 insertions(+), 202 deletions(-)

-- 
2.17.1

