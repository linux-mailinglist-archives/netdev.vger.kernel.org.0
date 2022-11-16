Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7591262CE15
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 23:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234050AbiKPWyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 17:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233886AbiKPWyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 17:54:03 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65ABB63CEC
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 14:54:01 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id 140so16515pfz.6
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 14:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GzY0Cg9Dlevhcd5fmFmvi+wpz/E/XkCStI+Yr+ILYYQ=;
        b=mYQF1jXmHGeQuICyAgDVOwwlgueJ38A2DgdHnoMIyhfTaexBMLhATD1cT1Wdo4yHI8
         +gq3WsOqu/jG3dV8mjQHwzriMWOA1zzrGf1K0z0b6sllSTgJ+QHJl3tXTOVIxT7gYkAZ
         6lP7nHIu/JvjRUxll/PN9OVm9O+nel6eZSaxo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GzY0Cg9Dlevhcd5fmFmvi+wpz/E/XkCStI+Yr+ILYYQ=;
        b=tgBHjV9Ba7Fn9BqY+Rb3i/F7mjlO0mjlL+34u5/FFkw9fqYib+SF4Chi3zwyzK/8JD
         UcfHzYZkVAUPowbCApDn7I2NaedTP982b21QbleMTmU648XFGxpbtIcF2oldwnMK9cdd
         YYaYY/Kxx2wsFTrHuoA/cIn07PDScrJjDv6MDsYOpyQt++LQN7M0bEtXoYwSAbAjcQkF
         vYrKPsOn3lAyNkLh0aKqgG/OceEWP+aBRmkVTVDHIdeyjvQq9pJsa1WDuagzAKQA4dVs
         2So8mQRsRUjaxg4ogDjAFRyPNbQRyLa0yk5h1j0JbeHO3SuUcqpdjPYB4FXyPu0snfyL
         vjng==
X-Gm-Message-State: ANoB5pkVnw/KgAWaecHusxsA1gn7chK7C5122qHsyI3/N8ejpKo8aApt
        Lkw8F+fkBP0iRU41GFu7R/mrXg==
X-Google-Smtp-Source: AA0mqf7NDJFTdi+ox3oJYEhcPbuuopkDOXAUn+w5JZ6yggNjJFBmW8IHGA1XN5QsLJrKTZ7seXlBoQ==
X-Received: by 2002:a63:4e53:0:b0:473:f7fb:d2c7 with SMTP id o19-20020a634e53000000b00473f7fbd2c7mr22550107pgl.535.1668639240930;
        Wed, 16 Nov 2022 14:54:00 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id x20-20020a17090ab01400b001fb1de10a4dsm2118687pjq.33.2022.11.16.14.54.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 14:54:00 -0800 (PST)
Date:   Wed, 16 Nov 2022 14:53:59 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next v2] netlink: split up copies in the ack
 construction
Message-ID: <202211161444.04F3EDEB@keescook>
References: <20221027212553.2640042-1-kuba@kernel.org>
 <20221114023927.GA685@u2004-local>
 <20221114090614.2bfeb81c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114090614.2bfeb81c@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 09:06:14AM -0800, Jakub Kicinski wrote:
> On Sun, 13 Nov 2022 19:39:27 -0700 David Ahern wrote:
> > On Thu, Oct 27, 2022 at 02:25:53PM -0700, Jakub Kicinski wrote:
> > > diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
> > > index e2ae82e3f9f7..5da0da59bf01 100644
> > > --- a/include/uapi/linux/netlink.h
> > > +++ b/include/uapi/linux/netlink.h
> > > @@ -48,6 +48,7 @@ struct sockaddr_nl {
> > >   * @nlmsg_flags: Additional flags
> > >   * @nlmsg_seq:   Sequence number
> > >   * @nlmsg_pid:   Sending process port ID
> > > + * @nlmsg_data:  Message payload
> > >   */
> > >  struct nlmsghdr {
> > >  	__u32		nlmsg_len;
> > > @@ -55,6 +56,7 @@ struct nlmsghdr {
> > >  	__u16		nlmsg_flags;
> > >  	__u32		nlmsg_seq;
> > >  	__u32		nlmsg_pid;
> > > +	__u8		nlmsg_data[];  
> > 
> > This breaks compile of iproute2 with clang. It does not like the
> > variable length array in the middle of a struct. While I could re-do the
> > structs in iproute2, I doubt it is alone in being affected by this
> > change.

Eww.

> 
> Kees, would you mind lending your expertise?
> 
> Not sure why something like (simplified):
> 
> struct top {
> 	struct nlmsghdr hdr;
> 	int tail;
> }; 
> 
> generates a warning:
> 
> In file included from stat-mr.c:7:
> In file included from ./res.h:9:
> In file included from ./rdma.h:21:
> In file included from ../include/utils.h:17:
> ../include/libnetlink.h:41:18: warning: field 'nlh' with variable sized type 'struct nlmsghdr' not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
>         struct nlmsghdr nlh;
>                         ^
> 
> which is not confined to -Wpedantic. 
> Seems like a useless warning :S

Yeah, this surprises me. But I can certainly reproduce it:
https://godbolt.org/z/fczq8sqbv

Gustavo, do you know what's happening here? GCC (and Clang) get mad
about doing this in the same struct:

struct nlmsghdr {
    __u32           nlmsg_len;
    __u16           nlmsg_flags;
    __u32           nlmsg_seq;
    __u32           nlmsg_pid;
    __u8            nlmsg_data[]; 
    int wat; 
};

<source>:10:21: error: flexible array member not at end of struct
   10 |     __u8            nlmsg_data[];
      |                     ^~~~~~~~~~

But the overlapping with other composite structs has been used in other
areas, I thought? (When I looked at this last, I thought the types just
had to overlap, but that doesn't seem to help here.)

-Kees

-- 
Kees Cook
