Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 362F62742B2
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 15:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgIVNL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 09:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726566AbgIVNL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 09:11:27 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E75C061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 06:11:27 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id t138so18915389qka.0
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 06:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=wau+OGNuUG2bWR+5cFA/zIG3EpHkt6fsz1L8ujw+ilA=;
        b=NzwqLu+snY6bp7o6n7IHv40Sh9ovlhl+iPNA/7x3KwOFRviWXbMraG/hEK+45zl5NS
         YsBm3awGeW6lDwEkvRsN01AI3gi0bF9tppzq6JF+cMoiogaCX3bn8usYU4+ZLloK3WZi
         895Hao2NE1d8W2YOAjZqAyAoOiO9mcNy0z9dd3trolW2WlUYMwbrqeAlHK1byO3keV9R
         ACcQnB+ZCJbwQZ+8Lf2WA46oghLKm1V3idgTwl3k8pL+UY2ER9jqEY4SAhIIRCCRaV4M
         Ezt990INCDDXd+K8ParOM45etYgu7XHzJyM5LIN4lKpL+AodeQukQv+JU7IZNtI67anw
         TqTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=wau+OGNuUG2bWR+5cFA/zIG3EpHkt6fsz1L8ujw+ilA=;
        b=sf5Bj0VdaMv5q0tlNBmrAoXMmDgFy7xjbhaEBM1/7an1iCqiW3EQL/qUKIbBAN5A4O
         Nne5kuGy31+kM+TK1JGNQWW1jsWvroz+/X9Y+Ldopwxv0CueqJ8Ypyf1pwQ45v9aehbm
         sO1ZiBXX0uAPO3rt39l7MNK9UGhbuQSD3On2u5ia68KmFMWjxR5cPxjphWcAspgtZunm
         M9CM0lobxGoeBhvNk6oxJ5hnS84u+hOunPQBCb0TyQeqDB3//5kAtkVtWXGPQZ8yUIXP
         u5yji3VDioTvu5MmBOCKL4LVeVYtImAUo6x2q3lxDg93PMII7muMILZWiz3ke5+A462A
         pj6g==
X-Gm-Message-State: AOAM530L299sX49u7p3+P4QJ/M3XUwkGdt+JiL0nmPFGyW5ixDGwR6wa
        ZdpqIsbK4HXihWYDhpVlJXSul4pgzACo
X-Google-Smtp-Source: ABdhPJyhF+5phep63X+baMEumcp5NssdgwVqSXbxG3IX+AqstiufUGs4nGynxZ0pUkwmZUi9zqL0Cw==
X-Received: by 2002:a05:620a:13f9:: with SMTP id h25mr4354111qkl.283.1600780286671;
        Tue, 22 Sep 2020 06:11:26 -0700 (PDT)
Received: from ICIPI.localdomain ([136.56.89.69])
        by smtp.gmail.com with ESMTPSA id d200sm11442595qkc.109.2020.09.22.06.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 06:11:26 -0700 (PDT)
Date:   Tue, 22 Sep 2020 09:11:22 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: ip rule iif oif and vrf
Message-ID: <20200922131122.GB1601@ICIPI.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

We have a use case where there are multiple user VRFs being leak routed
to and from tunnels that are on the core VRF. Traffic from user VRF to a
tunnel can be done the normal way by specifying the netdev directly on
the route entry on the user VRF route table:

ip route add <prefix> via <tunnel_end_point_addr> dev <tunnel_netdev>

But traffic received on the tunnel must be leak routed directly to the
respective a specific user VRF because multiple user VRFs can have
duplicate address spaces. I am thinking of using ip rule but when the
iif is an enslaved device, the rule doesn't get matched because the
ifindex in the skb is the master.

My question is: is this a bug, or is there anything else that can be
done to make sure that traffic from a tunnel being routed directly to a
user VRF? If it is the later, I can work on a patch.

Thank you,

Stephen.
