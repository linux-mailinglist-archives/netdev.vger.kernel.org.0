Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDD2F6F495C
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 19:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233823AbjEBR6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 13:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234369AbjEBR6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 13:58:24 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841BAAD
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 10:58:23 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-64115eef620so36661151b3a.1
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 10:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1683050303; x=1685642303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tiE1DWJVu6SR5fUQri2EkqUC06NuFzPAjn+VDe/bbX0=;
        b=a0zP5mMWN/KjUOhGaEfPf8s4GKxrE/biIQPS8edlBr0BnWsUKt+pKjQLHRdaP8j5PS
         VX1XEEGEg+HLO7JfJlt4fgOQ1fJk1MOLyVigx1xJSDwgvaBueNg889SV/9Qzf+8LuJ6q
         wO/tzIlmWSO/MjB35RBTm8IfWyJsq0GZAg0rpD053LEIVzybo4ES1xvQHznAI+XjtdXY
         Q7rT5Ovf8xYv5DjefiHXWQPZUjk7T0fMT7VpBU2nGTNTs+Cv1BD45hdyHmmgdd5gVNOM
         R1cHAMIn5BaDJdkMExyPI14x3Ab8tAjj283Bn3RgtSekq5QD5Bj1bsHgP2vbPxIyC3Pp
         CnrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683050303; x=1685642303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tiE1DWJVu6SR5fUQri2EkqUC06NuFzPAjn+VDe/bbX0=;
        b=iSZSdvlCs+UxHCy8WepHxrAoNQ9pWlXz3bc2jg1TPk9QTbDqqVCDA1IAXZN8NFsWjC
         2yay1U48VIKjBNU7FPiPJEHmmemANbxJIcQtXPXi6jrK9Dg6kyUpSs5q8g0DNOL6/jie
         re4tnuWJkZdhL9fhsowRMpWtv4PV1d6lQrxs/exeOpfIGYrLzkozrf8/0tAgqj7LCuw1
         +P9EosM69tPadE+JEc1dfMeWnLyM1NNAcBhDUThl3T6HbSBsnIhk/dnLGU4eNePUOgyE
         z6OjunIBD/JawvOReGa7Fs2U7xyRntKSnR7tPBgBa6xCAVFabtMYJDFu2AOMxyaEqMAJ
         m3vA==
X-Gm-Message-State: AC+VfDzLmr0eSKx+o38tKT7kDLXix7T80C9X8tbFdvHPHEWY9+ntTlM3
        RGIhL8En1VklEtnp4EAekSGIfA==
X-Google-Smtp-Source: ACHHUZ69sAcGtuvOJ3Hdq1uWU7dgus/z7Ditm8fZh+kuofxEiQ76vpCMTrCfqNdnQubuxw4bWhWcqg==
X-Received: by 2002:a05:6a20:72a6:b0:f2:817c:2038 with SMTP id o38-20020a056a2072a600b000f2817c2038mr22302768pzk.18.1683050302978;
        Tue, 02 May 2023 10:58:22 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id n12-20020a056a00212c00b0063f172b1c47sm20469544pfj.35.2023.05.02.10.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 10:58:22 -0700 (PDT)
Date:   Tue, 2 May 2023 10:58:20 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ganesh Babu <ganesh.babu@ekinops.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: mroute6.h: change type of mif6c_pifi to __u32
Message-ID: <20230502105820.2c27630d@hermes.local>
In-Reply-To: <20230502085718.0551a86d@kernel.org>
References: <PAZP264MB4064279CBAB0D7672726F4A1FC889@PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM>
        <20230328191456.43d2222e@kernel.org>
        <PAZP264MB406414BA18689729DDE24F3DFC659@PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM>
        <20230502085718.0551a86d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 May 2023 08:57:18 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Tue, 2 May 2023 08:07:10 +0000 Ganesh Babu wrote:
> > Thank you for your response. Regarding the proposed change to
> > the mif6ctl structure in mroute6.h, I would like to clarify,
> > that changing the datatype of mif6c_pifi from __u16 to __u32
> > will not change the offset of the structure members, which
> > means that the size of the structure remains the same and
> > the ABI remains compatible. Furthermore, ifindex is treated
> > as an integer in all the subsystems of the kernel and not
> > as a 16-bit value. Therefore, changing the datatype of
> > mif6c_pifi from __u16 to __u32 is a natural and expected
> > change that aligns with the existing practice in the kernel.
> > I understand that the mif6ctl structure is part of the uAPI
> > and changing its geometry is not allowed. However, in this
> > case, we are not changing the geometry of the structure,
> > as the size of the structure remains the same and the offset
> > of the structure members will not change. Thus, the proposed
> > change will not affect the ABI or the user API. Instead, it
> > will allow the kernel to handle 32-bit ifindex values without
> > any issues, which is essential for the smooth functioning of
> > the PIM6 protocol. I hope this explanation clarifies any
> > concerns you may have had. Let me know if you have any further
> > questions or need any more details.  
> 
> Please don't top post on the list.
> 
> How does the hole look on big endian? Does it occupy the low or 
> the high bytes?
> 
> There's also the problem of old user space possibly not initializing
> the hole, and passing in garbage.

Looks like multicast routing is one of the last places with no netlink
API, and only ioctl. There is no API to modify multicast routes in iproute2.

