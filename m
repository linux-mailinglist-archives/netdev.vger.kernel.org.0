Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D113C9F9DD
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 07:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbfH1Fgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 01:36:46 -0400
Received: from mail-ed1-f41.google.com ([209.85.208.41]:40328 "EHLO
        mail-ed1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfH1Fgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 01:36:46 -0400
Received: by mail-ed1-f41.google.com with SMTP id h8so1533801edv.7
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 22:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zC0CN4Yqsji8nrnEwhSBZD3mkYnYdGRz6B3DhEySr8A=;
        b=oLlONL2WNFhMxOwxzX+GyeDWg1Fl9JT1Mn5OhJRAexqDRv0UM5Q9nqLUf+aEbDchgg
         Y0TIwFTZRpVekXI13kuRJaajHfQB6fg2nR483HqLD3i9ww9CYgPXezUm6nEMYDQbTVj3
         oPsBQZCepBbeNInrVZNpQYqPZXgJitD5uJ5q8zmQqCaNd0m0KgwYmorR9asnX97ON3Xb
         YSDsC+JYXptKx7yzM2pLFUFjj8r3KDZy+yBie+dIV9nk8WoIjJmyaFYjJWVoTnJnzI8N
         WoBzXJwGqP02JMuzRpv1TXAgwIhF6GPXVc8u9BQWQhYFdESFwAItMeZVhdpJNbAC7JM9
         L//w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zC0CN4Yqsji8nrnEwhSBZD3mkYnYdGRz6B3DhEySr8A=;
        b=AX9KUbFpXnwJRXHpj3yN0hebKIPRTUZyIZ3Ep/1ta9s4SlbJAdoxbj3XmztrLuhTqu
         ZZrHI1rz4H4M9eOQaeNh8l6E2B6HTR1JdUkmWsO2Z87s06DlZZtHDRehXOwAjS2AK/b2
         +qW4sKS3D6f+NMXCcZcT/1bN5qiGjoFT2fUeq7LbUK9uZX2azVvtZxCF8uT7nMmpbGiL
         +wHPcv9ZbRoEDSfvIUBOt8CtKXHsyiYE0PnVPTvY36bvORQ6fQqlz5zYuwLWxsl9Yu8r
         RMW54ZqLquLdjoilgQeWf45FgcwCipUuxe07rIqsys+d0xYRuyGdhc3EcYpAqmEmmymf
         vc5w==
X-Gm-Message-State: APjAAAUc+JdpAmza485ZsGB3HqFOfRPaDG8dyfi7Nn/I1dW8K5jRNipW
        VcMYQrQRDIVq6KXo25ZM8aYxbg==
X-Google-Smtp-Source: APXvYqwnINOjgzbhJY03SZr6dtOUz5ZQIDgpUpbs79qSicTd6pRNIDi7YZpHB78U4VCqnVSJNvYp1w==
X-Received: by 2002:aa7:d981:: with SMTP id u1mr2156765eds.150.1566970604363;
        Tue, 27 Aug 2019 22:36:44 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id i23sm237334edv.11.2019.08.27.22.36.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 22:36:43 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        jaco.gericke@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH bpf-next 0/2] nfp: bpf: add simple map op cache
Date:   Tue, 27 Aug 2019 22:36:27 -0700
Message-Id: <20190828053629.28658-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This set adds a small batching and cache mechanism to the driver.
Map dumps require two operations per element - get next, and
lookup. Each of those needs a round trip to the device, and on
a loaded system scheduling out and in of the dumping process.
This set makes the driver request a number of entries at the same
time, and if no operation which would modify the map happens
from the host side those entries are used to serve lookup
requests for up to 250us, at which point they are considered
stale.

This set has been measured to provide almost 4x dumping speed
improvement, Jaco says:

OLD dump times
    500 000 elements: 26.1s
      1 000 000 elements: 54.5s

NEW dump times
    500 000 elements: 7.6s
      1 000 000 elements: 16.5s

Jakub Kicinski (2):
  nfp: bpf: rework MTU checking
  nfp: bpf: add simple map op cache

 drivers/net/ethernet/netronome/nfp/bpf/cmsg.c | 187 ++++++++++++++++--
 drivers/net/ethernet/netronome/nfp/bpf/fw.h   |   1 +
 drivers/net/ethernet/netronome/nfp/bpf/main.c |  33 ++++
 drivers/net/ethernet/netronome/nfp/bpf/main.h |  24 +++
 .../net/ethernet/netronome/nfp/bpf/offload.c  |   3 +
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |   2 +-
 .../ethernet/netronome/nfp/nfp_net_common.c   |   9 +-
 7 files changed, 239 insertions(+), 20 deletions(-)

-- 
2.21.0

