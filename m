Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9553F17B056
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 22:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgCEVOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 16:14:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:45344 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbgCEVOd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 16:14:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CD8B1AC26;
        Thu,  5 Mar 2020 21:14:28 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 78152E037F; Thu,  5 Mar 2020 22:14:28 +0100 (CET)
Date:   Thu, 5 Mar 2020 22:14:28 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     "John W. Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH ethtool v2 00/25] initial netlink interface
 implementation for 5.6 release
Message-ID: <20200305211428.GE28693@unicorn.suse.cz>
References: <cover.1583347351.git.mkubecek@suse.cz>
 <20200305192416.GA23804@tuxdriver.com>
 <20200305203259.GD28693@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200305203259.GD28693@unicorn.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 05, 2020 at 09:32:59PM +0100, Michal Kubecek wrote:
> On Thu, Mar 05, 2020 at 02:24:16PM -0500, John W. Linville wrote:
> > 
> > Just a quick check -- executing "./autogen.sh ; ./configure ; make
> > distcheck" fails with the attached log output.
> [...]
> > make[2]: Entering directory '/home/linville/git/ethtool/ethtool-5.4/_build/sub'
> > gcc -DHAVE_CONFIG_H -I. -I../..    -I./uapi -Wall  -g -O2 -MT ethtool-ethtool.o -MD -MP -MF .deps/ethtool-ethtool.Tpo -c -o ethtool-ethtool.o `test -f 'ethtool.c' || echo '../../'`ethtool.c
> 
> I can see what is going on: this runs in subdirectory and correctly adds
> "-I../.." but not "-I../../uapi". I'm afraid I'll have to dive into
> automake documentation to see how to make it adjust that path as well.
> 
> > ../../ethtool.c: In function ‘do_get_phy_tunable’:
> > ../../ethtool.c:4773:16: error: ‘ETHTOOL_PHY_EDPD’ undeclared (first use in this function); did you mean ‘ETHTOOL_PHYS_ID’?
> >  4773 |   cont.ds.id = ETHTOOL_PHY_EDPD;
> >       |                ^~~~~~~~~~~~~~~~
> >       |                ETHTOOL_PHYS_ID
> 
> This is a result of the missing include path above: instead of
> up-to-date uapi/linux/ethtool.h, older system file from /usr/include is
> used so that new additions are missing. I have many more errors like
> this and when I tried to rename /usr/include/linux/ethtool.h, the build
> failed with
> 
>   ../../internal.h:56:10: fatal error: linux/ethtool.h: No such file or directory
> 
> I'll try to find what is the right way to add an include directory,
> adding "-I./uapi" to AM_CFLAGS did the trick for regular build but
> clearly isn't sufficient for other targets.

The change below seems to fix the problem but I'll run some more tests
tomorrow to see that it does not break anything.

Michal

diff --git a/Makefile.am b/Makefile.am
index 2fd79eb8c79a..eae5a55ce933 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,4 +1,5 @@
-AM_CFLAGS = -I./uapi -Wall
+AM_CFLAGS = -Wall
+AM_CPPFLAGS = -I$(top_srcdir)/uapi
 LDADD = -lm
 
 man_MANS = ethtool.8
