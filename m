Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18096197D6
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 06:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfEJE5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 00:57:44 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:34667 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbfEJE5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 00:57:44 -0400
Received: by mail-it1-f195.google.com with SMTP id p18so6687703itm.1;
        Thu, 09 May 2019 21:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=XhD9AaJrk/ZyvLQSA+mEVn0uGSnJUWc1fc9BTMSCrwM=;
        b=WFf1QRwjZitDJiFwf5SSd6VRXgPpT1FyuQqnNl12/MK+7V/3k6Nh94bFcCfU6JRaZL
         hUkcFlke/G/b73IzCfP24FL9/jdzPJnnbliuXY006wiAoZ9oegAxI/HHW+KRaBfzxADY
         bS4qmNDtNn6+RU6wifViVwhs71hlDW/QJlGVMUC8YnDb6hx0ljfA/lFtPGNEs6XZjsfJ
         SJpjMl791NN8WiuNazPYTmGxAZVF4nMjgl7lzK/HGb+mTGsSH/bMkJDcuFclLVa3Ks3r
         TLsHflQuOWDkaPwCQfUeONHrBU+ZrM6wjd63roQTYA6JBHfq+bnt3XCtBcTbhgRB2UlR
         J+SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=XhD9AaJrk/ZyvLQSA+mEVn0uGSnJUWc1fc9BTMSCrwM=;
        b=H+xyWOnGBZRQjmEiULeqzdKwUcPmubAK9Ld0+2XLpwlusDIM6aV7r13sxQTfBYY8vU
         mKFdYw4GuByeg+RVszFqric0UcmysKATl1mQ7bcHal210vNXPkFa2oeCAPOXCuJQ493f
         mpLEb7pYqMedxVU4g2AQ3RSiNnJBYCVO4sR9rfsEWGFFHDKasLPf12FHmjc04Cplfngw
         9BT6qM3vhuhn7pDtxEcBZf00CUBTUFpao1fWFlxBSYyZnOorgIfbBoJZw2hv0V/lB9bM
         +P41MQgbICd8NQ8LrEufbZZFXdMzrAUIk8D18F+hzrBE7qk1TsHlKcOrwSE0TG368wem
         fAEw==
X-Gm-Message-State: APjAAAXUVR1+FVyWNN7n96Y4zdF+tnH2TY9J7ILbSmbREOYvc23mmoki
        dUU3AkI7+Hk65XzCt/nyFq0=
X-Google-Smtp-Source: APXvYqxqwl6d1B2CbgzohwOi8dWqwdy3NAMR+oyoFhYATMz1PzrDkNtgt8W13HqLV0h6v2RCK9Dkyw==
X-Received: by 2002:a02:1cc1:: with SMTP id c184mr6214614jac.97.1557464263195;
        Thu, 09 May 2019 21:57:43 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id w132sm2051083itb.30.2019.05.09.21.57.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 21:57:41 -0700 (PDT)
Subject: [bpf PATCH v4 0/4] sockmap/ktls fixes
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub.kicinski@netronome.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Thu, 09 May 2019 21:57:30 -0700
Message-ID: <155746412544.20677.8888193135689886027.stgit@john-XPS-13-9360>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Series of fixes for sockmap and ktls, see patches for descriptions.

v2: fix build issue for CONFIG_TLS_DEVICE and fixup couple comments
    from Jakub

v3: fix issue where release could call unhash resulting in a use after
    free. Now we detach the ulp pointer before calling into destroy
    or unhash. This way if we get a callback into unhash from destroy
    path there is no ulp to access. The fallout is we must pass the
    ctx into the functions rather than use the sk lookup in each
    routine. This is probably better anyways.

v4: move unhash routine to TLS_SW only, hardware offloads need to
    keep ctx around long enough to free in-flight context. We will
    need a follow up fix for this.

---

John Fastabend (4):
      bpf: tls, implement unhash to avoid transition out of ESTABLISHED
      bpf: sockmap, only stop/flush strp if it was enabled at some point
      bpf: sockmap remove duplicate queue free
      bpf: sockmap fix msg->sg.size account on ingress skb


 include/net/tls.h    |   28 +++++++---
 net/core/skmsg.c     |    7 ++-
 net/ipv4/tcp_bpf.c   |    2 -
 net/tls/tls_device.c |   10 ++--
 net/tls/tls_main.c   |   82 ++++++++++++++++++++---------
 net/tls/tls_sw.c     |  140 +++++++++++++++++++++++++++++---------------------
 6 files changed, 166 insertions(+), 103 deletions(-)

--
Signature
