Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19E6512392C
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 23:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfLQWMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 17:12:36 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:33293 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbfLQWMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 17:12:36 -0500
Received: by mail-lf1-f65.google.com with SMTP id n25so171407lfl.0
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 14:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VKzEutmQkj442xG4QYwCfewDTbDd/w0Y8fetglGnNkM=;
        b=HD67M/SjW1hrU5fu4qzA4k0XyUQVP05q6ma4X0uH2nnFEmKAshXXg8GFhhw0FvQJID
         FrewhBOWFTd7o3alGSIm3u63MlzG4DQl7w92vfXpVuDViOlHf0qFgO3mREXaOXwDD2DN
         LkhOYA4HG5kL4YU5W9pW2Zg2ohjug+iEL1KtB0oHK3QYMmULb1UZJqFEAzLN2U/wYvDA
         tuyesE9FQXvpY0lbYFY4rUwWYWvRLV0fMje2FsyBRXzmPN/lcdH5oOAFg0zuXEJL4wnC
         ctPRbJpfP4M2WlPMGSecyLUxpyNuyq3OMqYy2pkLBaHSstCBPLM2L36/XbCDKJKfffp+
         y20Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VKzEutmQkj442xG4QYwCfewDTbDd/w0Y8fetglGnNkM=;
        b=OwqEg13UDdjHnWqUYSEr6HW3EhfYCtOgE69x+nSEaRkY0XOWwMgIZcad7dhqdE4rFg
         enRaaWB1lKGQmNetPM9t/qLA4DgDmW4813DWksg8ymtzTLErJwF42kxz7Rcpdd6xiFdQ
         FRlI1EKaObZWMw541gOF49hhqQxKp/iNhLcwDkXh4FFoLEFLdRFlVLI8KoetTku9I8d/
         qAUStk7yzbU9mtBx2X9RGTdepTquW1jVF1PPuSkQmlUBoNyZejX6JC1/iX0StHG7po+T
         TNjC9MXr1snq2ixNo1OKqmgQEe/rJd7PkOAOk4SqtcsTldehXGqa0W47tvDoP60S9xK/
         Qhbg==
X-Gm-Message-State: APjAAAVxjyIWJIBYPOmbCkz3ujgOsWWoZVJSuS0N3QVnaA/qQXe4/8H3
        PNytltQIcGRUWetbieh/lEXNNw==
X-Google-Smtp-Source: APXvYqzx8rfFm6M08AfGHHWq+SSajgtkUurmYXwS7sG9S3P6sWdpuE1Ceg+cmbeYCST1DGzKHFMtjQ==
X-Received: by 2002:ac2:4add:: with SMTP id m29mr4148699lfp.190.1576620753913;
        Tue, 17 Dec 2019 14:12:33 -0800 (PST)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id u9sm13333440lju.95.2019.12.17.14.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 14:12:33 -0800 (PST)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 0/3] nfp: tls: implement the stream sync RX resync
Date:   Tue, 17 Dec 2019 14:11:59 -0800
Message-Id: <20191217221202.12611-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This small series adds support for using the device
in stream scan RX resync mode which improves the RX
resync success rate. Without stream scan it's pretty
much impossible to successfully resync a continuous
stream.

Jakub Kicinski (3):
  nfp: pass packet pointer to nfp_net_parse_meta()
  net/tls: add helper for testing if socket is RX offloaded
  nfp: tls: implement the stream sync RX resync

 drivers/net/ethernet/netronome/nfp/ccm.h      |  1 +
 .../ethernet/netronome/nfp/crypto/crypto.h    | 15 ++++
 .../net/ethernet/netronome/nfp/crypto/fw.h    |  8 ++
 .../net/ethernet/netronome/nfp/crypto/tls.c   | 89 +++++++++++++++++--
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |  6 ++
 .../ethernet/netronome/nfp/nfp_net_common.c   | 25 +++---
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.c | 41 +++++++--
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |  9 ++
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  |  8 +-
 include/net/tls.h                             |  9 ++
 net/tls/tls_device.c                          |  5 +-
 11 files changed, 190 insertions(+), 26 deletions(-)

-- 
2.23.0

