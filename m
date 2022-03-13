Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3407A4D7438
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 11:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbiCMKY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 06:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiCMKYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 06:24:22 -0400
Received: from eidolon.nox.tf (eidolon.nox.tf [IPv6:2a07:2ec0:2185::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C79286E5
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 03:23:14 -0700 (PDT)
Received: from [178.197.200.96] (helo=areia)
        by eidolon.nox.tf with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <equinox@diac24.net>)
        id 1nTLI7-003JVp-2z
        for netdev@vger.kernel.org; Sun, 13 Mar 2022 11:17:35 +0100
Received: from equinox by areia with local (Exim 4.95)
        (envelope-from <equinox@diac24.net>)
        id 1nTL1j-001aBF-7o
        for netdev@vger.kernel.org;
        Sun, 13 Mar 2022 11:00:39 +0100
From:   David Lamparter <equinox@diac24.net>
To:     netdev@vger.kernel.org
Subject: [RFC] net/packet: fix visible delays due to RCU sync
Date:   Sun, 13 Mar 2022 11:00:31 +0100
Message-Id: <20220313100033.343442-1-equinox@diac24.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,


while working with test setups that include a few hundred network
interfaces (not that unrealistic...), I ran into wireshark/dumpcap being
oddly slow to start up and decided to investigate.  Turns out it's
accumulating RCU delays (15ms, twice for each interface) - thise quickly
sum up.

Since synchronize_net() already does an expedited sync if RTNL is held,
I went and added a synchronize_net_expedited() for cases like this where
we have some other reason to want expedited sync.

Hope this is acceptable,


-David


