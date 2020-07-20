Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED767227293
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 01:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbgGTXA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 19:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbgGTXA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 19:00:29 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44EF1C061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 16:00:29 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id w17so9373454ply.11
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 16:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=sZW4IIV906VWL7UuzSCIMwFm2iRNJ/y9SUTIRaFoRx8=;
        b=STS+nd46kcPFPIHnzIdrvvfOGB/ZROYqAHh3uL+90vPLtoLkLDQLw8WPnjw2CDtwrs
         6xlJHO86gr2Kz5vBPSPtBiXfTGhzX5Jwxk3tP9mlZvLSk+cYhvXXpJE7kme+4ObKj9XG
         pN7GyQzheqt+VXJK8OpmzJydl0JR3pZy+G4MJGSIMb8lVNj3WZ3FkQHJ6XRSH2oUmDlF
         QyhH3TD2Ac+B1KIdjmq0l/LAx9N8dN6HH1DCE4v8DRXWeM72VZeZm5L0LNj8nujpKR/i
         tEF+UoXj2i4mEdJbJ4o9nok+9Rt3Jj6mwFx796mdY2DVOVW09j9Y5BOZ9GAwEWL23LXi
         1sJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sZW4IIV906VWL7UuzSCIMwFm2iRNJ/y9SUTIRaFoRx8=;
        b=MyC799k3JRw7ONsXwK3dcwfaXPbZdaKlvPFzqkjit3r5dMMt04d20urMRA4l7sUwtp
         p+3doHZzT8AO+Cy6G5CoWy3+roz/Sd8vxZdjklpuQZslDvWvFqw66xAJTYwfjqqfDv2p
         szDAZT9mvPe08uRDXdLFv/AYknYFg7ShYoJIWXPrerDIoGt/LFRaaJSVLO3lcRD8Hwht
         Qbg0fnTVSyEGOAnhSY6qs2FZEP106OFAmIezIy+v4Od/rScbpW3eICgzVj5Yt3pZrZEb
         jvLW/D8CBA5m3jcezormb8RM3V5or5JcaXU9hPVWGxxZFqU3IN89HoeLbB3OeNiv2aG9
         aORQ==
X-Gm-Message-State: AOAM531SFz82UuHoSTE1jrE8gvOowrhyQt/PpMgFyHhhMJUYn39Hxl2+
        SxkPvBiNbwje0RzHHE+rgSiPUjoxy48=
X-Google-Smtp-Source: ABdhPJzYcBIq7jTN6JOGPX66jQN3xJK2KLPJSKbuKP1P/9TXRCvUWP4/ohon3fI0kV4Wpi3IK7piTQ==
X-Received: by 2002:a17:90a:9285:: with SMTP id n5mr1481705pjo.27.1595286028550;
        Mon, 20 Jul 2020 16:00:28 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n9sm606738pjo.53.2020.07.20.16.00.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jul 2020 16:00:27 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 0/5] ionic: locking and filter fixes
Date:   Mon, 20 Jul 2020 16:00:12 -0700
Message-Id: <20200720230017.20419-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches address an ethtool show regs problem, some locking sightings,
and issues with RSS hash and filter_id tracking after a managed FW update.

Shannon Nelson (5):
  ionic: use offset for ethtool regs data
  ionic: fix up filter locks and debug msgs
  ionic: update filter id after replay
  ionic: keep rss hash after fw update
  ionic: use mutex to protect queue operations

 .../ethernet/pensando/ionic/ionic_ethtool.c   |  7 ++-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 50 +++++++++----------
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  8 +--
 .../ethernet/pensando/ionic/ionic_rx_filter.c | 29 +++++++++++
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  6 ---
 5 files changed, 60 insertions(+), 40 deletions(-)

-- 
2.17.1

