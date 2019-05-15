Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA051FC7B
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 00:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbfEOWFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 18:05:00 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34646 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfEOWE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 18:04:59 -0400
Received: by mail-qk1-f196.google.com with SMTP id j20so1055280qke.1
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 15:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=C34FeLB+NsCmU+Ozz+EEP9IjHJl+u3iWTHR3kle82Mc=;
        b=MZoLJ80j05SwxFuMEK/VrcrBgGnZ1K2eRxqR52iLAvqdO+RryoRMe3FiC9+Gly6aqY
         jMFnSQ8f1NicsX0g52Rdus5sQNDkPDXZaBhowoPk3N0w8yXlZmuDa5Y36m4O82SQOj5r
         z2NUgNa7MrsHEmsUZSetw5w8EwiWx3tvI6W4E0tW1dZy1iSULiay1HEVJTh4NTUMMwv+
         Ep80u50THXN3QODK/r+3ujLzLImXlor7fe+qWhR9BXsxcdvTShS0EjmRzURrPC60p8Cv
         OrOFuCX2eXQbKiTb0yIG9UzHle4nTevJmVDa2sLhHhISuLLX8nhHx1nnb9l5Otx8i+Qo
         vJZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=C34FeLB+NsCmU+Ozz+EEP9IjHJl+u3iWTHR3kle82Mc=;
        b=sFZEKlE7ZmXCEBr5lokg9ELcjJ0GmMP4nPTNUtt74ySwNHdjc9nt3MSVuWhmuNfsHi
         fYl6R2npQH7pbk6fHLHFbDwwTBPiL+qRDYiafMkB1igIQdJs4/IA1jNYap89LDwiJdNl
         9+KguCr/AFKI8xO1HqwHwpYy5rShA2e5VgLabbpufqDJtu8ycjvwgdlfFdjp6VrZOcy0
         2NEMPOiNmGyWLKMu0NBTWCOBSkjWpp8AEj5mkw17mJsa7Roe1itEWj+IUTH3HXSvyog5
         KMKjkpVtSUuijZtAi6lm9fCYpiwiZTrlNeLngu8MfPGgX/KW4TkgCXbc9UO8DF/0RrUo
         xUEg==
X-Gm-Message-State: APjAAAXG/rUb2kdBszyAxoU73CzvccGMZUodalMEjIaWJyxTXty9AdoN
        WGmTUuOSu04goG2dfRcZK9YEkQ==
X-Google-Smtp-Source: APXvYqzhixx0If4B+JArI+H2o9nTm2LibggRoYAp1GcEToSNMdadrdwpGTS6eEDvV4Qn0m41+Q6O4w==
X-Received: by 2002:a37:a5c6:: with SMTP id o189mr35545009qke.318.1557957898302;
        Wed, 15 May 2019 15:04:58 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id q27sm2442043qtf.27.2019.05.15.15.04.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 15 May 2019 15:04:58 -0700 (PDT)
Date:   Wed, 15 May 2019 15:04:34 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     NeilBrown <neilb@suse.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au, tgraf@suug.ch,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Simon Horman <simon.horman@netronome.com>
Subject: Re: [PATCH net] rhashtable: fix sparse RCU warnings on bit lock in
 bucket pointer
Message-ID: <20190515150434.7ae041c8@cakuba.netronome.com>
In-Reply-To: <87sgtfwg1m.fsf@notabene.neil.brown.name>
References: <20190515205501.17810-1-jakub.kicinski@netronome.com>
        <87sgtfwg1m.fsf@notabene.neil.brown.name>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 May 2019 07:42:29 +1000, NeilBrown wrote:
> On Wed, May 15 2019, Jakub Kicinski wrote:
> 
> > Since the bit_spin_lock() operations don't actually dereference
> > the pointer, it's fine to forcefully drop the RCU annotation.
> > This fixes 7 sparse warnings per include site.
> >
> > Fixes: 8f0db018006a ("rhashtable: use bit_spin_locks to protect hash bucket.")
> > Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> > Reviewed-by: Simon Horman <simon.horman@netronome.com>  
> 
> Hi, sorry for not responding to your initial post, but I'm otherwise
> engaged this week and cannot give it any real time.  I don't object to
> this patch, but I'll try to have a proper look next week, if only to
> find out how I didn't get the warnings, as I was testing with sparse.

You gave me a scare :)  I pulled latest sparse and they seem to still
be there (previously I was testing with sparse 5.2).  Note that I'm
just fixing the warnings in the header, those are particularly noisy as
they get printed for each include site.

$ gcc-9 --version
gcc-9 (Ubuntu 9-20190428-1ubuntu1~18.04.york0) 9.0.1 20190428 (prerelease) [gcc-9-branch revision 270630]
  [...]
$ sparse --version
v0.6.1-rc1-7-g2b96cd80
$ git checkout net/master
$ make CC=gcc-9 O=build_net-perf/ -j 32 W=1 C=1 
make[1]: Entering directory '/home/jkicinski/devel/linux/build_net-perf'
  GEN     Makefile
  DESCEND  objtool
  Using .. as source for kernel
  CALL    ../scripts/atomic/check-atomics.sh
  CALL    ../scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  CHECK   ../lib/rhashtable.c
../lib/rhashtable.c:134:13: warning: incorrect type in initializer (different address spaces)
../lib/rhashtable.c:134:13:    expected union nested_table [noderef] <asn:4> *__new
../lib/rhashtable.c:134:13:    got union nested_table *[assigned] ntbl
../lib/rhashtable.c:250:51: warning: incorrect type in argument 2 (different address spaces)
../lib/rhashtable.c:250:51:    expected struct rhash_lock_head **bucket
../lib/rhashtable.c:250:51:    got struct rhash_lock_head [noderef] <asn:4> **
../lib/rhashtable.c:277:27: warning: incorrect type in argument 2 (different address spaces)
../lib/rhashtable.c:277:27:    expected struct rhash_lock_head **bkt
../lib/rhashtable.c:277:27:    got struct rhash_lock_head [noderef] <asn:4> **bkt
../lib/rhashtable.c:284:29: warning: incorrect type in argument 2 (different address spaces)
../lib/rhashtable.c:284:29:    expected struct rhash_lock_head **bkt
../lib/rhashtable.c:284:29:    got struct rhash_lock_head [noderef] <asn:4> **bkt
../lib/rhashtable.c:299:13: warning: incorrect type in initializer (different address spaces)
../lib/rhashtable.c:299:13:    expected struct bucket_table [noderef] <asn:4> *__new
../lib/rhashtable.c:299:13:    got struct bucket_table *new_tbl
../lib/rhashtable.c:605:39: warning: incorrect type in argument 2 (different address spaces)
../lib/rhashtable.c:605:39:    expected struct rhash_lock_head **bkt
../lib/rhashtable.c:605:39:    got struct rhash_lock_head [noderef] <asn:4> **[assigned] bkt
../lib/rhashtable.c:613:41: warning: incorrect type in argument 2 (different address spaces)
../lib/rhashtable.c:613:41:    expected struct rhash_lock_head **bkt
../lib/rhashtable.c:613:41:    got struct rhash_lock_head [noderef] <asn:4> **[assigned] bkt
  [...]
$ git checkout rht-fix
$ make CC=gcc-9 O=build_net-perf/ -j 32 W=1 C=1 
  [...all things get rebuilt...]
$ touch lib/rhashtable.c
$ make CC=gcc-9 O=build_net-perf/ -j 32 W=1 C=1 
make[1]: Entering directory '/home/jkicinski/devel/linux/build_net-perf'
  GEN     Makefile
  DESCEND  objtool
  Using .. as source for kernel
  CALL    ../scripts/atomic/check-atomics.sh
  CALL    ../scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  CHECK   ../lib/rhashtable.c
../lib/rhashtable.c:134:13: warning: incorrect type in initializer (different address spaces)
../lib/rhashtable.c:134:13:    expected union nested_table [noderef] <asn:4> *__new
../lib/rhashtable.c:134:13:    got union nested_table *[assigned] ntbl
../lib/rhashtable.c:299:13: warning: incorrect type in initializer (different address spaces)
../lib/rhashtable.c:299:13:    expected struct bucket_table [noderef] <asn:4> *__new
../lib/rhashtable.c:299:13:    got struct bucket_table *new_tbl
  [...]
