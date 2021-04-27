Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48B7036BD23
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 04:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234896AbhD0CHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 22:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbhD0CHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 22:07:47 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 03911C061574;
        Mon, 26 Apr 2021 19:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID;
        bh=yINMv3uOqWN+slcpRlNpznilpHkVL0ty48AwqG03qjg=; b=p4VlS5B95/um1
        NrGUlSKRw2hI1wXC2oKwHdsdXEoSdDP2NtpftEq0wVfii68EhB/dTTM6GmUemjKX
        KmNekcLiNSz39T681Ku3DVlfVMsDcttGxs5V38SLsAuOGn2NT5/fIQ9XSUb9HGRD
        /fSmG7LaS9F7fcoc2roMLi3IFVa1Oc=
Received: by ajax-webmail-newmailweb.ustc.edu.cn (Coremail) ; Tue, 27 Apr
 2021 10:06:54 +0800 (GMT+08:00)
X-Originating-IP: [104.245.96.151]
Date:   Tue, 27 Apr 2021 10:06:54 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   lyl2019@mail.ustc.edu.cn
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [BUG] net:ipv6/ip6_tunnel:  A double free in ip6_tnl_start_xmit
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT3.0.8 dev build
 20190610(cb3344cf) Copyright (c) 2002-2021 www.mailtech.cn ustc-xl
X-SendMailWithSms: false
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <4072c4bc.6242b.17911144f20.Coremail.lyl2019@mail.ustc.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: LkAmygCHj5u+cYdgy85OAA--.6W
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/1tbiAQsEBlQhn6cVyAABsZ
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VW7Jw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, maintainer.
    Our code analyzer reported a double free bug,
and it is a little difficult for me to fix the intricate bug.

File: net/ipv6/ip6_tunnel.c

 In ip6_tnl_start_xmit, it calls ipxip6_tnl_xmit() and then
ipxip6_tnl_xmit calls ip6_tnl_xmit(). The skb could be freed
at line 1,213 via consume_skb(skb). If ip6_tnl_xmit() returns
an error code, the tx_err branch of ip6_tnl_start_xmit will free
the skb again.

Issue: e7bb18e6c8b7e ("ip6_tunnel: simplify transmit path")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
