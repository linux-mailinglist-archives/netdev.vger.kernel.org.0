Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9E4935D0C
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 14:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbfFEMkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 08:40:49 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:55178 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727273AbfFEMkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 08:40:49 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hYVDh-0005pc-KN; Wed, 05 Jun 2019 14:40:45 +0200
Date:   Wed, 5 Jun 2019 14:40:45 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Florian Westphal <fw@strlen.de>, kbuild-all@01.org,
        netdev@vger.kernel.org
Subject: Re: [ipsec-next:testing 4/6] net/xfrm/xfrm_state.c:1792:9: error:
 '__xfrm6_tmpl_sort_cmp' undeclared; did you mean 'xfrm_tmpl_sort'?
Message-ID: <20190605124045.gzkafkixihwu7447@breakpoint.cc>
References: <201906052002.P2x8MWme%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201906052002.P2x8MWme%lkp@intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kbuild test robot <lkp@intel.com> wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git testing
> head:   ca78a3eaad69bd08ba41c144c21881dc694d4a32
> commit: 8dc6e3891a4be64c0cca5e8fe2c3ad33bc06543e [4/6] xfrm: remove state and template sort indirections from xfrm_state_afinfo
> config: i386-randconfig-x003-201922 (attached as .config)
> compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
> reproduce:
>         git checkout 8dc6e3891a4be64c0cca5e8fe2c3ad33bc06543e
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    net/xfrm/xfrm_state.c: In function 'xfrm_tmpl_sort':
> >> net/xfrm/xfrm_state.c:1792:9: error: '__xfrm6_tmpl_sort_cmp' undeclared (first use in this function); did you mean 'xfrm_tmpl_sort'?
>             __xfrm6_tmpl_sort_cmp, 5);
>             ^~~~~~~~~~~~~~~~~~~~~
>             xfrm_tmpl_sort
>    net/xfrm/xfrm_state.c:1792:9: note: each undeclared identifier is reported only once for each function it appears in
>    net/xfrm/xfrm_state.c: In function 'xfrm_state_sort':
> >> net/xfrm/xfrm_state.c:1806:9: error: '__xfrm6_state_sort_cmp' undeclared (first use in this function); did you mean '__xfrm6_state_addr_cmp'?
>             __xfrm6_state_sort_cmp, 6);
>             ^~~~~~~~~~~~~~~~~~~~~~
>             __xfrm6_state_addr_cmp

this lacks stubs for CONFIG_IPV6=n case.

Steffen, as this is still only in your testing branch, I suggest you
squash this snipped into commit 8dc6e3891a4be64c0cca5e8fe2c3ad33bc06543e
("xfrm: remove state and template sort indirections from xfrm_state_afinfo"),
it resolves this problem for me.  Otherwise, I can make a formal submit,
just let me know.

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1845,6 +1845,9 @@ static int __xfrm6_tmpl_sort_cmp(const void *p)
 	return 4;
 }
 #else
+static inline int __xfrm6_state_sort_cmp(const void *p) { return 5; }
+static inline int __xfrm6_tmpl_sort_cmp(const void *p) { return 4; }
+
 static inline void
 __xfrm6_sort(void **dst, void **src, int n,
 	     int (*cmp)(const void *p), int maxclass)
