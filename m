Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 920CB2067D0
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 01:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388201AbgFWXB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 19:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388185AbgFWXBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 19:01:55 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2613BC061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 16:01:55 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id a1so395214ejg.12
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 16:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=QUORKcluDvTc8O0ydBRyRQB8lQ5ndgsbsG7repxMOU0=;
        b=Jw0/Ar9SPacarpMFDZlw3QqqpbitHGRItdgTC/OlvDJMQqn7DYv4M1T7KaInSfFb8F
         195BIAW3z+oGm6nSDnbL/toqhA3up8rrZVznzkDp4nQ3njjQ/RPUSWi/gKCDI62Dpzzr
         CoaPYU8AqFlbnyP1LW/7Z8KT40Ocl0e9E4xRI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QUORKcluDvTc8O0ydBRyRQB8lQ5ndgsbsG7repxMOU0=;
        b=oZqUEOb3cA0WMVNLs7HYfs8wC4ZN5IU+k1r/tP68SPEnv2DBrzmCMrDSCBxpxMeGgw
         HoMpMpqKT8RON/TAxWeAUU6a1F2FJ1oI7zY7qZWnrh8BK3fo7kzbzz92GI0s50wXIKpS
         5+VvLCkdsXeFOStA7UaVINsPsjHUuUf31j2iozN7xK9C+UrUNOrM32KHHxq34CaU/5Yg
         rrBe7KkOMjesA3pKbso18Y9uJYqN7dFIr7xLFIRBwLvALHO3XrFZc9rkAumjtJQw61rW
         5bG9uPsp+1wz1FlA3lcrJd4pQnkDbvjmNE3P8y1KN5v+cLKbnxgwuavUg7EkBcOoMKXH
         a3jA==
X-Gm-Message-State: AOAM531OJg372BWDcVsPJ8mpwMTLQRj1HfzrqSZFtg/fVC5osOGrd0kV
        lky1mp9JRt95f8okU5YqcfWRHLjB1J4=
X-Google-Smtp-Source: ABdhPJwQURCZG//4LfAf1SqQ7QuMRuKizBA4YUuZZC4raQJcfrf2on1ZBro3cX/oEfR2s8EgBXdHcA==
X-Received: by 2002:a17:906:36d0:: with SMTP id b16mr125192ejc.437.1592953313613;
        Tue, 23 Jun 2020 16:01:53 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id cw19sm8205865ejb.39.2020.06.23.16.01.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jun 2020 16:01:53 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/4] bnxt_en: Bug fixes.
Date:   Tue, 23 Jun 2020 19:01:34 -0400
Message-Id: <1592953298-20858-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch stores the firmware version code which is needed by the
next 2 patches to determine some worarounds based on the firmware version.
The workarounds are to disable legacy TX push mode and to clear the
hardware statistics during ifdown.  The last patch checks that it is
a PF before reading the VPD.

Please also queue these for -stable.  Thanks.

Michael Chan (3):
  bnxt_en: Store the running firmware version code.
  bnxt_en: Do not enable legacy TX push on older firmware.
  bnxt_en: Fix statistics counters issue during ifdown with older
    firmware.

Vasundhara Volam (1):
  bnxt_en: Read VPD info only for PFs

 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 36 +++++++++++++++++++++++++------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  5 +++++
 2 files changed, 34 insertions(+), 7 deletions(-)

-- 
1.8.3.1

