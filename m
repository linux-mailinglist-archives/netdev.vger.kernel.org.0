Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C02142A9B98
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 19:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgKFSHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 13:07:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727183AbgKFSHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 13:07:49 -0500
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B192C0613CF
        for <netdev@vger.kernel.org>; Fri,  6 Nov 2020 10:07:49 -0800 (PST)
Received: by mail-qk1-x743.google.com with SMTP id c27so1878658qko.10
        for <netdev@vger.kernel.org>; Fri, 06 Nov 2020 10:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cyOIzURfHhd0aqV2aj3Pasygw1WsjAsK+U7Y/UJ78Yo=;
        b=jh3CcWW5N81k7wbonk7vSAro+hqVfiQ9gZx3EF5+oupB3+cl9B+hb9cylATLjWbdvq
         RSD6vZ8aelSk2ELB5ztD9n7c+tTk1+cXrrtaY8AO84+W3l5aoFIRol2hxllLNovmao+R
         TCOYIAyvRuEOhHo9noH2Ake/EL6Pzttfkh3NZmLNntOpvHH/iRkME1EQkP5xBZXcJTKs
         AyReTeVLH3UXw/HbQfuVupyviQRCrmtHbvWmOlTrQgydvmlgD+4yGvq4fVNyqycJfja1
         Lei32MG1/vUUDRtPrWLzizxhggWDrRMbDTbL7oqDc4dbO5tavaLuNyZVgZvnc23MWCg9
         sm7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cyOIzURfHhd0aqV2aj3Pasygw1WsjAsK+U7Y/UJ78Yo=;
        b=GV58EHD7QnHVse62KFzei1E4dDlzMwu2FdiCedLyExOtFnbha9SNBwNuH+/tGPKp3J
         eTf3d/5FSDxR07XW+VZYHHv0fWVPmAhWG3zkzWeCVlHkPwpd5YF+PPvncYH5fMW1ZD0+
         +eOEgmyX2h1OwUn4QVtAfuPZcUIOUVOGnN+18L1Qgivhjdp8l2prDhRWiT54ie/BZLdj
         agp2DN+nKKz8J9JtSwgXjbNVE+2FnDwJ6qZcqGuz+W1TCFU/94PTdOJsDAxo5U9oqpCD
         sLup468XowcdOyvslMsGhtCsjtGmMtYhxskSlZUb/C5IJ9AF8C2+/VXjtHFdrssAKJP6
         T4uQ==
X-Gm-Message-State: AOAM533DbAYOqtCblKK36RMBO7HA8+fr3SpQ/c0EQ1kN7wwMMdfj8A79
        FwPl4rDrrRqPXlaG1iO6D7B1wMjHGXc=
X-Google-Smtp-Source: ABdhPJz049lBXHEV1dV0n4MrEmfbigeRm+1zPSjSNuiJaIisgJ5NzT8dk0zCdz4K4Mh2HgHMwwgMGw==
X-Received: by 2002:ae9:ee01:: with SMTP id i1mr2787379qkg.10.1604686068338;
        Fri, 06 Nov 2020 10:07:48 -0800 (PST)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:316:f693:9fff:feea:df57])
        by smtp.gmail.com with ESMTPSA id r133sm1018660qke.23.2020.11.06.10.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 10:07:47 -0800 (PST)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Tanner Love <tannerlove@google.com>
Subject: [PATCH net-next 0/2] net/packet: make packet_fanout.arr size configurable up to 64K
Date:   Fri,  6 Nov 2020 13:07:39 -0500
Message-Id: <20201106180741.2839668-1-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.29.1.341.ge80a0c044ae-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tanner Love <tannerlove@google.com>

First patch makes the change; second patch adds unit tests.

Tanner Love (2):
  net/packet: make packet_fanout.arr size configurable up to 64K
  selftests/net: test max_num_members, fanout_args in psock_fanout

 include/uapi/linux/if_packet.h             | 12 ++++
 net/packet/af_packet.c                     | 37 +++++++----
 net/packet/internal.h                      |  5 +-
 tools/testing/selftests/net/psock_fanout.c | 72 +++++++++++++++++++++-
 4 files changed, 109 insertions(+), 17 deletions(-)

-- 
2.29.1.341.ge80a0c044ae-goog

