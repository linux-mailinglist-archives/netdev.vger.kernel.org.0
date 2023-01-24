Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9A97678DD1
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 03:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbjAXCBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 21:01:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbjAXCBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 21:01:30 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724BFCDDF
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 18:01:29 -0800 (PST)
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 4A7822009E; Tue, 24 Jan 2023 10:01:24 +0800 (AWST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=codeconstruct.com.au; s=2022a; t=1674525684;
        bh=FsRhM+94+GVGrmBt/tRDhZz/PKn3DT52b+3lznD/QE0=;
        h=From:To:Cc:Subject:Date;
        b=hNUj8fdmdeL6TSC2vOSpHxaJYWU40WZlHJl7JaAThJh7OFLnBbJWNIVd9q7VTSLaA
         IPrWdZGZM33mlJOEApnXP9EjbkmQ2wSDKqhWDbgCzV+Cc6VylfJ+q4TpewjZm8E1ah
         2ljWf/N0rIwBj4ZMVcasU22OBbgJkxssae4MO7BGTQLCmHeemviaeGoPbio/juMpeF
         ZQCCPXt0UtvpTkGlbI3V74TMltQZiDyAA2T/LisiojSFUDW6H/1++nY0LSnytGpu/7
         cTdRXeVXWoMXx766sXbK1vpjjEzdY0Udhj9YpHmOU8H1nEEUxxvWUtEMPDGxnGL32Z
         +tl6QjwUgJeVg==
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Noam Rathaus <noamr@ssd-disclosure.com>
Subject: [PATCH net 0/4] net: mctp: struct sock lifetime fixes
Date:   Tue, 24 Jan 2023 10:01:02 +0800
Message-Id: <20230124020106.743966-1-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.35.1
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

This series is a set of fixes for the sock lifetime handling in the
AF_MCTP code, fixing a uaf reported by Noam Rathaus
<noamr@ssd-disclosure.com>.

The Fixes: tags indicate the original patches affected, but some
tweaking to backport to those commits may be needed; I have a separate
branch with backports to 5.15 if that helps with stable trees.

Of course, any comments/queries most welcome.

Cheers,


Jeremy

---


Jeremy Kerr (3):
  net: mctp: add an explicit reference from a mctp_sk_key to sock
  net: mctp: move expiry timer delete to unhash
  net: mctp: mark socks as dead on unhash, prevent re-add

Paolo Abeni (1):
  net: mctp: hold key reference when looking up a general key

 net/mctp/af_mctp.c | 10 +++++++---
 net/mctp/route.c   | 34 +++++++++++++++++++++-------------
 2 files changed, 28 insertions(+), 16 deletions(-)

-- 
2.35.1

