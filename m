Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38DA228229C
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 10:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725833AbgJCIpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 04:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbgJCIoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 04:44:55 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFFF0C0613E9
        for <netdev@vger.kernel.org>; Sat,  3 Oct 2020 01:44:54 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kOd9v-00FmcE-QC; Sat, 03 Oct 2020 10:44:51 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH v3 0/5] genetlink per-op policy export
Date:   Sat,  3 Oct 2020 10:44:41 +0200
Message-Id: <20201003084446.59042-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Here's a respin, now including Jakub's patch last so that it will
do the right thing from the start.

The first patch remains the same, of course; the others have mostly
some rebasing going on, except for the actual export patch (patch 4)
which is adjusted per Jakub's review comments about exporting the
policy only if it's actually used for do/dump.

To see that, the dump for "nlctrl" (i.e. the generic netlink control)
is instructive, because the ops are this:

        {
                .cmd            = CTRL_CMD_GETFAMILY,
                .validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
                .policy         = ctrl_policy_family,
                .maxattr        = ARRAY_SIZE(ctrl_policy_family) - 1,
                .doit           = ctrl_getfamily,
                .dumpit         = ctrl_dumpfamily,
        },
        {
                .cmd            = CTRL_CMD_GETPOLICY,
                .policy         = ctrl_policy_policy,
                .maxattr        = ARRAY_SIZE(ctrl_policy_policy) - 1,
                .start          = ctrl_dumppolicy_start,
                .dumpit         = ctrl_dumppolicy,
                .done           = ctrl_dumppolicy_done,
        },

So we exercise both "don't have doit" and "GENL_DONT_VALIDATE_DUMP"
parts, and get (with the current genl patch):

$ genl ctrl policy name nlctrl
	ID: 0x10  op 3 policies: do=0
	ID: 0x10  op 10 policies: dump=1
	ID: 0x10  policy[0]:attr[1]: type=U16 range:[0,65535]
	ID: 0x10  policy[0]:attr[2]: type=NUL_STRING max len:15
	ID: 0x10  policy[1]:attr[1]: type=U16 range:[0,65535]
	ID: 0x10  policy[1]:attr[2]: type=NUL_STRING max len:15
	ID: 0x10  policy[1]:attr[10]: type=U32 range:[0,4294967295]

johannes


