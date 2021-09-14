Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310C640B1DC
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 16:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234315AbhINOrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 10:47:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:40238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234717AbhINOrV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 10:47:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41308610F9;
        Tue, 14 Sep 2021 14:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631630763;
        bh=oM1TtWAjabDkiMw1w01I1Lf0mlPagSUVskiqnyRZEMM=;
        h=From:To:Cc:Subject:Date:From;
        b=FXLsFmCsYaZzUEFDCp+afoqQRUTV+EmxW4mvJHtIKONMxRohAmvOreC2W8q9lCXtS
         Af7NcBatGOI2nGqM42Mwf6D0E+q2b0RXMMgcoXsn/oKlybE/vmYMz6CI5CvWzPpswn
         Ulj9ECPWCnW3UyaEE/1IveiQYO04f6uOmTMGTiK1TBo3tB0P8dvMDTAPtJXuwaPZgi
         dehIoIsjUSLPjxLHRdaVPYLPRzGFOBDaYF/Yzak4SIp9tVd+xoBQpjtBcyFBLeWlfW
         jJjsVSqeKdBJwye35nfKILg2Qw9ZfF4HTb0PpKZ2fUTBHVifkstoKJbpe7U97F+fQs
         eeIdlCB+4zmsQ==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1mQ9hB-000Kz3-9K; Tue, 14 Sep 2021 16:46:01 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
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
Subject: [PATCH v2 0/5] get_abi.pl: Check for missing symbols at the ABI  specs
Date:   Tue, 14 Sep 2021 16:45:53 +0200
Message-Id: <cover.1631629987.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

That's the second version of the logic added at get_abi.pl meant to
validate ABI definitions.

While it would be doable to validate the ABI by searching __ATTR and
similar macros around the driver, this would probably be very complex
and would take a while to parse.

Instead, let's add a new feature at scripts/get_abi.pl which does
check the real ABI found at the sysfs contents of a running system
with Documentation/ABI.

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

While this series is independent, if you wanna test, I recommend to
apply first this series:

	https://lore.kernel.org/lkml/cover.1631629496.git.mchehab+huawei@kernel.org/T/#t

As it fix some bad What: descriptions, and some wildcard ambiquities.

-

v2:
  - multiple What: for the same description are now properly handled;
  - some special cases are now better handled;
  - some bugs got fixed.

The full series, with the ABI changes and some ABI improvements can be found
at:
	https://git.kernel.org/pub/scm/linux/kernel/git/mchehab/devel.git/commit/?h=get_undefined&id=1838d8fb149170f6c19feda0645d6c3157f46f4f

Mauro Carvalho Chehab (5):
  scripts: get_abi.pl: Better handle multiple What parameters
  scripts: get_abi.pl: Check for missing symbols at the ABI specs
  scripts: get_abi.pl: detect softlinks
  scripts: get_abi.pl: add an option to filter undefined results
  scripts: get_abi.pl: don't skip what that ends with wildcards

 scripts/get_abi.pl | 258 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 252 insertions(+), 6 deletions(-)

-- 
2.31.1


