Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7D21F5D71
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 22:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgFJU6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 16:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbgFJU6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 16:58:45 -0400
X-Greylist: delayed 437 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 10 Jun 2020 13:58:44 PDT
Received: from pandora.armlinux.org.uk (unknown [IPv6:2001:4d48:ad52:32c8:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D3BC03E96B;
        Wed, 10 Jun 2020 13:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=qRd9E6mg/me3FC+zYkNIbQdzQKiPFe8haYKnIMtGAPI=; b=xXS/kmbZXA25AeuRymU+hgewWJ
        Ucr/LjQXb+HkftrRyQ6fa4AMVX9nzR/smEsPPKj/13wta/BBtkf0vd6Is0j+D7fY47czVMIb55q5Y
        QWw1qCEV/pkcIQXkKTmYoNf0GKSwGfZ/ISd3jbWjeny3YE7xsO6TEWMDhNzb4BlinYsOrnBbd97ZX
        JjBiZvY0eiOPC6pr8ttcA6jewlAjhjrMOGfgnquBsklB42j+WsLB/9i1hDmlwk1gXGXzmEWKic2vB
        5DNhEHj3BMWPfig6Oa9fR4pJ8WzU4QzZ2ywg5l2eAc10o+0MCIJUqgWPVSuMLiFFVRM1ohzrbhFAZ
        6naFcpqg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:59226 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jj7gm-0006sH-2y; Wed, 10 Jun 2020 21:51:12 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jj7gl-0008Bq-BQ; Wed, 10 Jun 2020 21:51:11 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     coreteam@netfilter.org, netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH] netfiler: ipset: fix unaligned atomic access
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jj7gl-0008Bq-BQ@rmk-PC.armlinux.org.uk>
Date:   Wed, 10 Jun 2020 21:51:11 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using ip_set with counters and comment, traffic causes the kernel
to panic on 32-bit ARM:

Alignment trap: not handling instruction e1b82f9f at [<bf01b0dc>]
Unhandled fault: alignment exception (0x221) at 0xea08133c
PC is at ip_set_match_extensions+0xe0/0x224 [ip_set]

The problem occurs when we try to update the 64-bit counters - the
faulting address above is not 64-bit aligned.  The problem occurs
due to the way elements are allocated, for example:

	set->dsize = ip_set_elem_len(set, tb, 0, 0);
	map = ip_set_alloc(sizeof(*map) + elements * set->dsize);

If the element has a requirement for a member to be 64-bit aligned,
and set->dsize is not a multiple of 8, but is a multiple of four,
then every odd numbered elements will be misaligned - and hitting
an atomic64_add() on that element will cause the kernel to panic.

ip_set_elem_len() must return a size that is rounded to the maximum
alignment of any extension field stored in the element.  This change
ensures that is the case.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
Patch against v5.6, where I tripped over this bug.  This bug has
caused a kernel panic on my new router twice today.

 net/netfilter/ipset/ip_set_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 8dd17589217d..be9cd6a500fb 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -459,6 +459,8 @@ ip_set_elem_len(struct ip_set *set, struct nlattr *tb[], size_t len,
 	for (id = 0; id < IPSET_EXT_ID_MAX; id++) {
 		if (!add_extension(id, cadt_flags, tb))
 			continue;
+		if (align < ip_set_extensions[id].align)
+			align = ip_set_extensions[id].align;
 		len = ALIGN(len, ip_set_extensions[id].align);
 		set->offset[id] = len;
 		set->extensions |= ip_set_extensions[id].type;
-- 
2.20.1

