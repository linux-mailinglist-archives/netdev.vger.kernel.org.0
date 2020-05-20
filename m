Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250E21DADC3
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 10:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgETImO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 04:42:14 -0400
Received: from novek.ru ([213.148.174.62]:52230 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgETImO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 04:42:14 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 57406502966;
        Wed, 20 May 2020 11:42:07 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 57406502966
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1589964128; bh=2/oNs8TAXKSyNGJyrxFLSmElImQRQZafwaN5V/fGbEY=;
        h=From:To:Cc:Subject:Date:From;
        b=RLUSVZHdvkpY0wg+c7J+s10rKyfywlqwGdH+P+5b8/rRf7L/MeYBOr6M1agWT1aM/
         KkIx5COxGooQDQZaPR9AZFCyUTx1onUeUNJTXr6rYmfbDvw1VE4fILruVxjnCzHuHu
         1r0EPWivdtP5toJ/7Wz1GvtmNJJY2kwIHNXy3kxI=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [net v3 0/2] net/tls: fix encryption error path
Date:   Wed, 20 May 2020 11:41:42 +0300
Message-Id: <1589964104-9941-1-git-send-email-vfedorenko@novek.ru>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The problem with data stream corruption was found in KTLS
transmit path with small socket send buffers and large 
amount of data. bpf_exec_tx_verdict() frees open record
on any type of error including EAGAIN, ENOMEM and ENOSPC
while callers are able to recover this transient errors.
Also wrong error code was returned to user space in that
case. This patchset fixes the problems.

Vadim Fedorenko (2):
  net/tls: fix encryption error checking
  net/tls: free record only on encryption error

 net/tls/tls_sw.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

-- 
1.8.3.1

