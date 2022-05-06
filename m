Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D971B51DF95
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 21:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390840AbiEFTTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 15:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389906AbiEFTSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 15:18:48 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A226D384;
        Fri,  6 May 2022 12:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=Ku2H0dVFHWUXAOXQaFLrRey8keVDfRjwZFcZZ6wIpDs=; b=N/Pp2hwpFN7sAM2zS2K/pZ3EpJ
        Qk+IfyuXvAryDmhQjt1fr/IdKfckpAoDFPqGRy5lYW+TDiWD7iy+e9toVR/R+TtFrkJ1CYoSHaLAe
        6oGUT05exbMUYvpSwisbtxboW+ciDzCYIDdV+MVHO/NK7WkCr2TYRibxqEO9rHxeLBX8wHEd5UUYX
        /Z/BJGT3PsEXBSugervKTMytMynlSn4W4FXMSWLredYU+r0X840dnqcHEiHuq/NuMNtt5QlQIZEo0
        OC5Q8L4LqVtzqNqVwGmP5ZCgfilXTpa+91IBqbHHyzj4cM4kux2mVRJtuV/zAH/kmdw+7+YsvJlb+
        gDqThM4cAHZ6VuDBFiEY90QIxPAIEIkGOWkmMQEJxLIEgTMj0cmyfJlaJikkmwnberzYByblebhF+
        8Tcexi7nF8naAYKpb1aQpzue5P6u4kSI0Ve3aIDj/LoXrSsEktdaviEl0n2cOomTvBiJOAbS8AJ34
        8h9ozbb0Y+plpt43JUTwppAhi5CCY8MjbnFwC/HlqJJwAzNb+uUzKUCzo5Wo0dgWQrSsaQHhPjOr6
        xGusBwbWn/de3G8RB3wd4zRCtJR+U5j3on4y/6hFuIj+1OXw/+AmpfUsWJFLvhAr4W9ZT6cE1cFQR
        5dF9YfcStw9CrFhYlpivmpUSdPM7vjNTbIXj9BbgU=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     asmadeus@codewreck.org
Cc:     David Howells <dhowells@redhat.com>,
        David Kahurani <k.kahurani@gmail.com>, davem@davemloft.net,
        ericvh@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        lucho@ionkov.net, netdev@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, Greg Kurz <groug@kaod.org>
Subject: Re: 9p EBADF with cache enabled (Was: 9p fs-cache tests/benchmark (was: 9p
 fscache Duplicate cookie detected))
Date:   Fri, 06 May 2022 21:14:52 +0200
Message-ID: <7091002.4ErQJAuLzZ@silver>
In-Reply-To: <YnL0vzcdJjgyq8rQ@codewreck.org>
References: <YmKp68xvZEjBFell@codewreck.org> <6688504.ZJKUV3z3ry@silver>
 <YnL0vzcdJjgyq8rQ@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mittwoch, 4. Mai 2022 23:48:47 CEST asmadeus@codewreck.org wrote:
> Christian Schoenebeck wrote on Wed, May 04, 2022 at 08:33:36PM +0200:
> > On Dienstag, 3. Mai 2022 12:21:23 CEST asmadeus@codewreck.org wrote:
> > >  - add some complex code to track the exact byte range that got updated
> > > 
> > > in some conditions e.g. WRONLY or read fails?
> > > That'd still be useful depending on how the backend tracks file mode,
> > > qemu as user with security_model=mapped-file keeps files 600 but with
> > > passthrough or none qemu wouldn't be able to read the file regardless of
> > > what we do on client...
> > > Christian, if you still have an old kernel around did that use to work?
> > 
> > Sorry, what was the question, i.e. what should I test / look for
> > precisely? :)
> I was curious if older kernel does not issue read at all, or issues read
> on writeback fid correctly opened as root/RDRW
> 
> You can try either the append.c I pasted a few mails back or the dd
> commands, as regular user.
> 
> $ dd if=/dev/zero of=test bs=1M count=1
> $ chmod 400 test
> # drop cache or remount
> $ dd if=/dev/urandom of=test bs=102 seek=2 count=1 conv=notrunc
> dd: error writing 'test': Bad file descriptor

Seems you were right, the old kernel opens the file with O_RDWR.

The following was taken with cache=loose, pre-netfs kernel version, using your
append code and file to be appended already containing 34 bytes, relevant file is fid 7:

  v9fs_open tag 0 id 12 fid 7 mode 2
  v9fs_open_return tag 0 id 12 qid={type 0 version 1651854932 path 3108899} iounit 4096
  v9fs_xattrwalk tag 0 id 30 fid 5 newfid 8 name security.capability
  v9fs_rerror tag 0 id 30 err 95
  v9fs_read tag 0 id 116 fid 7 off 0 max_count 4096
  v9fs_read_return tag 0 id 116 count 34 err 45
  v9fs_read tag 0 id 116 fid 7 off 34 max_count 4062
  v9fs_read_return tag 0 id 116 count 0 err 11
  v9fs_clunk tag 0 id 120 fid 6
  v9fs_clunk tag 0 id 120 fid 4
  [delay]
  v9fs_write tag 0 id 118 fid 7 off 0 count 39 cnt 1
  v9fs_write_return tag 0 id 118 total 39 err 11
  v9fs_fsync tag 0 id 50 fid 7 datasync 0

BTW to see this protocol debug output with QEMU:

  cd qemu/build
  ../configure --enable-trace-backends=log ...
  make -jN
  ./qemu-system-x86_64 -trace 'v9fs*' ...

Best regards,
Christian Schoenebeck


