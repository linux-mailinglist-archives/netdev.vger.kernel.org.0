Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDCAD2CF8
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 16:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfJJOxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 10:53:15 -0400
Received: from mail.dlink.ru ([178.170.168.18]:52196 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbfJJOxP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 10:53:15 -0400
X-Greylist: delayed 568 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Oct 2019 10:53:13 EDT
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id E492E1B219BE; Thu, 10 Oct 2019 17:43:42 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru E492E1B219BE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1570718622; bh=FHtBS7Jcy3ew21+qN/bqcaXjjtB/iGpxjWtHVQNCEX4=;
        h=From:To:Cc:Subject:Date;
        b=Gpw6agS0xR8MiOYQfIXLjNRyme0C+TDGSzgicBwsS8JnC3x5oUkxmVFCIWYbiV+yc
         BfqIW6VWEefCFMDBMZ8Bg2M/lSe3A/UbsAxGAloEiKLL2XBL3jjSDl9RJmSdhcu0CU
         y6aypR59NclPV7mYEM8eew/XCzHWiN38D0w/wMYw=
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 066C21B20B0D;
        Thu, 10 Oct 2019 17:43:34 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 066C21B20B0D
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 0CD121B2023E;
        Thu, 10 Oct 2019 17:43:33 +0300 (MSK)
Received: from localhost.localdomain (unknown [196.196.203.126])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Thu, 10 Oct 2019 17:43:32 +0300 (MSK)
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Edward Cree <ecree@solarflare.com>, Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Petr Machata <petrm@mellanox.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Lobakin <alobakin@dlink.ru>
Subject: [PATCH net-next 0/2] net: core: use listified Rx for GRO_NORMAL in napi_gro_receive()
Date:   Thu, 10 Oct 2019 17:42:24 +0300
Message-Id: <20191010144226.4115-1-alobakin@dlink.ru>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series was written as a continuation to commit 323ebb61e32b
("net: use listified RX for handling GRO_NORMAL skbs"), and also takes
an advantage of listified Rx for GRO. This time, however, we're
targeting at a way more common and used function, napi_gro_receive().

There are about ~100 call sites of this function, including gro_cells
and mac80211, so even wireless systems will benefit from it.
The only driver that cares about the return value is
ethernet/socionext/netsec, and only for updating statistics. I don't
believe that this change can break its functionality, but anyway,
we have plenty of time till next merge window to pay this change
a proper attention.

Besides having this functionality implemented for napi_gro_frags()
users, the main reason is the solid performance boost that has been
shown during tests on 1-core MIPS board (with not yet mainlined
driver):

* no batching (5.4-rc2): ~450/450 Mbit/s
* with gro_normal_batch == 8: ~480/480 Mbit/s
* with gro_normal_batch == 16: ~500/500 Mbit/s

Applies on top of net-next.
Thanks.

Alexander Lobakin (2):
  net: core: use listified Rx for GRO_NORMAL in napi_gro_receive()
  net: core: increase the default size of GRO_NORMAL skb lists to flush

 net/core/dev.c | 51 +++++++++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 25 deletions(-)

-- 
2.23.0

