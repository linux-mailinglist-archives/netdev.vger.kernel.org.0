Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3BF6DF9ED
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 17:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbjDLP0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 11:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjDLP0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 11:26:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83221A5
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 08:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681313142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qYKh8FdFO1QSNtMcyFw/EOs8sZAgGQFCkTPMptXscZI=;
        b=O7H9YWLw9CILJJuMftDwyrxKSLZG9un5jzQtgPP5016d/bj+hiafEo8zfeiFFhY+m6WVgJ
        m98nn6yn/Z4D3YEBBrgM/zwI+FKFK7cug4vtmDmhUDzyt16WDITAsg5NDYIUVsUMbbrYEe
        Vc55y2SsnCPIifMvi9mOSZ3w2fTOa4g=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-487-G_DrlDnwNV-7GyZlVDk58w-1; Wed, 12 Apr 2023 11:25:39 -0400
X-MC-Unique: G_DrlDnwNV-7GyZlVDk58w-1
Received: by mail-yb1-f200.google.com with SMTP id d188-20020a25cdc5000000b00b8f4698b4a7so1500049ybf.19
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 08:25:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681313139;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qYKh8FdFO1QSNtMcyFw/EOs8sZAgGQFCkTPMptXscZI=;
        b=sEFO9zWx54CdtmSn7ug3fb8sK4MWWV3M7kiuSK8LY0Vjz9fvWGWWQA9Af15PAOB8q+
         fJJ1OHtsr4X7ldndTBjse4/Dc3uTCnYISWDAwpEEfTl5Tr3Hzj82OoPQWSa8XH9ovTYv
         I0j+8kXokxlNNRr1BADNQeQHlX12xYaGNFmSvUcP4nzd7dssKdPXi3Hg4vUAaSbjevGO
         MhnXUlFlm+hl6hAB+N2QAdLfCtr+iPYyoBXiAv5jRHpakhGNt8v4L/VbVZgRtYT/hNiG
         gEZOFbPhWqRmr7iG1emzCyK2I/hK15EYtWAVO+uE8YbxOPFnuCRmyrsrPA1AINeJdFuN
         A3zg==
X-Gm-Message-State: AAQBX9dLXFw5/x4Ii3C0lI2R2YuCbNzrD/znJwdytXt515u15AEEQhfW
        mzkQy/EvIzNbzBdpdoRJ9il7jRIYBJpnBZKAyspOKGwsScrF3Q+l/wmbzLRuVfP0qT1ngJnHNPS
        2RKMecg8u2iYhJW5e
X-Received: by 2002:a0d:e543:0:b0:536:eace:3a77 with SMTP id o64-20020a0de543000000b00536eace3a77mr5537547ywe.40.1681313139014;
        Wed, 12 Apr 2023 08:25:39 -0700 (PDT)
X-Google-Smtp-Source: AKy350aQJ4oa7t3dVS8AqwS5Qn+O71awkukNvK/6B1mDWaGqRW2D1r9R25FsfDQKlgi+zts06ET0Cg==
X-Received: by 2002:a0d:e543:0:b0:536:eace:3a77 with SMTP id o64-20020a0de543000000b00536eace3a77mr5537524ywe.40.1681313138788;
        Wed, 12 Apr 2023 08:25:38 -0700 (PDT)
Received: from x1 (c-73-214-169-22.hsd1.pa.comcast.net. [73.214.169.22])
        by smtp.gmail.com with ESMTPSA id q63-20020a81b242000000b0054c0c9e4043sm4252004ywh.95.2023.04.12.08.25.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 08:25:38 -0700 (PDT)
Date:   Wed, 12 Apr 2023 11:25:36 -0400
From:   Brian Masney <bmasney@redhat.com>
To:     Andrew Halaney <ahalaney@redhat.com>
Cc:     linux-kernel@vger.kernel.org, agross@kernel.org,
        andersson@kernel.org, konrad.dybcio@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, mturquette@baylibre.com,
        sboyd@kernel.org, richardcochran@gmail.com,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-clk@vger.kernel.org, netdev@vger.kernel.org,
        echanude@redhat.com, ncai@quicinc.com, jsuraj@qti.qualcomm.com,
        hisunil@quicinc.com
Subject: Re: [PATCH v4 0/3] Add EMAC3 support for sa8540p-ride
 (devicetree/clk bits)
Message-ID: <ZDbNcDGIbJrm/x6L@x1>
References: <20230411202009.460650-1-ahalaney@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411202009.460650-1-ahalaney@redhat.com>
User-Agent: Mutt/2.2.7 (2022-08-07)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 03:20:06PM -0500, Andrew Halaney wrote:
> This is a forward port / upstream refactor of code delivered
> downstream by Qualcomm over at [0] to enable the DWMAC5 based
> implementation called EMAC3 on the sa8540p-ride dev board.
> 
> From what I can tell with the board schematic in hand,
> as well as the code delivered, the main changes needed are:
> 
>     1. A new address space layout for dwmac5/EMAC3 MTL/DMA regs
>     2. A new programming sequence required for the EMAC3 base platforms
> 
> This series addresses the devicetree and clock changes to support this
> hardware bringup.
> 
> As requested[1], it has been split up by compile deps / maintainer tree.
> The associated v4 of the netdev specific changes can be found at [2].
> Together, they result in the ethernet controller working for
> both controllers on this platform.

Looks good to me!

Tested-by: Brian Masney <bmasney@redhat.com>

