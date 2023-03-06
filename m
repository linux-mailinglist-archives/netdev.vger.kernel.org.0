Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE98D6AD134
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 23:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbjCFWJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 17:09:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbjCFWJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 17:09:37 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040AD4D616
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 14:09:35 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id bd34so6869598pfb.3
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 14:09:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112; t=1678140575;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4FQv5I8b8c0Yhh9L0GuxNm1K+n9nP+qDzpUI4KcMXto=;
        b=gxgBFSDJo1Kd10sreCibZQZvhSj0TR+y1w/5nfbZCRYSDSQPjryfDWlObicl/bSLVQ
         Uxkq8UY/bg55sgvLWtg2+HJifm83/l2YdftJh0JjP/i+7kXhAYfIqoy17MtgHDCvwwfM
         0Iq6WT7DeO1WGsc6AGQg+tCS7Ewq11nXfCpRpvHQZA9TBhUMJz0RGrl2QARsqdqrjy89
         FwqsN7D+cK8SQd9/F3U71yS7XsAkJDhgR5ZY741xtPZTHATioeznUQBjUkgx4nidgvSx
         NmbWcPHq5REAKSrLXjtKQXLeIP8k/dttAmwR5ddzdS4h/8ApcFWQCUIVtgGGHbLSrhhL
         FaiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678140575;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4FQv5I8b8c0Yhh9L0GuxNm1K+n9nP+qDzpUI4KcMXto=;
        b=TQ+CrRdA2tlSjroIwLjZlQd/lgBPklHjlnGXgc3lyGkBVAbpSc/dTeIcAVhOiDTEP9
         lpWtkbP2fVm6Sys1kHDxqZ1+B8+tunBSjAYIcqw+NmJ4gMH4HyCJ85AnLG4re6YjYmjh
         jtxKxs6aucp2AJeyLSPXV0rQDWVNSictYResf55tS7KtAOFLDPdWkflDPHFYlDhr2huJ
         /6PIgfCpUTlMw+5IcUV9lQt1ukSOwm7WpVNJNAk+CEYug9D2fqkIa7JoADZuGWv/l/hR
         4scE6APkAup32nC0jUQ2Snp9/q7xaQws1qxDIZfUv7AhCZA1Y9FUG/SduIyu+0/4v8fA
         so9g==
X-Gm-Message-State: AO0yUKXnDvk7QrI00Q86Mzah1LR0sS0lrShgona1xSVsAfwMVPqxGVg1
        mg5ajkjwgeBAv4VG0R04demgSW6Sw1bOjsJRhoFO6w==
X-Google-Smtp-Source: AK7set9vWYcEwuO8pC7CO5cdEeYpJ5tp7tburzauZKetb6SkadV29+u6aNmw8l0QmphsgD/19EmURQ==
X-Received: by 2002:aa7:98c3:0:b0:5a8:e3dc:4337 with SMTP id e3-20020aa798c3000000b005a8e3dc4337mr12688135pfm.16.1678140575025;
        Mon, 06 Mar 2023 14:09:35 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id j18-20020aa78dd2000000b005d61829db4fsm6693113pfr.168.2023.03.06.14.09.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 14:09:34 -0800 (PST)
Date:   Mon, 6 Mar 2023 14:09:31 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Mike Freemon <mfreemon@cloudflare.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [RFC PATCH] Add a sysctl to allow TCP window shrinking in order
 to honor memory limits
Message-ID: <20230306140931.4c21d871@hermes.local>
In-Reply-To: <20230306213058.598516-1-mfreemon@cloudflare.com>
References: <20230306213058.598516-1-mfreemon@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  6 Mar 2023 15:30:58 -0600
Mike Freemon <mfreemon@cloudflare.com> wrote:

> +		if (net->ipv4.sysctl_tcp_shrink_window) {
> +			if (free_space < (1 << tp->rx_opt.rcv_wscale))
> +				return 0;
> +		}

Please combine if clauses with &&
