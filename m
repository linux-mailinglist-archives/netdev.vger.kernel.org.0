Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6A9F36BD8E
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 04:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbhD0C4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 22:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbhD0C4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 22:56:07 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 096F0C061574;
        Mon, 26 Apr 2021 19:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID;
        bh=L4kfcrc85nJywNTxQJ9ULzn904QQW3nv4pDzdVyLdWA=; b=IM09J8pKq1VV8
        ofMedyYnlwj2tQYrRL0LnIYLyQrg2BcbupMuXBG3w/b2EEyk3zkA4q06GLKCPWQs
        WpG4LjCNh/5ocWM92Nb6kgkyGrTqAmXVknzNYpQrN3WTYP6+4SlRFlOW/qm/cgYn
        CZrssgniRRhuHYTXLkE6lLgLP7ayow=
Received: by ajax-webmail-newmailweb.ustc.edu.cn (Coremail) ; Tue, 27 Apr
 2021 10:55:06 +0800 (GMT+08:00)
X-Originating-IP: [104.245.96.151]
Date:   Tue, 27 Apr 2021 10:55:06 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   lyl2019@mail.ustc.edu.cn
To:     benve@cisco.com, _govind@gmx.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [BUG] ethernet:enic: A use after free bug in enic_hard_start_xmit
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT3.0.8 dev build
 20190610(cb3344cf) Copyright (c) 2002-2021 www.mailtech.cn ustc-xl
X-SendMailWithSms: false
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <65becad9.62766.17911406ff0.Coremail.lyl2019@mail.ustc.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: LkAmygDHeO4KfYdgmhxPAA--.1W
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/1tbiAQsEBlQhn6cdfAABsl
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, maintainers.
    Our code analyzer reported a uaf bug, but it is a little
difficult for me to fix it directly.

File: drivers/net/ethernet/cisco/enic/enic_main.c
In enic_hard_start_xmit, it calls enic_queue_wq_skb(). Inside
enic_queue_wq_skb, if some error happens, the skb will be freed
by dev_kfree_skb(skb). But the freed skb is still used in 
skb_tx_timestamp(skb).

```
	enic_queue_wq_skb(enic, wq, skb);// skb could freed here

	if (vnic_wq_desc_avail(wq) < MAX_SKB_FRAGS + ENIC_DESC_MAX_SPLITS)
		netif_tx_stop_queue(txq);
	skb_tx_timestamp(skb); // freed skb is used here.
```
Bug introduced by fb7516d42478e ("enic: add sw timestamp support").

Thanks for your time, looking forwarding to your reply.
Lv Yunlong <lyl2019@mail.ustc.edu.cn>
