Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66CFD654AA4
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 03:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235783AbiLWCC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 21:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235604AbiLWCC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 21:02:26 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE151EAE0
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 18:02:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 01C26CE1B8B
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 02:02:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAFC8C433EF;
        Fri, 23 Dec 2022 02:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671760941;
        bh=X6JcGwUNJ1IlM0wpWVnbOtXHlhLno0Pi7KeQIIRMcIk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f+deVkcSYDWuI0Ii7Y81t9LU5NTXKOa87kGi0PNvCTmd/EyWVlAgxHV8MVAYk2sBQ
         7uQUx09jCuXWa56Hs7MVyDM8msxXzmtoiS7LAq/D+1FvRQHCeSEiCHHugNEh/psAE6
         xxOlCrWrIMKDH7M5QPPfb6VdeO2FTbmb60JoDS2On5VL5HzYfLtHgD7F8f9XWBZGfB
         BadkN03ajW5+83cs8/MWJKCp1GpGzY9Ppha8CCVA58kHOTZx8rF8z98MvohrWcL+Py
         otKOOZc4KvX8LvGIwk9wMRoiRcXzkdC62PCAK56dFI/RYoZgCKZpGZz2U0VzNAlSRx
         2OnYlxb7XQPxg==
Date:   Thu, 22 Dec 2022 18:02:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH ethtool-next v2 2/2] netlink: add netlink handler for
 get rss (-x)
Message-ID: <20221222180219.22b109c5@kernel.org>
In-Reply-To: <IA1PR11MB6266430ED759770807768D4EE4E89@IA1PR11MB6266.namprd11.prod.outlook.com>
References: <20221222001343.1220090-1-sudheer.mogilappagari@intel.com>
        <20221222001343.1220090-3-sudheer.mogilappagari@intel.com>
        <20221221172207.30127f4f@kernel.org>
        <IA1PR11MB6266430ED759770807768D4EE4E89@IA1PR11MB6266.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Dec 2022 22:57:19 +0000 Mogilappagari, Sudheer wrote:
> Will use "RSS hash-key' as key name and array. 

rss-hash-key ?

> Output in hex bytes like [ be,c3,13,... ] will be better
> I fell but it needs below changes. Without below changes
> output looks ["be", "c3", "13"...].  Will send out 
> v3 (with below changes as additional patch) unless there 
> is an objection. 

Hex would be great, but AFAIR JSON does not support hex :(
Imagine dealing with this in python, or bash. Do you really
want the values to be strings? They will have to get converted 
manually to integers. So I think just making them integers is
best, JSON is for machines not for looking at...

> +++ b/json_print.c
> void print_hex(enum output_type type, unsigned int hex)
>  {
>         if (_IS_JSON_CONTEXT(type)) {
> -               SPRINT_BUF(b1);
> -               snprintf(b1, sizeof(b1), "%x", hex);
>                 if (key)
> -                       jsonw_string_field(_jw, key, b1);
> +                       jsonw_xint_field(_jw, key, hex);
>                 else
> -                       jsonw_string(_jw, b1);
> +                       jsonw_xint(_jw, hex);
>         } else if (_IS_FP_CONTEXT(type)) {
>                 fprintf(stdout, fmt, hex);
>         }
