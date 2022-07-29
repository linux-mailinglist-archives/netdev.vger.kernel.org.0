Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8FCB585328
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 18:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbiG2QEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 12:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiG2QD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 12:03:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ED1FD87F7B
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 09:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659110636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rGREBqucJJOGNGa0XAhGtE5dmirak0cFTyn/iChNGR0=;
        b=UtK1zhmJrmLS17tTucBfx8lxQgcOCL1lHvmjlMXK2RVyLEnGgerBQ93skjulwA9bUTMN35
        TgGCeKbmiBlKUFsSK8Z9sYb2HMX/1wfJRri9awQYE8yG28hZuI2d6wAUSl/xPND80ler4B
        lhi9KL8qeFSsv1stjxd34QKLda6Tv9Y=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-159-UPUhr9TtM6KZPuj11ZHDlA-1; Fri, 29 Jul 2022 12:03:55 -0400
X-MC-Unique: UPUhr9TtM6KZPuj11ZHDlA-1
Received: by mail-wm1-f70.google.com with SMTP id r10-20020a05600c284a00b003a2ff6c9d6aso4184704wmb.4
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 09:03:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=rGREBqucJJOGNGa0XAhGtE5dmirak0cFTyn/iChNGR0=;
        b=6+znQieiDuGn+hvZZJa/Gts19rwdGT8SoDghd4L+0IAW1c7cj9RVPblQ2p+A2lkg1r
         QtgW04X2RBjiI/K/NGsolHfWP+hJo/52Bh464B+z2yYJihUgQwXsT6dLHlLAV5kGdSw/
         1ExknQhRvdhUwtCphQm6DKVFtPy6bm2+k9M2GWT18U8GLwsNEz/VNFJPcLhA3M14mugX
         zANI9uaoS9VlSIsfz29n73IEbDsJyxwv3Y0GMkOQZNaNbYoFwsSFj4wqSDgWSe7kls0r
         LZY+fJT8AqSvsVvG6fldA3DHKVggcWh5gxAqQLWKi0jOqR2le8gcartNIy9S2hqzgI0O
         gvCQ==
X-Gm-Message-State: AJIora+rJaZDmtCwFHfxYvX1GWAuNFuhUnuMImS/N885O608dlGca4Pc
        jCf/w5q5e3aOUwfJFO3iMX453f0MWN9z+BkvaM+y0PtfehJ5LvqxTr+MG8iYHQbI7IbsQHMSHcg
        K6q5kVhzJyqPOsU0L
X-Received: by 2002:a05:600c:1d1b:b0:3a3:e2:42d1 with SMTP id l27-20020a05600c1d1b00b003a300e242d1mr2996822wms.137.1659110634434;
        Fri, 29 Jul 2022 09:03:54 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1ueQc8PM+MGoBJr+zt90jRGqnB111NmHpe2FbvGUUAFr/GL1/0Mf7IVBrjSiabGjZZtiiBVAw==
X-Received: by 2002:a05:600c:1d1b:b0:3a3:e2:42d1 with SMTP id l27-20020a05600c1d1b00b003a300e242d1mr2996808wms.137.1659110634151;
        Fri, 29 Jul 2022 09:03:54 -0700 (PDT)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id r21-20020a05600c35d500b003a17ab4e7c8sm9780775wmq.39.2022.07.29.09.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 09:03:53 -0700 (PDT)
Date:   Fri, 29 Jul 2022 18:03:51 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Wojciech Drewek <wojciech.drewek@intel.com>,
        netdev@vger.kernel.org, stephen@networkplumber.org
Subject: Re: [PATCH iproute-next v4 2/3] lib: Introduce ppp protocols
Message-ID: <20220729160351.GD10877@pc-4.home>
References: <20220729085035.535788-1-wojciech.drewek@intel.com>
 <20220729085035.535788-3-wojciech.drewek@intel.com>
 <e00f3b23-7d9d-d8f1-646c-eaf843f744b5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e00f3b23-7d9d-d8f1-646c-eaf843f744b5@gmail.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 08:58:07AM -0600, David Ahern wrote:
> On 7/29/22 2:50 AM, Wojciech Drewek wrote:
> > PPP protocol field uses different values than ethertype. Introduce
> > utilities for translating PPP protocols from strings to values
> > and vice versa. Use generic API from utils in order to get
> > proto id and name.
> > 
> > Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
> > ---
> > v4: ppp_defs.h removed
> > ---
> >  include/rt_names.h |  3 +++
> >  lib/Makefile       |  2 +-
> >  lib/ppp_proto.c    | 52 ++++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 56 insertions(+), 1 deletion(-)
> >  create mode 100644 lib/ppp_proto.c
> > 
> 
> Ubuntu 20.04 with gcc 9.4 and clang 10.0 - both fail the same:
> 
> $ make
> 
> lib
>     CC       ppp_proto.o
> In file included from ppp_proto.c:9:
> ../include/uapi/linux/ppp_defs.h:151:5: error: unknown type name
> ‘__kernel_old_time_t’
>   151 |     __kernel_old_time_t xmit_idle; /* time since last NP packet
> sent */
>       |     ^~~~~~~~~~~~~~~~~~~
> ../include/uapi/linux/ppp_defs.h:152:5: error: unknown type name
> ‘__kernel_old_time_t’
>   152 |     __kernel_old_time_t recv_idle; /* time since last NP packet
> received */
>       |     ^~~~~~~~~~~~~~~~~~~
> make[1]: *** [../config.mk:58: ppp_proto.o] Error 1
> make: *** [Makefile:77: all] Error 2

Works for me on Debian 11 (Bullseye), where __kernel_old_time_t is
defined in /usr/include/asm-generic/posix_types.h (package
linux-libc-dev).

I guess the Ubuntu 20.04 failure happens because it's based on
Linux 5.4, while __kernel_old_time_t was introduced in v5.5 (by
commit 94c467ddb273 ("y2038: add __kernel_old_timespec and
__kernel_old_time_t")).

Not sure how to resolve this. This series doesn't need the
struct ppp_idle that depends on __kernel_old_time_t.

