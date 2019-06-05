Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE89535FAA
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 16:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728448AbfFEOzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 10:55:15 -0400
Received: from mail-yw1-f74.google.com ([209.85.161.74]:46687 "EHLO
        mail-yw1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728303AbfFEOzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 10:55:14 -0400
Received: by mail-yw1-f74.google.com with SMTP id q79so10107810ywg.13
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 07:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=rWzWtdY7wZgPO8Mq7xKXWlvksRdsLM4U1BdEFvTicz0=;
        b=lKN14HWvfMqaXJDHyKCfD+7aG2cyeFoHk/w9wEdfVJyp6IRQ36zFn6gW4w4aNNs3tC
         Q5E4uoFp9iozT1IJugtLGuq/t7sBu67G7vLcZUiEvQM8Gc3rhlkitNhRnPY6JoZnUOpm
         xbcIV7FM0k4zo26eepzNpufQM40kgHcUfxyt95an5YZ4I9FnocTyjeGnkfSMuY601s5b
         K7yPiaY5BjzeGwY3B9Ezv2YNQGUXu+Ut+OUMva+Nc6JZICmJFGPJusvi7QGB7gW74E5R
         XEHKXtcagiD9fu+HzFMOmhEla+zE9Vz5H9dQ+C1fJ6sCUJLlPDckIcHtizwxCHgJMfrJ
         Ostw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=rWzWtdY7wZgPO8Mq7xKXWlvksRdsLM4U1BdEFvTicz0=;
        b=NiY86aLPgReBmlMc7amldm9UFE7klHNuz3mAElDjF9oC1N+Jh3pT0ybxrIr9dJhz+W
         vyE3ML9agn55m3GxP4n9ws2/a6NLVoOrYCVsPqKwrIgCRmYCG1tMfHt35P2A9lljYcz9
         YZlfiARuoU/koOd1uu9ELeWdMsBiU0S91yWjOt/MUXKpZlM5K4Gq6Q6D6w4P/d6hSD19
         IO06bxrbfNb0f71qz98HEYaBiQp99MPjo+57GWqwAqKCsYuGO/yYR9fqOr3VmQOqeAny
         xKfebb2MX/FE9JG44eOCR99IxCvRNVWezrbXSGoVV7on3VuTsyLkU3aC7Tnnpg0SX9K1
         hEVg==
X-Gm-Message-State: APjAAAUO51l7x7KyCUtIoH3bJ+6kIztGnLOUkT1eoTWk2HGKCt1xP8U0
        8Y7R1pRaYJOBK6tG+Oau8RxY8Q/GUqn/Pw==
X-Google-Smtp-Source: APXvYqx6ApBxZHvDoumD/72d6S+yo+pWvxGIObkr9pD2Chf3vHX9Fjwv2yEDmM7mxxaM/iyDUUiV/qqM/36Veg==
X-Received: by 2002:a25:ef43:: with SMTP id w3mr18879816ybm.411.1559746513874;
 Wed, 05 Jun 2019 07:55:13 -0700 (PDT)
Date:   Wed,  5 Jun 2019 07:55:08 -0700
Message-Id: <20190605145510.74527-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
Subject: [PATCH v2 net-next 0/2] ipv6: tcp: more control on RST flowlabels
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First patch allows to reflect incoming IPv6 flowlabel
on RST packets sent when no socket could handle the packet.

Second patch makes sure we send the same flowlabel
for RST or ACK packets on behalf of TIME_WAIT sockets.

Eric Dumazet (2):
  ipv6: tcp: enable flowlabel reflection in some RST packets
  ipv6: tcp: send consistent flowlabel in TIME_WAIT state

 Documentation/networking/ip-sysctl.txt | 20 +++++++++++++++-----
 net/ipv6/af_inet6.c                    |  2 +-
 net/ipv6/sysctl_net_ipv6.c             |  3 +++
 net/ipv6/tcp_ipv6.c                    | 15 ++++++++++++---
 4 files changed, 31 insertions(+), 9 deletions(-)

-- 
2.22.0.rc1.311.g5d7573a151-goog

