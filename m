Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73F8E12E84C
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 16:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbgABPu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 10:50:59 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:35179 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728692AbgABPu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 10:50:59 -0500
Received: by mail-pj1-f68.google.com with SMTP id s7so3506295pjc.0
        for <netdev@vger.kernel.org>; Thu, 02 Jan 2020 07:50:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=GENgxy63AoFh0BOCNtfVuuosVUuHdXo2BMjGfPBx85U=;
        b=NeQ0wlWu2/J9YrsMzVzL356bbSdO+ZmN/0IIDuy3ylBBEr7HeytLMVfEVMUZZBBItS
         P7oLojGDB8mtDu+bn2YMnegrMj6jNYQlu7CaxDWUT/BerQOW/QeoG/H3eGOB61nf18cO
         u/WUzd0VSsxDwILlr8knphL4BvaRaAGgl5BZA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GENgxy63AoFh0BOCNtfVuuosVUuHdXo2BMjGfPBx85U=;
        b=n/GvKqXgLN0X89VDwLu6EJsxu1BiEnhjiHg+iotgjV8Whrg8PDQxp2l8goiXMwT2nf
         IthkaDMvsJ2qVcISU2A5eWNbhNiby6NqliAoJlxdvdttObmycabG1rWMo4mpwLBzr+5Q
         Xk2IM+mSVmUBVMcVnGLCVef4xgi0FreEtTX4FFw8ado77JBWaQp/ZvoMq+IEzc6oSRoe
         feFCrhef7GGXPFg9pKAKIMhUv6bEIG0uWUbjyfDps3ADIZPB94waUjEtCFDenPvAr9M7
         Frqn5hm9CW3bGf7QRzObzrw60u4v6WGFyIrfAiLv25I1QLJ1tO+1o0/x3DoZoHhvjtNw
         dsMQ==
X-Gm-Message-State: APjAAAXfTtvLCcd1DcQI2Q6RGRQ3UXsCwRH30GVt0sxUeoKzJZJUAhX2
        ixv3oY2ThQ2LkVacLhLFCHVwhQ==
X-Google-Smtp-Source: APXvYqzZLp15lKkIt+gXEryl82JVrBpljCNt2vLi8pxbdDuPNo67f7PZs++G25Ux0Hx5EFFPcVqPkg==
X-Received: by 2002:a17:902:a58b:: with SMTP id az11mr86055304plb.147.1577980258866;
        Thu, 02 Jan 2020 07:50:58 -0800 (PST)
Received: from Ninja.ibn.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2sm11499420pjv.18.2020.01.02.07.50.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 02 Jan 2020 07:50:58 -0800 (PST)
From:   Vikas Gupta <vikas.gupta@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     vasundhara-v.volam@broadcom.com, vikram.prakash@broadcom.com,
        Vikas Gupta <vikas.gupta@broadcom.com>
Subject: [PATCH INTERNAL v1 0/3] Devlink notification after recovery complete by bnxt_en driver
Date:   Thu,  2 Jan 2020 21:18:08 +0530
Message-Id: <1577980091-25118-1-git-send-email-vikas.gupta@broadcom.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
 This patchset adds following feature in devlink 
  1) Recovery complete direct call API to be used by drivers when it
     successfully completes. It is required as recovery triggered by
     devlink may return with EINPROGRESS and eventually recovery 
     completes in different context.
  2) A notification when health status is updated by reporter.

 Patchset also contains required changes in bnxt_en driver to 
 mark recovery in progress when recovery is triggered from kernel 
 devlink.


Vikas Gupta (3):
  devlink: add support for reporter recovery completion
  devlink: add devink notification when reporter update health state
  bnxt_en: Call recovery done after reset is successfully done

 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |  1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 14 ++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h |  1 +
 include/net/devlink.h                             |  2 +
 net/core/devlink.c                                | 62 +++++++++++++++++------
 5 files changed, 63 insertions(+), 17 deletions(-)

-- 
2.7.4

