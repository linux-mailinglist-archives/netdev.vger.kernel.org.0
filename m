Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E627B57C9F2
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 13:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbiGULvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 07:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiGULvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 07:51:24 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A9A2AC53;
        Thu, 21 Jul 2022 04:51:22 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id j22so2748438ejs.2;
        Thu, 21 Jul 2022 04:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GmDGNOSJLQLxHyqUbqdShMpk7Rg5vZOsES1osVYWvM8=;
        b=OGZ65YDJOY1TZJZnVZ0xSIYu44FSqV/GtlogNPVbdgVP4qeyYrQHHb6ra08gEteLzV
         Xza04ZqfmXuFmhOG2yubswI7rJYU6kah1KAk/PdYFcxZyIUiqrdeuYQK7JWkTWahv2Xx
         H+xG3OpXRv+ZsZ9rhioXX7uv2G6nrzfmTw7N3N0qOk9X/x9PqACbHtBuZasvnja9gYYF
         XGFgOoVVvydCpOFf0ll9jxiG+6G7lDcfGhK5m+DOx0uPlszpt/Sur2fiK2z/QmWdmkHp
         l+f6Bq9/k/W8I3XbHk5jPjUEsVz3hHt6datdIR1dhSigpWSaon9VR/EFMeMQbgLyiwqu
         SAzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GmDGNOSJLQLxHyqUbqdShMpk7Rg5vZOsES1osVYWvM8=;
        b=TkjgvM7cB30f4bxfCx8YOzMs4FtlwK6dTKKvKuFg6WAp7WasXVMo2KDwtnXFoIgnDt
         N1/D0td07rYb82m0PYTPFMbxHC/cYB4WMCp0IBrv8RnHNmr/VZJBqB85ZYTVrPWEnItZ
         L4SvcQas2RGd4Tdk9jinxv/i2eW/9rGU31GfHDL539fPkzEu7La7F0rD7VuTCWlOSF7m
         PhglL5JTgtjwgdHEq4KLxlnd+oLaRmEaYi1Y0exg8nGGOjSuUD0RQv8NHP9wMeP67Z1H
         jpWR/HV5yfEhC/5TXZT0rCdKjcsJ8Gw8gXtP4L3atL5hMmp0p0QusfYZX/5KCyU+KxbU
         dfcA==
X-Gm-Message-State: AJIora+V7wrsUQuD5kndzrAoyFVNrquWT1APco6nHKomnlFrCkQH1OuM
        /EnKGTD3Q/bL0JcvycNAJpU=
X-Google-Smtp-Source: AGRyM1suSHIrHuomtbcQyx39R4sEOccPsO0YKHzge8wgHA4N/CbmPmzndo1pH08PAhDMKhOryuKMBA==
X-Received: by 2002:a17:906:2086:b0:715:7983:a277 with SMTP id 6-20020a170906208600b007157983a277mr39840337ejq.386.1658404280576;
        Thu, 21 Jul 2022 04:51:20 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id 15-20020a170906328f00b006fee98045cdsm814224ejw.10.2022.07.21.04.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 04:51:19 -0700 (PDT)
Date:   Thu, 21 Jul 2022 14:51:16 +0300
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
Message-ID: <20220721115116.5avmhghbmbbprq23@skbuf>
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
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

Yes, but re-read my message about what "all the drivers" means.
