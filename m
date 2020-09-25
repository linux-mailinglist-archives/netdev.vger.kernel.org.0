Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C083827948A
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 01:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729058AbgIYXMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 19:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgIYXMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 19:12:16 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A94EC0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 16:12:16 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id y14so3811518pgf.12
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 16:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=DAci90Qs3cOEbHtcWnHMOz2Uaq1o3seVy2b+35LkX8s=;
        b=ntMrGcw6N81LEqWiLcAX1R1ZccXC96meO5NwmaYytrbMDfo9dtPbFStE5NQaaUBj+l
         scvHvt/ndutwXgCDD+vEW4Q+UyDZXXRbML+wa+ijvYpXoiNrM8Mt7VjylJntCC43DXuN
         p9lRG24x0auhkhPSq2AMUma+UXQZqYazVdI1LPiSgwyv+Drg05h8vfDEheeZRpqr5B/P
         HbN46QjfT/UMV2G4YDeaZXuwb4Xgr09LLeWmOZbyv57FD4yL+HpX2pquzmOWDrq3c+Cz
         CKD3uGQwMS13A4VSo7VEDZJUDsYupFZlpplqGb/TKBdcI9jcdqAIXGfx5jM46H+O4xir
         H+7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=DAci90Qs3cOEbHtcWnHMOz2Uaq1o3seVy2b+35LkX8s=;
        b=jmNUdY1/4ZwPREM4939ufsBWfuAe+AvWTWehEvwR9i5Du6ckdOO+RAwdO5mxmSirqb
         3uQKsPVXfEXLqsiQQjNXpg4swCLVWRkvobZmZxQHX9/WB1wi+AcVzplmMEEfda5PqxKi
         xbARaDMALYd2NLuII5Z+OphZX67sQ/g4kDMCRw0vFTqIASu76HXtv7o6WwIy+9qrcWkX
         oFKYRfrA9dyjeOE/UDgfuUoyD8JnlZkwKQxnnxgXt8d0q9k7+8DdubtUpOUvFq6Q0awW
         U+RzdH6bp7p/l2si5+USefs5EJliM5zWMkL3JeOjIGCYD0f+6eLR5U3OzDBkP4f4wiJf
         CANQ==
X-Gm-Message-State: AOAM53386aOqGawK8TNpN/WVn6y/hMN5QhYi4HD9Q+rCve1BVseeyHvV
        hg5i22B1ry8rO0PiW2tHEufY55ajWGlicQ==
X-Google-Smtp-Source: ABdhPJyAzFXdH4a7lhqejVcTAHshum00PqHU9kNmNg5Yc3yK0NeH6+94GqdV8pFYIbxTtUMAtb0Rxw==
X-Received: by 2002:a63:1a21:: with SMTP id a33mr964463pga.305.1601075535782;
        Fri, 25 Sep 2020 16:12:15 -0700 (PDT)
Received: from harryc-og.bne.opengear.com (brisbane.opengear.com. [60.241.24.90])
        by smtp.gmail.com with ESMTPSA id q190sm3916417pfq.99.2020.09.25.16.12.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 16:12:15 -0700 (PDT)
From:   Qingtao Cao <qingtao.cao.au@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, corbet@lwn.net
Subject: Support default route metric per interface
Date:   Sat, 26 Sep 2020 09:11:58 +1000
Message-Id: <20200925231159.945-1-qingtao.cao.au@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On a multihomed device there may be multiple default routes with different
priorities. For example by default the default route via the cable/WAN
interface has a higher priority (lower metric value) than the one via the
expensive cellular modem. However, when the userspace detects a network
connection issue on the cable/WAN interface, the userspace may change
metrics to prefer the celluar modem's default route until the one via the
cable/WAN is restored

When the kernel automatically creates routes such as IPv4 subnet routes
with newly bound addresses or IPv6 prefix routes with reception of RAs, the
kernel is expected to follow the same preference as decided by the userspace

To this end, per-interface's def_rt_metric sysfs attribute files are added,
so that:
. when userspace changes interfaces' priority, their metrics values could
  also be saved into their def_rt_metric sysfs files
. whenever the kernel creates IPv4 or IPv6 routes, the value in def_rt_metric
  for the relevant interface is read and applied when userspace has not
  explicitly specified a metric value (for example, via the IFA_RT_PRIORITY
  attribute in netlink messages)

If an interface's def_rt_metric is 0 then the kernel default metric value
will be fallen back on.

