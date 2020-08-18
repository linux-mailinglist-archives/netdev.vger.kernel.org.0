Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6AB5248037
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 10:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgHRIIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 04:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbgHRII3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 04:08:29 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101A4C061342
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 01:08:29 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1k7wfS-0067PR-69
        for netdev@vger.kernel.org; Tue, 18 Aug 2020 10:08:26 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Subject: [PATCH 0/3] netlink: allow NLA_BINARY length range validation
Date:   Tue, 18 Aug 2020 10:08:16 +0200
Message-Id: <20200818080819.10012-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In quite a few places (perhaps particularly in wireless) we need to
validation an NLA_BINARY attribute with both a minimum and a maximum
length. Currently, we can do either of the two, but not both, given
that we have NLA_MIN_LEN (minimum length) and NLA_BINARY (maximum).

Extend the range mechanisms that we use for integer validation to
apply to NLA_BINARY as well.

After converting everything to use NLA_POLICY_MIN_LEN() we can thus
get rid of the NLA_MIN_LEN type since that's now a special case of
NLA_BINARY with a minimum length validation. Similarly, NLA_EXACT_LEN
can be specified using NLA_POLICY_EXACT_LEN() and also maps to the
new NLA_BINARY validation (min == max == desired length).

Finally, NLA_POLICY_EXACT_LEN_WARN() also gets to be a somewhat
special case of this.

I haven't included the patch here now that converts nl82011 to use
this because it doesn't apply without another cleanup patch, but
we can remove a number of hand-coded min/max length checks and get
better error messages from the general validation code while doing
that.

As I had originally built the netlink policy export to userspace in
a way that has min/max length for NLA_BINARY (for the types that we
used to call NLA_MIN_LEN, NLA_BINARY and NLA_EXACT_LEN) anyway, it
doesn't really change anything there except that now there's a chance
that userspace sees min length < max length, which previously wasn't
possible.

johannes



