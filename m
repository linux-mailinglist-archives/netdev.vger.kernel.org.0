Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D270552D2ED
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 14:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238066AbiESMtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 08:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235483AbiESMtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 08:49:04 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8EB5B41C6
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 05:49:02 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id m1so4599920qkn.10
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 05:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZYNVM4/IO7V0fYNlQI5NvKWUT/yRQDy6ZvaTZbyqfac=;
        b=mJWbE0QEIqGVvxszguDCXk6HwPAW7vSyy5sd3KThi4tH55htbFfVr/pC0ToJ9Wjpa1
         NMmJnnauuKYVCnsnAXjrwKHeXhHl8ZPuLdHTFaFsHnnnmZs/DR1fBs0GWnkicU365rSs
         MDd0k6/yu9md8zAjjRbTMI3qMGHSL2wGEXHcaHNOhg7ATegQxyCdQWMpnJjS9kEMrpsw
         qAf5/l3VqY4vD1G5EoG5q0Ppuy/F+LqgJQy7AHg2mM4GxpxngJov49ELqlDU312VZzAS
         x0NZG6iAjVCyxWGkBA/EzzSF3qXZiUBc5CNglAFiNWxAi2Te8oEllwRgTQe+Qirgs8yO
         AkHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZYNVM4/IO7V0fYNlQI5NvKWUT/yRQDy6ZvaTZbyqfac=;
        b=0ntp+8QqTNpTPoJa6nw9HSXdE42olqR2iuIOs8HndvgqgBusuwAM64lS4fvzR/6o7K
         vSX9BCaAcdnWW/EDECZjjABicSjzgbxuYJ5zcKrzVKuivybS9gZa2AbBIXCyQn8FYiVy
         yJcEfUICTI3yaMuLVOeViMg0FWYR/fLKfK5lxQkNnK6o3O9IK1hvFzH+9b5wK8pyMw2g
         YuG71qWyeT3zPvZtSMjVNPQ+g1nSRlqfiWwbTwPwFqYtmBhPKbP+cOgz914NOODLMG0v
         oZ0yVCrwbS28im7w2aKBnw2yLXw/hpRU+PUgUltQAC0nZIKx7lMle1HtIxBBXDNxR3iw
         7pEA==
X-Gm-Message-State: AOAM5339JZEbN5mfkZv3hOe29aGn55NdkcYPAzHa2ReOJvjS8EAKW6HJ
        H73TIILpnyyl3GSe5XDsdJBQMA==
X-Google-Smtp-Source: ABdhPJwC7dyR0Qk9BGcWgMtmzQUq9wbfQt5NmHbKY9nEqa9QgAxBxse0MPnEsgUdrJlcKLQUc1t5uA==
X-Received: by 2002:a37:6883:0:b0:6a3:42ae:e17b with SMTP id d125-20020a376883000000b006a342aee17bmr524511qkc.59.1652964542542;
        Thu, 19 May 2022 05:49:02 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id p7-20020a37a607000000b0069fc13ce24dsm1250439qke.126.2022.05.19.05.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 05:49:01 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1nrfaO-008vEJ-VD; Thu, 19 May 2022 09:49:00 -0300
Date:   Thu, 19 May 2022 09:49:00 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Long Li <longli@microsoft.com>
Cc:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Message-ID: <20220519124900.GR63055@ziepe.ca>
References: <1652778276-2986-1-git-send-email-longli@linuxonhyperv.com>
 <1652778276-2986-13-git-send-email-longli@linuxonhyperv.com>
 <20220517152409.GJ63055@ziepe.ca>
 <PH7PR21MB326393A3D6BF619C2A7B4A42CED09@PH7PR21MB3263.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR21MB326393A3D6BF619C2A7B4A42CED09@PH7PR21MB3263.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 05:57:01AM +0000, Long Li wrote:

> > > +
> > > +	err = ib_copy_from_udata(&ucmd, udata, min(sizeof(ucmd),
> > > +udata->inlen));
> > 
> > Skeptical this min is correct, many other drivers get this wrong.
> 
> I think this is correct. This is to prevent user-mode passing more data that may overrun the kernel buffer.

And what happens when udata->inlen is, say, 0?
 
> > > +	// map to the page indexed by ucontext->doorbell
> > 
> > Not kernel style, be sure to run checkpatch and fix the egregious things.
> > 
> > > +static void mana_ib_disassociate_ucontext(struct ib_ucontext
> > > +*ibcontext) { }
> > 
> > Does this driver actually support disassociate? Don't define this function if it
> > doesn't.
> > 
> > I didn't see any mmap zapping so I guess it doesn't.
> 
> The user-mode deals with zapping.
> I see the following comments on rdma_umap_priv_init():
> 
> /* RDMA drivers supporting disassociation must have their user space designed
>  * to cope in some way with their IO pages going to the zero page. */
> 
> Is there any other additional work for the kernel driver to support
> disassociate? It seems uverbs_user_mmap_disassociate() has done all
> the zapping when destroying a ucontext.

Nope, that looks OK then
 
> I will open PR to rdma-core. The current version of the driver
> supports queue pair type IB_QPT_RAW_PACKET. The test case will be
> limited to querying device and load/unload. Running traffic tests
> will require DPDK (or other user-mode program making use of
> IB_QPT_RAW_PACKET).
> 
> Is it acceptable to develop test cases for this driver without
> traffic/data tests?

I'm not keen on that, even EFA was able to do simple traffic.

Even with RAW_PACKET I would expect the driver to be able to send/recv
using standard verbs as RAW_PACKET is a common feature.

Jason
