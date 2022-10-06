Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5415F66EB
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 14:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbiJFMyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 08:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231828AbiJFMxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 08:53:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516C0A5724
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 05:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665060674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Syg5zIWBvPOX0jJz9joJzjpsGxjICL72fZp42SQwfoM=;
        b=fM588Qk2Un9lYb+Boh+f9yFQI0rctrvLiiwEcSo/JI+UzzYAJPhAteYlJzxq4EtFerRWgV
        ddK7wwPL7qIwkqS0gWpYhDFQ+p0zrT4IqdVR9rPPOBTIMU6VQ8lpAYPJEM2J6MNEK38vhZ
        WZU6tk1r4A9Z/KzYibFq8idEFkB2/Ts=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-655-SbVPPnDwNumrzIv5AW5Y8A-1; Thu, 06 Oct 2022 08:51:13 -0400
X-MC-Unique: SbVPPnDwNumrzIv5AW5Y8A-1
Received: by mail-wr1-f71.google.com with SMTP id g27-20020adfa49b000000b0022cd5476cc7so491959wrb.17
        for <netdev@vger.kernel.org>; Thu, 06 Oct 2022 05:51:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Syg5zIWBvPOX0jJz9joJzjpsGxjICL72fZp42SQwfoM=;
        b=DwPqZwNQgFpwRK3Z0BmCUy0iOh9TwkWcCOzEWys1lnQYXZBmZaLPIgJR+ZbGK16iqc
         IGvIuVWYDBDAj5Xto5McXoqGrx7ha8i5zQLatsv3w2vViNZfx4gZHMf9xxq9jkY1ZNQW
         lK7oo47ecKw4CWYJv+uDQOFBpwKuPbZsEe9bnzDdWJBHHrblkDtSZUZ9qUopz9FQLd3u
         FRdd7UoGJxjMoMrfqRsbeaeqxuGf8o6gHPbfnKwS/8XuKc/T6VgGWFBCei36H9ZnzbNp
         E8X6mcq2Hj2CFDn0J2jPJUf90lsOq74Vgcnb1OQiPvwLWYWGvsMcEhxJE38TtTuDmccC
         KGFQ==
X-Gm-Message-State: ACrzQf1XNp2QTFDtLkFebGgq5ZyVuINrF7CRjduGJ69jdtLYaYiCmTxv
        XF/qrCVA5/H9yrfM6XgVSPI1xacI0cjvMDNdJmhcIEx6c5GkcbRl8ReGcFBbIt/JooNSCApBQ4R
        cu3ivvFHj9uQJOisH
X-Received: by 2002:a05:6000:982:b0:229:79e5:6a96 with SMTP id by2-20020a056000098200b0022979e56a96mr3013238wrb.469.1665060672555;
        Thu, 06 Oct 2022 05:51:12 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM58nCSs5milYBn+uz3POtf6SVmsGMBqz64i2N0S1T/ojkzi20QUFO80u17d3tCt4j0XzS5cUQ==
X-Received: by 2002:a05:6000:982:b0:229:79e5:6a96 with SMTP id by2-20020a056000098200b0022979e56a96mr3013230wrb.469.1665060672376;
        Thu, 06 Oct 2022 05:51:12 -0700 (PDT)
Received: from localhost.localdomain ([92.62.32.42])
        by smtp.gmail.com with ESMTPSA id p16-20020a05600c359000b003bdd2add8fcsm5095484wmq.24.2022.10.06.05.51.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 05:51:11 -0700 (PDT)
Date:   Thu, 6 Oct 2022 14:51:09 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, robh@kernel.org, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, stephen@networkplumber.org, sdf@google.com,
        f.fainelli@gmail.com, fw@strlen.de, linux-doc@vger.kernel.org,
        razor@blackwall.org, nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next v2 3/7] net: add basic C code generators for
 Netlink
Message-ID: <20221006125109.GE3328@localhost.localdomain>
References: <20220930023418.1346263-1-kuba@kernel.org>
 <20220930023418.1346263-4-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220930023418.1346263-4-kuba@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 07:34:14PM -0700, Jakub Kicinski wrote:
> Code generators to turn Netlink specs into C code.
> I'm definitely not proud of it.
> 
> The main generator is in Python, there's a bash script
> to regen all code-gen'ed files in tree after making
> spec changes.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> --
> v2: - use /* */ comments instead of //

Probably not a very interesting feedback, but there
are still many comments generated in the // style.

For example in this block:

> +    if args.mode == "kernel":
> +        if args.header:
> +            if parsed.kernel_policy == 'global':
> +                cw.p(f"// Global operation policy for {parsed.name}")
> +
> +                struct = Struct(parsed, parsed.global_policy_set, type_list=parsed.global_policy)
> +                print_req_policy_fwd(cw, struct)
> +                cw.nl()
> +
> +            for op_name, op in parsed.ops.items():
> +                if parsed.kernel_policy == 'per-op' and 'do' in op and 'event' not in op:
> +                    cw.p(f"// {op.enum_name} - do")
> +                    ri = RenderInfo(cw, parsed, args.mode, op, op_name, "do")
> +                    print_req_policy_fwd(cw, ri.struct['request'], op=op)
> +                    cw.nl()
> +
> +            print_kernel_op_table_fwd(parsed, cw)
> +        else:
> +            if parsed.kernel_policy == 'global':
> +                cw.p(f"// Global operation policy for {parsed.name}")
> +
> +                struct = Struct(parsed, parsed.global_policy_set, type_list=parsed.global_policy)
> +                print_req_policy(cw, struct)
> +                cw.nl()
> +
> +            for op_name, op in parsed.ops.items():
> +                if parsed.kernel_policy == 'per-op':
> +                    for op_mode in {'do', 'dump'}:
> +                        if op_mode in op and 'request' in op[op_mode]:
> +                            cw.p(f"// {op.enum_name} - {op_mode}")
> +                            ri = RenderInfo(cw, parsed, args.mode, op, op_name, op_mode)
> +                            print_req_policy(cw, ri.struct['request'], op=op)
> +                            cw.nl()
> +
> +            print_kernel_op_table(parsed, cw)

