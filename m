Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4383D0C26
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 12:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237352AbhGUJTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 05:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237804AbhGUI6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 04:58:38 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94263C061762;
        Wed, 21 Jul 2021 02:38:59 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id b12so1799870pfv.6;
        Wed, 21 Jul 2021 02:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i9lkhl5CGNwVkPr4Gc/fkK8jj+kqc00wstH/fPwiQoY=;
        b=hH2Z4OaAClP5KljSyPIFjkVHl1LF2NfPBN/bNCaI0eAGcpgtt2DbKCB6S0XKzS8s42
         /oZP5LmeyfDv8Caqje9WS3sgtklqdfYTMkuPq32Ew7XqxVFvcgD6wHm6XhrzeVZAAcGi
         11iJy/iIb7wcGE2RZq119eDp6TtBD95RcgfOTzPAtySSptZsmEUPvV/ajbVmASxQl0M5
         IIcQ1C+hiqd4WWu2yzvmMR9eegWTfQYD4GtMndBT9/7Pgs3EXpTe5r/0ZDZbxaTT91RU
         +XGIRLzmOWCyW9RWanuS27vUqIG9V3OSN9FOmfKOI+Qb+1KvQAq6BlbxPKoahWNsz/5p
         Hm0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i9lkhl5CGNwVkPr4Gc/fkK8jj+kqc00wstH/fPwiQoY=;
        b=WXqEYHd0WsFppra77BpGt4qkSsBAdZrL3S9tpq89BL+MAUkk0GpgVkI+mVaWM/rZmX
         bSfBsHBoceqAayDZqmgnP8I+MdQEZEbH1KnHqxnfxaewwTl6XuXiqlLFDRPov6C0bKw3
         sWeBC/yz1haZ6tDNrv64/ZbKGk8ztoofG8MAprz+4ACWqbm/7MCuDXdL4cqajpcNW/na
         ooCntlkMlBev0fqgjKK9u5XsfQMz96Ct/0jNLTAo1gqaIPEf/eeMfzIMLT06oskhKYB+
         WO+hmEUwDEiBjF/0HSM6Cn89iXgoTViPRoNpsVRCcaTIuXHGKTZoOb/ZcbZV4eUolf9Q
         YWEA==
X-Gm-Message-State: AOAM5322UfYg40TSDIvdNVSWUo0c2jHnqnse8jcRL4TeOIB4SuuiBv4R
        F/yTq9/7L2HY9NYOoooDxGM=
X-Google-Smtp-Source: ABdhPJwe9X9dZuLm3t9+BFn8++RhOcSNWNEc70KRQR5FCUJmoeexUawaYQaytntIsbib8D73D3c9Cw==
X-Received: by 2002:a63:3dcb:: with SMTP id k194mr34987757pga.202.1626860339124;
        Wed, 21 Jul 2021 02:38:59 -0700 (PDT)
Received: from localhost.localdomain ([118.200.190.93])
        by smtp.gmail.com with ESMTPSA id j129sm27311956pfb.132.2021.07.21.02.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 02:38:58 -0700 (PDT)
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        stefan@datenfreihafen.org
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
        gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH v3 0/2] Bluetooth: fix inconsistent lock states
Date:   Wed, 21 Jul 2021 17:38:30 +0800
Message-Id: <20210721093832.78081-1-desmondcheongzx@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series addresses inconsistent lock states first identified by
Syzbot here:
https://syzkaller.appspot.com/bug?extid=2f6d7c28bb4bf7e82060

v2 -> v3:
- Split SCO and RFCOMM code changes, as suggested by Luiz Augusto von
Dentz.
- Simplify local bh disabling in SCO by using local_bh_disable/enable
inside sco_chan_del. The rationale is inside the commit message, but in
summary I initially wanted to avoid nesting local_bh_disable until I
learned that local_bh_disable/enable pairs are reentrant.

v1 -> v2:
- Instead of pulling out the clean-up code out from sco_chan_del and
using it directly in sco_conn_del, disable local softirqs for relevant
sections.
- Disable local softirqs more thoroughly for instances of
bh_lock_sock/bh_lock_sock_nested in the bluetooth subsystem.
Specifically, the calls in af_bluetooth.c and rfcomm/sock.c are now made
with local softirqs disabled as well.

Best wishes,
Desmond

Desmond Cheong Zhi Xi (2):
  Bluetooth: fix inconsistent lock state in SCO
  Bluetooth: fix inconsistent lock state in rfcomm_connect_ind

 net/bluetooth/rfcomm/sock.c |  2 ++
 net/bluetooth/sco.c         | 21 +++++++++++++++++++++
 2 files changed, 23 insertions(+)

-- 
2.25.1

