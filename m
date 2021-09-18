Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424B34105B2
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 11:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244155AbhIRJxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 05:53:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243499AbhIRJxq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Sep 2021 05:53:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B3F36127C;
        Sat, 18 Sep 2021 09:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631958742;
        bh=chE0EwEyFLVgeK91ZaRsMFr0q3GXSbTjQji/CWReA4o=;
        h=From:To:Cc:Subject:Date:From;
        b=F7LsHblk8kibVjke9F4qRsRbuXdKGZhsooGevq7y51p9Dd89TQIU6DVX99TH4ODWS
         EADfQA9+wiUv22xq472rz/3A0hKodUSVPaheglwLjxUu+YhLXck1WhlOGW/iLYlXoX
         BZpB+we+smu1ddXVArP0DkOXMOpskmSpFD/4TxhxSJ99BNU6NaKEsTbTuUe3Jbpkc3
         hX+ir9h6F8WbEucTkj4R1vtRrO+lEQfoEzQYJDMu4jOJDIZDuCSlmcg5sm7qdjEuco
         U0IA2dfb69JX+H4CpegbS4cjnKMoA9SJC616s5MKd7OrwUoVKyfQPsStX1qJa3gifE
         F7Tzz5XawncBA==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1mRX1A-003b0n-FQ; Sat, 18 Sep 2021 11:52:20 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
Subject: [PATCH v3 0/7] get_abi.pl: Check for missing symbols at the ABI  specs
Date:   Sat, 18 Sep 2021 11:52:10 +0200
Message-Id: <cover.1631957565.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

Add a new feature at get_abi.pl to optionally check for existing symbols
under /sys that won't match a "What:" inside Documentation/ABI.

Such feature is very useful to detect missing documentation for ABI.

This series brings a major speedup, plus it fixes a few border cases when
matching regexes that end with a ".*" or \d+.

patch 1 changes get_abi.pl logic to handle multiple What: lines, in
order to make the script more robust;

patch 2 adds the basic logic. It runs really quicky (up to 2
seconds), but it doesn't use sysfs softlinks.

Patch 3 adds support for parsing softlinks. It makes the script a
lot slower, making it take a couple of minutes to process the entire
sysfs files. It could be optimized in the future by using a graph,
but, for now, let's keep it simple.

Patch 4 adds an optional parameter to allow filtering the results
using a regex given by the user. When this parameter is used
(which should be the normal usecase), it will only try to find softlinks
if the sysfs node matches a regex.

Patch 5 improves the report by avoiding it to ignore What: that
ends with a wildcard.

Patch 6 is a minor speedup.  On a Dell Precision 5820, after patch 6, 
results are:

	$ time ./scripts/get_abi.pl undefined |sort >undefined && cat undefined| perl -ne 'print "$1\n" if (m#.*/(\S+) not found#)'|sort|uniq -c|sort -nr >undefined_symbols; wc -l undefined; wc -l undefined_symbols

	real	2m35.563s
	user	2m34.346s
	sys	0m1.220s
	7595 undefined
	896 undefined_symbols

Patch 7 makes a *huge* speedup: it basically switches a linear O(n^3)
search for links by a logic which handle symlinks using BFS. It
also addresses a border case that was making 'msi-irqs/\d+' regex to
be misparsed. 

After patch 7, it is 11 times faster:

	$ time ./scripts/get_abi.pl undefined |sort >undefined && cat undefined| perl -ne 'print "$1\n" if (m#.*/(\S+) not found#)'|sort|uniq -c|sort -nr >undefined_symbols; wc -l undefined; wc -l undefined_symbols

	real	0m14.137s
	user	0m12.795s
	sys	0m1.348s
	7030 undefined
	794 undefined_symbols

(the difference on the number of undefined symbols are due to the fix for
it to properly handle 'msi-irqs/\d+' regex)

-

While this series is independent from Documentation/ABI changes, it
works best when applied from this tree, which also contain ABI fixes
and a couple of additions of frequent missed symbols on my machine:

    https://git.kernel.org/pub/scm/linux/kernel/git/mchehab/devel.git/log/?h=get_undefined_abi_v3

-

v3:
  - Fixed parse issues with 'msi-irqs/\d+' regex;
  - Added a BFS graph logic to solve symlinks at sysfs;

v2:
  - multiple What: for the same description are now properly handled;
  - some special cases are now better handled;
  - some bugs got fixed.

The full series, with the ABI changes and some ABI improvements can be found
at:
	https://git.kernel.org/pub/scm/linux/kernel/git/mchehab/devel.git/commit/?h=get_undefined&id=1838d8fb149170f6c19feda0645d6c3157f46f4f



Mauro Carvalho Chehab (7):
  scripts: get_abi.pl: Better handle multiple What parameters
  scripts: get_abi.pl: Check for missing symbols at the ABI specs
  scripts: get_abi.pl: detect softlinks
  scripts: get_abi.pl: add an option to filter undefined results
  scripts: get_abi.pl: don't skip what that ends with wildcards
  scripts: get_abi.pl: Ignore fs/cgroup sysfs nodes earlier
  scripts: get_abi.pl: add a graph to speedup the undefined algorithm

 scripts/get_abi.pl | 327 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 320 insertions(+), 7 deletions(-)

-- 
2.31.1


