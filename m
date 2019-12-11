Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C72011A5C3
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 09:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbfLKIWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 03:22:53 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33218 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728262AbfLKIWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 03:22:52 -0500
Received: by mail-pg1-f193.google.com with SMTP id 6so10415461pgk.0
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 00:22:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=rveMbpPf16JSkGp1c+3AGjpujfZxn6vIX/+XYtDa1KA=;
        b=GSpLC4u1qZ63g5vP4SXucoubDpIxEHNVFsgo+hERcytGAuPcCeLIBi7k4EJNzE59vo
         +jzYHZ8qHfqUlOQ8CfDyvdaQWGm7Cs9IlnFVFlZRnJxurxPRZdK+t+I4rBOPr8w4iYqa
         zHLHTZGjJ1XmHEmT0xi3RbbgNrOyt0ErjJgGDoq6tehuM7g/aalzreX0qFanbnMmfYWl
         WolcoTsgpGbThsYvZTuD154gLLEtL6DV0G7h/duCby80jTIAvFhCJ/ugtqKyDd6VPETw
         J+/PWvIpZSbr4ddilbdeuOWg4AlN5iZgmK3nEql9eJcwr1iqwjy6Dv/W7Afx67YVXHIl
         LHhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rveMbpPf16JSkGp1c+3AGjpujfZxn6vIX/+XYtDa1KA=;
        b=St6GHkDrTuK54tk2C/dgcmRTQX1TTf1+T3Ehy2R1VmjPxz7QwSlzp9+Y4G601BhF9O
         ECdlVXlcmcGvGztUqvXiNVGNp2W0mWW5K6jlPK6PNGo4XO7kubeXLBXC3u+WYLaKRARe
         ERLfDo2M2PaEfqsFvC2jCVQOCgO35HyCaNQ5hynoKFhUh9SAhV1t7FWFfDdaSo+5qkTC
         A+YRPi5YNWyZHV4PdmHSk7t/SBzyDSsJp1Kp/XOHlxyVzldCDqrbOFqcCmtjdjePbceV
         2n80ERQ0SGIB6VsQMowMcLjNMVeB8Ng70E2YwUr4pK0Xgls2uZ+YUoDi3DGVjiOHoj+I
         iV3g==
X-Gm-Message-State: APjAAAUksMDfLn7a1EGcQxkz0bH2+A37+tei0W7kZn9XZbIEh5PUU6wJ
        Cidoy7gROc7dvI4+wCEp9tM=
X-Google-Smtp-Source: APXvYqxo1ZezgIZ9FL+2PdAQx+a3IKjSTznrB13Lb4OXLZjl5Mqo4LqMeUnTSgbT1x3cas63AcFzzg==
X-Received: by 2002:aa7:95a3:: with SMTP id a3mr2452264pfk.193.1576052572174;
        Wed, 11 Dec 2019 00:22:52 -0800 (PST)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id y6sm1667720pgc.10.2019.12.11.00.22.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 00:22:50 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, pablo@netfilter.org, laforge@gnumonks.org,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 0/4] gtp: fix several bugs in gtp module
Date:   Wed, 11 Dec 2019 08:22:43 +0000
Message-Id: <20191211082243.28465-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset fixes several bugs in the GTP module.

1. Do not allow adding duplicate TID and ms_addr pdp context.
In the current code, duplicate TID and ms_addr pdp context could be added.
So, RX and TX path could find correct pdp context.

2. Fix wrong condition in ->dumpit() callback.
->dumpit() callback is re-called if dump packet size is too big.
So, before return, it saves last position and then restart from
last dump position.
TID value is used to find last dump position.
GTP module allows adding zero TID value. But ->dumpit() callback ignores
zero TID value.
So, dump would not work correctly if dump packet size too big.

3. Fix use-after-free in ipv4_pdp_find().
RX and TX patch always uses gtp->tid_hash and gtp->addr_hash.
but while packet processing, these hash pointer would be freed.
So, use-after-free would occur.

4. Fix panic because of zero size hashtable
GTP hashtable size could be set by user-space.
If hashsize is set to 0, hashtable will not work and panic will occur.

Taehee Yoo (4):
  gtp: do not allow adding duplicate tid and ms_addr pdp context
  gtp: fix wrong condition in gtp_genl_dump_pdp()
  gtp: fix an use-after-free in ipv4_pdp_find()
  gtp: avoid zero size hashtable

 drivers/net/gtp.c | 109 +++++++++++++++++++++++++++-------------------
 1 file changed, 63 insertions(+), 46 deletions(-)

-- 
2.17.1

