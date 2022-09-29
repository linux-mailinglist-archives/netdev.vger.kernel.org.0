Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85AFA5EF6AF
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 15:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbiI2NeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 09:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233587AbiI2NeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 09:34:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F0A137464
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 06:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664458460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rlftdk2hTC+j/otuOrlxim4c/Udb5r6B+3NxPu2X4c8=;
        b=Qj6Dd8ITHT4Aegqfw7+VFIEivQfzdKQUPJGWI1VvtPST+L6jR7BGl9YAbp07RkEz0pSAXL
        vYB2xtE/Zk2L1bliJ3rZS1LZGI+bfICW6CyBU6vno0+RZMy31h6GqWcVh60+WOOFTvGWOX
        04LqIt807nwrxUi06duY9pqDPuh4mS0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-624-f3FlRMkXNb2tVgJSN1B7fQ-1; Thu, 29 Sep 2022 09:34:19 -0400
X-MC-Unique: f3FlRMkXNb2tVgJSN1B7fQ-1
Received: by mail-wr1-f69.google.com with SMTP id p7-20020adfba87000000b0022cc6f805b1so543772wrg.21
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 06:34:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=rlftdk2hTC+j/otuOrlxim4c/Udb5r6B+3NxPu2X4c8=;
        b=SkWlyCBSLH+cuJvpIBC8O0dUGr23nLm6cjokjSZ+3JOZDUAdnQXcCggpWbwtZV7kKh
         LEe77jtXe+vepyYiPrX//a0op1CE9JIK0l3n7I10ozEeUXtf2QJWqsjLZ0XiVuplHcNY
         K/7L+ka8OyT9v22FKJklwRfLUEuvIdoBw9oZx1wBPmb5ZBo22nIiwKJVALV3C7LgDJy/
         Z8HW50MxKVdho6VF9uENhYdOVJEj77h2onCdqgTCt4xgAgE16gdo4pQT35iNMkQa7oBH
         mDIagAq1kQFybeVyjW5D7sBEfy2Ps+4hvOlZWEwbKO87EBZ/33YsN36xb40A2+P54gcR
         Wp9g==
X-Gm-Message-State: ACrzQf0qQf957bLtUhdmNV6swpozy4ur6WKNUfZfwPvmw04o6oPsvQ/j
        ZVK2UkZKLIQVLRALeL3FciICZ75V+R+rGDCho1Ijvv+BFdP1BiYWcKi7mgCszt7dNL40Z3EavEx
        ThM/pTyYmPJ3VPwbw
X-Received: by 2002:a7b:c047:0:b0:3b4:adc7:1ecb with SMTP id u7-20020a7bc047000000b003b4adc71ecbmr2381494wmc.144.1664458457898;
        Thu, 29 Sep 2022 06:34:17 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7g3+/13oJtIk6NXj7j85h1BWgvBBXBz91Zb26yCGbshBNMrmY+Zd8Fz4y2SGNJh+4ZxKRZhA==
X-Received: by 2002:a7b:c047:0:b0:3b4:adc7:1ecb with SMTP id u7-20020a7bc047000000b003b4adc71ecbmr2381475wmc.144.1664458457692;
        Thu, 29 Sep 2022 06:34:17 -0700 (PDT)
Received: from localhost.localdomain ([92.62.32.42])
        by smtp.gmail.com with ESMTPSA id n14-20020a5d420e000000b0022cc895cc11sm3968487wrq.104.2022.09.29.06.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 06:34:16 -0700 (PDT)
Date:   Thu, 29 Sep 2022 15:34:13 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, robh@kernel.org, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, stephen@networkplumber.org, sdf@google.com,
        f.fainelli@gmail.com, fw@strlen.de, linux-doc@vger.kernel.org,
        razor@blackwall.org, nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next 1/6] docs: add more netlink docs (incl. spec
 docs)
Message-ID: <20220929133413.GA6761@localhost.localdomain>
References: <20220929011122.1139374-1-kuba@kernel.org>
 <20220929011122.1139374-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929011122.1139374-2-kuba@kernel.org>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 28, 2022 at 06:11:17PM -0700, Jakub Kicinski wrote:
> +Answer requests
> +---------------
> +
> +Older families do not reply to all of the commands, especially NEW / ADD
> +commands. User only gets information whether the operation succeeded or
> +not via the ACK. Try to find useful data to return. Once the command is
> +added whether it replies with a full message or only an ACK is uAPI and
> +cannot be changed. It's better to err on the side of replying.
> +
> +Specifically NEW and ADD commands should reply with information identifying
> +the created object such as the allocated object's ID.
> +
> +Having to rely on ``NLM_F_ECHO`` is a hack, not a valid design.
> +
> +NLM_F_ECHO
> +----------
> +
> +Make sure to pass the request info to genl_notify() to allow ``NLM_F_ECHO``
> +to take effect.

Do you mean that netlink commands should properly handle NLM_F_ECHO,
although they should also design their API so that users don't need it?

