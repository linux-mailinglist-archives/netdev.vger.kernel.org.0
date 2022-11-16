Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 444F762CE21
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 23:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233768AbiKPW4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 17:56:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238946AbiKPW41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 17:56:27 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD1A8682B2
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 14:56:26 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id b21so17806773plc.9
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 14:56:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GiOuTv0Y83uWeHmwFnOugVQTYhEP8LeyahdHa6ev9kM=;
        b=kmurDlnR2S1s1gwNG3LHjq+Kf8wCcMB9TxESeQ3Hb2PKt7WZ72hWg3HebhuF/Hkl8p
         EnrC1JK3X1LI1kbm4pintY5WjeXy/tHNe6HiTxxsoNPTZ62+eV032UoVaOnUI2SlUTQ4
         khPDRPKIXNSwQUvud9C4Q7AAr+hP5FvGKw2g8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GiOuTv0Y83uWeHmwFnOugVQTYhEP8LeyahdHa6ev9kM=;
        b=RYTz6l2PXAqlmkDNZBon33B09v+cr4TwJKJA2lLGSsN9xFAQZjnrlOJsQyOn8WKHl5
         R8JFESu2z9IiZIcrQfW2tryj0J7dGXuhKBS4YpBn9qjFRdVFZPDg5j5Y+DcolTiCIitP
         KQRsJmgwRSGl2UYMjyWYOBuFIk23+v0OL78ncxnbWnrE528ZnF3pLpWsiyfG5rdPNPMa
         xvpYiHzzCPnJ1JOvPxnWjPUgTN6sWA8LAK9TIRNosYDByrUKdko1rSmNonDbixzvyN9t
         bf/0CtoANL3Tf8o4/aJQy8RH3z78LIbJqyjKDr0K69YRA2kkxeMoiPM4HMWG4iVsMmn7
         NYoQ==
X-Gm-Message-State: ANoB5pnsflIcUDSfPm01o6DmXNd/AbjyTtKAnO0JFGBmCvQUuyM9GIcf
        65Vn/edyBRYdrkAFHCP6UCFAQw==
X-Google-Smtp-Source: AA0mqf5Nu4Mo958iwkxzCF8h2kIG4oIVU16gDjPtH0QISGOyY0LgClbiU1M4UIpRtwz0SsX1MdNy2Q==
X-Received: by 2002:a17:90a:3d49:b0:213:9458:8a93 with SMTP id o9-20020a17090a3d4900b0021394588a93mr5881187pjf.233.1668639386171;
        Wed, 16 Nov 2022 14:56:26 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id k135-20020a636f8d000000b0046ff7db0984sm10265642pgc.72.2022.11.16.14.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 14:56:25 -0800 (PST)
Date:   Wed, 16 Nov 2022 14:56:25 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH net-next v2] netlink: split up copies in the ack
 construction
Message-ID: <202211161454.D5FA4ED44@keescook>
References: <20221027212553.2640042-1-kuba@kernel.org>
 <20221114023927.GA685@u2004-local>
 <20221114090614.2bfeb81c@kernel.org>
 <202211161444.04F3EDEB@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202211161444.04F3EDEB@keescook>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[sorry for the dup; resending with Gustavo actually CCed]

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
