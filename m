Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C137356B90C
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 13:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238157AbiGHL4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 07:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237909AbiGHL4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 07:56:30 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F2C9A6AA;
        Fri,  8 Jul 2022 04:56:29 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id d2so37368296ejy.1;
        Fri, 08 Jul 2022 04:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AG3Sm3NazJDBZSa/naVDAcI9egy0zTLjaKLWd6YOLPM=;
        b=iT2z7eTBAPBciEDO1xjz6EbYuR7iyR313S/TVdseEVTHd2GQMu/GurcYn7z8vAJGbl
         AueMvC/9KeZzWbXUQ/D7vnqLcpKUiuJsCPSVjs2WNiHnl4R//G/AKidZGjiKn3cb3rR6
         Ryeg9E/uIX4Y2xkJ1Rwx9DrUMWBZds6IHw2HsRA/1muEkSN2KO5TQH+L9Gz8oq0MAl4j
         jTKNmWAE4Nn66sOBYipmxMB2wPqr6mEv4NKyrxzAr7SDF7JazVXsa+0pqZ/LH3I18H6X
         ZSi+5QXc/LEJekr8nQ0BTilUq8qoLoYBFd7ivJQrBlRXEHuL08l7gRwhlyz86tf16xZV
         NBpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AG3Sm3NazJDBZSa/naVDAcI9egy0zTLjaKLWd6YOLPM=;
        b=jlNkzIyjOZpNTR0QO9za0JrKsq1NS67EunCZdb+P/hxV8ZBJTo+EJVYVBb80nSdOXt
         3fAL4N1jZu/yYEif6sR2ha5FxtwL43jCLIGGN7JwDcKyytzYf2c7m0RT8sstaKSYh+In
         6mh//m4273U2wQrsblYqC2F/2MZj/94Pjx8A2FVl5xfHsHy8XQyGtajUq4tHYzCRDrXV
         i7pRxC8zpySsf3j4C251zoFdbqpjmE9HW6v01khBn6QyU1bpZtO7xELMsTb5bkB5S73F
         DzBYfKhYXQsDVfQrUzup7jEMalbpgCWJ1JmCa9+wtsX0aLLONVOF9sMlKS8qUGfUVZ7p
         FabQ==
X-Gm-Message-State: AJIora81S6Bq4O/KP/GwmZvqBDaE+cyMwRMREQfnIBJ0XXPFjbn1tsHK
        S6K1MhElzo9LaImFB5un28w=
X-Google-Smtp-Source: AGRyM1t4dBzUEoo4AjYp4Cfpcy4Q9MRFHWXy4VzQ7Tgscb9ih1OqP7B9zSxpUwaP9YMpEzgWuUC/ww==
X-Received: by 2002:a17:907:1c8f:b0:6e8:f898:63bb with SMTP id nb15-20020a1709071c8f00b006e8f89863bbmr3248676ejc.721.1657281387546;
        Fri, 08 Jul 2022 04:56:27 -0700 (PDT)
Received: from skbuf ([188.25.231.143])
        by smtp.gmail.com with ESMTPSA id ec35-20020a0564020d6300b004316f94ec4esm30225678edb.66.2022.07.08.04.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 04:56:26 -0700 (PDT)
Date:   Fri, 8 Jul 2022 14:56:24 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@kapio-technology.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 net-next 3/6] drivers: net: dsa: add locked fdb entry
 flag to drivers
Message-ID: <20220708115624.rrjzjtidlhcqczjv@skbuf>
References: <20220707152930.1789437-1-netdev@kapio-technology.com>
 <20220707152930.1789437-4-netdev@kapio-technology.com>
 <20220708084904.33otb6x256huddps@skbuf>
 <e6f418705e19df370c8d644993aa9a6f@kapio-technology.com>
 <20220708091550.2qcu3tyqkhgiudjg@skbuf>
 <e3ea3c0d72c2417430e601a150c7f0dd@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3ea3c0d72c2417430e601a150c7f0dd@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 08, 2022 at 11:50:33AM +0200, netdev@kapio-technology.com wrote:
> On 2022-07-08 11:15, Vladimir Oltean wrote:
> > When the possibility for it to be true will exist, _all_ switchdev
> > drivers will need to be updated to ignore that (mlxsw, cpss, ocelot,
> > rocker, prestera, etc etc), not just DSA. And you don't need to
> > propagate the is_locked flag to all individual DSA sub-drivers when none
> > care about is_locked in the ADD_TO_DEVICE direction, you can just ignore
> > within DSA until needed otherwise.
> > 
> 
> Maybe I have it wrong, but I think that Ido requested me to send it to all
> the drivers, and have them ignore entries with is_locked=true ...

I don't think Ido requested you to ignore is_locked from all DSA
drivers, but instead from all switchdev drivers maybe. Quite different.

In any case I'm going to take a look at this patch set more closely and
run the selftest on my Marvell switch, but I can't do this today
unfortunately. I'll return with more comments.
