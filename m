Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C218267A0E1
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 19:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233407AbjAXSIS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 24 Jan 2023 13:08:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbjAXSIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 13:08:17 -0500
X-Greylist: delayed 599 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 24 Jan 2023 10:08:13 PST
Received: from mail.holtmann.org (coyote.holtmann.net [212.227.132.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 65B881286F
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 10:08:12 -0800 (PST)
Received: from smtpclient.apple (p4ff9f74d.dip0.t-ipconnect.de [79.249.247.77])
        by mail.holtmann.org (Postfix) with ESMTPSA id 9A8AECECD4;
        Tue, 24 Jan 2023 18:48:57 +0100 (CET)
From:   Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.2\))
Subject: Setting TLS_RX and TLS_TX crypto info more than once?
Message-Id: <A07B819E-A406-457A-B7DB-8926DCEBADCD@holtmann.org>
Date:   Tue, 24 Jan 2023 18:48:56 +0100
Cc:     netdev@vger.kernel.org
To:     Ilya Lesokhin <ilyal@mellanox.com>,
        Dave Watson <davejwatson@fb.com>
X-Mailer: Apple Mail (2.3696.120.41.1.2)
X-Spam-Status: No, score=-0.0 required=5.0 tests=BAYES_40,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ilya,

in commit 196c31b4b5447 you limited setsockopt for TLS_RX and TLS_TX
crypto info to just one time.

+       crypto_info = &ctx->crypto_send;
+       /* Currently we don't support set crypto info more than one time */
+       if (TLS_CRYPTO_INFO_READY(crypto_info))
+               goto out;

This is a bit unfortunate for TLS 1.3 where the majority of the TLS
handshake is actually encrypted with handshake traffic secrets and
only after a successful handshake, the application traffic secrets
are applied.

I am hitting this issue since I am just sending ClientHello and only
reading ServerHello and then switching on TLS_RX right away to receive
the rest of the handshake via TLS_GET_RECORD_TYPE. This works pretty
nicely in my code.

Since this limitation wasn’t there in the first place, can we get it
removed again and allow setting the crypto info more than once? At
least updating the key material (the cipher obviously has to match).

I think this is also needed when having to do any re-keying since I
have seen patches for that, but it seems they never got applied.

Any thoughts?

Regards

Marcel

