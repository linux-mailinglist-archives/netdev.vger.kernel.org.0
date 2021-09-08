Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8C1403C07
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 16:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351974AbhIHPAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 11:00:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:59212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351932AbhIHPAL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 11:00:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 831A661163;
        Wed,  8 Sep 2021 14:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631113142;
        bh=iER6cNpcjgk8n1TWkifigpXyj5UmGCift9D4uF2jMns=;
        h=From:To:Cc:Subject:Date:From;
        b=jEUUiYNesrwxixTuVWUx37ompZysIA5p0KCoiioN0f2BlrS+efomxgByiawC6Jjl8
         PfASkEjlfK7hzn3PNaz05R+fyf9GRreUV4a7BzTb9ouOrpuHon2nuQvF1WY/NNgHmC
         4t4sQQQX0l/0beJPHdHfx/wbrDWugLr74aLeNc3pPp2boRHSfLPcda06Vfzz/bPVkP
         STfQDLJpguHWxcT/MVZBintfsTiKoFKXdekzRbOzF+JA36vlO4oBOHqfVXsVVkX30W
         3j2HjgCY9z6S4nOOWu7yrTZmsviG4hwOnZf1Xez8C06XGSDDbZzBtD7v0995qNdA82
         mmKlHGuSQkIxQ==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1mNz2S-006r3a-E3; Wed, 08 Sep 2021 16:59:00 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Tony Luck <tony.luck@intel.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 0/9] get_abi.pl: Check for missing symbols at the ABI specs
Date:   Wed,  8 Sep 2021 16:58:47 +0200
Message-Id: <cover.1631112725.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

Sometime ago, I discussed with Jonathan Cameron about providing 
a way check that the ABI documentation is incomplete.

While it would be doable to validate the ABI by searching __ATTR and 
similar macros around the driver, this would probably be very complex
and would take a while to parse.

So, I ended by implementing a new feature at scripts/get_abi.pl
which does a check on the sysfs contents of a running system:
it reads everything under /sys and reads the entire ABI from
Documentation/ABI. It then warns for symbols that weren't found,
optionally showing possible candidates that might be misdefined.

I opted to place it on 3 patches:

The first patch adds the basic logic. It runs really quicky (up to 2
seconds), but it doesn't use sysfs softlinks.

Patch 2 adds support for also parsing softlinks. It slows the logic,
with now takes ~40 seconds to run on my desktop (and ~23
seconds on a HiKey970 ARM board). There are space there for
performance improvements, by using a more sophisticated
algorithm, at the expense of making the code harder to
understand. I ended opting to use a simple implementation
for now, as ~40 seconds sounds acceptable on my eyes.

Patch 3 adds an optional parameter to allow filtering the results
using a regex given by the user.

One of the problems with the current ABI definitions is that several
symbols define wildcards, on non-standard ways. The more commonly
wildcards used there are:

	<foo>
	{foo}
	[foo]
	X
	Y
	Z
	/.../

The script converts the above wildcards into (somewhat relaxed)
regexes.

There's one place using  "(some description)". This one is harder to
parse, as parenthesis are used by the parsing regexes. As this happens
only on one file, patch 4 addresses such case.

Patch 5 to 9 fix some other ABI troubles I identified.

In long term, perhaps the better would be to just use regex on What:
fields, as this would avoid extra heuristics at get_abi.pl, but this is
OOT from this patch, and would mean a large number of changes.

-

As reference, I sent an early implementation of this change as a RFC:
	https://lore.kernel.org/lkml/cover.1624014140.git.mchehab+huawei@kernel.org/

Mauro Carvalho Chehab (9):
  scripts: get_abi.pl: Check for missing symbols at the ABI specs
  scripts: get_abi.pl: detect softlinks
  scripts: get_abi.pl: add an option to filter undefined results
  ABI: sysfs-bus-usb: better document variable argument
  ABI: sysfs-module: better document module name parameter
  ABI: sysfs-tty: better document module name parameter
  ABI: sysfs-kernel-slab: use a wildcard for the cache name
  ABI: security: fix location for evm and ima_policy
  ABI: sysfs-module: document initstate

 Documentation/ABI/stable/sysfs-module       |  10 +-
 Documentation/ABI/testing/evm               |   4 +-
 Documentation/ABI/testing/ima_policy        |   2 +-
 Documentation/ABI/testing/sysfs-bus-usb     |  16 +-
 Documentation/ABI/testing/sysfs-kernel-slab |  94 ++++-----
 Documentation/ABI/testing/sysfs-module      |   7 +
 Documentation/ABI/testing/sysfs-tty         |  32 +--
 scripts/get_abi.pl                          | 218 +++++++++++++++++++-
 8 files changed, 303 insertions(+), 80 deletions(-)

-- 
2.31.1


