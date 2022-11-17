Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0DE62E883
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 23:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234809AbiKQWf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 17:35:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234174AbiKQWfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 17:35:34 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D847F13E35
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 14:35:33 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id jn7so1096267plb.13
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 14:35:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ABjDdrp70mWEwGd143QYXmyVvo4wL46Q8gGoARqo45Y=;
        b=NKxbuJw7Gxm38Y6hH8OzGWlBdSuPg13MEnDt2r/WJztjvIbF8A4Po5QBqvZto8GWOv
         G1zgp9viXVJ/Lsi0GTVdWbsiEe6gaj7IcEdnfDnCdEgdBJAKUasIMTya3SteN3mhuro7
         XhDQATnw7HKWu3rtYOfsD9i9K4CoQw6m9GUys=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ABjDdrp70mWEwGd143QYXmyVvo4wL46Q8gGoARqo45Y=;
        b=Yo0sqEBLy682Hjf9ZR3ZaTqFpaJYj/jTP4VHeTInipMjryu3fW0+Pl5OXbPpyadl1g
         9nAGittDyBIeB7y5/u+l+aIY94SqxeamN1qkbOCDnfUS+gici8CfxlQosCSI+TKDZys7
         FYMBVWPPtSwVDGuAJfVNvmtlwHCJZKYKjWW3ymdEjVNYnqr9qtp162cF+H+gOhj53EJI
         2Rz9MPXn8z+jpjSC+MX4CDbFw6aFI8eIBg1ctxnEu9Y2g6R4MKNk5SgNI43dRe4Jaz/0
         Q/rsRPQd76hQZmfGkIOYlYr9n4LSc68Wp/mdBe6A5JCqVhAQ+dkfjeu90RchbMDcrBtO
         6bHA==
X-Gm-Message-State: ANoB5pkvvS4e/CRFuDxKGChBTN36lUvtR4Bx9YphK/zcSSdrnLY45H+v
        TIVxBDlsmMly+N1wDB6MSbsyQA==
X-Google-Smtp-Source: AA0mqf4/q+L7EH0uH+MJ7vZW1XsLypum3yDXuWvd25VSL2AcCtRFeGfW/lFpRJ0MmG64uWII/3dQrw==
X-Received: by 2002:a17:902:e2d3:b0:187:2430:d37d with SMTP id l19-20020a170902e2d300b001872430d37dmr4738345plc.28.1668724533394;
        Thu, 17 Nov 2022 14:35:33 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id q12-20020a17090311cc00b001888cadf8f6sm1992162plh.49.2022.11.17.14.35.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 14:35:32 -0800 (PST)
Date:   Thu, 17 Nov 2022 14:35:32 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH net-next v2] netlink: split up copies in the ack
 construction
Message-ID: <202211171431.6C8675E2@keescook>
References: <20221114090614.2bfeb81c@kernel.org>
 <202211161444.04F3EDEB@keescook>
 <202211161454.D5FA4ED44@keescook>
 <202211161502.142D146@keescook>
 <1e97660d-32ff-c0cc-951b-5beda6283571@embeddedor.com>
 <20221116170526.752c304b@kernel.org>
 <1b373b08-988d-b870-d363-814f8083157c@embeddedor.com>
 <20221116221306.5a4bd5f8@kernel.org>
 <20221117082556.37b8028f@hermes.local>
 <20221117123615.41d9c71a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117123615.41d9c71a@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 12:36:15PM -0800, Jakub Kicinski wrote:
> On Thu, 17 Nov 2022 08:25:56 -0800 Stephen Hemminger wrote:
> > > I was asking based on your own commit 1e6e9d0f4859 ("uapi: revert
> > > flexible-array conversions"). This is uAPI as well.  
> >  
> > Some of the flex-array conversions fixed build warnings that occur in
> > iproute2 when using Gcc 12 or later.
> 
> Alright, this is getting complicated. I'll post a patch to fix 
> the issue I've added and gently place my head back into the sand.

Thanks! I think the path forward is clear. I should not have suggested
adding a flex-array member to the "header" struct lo these many moons
ago. You and Gustavo are right: we need a separate struct with the header
at the beginning, just as iproute2 is doing itself.

As for testing, I can do that if you want -- the goal was to make sure
the final result doesn't trip FORTIFY when built with -fstrict-flex-arrays
(not yet in a released compiler version, but present in both GCC and Clang
truck builds) and with __builtin_dynamic_object_size() enabled (which
is not yet in -next, as it is waiting on the last of ksize() clean-ups).

-- 
Kees Cook
