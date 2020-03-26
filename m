Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66381193B6B
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 10:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbgCZJCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 05:02:41 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:34933 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgCZJCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 05:02:41 -0400
Received: by mail-pl1-f177.google.com with SMTP id g6so1899854plt.2
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 02:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=CWGEtbf8XEScb4MUaYIXaGo8Tn+XVj03cYkmnyygY24=;
        b=P1VMGSUgfqhZRE5oRyQJo8Ei4mo25JO6g0AGT/UhQ0UH8uOWl1UK+8kBypaDRo+C6e
         sy4tgZ+5sxuEb0x4DrRM3Pu7MNG3l+1pHBrznemBStsFa95knslCsrXuMifEc/dvM/Nr
         BqdK9vopLtTc1jvyro6TeLC8T7syDysSW3tsRnZ8VwSPIFIxpELxFi+ShN3vMawfLPgR
         YX2dKhdoZe9+uYWT+aPnkYAdqptO/UaclIiWyHTKk1HaVxj+6Wx+8itLGXLAB6DTGFBI
         ToCijl40iE7VoAWyRHb1gXY5DNeN50paw4WiIDEWTl1A/VSptQvMLwuDhamD60GuetsM
         k1OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=CWGEtbf8XEScb4MUaYIXaGo8Tn+XVj03cYkmnyygY24=;
        b=hAcXerOSQtYtfnkHIfD7AwGS92UBS+d7vxV5thGncr2meJpeF1h1cEuhI3WALLdu+J
         llVUxznX026t8cB0RH+hOBvYoRsBjwiaij1IYehEIkMbSbgyOViU6HAyAnrfz8q0/iKG
         9jZQrsselzI3xvNM263qPi26N3Wn6qfj9l0Qf3WTrWdumj7kEGRRjzzz8cUH69Bxcda4
         SmKKlE9cIyKVMK0NPIj2ZwAlMEn93f2wdmO4yt/kTWBsw+fFoccm3EVDIgTCuNXXLXqM
         EN9/hQC7D7NDnY/wMEiVgnNCziF8j9WLSE8grU1OOqQOfYCD9LJrY34x1OD1FNJndxXb
         fTmQ==
X-Gm-Message-State: ANhLgQ1BNDHrPqCFCPvVIhWkTRcOi9g1fMdK3tPZZTmd2lpbefXAb2/z
        l/iTL0ZQRY6Zab7mwtUan32DaZF8
X-Google-Smtp-Source: ADFU+vvnfvmRK8Kv9Fo9LmqRqbnbiJsQdeb+3E3TdzHpm80r6pri38N2sQXMBtuJR9rRBbRXb6qO6w==
X-Received: by 2002:a17:90a:fd90:: with SMTP id cx16mr2019179pjb.41.1585213359323;
        Thu, 26 Mar 2020 02:02:39 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z63sm1160062pfb.20.2020.03.26.02.02.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Mar 2020 02:02:38 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 0/3] xfrm: add offload support for esp beet mode
Date:   Thu, 26 Mar 2020 17:02:28 +0800
Message-Id: <cover.1585213292.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is to add gso_segment functions for esp4 and esp6
beet mode, and prep function for both, and tested with 6 cases:

  1. IPv4 INNER ADDRESSES
     - OUTER v4 ADDRESSES
     - OUTER v6 ADDRESSES

  2. IPv4 INNER ADDRESSES with options
     - OUTER v4 ADDRESSES
     - OUTER v6 ADDRESSES

  3. IPv6 INNER ADDRESSES
     - OUTER v4 ADDRESSES
     - OUTER v6 ADDRESSES

With this patchset, an esp beet mode skb would be segmented and
encryped until it arrives in dev_queue_xmit()/validate_xmit_skb().

Xin Long (3):
  esp4: add gso_segment for esp4 beet mode
  esp6: add gso_segment for esp6 beet mode
  xfrm: add prep for esp beet mode offload

 net/ipv4/esp4_offload.c | 32 ++++++++++++++++++++++++++++++++
 net/ipv6/esp6_offload.c | 36 ++++++++++++++++++++++++++++++++++++
 net/xfrm/xfrm_device.c  | 28 +++++++++++++++++++++++++++-
 3 files changed, 95 insertions(+), 1 deletion(-)

-- 
2.1.0

