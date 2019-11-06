Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90308F119E
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 10:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbfKFJBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 04:01:17 -0500
Received: from mail-pl1-f179.google.com ([209.85.214.179]:34389 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbfKFJBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 04:01:16 -0500
Received: by mail-pl1-f179.google.com with SMTP id k7so11126814pll.1
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 01:01:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Wn6YtsmoRX3cKJxcmkxw60a7CT1gkIUJlUnXocalh0Y=;
        b=koTVA6uH/VJk649l5OsHAFkEdZjysUvpuNrXbFVnkhn6jA5hwPhBbKTaVr2bEjVEBX
         ZUNOBfrHJcq7Wfxa/LTu+IW7C0gBSRjMYUvbKc3zvprjsoAWo0WPHKGqUiguA/TU1nrQ
         BHaE+q8AwyEHovXZ+Q3mn7NPXHWpCvmc5fkEmXdgeTfr4uRmZvQGtAXCJ4DJU1GfkkdB
         wBGKUsONNDKOfZWSPZv3qOH2kRguo+kpwUrNJGRCtbgf67xudel5R/X6L5Zywt7hGizk
         pMwmwA0jlE59ThGiXEl5gM+09I2h6suJ9eQCVv9hnyu7i04vjpv0Opq+INob7SkgXRae
         dLWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Wn6YtsmoRX3cKJxcmkxw60a7CT1gkIUJlUnXocalh0Y=;
        b=kQGycY9yrbI6f+kfa7+fSbxshgPEBMw0Z0T4Dkxae7YMOwy+yiVU+z0UaysXznIRN+
         KVVH4ibuzepDNhOi9y6LILjrsXYp/Vkw+ZmrJHQuOUEis9hqarGXHacT5RB7MxEtd8Ir
         lPKnYwpvkE6wdv59tM2aNVIzfDxJK1NwRXll9TA0tPEGHkH4dn9GMWrruCIrhz9rwRKR
         cfFRarqWyj/HTX6v8RHNhnQgguH4AglvgzcuQhTqoMev3BAOthNB6dX4bOFghjd+Yfdh
         j4wn5RMVLXKqWc3ShyVBtB5WIGkv4mVor7b7XIEFmmV8gsMEER3il+FR8GrTJdrETFQH
         b3Gw==
X-Gm-Message-State: APjAAAXOuTg1g1Iw1PHKRnSs+nhJqcHLOQ7GxKTIR92jCQadyGpwQiQh
        uTAI5pHwtZYYaNtuy6xqQ35p5CKk
X-Google-Smtp-Source: APXvYqyb/0QhI5HqLhPwlpNK3cyOcqr80TR30hP2KHfhVkfStkNc3mubiyvrpocSqbh16ZTe1RRTUQ==
X-Received: by 2002:a17:902:9681:: with SMTP id n1mr1463726plp.87.1573030875657;
        Wed, 06 Nov 2019 01:01:15 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o15sm1297827pgn.49.2019.11.06.01.01.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Nov 2019 01:01:14 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        Jiri Benc <jbenc@redhat.com>, Thomas Graf <tgraf@suug.ch>,
        u9012063@gmail.com
Subject: [PATCH net-next 0/5] lwtunnel: add ip and ip6 options setting and dumping
Date:   Wed,  6 Nov 2019 17:01:02 +0800
Message-Id: <cover.1573030805.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With this patchset, users can configure options by ip route encap
for geneve, vxlan and ersapn lwtunnel, like:

  # ip r a 1.1.1.0/24 encap ip id 1 geneve class 0 type 0 \
    data "1212121234567890" dst 10.1.0.2 dev geneve1

  # ip r a 1.1.1.0/24 encap ip id 1 vxlan gbp 456 \
    dst 10.1.0.2 dev erspan1

  # ip r a 1.1.1.0/24 encap ip id 1 erspan ver 1 idx 123 \
    dst 10.1.0.2 dev erspan1

iproute side patch is attached on the reply of this mail.

Thank Simon for good advice.

Xin Long (5):
  lwtunnel: add options process for arp request
  lwtunnel: add options process for cmp_encap
  lwtunnel: add options setting and dumping for geneve
  lwtunnel: add options setting and dumping for vxlan
  lwtunnel: add options setting and dumping for erspan

 include/uapi/linux/lwtunnel.h |  41 +++++
 net/ipv4/ip_tunnel_core.c     | 382 +++++++++++++++++++++++++++++++++++++++---
 2 files changed, 402 insertions(+), 21 deletions(-)

-- 
2.1.0

