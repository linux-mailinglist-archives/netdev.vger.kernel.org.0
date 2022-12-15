Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA37464D7ED
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 09:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiLOIme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 03:42:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiLOImb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 03:42:31 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4FDF33C3F
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 00:42:30 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id x22so50539895ejs.11
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 00:42:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F5XX7OD1bjYm9YxNo3MVMy8A6RgOglbb8P9BDY7srbU=;
        b=6Um4rG1ehSPodJv4sVDwzFCtDKF/qWmAMpqnqqrGe1xi/hktjJp8iPBqXWIcR6J6Mg
         YnOnWRyLgyxGI9ticRwglV5nuonSrOlEIX1DBU+gZ+cxd9i8v33j+FJu8GLdg3ddGy5H
         VUalU8gfuwXZL9txT7QjGox+Zpd6CkinAKxIBS88V3pmRiTA5P0OQeVI/z8Madc8p6tW
         IEJFMAlAUwfjOkfg/bC6K9B6T2OtcmmyiGqiSn4+zmZLbuPyv8GRYvd4tRhcZOQV8l0e
         NOmlJ4jHPQj6Iu/bgUYyis0mlK5nO6yIihagfeDK88eK4sw4oKRpQhzcrdpiHmOXPP2y
         u81w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F5XX7OD1bjYm9YxNo3MVMy8A6RgOglbb8P9BDY7srbU=;
        b=vIDZIu7QH26u7FxKc4oIBkrhHhzBzSM9S1uhz7xdaE3TgEPLFaq3Lx7fcg6RLdQiwV
         g8DKKu0dZSunhN9n9etLPkVad0HYXW5KW73u6xcXiHPap1gBw2dAWzlvqZpp2lobThqM
         A1Prd04VYi5IMvHrB/Fa/Vc+jfQ9CYPiXKgiKiDNnume3y2FG5l9vIFUGWaug6gNGwEa
         qeJCElxnUZheIzApiwwpSspOVO7SVZq8/cI3bNIcUlrRUrC6a1dn6IdRAiG4/NtfHYJC
         vYEWXj878+apKCoeCq2VWlMgx6IIoQbDOteTuze0UrFvFhR2GarKcKvi+FJlZTsoaJGp
         C2Tw==
X-Gm-Message-State: ANoB5pkdGyyJ04GdIuwWkBNlq32HN2flUO0NOcRCE9ZmCprxSGwMPEEX
        zUHrNi5Te3UqELTFbwWXCQWifQ==
X-Google-Smtp-Source: AA0mqf6SeGTLFVTJ4d/l4MF6byQyjt6RVD4Ly6UUQ5zeCunV3jtB3kx4EXGdMnZXts0QRVqcR/3arQ==
X-Received: by 2002:a17:906:710:b0:7c0:f462:575a with SMTP id y16-20020a170906071000b007c0f462575amr22424488ejb.29.1671093749297;
        Thu, 15 Dec 2022 00:42:29 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id lu19-20020a170906fad300b007c0cbdfba04sm6716839ejb.70.2022.12.15.00.42.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 00:42:28 -0800 (PST)
Date:   Thu, 15 Dec 2022 09:42:27 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com, leon@kernel.org
Subject: Re: [RFC net-next 04/15] devlink: protect devlink dump by the
 instance lock
Message-ID: <Y5rd8xTN/2Loy8OR@nanopsycho>
References: <20221215020155.1619839-1-kuba@kernel.org>
 <20221215020155.1619839-5-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215020155.1619839-5-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Dec 15, 2022 at 03:01:44AM CET, kuba@kernel.org wrote:
>Take the instance lock around devlink_nl_fill() when the dumping.
>We are only dumping basic info so in the worst case we were only
>risking data races until now.
>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Should this be a separate patch targeted to -net with proper "fixes"
instead?
