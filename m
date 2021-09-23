Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6C2415FCF
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 15:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241339AbhIWNbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 09:31:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231974AbhIWNbq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 09:31:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAC8B61164;
        Thu, 23 Sep 2021 13:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632403814;
        bh=3hgRBay+GDZAkBnCzYWJ3psWTN3A28hgXY6M7EBS+vc=;
        h=From:To:Cc:Subject:Date:From;
        b=r1Tuli7EuAb9+mP4qApjAk8+ld3C9TDOEpc1BzTyLj4dOizTbhFjdiUkfR85O2kFA
         NNST9quGmmgmXu7LOLEyicPaWrXVbUAm9XewSLcbVncJIXijs/v35kKK5wnSrLlW4R
         CrctqxvU2TFt1401HFRtUMknWNxSmwMwsvmsyATUCtuGkbjeRJTfeJGzmUM86qjmLx
         64sLI7uirj3e0/simdP/0JuVdedMPSkDDkrY2s6MVM7EmkKqcvK5ZuqX1TH2Udky0l
         wJxlaTUCBQ8skeYJBiLjTVgltqRU0dv0SwKlgvRwAM2LXptU/Ol4XJAVP5qjFVkiyO
         lKBKeK//jo9EQ==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1mTOnk-000ndj-Ln; Thu, 23 Sep 2021 15:30:12 +0200
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
Subject: [PATCH 00/13] get_abi.pl undefined: improve precision and performance
Date:   Thu, 23 Sep 2021 15:29:58 +0200
Message-Id: <cover.1632402570.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

It follows a series of improvements for get_abi.pl. it is on the top of next-20210923.

With such changes, on my development tree, the script is taking 6 seconds to run 
on my desktop:

	$ !1076
	$ time ./scripts/get_abi.pl undefined |sort >undefined_after && cat undefined_after| perl -ne 'print "$1\n" if (m#.*/(\S+) not found#)'|sort|uniq -c|sort -nr >undefined_symbols; wc -l undefined_after undefined_symbols

	real	0m6,292s
	user	0m5,640s
	sys	0m0,634s
	  6838 undefined_after
	   808 undefined_symbols
	  7646 total

And 7 seconds on a Dell Precision 5820:

	$ time ./scripts/get_abi.pl undefined |sort >undefined && cat undefined| perl -ne 'print "$1\n" if (m#.*/(\S+) not found#)'|sort|uniq -c|sort -nr >undefined_symbols; wc -l undefined; wc -l undefined_symbols

	real	0m7.162s
	user	0m5.836s
	sys	0m1.329s
	6548 undefined
	772 undefined_symbols

Both tests were done against this tree (based on today's linux-next):

	$ https://git.kernel.org/pub/scm/linux/kernel/git/mchehab/devel.git/log/?h=get_abi_undefined-latest

It should be noticed that, as my tree has several ABI fixes,  the time to run the
script is likely less than if you run on your tree, as there will be less symbols to
be reported, and the algorithm is optimized to reduce the number of regexes
when a symbol is found.

Besides optimizing and improving the seek logic, this series also change the
debug logic. It how receives a bitmap, where "8" means to print the regexes
that will be used by "undefined" command:

	$ time ./scripts/get_abi.pl undefined --debug 8 >foo
	real	0m17,189s
	user	0m13,940s
	sys	0m2,404s

	$wc -l foo
	18421939 foo

	$ cat foo
	...
	/sys/kernel/kexec_crash_loaded =~ /^(?^:^/sys/.*/iio\:device.*/in_voltage.*_scale_available$)$/
	/sys/kernel/kexec_crash_loaded =~ /^(?^:^/sys/.*/iio\:device.*/out_voltage.*_scale_available$)$/
	/sys/kernel/kexec_crash_loaded =~ /^(?^:^/sys/.*/iio\:device.*/out_altvoltage.*_scale_available$)$/
	/sys/kernel/kexec_crash_loaded =~ /^(?^:^/sys/.*/iio\:device.*/in_pressure.*_scale_available$)$/
	...

On other words, on my desktop, the /sys match is performing >18M regular 
expression searches, which takes 6,2 seconds (or 17,2 seconds, if debug is 
enabled and sent to an area on my nvme storage).

Regards,
Mauro

---

Mauro Carvalho Chehab (13):
  scripts: get_abi.pl: Better handle multiple What parameters
  scripts: get_abi.pl: Check for missing symbols at the ABI specs
  scripts: get_abi.pl: detect softlinks
  scripts: get_abi.pl: add an option to filter undefined results
  scripts: get_abi.pl: don't skip what that ends with wildcards
  scripts: get_abi.pl: Ignore fs/cgroup sysfs nodes earlier
  scripts: get_abi.pl: add a graph to speedup the undefined algorithm
  scripts: get_abi.pl: improve debug logic
  scripts: get_abi.pl: Better handle leaves with wildcards
  scripts: get_abi.pl: ignore some sysfs nodes earlier
  scripts: get_abi.pl: stop check loop earlier when regex is found
  scripts: get_abi.pl: precompile what match regexes
  scripts: get_abi.pl: ensure that "others" regex will be parsed

 scripts/get_abi.pl | 388 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 372 insertions(+), 16 deletions(-)

-- 
2.31.1


