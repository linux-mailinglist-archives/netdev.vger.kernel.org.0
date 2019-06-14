Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD4064567A
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 09:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbfFNHfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 03:35:42 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45557 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbfFNHfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 03:35:42 -0400
Received: by mail-pf1-f196.google.com with SMTP id r1so882946pfq.12;
        Fri, 14 Jun 2019 00:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7t+luti4wV9vQmcaMbs7td85lQbR85hqcaLUIAiVWoI=;
        b=W1ugtM53KzaD8xdpRd7Qz9A000X0MEMoMTKwO4rOT+ukHKvs72fjktZHI2WdbvxqL8
         CUrxkE7YfIdQZ+jeOQtfL77kNuGwqeeV5RWJXxTqVCjcLYNj1TQICKiY9pJi2Oebz7n5
         5ytj4Z1uOgPX4/ZaERd5O+rl2o9gFiDJvBUWyjM+T2TZvAv9sEDxjVWYqwO7LHQB7NWK
         v1MCYnrUD8UJo4+OqL2Ai6N4tXtroBf2kjDNzUmuTiXHZcFDBOKR09LVRj3dFsHBvBua
         NBn5kJG4x+NmoX7BmHuMOZFuDU7NKE9VLfW+WDCwiaVFvmcQ9lLALJu5xXmTFZumQtkN
         k5Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7t+luti4wV9vQmcaMbs7td85lQbR85hqcaLUIAiVWoI=;
        b=PVLc5HDUzb/u1gONreU/hZdE1H4/kkQQF9zl7iXZYwNW53fL9LOEqlot4d9bXqDNvI
         Z55pcEdaUaodJye0aHfB8vMrEcAmPQFeCQnQ3CG5nH3RPePfQVCigKp0iXucUCGyDl80
         0OlpGL97/Wx5z4lUsIr1cdOLBdn48cSSl9F2jvpu9UN7zC7uAOpmcdXRPJ77jL08r5m6
         lvokJxZbuiTsbkC8D93TWJGSt6GN6oW2J+kk96YZOaLgthOc2ETUz47GMG+m4J7rlZwG
         C99ArRIz3/cz5DM5RzPda9LUV8zjmgNXGEfot1eQ5x37+gJXlzW1Vo/UdSFqWahF1UAe
         +RkA==
X-Gm-Message-State: APjAAAX7JUt93n2Sd4r/Ycxh37/OVuf/Eq4ikOw9Cf/fTHD5QQIgcAwj
        S746HC0i7Bcgq6/jElP1yhJ+vGhH
X-Google-Smtp-Source: APXvYqyv2Iou2lzuE0aE6mHU+9eW90kOnahjxUSoVewloziiQJO8iDhyEuFQn7BTkrc+npfuenI7Tg==
X-Received: by 2002:a65:4907:: with SMTP id p7mr33957517pgs.288.1560497741637;
        Fri, 14 Jun 2019 00:35:41 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::1:f6f1])
        by smtp.gmail.com with ESMTPSA id w197sm3563876pfd.41.2019.06.14.00.35.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 00:35:40 -0700 (PDT)
Date:   Fri, 14 Jun 2019 00:35:38 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>
Subject: Re: [PATCH 2/9] objtool: Fix ORC unwinding in non-JIT BPF generated
 code
Message-ID: <20190614073536.d3xkhwhq3fuivwt5@ast-mbp.dhcp.thefacebook.com>
References: <cover.1560431531.git.jpoimboe@redhat.com>
 <99c22bbd79e72855f4bc9049981602d537a54e70.1560431531.git.jpoimboe@redhat.com>
 <20190613205710.et5fywop4gfalsa6@ast-mbp.dhcp.thefacebook.com>
 <20190614012030.b6eujm7b4psu62kj@treble>
 <20190614070852.GQ3436@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614070852.GQ3436@hirez.programming.kicks-ass.net>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 09:08:52AM +0200, Peter Zijlstra wrote:
> On Thu, Jun 13, 2019 at 08:20:30PM -0500, Josh Poimboeuf wrote:
> > On Thu, Jun 13, 2019 at 01:57:11PM -0700, Alexei Starovoitov wrote:
> 
> > > and to patches 8 and 9.
> > 
> > Well, it's your code, but ... can I ask why?  AT&T syntax is the
> > standard for Linux, which is in fact the OS we are developing for.
> 
> I agree, all assembly in Linux is AT&T, adding Intel notation only
> serves to cause confusion.

It's not assembly. It's C code that generates binary and here
we're talking about comments.
I'm sure you're not proposing to do:
/* mov src, dst */
#define EMIT_mov(DST, SRC)                                                               \
right?
bpf_jit_comp.c stays as-is. Enough of it.

