Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435A057CA36
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 14:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233428AbiGUMFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 08:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232969AbiGUMFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 08:05:07 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF23275;
        Thu, 21 Jul 2022 05:05:05 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id v12so1848305edc.10;
        Thu, 21 Jul 2022 05:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hIRt+5psI0fBlG5c+/n/fiysz1qxRkLBoG/4SrkuiJE=;
        b=BydaKhLBRJp/iFzlps/w0ZfZuBS13oz1Ki8ce73VFVSQ6ccbqnmDkqzWL0VtZkitXs
         0RJYQEvWSAhg8BqpEvOOamDiStCjLC/ap9H1jJ1MGsJvT6B4XsOx06wONHzbha5m/ti+
         OgG8QPt+bqnTQq1BO/7l8t4FOeE06spuZy7zEo7wxDrf3JH5r3hHNco4PYXzf7mLI4xo
         G2DLu348tvSB46WOk01bqLu+V95p9/iF27DE1UUGSjW8+HQQT7megPPKwRGShoDxE6tp
         k2HaStBJYxL/pMtg+yNkMKIIxcapAjD3gSuCp9xRv6vkPqIlUZyRm2IOBae59CQCioai
         OkRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hIRt+5psI0fBlG5c+/n/fiysz1qxRkLBoG/4SrkuiJE=;
        b=luwjz/9KUvN+zPU4bDwlef9FK3fXZiR20iaOqVJfh6ftibZzBHaFlrjfqvMTs4GqSM
         El+28SskBcrrAfab7lp3jw//KpkNXsC7IHOr5GeEmx/SL8YGfEpGTJtGqgRJgJcY/dcf
         U0aBf1vhSYenxkDZ7HNiGWCXIb40lalU/AMTbwzSFJxoMtj7BJ9+JnU9bFlin7jzy6YQ
         6ZqsP1E2j7453Fadq2ETdF5ATRNx46QTF3W6Qgm20tI6PvbbO1NrIhyIpxpOBkjuaLGv
         PyykjgNUVfTxmrIBl7NgKv8BpSjV0q0FITnNTaS5w/Tpo3msdWbwTOtKERUDGhtYb8f7
         b6Tg==
X-Gm-Message-State: AJIora+tVLPY2M8faMyvHtgV2HQzc6940r9yipsQjLpuzOu6N3GdqgT/
        CfWS0IzfJegHTeJCMZkI1Ps=
X-Google-Smtp-Source: AGRyM1u86Jc71UcjZn1r3mvoQuqtJZrsDnH+UAYVN0SB5I9lwYjOKEs+fAzJCcEJFejXlVzpoGOeEw==
X-Received: by 2002:a05:6402:484:b0:43b:6e02:71af with SMTP id k4-20020a056402048400b0043b6e0271afmr22964119edv.176.1658405103949;
        Thu, 21 Jul 2022 05:05:03 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id e11-20020a056402148b00b0043a43fcde13sm897574edv.13.2022.07.21.05.05.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 05:05:02 -0700 (PDT)
Date:   Thu, 21 Jul 2022 15:04:59 +0300
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
Subject: Re: [PATCH v4 net-next 5/6] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Message-ID: <20220721120459.x6mm4coeoe4ecjfv@skbuf>
References: <20220707152930.1789437-1-netdev@kapio-technology.com>
 <20220707152930.1789437-6-netdev@kapio-technology.com>
 <20220717004725.ngix64ou2mz566is@skbuf>
 <3918e3d1a8b78dedc14b950ba1eee8d5@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3918e3d1a8b78dedc14b950ba1eee8d5@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 17, 2022 at 02:34:22PM +0200, netdev@kapio-technology.com wrote:
> > If I were to randomly guess at almost 4AM in the morning, it has to do with
> > "bridge fdb add" rather than the "bridge fdb replace" that's used for
> > the MAB selftest. The fact I pointed out a few revisions ago, that MAB
> > needs to be opt-in, is now coming back to bite us. Since it's not
> > opt-in, the mv88e6xxx driver always creates locked FDB entries, and when
> > we try to "bridge fdb add", the kernel says "hey, the FDB entry is
> > already there!". Is that it?
> 
> Yes, that sounds like a reasonable explanation, as it adds 'ext learned,
> offloaded' entries. If you try and replace the 'add' with 'replace' in those
> tests, does it work?

Well, you have access to the selftests too... But yes, that is the
reason, and it works when I change 'add' to 'replace', although of
course this isn't the correct solution.

> > As for how to opt into MAB. Hmm. MAB seems to be essentially CPU
> > assisted learning, which creates locked FDB entries. I wonder whether we
> > should reconsider the position that address learning makes no sense on
> > locked ports, and say that "+locked -learning" means no MAB, and
> > "+locked +learning" means MAB? This would make a bunch of things more
> > natural to handle in the kernel, and would also give us the opt-in we
> > need.
> 
> I have done the one and then the other. We need to have some final decision
> on this point. And remember that this gave rise to an extra patch to fix
> link-local learning if learning is turned on on a locked port, which
> resulted in the decision to allways have learning off on locked ports.

I think part of the reason for the back-and-forth was not making a very
clear distinction between basic 802.1X using hostapd, and MAB. While I
agree hostapd doesn't have what to do with learning, for MAB I'm still
wondering. It's the same situation for mv88e6xxx's Port Association
Vector in fact.

> > Side note, the VTU and ATU member violation printks annoy me so badly.
> > They aren't stating something super useful and they're a DoS attack
> > vector in itself, even if they're rate limited. I wonder whether we
> > could just turn the prints into a set of ethtool counters and call it a
> > day?
> 
> Sounds like a good idea to me. :-)

Thinking this through, what we really want is trace points here,
otherwise we'd lose information about which MAC address/VID/FID was it
that caused the violation.
