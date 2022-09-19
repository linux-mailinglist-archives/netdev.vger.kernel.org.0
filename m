Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E57B5BD71F
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 00:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbiISWTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 18:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiISWTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 18:19:05 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0A64DF25
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 15:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9NWU5Q2F1qmJNEsm8D2RCbWNoIPaGXGy1mJIR//mH0A=; b=esAJshukMVqSC61TrGMfvdQJZv
        eFlziB2so0h6ShKO7lCGGrI36wcVT5TgXB/kkFYGTc2IkbQfZxSr6ksFOipbFfi0oxEuIh/y9HDd+
        TJsqiSXw0RuqOsLrP+ltAixfTz5XzUj+dUVJQWpfAan58X+hNJIh1FGdd5IKDoYFzJhQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oaP6Q-00HBR4-ST; Tue, 20 Sep 2022 00:18:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     mattias.forsblad@gmail.com
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH rfc v0 0/9] DSA: Move parts of inband signalling into the DSA
Date:   Tue, 20 Sep 2022 00:18:44 +0200
Message-Id: <20220919221853.4095491-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220919110847.744712-3-mattias.forsblad@gmail.com>
References: <20220919110847.744712-3-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an RFC patchset.

Mattias Forsblad proposal for adding some core helpers to DSA for
inband signalling is going in a good direction, but there are a couple
of things which i think can be better. This patchset offs an
alternative to

patch 2/7: net: dsa: Add convenience functions for frame handling

and

patch 7/7 net: dsa: qca8k: Use new convenience functions

This patchset takes the abstraction further, putting more into the
core. It also makes the qca8k fully use the abstraction unlike 7/7.

The end result has a slightly different structure, in that there is a
struct dsa_inband of which qca8k has two instances of this. Doing this
avoids the custom completion code. If qca8k can have multiple parallel
request/replies in flight, it seems likely other devices can as well,
so this should be part of the abstraction.

Since i don't have the qck8 hardware, i hope that lots of small
patches make the review work easier, and finding the introduced bugs
is quicker.

The MIB handling of the qc8k is somewhat odd. It would be nice to work
on that further and try to make it better fit the model used
here. That work can be done later, and probably is more invasive than
the step by step approach taken here.

Another aim has been to make it easy to merge Mattias mv88e6xxx
patches with this patchset. The basic API is the same, so i think it
should be possible.

These are compile tested only....

Andrew Lunn (9):
  net: dsa: qca8k: Fix inconsistent use of jiffies vs milliseconds
  net: dsa: qca8k: Move completion into DSA core
  net: dsa: qca8K: Move queuing for request frame into the core
  net: dsa: qca8k: dsa_inband_request: More normal return values
  net: dsa: qca8k: Move request sequence number handling into core
  net: dsa: qca8k: Refactor sequence number mismatch to use error code
  net: dsa: qca8k: Pass error code from reply decoder to requester
  net: dsa: qca8k: Pass response buffer via dsa_rmu_request
  net: dsa: qca8k: Move inband mutex into DSA core

 drivers/net/dsa/qca/qca8k-8xxx.c | 234 ++++++++-----------------------
 drivers/net/dsa/qca/qca8k.h      |   8 +-
 include/net/dsa.h                |  25 ++++
 net/dsa/dsa.c                    |  90 ++++++++++++
 4 files changed, 172 insertions(+), 185 deletions(-)

-- 
2.37.2

