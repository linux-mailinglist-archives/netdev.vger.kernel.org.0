Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40FFF4B2D05
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 19:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344254AbiBKSfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 13:35:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240176AbiBKSfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 13:35:18 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1028184
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 10:35:16 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id t36so6926041pfg.0
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 10:35:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Law23MJZOOc1DSHm8VR9H3GrGJ66ArnHrnubRrOHPvQ=;
        b=grWpmNuAVAUNtXU+FnSt5b2Kn8aHJGFT1lR4959Vnw252ve2fpXQdIQ1kKb9yyPsmj
         RjwZFCQyZEfz6QZrdvPykM7QMkILoVaMcB3I/reCjgwP9ibSX7Rm7jSqLK5ev4mBzMuX
         LCSgqiAf3O/nFQXdLbc2KnG1uDsUmHvcBXlfO4Zn8Tn5wy0P7uls6AEoTgzK9sDmPHD9
         F5Ru1rSopIiSU2odYtukvpeanVTE+A1xa52+MDJIDAYT/wdFBHTOnnvJdoE2GeK4uKnO
         NAtawK9G852cwmGmHkER95Fx7y6Q8lNaY0Gk97hPCF7lNfns17Bt3Nrv76Y2ko6BydCW
         Fpwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Law23MJZOOc1DSHm8VR9H3GrGJ66ArnHrnubRrOHPvQ=;
        b=6Nf2QCfIOQINzErvbrrqtzG/7v1WAnbaMqWp39QIIGWPv9v4DJZrQ44530q8WoGhy/
         jPr8jQ+P771SeAWvfw+1c8T16USlUieU476vs3CbSL66emKgnqrzk7jI3u5R79ib0Kvz
         DcIZuXvTh5OTAmTFNFJH/GKTdTJKJap41EsBOMvB2Tqh5LIyQa3qriU6dbwPyjlI1jHm
         62r/BLKXJclrp6qbTnmZ0TLGYLsWHi3v2tiYnEXTTQAeKQ5nEKM3Xs16rDdLm2pE1z3W
         Z9DRfbeprmE/rPUohpAPn57G+/6YhBRDBxhqfrbimzE0sdn3qnCbxvxKAlL6JFxfjAXQ
         Oxzg==
X-Gm-Message-State: AOAM530OYmmc9gBb/nACa4VDwPT58xRCH7Qwg6w+9lfBaXl85QU4S++M
        GSUS5y70gsZzbw4cuHHo6PgKHfiCkGzU79cu
X-Google-Smtp-Source: ABdhPJz9XjGGUoTT/A2yzk9UDf0bjt//XEvmMyyYGB/gObDSgPewX+GURAnz6BGO+twFLqCsJYmNjg==
X-Received: by 2002:a05:6a00:1a16:: with SMTP id g22mr2987950pfv.81.1644604516227;
        Fri, 11 Feb 2022 10:35:16 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id g19sm9738509pfc.109.2022.02.11.10.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 10:35:15 -0800 (PST)
Date:   Fri, 11 Feb 2022 10:35:13 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Maxim Petrov <mmrmaximuzz@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] libnetlink: fix socket leak in
 rtnl_open_byproto()
Message-ID: <20220211103513.2ebc5615@hermes.local>
In-Reply-To: <8da15fe8-92be-ee9c-0c45-1a4af38fc9bd@gmail.com>
References: <20220210171903.66f35b6c@hermes.local>
        <8da15fe8-92be-ee9c-0c45-1a4af38fc9bd@gmail.com>
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

On Fri, 11 Feb 2022 21:30:11 +0300
Maxim Petrov <mmrmaximuzz@gmail.com> wrote:

> Hello Stephen!
> 
> On 2022-02-11 01:19 UTC, Stephen Hemminger wrote:
> > +	} else {
> > +		rth->seq = time(NULL);
> > +		return 0;
> >  	}  
> 
> For me it looks slightly alien as the normal flow jumps from one 'else if' to
> another, and the final return statement is hidden inside the else block. The
> original version is straightforward and less surprising.
> 
> > Can do the same thing without introducing a goto  
> But what's wrong with the goto here? I thought it is a perfectly legal C way to
> handle errors, and iproute2 uses it for that purpose almost everywhere.

Ok, either way. personal preference only.
