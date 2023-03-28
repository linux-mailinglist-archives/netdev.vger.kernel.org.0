Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB686CB463
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 04:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjC1C5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 22:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjC1C5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 22:57:05 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7801FFB
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 19:57:03 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pgzW5-009Nn1-A6; Tue, 28 Mar 2023 10:56:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Mar 2023 10:56:57 +0800
Date:   Tue, 28 Mar 2023 10:56:57 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     netdev@vger.kernel.org
Subject: [PATCH 0/2] macvlan: Allow some packets to bypass broadcast queue
Message-ID: <ZCJXefIhSrd7Hm2Z@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=4.3 required=5.0 tests=HELO_DYNAMIC_IPADDR2,
        PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series allows some packets to bypass the broadcast
queue on receive.  Currently all multicast packets are queued
on receive and then processed in a work queue.  This is to avoid
an unbounded amount of work occurring in the receive path, as
one broadcast packet could easily translate into 4,000 packets.

However, for multicast packets with just one receiver (possible
for IPv6 ND), this introduces unnecessary latency as the packet
will go to exactly one device.

This series allows such multicast packets to be processed inline.
It also adds a toggle which lets the admin control what threshold
to set between queueing and not queueing.  A follow-up patch for
iproute will be posted.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
