Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63C44577645
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 14:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbiGQM5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 08:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiGQM5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 08:57:24 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3BD813CF0;
        Sun, 17 Jul 2022 05:57:23 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id b11so16763163eju.10;
        Sun, 17 Jul 2022 05:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2gmtNIUUpvopJUec+O7hhUT0Dno5h9V+8LiFQ4qDF9o=;
        b=k4SKpSa3N3YVNVsGETrFqgc7O1Gei21+1Bl7GKznWtW7g/CY4lqGhIVu0U8vhpPzQz
         Plh+/nM/rqhALQbZVIwSq16R4FXRKq1d+Yml3HubQr/QOkC5+adlVohA2mul6H6GMQHj
         sUrwalKo/99FfC/arjGzEpurzBOj5+/Hn2FszJYNlbrIlRKgT8yx6JX+Pgc9326oL/yg
         hq4wRuLrJiCpEsiQZmT0j4QBYzyQdwVveiB3U0qZZjqxie/GPYR4i8O13TTQbJT1GmOM
         UKxBmtPp2nRaBaKeS3tJ1ZOXUrVLNF77EnXNaSZeZbU64bNooizuYgajBY02YU37AQJI
         zxXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2gmtNIUUpvopJUec+O7hhUT0Dno5h9V+8LiFQ4qDF9o=;
        b=hmrasD0O4BLFJ/NfDb/14d8MS9OKmXGIPbTQL5CJajl96Dcy/j5aEy3d+Qalm4ujYZ
         q8pd65tkQkMW3attjOFHq/gOMeyq+/rmAFXCPXAljLTAZdoIv1N6nMjVOop/PJ0Ss3GA
         hTv+teeko8Tcl1h6vVXIKceo4MjbU3JpJ5zMxX2uldvtu4yA8HYF34jDNMb+q8wAwfR2
         PRtZY9nwGRM42tbmh8oMiCwvfjOlxhNPoqruf7OBPCdP6mEHpTstQj/mePj8AVlA7Tu3
         kUskKay7X0YNTp/Xx5GdO1sFEqoXE4HVuSkyVWV29KEUoS4WjkYsEeXQzkm1JP69NpK1
         kw5A==
X-Gm-Message-State: AJIora+jrrzyCS4Qum39TdSyTZvZZ1P8NFIx3N3kk5bAylSMzLWHQfgf
        ARy718c6ID7ugmW+bdi9sRDcH5qu3TY=
X-Google-Smtp-Source: AGRyM1s5dLQ9rJsisC51YqHpwFfp3KbcwuCasxvHsCLNpwLjQx6HndCuLJJNu1SVyevu2Z9pSZqboA==
X-Received: by 2002:a17:907:28c8:b0:72b:97cd:d628 with SMTP id en8-20020a17090728c800b0072b97cdd628mr21882592ejc.208.1658062642128;
        Sun, 17 Jul 2022 05:57:22 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id b6-20020aa7cd06000000b004355998ec1asm6559370edw.14.2022.07.17.05.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jul 2022 05:57:21 -0700 (PDT)
Date:   Sun, 17 Jul 2022 15:57:18 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@kapio-technology.com
Cc:     Ido Schimmel <idosch@nvidia.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
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
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 net-next 3/6] drivers: net: dsa: add locked fdb entry
 flag to drivers
Message-ID: <20220717125718.mj7b3j3jmltu6gm5@skbuf>
References: <20220708084904.33otb6x256huddps@skbuf>
 <e6f418705e19df370c8d644993aa9a6f@kapio-technology.com>
 <20220708091550.2qcu3tyqkhgiudjg@skbuf>
 <e3ea3c0d72c2417430e601a150c7f0dd@kapio-technology.com>
 <20220708115624.rrjzjtidlhcqczjv@skbuf>
 <723e2995314b41ff323272536ef27341@kapio-technology.com>
 <YsqPWK67U0+Iw2Ru@shredder>
 <d3f674dc6b4f92f2fda3601685c78ced@kapio-technology.com>
 <Ys69DiAwT0Md+6ai@shredder>
 <648ba6718813bf76e7b973150b73f028@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <648ba6718813bf76e7b973150b73f028@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 17, 2022 at 02:21:47PM +0200, netdev@kapio-technology.com wrote:
> On 2022-07-13 14:39, Ido Schimmel wrote:
> > On Wed, Jul 13, 2022 at 09:09:58AM +0200, netdev@kapio-technology.com
> > wrote:
> 
> > 
> > What are "Storm Prevention" and "zero-DPV" FDB entries?
> 
> They are both FDB entries that at the HW level drops all packets having a
> specific SA, thus using minimum resources.
> (thus the name "Storm Prevention" aka, protection against DOS attacks. We
> must remember that we operate with CPU based learning.)

DPV means Destination Port Vector, and an ATU entry with a DPV of 0
essentially means a FDB entry pointing nowhere, so it will drop the
packet. That's a slight problem with Hans' implementation, the bridge
thinks that the locked FDB entry belongs to port X, but in reality it
matches on all bridged ports (since it matches by FID). FID allocation
in mv88e6xxx is slightly strange, all VLAN-unaware bridge ports,
belonging to any bridge, share the same FID, so the FDB databases are
not exactly isolated from each other.
