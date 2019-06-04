Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 892E634F46
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfFDRrw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 4 Jun 2019 13:47:52 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:60596 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725929AbfFDRrw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 13:47:52 -0400
Received: from tarshish (unknown [10.0.8.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 6B57B44059C;
        Tue,  4 Jun 2019 20:47:33 +0300 (IDT)
References: <602128d22db86bd67e11dec8fe40a73832c222c9.1559230347.git.baruch@tkos.co.il> <20190604094718.0a56d7a5@hermes.lan>
User-agent: mu4e 1.0; emacs 26.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: Re: [PATCH] devlink: fix libc and kernel headers collision
In-reply-to: <20190604094718.0a56d7a5@hermes.lan>
Date:   Tue, 04 Jun 2019 20:47:50 +0300
Message-ID: <87ef49nsxl.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

On Tue, Jun 04 2019, Stephen Hemminger wrote:
> On Thu, 30 May 2019 18:32:27 +0300
> Baruch Siach <baruch@tkos.co.il> wrote:
>
>> Since commit 2f1242efe9d ("devlink: Add devlink health show command") we
>> use the sys/sysinfo.h header for the sysinfo(2) system call. But since
>> iproute2 carries a local version of the kernel struct sysinfo, this
>> causes a collision with libc that do not rely on kernel defined sysinfo
>> like musl libc:
>> 
>> In file included from devlink.c:25:0:
>> .../sysroot/usr/include/sys/sysinfo.h:10:8: error: redefinition of 'struct sysinfo'
>>  struct sysinfo {
>>         ^~~~~~~
>> In file included from ../include/uapi/linux/kernel.h:5:0,
>>                  from ../include/uapi/linux/netlink.h:5,
>>                  from ../include/uapi/linux/genetlink.h:6,
>>                  from devlink.c:21:
>> ../include/uapi/linux/sysinfo.h:8:8: note: originally defined here
>>  struct sysinfo {
>> 		^~~~~~~
>> 
>> Rely on the kernel header alone to avoid kernel and userspace headers
>> collision of definitions.
>> 
>> Cc: Aya Levin <ayal@mellanox.com>
>> Cc: Moshe Shemesh <moshe@mellanox.com>
>> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
>
> Sorry this breaks the glibc build.
>
>
>     CC       devlink.o
> devlink.c: In function ‘format_logtime’:
> devlink.c:6124:8: warning: implicit declaration of function ‘sysinfo’; did you mean ‘psiginfo’? [-Wimplicit-function-declaration]
>   err = sysinfo(&s_info);
>         ^~~~~~~
>         psiginfo
>
> I backed out the patch now (before pushing it).
> Please fix and resubmit.

I can't think of anything better than this ugly fix:

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 436935f88bda..02e648ef64b3 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -18,11 +18,12 @@
 #include <limits.h>
 #include <errno.h>
 #include <inttypes.h>
+#include <sys/sysinfo.h>
+#define _LINUX_SYSINFO_H
 #include <linux/genetlink.h>
 #include <linux/devlink.h>
 #include <libmnl/libmnl.h>
 #include <netinet/ether.h>
-#include <sys/sysinfo.h>
 #include <sys/queue.h>
 
 #include "SNAPSHOT.h"

Would that be acceptable?

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
