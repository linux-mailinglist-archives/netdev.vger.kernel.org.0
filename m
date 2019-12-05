Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7AC113BDD
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 07:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbfLEGln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 01:41:43 -0500
Received: from mail-oi1-f179.google.com ([209.85.167.179]:33168 "EHLO
        mail-oi1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbfLEGln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 01:41:43 -0500
Received: by mail-oi1-f179.google.com with SMTP id v140so1796280oie.0
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 22:41:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=dXexx7DmCmH6C8/L+0YKCXrtO/22TuGnUACC1lkJ9hA=;
        b=i6cVPCI7Mm+V+BCqPBmSJ/E1p+BVAU5oJY+93VfJV9nGZVMqlVbGlBibJOfDeQWaZi
         5iyE3kvLt1IKQsqPH78pH//AC/WthOwFcNoKoS+sixKzHmtRPbqX96+VeIbphL1GRzr+
         FLTIKLAdIMjDxxW3kFsRH2XbxMhEtp0OQT/8iRmZ5q8Q7qLdHRq0lat9Jy2gq5000hgr
         PHtQjahKLfaIf4Y+9HhZi9b+amthf4WUHQaiXgs1dLFVORY9pFC5rzzEOM0OQ6MpZOCb
         qSXUCRLtCEBOJBe7fUApVM55pD+84voHbhqaAEI97liQ4g0T80cZxXd6lwN+TtWPrg13
         SuXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=dXexx7DmCmH6C8/L+0YKCXrtO/22TuGnUACC1lkJ9hA=;
        b=YE7vWGvL2mdgFubBxhJq3W+6qYrrpWUlykIrLWMIsvbikChkI2XG1xRmIK1Fd7j6VS
         71fAMH9Tk64BC+V08cq2tJQS4aA8mpo0mvXGR4xSOV4Ho+o4x8G+xncZZOjVVCAfkOi5
         QX1llvQXcf7bf3GlQvwpkcF8bpZqv+e5QpyvopKLN9T+lntDDBTcdrCuFP4iPHJ8KAbS
         fOEf0lSXnCveB1sWuYVA6i/+QA6tOh3laZq80uo8Ce1Yi06Kz9joqGMxabYi0fMUJM+4
         iPawkomTqn5geqNnupUMq521C/pXlS70UnPIJTEOgwrSpJSrVNtt6TpyHSJpewPbX//7
         IMqg==
X-Gm-Message-State: APjAAAWQBbcRikabohXUIDTe5U26n8jRgEDh0SBYvAmvmrFJ0IN3a28j
        uggZtIHA5wbDtEVA4pBIY+Ejiha61znVqEaiG1w=
X-Google-Smtp-Source: APXvYqwYOAyWGjhdgZLtJ95ir5YINlwrjlHb/aBRcpFeN9xJKaBHkZ0m7+4o1kpuy627/8stiINgaRXe9/rWtga/iIc=
X-Received: by 2002:aca:b588:: with SMTP id e130mr5816988oif.169.1575528102445;
 Wed, 04 Dec 2019 22:41:42 -0800 (PST)
MIME-Version: 1.0
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Thu, 5 Dec 2019 14:41:06 +0800
Message-ID: <CAMDZJNXcya=6VsXitukS5MmZ36oPCUVNMncBJKrWmzwK62LeUg@mail.gmail.com>
Subject: mlx5 support tc accept action
To:     Roi Dayan <roid@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Roi, Saeed
In one cause, we want the "accept" action: the IP of VF will be
"accept", and others
packets will be done with other actions(e.g. hairpin rule to other VF).

For example:

PF0=enp130s0f0
VF0_REP=enp130s0f0_0
VF0=p4p1_0
VF1=p4p2_0 # belong to PF1
VF0_IP=3.3.3.200

ethtool -K $PF0 hw-tc-offload on
ethtool -K $VF0 hw-tc-offload on
tc qdisc add dev $PF0 ingress
tc qdisc add dev $VF0 ingress
tc filter add dev $PF0 protocol all parent ffff: prio 10 handle 1
flower skip_sw action mirred egress redirect dev $VF0_REP
tc filter add dev $VF0 protocol ip parent ffff: prio 1 handle 3 flower
skip_sw dst_ip $VF0_IP action pass
tc filter add dev $VF0 protocol all parent ffff: prio 10 handle 2
flower skip_sw action mirred egress redirect dev $VF1

When I change the driver, the rule which action "action pass", can be
offloaded, but it didn't work.
+               case FLOW_ACTION_ACCEPT:
+                   action |= MLX5_FLOW_CONTEXT_ACTION_ALLOW;
+                   break;


How can we support it, this function is import for us.
