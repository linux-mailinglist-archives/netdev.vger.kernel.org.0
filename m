Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED456286774
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 20:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgJGShg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 14:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbgJGShf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 14:37:35 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CADA8C061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 11:37:35 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kQEJg-0017ki-BP; Wed, 07 Oct 2020 20:37:32 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v3 0/2] netlink: export policy on validation failures
Date:   Wed,  7 Oct 2020 20:37:22 +0200
Message-Id: <20201007183724.246725-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export the policy used for attribute validation when it fails,
so e.g. for an out-of-range attribute userspace immediately gets
the valid ranges back.

v2 incorporates the suggestion from Jakub to have a function to
estimate the size (netlink_policy_dump_attr_size_estimate()) and
check that it does the right thing on the *normal* policy dumps,
not (just) when calling it from the error scenario.

v3 only addresses a few minor style issues.


Tested using nl80211/iw in a few scenarios, seems to work fine
and return the policy back, e.g.

kernel reports: integer out of range
policy: 04 00 0b 00 0c 00 04 00 01 00 00 00 00 00 00 00 
        ^ padding
                    ^ minimum allowed value
policy: 04 00 0b 00 0c 00 05 00 ff ff ff ff 00 00 00 00 
        ^ padding
                    ^ maximum allowed value
policy: 08 00 01 00 04 00 00 00 
        ^ type 4 == U32

for an out-of-range case.

johannes


