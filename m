Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8D62E85F2
	for <lists+netdev@lfdr.de>; Sat,  2 Jan 2021 01:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbhABAEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jan 2021 19:04:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726991AbhABAEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jan 2021 19:04:52 -0500
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B82C061573
        for <netdev@vger.kernel.org>; Fri,  1 Jan 2021 16:04:11 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4D72Dn34KLzQjkp;
        Sat,  2 Jan 2021 01:04:09 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1609545847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SpTMGK7sXdnm6mVy68zQ4xX5xYn2SUH/oewZ8M1QtlI=;
        b=SqUdhAiV9gVXmAERXT+DA/EJgy8hIGZ0fY2ztCp206GYUdGFvxz6FhTs1yNYMgef8SQBVa
        QRoKOKD4SYTt7Jo4VrkKVkxkK2begAvaS7HcVPzXuixUgp7bHKYJhEzAFrcT/RUQUPAzz/
        C/WamQncYpSpSnyZ+pj1z/ivFsnzsGbHUBE3sFPbDBjfILDlYUPgPYRpbBbsthsVhHVDjg
        9/v5fcbmhTk+S/bg5Ubrn72a8YfOp4OzWCVv4OD2piknROr/EyU7pJsr27uPWTgRTXaupo
        VZO4HRjrPkJNXfSDPokWd0/nHTtbVhOUEkESFwUgnZoIsjzFkdi2Q7GbPn78jg==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id Zf2yM8vJnttB; Sat,  2 Jan 2021 01:04:06 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next v2 0/7] dcb: Support APP, DCBX objects
Date:   Sat,  2 Jan 2021 01:03:34 +0100
Message-Id: <cover.1609544200.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 1.98 / 15.00 / 15.00
X-Rspamd-Queue-Id: 6E3401718
X-Rspamd-UID: cf5692
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to the dcb tool for the following two DCB objects:

- APP, which allows configuration of traffic prioritization rules based on
  several possible packet headers.

- DCBX, which is a 1-byte bitfield of flags that configure whether the DCBX
  protocol is implemented in the device or in the host, and which version
  of the protocol should be used.

Patch #1 adds a new helper for finding a name of a given dsfield value.
This is useful for APP DSCP-to-priority rules, which can use human-readable
DSCP names.

Patches #2, #3 and #4 extend existing interfaces for, respectively, parsing
of the X:Y mappings, for setting a DCB object, and for getting a DCB
object.

In patch #5, support for the command line argument -N / --Numeric is
added. The APP tool later uses it to decide whether to format DSCP values
as human-readable strings or as plain numbers.

Patches #6 and #7 add the subtools themselves and their man pages.

v2:
- Two patches dropped and sent to iproute2 branch as "dcb: Fixes".
  This patch set now depends on that one.
- Patch #5:
    - Make it -N / --Numeric instead of -n / --no-nice-names
    - Rename the flag from no_nice_names to numeric as well
- Patch #6:
    - Adjust to s/no_nice_names/numeric/ from another patch.

Petr Machata (7):
  lib: rt_names: Add rtnl_dsfield_get_name()
  lib: Generalize parse_mapping()
  dcb: Generalize dcb_set_attribute()
  dcb: Generalize dcb_get_attribute()
  dcb: Support -N to suppress translation to human-readable names
  dcb: Add a subtool for the DCB APP object
  dcb: Add a subtool for the DCBX object

 dcb/Makefile        |   8 +-
 dcb/dcb.c           | 193 +++++++++--
 dcb/dcb.h           |  20 ++
 dcb/dcb_app.c       | 796 ++++++++++++++++++++++++++++++++++++++++++++
 dcb/dcb_dcbx.c      | 192 +++++++++++
 include/rt_names.h  |   1 +
 include/utils.h     |   5 +
 lib/rt_names.c      |  20 +-
 lib/utils.c         |  37 +-
 man/man8/dcb-app.8  | 237 +++++++++++++
 man/man8/dcb-dcbx.8 | 108 ++++++
 man/man8/dcb.8      |  12 +-
 12 files changed, 1591 insertions(+), 38 deletions(-)
 create mode 100644 dcb/dcb_app.c
 create mode 100644 dcb/dcb_dcbx.c
 create mode 100644 man/man8/dcb-app.8
 create mode 100644 man/man8/dcb-dcbx.8

-- 
2.26.2

