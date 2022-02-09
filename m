Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC5F4AEC0C
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 09:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240865AbiBIIUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 03:20:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbiBIITz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 03:19:55 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E064C0613CA
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 00:19:59 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id j24so995675qkk.10
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 00:19:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5aOJ70nbvlP/4QBy90F71nrSaHXZMaC4UI44gOq8rKQ=;
        b=O6n123uH+qaBTeFnN8WCfaEF2QKEebFYNsVSFQNXF5HYQum8qwg2ZxW1RD96ie8vMu
         AcWw0Kly4IqiSzaJXwAx8+gW4wjlOb9EqxvW15GmJU0Tc+HXai1qGRryN4cJD+Ldw+6F
         AVMmIBsBfVEo4suXYAgO/35fFWnrUuFIvAU0CEayL3pvY6uiZh2IY6yRHYzkD8mpC7AC
         C0KWyn4Uo+nZbi/33Kri0o7AoMLUmmSMNYgw5FoBdYWYgPK525m2CTQfFOwifS9cxCzo
         XOwp8wnEEVHW4v43nt9wcFY9nmCnFv8rk3qzgDlD3ygmNDWZ7moU1Emv5DYkxStQAs2R
         NwtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5aOJ70nbvlP/4QBy90F71nrSaHXZMaC4UI44gOq8rKQ=;
        b=LlhFUW9YjfM8HI/5prRJcSJ8Il1pD0UF4a6NMRPLwiUKhjTkv8nyCfAeFnawbIrtCH
         oth99f19dBcFyg1ckJr7H2ZUUsWSUgk/jce3T/D0ndAPyIwhLYZJV7KEhtdgkOtfIfAX
         Hho+yXR71iidYHn81kluxdioqsgZQyCF5z5bU6gSW8Kph6870w7XNvYY/CkcskWNgTK3
         NYt+K/ykd2g1n4LiQ2b++EmQmmrcmzf/EkSyrs/VMUa/rZ0Hz6xelfoiyAhgw19X4Rty
         FR4rWXE+NbtRXNaz0JBTa5QAnMGdjOdijYRxw0sSbjKyHg5SxZDBCgaEEiEFVlNKEDqJ
         Bwvg==
X-Gm-Message-State: AOAM531j6wsf//KX63nIiN+nycDCOIT/uzv2+/dPq2HiG04z0VB6JZ66
        iGHaMuT00hN1ABFTmYQcVZBP0bnMg/tqMg==
X-Google-Smtp-Source: ABdhPJzv3c92AyLdL42TLMGjPKcOvfm5kFM4HkUvJ99W/Pe8Bp8CaT4al3sNrRcT1A60CzB6eIk7uQ==
X-Received: by 2002:a05:620a:1a13:: with SMTP id bk19mr458438qkb.519.1644394798243;
        Wed, 09 Feb 2022 00:19:58 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id x18sm8837717qta.57.2022.02.09.00.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 00:19:57 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Ziyang Xuan <william.xuanziyang@huawei.com>
Subject: [PATCH net 0/2] vlan: fix a netdev refcnt leak for QinQ
Date:   Wed,  9 Feb 2022 03:19:54 -0500
Message-Id: <cover.1644394642.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This issue can be simply reproduced by:

  # ip link add dummy0 type dummy
  # ip link add link dummy0 name dummy0.1 type vlan id 1
  # ip link add link dummy0.1 name dummy0.1.2 type vlan id 2
  # rmmod 8021q

 unregister_netdevice: waiting for dummy0.1 to become free. Usage count = 1

So as to fix it, adjust vlan_dev_uninit() in Patch 1/1 so that it won't
be called twice for the same device, then do the fix in vlan_dev_uninit()
in Patch 2/2.

Xin Long (2):
  vlan: introduce vlan_dev_free_egress_priority
  vlan: move dev_put into vlan_dev_uninit

 net/8021q/vlan.h         |  2 +-
 net/8021q/vlan_dev.c     | 15 +++++++++++----
 net/8021q/vlan_netlink.c |  7 ++++---
 3 files changed, 16 insertions(+), 8 deletions(-)

-- 
2.27.0

