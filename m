Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6F0300470
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 14:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbhAVNnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 08:43:41 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:17499 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbhAVNnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 08:43:39 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600ad6620000>; Fri, 22 Jan 2021 05:42:58 -0800
Received: from yaviefel (172.20.145.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 22 Jan 2021 13:42:49
 +0000
References: <20210121234317.65936-1-rasmus.villemoes@prevas.dk>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Petr Machata <petrm@nvidia.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
CC:     <netdev@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Petr Machata" <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Vecera <ivecera@redhat.com>,
        "Jakub Kicinski" <kuba@kernel.org>
Subject: Re: [PATCH resend net] net: switchdev: don't set
 port_obj_info->handled true when -EOPNOTSUPP
In-Reply-To: <20210121234317.65936-1-rasmus.villemoes@prevas.dk>
Date:   Fri, 22 Jan 2021 14:42:45 +0100
Message-ID: <87y2glay0a.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611322978; bh=z7AAVkq4BTsyvhDS6nXFnqc5/A75c8keaNt8zf2SlLY=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Date:
         Message-ID:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=ZiSK8uaUwuNbQAsAEkF0tGAurVaVNxb8lQVFrjz9jehcQzaPG5UyKhag1WTz+B3E/
         ojKkHxF9S8I8im9XgwysywE5LBRLHOPvysgcklYed5mvcCkjGe+FsrdmahgHx0nCAF
         6PZxd9sZC1MaT0FX+aVyS1gjhUIDAYCiSIGL0ibrckbgdVIRw+jkpO+2ZCzbutHSzQ
         lPiZa/fNmvJjzneX9fGlPfLswnpx/tpXmiV7Gu7K33gHfhX+tEv2+jevrprYGyZ0+D
         +hW3U8ctlBNp98JS6Ey/J8NH0B+QaoGGCQukxolaWOM04dkLqq1TAdeGxyZiH6yvsC
         lgs0C5o4KcjuA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Rasmus Villemoes <rasmus.villemoes@prevas.dk> writes:

> It's not true that switchdev_port_obj_notify() only inspects the
> ->handled field of "struct switchdev_notifier_port_obj_info" if
> call_switchdev_blocking_notifiers() returns 0 - there's a WARN_ON()
> triggering for a non-zero return combined with ->handled not being
> true. But the real problem here is that -EOPNOTSUPP is not being
> properly handled.
>
> The wrapper functions switchdev_handle_port_obj_add() et al change a
> return value of -EOPNOTSUPP to 0, and the treatment of ->handled in
> switchdev_port_obj_notify() seems to be designed to change that back
> to -EOPNOTSUPP in case nobody actually acted on the notifier (i.e.,
> everybody returned -EOPNOTSUPP).
>
> Currently, as soon as some device down the stack passes the check_cb()
> check, ->handled gets set to true, which means that
> switchdev_port_obj_notify() cannot actually ever return -EOPNOTSUPP.
>
> This, for example, means that the detection of hardware offload
> support in the MRP code is broken - br_mrp_set_ring_role() always ends
> up setting mrp->ring_role_offloaded to 1, despite not a single
> mainline driver implementing any of the SWITCHDEV_OBJ_ID*_MRP. So
> since the MRP code thinks the generation of MRP test frames has been
> offloaded, no such frames are actually put on the wire.
>
> So, continue to set ->handled true if any callback returns success or
> any error distinct from -EOPNOTSUPP. But if all the callbacks return
> -EOPNOTSUPP, make sure that ->handled stays false, so the logic in
> switchdev_port_obj_notify() can propagate that information.
>
> Fixes: f30f0601eb93 ("switchdev: Add helpers to aid traversal through lower devices")
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

Looks good.

Reviewed-by: Petr Machata <petrm@nvidia.com>

Thanks!
