Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192012B9CEC
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 22:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgKSVXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 16:23:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgKSVXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 16:23:48 -0500
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97F0C0613CF;
        Thu, 19 Nov 2020 13:23:46 -0800 (PST)
Received: by mail-qv1-xf43.google.com with SMTP id u23so3676655qvf.1;
        Thu, 19 Nov 2020 13:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=3EhlA/ojPqIOU5cMnOFpW3uOLWZv3oRbFSBRyB2tWxE=;
        b=pVd9Ryyl9bj1VALGBGuAU7dA4VzLykh+oRK41Rz1UQBSS9UVbFmu1Gi+xmr+wvBPl4
         DE4P1blNBT4qVTRbBu7WpY0+xMUGANXBpPKzV6+YlEfjzVfNUYwS4XCwGfH9mVsUtJxe
         M04NOF/Jo/LoPVJOa+okSMrd09a550jXrraiV/RsqkfZgE6+CoxEULQfBNlOyfz0z6/l
         Oy00zMtTGbXbqhNeXyQZWz9a6uPuSVTvE0IaSQaS+Yb+MHgBIuBFk36Gou+jy7FXYDKr
         x5CwLXANfc6EUF3Xt/RAFtoJZsYX3mDlDl/saUmrLHM7MBkDFudOECIrEkrl757ms3i5
         f5GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=3EhlA/ojPqIOU5cMnOFpW3uOLWZv3oRbFSBRyB2tWxE=;
        b=WQfM7GWOhjqTw/prWQZtayJhiPoO2OWJN6KJHgZLtJlDAf3NwYgXorAiAxc78mbwk5
         Xmyzm7y5x06gC1lYm14gLAhIRasA5bgVq52Cq9Bv8GP7UBlB0IRDhLMqpY3fMwjjxkCP
         Kj1WHv83pX/7T5ip2Bz79eS5v9wyOSYKW991y612/8o3/bCIkKqEKpt9E85nu2LBXvlt
         Bof90wlNSW0CifpWcpdTAIJJHgVjeRZIiYm/IJsNJUos5Bjb5OrkBR5lNyS28bzwIU/8
         1Mgrii4iBq+BN2FE9RX3j3mLd7D6LQGsHsbCuFRhExrugKbTIkFhTeO/sQcwphjp8fKi
         BvWA==
X-Gm-Message-State: AOAM530mgGqkRzEokr3Wgh06471v8JboM6Y8f/LrYLkLuHWFvKJq+Npl
        3l7sLvucX7STH2N5DDJaQqFYSPla4ZGemw==
X-Google-Smtp-Source: ABdhPJxeqpO8Clh7MY4Nsc0+VXuCj0ARru09+d6mpeWI0BIKQ7+713M5TfiFy8kzp4QOTHbXgWc8MA==
X-Received: by 2002:a05:6214:768:: with SMTP id f8mr12339584qvz.1.1605821025917;
        Thu, 19 Nov 2020 13:23:45 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id y192sm831662qkb.12.2020.11.19.13.23.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 13:23:45 -0800 (PST)
Subject: [net PATCH 0/2] tcp: Address issues with ECT0 not being set in DCTCP
 packets
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net, kafai@fb.com,
        kernel-team@fb.com, edumazet@google.com, brakmo@fb.com,
        alexanderduyck@fb.com, weiwan@google.com
Date:   Thu, 19 Nov 2020 13:23:43 -0800
Message-ID: <160582070138.66684.11785214534154816097.stgit@localhost.localdomain>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set is meant to address issues seen with SYN/ACK packets not
containing the ECT0 bit when DCTCP is configured as the congestion control
algorithm for a TCP socket.

A simple test using "tcpdump" and "test_progs -t bpf_tcp_ca" makes the
issue obvious. Looking at the packets will result in the SYN/ACK packet
with an ECT0 bit that does not match the other packets for the flow when
the congestion control agorithm is switch from the default. So for example
going from non-DCTCP to a DCTCP congestion control algorithm we will see
the SYN/ACK IPV6 header will not have ECT0 set while the other packets in
the flow will. Likewise if we switch from a default of DCTCP to cubic we
will see the ECT0 bit set in the SYN/ACK while the other packets in the
flow will not.

---

Alexander Duyck (2):
      tcp: Allow full IP tos/IPv6 tclass to be reflected in L3 header
      tcp: Set INET_ECN_xmit configuration in tcp_reinit_congestion_control


 net/ipv4/tcp_cong.c | 5 +++++
 1 file changed, 5 insertions(+)

--

