Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 220B04DB04B
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 14:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355987AbiCPNET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 09:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355929AbiCPNER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 09:04:17 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9CA55B9;
        Wed, 16 Mar 2022 06:03:00 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id b24so2601820edu.10;
        Wed, 16 Mar 2022 06:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8ZZlmqC5VFB+TpGNzx3hi7Wlj0HQtNbpALYNMUhypww=;
        b=nIgBjOLQD1J7QK6kKh4kQuZuvR0bB1+otQ7TZDdrnqTfUYfWIMdVfMIcC+ia9FYnEl
         fUD5UAEae9GmQjkitTfcBXsqeF8XkckgfF+k6esCH2FqSv1QhiY94QJLTI/ajXmcVzbN
         9s2oGAgYu5IJ7CkD265nYF8+WiusP4qqMH9zZYLg0v+kbIYPKHtaGXuZsO9BImtR16CZ
         HZn3hc6vsGf0z8GuqmhW/7UAE/bxoN5KGlod0MLxnIcXQhp/0wdJMn0S9loIjGUuZTqF
         l06zo9FUxvqHhLSN3Suk3R58+sRQL1zxvKN4VIZlPQ/HM4zrIiSaR8tuk+4/f6P8ORej
         YvZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8ZZlmqC5VFB+TpGNzx3hi7Wlj0HQtNbpALYNMUhypww=;
        b=Ae4njeb2Shdber+YF3O7X2CHjKbRVASdFw0YPisr2kjHIjRMx14pIeg5LqwfDgSPJE
         +D6BAKAZSVt7Tc8f3vvl6D/FKXs15ivatKx15nB5jieqyEeEce9PBBhI7zL0PrDfRZK9
         MByprsyIYDdkV5+i2MS0gTCjQISYuI/fvOaxdW8V+tyLGD0htRvRGxYSdT541KtGJm+K
         3FrOezKh588tKcgbqxrWD5ScmmlgmMkGQDqZKtI2clu437woNGPqSQnxTlhZ9kHjmVdg
         tPlFIQLr3BdcFJoe02DwGCL38DbG0nsZXaXTUcKPBKSVmkRRkW6s+1dqUqO11PE2adGm
         msBQ==
X-Gm-Message-State: AOAM5321uHFL5UfpJpJjfX975EzSmxIqHxCRzClLL1gvNSVlLEtpIRyn
        pwquDPnll5TK2tN0eQx8XYo=
X-Google-Smtp-Source: ABdhPJzDp8H7SW9lX38fWe1TT+2GmLDXpwQcg209L91LhbTch2/JUjZJFZVaK3BbcRAAtTdEmqeOQg==
X-Received: by 2002:aa7:cc82:0:b0:410:d2b0:1a07 with SMTP id p2-20020aa7cc82000000b00410d2b01a07mr30100562edt.359.1647435779143;
        Wed, 16 Mar 2022 06:02:59 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id k7-20020aa7c047000000b004132d3b60aasm931534edo.78.2022.03.16.06.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 06:02:58 -0700 (PDT)
Date:   Wed, 16 Mar 2022 15:02:56 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH v4 net-next 12/15] net: dsa: Handle MST state changes
Message-ID: <20220316130256.3hgbllxioz4igxen@skbuf>
References: <20220315002543.190587-1-tobias@waldekranz.com>
 <20220315002543.190587-13-tobias@waldekranz.com>
 <20220315164249.sjgi6wbdpgehc6m6@skbuf>
 <87zglqjkmk.fsf@waldekranz.com>
 <87wngujkdm.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wngujkdm.fsf@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 16, 2022 at 10:51:17AM +0100, Tobias Waldekranz wrote:
> > Question though:
> >
> >>> +			err = dsa_port_msti_fast_age(dp, state->msti);
> >
> > If _msti_fast_age returns an error here, do we want that to bubble up to
> > the bridge? It seems more important to keep the bridge in sync with the
> > hardware. I.e. the hardware state has already been successfully synced,
> > we just weren't able to flush all VLANs for some reason. We could revert
> > the state I guess, but what if that fails?
> >
> > Should we settle for a log message?
> 
> Or should we set the extack message? Similar to how we report software
> fallback of bridging/LAGs?

A warning extack and chug along sounds great. The worst that can happen
if flushing a VLAN's FDB fails is that the topology will reconverge slower.
