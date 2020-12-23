Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E62D2E206C
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 19:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728151AbgLWS1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 13:27:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726923AbgLWS1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 13:27:44 -0500
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B852C061257
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 10:26:45 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4D1M962F3YzQlKq;
        Wed, 23 Dec 2020 19:26:18 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1608747976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=68AaHC38DS9Upylni2zj/H/1wNKyAcR0Mugc/+a2K/g=;
        b=UdM6TTYDjMArgyngkca3gUsXSHNU+cMMn+0kmscIT8/qH4A70IDJB0AnlqWucNKLdl+dVK
        a8pWW6wYY0lbhFVr4PwEQb4uFyupX8YTS/kdlFMYjDrtyWMpg4AtVNcaiOosmCh+wFMk0P
        Zci6S741PDU89eVh9u+SqSp6MNJ/dPijqFvLsqCrcQOMrsXO7d8YQ+KNP8gKrOY7+ZOa8O
        51DOJAjhyDU7R5smR3vFZkK82c21/pSKw4JcMo3yuB0RidMsT1iZBBqn3zeJV3OBd8WejJ
        xIc0VXAVYz1bsauBft+mdfHzL+Bl9OTCROlXQaZF4jVBImU7PWX5m2bOuV3tnw==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id S9KyEFftNpr2; Wed, 23 Dec 2020 19:26:14 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 0/9] dcb: Support APP, DCBX objects
Date:   Wed, 23 Dec 2020 19:25:38 +0100
Message-Id: <cover.1608746691.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 1.48 / 15.00 / 15.00
X-Rspamd-Queue-Id: 7379E172A
X-Rspamd-UID: 9212d9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to the dcb tool for the following two DCB objects:

- APP, which allows configuration of traffic prioritization rules based on
  several possible packet headers.

- DCBX, which is a 1-byte bitfield of flags that configure whether the DCBX
  protocol is implemented in the device or in the host, and which version
  of the protocol should be used.

Patches #1 and #2 fix issues in the current DCB code.

Patch #3 adds a new helper for finding a name of a given dsfield value.
This is useful for APP DSCP-to-priority rules, which can use human-readable
DSCP names.

Patches #4, #5 and #6 extend existing interfaces for, respectively, parsing
of the X:Y mappings, for setting a DCB object, and for getting a DCB
object.

In patch #7, support for the command line argument -n / --no-nice-names is
added. The APP tool later uses it to decide whether to format DSCP values
as human-readable strings or as plain numbers.

Patches #8 and #9 add the subtools themselves and their man pages.

Petr Machata (9):
  dcb: Set values with RTM_SETDCB type
  dcb: Plug a leaking DCB socket buffer
  lib: rt_names: Add rtnl_dsfield_get_name()
  lib: Generalize parse_mapping()
  dcb: Generalize dcb_set_attribute()
  dcb: Generalize dcb_get_attribute()
  dcb: Support -n to suppress translation to nice names
  dcb: Add a subtool for the DCB APP object
  dcb: Add a subtool for the DCBX object

 dcb/Makefile        |   8 +-
 dcb/dcb.c           | 194 +++++++++--
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
 12 files changed, 1592 insertions(+), 38 deletions(-)
 create mode 100644 dcb/dcb_app.c
 create mode 100644 dcb/dcb_dcbx.c
 create mode 100644 man/man8/dcb-app.8
 create mode 100644 man/man8/dcb-dcbx.8

-- 
2.25.1

