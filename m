Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12053255963
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 13:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729202AbgH1LbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 07:31:15 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:18770 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728680AbgH1LbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 07:31:01 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f48e5520001>; Fri, 28 Aug 2020 04:06:58 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 28 Aug 2020 04:09:00 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 28 Aug 2020 04:09:00 -0700
Received: from yaviefel (172.20.13.39) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 28 Aug 2020 11:08:49
 +0000
References: <20200827174041.13300-1-xiyou.wangcong@gmail.com>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@nvidia.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     <netdev@vger.kernel.org>,
        <syzbot+b33c1cb0a30ebdc8a5f9@syzkaller.appspotmail.com>,
        <syzbot+e5ea5f8a3ecfd4427a1c@syzkaller.appspotmail.com>,
        Petr Machata <petrm@mellanox.com>
Subject: Re: [Patch net] net_sched: fix error path in red_init()
In-Reply-To: <20200827174041.13300-1-xiyou.wangcong@gmail.com>
Date:   Fri, 28 Aug 2020 13:08:46 +0200
Message-ID: <87lfhzdo3l.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598612818; bh=PfgHxmOEUcuOlllkd1Mc6l1i7UPGzfbcGULMo0jpNX0=;
        h=X-PGP-Universal:References:User-agent:From:To:CC:Subject:
         In-Reply-To:Date:Message-ID:MIME-Version:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=FKk71lUv9ycye2Gvi17+ICt+wU7gmKeWDBp06hrslSFY2le5nceWc8b4f4woMmTbL
         VuROgklwkpRuL2gDQa5AAt3CAvVMX8A+jptLCtNTXm8w0ZRusTW+/Vk1hUwduOtTN3
         G3odqzzX/0ueNZBqKIH8ukUX4OwoS5mfhVSB4ms8SK+wfkd1Bgc0VhJB1bYRo9AWT1
         vMDl9v7toJU0LnQ1qZ5Adjmqu6V/F9lgUmmYmCZsla4k8jUKewAIzwQy0N4cPfUNes
         sORdp79NVSGVJalLksT1lxBsQt3QI8S/zJODJ1sbDARcU0R+UOnC/AQRneHpMZ0wey
         M5Rt9u6E1CZOA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Cong Wang <xiyou.wangcong@gmail.com> writes:

> When ->init() fails, ->destroy() is called to clean up.
> So it is unnecessary to clean up in red_init(), and it
> would cause some refcount underflow.

Hmm, yeah, qdisc_put() would get called twice. A surprising API, the
init needs to make sure to always bring the qdisc into destroyable
state. But qevents are like that after kzalloc, so the fix looks
correct.

Reviewed-by: Petr Machata <petrm@nvidia.com>

Thanks!
