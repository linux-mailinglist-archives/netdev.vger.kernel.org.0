Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF68829845
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 14:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391072AbfEXMtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 08:49:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56250 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390988AbfEXMtJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 08:49:09 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B09482EF169;
        Fri, 24 May 2019 12:49:08 +0000 (UTC)
Received: from carbon (ovpn-200-45.brq.redhat.com [10.40.200.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B62B7A4D7;
        Fri, 24 May 2019 12:49:02 +0000 (UTC)
Date:   Fri, 24 May 2019 14:49:00 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        brouer@redhat.com
Subject: Re: [PATCH bpf-next v3 2/3] libbpf: add bpf_object__load_xattr()
 API function to pass log_level
Message-ID: <20190524144900.618e8e93@carbon>
In-Reply-To: <5895821e-0d79-2169-d631-0fa7560135ec@netronome.com>
References: <20190524103648.15669-1-quentin.monnet@netronome.com>
        <20190524103648.15669-3-quentin.monnet@netronome.com>
        <20190524132215.4113ff08@carbon>
        <5895821e-0d79-2169-d631-0fa7560135ec@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Fri, 24 May 2019 12:49:08 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 May 2019 12:51:14 +0100
Quentin Monnet <quentin.monnet@netronome.com> wrote:

> 2019-05-24 13:22 UTC+0200 ~ Jesper Dangaard Brouer <brouer@redhat.com>
> > On Fri, 24 May 2019 11:36:47 +0100
> > Quentin Monnet <quentin.monnet@netronome.com> wrote:
> >   
> >> libbpf was recently made aware of the log_level attribute for programs,
> >> used to specify the level of information expected to be dumped by the
> >> verifier. Function bpf_prog_load_xattr() got support for this log_level
> >> parameter.
> >>
> >> But some applications using libbpf rely on another function to load
> >> programs, bpf_object__load(), which does accept any parameter for log
> >> level. Create an API function based on bpf_object__load(), but accepting
> >> an "attr" object as a parameter. Then add a log_level field to that
> >> object, so that applications calling the new bpf_object__load_xattr()
> >> can pick the desired log level.  
> > 
> > Does this allow us to extend struct bpf_object_load_attr later?  
> 
> I see no reason why it could not. Having the _xattr() version of the
> function is precisely a way to have something extensible in the future,
> without having to create additional API functions each time we want to
> pass a new parameter. And e.g. struct bpf_prog_load_attr (used with
> bpf_prog_load_xattr()) has already been extended in the past. So, yeah,
> we can add to it in the future.

Great.  I just don't know/understand how user-space handle this. If a
binary is compiled with libbpf as dynamic loadable lib, then it e.g. saw
libbpf.so.2 when it was compiled, then can't it choose to use libbpf.so.3
then? (e.g. when libbpf.so.2 is not on the system). (I would actually
like to learn/understand this, so links are welcome).

> Do you have something in mind?

I was playing with extending bpf_prog_load_attr, but instead I created a
bpf_prog_load_attr_maps instead and a new function
bpf_prog_load_xattr_maps(), e.g. see:

https://github.com/xdp-project/xdp-tutorial/blob/master/common/common_libbpf.h
https://github.com/xdp-project/xdp-tutorial/blob/master/common/common_libbpf.c

I guess, I could just extend bpf_prog_load_attr instead, right?

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
