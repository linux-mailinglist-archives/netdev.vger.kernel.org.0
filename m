Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 264601E9B7
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 10:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbfEOID1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 04:03:27 -0400
Received: from mail-pf1-f179.google.com ([209.85.210.179]:39814 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfEOID1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 04:03:27 -0400
Received: by mail-pf1-f179.google.com with SMTP id z26so947764pfg.6
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 01:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CULm7aKamfW6/SKc7mUXerFAjmC9ach31ZpwvXtFaGM=;
        b=a/9TytkMaTVxHVSg9IIzk4bQ0A2AukDsw5uCloi0mr0b1MWVWKotuR3JuxbMj93xZG
         VSlG58p3YxnV0/oIe4+FfimKaoQYS4PeLF4gZOvQuJzKeOC+v4xszu14UwqkkVyKFpz6
         e2iqYGXIy2wMKOZcdtT1VkfxNmbvhqea1iFFMaGbp1c20nDm2Rc+WjGPQ1FGb2d1IyDw
         E1uSlZJXSaNOP9xDOjBeZ2bZRjoRX3lOy8u3fZk6RNVNk/+WL9zhZjZ+quy6NLgOnYs8
         YnSdoOENIRUq9N2Gjnqu+ULjz06iZVkEOLTILTRqezZAvAlRV9TByc73QIVHLfQtvJvm
         ZFlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CULm7aKamfW6/SKc7mUXerFAjmC9ach31ZpwvXtFaGM=;
        b=WSgPv779aN7nv0ttDgWMKL+g7YHYOB9o/zzhBktEUdlmZSgz7Cn5RP/6W0N1U+t2uz
         Wv6PEBDVyVpk64TbDSuNOBeNwO6rm+9T+Tb1jl2lwuRrBmyI4DRy9Brer/feN1tHwd7K
         MhaKwRzdfoqZfB1fGmoEz2xH06JbGInrCUF6UJn8pVxLT5hPyjUcausNiQZtgelq2+Ya
         PydRbr0fihngURQb1qO7x7KV5g/iu1uXXjkvL5UdQ2vBIlgTsN20sdyiyxCBd/WJV5W8
         iXBKj1l0EtRxOcTCXR67SPnIoP/ey3LsttsEzLjjAH+je5p7NacwpXWkUWX/CJ5MP6eI
         pMaA==
X-Gm-Message-State: APjAAAWcRuQf2LcnLDWn43tLlijqPzYYBubXoEsKxx46X4dLYoanm6XX
        OfAj1Wp79V8EvmrBlJaYEuPF1g==
X-Google-Smtp-Source: APXvYqz8YC5GzZbrB4xEU1+pl+X7T3yEMwdUe10UH2LkYknBzg38T+5CerL6dGA+LMtSPgUh/UrQVA==
X-Received: by 2002:a63:950d:: with SMTP id p13mr43256345pgd.269.1557907406717;
        Wed, 15 May 2019 01:03:26 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 37sm3104572pgn.21.2019.05.15.01.03.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 01:03:26 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Stephen Hemminger <sthemmin@microsoft.com>
Subject: [RFC 0/2] netvsc fixes to VF frame handling
Date:   Wed, 15 May 2019 01:03:17 -0700
Message-Id: <20190515080319.15514-1-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XDP generic would not work with the transparent VF
support in the netvsc device. This problem is generic
and probably also happens with failsafe, team, bridge,
bond and any other device with a receive handler.

Stephen Hemminger (2):
  netvsc: invoke xdp_generic from VF frame handler
  netvsc: unshare skb in VF rx handler

 drivers/net/hyperv/netvsc_drv.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

-- 
2.20.1

