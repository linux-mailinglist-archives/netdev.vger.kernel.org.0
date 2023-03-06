Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C484A6AD129
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 23:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbjCFWIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 17:08:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjCFWIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 17:08:16 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2A528854
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 14:08:15 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id h11-20020a17090a2ecb00b00237c740335cso10074858pjs.3
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 14:08:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112; t=1678140495;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZdjNV87cxSkGCCuxqxx32JPjVG/7VfVasFbIpj9Fvdo=;
        b=K8+oQRQmCdhmLpnEb+hCUiQ63uCpROLRfnTv65gzLXeRkViKOM1m3eU7JWuITKYK5I
         fJMg0ulxMMjAW0xAMAosvZ2xWG4NUYEoEXTSLnSWB7+UFvvrZjD3QB18ykZxLCcVGE0W
         ds6RiZ9TiTOu0ieI7IDNN/3wAlW/L2r6ILSfGqZnxc74j/3HV/kje1G4BDddZxEBGWas
         wIPO7H5LSEjMlWo5UXoEp+R9EtBdbpA2IoB4JrrvAja9kpwvSA/WvPtjHRWxtm73S73t
         oZeqQcU1KEFIIFz1z5vXPQNORVL9WBT4AJHU/il0VTFpIhAp32arDbvZvo1qdFb1kdi0
         qMgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678140495;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZdjNV87cxSkGCCuxqxx32JPjVG/7VfVasFbIpj9Fvdo=;
        b=lwBPEoQIe1ReBEPSki35hG/mYOkI5Cq3FcHeeiGb/QoUTUHEG1OaRbNonKI2dybmBR
         4faBxKLvgxkQopQCH/ELWprYsdKKrymvQ851gtD1xeabkSag4pQLzMp0c2iCHs5pnXpU
         1ol+Jk9GC1TKXHaCAiaogxL8qWQgvajhTDkqun2m90upKBvdfNzZdojaTRy3hZJuQiFu
         f+z4j1O9AThF+vpl9DzGTfrMgDvJW19sw1sNBNDXGSEMeuWWBSlPDlaUYWlx692TS28J
         WCpSkmFY1g1j+wt6I6aV0EMX3B6sW6Fn45ooGONqcmTOFJGe+rOyYRi4YC+FFkAYo64c
         o2Gw==
X-Gm-Message-State: AO0yUKWvBcAeiaautSXFmTpJnzaCfaBBDFXNtaiXJbvN9bhZ92pbhIgQ
        LZW346bCoDi8wjSVKNLHx8sFfHD69txzlCpaaIRuNA==
X-Google-Smtp-Source: AK7set+pJS2SspDRq5Fs0NBFdPvzZys2gsriNHACGkc8N58vCQO+4QEt/szQFs6+kdAgqRWjLtvRQw==
X-Received: by 2002:a17:903:41c3:b0:19e:699e:9b64 with SMTP id u3-20020a17090341c300b0019e699e9b64mr16462201ple.65.1678140495293;
        Mon, 06 Mar 2023 14:08:15 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id lc15-20020a170902fa8f00b0019eddc81b86sm216074plb.0.2023.03.06.14.08.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 14:08:15 -0800 (PST)
Date:   Mon, 6 Mar 2023 14:08:12 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Mike Freemon <mfreemon@cloudflare.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [RFC PATCH] Add a sysctl to allow TCP window shrinking in order
 to honor memory limits
Message-ID: <20230306140812.17f35658@hermes.local>
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

> +		 * RFC 7323, section 2.4, says there are instances when a retracted
> +		 * window can be offered, and that TCP implementations MUST ensure
> +		 * that they handle a shrinking window, as specified in RFC 1122.
> +		 *
> +		 * This patch implements that functionality, which is enabled by
> +		 * setting the following sysctl.
> +		 *
> +		 * sysctl: net.ipv4.tcp_shrink_window
> +		 *
> +		 * This sysctl changes how the TCP window is calculated.
> +		 *
> +		 * If sysctl tcp_shrink_window is zero (the default value), then the
> +		 * window is never shrunk.
> +		 *
> +		 * If sysctl tcp_shrink_window is non-zero, then the memory limit
> +		 * set by autotuning is honored.  This requires that the TCP window
> +		 * be shrunk ("retracted") as described in RFC 1122.
> +		 *
> +		 * For context and additional information about this patch, see the
> +		 * blog post at TODO

This comment should be reworded such that it can be read at a much
later date with out all the associated context described here.

I.e. Get rid of "this patch part" and the blog post part.

Best to just refer to tcp_shrink_window sysctl and put the details
in the regular documentation spot (Documentation/networking/ip-sysctl.rst).
