Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC597584CA9
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 09:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234845AbiG2HdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 03:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234371AbiG2HdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 03:33:02 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075747B37F
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 00:33:01 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id f11so3391905pgj.7
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 00:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qvpro8/9dV4bp5UsVmY66qyCUULP+kH6X5nZ/0kdvcE=;
        b=HgfAGdrPzOGwsei9taE32rXMt27/0/KFI90L2dRllOqbwNmtKR5Whj8AhdENiXvGfV
         9mCA7PT24qqMXIxH8XQnAMDFCR0JUSvhGaLq1bAqbdXiRV2lMJezrvl9ZX8HLdOM7fID
         CrZcGK+HZsn/a9aa/GWw2XuLxvSE+puMel4dw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qvpro8/9dV4bp5UsVmY66qyCUULP+kH6X5nZ/0kdvcE=;
        b=5oDKXKPLnHFzpJ1up5cpnkNgVDnQUcWeXkwIer4tMgMvT2W5VIpf+KNFXQ/se4yQMB
         dT0MedY5yDE43ntsYfP7KS2MckE1rMsjaKtKNw3a2hp0xrol4sN8Mfcx6NKJ0EsMnOGU
         rFbXa7V7tPMpBffbuJSdUAhw7DyrjFSyniwGUJequaMyHnbR1Fs7abmPlL2AHi4Nw3NX
         9MILRsnF+mVWBTWNvNDrOucTTg5YjrUIrYwSUiXD/EA+bV0IGc2TDsKkEsQze8/pBWNJ
         s0/aqdFyuMZFFh3eVDPkxHm8U3n1SbdtP+FxSp+aBKwAoiK6mVm/wljQVy3SK4iTCjln
         F7Zw==
X-Gm-Message-State: AJIora9pw/Kx6KmMGXb1i9pVoOsHE4U6vU/gnlLrF9L6NnDbZQNTL3S6
        panJEtBVwZziuM0IE89Eyf2Ipg==
X-Google-Smtp-Source: AGRyM1s8DJsZUV8w/ht8gxLaEcCv4ZUh+VFsO9ob31rnb/iFG7juASUoFEhXBcxEkJdkuAIEk5iXFQ==
X-Received: by 2002:a63:1624:0:b0:41a:9dea:1c80 with SMTP id w36-20020a631624000000b0041a9dea1c80mr1961226pgl.400.1659079980488;
        Fri, 29 Jul 2022 00:33:00 -0700 (PDT)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id w71-20020a627b4a000000b005289ffefe82sm2074226pfc.130.2022.07.29.00.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 00:32:59 -0700 (PDT)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        lorenzo@kernel.org, hawk@kernel.org, netdev@vger.kernel.org,
        d.michailidis@fungible.com
Subject: [PATCH net-next 0/4] net/funeth: Tx support for XDP with frags
Date:   Fri, 29 Jul 2022 00:32:53 -0700
Message-Id: <20220729073257.2721-1-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support XDP with fragments for XDP_TX and ndo_xdp_xmit.

The first three patches rework existing code used by the skb path to
make it suitable also for XDP. With these all the callees of the main
Tx XDP function, fun_xdp_tx(), are fragment-capable. The last patch
updates fun_xdp_tx() to handle fragments.

Dimitris Michailidis (4):
  net/funeth: Unify skb/XDP Tx packet unmapping.
  net/funeth: Unify skb/XDP gather list writing.
  net/funeth: Unify skb/XDP packet mapping.
  net/funeth: Tx handling of XDP with fragments.

 .../net/ethernet/fungible/funeth/funeth_tx.c  | 135 ++++++++++--------
 1 file changed, 77 insertions(+), 58 deletions(-)

-- 
2.25.1

