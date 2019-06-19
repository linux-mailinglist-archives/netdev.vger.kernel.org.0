Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6794C340
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 23:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730625AbfFSVqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 17:46:44 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:42178 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbfFSVqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 17:46:44 -0400
Received: by mail-wr1-f49.google.com with SMTP id x17so775503wrl.9
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 14:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=4X0q3ZGdXuAsyGij9zP0aVkSV4m6i3hNuHj/bJtzKbk=;
        b=V2tgXRj2y7m8VatJglNmR4l1fo6bmm2YaN8EoREejtR0jsORmMM9ZCorHrE2w6n1mb
         VtXpUQo+78fLl314yU2crd1RAc5mBsQ4zIIYScU3IcbK5wJoUO1y0y1D57LiYvhM+Ic5
         NgyYJSQ7o6b19VVMaVtye2xhMgKyJGLsrt05ikuK/lh+EwvqMY5Wb+saHAzyXP0qVXix
         +jOOvkhSOQ9CV+rIbT+3UDV0Al17tcODW6DxaWwp4UExvbFuW1mmq5UndEH71YbSz6jz
         7K07BofXvg/81Npv2WsxGB9WO4gYzr5hFPhiKTBwczs/o201oS5vQkibTJXUmpL6qmuy
         gGew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4X0q3ZGdXuAsyGij9zP0aVkSV4m6i3hNuHj/bJtzKbk=;
        b=P16ro4dhP4tFDD0epTZE4yv82ipUkz2w+r1+iwUB0bcHT1XxdWOZSAKGj82nakWb5L
         oUh4FemFEUZgCL6fM/SMO+cIgWrHLlksaYhEMATU3ZvYLKVgh57zrwUYXFT9gbIfPwNA
         pIX1iZdISys4XMYlL0g7aC2dMa0dxs2UCCEFUkI+nm+rFgwZKB1s17Ut8ziMI9clGelg
         Iq5dGlZ990zrBiM7rLZZjo6ErfG7YqsqASerLvWGL4DHNrkK0lmrM6WXSZcf9V7NTSrB
         0pRPC4sosI+91fhn1SWXMirL++Zh0fgEmyF9r/DoDTpjAHJZQDnTc/7AOGbiMYP9hp0B
         l1UA==
X-Gm-Message-State: APjAAAXWkYsyd9lvj0g/Ka3kVWYa6+SZ12Sid5crdTOw0YRKiTirFeMO
        ips0bfI8J0jzXqcDYlO7X6HsIfTpLzndnQ==
X-Google-Smtp-Source: APXvYqyhlX71hdDu1lnaipaoZVv6xw9RoP1WLkgKxwcF3V8ym1cNvVwJAbq7BIIgZwtUAC4SuTV8xQ==
X-Received: by 2002:adf:ea88:: with SMTP id s8mr71248991wrm.68.1560980801901;
        Wed, 19 Jun 2019 14:46:41 -0700 (PDT)
Received: from e111045-lin.arm.com (lfbn-nic-1-216-10.w2-15.abo.wanadoo.fr. [2.15.62.10])
        by smtp.gmail.com with ESMTPSA id e11sm27109620wrc.9.2019.06.19.14.46.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 19 Jun 2019 14:46:41 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     netdev@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        edumazet@google.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, jbaron@akamai.com, cpaasch@apple.com,
        David.Laight@aculab.com, ycheng@google.com
Subject: [PATCH v4 0/1] net: fastopen: follow-up tweaks for SipHash switch
Date:   Wed, 19 Jun 2019 23:46:27 +0200
Message-Id: <20190619214628.2960-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some fixes for the fastopen code after switching to SipHash, which were
spotted in review after the change had already been queued.

Changes since v3:
- switch from compount literals to individual assignments of the siphash
  key fields

Changes since v2:
- add missing pairs of braces in compound literals used to assign the
  fastopen keys

cc: Eric Biggers <ebiggers@kernel.org>
cc: linux-crypto@vger.kernel.org
cc: herbert@gondor.apana.org.au
cc: edumazet@google.com
cc: davem@davemloft.net
cc: kuznet@ms2.inr.ac.ru
cc: yoshfuji@linux-ipv6.org
cc: jbaron@akamai.com
cc: cpaasch@apple.com
cc: David.Laight@aculab.com
cc: ycheng@google.com

Ard Biesheuvel (1):
  net: fastopen: robustness and endianness fixes for SipHash

 include/linux/tcp.h        |  2 +-
 include/net/tcp.h          |  8 ++---
 net/ipv4/sysctl_net_ipv4.c |  3 +-
 net/ipv4/tcp.c             |  3 +-
 net/ipv4/tcp_fastopen.c    | 35 ++++++++++----------
 5 files changed, 24 insertions(+), 27 deletions(-)

-- 
2.17.1

